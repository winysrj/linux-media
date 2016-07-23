Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43345 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234AbcGWLcY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Jul 2016 07:32:24 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 1/4] doc-rst: kernel-doc: fix a change introduced by mistake
Date: Sat, 23 Jul 2016 08:31:51 -0300
Message-Id: <a3f57ad0e401cc19887da462b16a20d97e7bccfb.1469273428.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

changeset b7e67f6c1bf7 ("doc-rst: linux_tv: supress lots of warnings")
were meant to touch only on media files, but it also touched
at this script by mistake. Revert such change.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 scripts/kernel-doc | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/kernel-doc b/scripts/kernel-doc
index f9652c25e09a..4f2e9049e8fa 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -1833,7 +1833,7 @@ sub output_function_rst(%) {
     my $oldprefix = $lineprefix;
     my $start;
 
-    print ".. cpp:function:: ";
+    print ".. c:function:: ";
     if ($args{'functiontype'} ne "") {
 	$start = $args{'functiontype'} . " " . $args{'function'} . " (";
     } else {
-- 
2.7.4

