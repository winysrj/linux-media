Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:3838 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965643Ab3E2LJM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 May 2013 07:09:12 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCHv1 10/38] cx231xx: remove g_chip_ident.
Date: Wed, 29 May 2013 12:59:43 +0200
Message-Id: <1369825211-29770-11-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1369825211-29770-1-git-send-email-hverkuil@xs4all.nl>
References: <1369825211-29770-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Remove g_chip_ident and replace it with g_chip_info.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/usb/cx231xx/cx231xx-417.c    |    1 -
 drivers/media/usb/cx231xx/cx231xx-avcore.c |    1 -
 drivers/media/usb/cx231xx/cx231xx-cards.c  |    1 -
 drivers/media/usb/cx231xx/cx231xx-vbi.c    |    1 -
 drivers/media/usb/cx231xx/cx231xx-video.c  |  417 +++++++---------------------
 drivers/media/usb/cx231xx/cx231xx.h        |    2 +-
 6 files changed, 103 insertions(+), 320 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-417.c b/drivers/media/usb/cx231xx/cx231xx-417.c
index f548db8..2f63029 100644
--- a/drivers/media/usb/cx231xx/cx231xx-417.c
+++ b/drivers/media/usb/cx231xx/cx231xx-417.c
@@ -1840,7 +1840,6 @@ static const struct v4l2_ioctl_ops mpeg_ioctl_ops = {
 	.vidioc_streamon	 = vidioc_streamon,
 	.vidioc_streamoff	 = vidioc_streamoff,
 	.vidioc_log_status	 = vidioc_log_status,
-	.vidioc_g_chip_ident	 = cx231xx_g_chip_ident,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.vidioc_g_register	 = cx231xx_g_register,
 	.vidioc_s_register	 = cx231xx_s_register,
diff --git a/drivers/media/usb/cx231xx/cx231xx-avcore.c b/drivers/media/usb/cx231xx/cx231xx-avcore.c
index 235ba65..89de00b 100644
--- a/drivers/media/usb/cx231xx/cx231xx-avcore.c
+++ b/drivers/media/usb/cx231xx/cx231xx-avcore.c
@@ -35,7 +35,6 @@
 
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
-#include <media/v4l2-chip-ident.h>
 
 #include "cx231xx.h"
 #include "cx231xx-dif.h"
diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
index 13249e5..27948e1 100644
--- a/drivers/media/usb/cx231xx/cx231xx-cards.c
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
@@ -29,7 +29,6 @@
 #include <media/tuner.h>
 #include <media/tveeprom.h>
 #include <media/v4l2-common.h>
-#include <media/v4l2-chip-ident.h>
 
 #include <media/cx25840.h>
 #include "dvb-usb-ids.h"
diff --git a/drivers/media/usb/cx231xx/cx231xx-vbi.c b/drivers/media/usb/cx231xx/cx231xx-vbi.c
index 1340ff2..c027942 100644
--- a/drivers/media/usb/cx231xx/cx231xx-vbi.c
+++ b/drivers/media/usb/cx231xx/cx231xx-vbi.c
@@ -32,7 +32,6 @@
 
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
-#include <media/v4l2-chip-ident.h>
 #include <media/msp3400.h>
 #include <media/tuner.h>
 
diff --git a/drivers/media/usb/cx231xx/cx231xx-video.c b/drivers/media/usb/cx231xx/cx231xx-video.c
index cd22147..54cdd4d 100644
--- a/drivers/media/usb/cx231xx/cx231xx-video.c
+++ b/drivers/media/usb/cx231xx/cx231xx-video.c
@@ -36,7 +36,6 @@
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-event.h>
-#include <media/v4l2-chip-ident.h>
 #include <media/msp3400.h>
 #include <media/tuner.h>
 
@@ -1228,179 +1227,86 @@ int cx231xx_s_frequency(struct file *file, void *priv,
 	return rc;
 }
 
-int cx231xx_g_chip_ident(struct file *file, void *fh,
-			struct v4l2_dbg_chip_ident *chip)
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+
+int cx231xx_g_chip_info(struct file *file, void *fh,
+			struct v4l2_dbg_chip_info *chip)
 {
-	chip->ident = V4L2_IDENT_NONE;
-	chip->revision = 0;
-	if (chip->match.type == V4L2_CHIP_MATCH_HOST) {
-		if (v4l2_chip_match_host(&chip->match))
-			chip->ident = V4L2_IDENT_CX23100;
+	switch (chip->match.addr) {
+	case 0:	/* Cx231xx - internal registers */
+		return 0;
+	case 1:	/* AFE - read byte */
+		strlcpy(chip->name, "AFE (byte)", sizeof(chip->name));
+		return 0;
+	case 2:	/* Video Block - read byte */
+		strlcpy(chip->name, "Video (byte)", sizeof(chip->name));
+		return 0;
+	case 3:	/* I2S block - read byte */
+		strlcpy(chip->name, "I2S (byte)", sizeof(chip->name));
+		return 0;
+	case 4: /* AFE - read dword */
+		strlcpy(chip->name, "AFE (dword)", sizeof(chip->name));
+		return 0;
+	case 5: /* Video Block - read dword */
+		strlcpy(chip->name, "Video (dword)", sizeof(chip->name));
+		return 0;
+	case 6: /* I2S Block - read dword */
+		strlcpy(chip->name, "I2S (dword)", sizeof(chip->name));
 		return 0;
 	}
 	return -EINVAL;
 }
 
-#ifdef CONFIG_VIDEO_ADV_DEBUG
-
-/*
-  -R, --list-registers=type=<host/i2cdrv/i2caddr>,
-				chip=<chip>[,min=<addr>,max=<addr>]
-		     dump registers from <min> to <max> [VIDIOC_DBG_G_REGISTER]
-  -r, --set-register=type=<host/i2cdrv/i2caddr>,
-				chip=<chip>,reg=<addr>,val=<val>
-		     set the register [VIDIOC_DBG_S_REGISTER]
-
-  if type == host, then <chip> is the hosts chip ID (default 0)
-  if type == i2cdrv (default), then <chip> is the I2C driver name or ID
-  if type == i2caddr, then <chip> is the 7-bit I2C address
-*/
-
 int cx231xx_g_register(struct file *file, void *priv,
 			     struct v4l2_dbg_register *reg)
 {
 	struct cx231xx_fh *fh = priv;
 	struct cx231xx *dev = fh->dev;
-	int ret = 0;
+	int ret;
 	u8 value[4] = { 0, 0, 0, 0 };
 	u32 data = 0;
 
-	switch (reg->match.type) {
-	case V4L2_CHIP_MATCH_HOST:
-		switch (reg->match.addr) {
-		case 0:	/* Cx231xx - internal registers */
-			ret = cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER,
-						  (u16)reg->reg, value, 4);
-			reg->val = value[0] | value[1] << 8 |
-				   value[2] << 16 | value[3] << 24;
-			break;
-		case 1:	/* AFE - read byte */
-			ret = cx231xx_read_i2c_data(dev, AFE_DEVICE_ADDRESS,
-						  (u16)reg->reg, 2, &data, 1);
-			reg->val = le32_to_cpu(data & 0xff);
-			break;
-		case 14: /* AFE - read dword */
-			ret = cx231xx_read_i2c_data(dev, AFE_DEVICE_ADDRESS,
-						  (u16)reg->reg, 2, &data, 4);
-			reg->val = le32_to_cpu(data);
-			break;
-		case 2:	/* Video Block - read byte */
-			ret = cx231xx_read_i2c_data(dev, VID_BLK_I2C_ADDRESS,
-						  (u16)reg->reg, 2, &data, 1);
-			reg->val = le32_to_cpu(data & 0xff);
-			break;
-		case 24: /* Video Block - read dword */
-			ret = cx231xx_read_i2c_data(dev, VID_BLK_I2C_ADDRESS,
-						  (u16)reg->reg, 2, &data, 4);
-			reg->val = le32_to_cpu(data);
-			break;
-		case 3:	/* I2S block - read byte */
-			ret = cx231xx_read_i2c_data(dev,
-						    I2S_BLK_DEVICE_ADDRESS,
-						    (u16)reg->reg, 1,
-						    &data, 1);
-			reg->val = le32_to_cpu(data & 0xff);
-			break;
-		case 34: /* I2S Block - read dword */
-			ret =
-			    cx231xx_read_i2c_data(dev, I2S_BLK_DEVICE_ADDRESS,
-						  (u16)reg->reg, 1, &data, 4);
-			reg->val = le32_to_cpu(data);
-			break;
-		}
-		return ret < 0 ? ret : 0;
-
-	case V4L2_CHIP_MATCH_I2C_DRIVER:
-		call_all(dev, core, g_register, reg);
-		return 0;
-	case V4L2_CHIP_MATCH_I2C_ADDR:/*for register debug*/
-		switch (reg->match.addr) {
-		case 0:	/* Cx231xx - internal registers */
-			ret = cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER,
-						  (u16)reg->reg, value, 4);
-			reg->val = value[0] | value[1] << 8 |
-				   value[2] << 16 | value[3] << 24;
-
-			break;
-		case 0x600:/* AFE - read byte */
-			ret = cx231xx_read_i2c_master(dev, AFE_DEVICE_ADDRESS,
-						 (u16)reg->reg, 2,
-						 &data, 1 , 0);
-			reg->val = le32_to_cpu(data & 0xff);
-			break;
-
-		case 0x880:/* Video Block - read byte */
-			if (reg->reg < 0x0b) {
-				ret = cx231xx_read_i2c_master(dev,
-						VID_BLK_I2C_ADDRESS,
-						 (u16)reg->reg, 2,
-						 &data, 1 , 0);
-				reg->val = le32_to_cpu(data & 0xff);
-			} else {
-				ret = cx231xx_read_i2c_master(dev,
-						VID_BLK_I2C_ADDRESS,
-						 (u16)reg->reg, 2,
-						 &data, 4 , 0);
-				reg->val = le32_to_cpu(data);
-			}
-			break;
-		case 0x980:
-			ret = cx231xx_read_i2c_master(dev,
-						I2S_BLK_DEVICE_ADDRESS,
-						(u16)reg->reg, 1,
-						&data, 1 , 0);
-			reg->val = le32_to_cpu(data & 0xff);
-			break;
-		case 0x400:
-			ret =
-			    cx231xx_read_i2c_master(dev, 0x40,
-						  (u16)reg->reg, 1,
-						 &data, 1 , 0);
-			reg->val = le32_to_cpu(data & 0xff);
-			break;
-		case 0xc01:
-			ret =
-				cx231xx_read_i2c_master(dev, 0xc0,
-						(u16)reg->reg, 2,
-						 &data, 38, 1);
-			reg->val = le32_to_cpu(data);
-			break;
-		case 0x022:
-			ret =
-				cx231xx_read_i2c_master(dev, 0x02,
-						(u16)reg->reg, 1,
-						 &data, 1, 2);
-			reg->val = le32_to_cpu(data & 0xff);
-			break;
-		case 0x322:
-			ret = cx231xx_read_i2c_master(dev,
-						0x32,
-						 (u16)reg->reg, 1,
-						 &data, 4 , 2);
-				reg->val = le32_to_cpu(data);
-			break;
-		case 0x342:
-			ret = cx231xx_read_i2c_master(dev,
-						0x34,
-						 (u16)reg->reg, 1,
-						 &data, 4 , 2);
-				reg->val = le32_to_cpu(data);
-			break;
-
-		default:
-			cx231xx_info("no match device address!!\n");
-			break;
-			}
-		return ret < 0 ? ret : 0;
-		/*return -EINVAL;*/
+	switch (reg->match.addr) {
+	case 0:	/* Cx231xx - internal registers */
+		ret = cx231xx_read_ctrl_reg(dev, VRT_GET_REGISTER,
+				(u16)reg->reg, value, 4);
+		reg->val = value[0] | value[1] << 8 |
+			value[2] << 16 | value[3] << 24;
+		break;
+	case 1:	/* AFE - read byte */
+		ret = cx231xx_read_i2c_data(dev, AFE_DEVICE_ADDRESS,
+				(u16)reg->reg, 2, &data, 1);
+		reg->val = data;
+		break;
+	case 2:	/* Video Block - read byte */
+		ret = cx231xx_read_i2c_data(dev, VID_BLK_I2C_ADDRESS,
+				(u16)reg->reg, 2, &data, 1);
+		reg->val = data;
+		break;
+	case 3:	/* I2S block - read byte */
+		ret = cx231xx_read_i2c_data(dev, I2S_BLK_DEVICE_ADDRESS,
+				(u16)reg->reg, 1, &data, 1);
+		reg->val = data;
+		break;
+	case 4: /* AFE - read dword */
+		ret = cx231xx_read_i2c_data(dev, AFE_DEVICE_ADDRESS,
+				(u16)reg->reg, 2, &data, 4);
+		reg->val = data;
+		break;
+	case 5: /* Video Block - read dword */
+		ret = cx231xx_read_i2c_data(dev, VID_BLK_I2C_ADDRESS,
+				(u16)reg->reg, 2, &data, 4);
+		reg->val = data;
+		break;
+	case 6: /* I2S Block - read dword */
+		ret = cx231xx_read_i2c_data(dev, I2S_BLK_DEVICE_ADDRESS,
+				(u16)reg->reg, 1, &data, 4);
+		reg->val = data;
+		break;
 	default:
-		if (!v4l2_chip_match_host(&reg->match))
-			return -EINVAL;
+		return -EINVAL;
 	}
-
-	call_all(dev, core, g_register, reg);
-
-	return ret;
+	return ret < 0 ? ret : 0;
 }
 
 int cx231xx_s_register(struct file *file, void *priv,
@@ -1408,165 +1314,46 @@ int cx231xx_s_register(struct file *file, void *priv,
 {
 	struct cx231xx_fh *fh = priv;
 	struct cx231xx *dev = fh->dev;
-	int ret = 0;
-	__le64 buf;
-	u32 value;
+	int ret;
 	u8 data[4] = { 0, 0, 0, 0 };
 
-	buf = cpu_to_le64(reg->val);
-
-	switch (reg->match.type) {
-	case V4L2_CHIP_MATCH_HOST:
-		{
-			value = (u32) buf & 0xffffffff;
-
-			switch (reg->match.addr) {
-			case 0:	/* cx231xx internal registers */
-				data[0] = (u8) value;
-				data[1] = (u8) (value >> 8);
-				data[2] = (u8) (value >> 16);
-				data[3] = (u8) (value >> 24);
-				ret = cx231xx_write_ctrl_reg(dev,
-							   VRT_SET_REGISTER,
-							   (u16)reg->reg, data,
-							   4);
-				break;
-			case 1:	/* AFE - read byte */
-				ret = cx231xx_write_i2c_data(dev,
-							AFE_DEVICE_ADDRESS,
-							(u16)reg->reg, 2,
-							value, 1);
-				break;
-			case 14: /* AFE - read dword */
-				ret = cx231xx_write_i2c_data(dev,
-							AFE_DEVICE_ADDRESS,
-							(u16)reg->reg, 2,
-							value, 4);
-				break;
-			case 2:	/* Video Block - read byte */
-				ret =
-				    cx231xx_write_i2c_data(dev,
-							VID_BLK_I2C_ADDRESS,
-							(u16)reg->reg, 2,
-							value, 1);
-				break;
-			case 24: /* Video Block - read dword */
-				ret =
-				    cx231xx_write_i2c_data(dev,
-							VID_BLK_I2C_ADDRESS,
-							(u16)reg->reg, 2,
-							value, 4);
-				break;
-			case 3:	/* I2S block - read byte */
-				ret =
-				    cx231xx_write_i2c_data(dev,
-							I2S_BLK_DEVICE_ADDRESS,
-							(u16)reg->reg, 1,
-							value, 1);
-				break;
-			case 34: /* I2S block - read dword */
-				ret =
-				    cx231xx_write_i2c_data(dev,
-							I2S_BLK_DEVICE_ADDRESS,
-							(u16)reg->reg, 1,
-							value, 4);
-				break;
-			}
-		}
-		return ret < 0 ? ret : 0;
-	case V4L2_CHIP_MATCH_I2C_ADDR:
-		{
-			value = (u32) buf & 0xffffffff;
-
-			switch (reg->match.addr) {
-			case 0:/*cx231xx internal registers*/
-					data[0] = (u8) value;
-					data[1] = (u8) (value >> 8);
-					data[2] = (u8) (value >> 16);
-					data[3] = (u8) (value >> 24);
-					ret = cx231xx_write_ctrl_reg(dev,
-							   VRT_SET_REGISTER,
-							   (u16)reg->reg, data,
-							   4);
-					break;
-			case 0x600:/* AFE - read byte */
-					ret = cx231xx_write_i2c_master(dev,
-							AFE_DEVICE_ADDRESS,
-							(u16)reg->reg, 2,
-							value, 1 , 0);
-					break;
-
-			case 0x880:/* Video Block - read byte */
-					if (reg->reg < 0x0b)
-						cx231xx_write_i2c_master(dev,
-							VID_BLK_I2C_ADDRESS,
-							(u16)reg->reg, 2,
-							value, 1, 0);
-					else
-						cx231xx_write_i2c_master(dev,
-							VID_BLK_I2C_ADDRESS,
-							(u16)reg->reg, 2,
-							value, 4, 0);
-					break;
-			case 0x980:
-					ret =
-						cx231xx_write_i2c_master(dev,
-							I2S_BLK_DEVICE_ADDRESS,
-							(u16)reg->reg, 1,
-							value, 1, 0);
-					break;
-			case 0x400:
-					ret =
-						cx231xx_write_i2c_master(dev,
-							0x40,
-							(u16)reg->reg, 1,
-							value, 1, 0);
-					break;
-			case 0xc01:
-					ret =
-						cx231xx_write_i2c_master(dev,
-							 0xc0,
-							 (u16)reg->reg, 1,
-							 value, 1, 1);
-					break;
-
-			case 0x022:
-					ret =
-						cx231xx_write_i2c_master(dev,
-							0x02,
-							(u16)reg->reg, 1,
-							value, 1, 2);
-					break;
-			case 0x322:
-					ret =
-						cx231xx_write_i2c_master(dev,
-							0x32,
-							(u16)reg->reg, 1,
-							value, 4, 2);
-					break;
-
-			case 0x342:
-					ret =
-						cx231xx_write_i2c_master(dev,
-							0x34,
-							(u16)reg->reg, 1,
-							value, 4, 2);
-					break;
-			default:
-				cx231xx_info("no match device address, "
-					"the value is %x\n", reg->match.addr);
-					break;
-
-					}
-
-		}
-	default:
+	switch (reg->match.addr) {
+	case 0:	/* cx231xx internal registers */
+		data[0] = (u8) reg->val;
+		data[1] = (u8) (reg->val >> 8);
+		data[2] = (u8) (reg->val >> 16);
+		data[3] = (u8) (reg->val >> 24);
+		ret = cx231xx_write_ctrl_reg(dev, VRT_SET_REGISTER,
+				(u16)reg->reg, data, 4);
+		break;
+	case 1:	/* AFE - write byte */
+		ret = cx231xx_write_i2c_data(dev, AFE_DEVICE_ADDRESS,
+				(u16)reg->reg, 2, reg->val, 1);
+		break;
+	case 2:	/* Video Block - write byte */
+		ret = cx231xx_write_i2c_data(dev, VID_BLK_I2C_ADDRESS,
+				(u16)reg->reg, 2, reg->val, 1);
+		break;
+	case 3:	/* I2S block - write byte */
+		ret = cx231xx_write_i2c_data(dev, I2S_BLK_DEVICE_ADDRESS,
+				(u16)reg->reg, 1, reg->val, 1);
+		break;
+	case 4: /* AFE - write dword */
+		ret = cx231xx_write_i2c_data(dev, AFE_DEVICE_ADDRESS,
+				(u16)reg->reg, 2, reg->val, 4);
+		break;
+	case 5: /* Video Block - write dword */
+		ret = cx231xx_write_i2c_data(dev, VID_BLK_I2C_ADDRESS,
+				(u16)reg->reg, 2, reg->val, 4);
 		break;
+	case 6: /* I2S block - write dword */
+		ret = cx231xx_write_i2c_data(dev, I2S_BLK_DEVICE_ADDRESS,
+				(u16)reg->reg, 1, reg->val, 4);
+		break;
+	default:
+		return -EINVAL;
 	}
-
-	call_all(dev, core, s_register, reg);
-
-	return ret;
+	return ret < 0 ? ret : 0;
 }
 #endif
 
@@ -2208,8 +1995,8 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_s_tuner                = cx231xx_s_tuner,
 	.vidioc_g_frequency            = cx231xx_g_frequency,
 	.vidioc_s_frequency            = cx231xx_s_frequency,
-	.vidioc_g_chip_ident           = cx231xx_g_chip_ident,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
+	.vidioc_g_chip_info            = cx231xx_g_chip_info,
 	.vidioc_g_register             = cx231xx_g_register,
 	.vidioc_s_register             = cx231xx_s_register,
 #endif
@@ -2240,8 +2027,8 @@ static const struct v4l2_ioctl_ops radio_ioctl_ops = {
 	.vidioc_s_tuner     = radio_s_tuner,
 	.vidioc_g_frequency = cx231xx_g_frequency,
 	.vidioc_s_frequency = cx231xx_s_frequency,
-	.vidioc_g_chip_ident = cx231xx_g_chip_ident,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
+	.vidioc_g_chip_info = cx231xx_g_chip_info,
 	.vidioc_g_register  = cx231xx_g_register,
 	.vidioc_s_register  = cx231xx_s_register,
 #endif
diff --git a/drivers/media/usb/cx231xx/cx231xx.h b/drivers/media/usb/cx231xx/cx231xx.h
index 5ad9fd6..e812119 100644
--- a/drivers/media/usb/cx231xx/cx231xx.h
+++ b/drivers/media/usb/cx231xx/cx231xx.h
@@ -945,7 +945,7 @@ int cx231xx_enum_input(struct file *file, void *priv,
 			     struct v4l2_input *i);
 int cx231xx_g_input(struct file *file, void *priv, unsigned int *i);
 int cx231xx_s_input(struct file *file, void *priv, unsigned int i);
-int cx231xx_g_chip_ident(struct file *file, void *fh, struct v4l2_dbg_chip_ident *chip);
+int cx231xx_g_chip_info(struct file *file, void *fh, struct v4l2_dbg_chip_info *chip);
 int cx231xx_g_register(struct file *file, void *priv,
 			     struct v4l2_dbg_register *reg);
 int cx231xx_s_register(struct file *file, void *priv,
-- 
1.7.10.4

