Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:21580 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755028AbaCELLI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Mar 2014 06:11:08 -0500
Date: Wed, 5 Mar 2014 14:09:37 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch v2] [patch] [media] em28xx-cards: remove a wrong indent level
Message-ID: <20140305110937.GC16926@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <530B8995.8030807@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This code is correct but the indenting is wrong and triggers a static
checker warning "add curly braces?".

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
v2: in v1 I added curly braces.

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 4d97a76cc3b0..33f06ffec4b2 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -3331,8 +3331,8 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 	if (has_video) {
 	    if (!dev->analog_ep_isoc || (try_bulk && dev->analog_ep_bulk))
 		dev->analog_xfer_bulk = 1;
-		em28xx_info("analog set to %s mode.\n",
-			    dev->analog_xfer_bulk ? "bulk" : "isoc");
+	    em28xx_info("analog set to %s mode.\n",
+			dev->analog_xfer_bulk ? "bulk" : "isoc");
 	}
 	if (has_dvb) {
 	    if (!dev->dvb_ep_isoc || (try_bulk && dev->dvb_ep_bulk))
