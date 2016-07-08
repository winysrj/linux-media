Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41489 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755390AbcGHNEG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jul 2016 09:04:06 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: corbet@lwn.net, markus.heiser@darmarIT.de,
	linux-doc@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 34/54] doc-rst: parse-headers: be more formal about the valid symbols
Date: Fri,  8 Jul 2016 10:03:26 -0300
Message-Id: <9c80c74563bceede4057bb93dbb21c84f56f5858.1467981855.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
References: <cover.1467981855.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
References: <cover.1467981855.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Be more formal about the valid symbols that are expected by
the parser, to match what c language expects.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/sphinx/parse-headers.pl | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/Documentation/sphinx/parse-headers.pl b/Documentation/sphinx/parse-headers.pl
index bf6f0df895f4..5e366756084f 100755
--- a/Documentation/sphinx/parse-headers.pl
+++ b/Documentation/sphinx/parse-headers.pl
@@ -34,7 +34,7 @@ while (<IN>) {
 
 	$data .= $_;
 
-	if ($is_enum && $ln =~ m/^\s*([_A-Z][^\s\}\,\=]+)\s*[\,=]?/) {
+	if ($is_enum && $ln =~ m/^\s*([_\w][\w\d_]+)\s*[\,=]?/) {
 		my $s = $1;
 		my $n = $1;
 		$n =~ tr/A-Z/a-z/;
@@ -47,7 +47,7 @@ while (<IN>) {
 	}
 	$is_enum = 0 if ($is_enum && m/\}/);
 
-	if ($ln =~ m/^\s*#\s*define\s+([_A-Z]\S+)\s+_IO/) {
+	if ($ln =~ m/^\s*#\s*define\s+([_\w][\w\d_]+)\s+_IO/) {
 		my $s = $1;
 		my $n = $1;
 		$n =~ tr/A-Z/a-z/;
@@ -56,7 +56,7 @@ while (<IN>) {
 		next;
 	}
 
-	if ($ln =~ m/^\s*#\s*define\s+([_A-Z]\S+)\s+/) {
+	if ($ln =~ m/^\s*#\s*define\s+([_\w][\w\d_]+)\s+/) {
 		my $s = $1;
 		my $n = $1;
 		$n =~ tr/A-Z/a-z/;
@@ -66,7 +66,7 @@ while (<IN>) {
 		next;
 	}
 
-	if ($ln =~ m/^\s*typedef\s+.*\s+([_\w]\S+);/) {
+	if ($ln =~ m/^\s*typedef\s+.*\s+([_\w][\w\d_]+);/) {
 		my $s = $1;
 		my $n = $1;
 		$n =~ tr/A-Z/a-z/;
@@ -75,8 +75,8 @@ while (<IN>) {
 		$typedefs{$s} = $n;
 		next;
 	}
-	if ($ln =~ m/^\s*enum\s+(\S+)\s+\{/
-	    || $ln =~ m/^\s*enum\s+(\S+)$/) {
+	if ($ln =~ m/^\s*enum\s+([_\w][\w\d_]+)\s+\{/
+	    || $ln =~ m/^\s*enum\s+([_\w][\w\d_]+)$/) {
 		my $s = $1;
 		my $n = $1;
 		$n =~ tr/A-Z/a-z/;
@@ -87,8 +87,8 @@ while (<IN>) {
 		$is_enum = $1;
 		next;
 	}
-	if ($ln =~ m/^\s*struct\s+([_A-Za-z_]\S+)\s+\{/
-	    || $ln =~ m/^\s*struct\s+([A-Za-z_]\S+)$/) {
+	if ($ln =~ m/^\s*struct\s+([_\w][\w\d_]+)\s+\{/
+	    || $ln =~ m/^\s*struct\s+([[_\w][\w\d_]+)$/) {
 		my $s = $1;
 		my $n = $1;
 		$n =~ tr/A-Z/a-z/;
-- 
2.7.4

