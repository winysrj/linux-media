Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:57147 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932461Ab2JURxl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Oct 2012 13:53:41 -0400
Received: by mail-wg0-f44.google.com with SMTP id dr13so1632849wgb.1
        for <linux-media@vger.kernel.org>; Sun, 21 Oct 2012 10:53:41 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 15/23] em28xx: rename function em28xx_dvb_isoc_copy and extend for USB bulk transfers
Date: Sun, 21 Oct 2012 19:52:21 +0300
Message-Id: <1350838349-14763-17-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1350838349-14763-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1350838349-14763-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The URB data processing for DVB bulk transfers is very similar to
what is done with isoc transfers, so create a common function that
works with both transfer types based on the existing isoc function.

This patch has been compilation tested only, because I don't have
a DVB device !

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-dvb.c |   44 +++++++++++++++++++++++----------
 1 Datei geändert, 31 Zeilen hinzugefügt(+), 13 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index b47e164..cd36a67 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -10,6 +10,8 @@
 
  (c) 2008 Aidan Thornton <makosoft@googlemail.com>
 
+ (c) 2012 Frank Schäfer <fschaefer.oss@googlemail.com>
+
  Based on cx88-dvb, saa7134-dvb and videobuf-dvb originally written by:
 	(c) 2004, 2005 Chris Pascoe <c.pascoe@itee.uq.edu.au>
 	(c) 2004 Gerd Knorr <kraxel@bytesex.org> [SuSE Labs]
@@ -124,9 +126,9 @@ static inline void print_err_status(struct em28xx *dev,
 	}
 }
 
-static inline int em28xx_dvb_isoc_copy(struct em28xx *dev, struct urb *urb)
+static inline int em28xx_dvb_urb_data_copy(struct em28xx *dev, struct urb *urb)
 {
-	int i;
+	int xfer_bulk, num_packets, i;
 
 	if (!dev)
 		return 0;
@@ -137,18 +139,34 @@ static inline int em28xx_dvb_isoc_copy(struct em28xx *dev, struct urb *urb)
 	if (urb->status < 0)
 		print_err_status(dev, -1, urb->status);
 
-	for (i = 0; i < urb->number_of_packets; i++) {
-		int status = urb->iso_frame_desc[i].status;
+	xfer_bulk = usb_pipebulk(urb->pipe);
 
-		if (status < 0) {
-			print_err_status(dev, i, status);
-			if (urb->iso_frame_desc[i].status != -EPROTO)
-				continue;
-		}
+	if (xfer_bulk) /* bulk */
+		num_packets = 1;
+	else /* isoc */
+		num_packets = urb->number_of_packets;
 
-		dvb_dmx_swfilter(&dev->dvb->demux, urb->transfer_buffer +
-				 urb->iso_frame_desc[i].offset,
-				 urb->iso_frame_desc[i].actual_length);
+	for (i = 0; i < num_packets; i++) {
+		if (xfer_bulk) {
+			if (urb->status < 0) {
+				print_err_status(dev, i, urb->status);
+				if (urb->status != -EPROTO)
+					continue;
+			}
+			dvb_dmx_swfilter(&dev->dvb->demux, urb->transfer_buffer,
+					urb->actual_length);
+		} else {
+			if (urb->iso_frame_desc[i].status < 0) {
+				print_err_status(dev, i,
+						 urb->iso_frame_desc[i].status);
+				if (urb->iso_frame_desc[i].status != -EPROTO)
+					continue;
+			}
+			dvb_dmx_swfilter(&dev->dvb->demux,
+					 urb->transfer_buffer +
+					 urb->iso_frame_desc[i].offset,
+					 urb->iso_frame_desc[i].actual_length);
+		}
 	}
 
 	return 0;
@@ -177,7 +195,7 @@ static int em28xx_start_streaming(struct em28xx_dvb *dvb)
 				    EM28XX_DVB_NUM_BUFS,
 				    max_dvb_packet_size,
 				    EM28XX_DVB_NUM_ISOC_PACKETS,
-				    em28xx_dvb_isoc_copy);
+				    em28xx_dvb_urb_data_copy);
 }
 
 static int em28xx_stop_streaming(struct em28xx_dvb *dvb)
-- 
1.7.10.4

