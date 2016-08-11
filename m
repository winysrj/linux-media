Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.zeus03.de ([194.117.254.33]:56192 "EHLO mail.zeus03.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932329AbcHKVLP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Aug 2016 17:11:15 -0400
From: Wolfram Sang <wsa-dev@sang-engineering.com>
To: linux-usb@vger.kernel.org
Cc: Wolfram Sang <wsa-dev@sang-engineering.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	linux-media@vger.kernel.org
Subject: [PATCH 03/28] media: rc: imon: don't print error when allocating urb fails
Date: Thu, 11 Aug 2016 23:03:39 +0200
Message-Id: <1470949451-24823-4-git-send-email-wsa-dev@sang-engineering.com>
In-Reply-To: <1470949451-24823-1-git-send-email-wsa-dev@sang-engineering.com>
References: <1470949451-24823-1-git-send-email-wsa-dev@sang-engineering.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

kmalloc will print enough information in case of failure.

Signed-off-by: Wolfram Sang <wsa-dev@sang-engineering.com>
---
 drivers/media/rc/imon.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
index 65f80b8b9f7ab9..86cc70fe25348f 100644
--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -2211,16 +2211,11 @@ static struct imon_context *imon_init_intf0(struct usb_interface *intf,
 		goto exit;
 	}
 	rx_urb = usb_alloc_urb(0, GFP_KERNEL);
-	if (!rx_urb) {
-		dev_err(dev, "%s: usb_alloc_urb failed for IR urb", __func__);
+	if (!rx_urb)
 		goto rx_urb_alloc_failed;
-	}
 	tx_urb = usb_alloc_urb(0, GFP_KERNEL);
-	if (!tx_urb) {
-		dev_err(dev, "%s: usb_alloc_urb failed for display urb",
-			__func__);
+	if (!tx_urb)
 		goto tx_urb_alloc_failed;
-	}
 
 	mutex_init(&ictx->lock);
 	spin_lock_init(&ictx->kc_lock);
@@ -2305,10 +2300,8 @@ static struct imon_context *imon_init_intf1(struct usb_interface *intf,
 	int ret = -ENOMEM;
 
 	rx_urb = usb_alloc_urb(0, GFP_KERNEL);
-	if (!rx_urb) {
-		pr_err("usb_alloc_urb failed for IR urb\n");
+	if (!rx_urb)
 		goto rx_urb_alloc_failed;
-	}
 
 	mutex_lock(&ictx->lock);
 
-- 
2.8.1

