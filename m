Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.zeus03.de ([194.117.254.33]:56282 "EHLO mail.zeus03.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932673AbcHKVL2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Aug 2016 17:11:28 -0400
From: Wolfram Sang <wsa-dev@sang-engineering.com>
To: linux-usb@vger.kernel.org
Cc: Wolfram Sang <wsa-dev@sang-engineering.com>,
	Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	linux-media@vger.kernel.org
Subject: [PATCH 20/28] media: usb: msi2500: msi2500: don't print error when allocating urb fails
Date: Thu, 11 Aug 2016 23:03:56 +0200
Message-Id: <1470949451-24823-21-git-send-email-wsa-dev@sang-engineering.com>
In-Reply-To: <1470949451-24823-1-git-send-email-wsa-dev@sang-engineering.com>
References: <1470949451-24823-1-git-send-email-wsa-dev@sang-engineering.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

kmalloc will print enough information in case of failure.

Signed-off-by: Wolfram Sang <wsa-dev@sang-engineering.com>
---
 drivers/media/usb/msi2500/msi2500.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/usb/msi2500/msi2500.c b/drivers/media/usb/msi2500/msi2500.c
index e7f167d44c61ce..367eb7e2a31dbc 100644
--- a/drivers/media/usb/msi2500/msi2500.c
+++ b/drivers/media/usb/msi2500/msi2500.c
@@ -509,7 +509,6 @@ static int msi2500_isoc_init(struct msi2500_dev *dev)
 	for (i = 0; i < MAX_ISO_BUFS; i++) {
 		urb = usb_alloc_urb(ISO_FRAMES_PER_DESC, GFP_KERNEL);
 		if (urb == NULL) {
-			dev_err(dev->dev, "Failed to allocate urb %d\n", i);
 			msi2500_isoc_cleanup(dev);
 			return -ENOMEM;
 		}
-- 
2.8.1

