Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway16.websitewelcome.com ([67.18.21.17]:50075 "HELO
	gateway16.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754770Ab0CDB0B (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Mar 2010 20:26:01 -0500
Date: Wed, 3 Mar 2010 14:39:19 -0800 (PST)
From: "Dean A." <dean@sensoray.com>
Subject: [PATCH] s2255drv : adding video input status capability
To: mchehab@infradead.org, linux-media@vger.kernel.org
Message-ID: <tkrat.943a3edcb56e69ba@sensoray.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

# HG changeset patch
# User Dean Anderson <dean@sensoray.com>
# Date 1267655333 28800
# Node ID 3bf09a2ab1100269d6424c487ca98a1b1e4ead54
# Parent  5e0d6be7f020d6c0741795b0bd039ace7d54d310
Adds video status capability to 2255 driver

From: Dean Anderson <dean@sensoray.com>

Video status capability for inputs on Sensoray 2255 driver.

Priority: normal

Signed-off-by: Dean Anderson <dean@sensoray.com>

diff -r 5e0d6be7f020 -r 3bf09a2ab110 linux/drivers/media/video/s2255drv.c
--- a/linux/drivers/media/video/s2255drv.c	Wed Mar 03 18:34:32 2010 -0300
+++ b/linux/drivers/media/video/s2255drv.c	Wed Mar 03 14:28:53 2010 -0800
@@ -1,7 +1,7 @@
 /*
  *  s2255drv.c - a driver for the Sensoray 2255 USB video capture device
  *
- *   Copyright (C) 2007-2008 by Sensoray Company Inc.
+ *   Copyright (C) 2007-2010 by Sensoray Company Inc.
  *                              Dean Anderson
  *
  * Some video buffer code based on vivi driver:
@@ -76,11 +76,13 @@
 #define S2255_LOAD_TIMEOUT      (5000 + S2255_DSP_BOOTTIME)
 #define S2255_DEF_BUFS          16
 #define S2255_SETMODE_TIMEOUT   500
+#define S2255_VIDSTATUS_TIMEOUT 350
 #define MAX_CHANNELS		4
 #define S2255_MARKER_FRAME	0x2255DA4AL
 #define S2255_MARKER_RESPONSE	0x2255ACACL
 #define S2255_RESPONSE_SETMODE  0x01
 #define S2255_RESPONSE_FW       0x10
+#define S2255_RESPONSE_STATUS   0x20
 #define S2255_USB_XFER_SIZE	(16 * 1024)
 #define MAX_CHANNELS		4
 #define MAX_PIPE_BUFFERS	1
@@ -261,9 +263,16 @@
 	int                     chn_configured[MAX_CHANNELS];
 	wait_queue_head_t       wait_setmode[MAX_CHANNELS];
 	int                     setmode_ready[MAX_CHANNELS];
+	/* video status items */
+	int                     vidstatus[MAX_CHANNELS];
+	wait_queue_head_t       wait_vidstatus[MAX_CHANNELS];
+	int                     vidstatus_ready[MAX_CHANNELS];
+
 	int                     chn_ready;
 	struct kref		kref;
 	spinlock_t              slock;
+	/* dsp firmware version (f2255usb.bin) */
+	int                     dsp_fw_ver;
 };
 #define to_s2255_dev(d) container_of(d, struct s2255_dev, kref)
 
@@ -296,8 +305,12 @@
 
 /* current cypress EEPROM firmware version */
 #define S2255_CUR_USB_FWVER	((3 << 8) | 6)
+/* current DSP FW version */
+#define S2255_CUR_DSP_FWVER     5
+/* Need DSP version 5+ for video status feature */
+#define S2255_MIN_DSP_STATUS    5
 #define S2255_MAJOR_VERSION	1
-#define S2255_MINOR_VERSION	14
+#define S2255_MINOR_VERSION	15
 #define S2255_RELEASE		0
 #define S2255_VERSION		KERNEL_VERSION(S2255_MAJOR_VERSION, \
 					       S2255_MINOR_VERSION, \
@@ -1261,6 +1274,42 @@
 	return res;
 }
 
