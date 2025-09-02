#!/bin/bash

# === SETTINGS ===
GENOME_DIR="/Users/shemarstewart/Downloads/E.coli Project"
OUT_DIR="/Users/shemarstewart/Downloads/E.coli Project/mashtree_out"
mkdir -p "$OUT_DIR"

# === STEP 1: Create a genome list
find "$GENOME_DIR" -name "*.fasta" > "$OUT_DIR/genomes.txt"

# === STEP 2: Run mashtree
echo "🌲 Building phylogenetic tree with mashtree..."
mashtree --numcpus 8 --file "$OUT_DIR/genomes.txt" > "$OUT_DIR/tree.nwk"

echo "✅ Done!"
echo "Newick tree saved to: $OUT_DIR/tree.nwk"
