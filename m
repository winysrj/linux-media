Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48173 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752837AbcIDOOH (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 4 Sep 2016 10:14:07 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Terry Heo <terryheo@google.com>, Peter Rosin <peda@axentia.se>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH 2/7] [media] cx231xx: fix GPIOs for Pixelview SBTVD hybrid
Date: Sun,  4 Sep 2016 11:13:54 -0300
Message-Id: <7dc123eceb1844dcf396a4b77d0a896cdbef5d9e.1472998424.git.mchehab@s-opensource.com>
In-Reply-To: <9a71d7985c758c3ac789ba50e407e4e81c269bcc.1472998424.git.mchehab@s-opensource.com>
References: <9a71d7985c758c3ac789ba50e407e4e81c269bcc.1472998424.git.mchehab@s-opensource.com>
In-Reply-To: <9a71d7985c758c3ac789ba50e407e4e81c269bcc.1472998424.git.mchehab@s-opensource.com>
References: <9a71d7985c758c3ac789ba50e407e4e81c269bcc.1472998424.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

This device uses GPIOs: 28 to switch between analog and
digital modes: on digital mode, it should be set to 1.

The code that sets it on analog mode is OK, but it misses
the logic that sets it on digital mode.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/cx231xx/cx231xx-core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-core.c b/drivers/media/usb/cx231xx/cx231xx-core.c
index 630f4fc5155f..6c8f825452dd 100644
--- a/drivers/media/usb/cx231xx/cx231xx-core.c
+++ b/drivers/media/usb/cx231xx/cx231xx-core.c
@@ -712,6 +712,7 @@ int cx231xx_set_mode(struct cx231xx *dev, enum cx231xx_mode set_mode)
 			break;
 		case CX231XX_BOARD_CNXT_RDE_253S:
 		case CX231XX_BOARD_CNXT_RDU_253S:
+		case CX231XX_BOARD_PV_PLAYTV_USB_HYBRID:
 			errCode = cx231xx_set_agc_analog_digital_mux_select(dev, 1);
 			break;
 		case CX231XX_BOARD_HAUPPAUGE_EXETER:
@@ -738,7 +739,7 @@ int cx231xx_set_mode(struct cx231xx *dev, enum cx231xx_mode set_mode)
 		case CX231XX_BOARD_PV_PLAYTV_USB_HYBRID:
 		case CX231XX_BOARD_HAUPPAUGE_USB2_FM_PAL:
 		case CX231XX_BOARD_HAUPPAUGE_USB2_FM_NTSC:
-		errCode = cx231xx_set_agc_analog_digital_mux_select(dev, 0);
+			errCode = cx231xx_set_agc_analog_digital_mux_select(dev, 0);
 			break;
 		default:
 			break;
-- 
2.7.4

