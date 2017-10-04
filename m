Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:57151 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751996AbdJDL6f (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 4 Oct 2017 07:58:35 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH v3 11/17] scripts: kernel-doc: replace tabs by spaces
Date: Wed,  4 Oct 2017 08:48:49 -0300
Message-Id: <128c478afdd0211fabd0dd4bb098831f8b32d31f.1507116877.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1507116877.git.mchehab@s-opensource.com>
References: <cover.1507116877.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1507116877.git.mchehab@s-opensource.com>
References: <cover.1507116877.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sphinx has a hard time dealing with tabs, causing it to
misinterpret paragraph continuation.

As we're now mainly focused on supporting ReST output,
replace tabs by spaces, in order to avoid troubles when
the output is parsed by Sphinx.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 scripts/kernel-doc | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/scripts/kernel-doc b/scripts/kernel-doc
index 2d3d5e9bf7de..d8c98e45b1ce 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -1557,7 +1557,7 @@ sub tracepoint_munge($) {
 sub syscall_munge() {
 	my $void = 0;
 
-	$prototype =~ s@[\r\n\t]+@ @gos; # strip newlines/CR's/tabs
+	$prototype =~ s@[\r\n]+@ @gos; # strip newlines/CR's
 ##	if ($prototype =~ m/SYSCALL_DEFINE0\s*\(\s*(a-zA-Z0-9_)*\s*\)/) {
 	if ($prototype =~ m/SYSCALL_DEFINE0/) {
 		$void = 1;
@@ -1756,6 +1756,8 @@ sub process_file($) {
 	while (s/\\\s*$//) {
 	    $_ .= <IN>;
 	}
+	# Replace tabs by spaces
+        while ($_ =~ s/\t+/' ' x (length($&) * 8 - length($`) % 8)/e) {};
 	if ($state == STATE_NORMAL) {
 	    if (/$doc_start/o) {
 		$state = STATE_NAME;	# next line is always the function name
@@ -1855,8 +1857,7 @@ sub process_file($) {
 		$in_purpose = 0;
 		$contents = $newcontents;
                 $new_start_line = $.;
-		while ((substr($contents, 0, 1) eq " ") ||
-		       substr($contents, 0, 1) eq "\t") {
+		while (substr($contents, 0, 1) eq " ") {
 		    $contents = substr($contents, 1);
 		}
 		if ($contents ne "") {
@@ -1925,8 +1926,7 @@ sub process_file($) {
 		$contents = $2;
                 $new_start_line = $.;
 		if ($contents ne "") {
-		    while ((substr($contents, 0, 1) eq " ") ||
-		           substr($contents, 0, 1) eq "\t") {
+		    while (substr($contents, 0, 1) eq " ") {
 			$contents = substr($contents, 1);
 		    }
 		    $contents .= "\n";
-- 
2.13.6
