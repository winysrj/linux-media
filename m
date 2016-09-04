Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48181 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753791AbcIDOOI (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 4 Sep 2016 10:14:08 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Terry Heo <terryheo@google.com>, Peter Rosin <peda@axentia.se>
Subject: [PATCH 7/7] [media] cx231xx-core: fix GPIO comments
Date: Sun,  4 Sep 2016 11:13:59 -0300
Message-Id: <3a3bfcd1835249e7ec923d43fded6f00b468dafb.1472998424.git.mchehab@s-opensource.com>
In-Reply-To: <9a71d7985c758c3ac789ba50e407e4e81c269bcc.1472998424.git.mchehab@s-opensource.com>
References: <9a71d7985c758c3ac789ba50e407e4e81c269bcc.1472998424.git.mchehab@s-opensource.com>
In-Reply-To: <9a71d7985c758c3ac789ba50e407e4e81c269bcc.1472998424.git.mchehab@s-opensource.com>
References: <9a71d7985c758c3ac789ba50e407e4e81c269bcc.1472998424.git.mchehab@s-opensource.com>
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
index 44288f265a26..f5220e726523 100644
--- a/drivers/media/usb/cx231xx/cx231xx-core.c
+++ b/drivers/media/usb/cx231xx/cx231xx-core.c
@@ -1457,14 +1457,14 @@ int cx231xx_send_gpio_cmd(struct cx231xx *dev, u32 gpio_bit, u8 *gpio_val,
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

