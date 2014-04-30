Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48472 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757271AbaD3JgZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Apr 2014 05:36:25 -0400
Date: Wed, 30 Apr 2014 12:36:03 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org,
	Frank =?iso-8859-1?Q?Sch=E4fer?= <fschaefer.oss@googlemail.com>,
	kernel-janitors@vger.kernel.org
Subject: [patch v3] [media] em28xx-cards: fix indenting in probe()
Message-ID: <20140430093603.GA20713@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140307170110.GP4774@mwanda>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There was a mix of 4 space and tab indenting here which was confusing.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
v3: Just fix all the surrounding indents as well.
v2: At first I thought the code was buggy and was missing curly braces
    but it was just the indenting which was confusing.

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 50aa5a5..3744766 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -3416,14 +3416,14 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 
 	/* Select USB transfer types to use */
 	if (has_video) {
-	    if (!dev->analog_ep_isoc || (try_bulk && dev->analog_ep_bulk))
-		dev->analog_xfer_bulk = 1;
-	    em28xx_info("analog set to %s mode.\n",
-			dev->analog_xfer_bulk ? "bulk" : "isoc");
+		if (!dev->analog_ep_isoc || (try_bulk && dev->analog_ep_bulk))
+			dev->analog_xfer_bulk = 1;
+		em28xx_info("analog set to %s mode.\n",
+			    dev->analog_xfer_bulk ? "bulk" : "isoc");
 	}
 	if (has_dvb) {
-	    if (!dev->dvb_ep_isoc || (try_bulk && dev->dvb_ep_bulk))
-		dev->dvb_xfer_bulk = 1;
+		if (!dev->dvb_ep_isoc || (try_bulk && dev->dvb_ep_bulk))
+			dev->dvb_xfer_bulk = 1;
 
 		em28xx_info("dvb set to %s mode.\n",
 			    dev->dvb_xfer_bulk ? "bulk" : "isoc");