+static int s2255_cmd_status(struct s2255_dev *dev, unsigned long chn,
+			    u32 *pstatus)
+{
+	int res;
+	u32 *buffer;
+	u32 chn_rev;
+	mutex_lock(&dev->lock);
+	chn_rev = G_chnmap[chn];
+	dprintk(4, "%s chan %d\n", __func__, chn_rev);
+	buffer = kzalloc(512, GFP_KERNEL);
+	if (buffer == NULL) {
+		dev_err(&dev->udev->dev, "out of mem\n");
+		mutex_unlock(&dev->lock);
+		return -ENOMEM;
+	}
+	/* form the get vid status command */
+	buffer[0] = IN_DATA_TOKEN;
+	buffer[1] = chn_rev;
+	buffer[2] = CMD_STATUS;
+	*pstatus = 0;
+	dev->vidstatus_ready[chn] = 0;
+	res = s2255_write_config(dev->udev, (unsigned char *)buffer, 512);
+	kfree(buffer);
+	wait_event_timeout(dev->wait_vidstatus[chn],
+			   (dev->vidstatus_ready[chn] != 0),
+			   msecs_to_jiffies(S2255_VIDSTATUS_TIMEOUT));
+	if (dev->vidstatus_ready[chn] != 1) {
+		printk(KERN_DEBUG "s2255: no vidstatus response\n");
+		res = -EFAULT;
+	}
+	*pstatus = dev->vidstatus[chn];
+	dprintk(4, "%s, vid status %d\n", __func__, *pstatus);
+	mutex_unlock(&dev->lock);
+	return res;
+}
+
 static int vidioc_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
 {
 	int res;
@@ -1386,11 +1435,24 @@
 static int vidioc_enum_input(struct file *file, void *priv,
 			     struct v4l2_input *inp)
 {
+	struct s2255_fh *fh = priv;
+	struct s2255_dev *dev = fh->dev;
+	u32 status = 0;
+
 	if (inp->index != 0)
 		return -EINVAL;
 
 	inp->type = V4L2_INPUT_TYPE_CAMERA;
 	inp->std = S2255_NORMS;
+	inp->status = 0;
+	if (dev->dsp_fw_ver >= S2255_MIN_DSP_STATUS) {
+		int rc;
+		rc = s2255_cmd_status(dev, fh->channel, &status);
+		dprintk(4, "s2255_cmd_status rc: %d status %x\n", rc, status);
+		if (rc == 0)
+			inp->status =  (status & 0x01) ? 0
+				: V4L2_IN_ST_NO_SIGNAL;
+	}
 	strlcpy(inp->name, "Camera", sizeof(inp->name));
 	return 0;
 }
@@ -1700,6 +1762,8 @@
 	for (i = 0; i < MAX_CHANNELS; i++) {
 		dev->setmode_ready[i] = 1;
 		wake_up(&dev->wait_setmode[i]);
+		dev->vidstatus_ready[i] = 1;
+		wake_up(&dev->wait_vidstatus[i]);
 	}
 	mutex_lock(&dev->open_lock);
 	/* reset the DSP so firmware can be reload next time */
@@ -1965,6 +2029,13 @@
 						   S2255_FW_SUCCESS);
 					wake_up(&dev->fw_data->wait_fw);
 					break;
+				case S2255_RESPONSE_STATUS:
+					dev->vidstatus[cc] = pdword[3];
+					dev->vidstatus_ready[cc] = 1;
+					wake_up(&dev->wait_vidstatus[cc]);
+					dprintk(5, "got vidstatus %x chan %d\n",
+						pdword[3], cc);
+					break;
 				default:
 					printk(KERN_INFO "s2255 unknown resp\n");
 				}
@@ -2527,9 +2598,10 @@
 	dev->timer.data = (unsigned long)dev->fw_data;
 
 	init_waitqueue_head(&dev->fw_data->wait_fw);
-	for (i = 0; i < MAX_CHANNELS; i++)
+	for (i = 0; i < MAX_CHANNELS; i++) {
 		init_waitqueue_head(&dev->wait_setmode[i]);
-
+		init_waitqueue_head(&dev->wait_vidstatus[i]);
+	}
 
 	dev->fw_data->fw_urb = usb_alloc_urb(0, GFP_KERNEL);
 
@@ -2561,6 +2633,9 @@
 		__le32 *pRel;
 		pRel = (__le32 *) &dev->fw_data->fw->data[fw_size - 4];
 		printk(KERN_INFO "s2255 dsp fw version %x\n", *pRel);
+		dev->dsp_fw_ver = *pRel;
+		if (*pRel < S2255_CUR_DSP_FWVER)
+			printk(KERN_INFO "s2255: f2255usb.bin out of date.\n");
 	}
 	/* loads v4l specific */
 	s2255_probe_v4l(dev);
@@ -2597,6 +2672,8 @@
 	for (i = 0; i < MAX_CHANNELS; i++) {
 		dev->setmode_ready[i] = 1;
 		wake_up(&dev->wait_setmode[i]);
+		dev->vidstatus_ready[i] = 1;
+		wake_up(&dev->wait_vidstatus[i]);
 	}
 
 	mutex_lock(&dev->open_lock);

