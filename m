Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:50454 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932529Ab2JURxu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Oct 2012 13:53:50 -0400
Received: by mail-wg0-f44.google.com with SMTP id dr13so1633030wgb.1
        for <linux-media@vger.kernel.org>; Sun, 21 Oct 2012 10:53:48 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 21/23] em28xx: add module parameter for selection of the preferred USB transfer type
Date: Sun, 21 Oct 2012 19:52:27 +0300
Message-Id: <1350838349-14763-23-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1350838349-14763-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1350838349-14763-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

By default, isoc transfers are used if possible.
With the new module parameter, bulk can be selected as the
preferred USB transfer type.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c |    9 +++++++--
 1 Datei geändert, 7 Zeilen hinzugefügt(+), 2 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 751e408..410ed8d 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -61,6 +61,11 @@ static unsigned int card[]     = {[0 ... (EM28XX_MAXBOARDS - 1)] = UNSET };
 module_param_array(card,  int, NULL, 0444);
 MODULE_PARM_DESC(card,     "card type");
 
+static unsigned int prefer_bulk;
+module_param(prefer_bulk, int, 0644);
+MODULE_PARM_DESC(prefer_bulk, "prefer USB bulk transfers");
+
+
 /* Bitmask marking allocated devices from 0 to EM28XX_MAXBOARDS - 1 */
 static unsigned long em28xx_devused;
 
@@ -3325,9 +3330,9 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 	}
 
 	/* Select USB transfer types to use */
-	if (has_video && !dev->analog_ep_isoc)
+	if (has_video && (!dev->analog_ep_isoc || prefer_bulk))
 		dev->analog_xfer_bulk = 1;
-	if (has_dvb && !dev->dvb_ep_isoc)
+	if (has_dvb && (!dev->dvb_ep_isoc || prefer_bulk))
 		dev->dvb_xfer_bulk = 1;
 
 	snprintf(dev->name, sizeof(dev->name), "em28xx #%d", nr);
-- 
1.7.10.4

