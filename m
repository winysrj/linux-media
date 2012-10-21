Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:52190 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932517Ab2JURxq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Oct 2012 13:53:46 -0400
Received: by mail-we0-f174.google.com with SMTP id t9so1066948wey.19
        for <linux-media@vger.kernel.org>; Sun, 21 Oct 2012 10:53:45 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 19/23] em28xx: set USB alternate settings for analog video bulk transfers properly
Date: Sun, 21 Oct 2012 19:52:25 +0300
Message-Id: <1350838349-14763-21-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1350838349-14763-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1350838349-14763-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Extend function em28xx_set_alternate:
- use alternate setting 0 for bulk transfers as default
- respect module parameter 'alt'=0 for bulk transfers
- set max_packet_size to 512 bytes for bulk transfers

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-core.c |   23 +++++++++++++++--------
 1 Datei geändert, 15 Zeilen hinzugefügt(+), 8 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
index 6b588e2..06d5734 100644
--- a/drivers/media/usb/em28xx/em28xx-core.c
+++ b/drivers/media/usb/em28xx/em28xx-core.c
@@ -805,21 +805,23 @@ int em28xx_resolution_set(struct em28xx *dev)
 	return em28xx_scaler_set(dev, dev->hscale, dev->vscale);
 }
 
+/* Set USB alternate setting for analog video */
 int em28xx_set_alternate(struct em28xx *dev)
 {
 	int errCode, prev_alt = dev->alt;
 	int i;
 	unsigned int min_pkt_size = dev->width * 2 + 4;
 
-	/*
-	 * alt = 0 is used only for control messages, so, only values
-	 * greater than 0 can be used for streaming.
-	 */
-	if (alt && alt < dev->num_alt) {
+	/* NOTE: for isoc transfers, only alt settings > 0 are allowed
+		 for bulk transfers, use alt=0 as default value */
+	dev->alt = 0;
+	if ((alt > 0) && (alt < dev->num_alt)) {
 		em28xx_coredbg("alternate forced to %d\n", dev->alt);
 		dev->alt = alt;
 		goto set_alt;
 	}
+	if (dev->analog_xfer_bulk)
+		goto set_alt;
 
 	/* When image size is bigger than a certain value,
 	   the frame size should be increased, otherwise, only
@@ -843,9 +845,14 @@ int em28xx_set_alternate(struct em28xx *dev)
 
 set_alt:
 	if (dev->alt != prev_alt) {
-		em28xx_coredbg("minimum isoc packet size: %u (alt=%d)\n",
-				min_pkt_size, dev->alt);
-		dev->max_pkt_size = dev->alt_max_pkt_size_isoc[dev->alt];
+		if (dev->analog_xfer_bulk) {
+			dev->max_pkt_size = 512; /* USB 2.0 spec */
+		} else { /* isoc */
+			em28xx_coredbg("minimum isoc packet size: "
+				       "%u (alt=%d)\n", min_pkt_size, dev->alt);
+			dev->max_pkt_size =
+					  dev->alt_max_pkt_size_isoc[dev->alt];
+		}
 		em28xx_coredbg("setting alternate %d with wMaxPacketSize=%u\n",
 			       dev->alt, dev->max_pkt_size);
 		errCode = usb_set_interface(dev->udev, 0, dev->alt);
-- 
1.7.10.4

