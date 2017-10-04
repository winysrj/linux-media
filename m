Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:64747 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751677AbdJDL6c (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 4 Oct 2017 07:58:32 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH v3 09/17] scripts: kernel-doc: improve argument handling
Date: Wed,  4 Oct 2017 08:48:47 -0300
Message-Id: <8819dbe2f8e6a5ef43601b666a5d0b0d9cbe2615.1507116877.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1507116877.git.mchehab@s-opensource.com>
References: <cover.1507116877.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1507116877.git.mchehab@s-opensource.com>
References: <cover.1507116877.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Right now, if one uses "--rst" instead of "-rst", it just
ignore the argument and produces a man page. Change the
logic to accept both "-cmd" and "--cmd". Also, if
"cmd" doesn't exist, print the usage information and exit.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 scripts/kernel-doc | 34 +++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 15 deletions(-)

diff --git a/scripts/kernel-doc b/scripts/kernel-doc
index 68d81a78b2fc..f5901989971f 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -390,45 +390,49 @@ my $undescribed = "-- undescribed --";
 
 reset_state();
 
-while ($ARGV[0] =~ m/^-(.*)/) {
-    my $cmd = shift @ARGV;
-    if ($cmd eq "-man") {
+while ($ARGV[0] =~ m/^--?(.*)/) {
+    my $cmd = $1;
+    shift @ARGV;
+    if ($cmd eq "man") {
 	$output_mode = "man";
 	@highlights = @highlights_man;
 	$blankline = $blankline_man;
-    } elsif ($cmd eq "-rst") {
+    } elsif ($cmd eq "rst") {
 	$output_mode = "rst";
 	@highlights = @highlights_rst;
 	$blankline = $blankline_rst;
-    } elsif ($cmd eq "-module") { # not needed for XML, inherits from calling document
+    } elsif ($cmd eq "module") { # not needed for XML, inherits from calling document
 	$modulename = shift @ARGV;
-    } elsif ($cmd eq "-function") { # to only output specific functions
+    } elsif ($cmd eq "function") { # to only output specific functions
 	$output_selection = OUTPUT_INCLUDE;
 	$function = shift @ARGV;
 	$function_table{$function} = 1;
-    } elsif ($cmd eq "-nofunction") { # output all except specific functions
+    } elsif ($cmd eq "nofunction") { # output all except specific functions
 	$output_selection = OUTPUT_EXCLUDE;
 	$function = shift @ARGV;
 	$function_table{$function} = 1;
-    } elsif ($cmd eq "-export") { # only exported symbols
+    } elsif ($cmd eq "export") { # only exported symbols
 	$output_selection = OUTPUT_EXPORTED;
 	%function_table = ();
-    } elsif ($cmd eq "-internal") { # only non-exported symbols
+    } elsif ($cmd eq "internal") { # only non-exported symbols
 	$output_selection = OUTPUT_INTERNAL;
 	%function_table = ();
-    } elsif ($cmd eq "-export-file") {
+    } elsif ($cmd eq "export-file") {
 	my $file = shift @ARGV;
 	push(@export_file_list, $file);
-    } elsif ($cmd eq "-v") {
+    } elsif ($cmd eq "v") {
 	$verbose = 1;
-    } elsif (($cmd eq "-h") || ($cmd eq "--help")) {
+    } elsif (($cmd eq "h") || ($cmd eq "help")) {
 	usage();
-    } elsif ($cmd eq '-no-doc-sections') {
+    } elsif ($cmd eq 'no-doc-sections') {
 	    $no_doc_sections = 1;
-    } elsif ($cmd eq '-enable-lineno') {
+    } elsif ($cmd eq 'enable-lineno') {
 	    $enable_lineno = 1;
-    } elsif ($cmd eq '-show-not-found') {
+    } elsif ($cmd eq 'show-not-found') {
 	$show_not_found = 1;
+    } else {
+	# Unknown argument
+        usage();
     }
 }
 
-- 
2.13.6
