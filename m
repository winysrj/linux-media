Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43775 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941739AbcIHMES (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2016 08:04:18 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Markus Heiser <markus.heiser@darmarit.de>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 03/47] docs-rst: parse-headers.pl: use the C domain for cross-references
Date: Thu,  8 Sep 2016 09:03:25 -0300
Message-Id: <a92032faa103f062cbd07900cbbc31584c5c67be.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473334905.git.mchehab@s-opensource.com>
References: <cover.1473334905.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of keep using the normal reference, move to the C
domain ones. Using C domains everywhere will allow
cross-references between kAPI and uAPI docs.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/sphinx/parse-headers.pl | 113 ++++++++++++++++++----------------
 1 file changed, 59 insertions(+), 54 deletions(-)

diff --git a/Documentation/sphinx/parse-headers.pl b/Documentation/sphinx/parse-headers.pl
index 531c710fc73f..db0186a7618f 100755
--- a/Documentation/sphinx/parse-headers.pl
+++ b/Documentation/sphinx/parse-headers.pl
@@ -57,7 +57,7 @@ while (<IN>) {
 		$n =~ tr/A-Z/a-z/;
 		$n =~ tr/_/-/;
 
-		$enum_symbols{$s} = $n;
+		$enum_symbols{$s} =  "\\ :ref:`$s <$n>`\\ ";
 
 		$is_enum = 0 if ($is_enum && m/\}/);
 		next;
@@ -69,7 +69,7 @@ while (<IN>) {
 		my $n = $1;
 		$n =~ tr/A-Z/a-z/;
 
-		$ioctls{$s} = $n;
+		$ioctls{$s} = "\\ :ref:`$s <$n>`\\ ";
 		next;
 	}
 
@@ -79,17 +79,15 @@ while (<IN>) {
 		$n =~ tr/A-Z/a-z/;
 		$n =~ tr/_/-/;
 
-		$defines{$s} = $n;
+		$defines{$s} = "\\ :ref:`$s <$n>`\\ ";
 		next;
 	}
 
