Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:35816 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750814AbdCMMye (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Mar 2017 08:54:34 -0400
From: Johan Hovold <johan@kernel.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>,
        Thierry MERLE <thierry.merle@free.fr>
Subject: [PATCH 2/6] [media] usbvision: fix NULL-deref at probe
Date: Mon, 13 Mar 2017 13:53:55 +0100
Message-Id: <20170313125359.29394-3-johan@kernel.org>
In-Reply-To: <20170313125359.29394-1-johan@kernel.org>
References: <20170313125359.29394-1-johan@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make sure to check the number of endpoints to avoid dereferencing a
NULL-pointer or accessing memory beyond the endpoint array should a
malicious device lack the expected endpoints.

Fixes: 2a9f8b5d25be ("V4L/DVB (5206): Usbvision: set alternate interface
modification")
Cc: stable <stable@vger.kernel.org>     # 2.6.21
Cc: Thierry MERLE <thierry.merle@free.fr>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/media/usb/usbvision/usbvision-video.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/usbvision/usbvision-video.c b/drivers/media/usb/usbvision/usbvision-video.c
index f5c635a67d74..f9c3325aa4d4 100644
--- a/drivers/media/usb/usbvision/usbvision-video.c
+++ b/drivers/media/usb/usbvision/usbvision-video.c
@@ -1501,7 +1501,14 @@ static int usbvision_probe(struct usb_interface *intf,
 	}
 
 	for (i = 0; i < usbvision->num_alt; i++) {
-		u16 tmp = le16_to_cpu(uif->altsetting[i].endpoint[1].desc.
+		u16 tmp;
+
+		if (uif->altsetting[i].desc.bNumEndpoints < 2) {
+			ret = -ENODEV;
+			goto err_pkt;
+		}
+
+		tmp = le16_to_cpu(uif->altsetting[i].endpoint[1].desc.
 				      wMaxPacketSize);
 		usbvision->alt_max_pkt_size[i] =
 			(tmp & 0x07ff) * (((tmp & 0x1800) >> 11) + 1);
-- 
2.12.0
