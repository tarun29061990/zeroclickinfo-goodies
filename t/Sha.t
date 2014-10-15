#!/usr/bin/env perl

use utf8;
use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'sha';
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::Sha )],
    'sha password' => test_zci(
        '5baa61e4c9b93f3f0682250b6cf8331b7ee68fd8',
        structured_answer => {
            input     => ['password'],
            operation => 'hex SHA-1 hash',
            result    => '5baa61e4c9b93f3f0682250b6cf8331b7ee68fd8'
        }
    ),
    'sha512 base64 password' => test_zci(
        'sQnzu7wkTrgkQZF+0G1hi5AI3Qmzvv0bXgc5THBqi7mAsdd4Xll27ASbRt9fEyavWi6m0QP9B8lThf+rDKy8hg',
        structured_answer => {
            input     => ['password'],
            operation => 'base64 SHA-512 hash',
            result    => 'sQnzu7wkTrgkQZF+0G1hi5AI3Qmzvv0bXgc5THBqi7mAsdd4Xll27ASbRt9fEyavWi6m0QP9B8lThf+rDKy8hg'
        }
    ),
    'sha-224 hex password' => test_zci(
        'd63dc919e201d7bc4c825630d2cf25fdc93d4b2f0d46706d29038d01',
        structured_answer => {
            input     => ['password'],
            operation => 'hex SHA-224 hash',
            result    => 'd63dc919e201d7bc4c825630d2cf25fdc93d4b2f0d46706d29038d01'
        }
    ),
    'sha-224sum password' => test_zci(
        'd63dc919e201d7bc4c825630d2cf25fdc93d4b2f0d46706d29038d01',
        structured_answer => {
            input     => ['password'],
            operation => 'hex SHA-224 hash',
            result    => 'd63dc919e201d7bc4c825630d2cf25fdc93d4b2f0d46706d29038d01'
        }
    ),
    # Example queries
    'SHA this' => test_zci(
        'c2543fff3bfa6f144c2f06a7de6cd10c0b650cae',
        structured_answer => {
            input     => ['this'],
            operation => 'hex SHA-1 hash',
            result    => 'c2543fff3bfa6f144c2f06a7de6cd10c0b650cae'
        }
    ),
    'sha-512 that' => test_zci(
        '10a47406ff35a59c42fbf94624f25f2dd4c265bcd4072d81ecbd39a9c3b5b82cad7a0abbda36102e203c84dfd329e23cee61b67afbe3cebb4cb0153786219fef',
        structured_answer => {
            input     => ['that'],
            operation => 'hex SHA-512 hash',
            result =>
              '10a47406ff35a59c42fbf94624f25f2dd4c265bcd4072d81ecbd39a9c3b5b82cad7a0abbda36102e203c84dfd329e23cee61b67afbe3cebb4cb0153786219fef'
        }
    ),
    'sha512sum dim-dims' => test_zci(
        '1dac010aead021b60fa0e4556ed0c8a8481bcd559e98bc7606543b5045c9c89dea19d26524096363236f85887f798d1f22e3b9f508e25f67de0ec275d91b2bdb',
        structured_answer => {
            input     => ['dim-dims'],
            operation => 'hex SHA-512 hash',
            result =>
              '1dac010aead021b60fa0e4556ed0c8a8481bcd559e98bc7606543b5045c9c89dea19d26524096363236f85887f798d1f22e3b9f508e25f67de0ec275d91b2bdb'
        }
    ),
);

done_testing;
