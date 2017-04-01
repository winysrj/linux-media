Return-path: <linux-media-owner@vger.kernel.org>
Received: from twinsen.zall.org ([109.74.194.249]:57561 "EHLO twinsen.zall.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751661AbdDARjd (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 1 Apr 2017 13:39:33 -0400
Date: Sat, 1 Apr 2017 17:34:08 +0000
From: Alyssa Milburn <amilburn@zall.org>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 2/4] zr364xx: enforce minimum size when reading header
Message-ID: <3baed23b0ddf82764025b64eba2ac240e26854a8.1491066251.git.amilburn@zall.org>
References: <cover.1491066251.git.amilburn@zall.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <cover.1491066251.git.amilburn@zall.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This code copies actual_length-128 bytes from the header, which will
underflow if the received buffer is too small.

Signed-off-by: Alyssa Milburn <amilburn@zall.org>
---
 drivers/media/usb/zr364xx/zr364xx.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/media/usb/zr364xx/zr364xx.c b/drivers/media/usb/zr364xx/zr364xx.c
index f2d6fc03dda0..efdcd5bd6a4c 100644
--- a/drivers/media/usb/zr364xx/zr364xx.c
+++ b/drivers/media/usb/zr364xx/zr364xx.c
@@ -600,6 +600,14 @@ static int zr364xx_read_video_callback(struct zr364xx_camera *cam,
 	ptr = pdest = frm->lpvbits;
 
 	if (frm->ulState == ZR364XX_READ_IDLE) {
+		if (purb->actual_length < 128) {
+			/* header incomplete */
+			dev_info(&cam->udev->dev,
+				 "%s: buffer (%d bytes) too small to hold jpeg header. Discarding.\n",
+				 __func__, purb->actual_length);
+			return -EINVAL;
+		}
+
 		frm->ulState = ZR364XX_READ_FRAME;
 		frm->cur_size = 0;
 
-- 
2.11.0
