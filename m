Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.zeus03.de ([194.117.254.33]:56203 "EHLO mail.zeus03.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932430AbcHKVLR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Aug 2016 17:11:17 -0400
From: Wolfram Sang <wsa-dev@sang-engineering.com>
To: linux-usb@vger.kernel.org
Cc: Wolfram Sang <wsa-dev@sang-engineering.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	linux-media@vger.kernel.org
Subject: [PATCH 06/28] media: usb: as102: as102_usb_drv: don't print error when allocating urb fails
Date: Thu, 11 Aug 2016 23:03:42 +0200
Message-Id: <1470949451-24823-7-git-send-email-wsa-dev@sang-engineering.com>
In-Reply-To: <1470949451-24823-1-git-send-email-wsa-dev@sang-engineering.com>
References: <1470949451-24823-1-git-send-email-wsa-dev@sang-engineering.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

kmalloc will print enough information in case of failure.

Signed-off-by: Wolfram Sang <wsa-dev@sang-engineering.com>
---
 drivers/media/usb/as102/as102_usb_drv.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/usb/as102/as102_usb_drv.c b/drivers/media/usb/as102/as102_usb_drv.c
index 0e8030c071b8e7..68c3a80ce349b7 100644
--- a/drivers/media/usb/as102/as102_usb_drv.c
+++ b/drivers/media/usb/as102/as102_usb_drv.c
@@ -270,8 +270,6 @@ static int as102_alloc_usb_stream_buffer(struct as102_dev_t *dev)
 
 		urb = usb_alloc_urb(0, GFP_ATOMIC);
 		if (urb == NULL) {
-			dev_dbg(&dev->bus_adap.usb_dev->dev,
-				"%s: usb_alloc_urb failed\n", __func__);
 			as102_free_usb_stream_buffer(dev);
 			return -ENOMEM;
 		}
-- 
2.8.1

