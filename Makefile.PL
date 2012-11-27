use inc::Module::Install;
use Module::Install::Repository;
use Module::Install::ReadmePodFromPod;
name 'Smart-Options-WithRule';
all_from 'lib/Smart/Options/WithRule.pm';
readme_pod_from 'lib/Smart/Options/WithRule.pm';

requires 'Smart::Options';
requires 'Data::Validator';
requires 'Data::Clone';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';

auto_set_repository;
auto_include;
WriteAll;
