Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41397 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932252AbcGHNEJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jul 2016 09:04:09 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: corbet@lwn.net, markus.heiser@darmarIT.de,
	linux-doc@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 31/54] doc-rst: parse-headers: improve delimiters to detect symbols
Date: Fri,  8 Jul 2016 10:03:23 -0300
Message-Id: <6fe79d1edea4861d7453915e596cc39a83ddc683.1467981855.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
References: <cover.1467981855.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
References: <cover.1467981855.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As we had to escape the symbols for the ReST markup to not do
the wrong thing, the logic to discover start/end of strings
are not trivial. Improve the end delimiter detection, in order
to highlight more occurrences of the strings.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/sphinx/parse-headers.pl | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/Documentation/sphinx/parse-headers.pl b/Documentation/sphinx/parse-headers.pl
index 287f6459e13a..ec9537ef586f 100755
--- a/Documentation/sphinx/parse-headers.pl
+++ b/Documentation/sphinx/parse-headers.pl
@@ -200,78 +200,79 @@ $data =~ s,([\_\`\*\<\>\&\\\\:\/]),\\$1,g;
 # Add references
 #
 
-my $separators = "[\n \t\,\)\=\:\{\}\;]";
+my $start_delim = "[ \n\t\(\=\*\@]";
+my $end_delim = "(\\s|,|\\\\=|\\\\:|\\;|\\\)|\\}|\\{)";
 
 foreach my $r (keys %ioctls) {
 	my $n = $ioctls{$r};
 
-	my $s = ":ref:`$r <$n>`";
+	my $s = "\\ :ref:`$r <$n>`\\ ";
 
 	$r =~ s,([\_\`\*\<\>\&\\\\:\/]),\\\\$1,g;
 
 	print "$r -> $s\n" if ($debug);
 
-	$data =~ s/([\s])($r)($separators)/$1$s$3/g;
+	$data =~ s/($start_delim)($r)$end_delim/$1$s$3/g;
 }
 
 foreach my $r (keys %defines) {
 	my $n = $defines{$r};
 
-	my $s = ":ref:`$r <$n>`";
+	my $s = "\\ :ref:`$r <$n>`\\ ";
 
 	$r =~ s,([\_\`\*\<\>\&\\\\:\/]),\\\\$1,g;
 
 	print "$r -> $s\n" if ($debug);
 
-	$data =~ s/([\s])($r)($separators)/$1$s$3/g;
+	$data =~ s/($start_delim)($r)$end_delim/$1$s$3/g;
 }
 
 foreach my $r (keys %enum_symbols) {
 	my $n = $enum_symbols{$r};
 
-	my $s = ":ref:`$r <$n>`";
+	my $s = "\\ :ref:`$r <$n>`\\ ";
 
 	$r =~ s,([\_\`\*\<\>\&\\\\:\/]),\\\\$1,g;
 
 	print "$r -> $s\n" if ($debug);
 
-	$data =~ s/([\s])($r)($separators)/$1$s$3/g;
+	$data =~ s/($start_delim)($r)$end_delim/$1$s$3/g;
 }
 
 foreach my $r (keys %enums) {
 	my $n = $enums{$r};
 
-	my $s = ":ref:`enum $r <$n>`";
+	my $s = "\\ :ref:`enum $r <$n>`\\ ";
 
 	$r =~ s,([\_\`\*\<\>\&\\\\:\/]),\\\\$1,g;
 
 	print "$r -> $s\n" if ($debug);
 
-	$data =~ s/enum\s+($r)($separators)/$s$2/g;
+	$data =~ s/enum\s+($r)$end_delim/$s$2/g;
 }
 
 foreach my $r (keys %structs) {
 	my $n = $structs{$r};
 
-	my $s = ":ref:`struct $r <$n>`";
+	my $s = "\\ :ref:`struct $r <$n>`\\ ";
 
 	$r =~ s,([\_\`\*\<\>\&\\\\:\/]),\\\\$1,g;
 
 	print "$r -> $s\n" if ($debug);
 
-	$data =~ s/struct\s+($r)($separators)/$s$2/g;
+	$data =~ s/struct\s+($r)$end_delim/$s$2/g;
 }
 
 foreach my $r (keys %typedefs) {
 	my $n = $typedefs{$r};
 
-	my $s = ":ref:`$r <$n>`";
+	my $s = "\\ :ref:`$r <$n>`\\ ";
 
 	$r =~ s,([\_\`\*\<\>\&\\\\:\/]),\\\\$1,g;
 
 	print "$r -> $s\n" if ($debug);
 
-	$data =~ s/([\s\(\,\=])($r)($separators)/$1$s$3/g;
+	$data =~ s/($start_delim)($r)$end_delim/$1$s$3/g;
 }
 
 #
-- 
2.7.4

