Return-path: <mchehab@pedra>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:24238 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026Ab1AQMVy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Jan 2011 07:21:54 -0500
From: Hans Verkuil <hansverk@cisco.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] Fix media_build file matching
Date: Mon, 17 Jan 2011 13:21:15 +0100
Cc: "Mauro Carvalho Chehab" <mchehab@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201101171321.15893.hansverk@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

Can you apply this patch to the media_build tree? It quotes the *.[ch] file
pattern used by find.

When I was experimenting with the media_build tree and trying
'make tar DIR=<git repo>' I kept ending up with just one source in my tar
archive. I couldn't for the life of me understand what was going on until
I realized that I had a copy of a media driver source in the top dir of my
git repository. Because the file pattern was not quoted it would expand to
that particular source and match only that one.

It took me a surprisingly long time before I figured this out :-(

Quoting the pattern fixes this.

Regards,

	Hans

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/linux/Makefile b/linux/Makefile
index 8bbeee8..d731f61 100644
--- a/linux/Makefile
+++ b/linux/Makefile
@@ -58,7 +58,7 @@ todaytar:
 	tar rvf $(PWD)/linux-media.tar git_log
 	for i in $(TARDIR); do \
 		if [ "`echo $$i|grep Documentation`" = "" ]; then \
-			dir="`(cd $(DIR); find $$i -type f -name *.[ch])`"; \
+			dir="`(cd $(DIR); find $$i -type f -name '*.[ch]')`"; \
 			dir="$$dir `(cd $(DIR); find $$i -type f -name Makefile)`"; \
 			dir="$$dir `(cd $(DIR); find $$i -type f -name Kconfig)`"; \
 			tar rvf $(PWD)/$(TODAY_TAR) -C $(DIR) $$dir; \
@@ -75,7 +75,7 @@ tar:
 	tar rvf $(PWD)/linux-media.tar git_log
 	for i in $(TARDIR); do \
 		if [ "`echo $$i|grep Documentation`" = "" ]; then \
-			dir="`(cd $(DIR); find $$i -type f -name *.[ch])`"; \
+			dir="`(cd $(DIR); find $$i -type f -name '*.[ch]')`"; \
 			dir="$$dir `(cd $(DIR); find $$i -type f -name Makefile)`"; \
 			dir="$$dir `(cd $(DIR); find $$i -type f -name Kconfig)`"; \
 			tar rvf $(PWD)/linux-media.tar -C $(DIR) $$dir; \
