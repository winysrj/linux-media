Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f172.google.com ([209.85.215.172]:52648 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933894Ab3AIUvx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Jan 2013 15:51:53 -0500
Received: by mail-ea0-f172.google.com with SMTP id f13so421856eaa.3
        for <linux-media@vger.kernel.org>; Wed, 09 Jan 2013 12:51:52 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org, dheitmueller@kernellabs.com,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [RFC PATCH] em28xx: fix analog streaming with USB bulk transfers
Date: Wed,  9 Jan 2013 21:52:11 +0100
Message-Id: <1357764731-4999-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

With the conversion to videobuf2, some unnecessary calls of
em28xx_set_alternate() have been removed. It is now called at analog streaming
start only.
This has unveiled a bug that causes USB bulk transfers to fail with all urbs
having status -EVOERFLOW.
The reason is, that for bulk transfers usb_set_interface() needs to be called
even if the previous alt setting was the same (side note: bulk transfers seem
to work only with alt=0).
While it seems to be NOT necessary for isoc transfers, it's reasonable to just
call usb_set_interface() unconditionally in em28xx_set_alternate().
Also add a comment that explains the issue to prevent regressions in the future.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-core.c |   43 ++++++++++++++++----------------
 1 Datei geändert, 22 Zeilen hinzugefügt(+), 21 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
index 80f87bb..ce4f252 100644
--- a/drivers/media/usb/em28xx/em28xx-core.c
+++ b/drivers/media/usb/em28xx/em28xx-core.c
@@ -811,12 +811,12 @@ int em28xx_resolution_set(struct em28xx *dev)
 /* Set USB alternate setting for analog video */
 int em28xx_set_alternate(struct em28xx *dev)
 {
-	int errCode, prev_alt = dev->alt;
+	int errCode;
 	int i;
 	unsigned int min_pkt_size = dev->width * 2 + 4;
 
 	/* NOTE: for isoc transfers, only alt settings > 0 are allowed
-		 for bulk transfers, use alt=0 as default value */
+		 bulk transfers seem to work only with alt=0 ! */
 	dev->alt = 0;
 	if ((alt > 0) && (alt < dev->num_alt)) {
 		em28xx_coredbg("alternate forced to %d\n", dev->alt);
@@ -847,25 +847,26 @@ int em28xx_set_alternate(struct em28xx *dev)
 	}
 
 set_alt:
-	if (dev->alt != prev_alt) {
-		if (dev->analog_xfer_bulk) {
-			dev->max_pkt_size = 512; /* USB 2.0 spec */
-			dev->packet_multiplier = EM28XX_BULK_PACKET_MULTIPLIER;
-		} else { /* isoc */
-			em28xx_coredbg("minimum isoc packet size: %u (alt=%d)\n",
-				       min_pkt_size, dev->alt);
-			dev->max_pkt_size =
-					  dev->alt_max_pkt_size_isoc[dev->alt];
-			dev->packet_multiplier = EM28XX_NUM_ISOC_PACKETS;
-		}
-		em28xx_coredbg("setting alternate %d with wMaxPacketSize=%u\n",
-			       dev->alt, dev->max_pkt_size);
-		errCode = usb_set_interface(dev->udev, 0, dev->alt);
-		if (errCode < 0) {
-			em28xx_errdev("cannot change alternate number to %d (error=%i)\n",
-					dev->alt, errCode);
-			return errCode;
-		}
+	/* NOTE: for bulk transfers, we need to call usb_set_interface()
+	 * even if the previous settings were the same. Otherwise streaming
+	 * fails with all urbs having status = -EOVERFLOW ! */
+	if (dev->analog_xfer_bulk) {
+		dev->max_pkt_size = 512; /* USB 2.0 spec */
+		dev->packet_multiplier = EM28XX_BULK_PACKET_MULTIPLIER;
+	} else { /* isoc */
+		em28xx_coredbg("minimum isoc packet size: %u (alt=%d)\n",
+			       min_pkt_size, dev->alt);
+		dev->max_pkt_size =
+				  dev->alt_max_pkt_size_isoc[dev->alt];
+		dev->packet_multiplier = EM28XX_NUM_ISOC_PACKETS;
+	}
+	em28xx_coredbg("setting alternate %d with wMaxPacketSize=%u\n",
+		       dev->alt, dev->max_pkt_size);
+	errCode = usb_set_interface(dev->udev, 0, dev->alt);
+	if (errCode < 0) {
+		em28xx_errdev("cannot change alternate number to %d (error=%i)\n",
+				dev->alt, errCode);
+		return errCode;
 	}
 	return 0;
 }
-- 
1.7.10.4

