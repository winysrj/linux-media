Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway04.websitewelcome.com ([69.93.154.2]:48648 "HELO
	gateway04.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750881Ab0CEFOP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Mar 2010 00:14:15 -0500
Date: Thu, 4 Mar 2010 15:47:33 -0800 (PST)
From: "Dean A." <dean@sensoray.com>
Subject: [PATCH] s2255drv: fixes for big endian arch
To: mchehab@infradead.org, linux-media@vger.kernel.org
Message-ID: <tkrat.52c69169fe0f142c@sensoray.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

# HG changeset patch
# User Dean Anderson <dean@sensoray.com>
# Date 1267746208 28800
# Node ID ff343fa70b4def92d35f9ef7ee56a953b012d169
# Parent  c9c1bcda21557cea425589f281b6b3100e2c15a0
s2255drv: fixes for big endian arch

From: Dean Anderson <dean@sensoray.com>

s2255drv fixes for big endian architecture

Priority: normal

Signed-off-by: Dean Anderson <dean@sensoray.com>

diff -r c9c1bcda2155 -r ff343fa70b4d linux/drivers/media/video/s2255drv.c
--- a/linux/drivers/media/video/s2255drv.c	Wed Mar 03 14:28:53 2010 -0800
+++ b/linux/drivers/media/video/s2255drv.c	Thu Mar 04 15:43:28 2010 -0800
@@ -78,11 +78,11 @@
 #define S2255_SETMODE_TIMEOUT   500
 #define S2255_VIDSTATUS_TIMEOUT 350
 #define MAX_CHANNELS		4
-#define S2255_MARKER_FRAME	0x2255DA4AL
-#define S2255_MARKER_RESPONSE	0x2255ACACL
-#define S2255_RESPONSE_SETMODE  0x01
-#define S2255_RESPONSE_FW       0x10
-#define S2255_RESPONSE_STATUS   0x20
+#define S2255_MARKER_FRAME	cpu_to_le32(0x2255DA4AL)
+#define S2255_MARKER_RESPONSE	cpu_to_le32(0x2255ACACL)
+#define S2255_RESPONSE_SETMODE  cpu_to_le32(0x01)
+#define S2255_RESPONSE_FW       cpu_to_le32(0x10)
+#define S2255_RESPONSE_STATUS   cpu_to_le32(0x20)
 #define S2255_USB_XFER_SIZE	(16 * 1024)
 #define MAX_CHANNELS		4
 #define MAX_PIPE_BUFFERS	1
@@ -141,12 +141,12 @@
 #define DEF_HUE		0
 
 /* usb config commands */
-#define IN_DATA_TOKEN	0x2255c0de
-#define CMD_2255	0xc2255000
-#define CMD_SET_MODE	(CMD_2255 | 0x10)
-#define CMD_START	(CMD_2255 | 0x20)
-#define CMD_STOP	(CMD_2255 | 0x30)
-#define CMD_STATUS	(CMD_2255 | 0x40)
+#define IN_DATA_TOKEN	cpu_to_le32(0x2255c0de)
+#define CMD_2255	cpu_to_le32(0xc2255000)
+#define CMD_SET_MODE	cpu_to_le32((CMD_2255 | 0x10))
+#define CMD_START	cpu_to_le32((CMD_2255 | 0x20))
+#define CMD_STOP	cpu_to_le32((CMD_2255 | 0x30))
+#define CMD_STATUS	cpu_to_le32((CMD_2255 | 0x40))
 
 struct s2255_mode {
 	u32 format;	/* input video format (NTSC, PAL) */
@@ -310,7 +310,7 @@
 /* Need DSP version 5+ for video status feature */
 #define S2255_MIN_DSP_STATUS    5
 #define S2255_MAJOR_VERSION	1
-#define S2255_MINOR_VERSION	15
+#define S2255_MINOR_VERSION	16
 #define S2255_RELEASE		0
 #define S2255_VERSION		KERNEL_VERSION(S2255_MAJOR_VERSION, \
 					       S2255_MINOR_VERSION, \
@@ -1219,9 +1219,8 @@
 			  struct s2255_mode *mode)
 {
 	int res;
-	u32 *buffer;
+	__le32 *buffer;
 	unsigned long chn_rev;
-
 	mutex_lock(&dev->lock);
 	chn_rev = G_chnmap[chn];
 	dprintk(3, "mode scale [%ld] %p %d\n", chn, mode, mode->scale);
@@ -1247,7 +1246,7 @@
 
 	/* set the mode */
 	buffer[0] = IN_DATA_TOKEN;
-	buffer[1] = (u32) chn_rev;
+	buffer[1] = (__le32) cpu_to_le32(chn_rev);
 	buffer[2] = CMD_SET_MODE;
 	memcpy(&buffer[3], &dev->mode[chn], sizeof(struct s2255_mode));
 	dev->setmode_ready[chn] = 0;
@@ -1278,7 +1277,7 @@
 			    u32 *pstatus)
 {
 	int res;
-	u32 *buffer;
+	__le32 *buffer;
 	u32 chn_rev;
 	mutex_lock(&dev->lock);
 	chn_rev = G_chnmap[chn];
@@ -1291,7 +1290,7 @@
 	}
 	/* form the get vid status command */
 	buffer[0] = IN_DATA_TOKEN;
-	buffer[1] = chn_rev;
+	buffer[1] = (__le32) cpu_to_le32(chn_rev);
 	buffer[2] = CMD_STATUS;
 	*pstatus = 0;
 	dev->vidstatus_ready[chn] = 0;
@@ -1971,14 +1970,14 @@
 	if (frm->ulState == S2255_READ_IDLE) {
 		int jj;
 		unsigned int cc;
-		s32 *pdword;
+		__le32 *pdword; /*data from dsp is little endian */
 		int payload;
 		/* search for marker codes */
 		pdata = (unsigned char *)pipe_info->transfer_buffer;
+		pdword = (__le32 *)pdata;
 		for (jj = 0; jj < (pipe_info->cur_transfer_size - 12); jj++) {
-			switch (*(s32 *) pdata) {
+			switch (*pdword) {
 			case S2255_MARKER_FRAME:
-				pdword = (s32 *)pdata;
 				dprintk(4, "found frame marker at offset:"
 					" %d [%x %x]\n", jj, pdata[0],
 					pdata[1]);
@@ -2002,7 +2001,6 @@
 				dev->jpg_size[dev->cc] = pdword[4];
 				break;
 			case S2255_MARKER_RESPONSE:
-				pdword = (s32 *)pdata;
 				pdata += DEF_USB_BLOCK;
 				jj += DEF_USB_BLOCK;
 				if (pdword[1] >= MAX_CHANNELS)
@@ -2437,9 +2435,9 @@
 	}
 
 	/* send the start command */
-	*(u32 *) buffer = IN_DATA_TOKEN;
-	*((u32 *) buffer + 1) = (u32) chn_rev;
-	*((u32 *) buffer + 2) = (u32) CMD_START;
+	*(__le32 *) buffer = IN_DATA_TOKEN;
+	*((__le32 *) buffer + 1) = (__le32) cpu_to_le32(chn_rev);
+	*((__le32 *) buffer + 2) = CMD_START;
 	res = s2255_write_config(dev->udev, (unsigned char *)buffer, 512);
 	if (res != 0)
 		dev_err(&dev->udev->dev, "CMD_START error\n");
@@ -2454,24 +2452,21 @@
 	unsigned char *buffer;
 	int res;
 	unsigned long chn_rev;
-
 	if (chn >= MAX_CHANNELS) {
 		dprintk(2, "stop acquire failed, bad channel %lu\n", chn);
 		return -1;
 	}
 	chn_rev = G_chnmap[chn];
-
 	buffer = kzalloc(512, GFP_KERNEL);
 	if (buffer == NULL) {
 		dev_err(&dev->udev->dev, "out of mem\n");
 		return -ENOMEM;
 	}
-
 	/* send the stop command */
 	dprintk(4, "stop acquire %lu\n", chn);
-	*(u32 *) buffer = IN_DATA_TOKEN;
-	*((u32 *) buffer + 1) = (u32) chn_rev;
-	*((u32 *) buffer + 2) = CMD_STOP;
+	*(__le32 *) buffer = IN_DATA_TOKEN;
+	*((__le32 *) buffer + 1) = (__le32) cpu_to_le32(chn_rev);
+	*((__le32 *) buffer + 2) = CMD_STOP;
 	res = s2255_write_config(dev->udev, (unsigned char *)buffer, 512);
 
 	if (res != 0)

