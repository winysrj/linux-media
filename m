Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.zeus03.de ([194.117.254.33]:56270 "EHLO mail.zeus03.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932654AbcHKVL1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Aug 2016 17:11:27 -0400
From: Wolfram Sang <wsa-dev@sang-engineering.com>
To: linux-usb@vger.kernel.org
Cc: Wolfram Sang <wsa-dev@sang-engineering.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	linux-media@vger.kernel.org
Subject: [PATCH 19/28] media: usb: hdpvr: hdpvr-video: don't print error when allocating urb fails
Date: Thu, 11 Aug 2016 23:03:55 +0200
Message-Id: <1470949451-24823-20-git-send-email-wsa-dev@sang-engineering.com>
In-Reply-To: <1470949451-24823-1-git-send-email-wsa-dev@sang-engineering.com>
References: <1470949451-24823-1-git-send-email-wsa-dev@sang-engineering.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

kmalloc will print enough information in case of failure.

Signed-off-by: Wolfram Sang <wsa-dev@sang-engineering.com>
---
 drivers/media/usb/hdpvr/hdpvr-video.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/media/usb/hdpvr/hdpvr-video.c b/drivers/media/usb/hdpvr/hdpvr-video.c
index 2a3a8b470555b9..6d43d75493ea0e 100644
--- a/drivers/media/usb/hdpvr/hdpvr-video.c
+++ b/drivers/media/usb/hdpvr/hdpvr-video.c
@@ -155,10 +155,8 @@ int hdpvr_alloc_buffers(struct hdpvr_device *dev, uint count)
 		buf->dev = dev;
 
 		urb = usb_alloc_urb(0, GFP_KERNEL);
-		if (!urb) {
-			v4l2_err(&dev->v4l2_dev, "cannot allocate urb\n");
+		if (!urb)
 			goto exit_urb;
-		}
 		buf->urb = urb;
 
 		mem = usb_alloc_coherent(dev->udev, dev->bulk_in_size, GFP_KERNEL,
-- 
2.8.1

