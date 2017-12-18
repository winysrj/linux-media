Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:60475 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759027AbdLRMac (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Dec 2017 07:30:32 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Subject: [PATCH v4 11/18] scripts: kernel-doc: replace tabs by spaces
Date: Mon, 18 Dec 2017 10:30:12 -0200
Message-Id: <da839904b0429a17d6f3b9080791fa7e73e1d95a.1513599193.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1513599193.git.mchehab@s-opensource.com>
References: <cover.1513599193.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1513599193.git.mchehab@s-opensource.com>
References: <cover.1513599193.git.mchehab@s-opensource.com>
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
index e417d93575b9..05aadac0612a 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -1579,7 +1579,7 @@ sub tracepoint_munge($) {
 sub syscall_munge() {
 	my $void = 0;
 
-	$prototype =~ s@[\r\n\t]+@ @gos; # strip newlines/CR's/tabs
+	$prototype =~ s@[\r\n]+@ @gos; # strip newlines/CR's
 ##	if ($prototype =~ m/SYSCALL_DEFINE0\s*\(\s*(a-zA-Z0-9_)*\s*\)/) {
 	if ($prototype =~ m/SYSCALL_DEFINE0/) {
 		$void = 1;
@@ -1778,6 +1778,8 @@ sub process_file($) {
 	while (s/\\\s*$//) {
 	    $_ .= <IN>;
 	}
+	# Replace tabs by spaces
+        while ($_ =~ s/\t+/' ' x (length($&) * 8 - length($`) % 8)/e) {};
 	if ($state == STATE_NORMAL) {
 	    if (/$doc_start/o) {
 		$state = STATE_NAME;	# next line is always the function name
@@ -1877,8 +1879,7 @@ sub process_file($) {
 		$in_purpose = 0;
 		$contents = $newcontents;
                 $new_start_line = $.;
-		while ((substr($contents, 0, 1) eq " ") ||
-		       substr($contents, 0, 1) eq "\t") {
+		while (substr($contents, 0, 1) eq " ") {
 		    $contents = substr($contents, 1);
 		}
 		if ($contents ne "") {
@@ -1947,8 +1948,7 @@ sub process_file($) {
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
2.14.3
