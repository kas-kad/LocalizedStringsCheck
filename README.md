# LocalizedStringsCheck
Perl script that checks all localized strings from your xcode project directory and prints out those of them that you should pay attention to.


# How to use?
1. Open the .pl file.
2. Customize the settings for your needs.
3. Run the script `perl LocalizedStringsCheck.pl`


Please keep in mind that during the search for unlocalized strings, the script will ignore all occurrences `@"Button title"`- strings from your project source files. It only looks for `NSLocalizedString(@"Button title", nil)`, that you forgot to localize in your .strings files.

If you are using shorthand macros like `#define Localize(text) NSLocalizedString (text, nil)` and similar, you should set the marcos name `Localize` in script settings.
