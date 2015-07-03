# How to use?
1. Open the .pl file.
2. Customize the settings for your needs (section below `# settings` mark).
3. Run the script `perl LocalizedStringsCheck.pl`

If you are using shorthand macros like `#define Localize(text) NSLocalizedString (text, nil)` and similar, you should set the marcos name `Localize` in script settings:
```
my $NSLocalizedStringMacros = "Localize";
```

Please keep in mind that during the search for unlocalized strings, the script will ignore all occurrences of `@"Button title"`- strings in your project source files. It only looks for `NSLocalizedString(@"Button title", nil)`, that you forgot to localize in your `.strings` files. But if you are curious enough to look through all used strings, just set following setting in the script setting:
```
my $NSLocalizedStringMacros = "";
```
