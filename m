Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:56852 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754058AbeCWL5g (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Mar 2018 07:57:36 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Markus Elfring <elfring@users.sourceforge.net>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Colin Ian King <colin.king@canonical.com>
Subject: [PATCH 28/30] media: tm6000:  avoid casting just to print pointer address
Date: Fri, 23 Mar 2018 07:57:14 -0400
Message-Id: <e771bdf595ce7b297d9d50918300220f4981b5da.1521806166.git.mchehab@s-opensource.com>
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
 drivers/media/usb/tm6000/tm6000-video.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/tm6000/tm6000-video.c b/drivers/media/usb/tm6000/tm6000-video.c
index 8314d3fa9241..b2399d4266da 100644
--- a/drivers/media/usb/tm6000/tm6000-video.c
+++ b/drivers/media/usb/tm6000/tm6000-video.c
@@ -1346,9 +1346,8 @@ static int __tm6000_open(struct file *file)
 	fh->width = dev->width;
 	fh->height = dev->height;
 
-	dprintk(dev, V4L2_DEBUG_OPEN, "Open: fh=0x%08lx, dev=0x%08lx, dev->vidq=0x%08lx\n",
-			(unsigned long)fh, (unsigned long)dev,
-			(unsigned long)&dev->vidq);
+	dprintk(dev, V4L2_DEBUG_OPEN, "Open: fh=%p, dev=%p, dev->vidq=%p\n",
+		fh, dev, &dev->vidq);
 	dprintk(dev, V4L2_DEBUG_OPEN, "Open: list_empty queued=%d\n",
 		list_empty(&dev->vidq.queued));
 	dprintk(dev, V4L2_DEBUG_OPEN, "Open: list_empty active=%d\n",
-- 
2.14.3