-	if ($ln =~ m/^\s*typedef\s+.*\s+([_\w][\w\d_]+);/) {
-		my $s = $1;
-		my $n = $1;
-		$n =~ tr/A-Z/a-z/;
-		$n =~ tr/_/-/;
+	if ($ln =~ m/^\s*typedef\s+([_\w][\w\d_]+)\s+(.*)\s+([_\w][\w\d_]+);/) {
+		my $s = $2;
+		my $n = $3;
 
-		$typedefs{$s} = $n;
+		$typedefs{$n} = "\\ :c:type:`$n <$s>`\\ ";
 		next;
 	}
 	if ($ln =~ m/^\s*enum\s+([_\w][\w\d_]+)\s+\{/
@@ -97,11 +95,8 @@ while (<IN>) {
 	    || $ln =~ m/^\s*typedef\s*enum\s+([_\w][\w\d_]+)\s+\{/
 	    || $ln =~ m/^\s*typedef\s*enum\s+([_\w][\w\d_]+)$/) {
 		my $s = $1;
-		my $n = $1;
-		$n =~ tr/A-Z/a-z/;
-		$n =~ tr/_/-/;
 
-		$enums{$s} = $n;
+		$enums{$s} =  "enum :c:type:`$s`\\ ";
 
 		$is_enum = $1;
 		next;
@@ -112,11 +107,8 @@ while (<IN>) {
 	    || $ln =~ m/^\s*typedef\s*struct\s+([[_\w][\w\d_]+)$/
 	    ) {
 		my $s = $1;
-		my $n = $1;
-		$n =~ tr/A-Z/a-z/;
-		$n =~ tr/_/-/;
 
-		$structs{$s} = $n;
+		$structs{$s} = "struct :c:type:`$s`\\ ";
 		next;
 	}
 }
@@ -129,12 +121,9 @@ close IN;
 my @matches = ($data =~ m/typedef\s+struct\s+\S+?\s*\{[^\}]+\}\s*(\S+)\s*\;/g,
 	       $data =~ m/typedef\s+enum\s+\S+?\s*\{[^\}]+\}\s*(\S+)\s*\;/g,);
 foreach my $m (@matches) {
-		my $s = $m;
-		my $n = $m;
-		$n =~ tr/A-Z/a-z/;
-		$n =~ tr/_/-/;
+	my $s = $m;
 
-		$typedefs{$s} = $n;
+	$typedefs{$s} = "\\ :c:type:`$s`\\ ";
 	next;
 }
 
@@ -142,6 +131,15 @@ foreach my $m (@matches) {
 # Handle exceptions, if any
 #
 
+my %def_reftype = (
+	"ioctl"   => ":ref",
+	"define"  => ":ref",
+	"symbol"  => ":ref",
+	"typedef" => ":c:type",
+	"enum"    => ":c:type",
+	"struct"  => ":c:type",
+);
+
 if ($file_exceptions) {
 	open IN, $file_exceptions or die "Can't read $file_exceptions";
 	while (<IN>) {
@@ -175,29 +173,49 @@ if ($file_exceptions) {
 		}
 
 		# Parsers to replace a symbol
+		my ($type, $old, $new, $reftype);
 
-		if (m/^replace\s+ioctl\s+(\S+)\s+(\S+)/) {
-			$ioctls{$1} = $2 if (exists($ioctls{$1}));
+		if (m/^replace\s+(\S+)\s+(\S+)\s+(\S+)/) {
+			$type = $1;
+			$old = $2;
+			$new = $3;
+		} else {
+			die "Can't parse $file_exceptions: $_";
+		}
+
+		if ($new =~ m/^\:c\:(data|func|macro|type)\:\`(.+)\`/) {
+			$reftype = ":c:$1";
+			$new = $2;
+		} elsif ($new =~ m/\:ref\:\`(.+)\`/) {
+			$reftype = ":ref";
+			$new = $1;
+		} else {
+			$reftype = $def_reftype{$type};
+		}
+		$new = "$reftype:`$old <$new>`";
+
+		if ($type eq "ioctl") {
+			$ioctls{$old} = $new if (exists($ioctls{$old}));
 			next;
 		}
-		if (m/^replace\s+define\s+(\S+)\s+(\S+)/) {
-			$defines{$1} = $2 if (exists($defines{$1}));
+		if ($type eq "define") {
+			$defines{$old} = $new if (exists($defines{$old}));
 			next;
 		}
-		if (m/^replace\s+typedef\s+(\S+)\s+(\S+)/) {
-			$typedefs{$1} = $2 if (exists($typedefs{$1}));
+		if ($type eq "symbol") {
+			$enum_symbols{$old} = $new if (exists($enum_symbols{$old}));
 			next;
 		}
-		if (m/^replace\s+enum\s+(\S+)\s+(\S+)/) {
-			$enums{$1} = $2 if (exists($enums{$1}));
+		if ($type eq "typedef") {
+			$typedefs{$old} = $new if (exists($typedefs{$old}));
 			next;
 		}
-		if (m/^replace\s+symbol\s+(\S+)\s+(\S+)/) {
-			$enum_symbols{$1} = $2 if (exists($enum_symbols{$1}));
+		if ($type eq "enum") {
+			$enums{$old} = $new if (exists($enums{$old}));
 			next;
 		}
-		if (m/^replace\s+struct\s+(\S+)\s+(\S+)/) {
-			$structs{$1} = $2 if (exists($structs{$1}));
+		if ($type eq "struct") {
+			$structs{$old} = $new if (exists($structs{$old}));
 			next;
 		}
 
@@ -238,9 +256,7 @@ my $start_delim = "[ \n\t\(\=\*\@]";
 my $end_delim = "(\\s|,|\\\\=|\\\\:|\\;|\\\)|\\}|\\{)";
 
 foreach my $r (keys %ioctls) {
-	my $n = $ioctls{$r};
-
-	my $s = "\\ :ref:`$r <$n>`\\ ";
+	my $s = $ioctls{$r};
 
 	$r =~ s,([\_\`\*\<\>\&\\\\:\/]),\\\\$1,g;
 
@@ -250,9 +266,7 @@ foreach my $r (keys %ioctls) {
 }
 
 foreach my $r (keys %defines) {
-	my $n = $defines{$r};
-
-	my $s = "\\ :ref:`$r <$n>`\\ ";
+	my $s = $defines{$r};
 
 	$r =~ s,([\_\`\*\<\>\&\\\\:\/]),\\\\$1,g;
 
@@ -262,9 +276,7 @@ foreach my $r (keys %defines) {
 }
 
 foreach my $r (keys %enum_symbols) {
-	my $n = $enum_symbols{$r};
-
-	my $s = "\\ :ref:`$r <$n>`\\ ";
+	my $s = $enum_symbols{$r};
 
 	$r =~ s,([\_\`\*\<\>\&\\\\:\/]),\\\\$1,g;
 
@@ -274,9 +286,7 @@ foreach my $r (keys %enum_symbols) {
 }
 
 foreach my $r (keys %enums) {
-	my $n = $enums{$r};
-
-	my $s = "\\ :ref:`enum $r <$n>`\\ ";
+	my $s = $enums{$r};
 
 	$r =~ s,([\_\`\*\<\>\&\\\\:\/]),\\\\$1,g;
 
@@ -286,9 +296,7 @@ foreach my $r (keys %enums) {
 }
 
 foreach my $r (keys %structs) {
-	my $n = $structs{$r};
-
-	my $s = "\\ :ref:`struct $r <$n>`\\ ";
+	my $s = $structs{$r};
 
 	$r =~ s,([\_\`\*\<\>\&\\\\:\/]),\\\\$1,g;
 
@@ -298,18 +306,15 @@ foreach my $r (keys %structs) {
 }
 
 foreach my $r (keys %typedefs) {
-	my $n = $typedefs{$r};
-
-	my $s = "\\ :ref:`$r <$n>`\\ ";
+	my $s = $typedefs{$r};
 
 	$r =~ s,([\_\`\*\<\>\&\\\\:\/]),\\\\$1,g;
 
 	print "$r -> $s\n" if ($debug);
-
 	$data =~ s/($start_delim)($r)$end_delim/$1$s$3/g;
 }
 
-$data =~ s/\\ \n/\n/g;
+$data =~ s/\\ ([\n\s])/\1/g;
 
 #
 # Generate output file
-- 
2.7.4


