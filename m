Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:35819 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750907AbdCMMyg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Mar 2017 08:54:36 -0400
From: Johan Hovold <johan@kernel.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>,
        Sri Deevi <Srinivasa.Deevi@conexant.com>
Subject: [PATCH 3/6] [media] cx231xx-cards: fix NULL-deref at probe
Date: Mon, 13 Mar 2017 13:53:56 +0100
Message-Id: <20170313125359.29394-4-johan@kernel.org>
In-Reply-To: <20170313125359.29394-1-johan@kernel.org>
References: <20170313125359.29394-1-johan@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make sure to check the number of endpoints to avoid dereferencing a
NULL-pointer or accessing memory beyond the endpoint array should a
malicious device lack the expected endpoints.

Fixes: e0d3bafd0258 ("V4L/DVB (10954): Add cx231xx USB driver")
Cc: stable <stable@vger.kernel.org>     # 2.6.30
Cc: Sri Deevi <Srinivasa.Deevi@conexant.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/media/usb/cx231xx/cx231xx-cards.c | 45 +++++++++++++++++++++++++++----
 1 file changed, 40 insertions(+), 5 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
index f730fdbc9156..f850267a0095 100644
--- a/drivers/media/usb/cx231xx/cx231xx-cards.c
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
@@ -1426,6 +1426,9 @@ static int cx231xx_init_v4l2(struct cx231xx *dev,
 
 	uif = udev->actconfig->interface[idx];
 
+	if (uif->altsetting[0].desc.bNumEndpoints < isoc_pipe + 1)
+		return -ENODEV;
+
 	dev->video_mode.end_point_addr = uif->altsetting[0].endpoint[isoc_pipe].desc.bEndpointAddress;
 	dev->video_mode.num_alt = uif->num_altsetting;
 
@@ -1439,7 +1442,12 @@ static int cx231xx_init_v4l2(struct cx231xx *dev,
 		return -ENOMEM;
 
 	for (i = 0; i < dev->video_mode.num_alt; i++) {
-		u16 tmp = le16_to_cpu(uif->altsetting[i].endpoint[isoc_pipe].desc.wMaxPacketSize);
+		u16 tmp;
+
+		if (uif->altsetting[i].desc.bNumEndpoints < isoc_pipe + 1)
+			return -ENODEV;
+
+		tmp = le16_to_cpu(uif->altsetting[i].endpoint[isoc_pipe].desc.wMaxPacketSize);
 		dev->video_mode.alt_max_pkt_size[i] = (tmp & 0x07ff) * (((tmp & 0x1800) >> 11) + 1);
 		dev_dbg(dev->dev,
 			"Alternate setting %i, max size= %i\n", i,
@@ -1456,6 +1464,9 @@ static int cx231xx_init_v4l2(struct cx231xx *dev,
 	}
 	uif = udev->actconfig->interface[idx];
 
+	if (uif->altsetting[0].desc.bNumEndpoints < isoc_pipe + 1)
+		return -ENODEV;
+
 	dev->vbi_mode.end_point_addr =
 	    uif->altsetting[0].endpoint[isoc_pipe].desc.
 			bEndpointAddress;
@@ -1472,8 +1483,12 @@ static int cx231xx_init_v4l2(struct cx231xx *dev,
 		return -ENOMEM;
 
 	for (i = 0; i < dev->vbi_mode.num_alt; i++) {
-		u16 tmp =
-		    le16_to_cpu(uif->altsetting[i].endpoint[isoc_pipe].
+		u16 tmp;
+
+		if (uif->altsetting[i].desc.bNumEndpoints < isoc_pipe + 1)
+			return -ENODEV;
+
+		tmp = le16_to_cpu(uif->altsetting[i].endpoint[isoc_pipe].
 				desc.wMaxPacketSize);
 		dev->vbi_mode.alt_max_pkt_size[i] =
 		    (tmp & 0x07ff) * (((tmp & 0x1800) >> 11) + 1);
@@ -1493,6 +1508,9 @@ static int cx231xx_init_v4l2(struct cx231xx *dev,
 	}
 	uif = udev->actconfig->interface[idx];
 
+	if (uif->altsetting[0].desc.bNumEndpoints < isoc_pipe + 1)
+		return -ENODEV;
+
 	dev->sliced_cc_mode.end_point_addr =
 	    uif->altsetting[0].endpoint[isoc_pipe].desc.
 			bEndpointAddress;
@@ -1507,7 +1525,12 @@ static int cx231xx_init_v4l2(struct cx231xx *dev,
 		return -ENOMEM;
 
 	for (i = 0; i < dev->sliced_cc_mode.num_alt; i++) {
-		u16 tmp = le16_to_cpu(uif->altsetting[i].endpoint[isoc_pipe].
+		u16 tmp;
+
+		if (uif->altsetting[i].desc.bNumEndpoints < isoc_pipe + 1)
+			return -ENODEV;
+
+		tmp = le16_to_cpu(uif->altsetting[i].endpoint[isoc_pipe].
 				desc.wMaxPacketSize);
 		dev->sliced_cc_mode.alt_max_pkt_size[i] =
 		    (tmp & 0x07ff) * (((tmp & 0x1800) >> 11) + 1);
@@ -1676,6 +1699,11 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 		}
 		uif = udev->actconfig->interface[idx];
 
+		if (uif->altsetting[0].desc.bNumEndpoints < isoc_pipe + 1) {
+			retval = -ENODEV;
+			goto err_video_alt;
+		}
+
 		dev->ts1_mode.end_point_addr =
 		    uif->altsetting[0].endpoint[isoc_pipe].
 				desc.bEndpointAddress;
@@ -1693,7 +1721,14 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 		}
 
 		for (i = 0; i < dev->ts1_mode.num_alt; i++) {
-			u16 tmp = le16_to_cpu(uif->altsetting[i].
+			u16 tmp;
+
+			if (uif->altsetting[i].desc.bNumEndpoints < isoc_pipe + 1) {
+				retval = -ENODEV;
+				goto err_video_alt;
+			}
+
+			tmp = le16_to_cpu(uif->altsetting[i].
 						endpoint[isoc_pipe].desc.
 						wMaxPacketSize);
 			dev->ts1_mode.alt_max_pkt_size[i] =
-- 
2.12.0
