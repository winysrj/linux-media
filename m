Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:46811 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752223AbdI2PT0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 29 Sep 2017 11:19:26 -0400
Date: Fri, 29 Sep 2017 12:19:10 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Markus Heiser <markus.heiser@darmarit.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: [PATCH v2 09/13] scripts: kernel-doc: parse next structs/unions
Message-ID: <20170929121910.4c3cd1e2@recife.lan>
In-Reply-To: <6071B3F0-A0D8-4E03-927D-79C624E3ACAF@darmarit.de>
References: <cover.1506546492.git.mchehab@s-opensource.com>
        <cover.1506546492.git.mchehab@s-opensource.com>
        <b2528c4f1d2e76b7dacde8c5660e94de32e2eb71.1506546492.git.mchehab@s-opensource.com>
        <68968C67-7CD6-4264-A46D-1EE195CBC58D@darmarit.de>
        <20170929090853.469ea73b@recife.lan>
        <768B7EAA-53EB-4D43-95C3-D4710E6DCB41@darmarit.de>
        <20170929103234.38ea8086@recife.lan>
        <6071B3F0-A0D8-4E03-927D-79C624E3ACAF@darmarit.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 29 Sep 2017 17:00:36 +0200
Markus Heiser <markus.heiser@darmarit.de> escreveu:

> > None to argue here. If it is part of the language, either comply or use
> > some other language that it isn't position oriented.  
> 
> Just for info; when Guido van Rossum created python he thought, that
> readability counts. With indentation as a part of the syntax, python
> forces the developer to write readable code.

I'm sympathetic with the idea of having a more readable code, but a similar
effect could be produced by noisy warnings if the indentation is not
correct. It also wouldn't force the others about a personal tabs usage
preference.

For me, the issue that bothers most on Python is that, if I need to comment
out part of the code (for example, to remove an IF clause) to do some tests
or add new prints, the code inside it needs to be re-indented, with slows
down my tests ;)

On all other languages, I just comment out the lines, and, if I want to
place additional prints, I start from column 1, as this is very easy to
notice and strip before pushing the final version.

> I have stack of punched card right here: Nowadays they are excellent
> cigarettes filter ;)

:-)

> 
>   https://github.com/return42/linuxdoc/blob/master/linuxdoc/kernel_doc.py#L1713
> 
> I guess we should do the same in sub process_file($) with <IN>. My
> perl is to bad, may you could take a look at? / Thanks!

Gah! I guess I forgot to attach the patch I wrote on my previous e-mail...
I did exactly what you suggested.

I opted to use this:

    while (<IN>) {
	while (s/\\\s*$//) {
	    $_ .= <IN>;
	}
	# Replace tabs by spaces
        while ($_ =~ s/\t+/' ' x (length($&) * 8 - length($`) % 8)/e) {};

To replace them. I could, instead, use a perl extension, but that
would add an extra dependency for something that can be done on a
single Perl regex statement.

Thanks,
Mauro

-

>From 7c4ef302b855aeb68773621f379fb6e8813c886c Mon Sep 17 00:00:00 2001
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Date: Fri, 29 Sep 2017 08:53:40 -0300
Subject: [PATCH] kernel-doc: replace tabs by spaces

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
