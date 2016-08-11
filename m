Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.zeus03.de ([194.117.254.33]:56311 "EHLO mail.zeus03.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932701AbcHKVLd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Aug 2016 17:11:33 -0400
From: Wolfram Sang <wsa-dev@sang-engineering.com>
To: linux-usb@vger.kernel.org
Cc: Wolfram Sang <wsa-dev@sang-engineering.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	linux-media@vger.kernel.org
Subject: [PATCH 26/28] media: usb: tm6000: tm6000-video: don't print error when allocating urb fails
Date: Thu, 11 Aug 2016 23:04:02 +0200
Message-Id: <1470949451-24823-27-git-send-email-wsa-dev@sang-engineering.com>
In-Reply-To: <1470949451-24823-1-git-send-email-wsa-dev@sang-engineering.com>
References: <1470949451-24823-1-git-send-email-wsa-dev@sang-engineering.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

kmalloc will print enough information in case of failure.

Signed-off-by: Wolfram Sang <wsa-dev@sang-engineering.com>
---
 drivers/media/usb/tm6000/tm6000-video.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/usb/tm6000/tm6000-video.c b/drivers/media/usb/tm6000/tm6000-video.c
index fa5e8bda2ae4a7..dee7e7d3d47d71 100644
--- a/drivers/media/usb/tm6000/tm6000-video.c
+++ b/drivers/media/usb/tm6000/tm6000-video.c
@@ -635,7 +635,6 @@ static int tm6000_prepare_isoc(struct tm6000_core *dev)
 	for (i = 0; i < dev->isoc_ctl.num_bufs; i++) {
 		urb = usb_alloc_urb(max_packets, GFP_KERNEL);
 		if (!urb) {
-			tm6000_err("cannot alloc isoc_ctl.urb %i\n", i);
 			tm6000_uninit_isoc(dev);
 			usb_free_urb(urb);
 			return -ENOMEM;
-- 
2.8.1

