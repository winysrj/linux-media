Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.zeus03.de ([194.117.254.33]:56228 "EHLO mail.zeus03.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932368AbcHKVLV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Aug 2016 17:11:21 -0400
From: Wolfram Sang <wsa-dev@sang-engineering.com>
To: linux-usb@vger.kernel.org
Cc: Wolfram Sang <wsa-dev@sang-engineering.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	linux-media@vger.kernel.org
Subject: [PATCH 11/28] media: usb: cx231xx: cx231xx-vbi: don't print error when allocating urb fails
Date: Thu, 11 Aug 2016 23:03:47 +0200
Message-Id: <1470949451-24823-12-git-send-email-wsa-dev@sang-engineering.com>
In-Reply-To: <1470949451-24823-1-git-send-email-wsa-dev@sang-engineering.com>
References: <1470949451-24823-1-git-send-email-wsa-dev@sang-engineering.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

kmalloc will print enough information in case of failure.

Signed-off-by: Wolfram Sang <wsa-dev@sang-engineering.com>
---
 drivers/media/usb/cx231xx/cx231xx-vbi.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-vbi.c b/drivers/media/usb/cx231xx/cx231xx-vbi.c
index 15bb573b78ac82..76e901920f6f9b 100644
--- a/drivers/media/usb/cx231xx/cx231xx-vbi.c
+++ b/drivers/media/usb/cx231xx/cx231xx-vbi.c
@@ -442,8 +442,6 @@ int cx231xx_init_vbi_isoc(struct cx231xx *dev, int max_packets,
 
 		urb = usb_alloc_urb(0, GFP_KERNEL);
 		if (!urb) {
-			dev_err(dev->dev,
-				"cannot alloc bulk_ctl.urb %i\n", i);
 			cx231xx_uninit_vbi_isoc(dev);
 			return -ENOMEM;
 		}
-- 
2.8.1

