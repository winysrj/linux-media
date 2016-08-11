Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.zeus03.de ([194.117.254.33]:56230 "EHLO mail.zeus03.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932329AbcHKVLW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Aug 2016 17:11:22 -0400
From: Wolfram Sang <wsa-dev@sang-engineering.com>
To: linux-usb@vger.kernel.org
Cc: Wolfram Sang <wsa-dev@sang-engineering.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	linux-media@vger.kernel.org
Subject: [PATCH 12/28] media: usb: dvb-usb: dib0700_core: don't print error when allocating urb fails
Date: Thu, 11 Aug 2016 23:03:48 +0200
Message-Id: <1470949451-24823-13-git-send-email-wsa-dev@sang-engineering.com>
In-Reply-To: <1470949451-24823-1-git-send-email-wsa-dev@sang-engineering.com>
References: <1470949451-24823-1-git-send-email-wsa-dev@sang-engineering.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

kmalloc will print enough information in case of failure.

Signed-off-by: Wolfram Sang <wsa-dev@sang-engineering.com>
---
 drivers/media/usb/dvb-usb/dib0700_core.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/dib0700_core.c b/drivers/media/usb/dvb-usb/dib0700_core.c
index bf890c3d9cda02..26797979ebce4b 100644
--- a/drivers/media/usb/dvb-usb/dib0700_core.c
+++ b/drivers/media/usb/dvb-usb/dib0700_core.c
@@ -783,10 +783,8 @@ int dib0700_rc_setup(struct dvb_usb_device *d, struct usb_interface *intf)
 	/* Starting in firmware 1.20, the RC info is provided on a bulk pipe */
 
 	purb = usb_alloc_urb(0, GFP_KERNEL);
-	if (purb == NULL) {
-		err("rc usb alloc urb failed");
+	if (purb == NULL)
 		return -ENOMEM;
-	}
 
 	purb->transfer_buffer = kzalloc(RC_MSG_SIZE_V1_20, GFP_KERNEL);
 	if (purb->transfer_buffer == NULL) {
-- 
2.8.1

