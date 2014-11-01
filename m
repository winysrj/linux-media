Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55258 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759129AbaKANjG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 1 Nov 2014 09:39:06 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Matthias Schwarzott <zzam@gentoo.org>,
	Antti Palosaari <crope@iki.fi>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/7] [media] cx231xx: Fix identation
Date: Sat,  1 Nov 2014 11:38:54 -0200
Message-Id: <452a20d01e80c6bc96b94dd642e10ce589e53af7.1414849031.git.mchehab@osg.samsung.com>
In-Reply-To: <1414849139-29609-1-git-send-email-mchehab@osg.samsung.com>
References: <1414849139-29609-1-git-send-email-mchehab@osg.samsung.com>
In-Reply-To: <cover.1414849031.git.mchehab@osg.samsung.com>
References: <cover.1414849031.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

One of the identation blocks is wrong. Fix it.

While here, replace pr_info by pr_debug inside such block and
add the function name to the print messages, as otherwise they
will not help much.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/usb/cx231xx/cx231xx-avcore.c b/drivers/media/usb/cx231xx/cx231xx-avcore.c
index 9185b05b4fbe..036ffdde6e89 100644
--- a/drivers/media/usb/cx231xx/cx231xx-avcore.c
+++ b/drivers/media/usb/cx231xx/cx231xx-avcore.c
@@ -2534,34 +2534,33 @@ int cx231xx_initialize_stream_xfer(struct cx231xx *dev, u32 media_type)
 			break;
 
 		case TS1_serial_mode:
-			pr_info("%s: set ts1 registers", __func__);
+			pr_debug("%s: set ts1 registers", __func__);
 
-		if (dev->board.has_417) {
-			pr_info(" MPEG\n");
-			value &= 0xFFFFFFFC;
-			value |= 0x3;
+			if (dev->board.has_417) {
+				pr_debug("%s: MPEG\n", __func__);
+				value &= 0xFFFFFFFC;
+				value |= 0x3;
 
-			status = cx231xx_mode_register(dev, TS_MODE_REG, value);
+				status = cx231xx_mode_register(dev, TS_MODE_REG, value);
 
-			val[0] = 0x04;
-			val[1] = 0xA3;
-			val[2] = 0x3B;
-			val[3] = 0x00;
-			status = cx231xx_write_ctrl_reg(dev, VRT_SET_REGISTER,
-				 TS1_CFG_REG, val, 4);
+				val[0] = 0x04;
+				val[1] = 0xA3;
+				val[2] = 0x3B;
+				val[3] = 0x00;
+				status = cx231xx_write_ctrl_reg(dev, VRT_SET_REGISTER,
+					 TS1_CFG_REG, val, 4);
 
-			val[0] = 0x00;
-			val[1] = 0x08;
-			val[2] = 0x00;
-			val[3] = 0x08;
-			status = cx231xx_write_ctrl_reg(dev, VRT_SET_REGISTER,
-				 TS1_LENGTH_REG, val, 4);
-
-		} else {
-			pr_info(" BDA\n");
-			status = cx231xx_mode_register(dev, TS_MODE_REG, 0x101);
-			status = cx231xx_mode_register(dev, TS1_CFG_REG, 0x010);
-		}
+				val[0] = 0x00;
+				val[1] = 0x08;
+				val[2] = 0x00;
+				val[3] = 0x08;
+				status = cx231xx_write_ctrl_reg(dev, VRT_SET_REGISTER,
+					 TS1_LENGTH_REG, val, 4);
+			} else {
+				pr_debug("%s: BDA\n", __func__);
+				status = cx231xx_mode_register(dev, TS_MODE_REG, 0x101);
+				status = cx231xx_mode_register(dev, TS1_CFG_REG, 0x010);
+			}
 			break;
 
 		case TS1_parallel_mode:
-- 
1.9.3

