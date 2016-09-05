Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55035 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933114AbcIEKcs (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Sep 2016 06:32:48 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Terry Heo <terryheo@google.com>, Peter Rosin <peda@axentia.se>
Subject: [PATCH v2 07/12] [media] cx231xx-core: fix GPIO comments
Date: Mon,  5 Sep 2016 07:32:35 -0300
Message-Id: <5a8a71964aef333bdd7cdc601ce694af82d0b87f.1473071468.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473071468.git.mchehab@s-opensource.com>
References: <cover.1473071468.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473071468.git.mchehab@s-opensource.com>
References: <cover.1473071468.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The number of the cx231xx REQ for GPIO register set/get are wrong.
They should follow what's there at cx231xx-pcb-cfg.h.

Noticed while checking the cx231xx parser at the v4l-utils.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/cx231xx/cx231xx-core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-core.c b/drivers/media/usb/cx231xx/cx231xx-core.c
index 4b3acbd1d7f0..68b0df2814cf 100644
--- a/drivers/media/usb/cx231xx/cx231xx-core.c
+++ b/drivers/media/usb/cx231xx/cx231xx-core.c
@@ -1460,14 +1460,14 @@ int cx231xx_send_gpio_cmd(struct cx231xx *dev, u32 gpio_bit, u8 *gpio_val,
 	/* set request */
 	if (!request) {
 		if (direction)
-			ven_req.bRequest = VRT_GET_GPIO;	/* 0x8 gpio */
+			ven_req.bRequest = VRT_GET_GPIO;	/* 0x9 gpio */
 		else
-			ven_req.bRequest = VRT_SET_GPIO;	/* 0x9 gpio */
+			ven_req.bRequest = VRT_SET_GPIO;	/* 0x8 gpio */
 	} else {
 		if (direction)
-			ven_req.bRequest = VRT_GET_GPIE;	/* 0xa gpie */
+			ven_req.bRequest = VRT_GET_GPIE;	/* 0xb gpie */
 		else
-			ven_req.bRequest = VRT_SET_GPIE;	/* 0xb gpie */
+			ven_req.bRequest = VRT_SET_GPIE;	/* 0xa gpie */
 	}
 
 	/* set index value */
-- 
2.7.4


