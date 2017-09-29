Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:48920 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750926AbdI2MSc (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 29 Sep 2017 08:18:32 -0400
Date: Fri, 29 Sep 2017 09:08:53 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Markus Heiser <markus.heiser@darmarit.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: [PATCH v2 09/13] scripts: kernel-doc: parse next structs/unions
Message-ID: <20170929090853.469ea73b@recife.lan>
In-Reply-To: <68968C67-7CD6-4264-A46D-1EE195CBC58D@darmarit.de>
References: <cover.1506546492.git.mchehab@s-opensource.com>
        <cover.1506546492.git.mchehab@s-opensource.com>
        <b2528c4f1d2e76b7dacde8c5660e94de32e2eb71.1506546492.git.mchehab@s-opensource.com>
        <68968C67-7CD6-4264-A46D-1EE195CBC58D@darmarit.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 28 Sep 2017 18:28:32 +0200
Markus Heiser <markus.heiser@darmarit.de> escreveu:

> Hi Mauro,
> 
> > Am 27.09.2017 um 23:10 schrieb Mauro Carvalho Chehab <mchehab@s-opensource.com>:
> > 
> I also untabified the example since tabs in reST are
> a nightmare, especially in code blocks ... tabulators are the source
> of all evil [1] ...
> 
>   Please, never use tabs in markups or programming languages
>   where indentation is a part of the markup respectively the 
>   language!!

Tabs will exist at the sources, as Kernel coding style recommends its
usage. There's nothing that can be done to avoid. So, whatever scripts
we use, it should handle it.

Thankfully, solving this issue is a one line perl patch, as explained at:
	http://perldoc.perl.org/perlfaq4.html#How-do-I-expand-tabs-in-a-string?

Something like the enclosed (untested) patch.

Thanks,
Mauro

[PATCH] kernel-doc: replace tabs by spaces

Sphinx has a hard time dealing with tabs, causing it to
misinterpret paragraph continuation.

As we're now mainly focused on supporting ReST output,
replace tabs by spaces, in order to avoid troubles when
the output is parsed by Sphinx.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

diff --git a/scripts/kernel-doc b/scripts/kernel-doc
index 69757ee9db4c..7bc139184177 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -1544,7 +1544,7 @@ sub tracepoint_munge($) {
 sub syscall_munge() {
 	my $void = 0;
 
-	$prototype =~ s@[\r\n\t]+@ @gos; # strip newlines/CR's/tabs
+	$prototype =~ s@[\r\n]+@ @gos; # strip newlines/CR's
 ##	if ($prototype =~ m/SYSCALL_DEFINE0\s*\(\s*(a-zA-Z0-9_)*\s*\)/) {
 	if ($prototype =~ m/SYSCALL_DEFINE0/) {
 		$void = 1;
@@ -1743,6 +1743,8 @@ sub process_file($) {
 	while (s/\\\s*$//) {
 	    $_ .= <IN>;
 	}
+	# Replace tabs by spaces
+        while ($_ =~ s/\t+/' ' x (length($&) * 8 - length($`) % 8)/e) {};
 	if ($state == STATE_NORMAL) {
 	    if (/$doc_start/o) {
 		$state = STATE_NAME;	# next line is always the function name
@@ -1842,8 +1844,7 @@ sub process_file($) {
 		$in_purpose = 0;
 		$contents = $newcontents;
                 $new_start_line = $.;
-		while ((substr($contents, 0, 1) eq " ") ||
-		       substr($contents, 0, 1) eq "\t") {
+		while (substr($contents, 0, 1) eq " ") {
 		    $contents = substr($contents, 1);
 		}
 		if ($contents ne "") {
@@ -1912,8 +1913,7 @@ sub process_file($) {
 		$contents = $2;
                 $new_start_line = $.;
 		if ($contents ne "") {
-		    while ((substr($contents, 0, 1) eq " ") ||
-		           substr($contents, 0, 1) eq "\t") {
+		    while (substr($contents, 0, 1) eq " ") {
 			$contents = substr($contents, 1);
 		    }
 		    $contents .= "\n";
