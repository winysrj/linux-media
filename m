Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9EI4Sdi019549
	for <video4linux-list@redhat.com>; Tue, 14 Oct 2008 14:04:28 -0400
Received: from mail11d.verio-web.com (mail11d.verio-web.com [204.202.242.86])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m9EI4EkZ032609
	for <video4linux-list@redhat.com>; Tue, 14 Oct 2008 14:04:14 -0400
Received: from mx53.stngva01.us.mxservers.net (204.202.242.79)
	by mail11d.verio-web.com (RS ver 1.0.95vs) with SMTP id 4-0823337454
	for <video4linux-list@redhat.com>; Tue, 14 Oct 2008 14:04:14 -0400 (EDT)
Date: Tue, 14 Oct 2008 11:04:11 -0700 (PDT)
From: "Dean A." <dean@sensoray.com>
To: mchehab@infradead.org, video4linux-list@redhat.com,
	v4l-dvb-maintainer@linuxtv.org
Message-ID: <tkrat.ff9400bfbd1cfe2f@sensoray.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Cc: dean@sensoray.com
Subject: [PATCH] s2255drv: adds video input signal detection to
 VIDIOC_ENUMINPUT
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

From: Dean Anderson <dean@sensoray.com>

This patch adds video input status detection.
Fixes possible race condition on changing modes.

Signed-off-by: Dean Anderson <dean@sensoray.com>
---


--- /usr/src/v4l-dvb-9621b3986345/linux/drivers/media/video/s2255drv.c.orig	2008-10-13 18:31:15.000000000 -0700
+++ /usr/src/v4l-dvb-9621b3986345/linux/drivers/media/video/s2255drv.c	2008-10-14 10:44:22.000000000 -0700
@@ -57,6 +57,11 @@
 
 #define FIRMWARE_FILE_NAME "f2255usb.bin"
 
+/*
+ * requires version 5 or later of firmware(above)
+ *  to enable vid status feature
+ */
+#define FIRMWARE_VER_CAP_STATUS  5
 
 
 /* default JPEG quality */
@@ -75,9 +80,13 @@
 #define S2255_LOAD_TIMEOUT      (5000 + S2255_DSP_BOOTTIME)
 #define S2255_DEF_BUFS          16
 #define S2255_SETMODE_TIMEOUT   500
+#define S2255_VIDSTATUS_TIMEOUT 350
 #define MAX_CHANNELS		4
 #define S2255_MARKER_FRAME	0x2255DA4AL
 #define S2255_MARKER_RESPONSE	0x2255ACACL
+#define S2255_RESPONSE_SETMODE  0x01
+#define S2255_RESPONSE_FW       0x10
+#define S2255_RESPONSE_STATUS   0x20
 #define S2255_USB_XFER_SIZE	(16 * 1024)
 #define MAX_CHANNELS		4
 #define MAX_PIPE_BUFFERS	1
