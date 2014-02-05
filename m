Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway05.websitewelcome.com ([69.56.148.14]:40266 "EHLO
	gateway05.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751384AbaBETbu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 5 Feb 2014 14:31:50 -0500
Received: from gator3086.hostgator.com (ns6171.hostgator.com [50.87.144.121])
	by gateway05.websitewelcome.com (Postfix) with ESMTP id 4EC3E96B66681
	for <linux-media@vger.kernel.org>; Wed,  5 Feb 2014 12:43:56 -0600 (CST)
From: Dean Anderson <linux-dev@sensoray.com>
To: hverkuil@xs4all.nl, linux-dev@sensoray.com,
	linux-media@vger.kernel.org
Subject: [PATCH] s2255drv: dynamic memory allocation efficiency fix
Date: Wed,  5 Feb 2014 10:43:51 -0800
Message-Id: <1391625831-3503-1-git-send-email-linux-dev@sensoray.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Driver was allocating a kernel buffer each time it was sending a command.
It is better to allocate this buffer once at startup.

Signed-off-by: Dean Anderson <linux-dev@sensoray.com>
---
 drivers/media/usb/s2255/s2255drv.c |   67 ++++++++++++++++++++----------------
 1 file changed, 37 insertions(+), 30 deletions(-)

diff --git a/drivers/media/usb/s2255/s2255drv.c b/drivers/media/usb/s2255/s2255drv.c
index 517901b..4c483ad 100644
--- a/drivers/media/usb/s2255/s2255drv.c
+++ b/drivers/media/usb/s2255/s2255drv.c
@@ -260,6 +260,7 @@ struct s2255_dev {
 	atomic_t                num_channels;
 	int			frames;
 	struct mutex		lock;	/* channels[].vdev.lock */
+	struct mutex		cmdlock; /* protects cmdbuf */
 	struct usb_device	*udev;
 	struct usb_interface	*interface;
 	u8			read_endpoint;
@@ -273,6 +274,8 @@ struct s2255_dev {
 	/* dsp firmware version (f2255usb.bin) */
 	int                     dsp_fw_ver;
 	u16                     pid; /* product id */
+#define S2255_CMDBUF_SIZE 512
+	__le32                  *cmdbuf;
 };
 
 static inline struct s2255_dev *to_s2255_dev(struct v4l2_device *v4l2_dev)
@@ -1121,11 +1124,12 @@ static int s2255_set_mode(struct s2255_vc *vc,
 			  struct s2255_mode *mode)
 {
 	int res;
-	__le32 *buffer;
 	unsigned long chn_rev;
 	struct s2255_dev *dev = to_s2255_dev(vc->vdev.v4l2_dev);
 	int i;
+	__le32 *buffer = dev->cmdbuf;
 
+	mutex_lock(&dev->cmdlock);
 	chn_rev = G_chnmap[vc->idx];
 	dprintk(dev, 3, "%s channel: %d\n", __func__, vc->idx);
 	/* if JPEG, set the quality */
@@ -1139,11 +1143,6 @@ static int s2255_set_mode(struct s2255_vc *vc,
 	vc->mode = *mode;
 	vc->req_image_size = get_transfer_size(mode);
 	dprintk(dev, 1, "%s: reqsize %ld\n", __func__, vc->req_image_size);
-	buffer = kzalloc(512, GFP_KERNEL);
-	if (buffer == NULL) {
-		dev_err(&dev->udev->dev, "out of mem\n");
-		return -ENOMEM;
-	}
 	/* set the mode */
 	buffer[0] = IN_DATA_TOKEN;
 	buffer[1] = (__le32) cpu_to_le32(chn_rev);
@@ -1154,7 +1153,6 @@ static int s2255_set_mode(struct s2255_vc *vc,
 	res = s2255_write_config(dev->udev, (unsigned char *)buffer, 512);
 	if (debug)
 		s2255_print_cfg(dev, mode);
-	kfree(buffer);
 	/* wait at least 3 frames before continuing */
 	if (mode->restart) {
 		wait_event_timeout(vc->wait_setmode,
@@ -1168,22 +1166,20 @@ static int s2255_set_mode(struct s2255_vc *vc,
 	/* clear the restart flag */
 	vc->mode.restart = 0;
 	dprintk(dev, 1, "%s chn %d, result: %d\n", __func__, vc->idx, res);
+	mutex_unlock(&dev->cmdlock);
 	return res;
 }
 
 static int s2255_cmd_status(struct s2255_vc *vc, u32 *pstatus)
 {
 	int res;
-	__le32 *buffer;
 	u32 chn_rev;
 	struct s2255_dev *dev = to_s2255_dev(vc->vdev.v4l2_dev);
+	__le32 *buffer = dev->cmdbuf;
+
+	mutex_lock(&dev->cmdlock);
 	chn_rev = G_chnmap[vc->idx];
 	dprintk(dev, 4, "%s chan %d\n", __func__, vc->idx);
-	buffer = kzalloc(512, GFP_KERNEL);
-	if (buffer == NULL) {
-		dev_err(&dev->udev->dev, "out of mem\n");
-		return -ENOMEM;
-	}
 	/* form the get vid status command */
 	buffer[0] = IN_DATA_TOKEN;
 	buffer[1] = (__le32) cpu_to_le32(chn_rev);
@@ -1191,7 +1187,6 @@ static int s2255_cmd_status(struct s2255_vc *vc, u32 *pstatus)
 	*pstatus = 0;
 	vc->vidstatus_ready = 0;
 	res = s2255_write_config(dev->udev, (unsigned char *)buffer, 512);
-	kfree(buffer);
 	wait_event_timeout(vc->wait_vidstatus,
 			   (vc->vidstatus_ready != 0),
 			   msecs_to_jiffies(S2255_VIDSTATUS_TIMEOUT));
@@ -1201,6 +1196,7 @@ static int s2255_cmd_status(struct s2255_vc *vc, u32 *pstatus)
 	}
 	*pstatus = vc->vidstatus;
 	dprintk(dev, 4, "%s, vid status %d\n", __func__, *pstatus);
+	mutex_unlock(&dev->cmdlock);
 	return res;
 }
 
@@ -1724,6 +1720,7 @@ static void s2255_destroy(struct s2255_dev *dev)
 	mutex_destroy(&dev->lock);
 	usb_put_dev(dev->udev);
 	v4l2_device_unregister(&dev->v4l2_dev);
+	kfree(dev->cmdbuf);
 	kfree(dev);
 }
 
@@ -2350,18 +2347,14 @@ static int s2255_start_readpipe(struct s2255_dev *dev)
 /* starts acquisition process */
 static int s2255_start_acquire(struct s2255_vc *vc)
 {
-	unsigned char *buffer;
 	int res;
 	unsigned long chn_rev;
 	int j;
 	struct s2255_dev *dev = to_s2255_dev(vc->vdev.v4l2_dev);
-	chn_rev = G_chnmap[vc->idx];
-	buffer = kzalloc(512, GFP_KERNEL);
-	if (buffer == NULL) {
-		dev_err(&dev->udev->dev, "out of mem\n");
-		return -ENOMEM;
-	}
+	__le32 *buffer = dev->cmdbuf;
 
+	mutex_lock(&dev->cmdlock);
+	chn_rev = G_chnmap[vc->idx];
 	vc->last_frame = -1;
 	vc->bad_payload = 0;
 	vc->cur_frame = 0;
@@ -2371,24 +2364,26 @@ static int s2255_start_acquire(struct s2255_vc *vc)
 	}
 
 	/* send the start command */
-	*(__le32 *) buffer = IN_DATA_TOKEN;
-	*((__le32 *) buffer + 1) = (__le32) cpu_to_le32(chn_rev);
-	*((__le32 *) buffer + 2) = CMD_START;
+	buffer[0] = IN_DATA_TOKEN;
+	buffer[1] = (__le32) cpu_to_le32(chn_rev);
+	buffer[2] = CMD_START;
 	res = s2255_write_config(dev->udev, (unsigned char *)buffer, 512);
 	if (res != 0)
 		dev_err(&dev->udev->dev, "CMD_START error\n");
 
 	dprintk(dev, 2, "start acquire exit[%d] %d\n", vc->idx, res);
-	kfree(buffer);
+	mutex_unlock(&dev->cmdlock);
 	return 0;
 }
 
 static int s2255_stop_acquire(struct s2255_vc *vc)
 {
-	unsigned char *buffer;
 	int res;
 	unsigned long chn_rev;
 	struct s2255_dev *dev = to_s2255_dev(vc->vdev.v4l2_dev);
+	__le32 *buffer = dev->cmdbuf;
+
+	mutex_lock(&dev->cmdlock);
 	chn_rev = G_chnmap[vc->idx];
 	buffer = kzalloc(512, GFP_KERNEL);
 	if (buffer == NULL) {
@@ -2396,15 +2391,17 @@ static int s2255_stop_acquire(struct s2255_vc *vc)
 		return -ENOMEM;
 	}
 	/* send the stop command */
-	*(__le32 *) buffer = IN_DATA_TOKEN;
-	*((__le32 *) buffer + 1) = (__le32) cpu_to_le32(chn_rev);
-	*((__le32 *) buffer + 2) = CMD_STOP;
+	buffer[0] = IN_DATA_TOKEN;
+	buffer[1] = (__le32) cpu_to_le32(chn_rev);
+	buffer[2] = CMD_STOP;
+
 	res = s2255_write_config(dev->udev, (unsigned char *)buffer, 512);
 	if (res != 0)
 		dev_err(&dev->udev->dev, "CMD_STOP error\n");
-	kfree(buffer);
+
 	vc->b_acquire = 0;
 	dprintk(dev, 4, "%s: chn %d, res %d\n", __func__, vc->idx, res);
+	mutex_unlock(&dev->cmdlock);
 	return res;
 }
 
@@ -2451,18 +2448,27 @@ static int s2255_probe(struct usb_interface *interface,
 	int retval = -ENOMEM;
 	__le32 *pdata;
 	int fw_size;
+
 	/* allocate memory for our device state and initialize it to zero */
 	dev = kzalloc(sizeof(struct s2255_dev), GFP_KERNEL);
 	if (dev == NULL) {
 		s2255_dev_err(&interface->dev, "out of memory\n");
 		return -ENOMEM;
 	}
+
+	dev->cmdbuf = kzalloc(S2255_CMDBUF_SIZE, GFP_KERNEL);
+	if (dev->cmdbuf == NULL) {
+		s2255_dev_err(&interface->dev, "out of memory\n");
+		return -ENOMEM;
+	}
+
 	atomic_set(&dev->num_channels, 0);
 	dev->pid = le16_to_cpu(id->idProduct);
 	dev->fw_data = kzalloc(sizeof(struct s2255_fw), GFP_KERNEL);
 	if (!dev->fw_data)
 		goto errorFWDATA1;
 	mutex_init(&dev->lock);
+	mutex_init(&dev->cmdlock);
 	/* grab usb_device and save it */
 	dev->udev = usb_get_dev(interface_to_usbdev(interface));
 	if (dev->udev == NULL) {
@@ -2568,6 +2574,7 @@ errorUDEV:
 	kfree(dev->fw_data);
 	mutex_destroy(&dev->lock);
 errorFWDATA1:
+	kfree(dev->cmdbuf);
 	kfree(dev);
 	pr_warn("Sensoray 2255 driver load failed: 0x%x\n", retval);
 	return retval;
-- 
1.7.9.5

