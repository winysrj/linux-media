Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:65470 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756656Ab2KHTM6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Nov 2012 14:12:58 -0500
Received: by mail-ee0-f46.google.com with SMTP id b15so1754511eek.19
        for <linux-media@vger.kernel.org>; Thu, 08 Nov 2012 11:12:58 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH v2 21/21] em28xx: add module parameter for selection of the preferred USB transfer type
Date: Thu,  8 Nov 2012 20:11:53 +0200
Message-Id: <1352398313-3698-22-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1352398313-3698-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1352398313-3698-1-git-send-email-fschaefer.oss@googlemail.com>
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
 drivers/media/usb/em28xx/em28xx-cards.c |   11 +++++++++--
 1 Datei geändert, 9 Zeilen hinzugefügt(+), 2 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index a9344f0..7f5b303 100644
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
 
@@ -3334,9 +3339,11 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 	}
 
 	/* Select USB transfer types to use */
-	if (has_video && !dev->analog_ep_isoc)
+	if (has_video &&
+	    (!dev->analog_ep_isoc || (prefer_bulk && dev->analog_ep_bulk)))
 		dev->analog_xfer_bulk = 1;
-	if (has_dvb && !dev->dvb_ep_isoc)
+	if (has_dvb &&
+	    (!dev->dvb_ep_isoc || (prefer_bulk && dev->dvb_ep_bulk)))
 		dev->dvb_xfer_bulk = 1;
 
 	snprintf(dev->name, sizeof(dev->name), "em28xx #%d", nr);
-- 
1.7.10.4

