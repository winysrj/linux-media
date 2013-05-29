Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:3583 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965703Ab3E2LBO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 May 2013 07:01:14 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCHv1 31/38] cx231xx: the reg->size field wasn't filled in.
Date: Wed, 29 May 2013 13:00:04 +0200
Message-Id: <1369825211-29770-32-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1369825211-29770-1-git-send-email-hverkuil@xs4all.nl>
References: <1369825211-29770-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/usb/cx231xx/cx231xx-video.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/media/usb/cx231xx/cx231xx-video.c b/drivers/media/usb/cx231xx/cx231xx-video.c
index 54cdd4d..9906261 100644
--- a/drivers/media/usb/cx231xx/cx231xx-video.c
+++ b/drivers/media/usb/cx231xx/cx231xx-video.c
@@ -1272,36 +1272,43 @@ int cx231xx_g_register(struct file *file, void *priv,
 				(u16)reg->reg, value, 4);
 		reg->val = value[0] | value[1] << 8 |
 			value[2] << 16 | value[3] << 24;
+		reg->size = 4;
 		break;
 	case 1:	/* AFE - read byte */
 		ret = cx231xx_read_i2c_data(dev, AFE_DEVICE_ADDRESS,
 				(u16)reg->reg, 2, &data, 1);
 		reg->val = data;
+		reg->size = 1;
 		break;
 	case 2:	/* Video Block - read byte */
 		ret = cx231xx_read_i2c_data(dev, VID_BLK_I2C_ADDRESS,
 				(u16)reg->reg, 2, &data, 1);
 		reg->val = data;
+		reg->size = 1;
 		break;
 	case 3:	/* I2S block - read byte */
 		ret = cx231xx_read_i2c_data(dev, I2S_BLK_DEVICE_ADDRESS,
 				(u16)reg->reg, 1, &data, 1);
 		reg->val = data;
+		reg->size = 1;
 		break;
 	case 4: /* AFE - read dword */
 		ret = cx231xx_read_i2c_data(dev, AFE_DEVICE_ADDRESS,
 				(u16)reg->reg, 2, &data, 4);
 		reg->val = data;
+		reg->size = 4;
 		break;
 	case 5: /* Video Block - read dword */
 		ret = cx231xx_read_i2c_data(dev, VID_BLK_I2C_ADDRESS,
 				(u16)reg->reg, 2, &data, 4);
 		reg->val = data;
+		reg->size = 4;
 		break;
 	case 6: /* I2S Block - read dword */
 		ret = cx231xx_read_i2c_data(dev, I2S_BLK_DEVICE_ADDRESS,
 				(u16)reg->reg, 1, &data, 4);
 		reg->val = data;
+		reg->size = 4;
 		break;
 	default:
 		return -EINVAL;
-- 
1.7.10.4

