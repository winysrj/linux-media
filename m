Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:36574 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750927AbdCMMyg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Mar 2017 08:54:36 -0400
From: Johan Hovold <johan@kernel.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>,
        Sri Deevi <Srinivasa.Deevi@conexant.com>
Subject: [PATCH 5/6] [media] cx231xx-audio: fix NULL-deref at probe
Date: Mon, 13 Mar 2017 13:53:58 +0100
Message-Id: <20170313125359.29394-6-johan@kernel.org>
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
 drivers/media/usb/cx231xx/cx231xx-audio.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-audio.c b/drivers/media/usb/cx231xx/cx231xx-audio.c
index f3729d6eb46a..a050d125934c 100644
--- a/drivers/media/usb/cx231xx/cx231xx-audio.c
+++ b/drivers/media/usb/cx231xx/cx231xx-audio.c
@@ -697,6 +697,11 @@ static int cx231xx_audio_init(struct cx231xx *dev)
 					    hs_config_info[0].interface_info.
 					    audio_index + 1];
 
+	if (uif->altsetting[0].desc.bNumEndpoints < isoc_pipe + 1) {
+		err = -ENODEV;
+		goto err_free_card;
+	}
+
 	adev->end_point_addr =
 	    uif->altsetting[0].endpoint[isoc_pipe].desc.
 			bEndpointAddress;
@@ -712,8 +717,14 @@ static int cx231xx_audio_init(struct cx231xx *dev)
 	}
 
 	for (i = 0; i < adev->num_alt; i++) {
-		u16 tmp =
-		    le16_to_cpu(uif->altsetting[i].endpoint[isoc_pipe].desc.
+		u16 tmp;
+
+		if (uif->altsetting[i].desc.bNumEndpoints < isoc_pipe + 1) {
+			err = -ENODEV;
+			goto err_free_pkt_size;
+		}
+
+		tmp = le16_to_cpu(uif->altsetting[i].endpoint[isoc_pipe].desc.
 				wMaxPacketSize);
 		adev->alt_max_pkt_size[i] =
 		    (tmp & 0x07ff) * (((tmp & 0x1800) >> 11) + 1);
@@ -724,6 +735,8 @@ static int cx231xx_audio_init(struct cx231xx *dev)
 
 	return 0;
 
+err_free_pkt_size:
+	kfree(adev->alt_max_pkt_size);
 err_free_card:
 	snd_card_free(card);
 
-- 
2.12.0
