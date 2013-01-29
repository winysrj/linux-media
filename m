Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:4054 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754794Ab3A2Qdk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Jan 2013 11:33:40 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Srinivasa Deevi <srinivasa.deevi@conexant.com>,
	Palash.Bandyopadhyay@conexant.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 18/20] cx231xx-417: checkpatch cleanups.
Date: Tue, 29 Jan 2013 17:33:11 +0100
Message-Id: <86234d7818d9aa259097796181da70b988436739.1359476777.git.hans.verkuil@cisco.com>
In-Reply-To: <1359477193-9768-1-git-send-email-hverkuil@xs4all.nl>
References: <1359477193-9768-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <8a9d877c6be8a336a44c69a21b3fca449294139d.1359476776.git.hans.verkuil@cisco.com>
References: <8a9d877c6be8a336a44c69a21b3fca449294139d.1359476776.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/cx231xx/cx231xx-417.c |  732 +++++++++++++++----------------
 1 file changed, 360 insertions(+), 372 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-417.c b/drivers/media/usb/cx231xx/cx231xx-417.c
index cbdc141..2c05c8f 100644
--- a/drivers/media/usb/cx231xx/cx231xx-417.c
+++ b/drivers/media/usb/cx231xx/cx231xx-417.c
@@ -38,7 +38,6 @@
 #include <linux/usb.h>
 
 #include "cx231xx.h"
-/*#include "cx23885-ioctl.h"*/
 
 #define CX231xx_FIRM_IMAGE_SIZE 376836
 #define CX231xx_FIRM_IMAGE_NAME "v4l-cx23885-enc.fw"
@@ -75,9 +74,11 @@
 static unsigned int mpegbufs = 8;
 module_param(mpegbufs, int, 0644);
 MODULE_PARM_DESC(mpegbufs, "number of mpeg buffers, range 2-32");
+
 static unsigned int mpeglines = 128;
 module_param(mpeglines, int, 0644);
 MODULE_PARM_DESC(mpeglines, "number of lines in an MPEG buffer, range 2-32");
