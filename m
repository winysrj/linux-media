Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41409 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755318AbcGHNEE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jul 2016 09:04:04 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: corbet@lwn.net, markus.heiser@darmarIT.de,
	linux-doc@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 29/54] doc-rst: add parse-headers.pl script
Date: Fri,  8 Jul 2016 10:03:21 -0300
Message-Id: <dabf8be33bbd8675d44925de7428d3fa86f1d6f3.1467981855.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
References: <cover.1467981855.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
References: <cover.1467981855.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This script parses a header file and converts it into a
parsed-literal block, creating references for ioctls,
defines, typedefs, enums and structs.

It also allow an external file to modify the rules, in
order to fix the expressions.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/sphinx/parse-headers.pl | 290 ++++++++++++++++++++++++++++++++++
 1 file changed, 290 insertions(+)
 create mode 100755 Documentation/sphinx/parse-headers.pl

diff --git a/Documentation/sphinx/parse-headers.pl b/Documentation/sphinx/parse-headers.pl
new file mode 100755
index 000000000000..287f6459e13a
--- /dev/null
+++ b/Documentation/sphinx/parse-headers.pl
@@ -0,0 +1,290 @@
+#!/usr/bin/perl
+use strict;
+use Text::Tabs;
+
+# Uncomment if debug is needed
+#use Data::Dumper;
+
+# change to 1 to generate some debug prints
+my $debug = 0;
+
+if (scalar @ARGV < 2 || scalar @ARGV > 3) {
+	die "Usage:\n\t$0 <file in> <file out> [<exceptions file>]\n";
+}
+
+my ($file_in, $file_out, $file_exceptions) = @ARGV;
+
+my $data;
+my %ioctls;
+my %defines;
+my %typedefs;
+my %enums;
+my %enum_symbols;
+my %structs;
+
+#
+# read the file and get identifiers
+#
+
+my $is_enum = 0;
+open IN, $file_in or die "Can't open $file_in";
+while (<IN>) {
+	$data .= $_;
+
+	if ($is_enum && m/^\s*([^\s\}\,\=]+)\s*[\,=]?/) {
+		my $s = $1;
+		my $n = $1;
+		$n =~ tr/A-Z/a-z/;
+		$n =~ tr/_/-/;
+
+		$enum_symbols{$s} = $n;
+
+		$is_enum = 0 if ($is_enum && m/\}/);
+		next;
+	}
+	$is_enum = 0 if ($is_enum && m/\}/);
+
+	if (m/^\s*#\s*define\s+([_A-Z]\S+)\s+_IO/) {
+		my $s = $1;
+		my $n = $1;
+		$n =~ tr/A-Z/a-z/;
+
+		$ioctls{$s} = $n;
+		next;
+	}
+
+	if (m/^\s*#\s*define\s+([_A-Z]\S+)\s+/) {
+		my $s = $1;
+		my $n = $1;
+		$n =~ tr/A-Z/a-z/;
+		$n =~ tr/_/-/;
+
+		$defines{$s} = $n;
+		next;
+	}
+
+	if (m/^\s*typedef\s+.*\s+([_\w]\S+);/) {
+		my $s = $1;
+		my $n = $1;
+		$n =~ tr/A-Z/a-z/;
+		$n =~ tr/_/-/;
+
+		$typedefs{$s} = $n;
+		next;
+	}
+	if (m/^\s*enum\s+(\S+)\s+\{/ || m/^\s*enum\s+(\S+)$/) {
+		my $s = $1;
+		my $n = $1;
+		$n =~ tr/A-Z/a-z/;
+		$n =~ tr/_/-/;
+
+		$enums{$s} = $n;
+
+		$is_enum = $1;
+		next;
+	}
+	if (m/^\s*struct\s+([_A-Za-z_]\S+)\s+\{/ || m/^\s*struct\s+([A-Za-z_]\S+)$/) {
+		my $s = $1;
+		my $n = $1;
+		$n =~ tr/A-Z/a-z/;
+		$n =~ tr/_/-/;
+
+		$structs{$s} = $n;
+		next;
+	}
+}
+close IN;
+
+#
+# Handle multi-line typedefs
+#
+
+my @matches = $data =~ m/typedef\s+struct\s+\S+\s*\{[^\}]+\}\s*(\S+)\s*\;/g;
+foreach my $m (@matches) {
+		my $s = $1;
+		my $n = $1;
+		$n =~ tr/A-Z/a-z/;
+		$n =~ tr/_/-/;
+
+		$typedefs{$s} = $n;
+	next;
+}
+
+#
+# Handle exceptions, if any
+#
+
+if ($file_exceptions) {
+	open IN, $file_exceptions or die "Can't read $file_exceptions";
+	while (<IN>) {
+		next if (m/^\s*$/ || m/^\s*#/);
+
+		# Parsers to ignore a symbol
+
+		if (m/^ignore\s+ioctl\s+(\S+)/) {
+			delete $ioctls{$1} if (exists($ioctls{$1}));
+			next;
+		}
+		if (m/^ignore\s+define\s+(\S+)/) {
+			delete $defines{$1} if (exists($defines{$1}));
+			next;
+		}
+		if (m/^ignore\s+typedef\s+(\S+)/) {
+			delete $typedefs{$1} if (exists($typedefs{$1}));
+			next;
+		}
+		if (m/^ignore\s+enum\s+(\S+)/) {
+			delete $enums{$1} if (exists($enums{$1}));
+			next;
+		}
+		if (m/^ignore\s+struct\s+(\S+)/) {
+			delete $structs{$1} if (exists($structs{$1}));
+			next;
+		}
+
+		# Parsers to replace a symbol
+
+		if (m/^replace\s+ioctl\s+(\S+)\s+(\S+)/) {
+			$ioctls{$1} = $2 if (exists($ioctls{$1}));
+			next;
+		}
+		if (m/^replace\s+define\s+(\S+)\s+(\S+)/) {
+			$defines{$1} = $2 if (exists($defines{$1}));
+			next;
+		}
+		if (m/^replace\s+typedef\s+(\S+)\s+(\S+)/) {
+			$typedefs{$1} = $2 if (exists($typedefs{$1}));
+			next;
+		}
+		if (m/^replace\s+enum\s+(\S+)\s+(\S+)/) {
+			$enums{$1} = $2 if (exists($enums{$1}));
+			next;
+		}
+		if (m/^replace\s+symbol\s+(\S+)\s+(\S+)/) {
+			$enum_symbols{$1} = $2 if (exists($enum_symbols{$1}));
+			next;
+		}
+		if (m/^replace\s+struct\s+(\S+)\s+(\S+)/) {
+			$structs{$1} = $2 if (exists($structs{$1}));
+			next;
+		}
+
+		die "Can't parse $file_exceptions: $_";
+	}
+}
+
+if ($debug) {
+	print Data::Dumper->Dump([\%ioctls], [qw(*ioctls)]) if (%ioctls);
+	print Data::Dumper->Dump([\%typedefs], [qw(*typedefs)]) if (%typedefs);
+	print Data::Dumper->Dump([\%enums], [qw(*enums)]) if (%enums);
+	print Data::Dumper->Dump([\%structs], [qw(*structs)]) if (%structs);
+	print Data::Dumper->Dump([\%defines], [qw(*defines)]) if (%defines);
+	print Data::Dumper->Dump([\%enum_symbols], [qw(*enum_symbols)]) if (%enum_symbols);
+}
+
+#
+# Align block
+#
+$data = expand($data);
+$data = "    " . $data;
+$data =~ s/\n/\n    /g;
+$data =~ s/\n\s+$/\n/g;
+$data =~ s/\n\s+\n/\n\n/g;
+
+#
+# Add escape codes for special characters
+#
+$data =~ s,([\_\`\*\<\>\&\\\\:\/]),\\$1,g;
+
+#
+# Add references
+#
+
+my $separators = "[\n \t\,\)\=\:\{\}\;]";
+
+foreach my $r (keys %ioctls) {
+	my $n = $ioctls{$r};
+
+	my $s = ":ref:`$r <$n>`";
+
+	$r =~ s,([\_\`\*\<\>\&\\\\:\/]),\\\\$1,g;
+
+	print "$r -> $s\n" if ($debug);
+
+	$data =~ s/([\s])($r)($separators)/$1$s$3/g;
+}
+
+foreach my $r (keys %defines) {
+	my $n = $defines{$r};
+
+	my $s = ":ref:`$r <$n>`";
+
+	$r =~ s,([\_\`\*\<\>\&\\\\:\/]),\\\\$1,g;
+
+	print "$r -> $s\n" if ($debug);
+
+	$data =~ s/([\s])($r)($separators)/$1$s$3/g;
+}
+
+foreach my $r (keys %enum_symbols) {
+	my $n = $enum_symbols{$r};
+
+	my $s = ":ref:`$r <$n>`";
+
+	$r =~ s,([\_\`\*\<\>\&\\\\:\/]),\\\\$1,g;
+
+	print "$r -> $s\n" if ($debug);
+
+	$data =~ s/([\s])($r)($separators)/$1$s$3/g;
+}
+
+foreach my $r (keys %enums) {
+	my $n = $enums{$r};
+
+	my $s = ":ref:`enum $r <$n>`";
+
+	$r =~ s,([\_\`\*\<\>\&\\\\:\/]),\\\\$1,g;
+
+	print "$r -> $s\n" if ($debug);
+
+	$data =~ s/enum\s+($r)($separators)/$s$2/g;
+}
+
+foreach my $r (keys %structs) {
+	my $n = $structs{$r};
+
+	my $s = ":ref:`struct $r <$n>`";
+
+	$r =~ s,([\_\`\*\<\>\&\\\\:\/]),\\\\$1,g;
+
+	print "$r -> $s\n" if ($debug);
+
+	$data =~ s/struct\s+($r)($separators)/$s$2/g;
+}
+
+foreach my $r (keys %typedefs) {
+	my $n = $typedefs{$r};
+
+	my $s = ":ref:`$r <$n>`";
+
+	$r =~ s,([\_\`\*\<\>\&\\\\:\/]),\\\\$1,g;
+
+	print "$r -> $s\n" if ($debug);
+
+	$data =~ s/([\s\(\,\=])($r)($separators)/$1$s$3/g;
+}
+
+#
+# Generate output file
+#
+
+my $title = $file_in;
+$title =~ s,.*/,,;
+
+open OUT, "> $file_out" or die "Can't open $file_out";
+print OUT ".. -*- coding: utf-8; mode: rst -*-\n\n";
+print OUT "$title\n";
+print OUT "=" x length($title);
+print OUT "\n\n.. parsed-literal::\n\n";
+print OUT $data;
+close OUT;
-- 
2.7.4

