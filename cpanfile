requires 'Log::Minimal', 0.18;
requires 'perl', '5.008005';

on test => sub {
    requires 'Test::More', '0.98';
};

on configure => sub {
    requires 'Module::Build::Tiny', '0.035';
};
