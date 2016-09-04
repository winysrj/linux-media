Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48172 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752979AbcIDOOH (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 4 Sep 2016 10:14:07 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Matthias Schwarzott <zzam@gentoo.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH 5/7] [media] cx231xx: fix PV SBTVD Hybrid AGC GPIO pin
Date: Sun,  4 Sep 2016 11:13:57 -0300
Message-Id: <fd945f1d7b8536951c7116d84f7a100dd82d712b.1472998424.git.mchehab@s-opensource.com>
In-Reply-To: <9a71d7985c758c3ac789ba50e407e4e81c269bcc.1472998424.git.mchehab@s-opensource.com>
References: <9a71d7985c758c3ac789ba50e407e4e81c269bcc.1472998424.git.mchehab@s-opensource.com>
In-Reply-To: <9a71d7985c758c3ac789ba50e407e4e81c269bcc.1472998424.git.mchehab@s-opensource.com>
References: <9a71d7985c758c3ac789ba50e407e4e81c269bcc.1472998424.git.mchehab@s-opensource.com>
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

