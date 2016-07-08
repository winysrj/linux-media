Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41369 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755276AbcGHNED (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jul 2016 09:04:03 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: corbet@lwn.net, markus.heiser@darmarIT.de,
	linux-doc@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 33/54] doc-rst: fix parsing comments and '{' on a separate line
Date: Fri,  8 Jul 2016 10:03:25 -0300
Message-Id: <9afe51129ba2b275c6464d485dd6e2c9d3deb72e.1467981855.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
References: <cover.1467981855.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
References: <cover.1467981855.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The dmx.h header has two things that causes the parser to
break while handling enums:
 per-header enums and the '{' starts on a new line

Both makes the parser to get lexical marks to be detected
as if they were symbols.

Fix it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/sphinx/parse-headers.pl | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/Documentation/sphinx/parse-headers.pl b/Documentation/sphinx/parse-headers.pl
index 59f2c90f6942..bf6f0df895f4 100755
--- a/Documentation/sphinx/parse-headers.pl
+++ b/Documentation/sphinx/parse-headers.pl
@@ -29,9 +29,12 @@ my %structs;
 my $is_enum = 0;
 open IN, $file_in or die "Can't open $file_in";
 while (<IN>) {
+	my $ln = $_;
+	$ln =~ s,/\*.*\*/,,;
+
 	$data .= $_;
 
-	if ($is_enum && m/^\s*([^\s\}\,\=]+)\s*[\,=]?/) {
+	if ($is_enum && $ln =~ m/^\s*([_A-Z][^\s\}\,\=]+)\s*[\,=]?/) {
 		my $s = $1;
 		my $n = $1;
 		$n =~ tr/A-Z/a-z/;
@@ -44,7 +47,7 @@ while (<IN>) {
 	}
 	$is_enum = 0 if ($is_enum && m/\}/);
 
-	if (m/^\s*#\s*define\s+([_A-Z]\S+)\s+_IO/) {
+	if ($ln =~ m/^\s*#\s*define\s+([_A-Z]\S+)\s+_IO/) {
 		my $s = $1;
 		my $n = $1;
 		$n =~ tr/A-Z/a-z/;
@@ -53,7 +56,7 @@ while (<IN>) {
 		next;
 	}
 
-	if (m/^\s*#\s*define\s+([_A-Z]\S+)\s+/) {
+	if ($ln =~ m/^\s*#\s*define\s+([_A-Z]\S+)\s+/) {
 		my $s = $1;
 		my $n = $1;
 		$n =~ tr/A-Z/a-z/;
@@ -63,7 +66,7 @@ while (<IN>) {
 		next;
 	}
 
-	if (m/^\s*typedef\s+.*\s+([_\w]\S+);/) {
+	if ($ln =~ m/^\s*typedef\s+.*\s+([_\w]\S+);/) {
 		my $s = $1;
 		my $n = $1;
 		$n =~ tr/A-Z/a-z/;
@@ -72,7 +75,8 @@ while (<IN>) {
 		$typedefs{$s} = $n;
 		next;
 	}
-	if (m/^\s*enum\s+(\S+)\s+\{/ || m/^\s*enum\s+(\S+)$/) {
+	if ($ln =~ m/^\s*enum\s+(\S+)\s+\{/
+	    || $ln =~ m/^\s*enum\s+(\S+)$/) {
 		my $s = $1;
 		my $n = $1;
 		$n =~ tr/A-Z/a-z/;
@@ -83,7 +87,8 @@ while (<IN>) {
 		$is_enum = $1;
 		next;
 	}
-	if (m/^\s*struct\s+([_A-Za-z_]\S+)\s+\{/ || m/^\s*struct\s+([A-Za-z_]\S+)$/) {
+	if ($ln =~ m/^\s*struct\s+([_A-Za-z_]\S+)\s+\{/
+	    || $ln =~ m/^\s*struct\s+([A-Za-z_]\S+)$/) {
 		my $s = $1;
 		my $n = $1;
 		$n =~ tr/A-Z/a-z/;
-- 
2.7.4