@@ -265,9 +274,16 @@ struct s2255_dev {
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
 
@@ -1235,6 +1251,7 @@ static int s2255_set_mode(struct s2255_d
 	buffer[1] = (u32) chn_rev;
 	buffer[2] = CMD_SET_MODE;
 	memcpy(&buffer[3], &dev->mode[chn], sizeof(struct s2255_mode));
+	dev->setmode_ready[chn] = 0;
 	res = s2255_write_config(dev->udev, (unsigned char *)buffer, 512);
 	if (debug)
 		dump_verify_mode(dev, mode);
@@ -1243,7 +1260,6 @@ static int s2255_set_mode(struct s2255_d
 
 	/* wait at least 3 frames before continuing */
 	if (mode->restart) {
-		dev->setmode_ready[chn] = 0;
 		wait_event_timeout(dev->wait_setmode[chn],
 				   (dev->setmode_ready[chn] != 0),
 				   msecs_to_jiffies(S2255_SETMODE_TIMEOUT));
@@ -1259,6 +1275,44 @@ static int s2255_set_mode(struct s2255_d
 	return res;
 }
 
+static int s2255_cmd_status(struct s2255_dev *dev, unsigned long chn,
+			    u32 *pstatus)
+{
+	int res;
+	u32 *buffer;
+	unsigned long chn_rev;
+
+	mutex_lock(&dev->lock);
+	chn_rev = G_chnmap[chn];
+	dprintk(4, "s2255_get_status: chan %ld\n", chn_rev);
+	buffer = kzalloc(512, GFP_KERNEL);
+	if (buffer == NULL) {
+		dev_err(&dev->udev->dev, "out of mem\n");
+		mutex_unlock(&dev->lock);
+		return -ENOMEM;
+	}
+	/* form the get vid status command */
+	buffer[0] = IN_DATA_TOKEN;
+	buffer[1] = (u32) chn_rev;
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
+	dprintk(4, "s2255: vid status %d\n", *pstatus);
+	mutex_unlock(&dev->lock);
+	return res;
+}
+
+
 static int vidioc_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
 {
 	int res;
@@ -1387,11 +1441,24 @@ out_s_std:
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
+	if (dev->dsp_fw_ver >= FIRMWARE_VER_CAP_STATUS) {
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
@@ -1681,6 +1748,8 @@ static void s2255_destroy(struct kref *k
 	for (i = 0; i < MAX_CHANNELS; i++) {
 		dev->setmode_ready[i] = 1;
 		wake_up(&dev->wait_setmode[i]);
+		dev->vidstatus_ready[i] = 1;
+		wake_up(&dev->wait_vidstatus[i]);
 	}
 	mutex_lock(&dev->open_lock);
 	/* reset the DSP so firmware can be reload next time */
@@ -1931,14 +2000,14 @@ static int save_frame(struct s2255_dev *
 				if (!(cc >= 0 && cc < MAX_CHANNELS))
 					break;
 				switch (pdword[2]) {
-				case 0x01:
+				case S2255_RESPONSE_SETMODE:
 					/* check if channel valid */
 					/* set mode ready */
 					dev->setmode_ready[cc] = 1;
 					wake_up(&dev->wait_setmode[cc]);
 					dprintk(5, "setmode ready %d\n", cc);
 					break;
-				case 0x10:
+				case S2255_RESPONSE_FW:
 
 					dev->chn_ready |= (1 << cc);
 					if ((dev->chn_ready & 0x0f) != 0x0f)
@@ -1949,6 +2018,13 @@ static int save_frame(struct s2255_dev *
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
 					printk(KERN_INFO "s2255 unknwn resp\n");
 				}
@@ -2504,8 +2580,10 @@ static int s2255_probe(struct usb_interf
 	dev->timer.data = (unsigned long)dev->fw_data;
 
 	init_waitqueue_head(&dev->fw_data->wait_fw);
-	for (i = 0; i < MAX_CHANNELS; i++)
+	for (i = 0; i < MAX_CHANNELS; i++) {
 		init_waitqueue_head(&dev->wait_setmode[i]);
+		init_waitqueue_head(&dev->wait_vidstatus[i]);
+	}
 
 
 	dev->fw_data->fw_urb = usb_alloc_urb(0, GFP_KERNEL);
@@ -2538,6 +2616,7 @@ static int s2255_probe(struct usb_interf
 		__le32 *pRel;
 		pRel = (__le32 *) &dev->fw_data->fw->data[fw_size - 4];
 		printk(KERN_INFO "s2255 dsp fw version %x\n", *pRel);
+		dev->dsp_fw_ver = *pRel;
 	}
 	/* loads v4l specific */
 	s2255_probe_v4l(dev);
@@ -2572,6 +2651,8 @@ static void s2255_disconnect(struct usb_
 	for (i = 0; i < MAX_CHANNELS; i++) {
 		dev->setmode_ready[i] = 1;
 		wake_up(&dev->wait_setmode[i]);
+		dev->vidstatus_ready[i] = 1;
+		wake_up(&dev->wait_vidstatus[i]);
 	}
 
 	mutex_lock(&dev->open_lock);

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
