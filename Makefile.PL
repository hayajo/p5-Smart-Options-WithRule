use inc::Module::Install;
use Module::Install::Repository;
name 'Smart-Options-WithRule';
all_from 'lib/Smart/Options/WithRule.pm';

requires 'Smart::Options';
requires 'Data::Validator';
requires 'Data::Clone';

tests 't/*.t';

test_requires 'Test::More';

auto_set_repository;
auto_include;
WriteAll;
