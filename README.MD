# treeignore.pl

`treeignore.pl` is a Perl script that generates a tree-like structure of a directory while respecting `.gitignore` patterns. The script can combine multiple `.gitignore` files and includes a default `.gitignore` if the `-d` flag is specified.

## Usage

### Running the Script

To generate the project tree:

```sh
perl treeignore.pl [directory] [options]
```

- `directory`: The starting directory for the project tree (defaults to the current directory if not specified).
- `options`: Additional options for the script.

### Options

- `--gitignore <file>`: Specify multiple `.gitignore` files to combine.
- `-d`: Include default `.gitignore` patterns (`*.log`, `*.tmp`, `*.bak`) if no `.gitignore` file is provided.

### Examples

1. Generate the tree for the current directory:

    ```sh
    perl treeignore.pl
    ```

2. Generate the tree for a specific directory:

    ```sh
    perl treeignore.pl /path/to/project
    ```

3. Use multiple `.gitignore` files:

    ```sh
    perl treeignore.pl /path/to/project --gitignore /path/to/project/.gitignore --gitignore /path/to/project/another.gitignore
    ```

4. Include default `.gitignore` patterns:

    ```sh
    perl treeignore.pl /path/to/project -d
    ```

## Testing

A test script `testtreeignore.pl` is provided to ensure the functionality of `treeignore.pl`. The tests cover various scenarios, including the use of multiple `.gitignore` files and the inclusion of default patterns.

### Running the Tests

To run the tests, use the following command:

```sh
perl testtreeignore.pl
```

### Test Coverage

- Ensure the script runs without errors.
- Verify the top-level directory is printed.
- Check that nested directories are printed.
- Confirm that files are printed.
- Validate that `.gitignore` patterns are respected.
- Test the inclusion of default `.gitignore` patterns with the `-d` flag.
- Ensure multiple `.gitignore` files can be combined.
- Confirm that default `.gitignore` patterns are not used if the `-d` flag is not provided.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please feel free to submit a pull request or open an issue for any bugs or feature requests.

## Acknowledgments

This project was developed to provide a simple way to visualize the structure of a project while respecting `.gitignore` rules.

### Instructions for the Users

1. **Download or clone the repository containing `treeignore.pl` and `testtreeignore.pl`.**
2. **Ensure you have Perl installed on your system.**
3. **Follow the instructions in the `README.md` file to run the script and the tests.**

By following these instructions, users will have a clear understanding of how to use and test the `treeignore.pl` script.
