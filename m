Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:61745 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754065AbeCWL5g (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Mar 2018 07:57:36 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Antoine Jacquet <royale@zerezo.com>, linux-usb@vger.kernel.org
Subject: [PATCH 26/30] media: zr364xx: avoid casting just to print pointer address
Date: Fri, 23 Mar 2018 07:57:12 -0400
Message-Id: <2be09d8d8342f775a9a6a9da6b91dded0a879718.1521806166.git.mchehab@s-opensource.com>
In-Reply-To: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
References: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
In-Reply-To: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
References: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of casting, just use %p.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/zr364xx/zr364xx.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/zr364xx/zr364xx.c b/drivers/media/usb/zr364xx/zr364xx.c
index 8b7c19943d46..b8886102c5ed 100644
--- a/drivers/media/usb/zr364xx/zr364xx.c
+++ b/drivers/media/usb/zr364xx/zr364xx.c
@@ -517,8 +517,7 @@ static void zr364xx_fillbuff(struct zr364xx_camera *cam,
 		printk(KERN_ERR KBUILD_MODNAME ": =======no frame\n");
 		return;
 	}
-	DBG("%s: Buffer 0x%08lx size= %d\n", __func__,
-		(unsigned long)vbuf, pos);
+	DBG("%s: Buffer %p size= %d\n", __func__, vbuf, pos);
 	/* tell v4l buffer was filled */
 
 	buf->vb.field_count = cam->frame_count * 2;
@@ -1277,7 +1276,7 @@ static int zr364xx_mmap(struct file *file, struct vm_area_struct *vma)
 		DBG("%s: cam == NULL\n", __func__);
 		return -ENODEV;
 	}
-	DBG("mmap called, vma=0x%08lx\n", (unsigned long)vma);
+	DBG("mmap called, vma=%p\n", vma);
 
 	ret = videobuf_mmap_mapper(&cam->vb_vidq, vma);
 
-- 
2.14.3
