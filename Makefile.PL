use ExtUtils::MakeMaker;
WriteMakefile(
	VERSION_FROM =>'lib/File/EmptyDirs.pm',
	NAME => 'File::EmptyDirs',
	PREREQ_PM => {
		'File::Find::Rule::DirectoryEmpty' => 0,
		'Smart::Comments' => 0,
	},
	
);
