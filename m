Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55067 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932483AbcIEKcu (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Sep 2016 06:32:50 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Matthias Schwarzott <zzam@gentoo.org>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH v2 05/12] [media] cx231xx: fix PV SBTVD Hybrid AGC GPIO pin
Date: Mon,  5 Sep 2016 07:32:33 -0300
Message-Id: <52eb3ec40e8d1b896e70abd6c4fddf0af6b7bcde.1473071468.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473071468.git.mchehab@s-opensource.com>
References: <cover.1473071468.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473071468.git.mchehab@s-opensource.com>
References: <cover.1473071468.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

The AGC GPIO pin for this board is wrong. it should be GPIO 28
(0x1c).

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/cx231xx/cx231xx-cards.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
index c63248a18823..72c246bfaa1c 100644
--- a/drivers/media/usb/cx231xx/cx231xx-cards.c
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
@@ -486,7 +486,7 @@ struct cx231xx_board cx231xx_boards[] = {
 		.output_mode = OUT_MODE_VIP11,
 		.demod_xfer_mode = 0,
 		.ctl_pin_status_mask = 0xFFFFFFC4,
-		.agc_analog_digital_select_gpio = 0x00,	/* According with PV cxPolaris.inf file */
+		.agc_analog_digital_select_gpio = 0x1c,
 		.tuner_sif_gpio = -1,
 		.tuner_scl_gpio = -1,
 		.tuner_sda_gpio = -1,
-- 
2.7.4


