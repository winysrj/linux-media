Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59143 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757036AbcJNUWn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 16:22:43 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Antoine Jacquet <royale@zerezo.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-usb@vger.kernel.org
Subject: [PATCH 50/57] [media] zr364xx: don't break long lines
Date: Fri, 14 Oct 2016 17:20:38 -0300
Message-Id: <278815c378202b4630326d93df21619d306fcdea.1476475771.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476475770.git.mchehab@s-opensource.com>
References: <cover.1476475770.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1476475770.git.mchehab@s-opensource.com>
References: <cover.1476475770.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Due to the 80-cols checkpatch warnings, several strings
were broken into multiple lines. This is not considered
a good practice anymore, as it makes harder to grep for
strings at the source code. So, join those continuation
lines.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/zr364xx/zr364xx.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/zr364xx/zr364xx.c b/drivers/media/usb/zr364xx/zr364xx.c
index cc128db85723..3950708cbb32 100644
--- a/drivers/media/usb/zr364xx/zr364xx.c
+++ b/drivers/media/usb/zr364xx/zr364xx.c
@@ -633,8 +633,7 @@ static int zr364xx_read_video_callback(struct zr364xx_camera *cam,
 	} else {
 		if (frm->cur_size + purb->actual_length > MAX_FRAME_SIZE) {
 			dev_info(&cam->udev->dev,
-				 "%s: buffer (%d bytes) too small to hold "
-				 "frame data. Discarding frame data.\n",
+				 "%s: buffer (%d bytes) too small to hold frame data. Discarding frame data.\n",
 				 __func__, MAX_FRAME_SIZE);
 		} else {
 			pdest += frm->cur_size;
@@ -1373,8 +1372,7 @@ static int zr364xx_board_init(struct zr364xx_camera *cam)
 			&cam->buffer.frame[i], i,
 			cam->buffer.frame[i].lpvbits);
 		if (cam->buffer.frame[i].lpvbits == NULL) {
-			printk(KERN_INFO KBUILD_MODNAME ": out of memory. "
-			       "Using less frames\n");
+			printk(KERN_INFO KBUILD_MODNAME ": out of memory. Using less frames\n");
 			break;
 		}
 	}
-- 
2.7.4


