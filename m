Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f178.google.com ([209.85.215.178]:57743 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754282Ab3C0UGy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Mar 2013 16:06:54 -0400
Received: by mail-ea0-f178.google.com with SMTP id o10so480522eaj.23
        for <linux-media@vger.kernel.org>; Wed, 27 Mar 2013 13:06:52 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: timo.teras@iki.fi, linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>,
	stable@kernel.org
Subject: [PATCH] em28xx: ignore isoc DVB USB endpoints with wMaxPacketSize = 0 bytes for all alt settings
Date: Wed, 27 Mar 2013 21:07:41 +0100
Message-Id: <1364414861-7233-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some devices without DVB support (such as the "Terratec Grabby" and
"Easycap DC-60") provide isochronous DVB USB endpoints with wMaxPacketSize set
to 0 bytes for all alt settings.

Ignore these endpoints and avoid registering a DVB device node and loading the
DVB driver extension.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
Cc: stable@kernel.org
---
 drivers/media/usb/em28xx/em28xx-cards.c |    9 ++++++++-
 1 Datei geändert, 8 Zeilen hinzugefügt(+), 1 Zeile entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 54e0362..94536ee 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -3357,14 +3357,15 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 						dev->analog_ep_bulk =
 							    e->bEndpointAddress;
 					} else {
-						has_dvb = true;
 						if (usb_endpoint_xfer_isoc(e)) {
 							dev->dvb_ep_isoc = e->bEndpointAddress;
 							if (size > dev->dvb_max_pkt_size_isoc) {
+								has_dvb = true; /* see NOTE (~) */
 								dev->dvb_max_pkt_size_isoc = size;
 								dev->dvb_alt_isoc = i;
 							}
 						} else {
+							has_dvb = true;
 							dev->dvb_ep_bulk = e->bEndpointAddress;
 						}
 					}
@@ -3391,6 +3392,12 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 			 * so far. But there might be devices for which this
 			 * logic is not sufficient...
 			 */
+			/* 
+			 * NOTE (~): some manufacturers (e.g. Terratec) disable
+			 * endpoints by setting wMaxPacketSize to 0 bytes for
+			 * all alt settings. So far, we've seen this for 
+			 * DVB isoc endpoints only.
+			 */
 		}
 	}
 
-- 
1.7.10.4

