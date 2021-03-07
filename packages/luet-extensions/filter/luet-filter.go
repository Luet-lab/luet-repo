package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"os"
)

type Package struct {
	Repository     string
	Name, Category string
	Version        string
	Files          []string
}

type Doc struct {
	Packages []Package
}

func duplicates(d Doc) bool {
	files := map[string][]Package{}

	for _, p := range d.Packages {
		for _, e := range p.Files {
			files[e] = append(files[e], p)
		}
	}
	found := false
	for f, pp := range files {
		if len(pp) > 1 {
			found = true
			fmt.Printf("Duplicate found for %s in", f)
			for _, entry := range pp {
				fmt.Printf(" %s/%s", entry.Category, entry.Name)
			}
			fmt.Printf("\n")
		}
	}
	return found
}

func main() {
	var d Doc
	str, _ := ioutil.ReadAll(os.Stdin)
	json.Unmarshal([]byte(str), &d)

	found := duplicates(d)
	if found {
		os.Exit(1)
	}
}
