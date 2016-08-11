Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.zeus03.de ([194.117.254.33]:56298 "EHLO mail.zeus03.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932680AbcHKVLa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Aug 2016 17:11:30 -0400
From: Wolfram Sang <wsa-dev@sang-engineering.com>
To: linux-usb@vger.kernel.org
Cc: Wolfram Sang <wsa-dev@sang-engineering.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	linux-media@vger.kernel.org
Subject: [PATCH 22/28] media: usb: s2255: s2255drv: don't print error when allocating urb fails
Date: Thu, 11 Aug 2016 23:03:58 +0200
Message-Id: <1470949451-24823-23-git-send-email-wsa-dev@sang-engineering.com>
In-Reply-To: <1470949451-24823-1-git-send-email-wsa-dev@sang-engineering.com>
References: <1470949451-24823-1-git-send-email-wsa-dev@sang-engineering.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

kmalloc will print enough information in case of failure.

Signed-off-by: Wolfram Sang <wsa-dev@sang-engineering.com>
---
 drivers/media/usb/s2255/s2255drv.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/media/usb/s2255/s2255drv.c b/drivers/media/usb/s2255/s2255drv.c
index 43ba71a7d02b8f..9458eb0ef66f43 100644
--- a/drivers/media/usb/s2255/s2255drv.c
+++ b/drivers/media/usb/s2255/s2255drv.c
@@ -2113,11 +2113,8 @@ static int s2255_start_readpipe(struct s2255_dev *dev)
 	pipe_info->state = 1;
 	pipe_info->err_count = 0;
 	pipe_info->stream_urb = usb_alloc_urb(0, GFP_KERNEL);
-	if (!pipe_info->stream_urb) {
-		dev_err(&dev->udev->dev,
-			"ReadStream: Unable to alloc URB\n");
+	if (!pipe_info->stream_urb)
 		return -ENOMEM;
-	}
 	/* transfer buffer allocated in board_init */
 	usb_fill_bulk_urb(pipe_info->stream_urb, dev->udev,
 			  pipe,
@@ -2290,10 +2287,8 @@ static int s2255_probe(struct usb_interface *interface,
 	}
 
 	dev->fw_data->fw_urb = usb_alloc_urb(0, GFP_KERNEL);
-	if (!dev->fw_data->fw_urb) {
-		dev_err(&interface->dev, "out of memory!\n");
+	if (!dev->fw_data->fw_urb)
 		goto errorFWURB;
-	}
 
 	dev->fw_data->pfw_data = kzalloc(CHUNK_SIZE, GFP_KERNEL);
 	if (!dev->fw_data->pfw_data) {
-- 
2.8.1

