Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:57599 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406AbZKIBmp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 8 Nov 2009 20:42:45 -0500
Subject: [PATCH] v4l/scripts: Fix make checkpatch operation with in tree
 checkpatch.pl
From: Andy Walls <awalls@radix.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain
Date: Sun, 08 Nov 2009 20:44:57 -0500
Message-Id: <1257731097.6504.4.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

make checkpatch wasn't working for me.

I found that the new version of checkpatch.pl that's in the v4l/dvb tree
doesn't emit a version number unless explicitly requested.

This patch gets 'make checkpatch' working (and complaining again) for
me.

Regards,
Andy

Signed-off-by: Andy Walls <awalls@radix.net>



diff -r d2aaff136907 v4l/scripts/check.pl
--- a/v4l/scripts/check.pl	Thu Nov 05 19:51:24 2009 -0500
+++ b/v4l/scripts/check.pl	Sun Nov 08 20:40:06 2009 -0500
@@ -56,11 +56,13 @@
 }
 close IN;
 
-my $intree_checkpatch = "scripts/checkpatch.pl --no-tree --strict";
+my $intree_checkpatch = "scripts/checkpatch.pl --version ";
 if (!open IN,"$intree_checkpatch|") {
 	$intree_checkpatch = "v4l/".$intree_checkpatch;
 	open IN,"$intree_checkpatch|";
 }
+$intree_checkpatch =~ s/--version/--no-tree --strict/;
+
 while (<IN>) {
 	tr/A-Z/a-z/;
 	if (m/version\s*:\s*([\d\.]+)/) {


