Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:48240 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbaCVNAd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Mar 2014 09:00:33 -0400
Received: by mail-ee0-f54.google.com with SMTP id d49so2745055eek.13
        for <linux-media@vger.kernel.org>; Sat, 22 Mar 2014 06:00:32 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 1/5] em28xx: fix indenting in em28xx_usb_probe()
Date: Sat, 22 Mar 2014 14:00:59 +0100
Message-Id: <1395493263-2158-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 50aa5a5..ff19833 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -3416,15 +3416,14 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 
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
-
+		if (!dev->dvb_ep_isoc || (try_bulk && dev->dvb_ep_bulk))
+			dev->dvb_xfer_bulk = 1;
 		em28xx_info("dvb set to %s mode.\n",
 			    dev->dvb_xfer_bulk ? "bulk" : "isoc");
 	}
-- 
1.8.4.5

