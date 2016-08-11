Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.zeus03.de ([194.117.254.33]:56221 "EHLO mail.zeus03.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932593AbcHKVLU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Aug 2016 17:11:20 -0400
From: Wolfram Sang <wsa-dev@sang-engineering.com>
To: linux-usb@vger.kernel.org
Cc: Wolfram Sang <wsa-dev@sang-engineering.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	linux-media@vger.kernel.org
Subject: [PATCH 10/28] media: usb: cx231xx: cx231xx-core: don't print error when allocating urb fails
Date: Thu, 11 Aug 2016 23:03:46 +0200
Message-Id: <1470949451-24823-11-git-send-email-wsa-dev@sang-engineering.com>
In-Reply-To: <1470949451-24823-1-git-send-email-wsa-dev@sang-engineering.com>
References: <1470949451-24823-1-git-send-email-wsa-dev@sang-engineering.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

kmalloc will print enough information in case of failure.

Signed-off-by: Wolfram Sang <wsa-dev@sang-engineering.com>
---
 drivers/media/usb/cx231xx/cx231xx-core.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-core.c b/drivers/media/usb/cx231xx/cx231xx-core.c
index 630f4fc5155f12..8ec05cb306d89a 100644
--- a/drivers/media/usb/cx231xx/cx231xx-core.c
+++ b/drivers/media/usb/cx231xx/cx231xx-core.c
@@ -1035,8 +1035,6 @@ int cx231xx_init_isoc(struct cx231xx *dev, int max_packets,
 	for (i = 0; i < dev->video_mode.isoc_ctl.num_bufs; i++) {
 		urb = usb_alloc_urb(max_packets, GFP_KERNEL);
 		if (!urb) {
-			dev_err(dev->dev,
-				"cannot alloc isoc_ctl.urb %i\n", i);
 			cx231xx_uninit_isoc(dev);
 			return -ENOMEM;
 		}
@@ -1172,8 +1170,6 @@ int cx231xx_init_bulk(struct cx231xx *dev, int max_packets,
 	for (i = 0; i < dev->video_mode.bulk_ctl.num_bufs; i++) {
 		urb = usb_alloc_urb(0, GFP_KERNEL);
 		if (!urb) {
-			dev_err(dev->dev,
-				"cannot alloc bulk_ctl.urb %i\n", i);
 			cx231xx_uninit_bulk(dev);
 			return -ENOMEM;
 		}
-- 
2.8.1