+
 static unsigned int mpeglinesize = 512;
 module_param(mpeglinesize, int, 0644);
 MODULE_PARM_DESC(mpeglinesize,
@@ -86,10 +87,10 @@ MODULE_PARM_DESC(mpeglinesize,
 static unsigned int v4l_debug = 1;
 module_param(v4l_debug, int, 0644);
 MODULE_PARM_DESC(v4l_debug, "enable V4L debug messages");
-struct cx231xx_dmaqueue *dma_qq;
+
 #define dprintk(level, fmt, arg...)\
 	do { if (v4l_debug >= level) \
-		printk(KERN_INFO "%s: " fmt, \
+		pr_info("%s: " fmt, \
 		(dev) ? dev->name : "cx231xx[?]", ## arg); \
 	} while (0)
 
@@ -131,11 +132,13 @@ static struct cx231xx_tvnorm cx231xx_tvnorms[] = {
 };
 
 /* ------------------------------------------------------------------ */
+
 enum cx231xx_capture_type {
 	CX231xx_MPEG_CAPTURE,
 	CX231xx_RAW_CAPTURE,
 	CX231xx_RAW_PASSTHRU_CAPTURE
 };
+
 enum cx231xx_capture_bits {
 	CX231xx_RAW_BITS_NONE             = 0x00,
 	CX231xx_RAW_BITS_YUV_CAPTURE      = 0x01,
@@ -144,33 +147,40 @@ enum cx231xx_capture_bits {
 	CX231xx_RAW_BITS_PASSTHRU_CAPTURE = 0x08,
 	CX231xx_RAW_BITS_TO_HOST_CAPTURE  = 0x10
 };
+
 enum cx231xx_capture_end {
 	CX231xx_END_AT_GOP, /* stop at the end of gop, generate irq */
 	CX231xx_END_NOW, /* stop immediately, no irq */
 };
+
 enum cx231xx_framerate {
 	CX231xx_FRAMERATE_NTSC_30, /* NTSC: 30fps */
 	CX231xx_FRAMERATE_PAL_25   /* PAL: 25fps */
 };
+
 enum cx231xx_stream_port {
 	CX231xx_OUTPUT_PORT_MEMORY,
 	CX231xx_OUTPUT_PORT_STREAMING,
 	CX231xx_OUTPUT_PORT_SERIAL
 };
+
 enum cx231xx_data_xfer_status {
 	CX231xx_MORE_BUFFERS_FOLLOW,
 	CX231xx_LAST_BUFFER,
 };
+
 enum cx231xx_picture_mask {
 	CX231xx_PICTURE_MASK_NONE,
 	CX231xx_PICTURE_MASK_I_FRAMES,
 	CX231xx_PICTURE_MASK_I_P_FRAMES = 0x3,
 	CX231xx_PICTURE_MASK_ALL_FRAMES = 0x7,
 };
+
 enum cx231xx_vbi_mode_bits {
 	CX231xx_VBI_BITS_SLICED,
 	CX231xx_VBI_BITS_RAW,
 };
+
 enum cx231xx_vbi_insertion_bits {
 	CX231xx_VBI_BITS_INSERT_IN_XTENSION_USR_DATA,
 	CX231xx_VBI_BITS_INSERT_IN_PRIVATE_PACKETS = 0x1 << 1,
@@ -178,56 +188,69 @@ enum cx231xx_vbi_insertion_bits {
 	CX231xx_VBI_BITS_SEPARATE_STREAM_USR_DATA = 0x4 << 1,
 	CX231xx_VBI_BITS_SEPARATE_STREAM_PRV_DATA = 0x5 << 1,
 };
+
 enum cx231xx_dma_unit {
 	CX231xx_DMA_BYTES,
 	CX231xx_DMA_FRAMES,
 };
+
 enum cx231xx_dma_transfer_status_bits {
 	CX231xx_DMA_TRANSFER_BITS_DONE = 0x01,
 	CX231xx_DMA_TRANSFER_BITS_ERROR = 0x04,
 	CX231xx_DMA_TRANSFER_BITS_LL_ERROR = 0x10,
 };
+
 enum cx231xx_pause {
 	CX231xx_PAUSE_ENCODING,
 	CX231xx_RESUME_ENCODING,
 };
+
 enum cx231xx_copyright {
 	CX231xx_COPYRIGHT_OFF,
 	CX231xx_COPYRIGHT_ON,
 };
+
 enum cx231xx_notification_type {
 	CX231xx_NOTIFICATION_REFRESH,
 };
+
 enum cx231xx_notification_status {
 	CX231xx_NOTIFICATION_OFF,
 	CX231xx_NOTIFICATION_ON,
 };
+
 enum cx231xx_notification_mailbox {
 	CX231xx_NOTIFICATION_NO_MAILBOX = -1,
 };
+
 enum cx231xx_field1_lines {
 	CX231xx_FIELD1_SAA7114 = 0x00EF, /* 239 */
 	CX231xx_FIELD1_SAA7115 = 0x00F0, /* 240 */
 	CX231xx_FIELD1_MICRONAS = 0x0105, /* 261 */
 };
+
 enum cx231xx_field2_lines {
 	CX231xx_FIELD2_SAA7114 = 0x00EF, /* 239 */
 	CX231xx_FIELD2_SAA7115 = 0x00F0, /* 240 */
 	CX231xx_FIELD2_MICRONAS = 0x0106, /* 262 */
 };
+
 enum cx231xx_custom_data_type {
 	CX231xx_CUSTOM_EXTENSION_USR_DATA,
 	CX231xx_CUSTOM_PRIVATE_PACKET,
 };
+
 enum cx231xx_mute {
 	CX231xx_UNMUTE,
 	CX231xx_MUTE,
 };
+
 enum cx231xx_mute_video_mask {
 	CX231xx_MUTE_VIDEO_V_MASK = 0x0000FF00,
 	CX231xx_MUTE_VIDEO_U_MASK = 0x00FF0000,
 	CX231xx_MUTE_VIDEO_Y_MASK = 0xFF000000,
 };
+
 enum cx231xx_mute_video_shift {
 	CX231xx_MUTE_VIDEO_V_SHIFT = 8,
 	CX231xx_MUTE_VIDEO_U_SHIFT = 16,
@@ -296,41 +319,43 @@ enum cx231xx_mute_video_shift {
 
 
 #define CX23417_GPIO_MASK 0xFC0003FF
-static int setITVCReg(struct cx231xx *dev, u32 gpio_direction, u32 value)
+
+static int set_itvc_reg(struct cx231xx *dev, u32 gpio_direction, u32 value)
 {
 	int status = 0;
 	u32 _gpio_direction = 0;
 
 	_gpio_direction = _gpio_direction & CX23417_GPIO_MASK;
-	_gpio_direction = _gpio_direction|gpio_direction;
+	_gpio_direction = _gpio_direction | gpio_direction;
 	status = cx231xx_send_gpio_cmd(dev, _gpio_direction,
 			 (u8 *)&value, 4, 0, 0);
 	return status;
 }
-static int getITVCReg(struct cx231xx *dev, u32 gpio_direction, u32 *pValue)
+
+static int get_itvc_reg(struct cx231xx *dev, u32 gpio_direction, u32 *val_ptr)
 {
 	int status = 0;
 	u32 _gpio_direction = 0;
 
 	_gpio_direction = _gpio_direction & CX23417_GPIO_MASK;
-	_gpio_direction = _gpio_direction|gpio_direction;
+	_gpio_direction = _gpio_direction | gpio_direction;
 
 	status = cx231xx_send_gpio_cmd(dev, _gpio_direction,
-		 (u8 *)pValue, 4, 0, 1);
+		 (u8 *)val_ptr, 4, 0, 1);
 	return status;
 }
 
-static int waitForMciComplete(struct cx231xx *dev)
+static int wait_for_mci_complete(struct cx231xx *dev)
 {
 	u32 gpio;
-	u32 gpio_driection = 0;
+	u32 gpio_direction = 0;
 	u8 count = 0;
-	getITVCReg(dev, gpio_driection, &gpio);
+	get_itvc_reg(dev, gpio_direction, &gpio);
 
 	while (!(gpio&0x020000)) {
 		msleep(10);
 
-		getITVCReg(dev, gpio_driection, &gpio);
+		get_itvc_reg(dev, gpio_direction, &gpio);
 
 		if (count++ > 100) {
 			dprintk(3, "ERROR: Timeout - gpio=%x\n", gpio);
@@ -345,57 +370,57 @@ static int mc417_register_write(struct cx231xx *dev, u16 address, u32 value)
 	u32 temp;
 	int status = 0;
 
-	temp = 0x82|MCI_REGISTER_DATA_BYTE0|((value&0x000000FF)<<8);
-	temp = temp<<10;
-	status = setITVCReg(dev, ITVC_WRITE_DIR, temp);
+	temp = 0x82 | MCI_REGISTER_DATA_BYTE0 | ((value & 0x000000FF) << 8);
+	temp = temp << 10;
+	status = set_itvc_reg(dev, ITVC_WRITE_DIR, temp);
 	if (status < 0)
 		return status;
-	temp = temp|((0x05)<<10);
-	setITVCReg(dev, ITVC_WRITE_DIR, temp);
+	temp = temp | (0x05 << 10);
+	set_itvc_reg(dev, ITVC_WRITE_DIR, temp);
 
 	/*write data byte 1;*/
-	temp = 0x82|MCI_REGISTER_DATA_BYTE1|(value&0x0000FF00);
-	temp = temp<<10;
-	setITVCReg(dev, ITVC_WRITE_DIR, temp);
-	temp = temp|((0x05)<<10);
-	setITVCReg(dev, ITVC_WRITE_DIR, temp);
+	temp = 0x82 | MCI_REGISTER_DATA_BYTE1 | (value & 0x0000FF00);
+	temp = temp << 10;
+	set_itvc_reg(dev, ITVC_WRITE_DIR, temp);
+	temp = temp | (0x05 << 10);
+	set_itvc_reg(dev, ITVC_WRITE_DIR, temp);
 
 	/*write data byte 2;*/
-	temp = 0x82|MCI_REGISTER_DATA_BYTE2|((value&0x00FF0000)>>8);
-	temp = temp<<10;
-	setITVCReg(dev, ITVC_WRITE_DIR, temp);
-	temp = temp|((0x05)<<10);
-	setITVCReg(dev, ITVC_WRITE_DIR, temp);
+	temp = 0x82 | MCI_REGISTER_DATA_BYTE2 | ((value & 0x00FF0000) >> 8);
+	temp = temp << 10;
+	set_itvc_reg(dev, ITVC_WRITE_DIR, temp);
+	temp = temp | (0x05 << 10);
+	set_itvc_reg(dev, ITVC_WRITE_DIR, temp);
 
 	/*write data byte 3;*/
-	temp = 0x82|MCI_REGISTER_DATA_BYTE3|((value&0xFF000000)>>16);
-	temp = temp<<10;
-	setITVCReg(dev, ITVC_WRITE_DIR, temp);
-	temp = temp|((0x05)<<10);
-	setITVCReg(dev, ITVC_WRITE_DIR, temp);
+	temp = 0x82 | MCI_REGISTER_DATA_BYTE3 | ((value & 0xFF000000) >> 16);
+	temp = temp << 10;
+	set_itvc_reg(dev, ITVC_WRITE_DIR, temp);
+	temp = temp | (0x05 << 10);
+	set_itvc_reg(dev, ITVC_WRITE_DIR, temp);
 
 	/*write address byte 0;*/
-	temp = 0x82|MCI_REGISTER_ADDRESS_BYTE0|((address&0x000000FF)<<8);
-	temp = temp<<10;
-	setITVCReg(dev, ITVC_WRITE_DIR, temp);
-	temp = temp|((0x05)<<10);
-	setITVCReg(dev, ITVC_WRITE_DIR, temp);
+	temp = 0x82 | MCI_REGISTER_ADDRESS_BYTE0 | ((address & 0x000000FF) << 8);
+	temp = temp << 10;
+	set_itvc_reg(dev, ITVC_WRITE_DIR, temp);
+	temp = temp | (0x05 << 10);
+	set_itvc_reg(dev, ITVC_WRITE_DIR, temp);
 
 	/*write address byte 1;*/
-	temp = 0x82|MCI_REGISTER_ADDRESS_BYTE1|(address&0x0000FF00);
-	temp = temp<<10;
-	setITVCReg(dev, ITVC_WRITE_DIR, temp);
-	temp = temp|((0x05)<<10);
-	setITVCReg(dev, ITVC_WRITE_DIR, temp);
+	temp = 0x82 | MCI_REGISTER_ADDRESS_BYTE1 | (address & 0x0000FF00);
+	temp = temp << 10;
+	set_itvc_reg(dev, ITVC_WRITE_DIR, temp);
+	temp = temp | (0x05 << 10);
+	set_itvc_reg(dev, ITVC_WRITE_DIR, temp);
 
 	/*Write that the mode is write.*/
 	temp = 0x82 | MCI_REGISTER_MODE | MCI_MODE_REGISTER_WRITE;
-	temp = temp<<10;
-	setITVCReg(dev, ITVC_WRITE_DIR, temp);
-	temp = temp|((0x05)<<10);
-	setITVCReg(dev, ITVC_WRITE_DIR, temp);
+	temp = temp << 10;
+	set_itvc_reg(dev, ITVC_WRITE_DIR, temp);
+	temp = temp | (0x05 << 10);
+	set_itvc_reg(dev, ITVC_WRITE_DIR, temp);
 
-	return waitForMciComplete(dev);
+	return wait_for_mci_complete(dev);
 }
 
 static int mc417_register_read(struct cx231xx *dev, u16 address, u32 *value)
@@ -407,70 +432,68 @@ static int mc417_register_read(struct cx231xx *dev, u16 address, u32 *value)
 
 	temp = 0x82 | MCI_REGISTER_ADDRESS_BYTE0 | ((address & 0x00FF) << 8);
 	temp = temp << 10;
-	setITVCReg(dev, ITVC_WRITE_DIR, temp);
+	set_itvc_reg(dev, ITVC_WRITE_DIR, temp);
 	temp = temp | ((0x05) << 10);
-	setITVCReg(dev, ITVC_WRITE_DIR, temp);
+	set_itvc_reg(dev, ITVC_WRITE_DIR, temp);
 
 	/*write address byte 1;*/
 	temp = 0x82 | MCI_REGISTER_ADDRESS_BYTE1 | (address & 0xFF00);
 	temp = temp << 10;
-	setITVCReg(dev, ITVC_WRITE_DIR, temp);
+	set_itvc_reg(dev, ITVC_WRITE_DIR, temp);
 	temp = temp | ((0x05) << 10);
-	setITVCReg(dev, ITVC_WRITE_DIR, temp);
+	set_itvc_reg(dev, ITVC_WRITE_DIR, temp);
 
 	/*write that the mode is read;*/
 	temp = 0x82 | MCI_REGISTER_MODE | MCI_MODE_REGISTER_READ;
 	temp = temp << 10;
-	setITVCReg(dev, ITVC_WRITE_DIR, temp);
+	set_itvc_reg(dev, ITVC_WRITE_DIR, temp);
 	temp = temp | ((0x05) << 10);
-	setITVCReg(dev, ITVC_WRITE_DIR, temp);
+	set_itvc_reg(dev, ITVC_WRITE_DIR, temp);
 
 	/*wait for the MIRDY line to be asserted ,
 	signalling that the read is done;*/
-	ret = waitForMciComplete(dev);
+	ret = wait_for_mci_complete(dev);
 
 	/*switch the DATA- GPIO to input mode;*/
 
 	/*Read data byte 0;*/
 	temp = (0x82 | MCI_REGISTER_DATA_BYTE0) << 10;
-	setITVCReg(dev, ITVC_READ_DIR, temp);
+	set_itvc_reg(dev, ITVC_READ_DIR, temp);
 	temp = ((0x81 | MCI_REGISTER_DATA_BYTE0) << 10);
-	setITVCReg(dev, ITVC_READ_DIR, temp);
-	getITVCReg(dev, ITVC_READ_DIR, &temp);
+	set_itvc_reg(dev, ITVC_READ_DIR, temp);
+	get_itvc_reg(dev, ITVC_READ_DIR, &temp);
 	return_value |= ((temp & 0x03FC0000) >> 18);
-	setITVCReg(dev, ITVC_READ_DIR, (0x87 << 10));
+	set_itvc_reg(dev, ITVC_READ_DIR, (0x87 << 10));
 
 	/* Read data byte 1;*/
 	temp = (0x82 | MCI_REGISTER_DATA_BYTE1) << 10;
-	setITVCReg(dev, ITVC_READ_DIR, temp);
+	set_itvc_reg(dev, ITVC_READ_DIR, temp);
 	temp = ((0x81 | MCI_REGISTER_DATA_BYTE1) << 10);
-	setITVCReg(dev, ITVC_READ_DIR, temp);
-	getITVCReg(dev, ITVC_READ_DIR, &temp);
+	set_itvc_reg(dev, ITVC_READ_DIR, temp);
+	get_itvc_reg(dev, ITVC_READ_DIR, &temp);
 
 	return_value |= ((temp & 0x03FC0000) >> 10);
-	setITVCReg(dev, ITVC_READ_DIR, (0x87 << 10));
+	set_itvc_reg(dev, ITVC_READ_DIR, (0x87 << 10));
 
 	/*Read data byte 2;*/
 	temp = (0x82 | MCI_REGISTER_DATA_BYTE2) << 10;
-	setITVCReg(dev, ITVC_READ_DIR, temp);
+	set_itvc_reg(dev, ITVC_READ_DIR, temp);
 	temp = ((0x81 | MCI_REGISTER_DATA_BYTE2) << 10);
-	setITVCReg(dev, ITVC_READ_DIR, temp);
-	getITVCReg(dev, ITVC_READ_DIR, &temp);
+	set_itvc_reg(dev, ITVC_READ_DIR, temp);
+	get_itvc_reg(dev, ITVC_READ_DIR, &temp);
 	return_value |= ((temp & 0x03FC0000) >> 2);
-	setITVCReg(dev, ITVC_READ_DIR, (0x87 << 10));
+	set_itvc_reg(dev, ITVC_READ_DIR, (0x87 << 10));
 
 	/*Read data byte 3;*/
 	temp = (0x82 | MCI_REGISTER_DATA_BYTE3) << 10;
-	setITVCReg(dev, ITVC_READ_DIR, temp);
+	set_itvc_reg(dev, ITVC_READ_DIR, temp);
 	temp = ((0x81 | MCI_REGISTER_DATA_BYTE3) << 10);
-	setITVCReg(dev, ITVC_READ_DIR, temp);
-	getITVCReg(dev, ITVC_READ_DIR, &temp);
+	set_itvc_reg(dev, ITVC_READ_DIR, temp);
+	get_itvc_reg(dev, ITVC_READ_DIR, &temp);
 	return_value |= ((temp & 0x03FC0000) << 6);
-	setITVCReg(dev, ITVC_READ_DIR, (0x87 << 10));
+	set_itvc_reg(dev, ITVC_READ_DIR, (0x87 << 10));
 
 	*value  = return_value;
-
-
 	return ret;
 }
 
@@ -481,59 +504,59 @@ static int mc417_memory_write(struct cx231xx *dev, u32 address, u32 value)
 	u32 temp;
 	int ret = 0;
 
-	temp = 0x82 | MCI_MEMORY_DATA_BYTE0|((value & 0x000000FF) << 8);
+	temp = 0x82 | MCI_MEMORY_DATA_BYTE0 | ((value & 0x000000FF) << 8);
 	temp = temp << 10;
-	ret = setITVCReg(dev, ITVC_WRITE_DIR, temp);
+	ret = set_itvc_reg(dev, ITVC_WRITE_DIR, temp);
 	if (ret < 0)
 		return ret;
-	temp = temp | ((0x05) << 10);
-	setITVCReg(dev, ITVC_WRITE_DIR, temp);
+	temp = temp | (0x05 << 10);
+	set_itvc_reg(dev, ITVC_WRITE_DIR, temp);
 
 	/*write data byte 1;*/
 	temp = 0x82 | MCI_MEMORY_DATA_BYTE1 | (value & 0x0000FF00);
 	temp = temp << 10;
-	setITVCReg(dev, ITVC_WRITE_DIR, temp);
-	temp = temp | ((0x05) << 10);
-	setITVCReg(dev, ITVC_WRITE_DIR, temp);
+	set_itvc_reg(dev, ITVC_WRITE_DIR, temp);
+	temp = temp | (0x05 << 10);
+	set_itvc_reg(dev, ITVC_WRITE_DIR, temp);
 
 	/*write data byte 2;*/
-	temp = 0x82|MCI_MEMORY_DATA_BYTE2|((value&0x00FF0000)>>8);
-	temp = temp<<10;
-	setITVCReg(dev, ITVC_WRITE_DIR, temp);
-	temp = temp|((0x05)<<10);
-	setITVCReg(dev, ITVC_WRITE_DIR, temp);
+	temp = 0x82 | MCI_MEMORY_DATA_BYTE2 | ((value & 0x00FF0000) >> 8);
+	temp = temp << 10;
+	set_itvc_reg(dev, ITVC_WRITE_DIR, temp);
+	temp = temp | (0x05 << 10);
+	set_itvc_reg(dev, ITVC_WRITE_DIR, temp);
 
 	/*write data byte 3;*/
-	temp = 0x82|MCI_MEMORY_DATA_BYTE3|((value&0xFF000000)>>16);
-	temp = temp<<10;
-	setITVCReg(dev, ITVC_WRITE_DIR, temp);
-	temp = temp|((0x05)<<10);
-	setITVCReg(dev, ITVC_WRITE_DIR, temp);
+	temp = 0x82 | MCI_MEMORY_DATA_BYTE3 | ((value & 0xFF000000) >> 16);
+	temp = temp << 10;
+	set_itvc_reg(dev, ITVC_WRITE_DIR, temp);
+	temp = temp | (0x05 << 10);
+	set_itvc_reg(dev, ITVC_WRITE_DIR, temp);
 
 	/* write address byte 2;*/
-	temp = 0x82|MCI_MEMORY_ADDRESS_BYTE2 | MCI_MODE_MEMORY_WRITE |
-		((address & 0x003F0000)>>8);
-	temp = temp<<10;
-	setITVCReg(dev, ITVC_WRITE_DIR, temp);
-	temp = temp|((0x05)<<10);
-	setITVCReg(dev, ITVC_WRITE_DIR, temp);
+	temp = 0x82 | MCI_MEMORY_ADDRESS_BYTE2 | MCI_MODE_MEMORY_WRITE |
+		((address & 0x003F0000) >> 8);
+	temp = temp << 10;
+	set_itvc_reg(dev, ITVC_WRITE_DIR, temp);
+	temp = temp | (0x05 << 10);
+	set_itvc_reg(dev, ITVC_WRITE_DIR, temp);
 
 	/* write address byte 1;*/
-	temp = 0x82|MCI_MEMORY_ADDRESS_BYTE1 | (address & 0xFF00);
-	temp = temp<<10;
-	setITVCReg(dev, ITVC_WRITE_DIR, temp);
-	temp = temp|((0x05)<<10);
-	setITVCReg(dev, ITVC_WRITE_DIR, temp);
+	temp = 0x82 | MCI_MEMORY_ADDRESS_BYTE1 | (address & 0xFF00);
+	temp = temp << 10;
+	set_itvc_reg(dev, ITVC_WRITE_DIR, temp);
+	temp = temp | (0x05 << 10);
+	set_itvc_reg(dev, ITVC_WRITE_DIR, temp);
 
 	/* write address byte 0;*/
-	temp = 0x82|MCI_MEMORY_ADDRESS_BYTE0|((address & 0x00FF)<<8);
-	temp = temp<<10;
-	setITVCReg(dev, ITVC_WRITE_DIR, temp);
-	temp = temp|((0x05)<<10);
-	setITVCReg(dev, ITVC_WRITE_DIR, temp);
+	temp = 0x82 | MCI_MEMORY_ADDRESS_BYTE0 | ((address & 0x00FF) << 8);
+	temp = temp << 10;
+	set_itvc_reg(dev, ITVC_WRITE_DIR, temp);
+	temp = temp | (0x05 << 10);
+	set_itvc_reg(dev, ITVC_WRITE_DIR, temp);
 
 	/*wait for MIRDY line;*/
-	waitForMciComplete(dev);
+	wait_for_mci_complete(dev);
 
 	return 0;
 }
@@ -545,68 +568,68 @@ static int mc417_memory_read(struct cx231xx *dev, u32 address, u32 *value)
 	int ret = 0;
 
 	/*write address byte 2;*/
-	temp = 0x82|MCI_MEMORY_ADDRESS_BYTE2 | MCI_MODE_MEMORY_READ |
-		((address & 0x003F0000)>>8);
-	temp = temp<<10;
-	ret = setITVCReg(dev, ITVC_WRITE_DIR, temp);
+	temp = 0x82 | MCI_MEMORY_ADDRESS_BYTE2 | MCI_MODE_MEMORY_READ |
+		((address & 0x003F0000) >> 8);
+	temp = temp << 10;
+	ret = set_itvc_reg(dev, ITVC_WRITE_DIR, temp);
 	if (ret < 0)
 		return ret;
-	temp = temp|((0x05)<<10);
-	setITVCReg(dev, ITVC_WRITE_DIR, temp);
+	temp = temp | (0x05 << 10);
+	set_itvc_reg(dev, ITVC_WRITE_DIR, temp);
 
 	/*write address byte 1*/
-	temp = 0x82|MCI_MEMORY_ADDRESS_BYTE1 | (address & 0xFF00);
-	temp = temp<<10;
-	setITVCReg(dev, ITVC_WRITE_DIR, temp);
-	temp = temp|((0x05)<<10);
-	setITVCReg(dev, ITVC_WRITE_DIR, temp);
+	temp = 0x82 | MCI_MEMORY_ADDRESS_BYTE1 | (address & 0xFF00);
+	temp = temp << 10;
+	set_itvc_reg(dev, ITVC_WRITE_DIR, temp);
+	temp = temp | (0x05 << 10);
+	set_itvc_reg(dev, ITVC_WRITE_DIR, temp);
 
 	/*write address byte 0*/
-	temp = 0x82|MCI_MEMORY_ADDRESS_BYTE0 | ((address & 0x00FF)<<8);
-	temp = temp<<10;
-	setITVCReg(dev, ITVC_WRITE_DIR, temp);
-	temp = temp|((0x05)<<10);
-	setITVCReg(dev, ITVC_WRITE_DIR, temp);
+	temp = 0x82 | MCI_MEMORY_ADDRESS_BYTE0 | ((address & 0x00FF) << 8);
+	temp = temp << 10;
+	set_itvc_reg(dev, ITVC_WRITE_DIR, temp);
+	temp = temp | (0x05 << 10);
+	set_itvc_reg(dev, ITVC_WRITE_DIR, temp);
 
 	/*Wait for MIRDY line*/
-	ret = waitForMciComplete(dev);
+	ret = wait_for_mci_complete(dev);
 
 
 	/*Read data byte 3;*/
-	temp = (0x82|MCI_MEMORY_DATA_BYTE3)<<10;
-	setITVCReg(dev, ITVC_READ_DIR, temp);
-	temp = ((0x81|MCI_MEMORY_DATA_BYTE3)<<10);
-	setITVCReg(dev, ITVC_READ_DIR, temp);
-	getITVCReg(dev, ITVC_READ_DIR, &temp);
-	return_value |= ((temp&0x03FC0000)<<6);
-	setITVCReg(dev, ITVC_READ_DIR, (0x87<<10));
+	temp = (0x82 | MCI_MEMORY_DATA_BYTE3) << 10;
+	set_itvc_reg(dev, ITVC_READ_DIR, temp);
+	temp = ((0x81 | MCI_MEMORY_DATA_BYTE3) << 10);
+	set_itvc_reg(dev, ITVC_READ_DIR, temp);
+	get_itvc_reg(dev, ITVC_READ_DIR, &temp);
+	return_value |= ((temp & 0x03FC0000) << 6);
+	set_itvc_reg(dev, ITVC_READ_DIR, (0x87 << 10));
 
 	/*Read data byte 2;*/
-	temp = (0x82|MCI_MEMORY_DATA_BYTE2)<<10;
-	setITVCReg(dev, ITVC_READ_DIR, temp);
-	temp = ((0x81|MCI_MEMORY_DATA_BYTE2)<<10);
-	setITVCReg(dev, ITVC_READ_DIR, temp);
-	getITVCReg(dev, ITVC_READ_DIR, &temp);
-	return_value |= ((temp&0x03FC0000)>>2);
-	setITVCReg(dev, ITVC_READ_DIR, (0x87<<10));
+	temp = (0x82 | MCI_MEMORY_DATA_BYTE2) << 10;
+	set_itvc_reg(dev, ITVC_READ_DIR, temp);
+	temp = ((0x81 | MCI_MEMORY_DATA_BYTE2) << 10);
+	set_itvc_reg(dev, ITVC_READ_DIR, temp);
+	get_itvc_reg(dev, ITVC_READ_DIR, &temp);
+	return_value |= ((temp & 0x03FC0000) >> 2);
+	set_itvc_reg(dev, ITVC_READ_DIR, (0x87 << 10));
 
 	/* Read data byte 1;*/
-	temp = (0x82|MCI_MEMORY_DATA_BYTE1)<<10;
-	setITVCReg(dev, ITVC_READ_DIR, temp);
-	temp = ((0x81|MCI_MEMORY_DATA_BYTE1)<<10);
-	setITVCReg(dev, ITVC_READ_DIR, temp);
-	getITVCReg(dev, ITVC_READ_DIR, &temp);
-	return_value |= ((temp&0x03FC0000)>>10);
-	setITVCReg(dev, ITVC_READ_DIR, (0x87<<10));
+	temp = (0x82 | MCI_MEMORY_DATA_BYTE1) << 10;
+	set_itvc_reg(dev, ITVC_READ_DIR, temp);
+	temp = ((0x81 | MCI_MEMORY_DATA_BYTE1) << 10);
+	set_itvc_reg(dev, ITVC_READ_DIR, temp);
+	get_itvc_reg(dev, ITVC_READ_DIR, &temp);
+	return_value |= ((temp & 0x03FC0000) >> 10);
+	set_itvc_reg(dev, ITVC_READ_DIR, (0x87 << 10));
 
 	/*Read data byte 0;*/
-	temp = (0x82|MCI_MEMORY_DATA_BYTE0)<<10;
-	setITVCReg(dev, ITVC_READ_DIR, temp);
-	temp = ((0x81|MCI_MEMORY_DATA_BYTE0)<<10);
-	setITVCReg(dev, ITVC_READ_DIR, temp);
-	getITVCReg(dev, ITVC_READ_DIR, &temp);
-	return_value |= ((temp&0x03FC0000)>>18);
-	setITVCReg(dev, ITVC_READ_DIR, (0x87<<10));
+	temp = (0x82 | MCI_MEMORY_DATA_BYTE0) << 10;
+	set_itvc_reg(dev, ITVC_READ_DIR, temp);
+	temp = ((0x81 | MCI_MEMORY_DATA_BYTE0) << 10);
+	set_itvc_reg(dev, ITVC_READ_DIR, temp);
+	get_itvc_reg(dev, ITVC_READ_DIR, &temp);
+	return_value |= ((temp & 0x03FC0000) >> 18);
+	set_itvc_reg(dev, ITVC_READ_DIR, (0x87 << 10));
 
 	*value  = return_value;
 	return ret;
@@ -619,94 +642,91 @@ static char *cmd_to_str(int cmd)
 {
 	switch (cmd) {
 	case CX2341X_ENC_PING_FW:
-		return  "PING_FW";
+		return "PING_FW";
 	case CX2341X_ENC_START_CAPTURE:
-		return  "START_CAPTURE";
+		return "START_CAPTURE";
 	case CX2341X_ENC_STOP_CAPTURE:
-		return  "STOP_CAPTURE";
+		return "STOP_CAPTURE";
 	case CX2341X_ENC_SET_AUDIO_ID:
-		return  "SET_AUDIO_ID";
+		return "SET_AUDIO_ID";
 	case CX2341X_ENC_SET_VIDEO_ID:
-		return  "SET_VIDEO_ID";
+		return "SET_VIDEO_ID";
 	case CX2341X_ENC_SET_PCR_ID:
-		return  "SET_PCR_PID";
+		return "SET_PCR_PID";
 	case CX2341X_ENC_SET_FRAME_RATE:
-		return  "SET_FRAME_RATE";
+		return "SET_FRAME_RATE";
 	case CX2341X_ENC_SET_FRAME_SIZE:
-		return  "SET_FRAME_SIZE";
+		return "SET_FRAME_SIZE";
 	case CX2341X_ENC_SET_BIT_RATE:
-		return  "SET_BIT_RATE";
+		return "SET_BIT_RATE";
 	case CX2341X_ENC_SET_GOP_PROPERTIES:
-		return  "SET_GOP_PROPERTIES";
+		return "SET_GOP_PROPERTIES";
 	case CX2341X_ENC_SET_ASPECT_RATIO:
-		return  "SET_ASPECT_RATIO";
+		return "SET_ASPECT_RATIO";
 	case CX2341X_ENC_SET_DNR_FILTER_MODE:
-		return  "SET_DNR_FILTER_PROPS";
+		return "SET_DNR_FILTER_PROPS";
 	case CX2341X_ENC_SET_DNR_FILTER_PROPS:
-		return  "SET_DNR_FILTER_PROPS";
+		return "SET_DNR_FILTER_PROPS";
 	case CX2341X_ENC_SET_CORING_LEVELS:
-		return  "SET_CORING_LEVELS";
+		return "SET_CORING_LEVELS";
 	case CX2341X_ENC_SET_SPATIAL_FILTER_TYPE:
-		return  "SET_SPATIAL_FILTER_TYPE";
+		return "SET_SPATIAL_FILTER_TYPE";
 	case CX2341X_ENC_SET_VBI_LINE:
-		return  "SET_VBI_LINE";
+		return "SET_VBI_LINE";
 	case CX2341X_ENC_SET_STREAM_TYPE:
-		return  "SET_STREAM_TYPE";
+		return "SET_STREAM_TYPE";
 	case CX2341X_ENC_SET_OUTPUT_PORT:
-		return  "SET_OUTPUT_PORT";
+		return "SET_OUTPUT_PORT";
 	case CX2341X_ENC_SET_AUDIO_PROPERTIES:
-		return  "SET_AUDIO_PROPERTIES";
+		return "SET_AUDIO_PROPERTIES";
 	case CX2341X_ENC_HALT_FW:
-		return  "HALT_FW";
+		return "HALT_FW";
 	case CX2341X_ENC_GET_VERSION:
-		return  "GET_VERSION";
+		return "GET_VERSION";
 	case CX2341X_ENC_SET_GOP_CLOSURE:
-		return  "SET_GOP_CLOSURE";
+		return "SET_GOP_CLOSURE";
 	case CX2341X_ENC_GET_SEQ_END:
-		return  "GET_SEQ_END";
+		return "GET_SEQ_END";
 	case CX2341X_ENC_SET_PGM_INDEX_INFO:
-		return  "SET_PGM_INDEX_INFO";
+		return "SET_PGM_INDEX_INFO";
 	case CX2341X_ENC_SET_VBI_CONFIG:
-		return  "SET_VBI_CONFIG";
+		return "SET_VBI_CONFIG";
 	case CX2341X_ENC_SET_DMA_BLOCK_SIZE:
-		return  "SET_DMA_BLOCK_SIZE";
+		return "SET_DMA_BLOCK_SIZE";
 	case CX2341X_ENC_GET_PREV_DMA_INFO_MB_10:
-		return  "GET_PREV_DMA_INFO_MB_10";
+		return "GET_PREV_DMA_INFO_MB_10";
 	case CX2341X_ENC_GET_PREV_DMA_INFO_MB_9:
-		return  "GET_PREV_DMA_INFO_MB_9";
+		return "GET_PREV_DMA_INFO_MB_9";
 	case CX2341X_ENC_SCHED_DMA_TO_HOST:
-		return  "SCHED_DMA_TO_HOST";
+		return "SCHED_DMA_TO_HOST";
 	case CX2341X_ENC_INITIALIZE_INPUT:
-		return  "INITIALIZE_INPUT";
+		return "INITIALIZE_INPUT";
 	case CX2341X_ENC_SET_FRAME_DROP_RATE:
-		return  "SET_FRAME_DROP_RATE";
+		return "SET_FRAME_DROP_RATE";
 	case CX2341X_ENC_PAUSE_ENCODER:
-		return  "PAUSE_ENCODER";
+		return "PAUSE_ENCODER";
 	case CX2341X_ENC_REFRESH_INPUT:
-		return  "REFRESH_INPUT";
+		return "REFRESH_INPUT";
 	case CX2341X_ENC_SET_COPYRIGHT:
-		return  "SET_COPYRIGHT";
+		return "SET_COPYRIGHT";
 	case CX2341X_ENC_SET_EVENT_NOTIFICATION:
-		return  "SET_EVENT_NOTIFICATION";
+		return "SET_EVENT_NOTIFICATION";
 	case CX2341X_ENC_SET_NUM_VSYNC_LINES:
-		return  "SET_NUM_VSYNC_LINES";
+		return "SET_NUM_VSYNC_LINES";
 	case CX2341X_ENC_SET_PLACEHOLDER:
-		return  "SET_PLACEHOLDER";
+		return "SET_PLACEHOLDER";
 	case CX2341X_ENC_MUTE_VIDEO:
-		return  "MUTE_VIDEO";
+		return "MUTE_VIDEO";
 	case CX2341X_ENC_MUTE_AUDIO:
-		return  "MUTE_AUDIO";
+		return "MUTE_AUDIO";
 	case CX2341X_ENC_MISC:
-		return  "MISC";
+		return "MISC";
 	default:
 		return "UNKNOWN";
 	}
 }
 
-static int cx231xx_mbox_func(void *priv,
-			     u32 command,
-			     int in,
-			     int out,
+static int cx231xx_mbox_func(void *priv, u32 command, int in, int out,
 			     u32 data[CX2341X_MBOX_MAX_DATA])
 {
 	struct cx231xx *dev = priv;
@@ -721,10 +741,8 @@ static int cx231xx_mbox_func(void *priv,
 	   without side effects */
 	mc417_memory_read(dev, dev->cx23417_mailbox - 4, &value);
 	if (value != 0x12345678) {
-		dprintk(3,
-			"Firmware and/or mailbox pointer not initialized "
-			"or corrupted, signature = 0x%x, cmd = %s\n", value,
-			cmd_to_str(command));
+		dprintk(3, "Firmware and/or mailbox pointer not initialized or corrupted, signature = 0x%x, cmd = %s\n",
+			value, cmd_to_str(command));
 		return -1;
 	}
 
@@ -733,8 +751,8 @@ static int cx231xx_mbox_func(void *priv,
 	 */
 	mc417_memory_read(dev, dev->cx23417_mailbox, &flag);
 	if (flag) {
-		dprintk(3, "ERROR: Mailbox appears to be in use "
-			"(%x), cmd = %s\n", flag, cmd_to_str(command));
+		dprintk(3, "ERROR: Mailbox appears to be in use (%x), cmd = %s\n",
+				flag, cmd_to_str(command));
 		return -1;
 	}
 
@@ -787,11 +805,8 @@ static int cx231xx_mbox_func(void *priv,
 /* We don't need to call the API often, so using just one
  * mailbox will probably suffice
  */
-static int cx231xx_api_cmd(struct cx231xx *dev,
-			   u32 command,
-			   u32 inputcnt,
-			   u32 outputcnt,
-			   ...)
+static int cx231xx_api_cmd(struct cx231xx *dev, u32 command,
+		u32 inputcnt, u32 outputcnt, ...)
 {
 	u32 data[CX2341X_MBOX_MAX_DATA];
 	va_list vargs;
@@ -834,81 +849,80 @@ static int cx231xx_find_mailbox(struct cx231xx *dev)
 		else
 			signaturecnt = 0;
 		if (4 == signaturecnt) {
-			dprintk(1, "Mailbox signature found at 0x%x\n", i+1);
-			return i+1;
+			dprintk(1, "Mailbox signature found at 0x%x\n", i + 1);
+			return i + 1;
 		}
 	}
 	dprintk(3, "Mailbox signature values not found!\n");
 	return -1;
 }
 
-static void mciWriteMemoryToGPIO(struct cx231xx *dev, u32 address, u32 value,
+static void mci_write_memory_to_gpio(struct cx231xx *dev, u32 address, u32 value,
 		u32 *p_fw_image)
 {
-
 	u32 temp = 0;
 	int i = 0;
 
-	temp = 0x82|MCI_MEMORY_DATA_BYTE0|((value&0x000000FF)<<8);
-	temp = temp<<10;
+	temp = 0x82 | MCI_MEMORY_DATA_BYTE0 | ((value & 0x000000FF) << 8);
+	temp = temp << 10;
 	*p_fw_image = temp;
 	p_fw_image++;
-	temp = temp|((0x05)<<10);
+	temp = temp | (0x05 << 10);
 	*p_fw_image = temp;
 	p_fw_image++;
 
 	/*write data byte 1;*/
-	temp = 0x82|MCI_MEMORY_DATA_BYTE1|(value&0x0000FF00);
-	temp = temp<<10;
+	temp = 0x82 | MCI_MEMORY_DATA_BYTE1 | (value & 0x0000FF00);
+	temp = temp << 10;
 	*p_fw_image = temp;
 	p_fw_image++;
-	temp = temp|((0x05)<<10);
+	temp = temp | (0x05 << 10);
 	*p_fw_image = temp;
 	p_fw_image++;
 
 	/*write data byte 2;*/
-	temp = 0x82|MCI_MEMORY_DATA_BYTE2|((value&0x00FF0000)>>8);
-	temp = temp<<10;
+	temp = 0x82 | MCI_MEMORY_DATA_BYTE2 | ((value & 0x00FF0000) >> 8);
+	temp = temp << 10;
 	*p_fw_image = temp;
 	p_fw_image++;
-	temp = temp|((0x05)<<10);
+	temp = temp | (0x05 << 10);
 	*p_fw_image = temp;
 	p_fw_image++;
 
 	/*write data byte 3;*/
-	temp = 0x82|MCI_MEMORY_DATA_BYTE3|((value&0xFF000000)>>16);
-	temp = temp<<10;
+	temp = 0x82 | MCI_MEMORY_DATA_BYTE3 | ((value & 0xFF000000) >> 16);
+	temp = temp << 10;
 	*p_fw_image = temp;
 	p_fw_image++;
-	temp = temp|((0x05)<<10);
+	temp = temp | (0x05 << 10);
 	*p_fw_image = temp;
 	p_fw_image++;
 
 	/* write address byte 2;*/
-	temp = 0x82|MCI_MEMORY_ADDRESS_BYTE2 | MCI_MODE_MEMORY_WRITE |
-		((address & 0x003F0000)>>8);
-	temp = temp<<10;
+	temp = 0x82 | MCI_MEMORY_ADDRESS_BYTE2 | MCI_MODE_MEMORY_WRITE |
+		((address & 0x003F0000) >> 8);
+	temp = temp << 10;
 	*p_fw_image = temp;
 	p_fw_image++;
-	temp = temp|((0x05)<<10);
+	temp = temp | (0x05 << 10);
 	*p_fw_image = temp;
 	p_fw_image++;
 
 	/* write address byte 1;*/
-	temp = 0x82|MCI_MEMORY_ADDRESS_BYTE1 | (address & 0xFF00);
-	temp = temp<<10;
+	temp = 0x82 | MCI_MEMORY_ADDRESS_BYTE1 | (address & 0xFF00);
+	temp = temp << 10;
 	*p_fw_image = temp;
 	p_fw_image++;
-	temp = temp|((0x05)<<10);
+	temp = temp | (0x05 << 10);
 	*p_fw_image = temp;
 	p_fw_image++;
 
 	/* write address byte 0;*/
-	temp = 0x82|MCI_MEMORY_ADDRESS_BYTE0|((address & 0x00FF)<<8);
-	temp = temp<<10;
+	temp = 0x82 | MCI_MEMORY_ADDRESS_BYTE0 | ((address & 0x00FF) << 8);
+	temp = temp << 10;
 	*p_fw_image = temp;
 	p_fw_image++;
-	temp = temp|((0x05)<<10);
+	temp = temp | (0x05 << 10);
 	*p_fw_image = temp;
 	p_fw_image++;
 
@@ -971,8 +985,7 @@ static int cx231xx_load_firmware(struct cx231xx *dev)
 		IVTV_REG_APU, 0);
 
 	if (retval != 0) {
-		printk(KERN_ERR "%s: Error with mc417_register_write\n",
-			__func__);
+		pr_err("%s: Error with mc417_register_write\n", __func__);
 		return -1;
 	}
 
@@ -980,25 +993,21 @@ static int cx231xx_load_firmware(struct cx231xx *dev)
 				  &dev->udev->dev);
 
 	if (retval != 0) {
-		printk(KERN_ERR
-			"ERROR: Hotplug firmware request failed (%s).\n",
+		pr_err("ERROR: Hotplug firmware request failed (%s).\n",
 			CX231xx_FIRM_IMAGE_NAME);
-		printk(KERN_ERR "Please fix your hotplug setup, the board will "
-			"not work without firmware loaded!\n");
+		pr_err("Please fix your hotplug setup, the board will not work without firmware loaded!\n");
 		return -1;
 	}
 
 	if (firmware->size != CX231xx_FIRM_IMAGE_SIZE) {
-		printk(KERN_ERR "ERROR: Firmware size mismatch "
-			"(have %zd, expected %d)\n",
+		pr_err("ERROR: Firmware size mismatch (have %zd, expected %d)\n",
 			firmware->size, CX231xx_FIRM_IMAGE_SIZE);
 		release_firmware(firmware);
 		return -1;
 	}
 
 	if (0 != memcmp(firmware->data, magic, 8)) {
-		printk(KERN_ERR
-			"ERROR: Firmware magic mismatch, wrong file?\n");
+		pr_err("ERROR: Firmware magic mismatch, wrong file?\n");
 		release_firmware(firmware);
 		return -1;
 	}
@@ -1013,7 +1022,7 @@ static int cx231xx_load_firmware(struct cx231xx *dev)
 		 transfer_size += 4) {
 		fw_data = *p_fw_data;
 
-		 mciWriteMemoryToGPIO(dev, address, fw_data, p_current_fw);
+		mci_write_memory_to_gpio(dev, address, fw_data, p_current_fw);
 		address = address + 1;
 		p_current_fw += 20;
 		p_fw_data += 1;
@@ -1045,7 +1054,7 @@ static int cx231xx_load_firmware(struct cx231xx *dev)
 	retval |= mc417_register_write(dev, IVTV_REG_HW_BLOCKS,
 		IVTV_CMD_HW_BLOCKS_RST);
 	if (retval < 0) {
-		printk(KERN_ERR "%s: Error with mc417_register_write\n",
+		pr_err("%s: Error with mc417_register_write\n",
 			__func__);
 		return retval;
 	}
@@ -1057,7 +1066,7 @@ static int cx231xx_load_firmware(struct cx231xx *dev)
 	retval |= mc417_register_write(dev, IVTV_REG_VPU, value & 0xFFFFFFE8);
 
 	if (retval < 0) {
-		printk(KERN_ERR "%s: Error with mc417_register_write\n",
+		pr_err("%s: Error with mc417_register_write\n",
 			__func__);
 		return retval;
 	}
@@ -1105,27 +1114,25 @@ static int cx231xx_initialize_codec(struct cx231xx *dev)
 		dprintk(2, "%s() PING OK\n", __func__);
 		retval = cx231xx_load_firmware(dev);
 		if (retval < 0) {
-			printk(KERN_ERR "%s() f/w load failed\n", __func__);
+			pr_err("%s() f/w load failed\n", __func__);
 			return retval;
 		}
 		retval = cx231xx_find_mailbox(dev);
 		if (retval < 0) {
-			printk(KERN_ERR "%s() mailbox < 0, error\n",
+			pr_err("%s() mailbox < 0, error\n",
 				__func__);
 			return -1;
 		}
 		dev->cx23417_mailbox = retval;
 		retval = cx231xx_api_cmd(dev, CX2341X_ENC_PING_FW, 0, 0);
 		if (retval < 0) {
-			printk(KERN_ERR
-				"ERROR: cx23417 firmware ping failed!\n");
+			pr_err("ERROR: cx23417 firmware ping failed!\n");
 			return -1;
 		}
 		retval = cx231xx_api_cmd(dev, CX2341X_ENC_GET_VERSION, 0, 1,
 			&version);
 		if (retval < 0) {
-			printk(KERN_ERR "ERROR: cx23417 firmware get encoder :"
-				"version failed!\n");
+			pr_err("ERROR: cx23417 firmware get encoder: version failed!\n");
 			return -1;
 		}
 		dprintk(1, "cx23417 firmware version is 0x%08x\n", version);
@@ -1134,7 +1141,7 @@ static int cx231xx_initialize_codec(struct cx231xx *dev)
 
 	for (i = 0; i < 1; i++) {
 		retval = mc417_register_read(dev, 0x20f8, &val);
-		dprintk(3, "***before enable656() VIM Capture Lines =%d ***\n",
+		dprintk(3, "***before enable656() VIM Capture Lines = %d ***\n",
 				 val);
 		if (retval < 0)
 			return retval;
@@ -1202,7 +1209,7 @@ static int cx231xx_initialize_codec(struct cx231xx *dev)
 
 	for (i = 0; i < 1; i++) {
 		mc417_register_read(dev, 0x20f8, &val);
-	dprintk(3, "***VIM Capture Lines =%d ***\n", val);
+		dprintk(3, "***VIM Capture Lines =%d ***\n", val);
 	}
 
 	return 0;
@@ -1250,91 +1257,85 @@ static void free_buffer(struct videobuf_queue *vq, struct cx231xx_buffer *buf)
 static void buffer_copy(struct cx231xx *dev, char *data, int len, struct urb *urb,
 		struct cx231xx_dmaqueue *dma_q)
 {
-		void *vbuf;
-		struct cx231xx_buffer *buf;
-		u32 tail_data = 0;
-		char *p_data;
-
-		if (dma_q->mpeg_buffer_done == 0) {
-			if (list_empty(&dma_q->active))
-				return;
-
-			buf = list_entry(dma_q->active.next,
-					struct cx231xx_buffer, vb.queue);
-			dev->video_mode.isoc_ctl.buf = buf;
-			dma_q->mpeg_buffer_done = 1;
-		}
-		/* Fill buffer */
-		buf = dev->video_mode.isoc_ctl.buf;
-		vbuf = videobuf_to_vmalloc(&buf->vb);
-
-		if ((dma_q->mpeg_buffer_completed+len) <
-		   mpeglines*mpeglinesize) {
-			if (dma_q->add_ps_package_head ==
-			   CX231XX_NEED_ADD_PS_PACKAGE_HEAD) {
-				memcpy(vbuf+dma_q->mpeg_buffer_completed,
-				       dma_q->ps_head, 3);
-				dma_q->mpeg_buffer_completed =
-				  dma_q->mpeg_buffer_completed + 3;
-				dma_q->add_ps_package_head =
-				  CX231XX_NONEED_PS_PACKAGE_HEAD;
-			}
-			memcpy(vbuf+dma_q->mpeg_buffer_completed, data, len);
-			dma_q->mpeg_buffer_completed =
-			  dma_q->mpeg_buffer_completed + len;
-		} else {
-			dma_q->mpeg_buffer_done = 0;
-
-			tail_data =
-			  mpeglines*mpeglinesize - dma_q->mpeg_buffer_completed;
-			memcpy(vbuf+dma_q->mpeg_buffer_completed,
-			       data, tail_data);
-
-			buf->vb.state = VIDEOBUF_DONE;
-			buf->vb.field_count++;
-			v4l2_get_timestamp(&buf->vb.ts);
-			list_del(&buf->vb.queue);
-			wake_up(&buf->vb.done);
-			dma_q->mpeg_buffer_completed = 0;
-
-			if (len - tail_data > 0) {
-				p_data = data + tail_data;
-				dma_q->left_data_count = len - tail_data;
-				memcpy(dma_q->p_left_data,
-				       p_data, len - tail_data);
-			}
-
-		}
-
-	    return;
-}
-
-static void buffer_filled(char *data, int len, struct urb *urb,
-		struct cx231xx_dmaqueue *dma_q)
-{
-		void *vbuf;
-		struct cx231xx_buffer *buf;
+	void *vbuf;
+	struct cx231xx_buffer *buf;
+	u32 tail_data = 0;
+	char *p_data;
 
+	if (dma_q->mpeg_buffer_done == 0) {
 		if (list_empty(&dma_q->active))
 			return;
 
-
 		buf = list_entry(dma_q->active.next,
-				 struct cx231xx_buffer, vb.queue);
+				struct cx231xx_buffer, vb.queue);
+		dev->video_mode.isoc_ctl.buf = buf;
+		dma_q->mpeg_buffer_done = 1;
+	}
+	/* Fill buffer */
+	buf = dev->video_mode.isoc_ctl.buf;
+	vbuf = videobuf_to_vmalloc(&buf->vb);
+
+	if ((dma_q->mpeg_buffer_completed+len) <
+			mpeglines*mpeglinesize) {
+		if (dma_q->add_ps_package_head ==
+				CX231XX_NEED_ADD_PS_PACKAGE_HEAD) {
+			memcpy(vbuf+dma_q->mpeg_buffer_completed,
+					dma_q->ps_head, 3);
+			dma_q->mpeg_buffer_completed =
+				dma_q->mpeg_buffer_completed + 3;
+			dma_q->add_ps_package_head =
+				CX231XX_NONEED_PS_PACKAGE_HEAD;
+		}
+		memcpy(vbuf+dma_q->mpeg_buffer_completed, data, len);
+		dma_q->mpeg_buffer_completed =
+			dma_q->mpeg_buffer_completed + len;
+	} else {
+		dma_q->mpeg_buffer_done = 0;
 
+		tail_data =
+			mpeglines*mpeglinesize - dma_q->mpeg_buffer_completed;
+		memcpy(vbuf+dma_q->mpeg_buffer_completed,
+				data, tail_data);
 
-		/* Fill buffer */
-		vbuf = videobuf_to_vmalloc(&buf->vb);
-		memcpy(vbuf, data, len);
 		buf->vb.state = VIDEOBUF_DONE;
 		buf->vb.field_count++;
 		v4l2_get_timestamp(&buf->vb.ts);
 		list_del(&buf->vb.queue);
 		wake_up(&buf->vb.done);
+		dma_q->mpeg_buffer_completed = 0;
+
+		if (len - tail_data > 0) {
+			p_data = data + tail_data;
+			dma_q->left_data_count = len - tail_data;
+			memcpy(dma_q->p_left_data,
+					p_data, len - tail_data);
+		}
+	}
+}
 
-	    return;
+static void buffer_filled(char *data, int len, struct urb *urb,
+		struct cx231xx_dmaqueue *dma_q)
+{
+	void *vbuf;
+	struct cx231xx_buffer *buf;
+
+	if (list_empty(&dma_q->active))
+		return;
+
+	buf = list_entry(dma_q->active.next,
+			struct cx231xx_buffer, vb.queue);
+
+	/* Fill buffer */
+	vbuf = videobuf_to_vmalloc(&buf->vb);
+	memcpy(vbuf, data, len);
+	buf->vb.state = VIDEOBUF_DONE;
+	buf->vb.field_count++;
+	v4l2_get_timestamp(&buf->vb.ts);
+	list_del(&buf->vb.queue);
+	wake_up(&buf->vb.done);
 }
-static inline int cx231xx_isoc_copy(struct cx231xx *dev, struct urb *urb)
+
+static int cx231xx_isoc_copy(struct cx231xx *dev, struct urb *urb)
 {
 	struct cx231xx_dmaqueue *dma_q = urb->context;
 	unsigned char *p_buffer;
@@ -1359,11 +1360,9 @@ static inline int cx231xx_isoc_copy(struct cx231xx *dev, struct urb *urb)
 
 	return 0;
 }
-static inline int cx231xx_bulk_copy(struct cx231xx *dev, struct urb *urb)
-{
 
-	/*char *outp;*/
-	/*struct cx231xx_buffer *buf;*/
+static int cx231xx_bulk_copy(struct cx231xx *dev, struct urb *urb)
+{
 	struct cx231xx_dmaqueue *dma_q = urb->context;
 	unsigned char *p_buffer, *buffer;
 	u32 buffer_size = 0;
@@ -1394,8 +1393,6 @@ static int bb_buf_prepare(struct videobuf_queue *q,
 	int rc = 0, urb_init = 0;
 	int size = fh->dev->ts1.ts_packet_size * fh->dev->ts1.ts_packet_count;
 
-	dma_qq = &dev->video_mode.vidq;
-
 	if (0 != buf->vb.baddr  &&  buf->vb.bsize < size)
 		return -EINVAL;
 	buf->vb.width = fh->dev->ts1.ts_packet_size;
@@ -1521,6 +1518,7 @@ static int vidioc_g_std(struct file *file, void *fh0, v4l2_std_id *norm)
 	*norm = dev->encodernorm.id;
 	return 0;
 }
+
 static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id *id)
 {
 	struct cx231xx_fh  *fh  = file->private_data;
@@ -1552,7 +1550,8 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id *id)
 	dprintk(3, "exit vidioc_s_std() i=0x%x\n", i);
 	return 0;
 }
-static const char *iname[] = {
+
+static const char * const iname[] = {
 	[CX231XX_VMUX_COMPOSITE1] = "Composite1",
 	[CX231XX_VMUX_SVIDEO]     = "S-Video",
 	[CX231XX_VMUX_TELEVISION] = "Television",
@@ -1560,6 +1559,7 @@ static const char *iname[] = {
 	[CX231XX_VMUX_DVB]        = "DVB",
 	[CX231XX_VMUX_DEBUG]      = "for debug only",
 };
+
 static int vidioc_enum_input(struct file *file, void *priv,
 				struct v4l2_input *i)
 {
@@ -1572,7 +1572,6 @@ static int vidioc_enum_input(struct file *file, void *priv,
 	if (i->index >= 4)
 		return -EINVAL;
 
-
 	input = &cx231xx_boards[dev->model].input[i->index];
 
 	if (input->type == 0)
@@ -1589,8 +1588,6 @@ static int vidioc_enum_input(struct file *file, void *priv,
 		i->type = V4L2_INPUT_TYPE_TUNER;
 	else
 		i->type  = V4L2_INPUT_TYPE_CAMERA;
-
-
 	return 0;
 }
 
@@ -1621,6 +1618,7 @@ static int vidioc_s_ctrl(struct file *file, void *priv,
 {
 	struct cx231xx_fh  *fh  = file->private_data;
 	struct cx231xx *dev = fh->dev;
+
 	dprintk(3, "enter vidioc_s_ctrl()\n");
 	/* Update the A/V core */
 	call_all(dev, core, s_ctrl, ctl);
@@ -1631,7 +1629,6 @@ static int vidioc_s_ctrl(struct file *file, void *priv,
 static int vidioc_enum_fmt_vid_cap(struct file *file, void  *priv,
 					struct v4l2_fmtdesc *f)
 {
-
 	if (f->index != 0)
 		return -EINVAL;
 
@@ -1717,22 +1714,22 @@ static int vidioc_streamon(struct file *file, void *priv,
 				enum v4l2_buf_type i)
 {
 	struct cx231xx_fh  *fh  = file->private_data;
-
 	struct cx231xx *dev = fh->dev;
+
 	dprintk(3, "enter vidioc_streamon()\n");
-		cx231xx_set_alt_setting(dev, INDEX_TS1, 0);
-		cx231xx_set_mode(dev, CX231XX_DIGITAL_MODE);
-		if (dev->USE_ISO)
-			cx231xx_init_isoc(dev, CX231XX_NUM_PACKETS,
-				       CX231XX_NUM_BUFS,
-				       dev->video_mode.max_pkt_size,
-				       cx231xx_isoc_copy);
-		else {
-			cx231xx_init_bulk(dev, 320,
-				       5,
-				       dev->ts1_mode.max_pkt_size,
-				       cx231xx_bulk_copy);
-		}
+	cx231xx_set_alt_setting(dev, INDEX_TS1, 0);
+	cx231xx_set_mode(dev, CX231XX_DIGITAL_MODE);
+	if (dev->USE_ISO)
+		cx231xx_init_isoc(dev, CX231XX_NUM_PACKETS,
+				CX231XX_NUM_BUFS,
+				dev->video_mode.max_pkt_size,
+				cx231xx_isoc_copy);
+	else {
+		cx231xx_init_bulk(dev, 320,
+				5,
+				dev->ts1_mode.max_pkt_size,
+				cx231xx_bulk_copy);
+	}
 	dprintk(3, "exit vidioc_streamon()\n");
 	return videobuf_streamon(&fh->vidq);
 }
@@ -1749,6 +1746,7 @@ static int vidioc_g_ext_ctrls(struct file *file, void *priv,
 {
 	struct cx231xx_fh  *fh  = priv;
 	struct cx231xx *dev = fh->dev;
+
 	dprintk(3, "enter vidioc_g_ext_ctrls()\n");
 	if (f->ctrl_class != V4L2_CTRL_CLASS_MPEG)
 		return -EINVAL;
@@ -1763,6 +1761,7 @@ static int vidioc_s_ext_ctrls(struct file *file, void *priv,
 	struct cx231xx *dev = fh->dev;
 	struct cx2341x_mpeg_params p;
 	int err;
+
 	dprintk(3, "enter vidioc_s_ext_ctrls()\n");
 	if (f->ctrl_class != V4L2_CTRL_CLASS_MPEG)
 		return -EINVAL;
@@ -1776,9 +1775,6 @@ static int vidioc_s_ext_ctrls(struct file *file, void *priv,
 	}
 
 	return err;
-
-
-return 0;
 }
 
 static int vidioc_try_ext_ctrls(struct file *file, void *priv,
@@ -1788,6 +1784,7 @@ static int vidioc_try_ext_ctrls(struct file *file, void *priv,
 	struct cx231xx *dev = fh->dev;
 	struct cx2341x_mpeg_params p;
 	int err;
+
 	dprintk(3, "enter vidioc_try_ext_ctrls()\n");
 	if (f->ctrl_class != V4L2_CTRL_CLASS_MPEG)
 		return -EINVAL;
@@ -1805,14 +1802,8 @@ static int vidioc_log_status(struct file *file, void *priv)
 	char name[32 + 2];
 
 	snprintf(name, sizeof(name), "%s/2", dev->name);
-	dprintk(3,
-		"%s/2: ============  START LOG STATUS  ============\n",
-	       dev->name);
 	call_all(dev, core, log_status);
 	cx2341x_log_status(&dev->mpeg_params, name);
-	dprintk(3,
-		"%s/2: =============  END LOG STATUS  =============\n",
-	       dev->name);
 	return 0;
 }
 
@@ -1821,6 +1812,7 @@ static int vidioc_querymenu(struct file *file, void *priv,
 {
 	struct cx231xx_fh  *fh  = priv;
 	struct cx231xx *dev = fh->dev;
+
 	dprintk(3, "enter vidioc_querymenu()\n");
 	dprintk(3, "exit vidioc_querymenu()\n");
 	return cx231xx_querymenu(dev, a);
@@ -1831,6 +1823,7 @@ static int vidioc_queryctrl(struct file *file, void *priv,
 {
 	struct cx231xx_fh  *fh  = priv;
 	struct cx231xx *dev = fh->dev;
+
 	dprintk(3, "enter vidioc_queryctrl()\n");
 	dprintk(3, "exit vidioc_queryctrl()\n");
 	return cx231xx_queryctrl(dev, c);
@@ -1881,7 +1874,6 @@ static int mpeg_open(struct file *file)
 			    fh, &dev->lock);
 */
 
-
 	cx231xx_set_alt_setting(dev, INDEX_VANC, 1);
 	cx231xx_set_gpio_value(dev, 2, 0);
 
@@ -1909,16 +1901,16 @@ static int mpeg_release(struct file *file)
 
 	cx231xx_stop_TS1(dev);
 
-		/* do this before setting alternate! */
-		if (dev->USE_ISO)
-			cx231xx_uninit_isoc(dev);
-		else
-			cx231xx_uninit_bulk(dev);
-		cx231xx_set_mode(dev, CX231XX_SUSPEND);
+	/* do this before setting alternate! */
+	if (dev->USE_ISO)
+		cx231xx_uninit_isoc(dev);
+	else
+		cx231xx_uninit_bulk(dev);
+	cx231xx_set_mode(dev, CX231XX_SUSPEND);
 
-		cx231xx_api_cmd(fh->dev, CX2341X_ENC_STOP_CAPTURE, 3, 0,
-				CX231xx_END_NOW, CX231xx_MPEG_CAPTURE,
-				CX231xx_RAW_BITS_NONE);
+	cx231xx_api_cmd(fh->dev, CX2341X_ENC_STOP_CAPTURE, 3, 0,
+			CX231xx_END_NOW, CX231xx_MPEG_CAPTURE,
+			CX231xx_RAW_BITS_NONE);
 
 	/* FIXME: Review this crap */
 	/* Shut device down on last close */
@@ -1950,7 +1942,6 @@ static ssize_t mpeg_read(struct file *file, char __user *data,
 	struct cx231xx_fh *fh = file->private_data;
 	struct cx231xx *dev = fh->dev;
 
-
 	/* Deal w/ A/V decoder * and mpeg encoder sync issues. */
 	/* Start mpeg encoder on first read. */
 	if (atomic_cmpxchg(&fh->v4l_reading, 0, 1) == 0) {
@@ -1968,9 +1959,6 @@ static unsigned int mpeg_poll(struct file *file,
 	struct poll_table_struct *wait)
 {
 	struct cx231xx_fh *fh = file->private_data;
-	/*struct cx231xx *dev = fh->dev;*/
-
-	/*dprintk(2, "%s\n", __func__);*/
 
 	return videobuf_poll_stream(file, &fh->vidq, wait);
 }
-- 
1.7.10.4

