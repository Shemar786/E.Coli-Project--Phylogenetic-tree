# 👬 E. coli Phylogenetic Tree Pipeline Using MashTree + FastTree + Python

This project builds a **whole-genome phylogenetic tree** from 625 *Escherichia coli* genomes using a **sketch-based distance method (MashTree)** followed by **FastTree**, with optional rerooting and visualization using Python.

> **NOTE:** Genome FASTA files are **not included** in this repository due to GitHub storage limits. Please see [data/README.md](data/README.md) for detailed instructions on how to download or structure your own `.fasta` files.

---

## 🧰 Why MashTree?

MashTree is a fast, alignment-free tool that approximates pairwise distances between genomes using **MinHash sketches**, making it ideal for large datasets like the 625 *E. coli* genomes in this study.

I originally attempted to install MashTree with:

```bash
cpanm --install Mashtree
```

However, this failed due to environment and dependency conflicts on macOS. As a result, I switched to using a stable Docker image: `staphb/mashtree`, which allowed the pipeline to work reliably across systems.

### Advantages over Alignment-based Tools

* ✅ Faster and more scalable than Parsnp or Clustal for hundreds of genomes
* ✅ Requires no full-genome alignments
* ✅ Produces a valid Newick tree that can be used in downstream tools

---

## 🚀 Pipeline Overview

### Step 1: Build the Tree with Docker (MashTree)

```bash
docker run --rm --platform=linux/amd64 \
  -v "/path/to/Ecoli_clean":/data \
  -v "/path/to/mashtree_out":/out \
  staphb/mashtree:latest \
  bash -c "mashtree \$(find /data -name '*.fasta') > /out/tree.nwk"
```

This performs:

* MinHash sketching of all `.fasta` files
* Pairwise distance calculation
* Tree construction with FastTree
* Newick-format tree saved to `tree.nwk`

> Tip: The file names (e.g., `1..fasta`, `2..fasta`) become the leaf names in the tree.

---


### iTOL Visualization

The `tree_rooted.nwk` can be uploaded to [iTOL](https://itol.embl.de/).  
Annotations can be added using `results/itol_annotations.txt`.  
An example iTOL export is included in `docs/E.COLI_Shemar_Stewart.pdf`.
---

## 📂 Repository Structure

```
mash-tree-pipeline/
├── mash_tree_pipeline.sh         # Bash script to run tree pipeline
├── reroot_tree.py                # Python script to reroot the tree
├── build_tree_paperstyle.py      # Python visualization script
├── results/
│   ├── tree.nwk                  # Raw tree from MashTree
│   ├── tree_rooted.nwk           # Rerooted version
│   └── fig_circular_ST_rooted.png # Optional PNG figure
├── data/
│   └── README.md                 # How to structure your .fasta files
├── alt_parsnp_pipeline/
│   └── build_tree_parsnp.py      # Optional Parsnp alignment script
```

---

## 📅 Input Data: FASTA Files

The original dataset contains 625 `.fasta` files named like:

```
1..fasta
2..fasta
...
625..fasta
```

These represent complete or draft genome assemblies for different *E. coli* strains.

**Not included due to size limits.** Follow `data/README.md` to:

* Download from NCBI, Enterobase, etc.
* Validate file lengths
* Maintain consistent naming

---

## 💪 Alternative: Parsnp-based Alignment

The repo includes an optional alignment-based pipeline using Parsnp:

```bash
python3 build_tree_parsnp.py
```

Parsnp aligns core genomes and builds a tree. It may skip short genomes:

```
ERROR - File /data/531..fasta is 1.20x shorter than reference genome! Skipping...
```

Use this method if you need core-genome alignment instead of sketching.

---

## ✅ Summary of Key Commands

### Run Mashtree with Docker:

```bash
docker run --rm --platform=linux/amd64 \
  -v /your/data:/data -v /your/output:/out \
  staphb/mashtree:latest \
  bash -c "mashtree \$(find /data -name '*.fasta') > /out/tree.nwk"
```

### Reroot the Tree:

```bash
python3 reroot_tree.py
```

### Visualize Tree:

```bash
python3 build_tree_paperstyle.py --fastadir data/ecoli_genomes --tree results/tree_rooted.nwk --out results/fig_circular_ST_rooted.png --threads 8
```

---

## 👨‍💼 Author

**Shemar Stewart**


## 🤔 References

* Ondov et al. (2016) [Mash: fast genome and metagenome distance estimation](https://doi.org/10.1038/nbt.3442)
* Katz et al. [Mashtree GitHub](https://github.com/lskatz/mashtree)
* Price et al. (2009) [FastTree: computing large minimum evolution trees](https://doi.org/10.1371/journal.pone.0009490)

```
```

