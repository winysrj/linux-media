Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:56906 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753993AbeCWL5Z (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Mar 2018 07:57:25 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Andy Walls <awalls@md.metrocast.net>
Subject: [PATCH 17/30] media: ivtvfb: Cleanup some warnings
Date: Fri, 23 Mar 2018 07:57:03 -0400
Message-Id: <057bad7bc9eec71152be1b7bf1f9c2470b7db8e6.1521806166.git.mchehab@s-opensource.com>
In-Reply-To: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
References: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
In-Reply-To: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
References: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/pci/ivtv/ivtvfb.c:349 ivtvfb_prep_frame() warn: argument 3 to %08lx specifier is cast from pointer
drivers/media/pci/ivtv/ivtvfb.c:360 ivtvfb_prep_frame() warn: argument 3 to %08lx specifier is cast from pointer
drivers/media/pci/ivtv/ivtvfb.c:363 ivtvfb_prep_frame() warn: argument 4 to %08lx specifier is cast from pointer

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/pci/ivtv/ivtvfb.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/media/pci/ivtv/ivtvfb.c b/drivers/media/pci/ivtv/ivtvfb.c
index 621b2f613d81..8e62b8be6529 100644
--- a/drivers/media/pci/ivtv/ivtvfb.c
+++ b/drivers/media/pci/ivtv/ivtvfb.c
@@ -346,8 +346,8 @@ static int ivtvfb_prep_frame(struct ivtv *itv, int cmd, void __user *source,
 
 	/* Not fatal, but will have undesirable results */
 	if ((unsigned long)source & 3)
-		IVTVFB_WARN("ivtvfb_prep_frame: Source address not 32 bit aligned (0x%08lx)\n",
-			(unsigned long)source);
+		IVTVFB_WARN("ivtvfb_prep_frame: Source address not 32 bit aligned (%p)\n",
+			    source);
 
 	if (dest_offset & 3)
 		IVTVFB_WARN("ivtvfb_prep_frame: Dest offset not 32 bit aligned (%ld)\n", dest_offset);
@@ -357,12 +357,10 @@ static int ivtvfb_prep_frame(struct ivtv *itv, int cmd, void __user *source,
 
 	/* Check Source */
 	if (!access_ok(VERIFY_READ, source + dest_offset, count)) {
-		IVTVFB_WARN("Invalid userspace pointer 0x%08lx\n",
-			(unsigned long)source);
+		IVTVFB_WARN("Invalid userspace pointer %p\n", source);
 
-		IVTVFB_DEBUG_WARN("access_ok() failed for offset 0x%08lx source 0x%08lx count %d\n",
-			dest_offset, (unsigned long)source,
-			count);
+		IVTVFB_DEBUG_WARN("access_ok() failed for offset 0x%08lx source %p count %d\n",
+				  dest_offset, source, count);
 		return -EINVAL;
 	}
 
-- 
2.14.3
