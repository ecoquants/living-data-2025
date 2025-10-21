#!/usr/bin/env python3
"""
Extract abstracts from Living Data 2025 Program PDF and create JSON file.
"""

import re
import json
import sys
from pathlib import Path

try:
    import pdfplumber
except ImportError:
    print("Error: pdfplumber not installed. Run: pip install pdfplumber")
    sys.exit(1)

def extract_abstracts_from_pdf(pdf_path):
    """Extract abstracts from PDF file."""
    abstracts = {}

    with pdfplumber.open(pdf_path) as pdf:
        full_text = ""
        print(f"Processing {len(pdf.pages)} pages...")

        # Extract all text from PDF
        for i, page in enumerate(pdf.pages, 1):
            if i % 10 == 0:
                print(f"  Page {i}/{len(pdf.pages)}...")
            text = page.extract_text()
            if text:
                full_text += text + "\n"

        # Try to find abstracts by ID pattern
        # Looking for patterns like "ID: 7021007" or "Abstract ID: 7021007" or just "7021007"
        # followed by title, authors, and abstract text

        # Split into potential abstract sections
        # Common patterns in conference programs:
        # - Abstract ID or presentation ID
        # - Title (often in caps or bold)
        # - Authors with affiliations
        # - Abstract text

        # Try multiple patterns to find abstracts
        patterns = [
            # Pattern 1: ID followed by content until next ID or end
            r'(?:ID|Abstract|Presentation)[\s:]*(\d{7})\s*\n(.*?)(?=(?:ID|Abstract|Presentation)[\s:]*\d{7}|$)',
            # Pattern 2: Just 7-digit numbers as IDs
            r'(\d{7})\s*\n([A-Z].{20,}?)(?=\d{7}|$)',
        ]

        found_count = 0
        for pattern_idx, pattern in enumerate(patterns):
            matches = re.finditer(pattern, full_text, re.DOTALL | re.MULTILINE)
            matches_list = list(matches)

            if matches_list:
                print(f"\nPattern {pattern_idx + 1} found {len(matches_list)} potential matches")

                for match in matches_list:
                    abstract_id = match.group(1)
                    content = match.group(2).strip()

                    # Clean up the content
                    content = re.sub(r'\s+', ' ', content)

                    # Only keep if content is substantial (more than 50 chars)
                    if len(content) > 50:
                        abstracts[abstract_id] = {
                            "id": abstract_id,
                            "abstract": content[:1000],  # Limit to first 1000 chars
                            "full_text": content
                        }
                        found_count += 1

                if found_count > 0:
                    print(f"Successfully extracted {found_count} abstracts")
                    break

        # If no abstracts found with patterns, try a different approach
        # Look for the abstract IDs we have in the CSV and extract surrounding text
        if not abstracts:
            print("\nNo abstracts found with automatic patterns. Trying manual extraction...")
            # This would require reading the CSV and looking for each ID in the text
            # For now, just extract all text blocks

            # Split by double newlines or page breaks
            blocks = re.split(r'\n\n+', full_text)
            print(f"Found {len(blocks)} text blocks in PDF")

            # Try to identify blocks that contain abstracts
            for block in blocks:
                # Look for 7-digit numbers in the block
                id_match = re.search(r'\b(\d{7})\b', block)
                if id_match and len(block) > 100:
                    abstract_id = id_match.group(1)
                    clean_block = re.sub(r'\s+', ' ', block).strip()

                    if abstract_id not in abstracts:
                        abstracts[abstract_id] = {
                            "id": abstract_id,
                            "abstract": clean_block[:500],
                            "full_text": clean_block
                        }

    return abstracts

def main():
    pdf_path = Path("Living_Data_2025_Program.pdf")
    output_path = Path("living_data_abstracts.json")

    if not pdf_path.exists():
        print(f"Error: PDF file not found: {pdf_path}")
        sys.exit(1)

    print("Extracting abstracts from PDF...")
    abstracts = extract_abstracts_from_pdf(pdf_path)

    if abstracts:
        print(f"\nWriting {len(abstracts)} abstracts to {output_path}...")
        with open(output_path, 'w', encoding='utf-8') as f:
            json.dump(abstracts, f, indent=2, ensure_ascii=False)
        print(f"Successfully created {output_path}")

        # Show sample
        sample_ids = list(abstracts.keys())[:3]
        print(f"\nSample abstracts (IDs: {', '.join(sample_ids)}):")
        for aid in sample_ids:
            print(f"\n  ID {aid}:")
            print(f"  {abstracts[aid]['abstract'][:200]}...")
    else:
        print("\nWarning: No abstracts were extracted from the PDF.")
        print("The PDF may have a different format than expected.")
        print("Please check the PDF structure manually.")

if __name__ == "__main__":
    main()
