Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f41.google.com ([74.125.83.41]:53966 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517Ab3DHRGS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Apr 2013 13:06:18 -0400
Received: by mail-ee0-f41.google.com with SMTP id c1so2530225eek.0
        for <linux-media@vger.kernel.org>; Mon, 08 Apr 2013 10:06:17 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH] em28xx: save isoc endpoint number for DVB only if endpoint has alt settings with xMaxPacketSize != 0
Date: Mon,  8 Apr 2013 19:06:59 +0200
Message-Id: <1365440819-7864-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In addition to commit 72cc9ba3 "em28xx: ignore isoc DVB USB endpoints with
wMaxPacketSize = 0 bytes for all alt settings" we should not save the endpoint
number of the isoc DVB endpoint before it has been validated.
While the current code works fine, dev->dvb_ep_isoc != 0 could be interpreted
as indicator that the device provides DVB support.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c |    2 +-
 1 Datei geändert, 1 Zeile hinzugefügt(+), 1 Zeile entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 1d3866f..085b8fc 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -3217,9 +3217,9 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 							    e->bEndpointAddress;
 					} else {
 						if (usb_endpoint_xfer_isoc(e)) {
-							dev->dvb_ep_isoc = e->bEndpointAddress;
 							if (size > dev->dvb_max_pkt_size_isoc) {
 								has_dvb = true; /* see NOTE (~) */
+								dev->dvb_ep_isoc = e->bEndpointAddress;
 								dev->dvb_max_pkt_size_isoc = size;
 								dev->dvb_alt_isoc = i;
 							}
-- 
1.7.10.4

