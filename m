Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.zeus03.de ([194.117.254.33]:56313 "EHLO mail.zeus03.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932664AbcHKVLe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Aug 2016 17:11:34 -0400
From: Wolfram Sang <wsa-dev@sang-engineering.com>
To: linux-usb@vger.kernel.org
Cc: Wolfram Sang <wsa-dev@sang-engineering.com>,
	Antoine Jacquet <royale@zerezo.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	linux-media@vger.kernel.org
Subject: [PATCH 28/28] media: usb: zr364xx: zr364xx: don't print error when allocating urb fails
Date: Thu, 11 Aug 2016 23:04:04 +0200
Message-Id: <1470949451-24823-29-git-send-email-wsa-dev@sang-engineering.com>
In-Reply-To: <1470949451-24823-1-git-send-email-wsa-dev@sang-engineering.com>
References: <1470949451-24823-1-git-send-email-wsa-dev@sang-engineering.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

kmalloc will print enough information in case of failure.

Signed-off-by: Wolfram Sang <wsa-dev@sang-engineering.com>
---
 drivers/media/usb/zr364xx/zr364xx.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/media/usb/zr364xx/zr364xx.c b/drivers/media/usb/zr364xx/zr364xx.c
index 7433ba5c4bad8b..cc128db85723c9 100644
--- a/drivers/media/usb/zr364xx/zr364xx.c
+++ b/drivers/media/usb/zr364xx/zr364xx.c
@@ -1045,10 +1045,8 @@ static int zr364xx_start_readpipe(struct zr364xx_camera *cam)
 	pipe_info->state = 1;
 	pipe_info->err_count = 0;
 	pipe_info->stream_urb = usb_alloc_urb(0, GFP_KERNEL);
-	if (!pipe_info->stream_urb) {
-		dev_err(&cam->udev->dev, "ReadStream: Unable to alloc URB\n");
+	if (!pipe_info->stream_urb)
 		return -ENOMEM;
-	}
 	/* transfer buffer allocated in board_init */
 	usb_fill_bulk_urb(pipe_info->stream_urb, cam->udev,
 			  pipe,
-- 
2.8.1

