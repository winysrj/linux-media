Return-path: <mchehab@gaivota>
Received: from gateway04.websitewelcome.com ([67.18.39.3]:41610 "HELO
	gateway04.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753898Ab0LTW2g (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Dec 2010 17:28:36 -0500
Subject: [PATCH] s2255drv: remove BKL
From: Pete Eberlein <pete@sensoray.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: linux-dev@sensoray.com
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 20 Dec 2010 14:18:59 -0800
Message-ID: <1292883539.2767.20.camel@pete-desktop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Remove BKL ioctl and use unlocked_ioctl with core-assisted locking instead.

Signed-off-by: Pete Eberlein <pete@sensoray.com>

diff --git a/drivers/media/video/s2255drv.c b/drivers/media/video/s2255drv.c
index f5a46c4..a216d62 100644
--- a/drivers/media/video/s2255drv.c
+++ b/drivers/media/video/s2255drv.c
@@ -269,7 +269,7 @@ struct s2255_dev {
 	struct v4l2_device 	v4l2_dev;
 	atomic_t                num_channels;
 	int			frames;
-	struct mutex		lock;
+	struct mutex		lock;	/* channels[].vdev.lock */
 	struct mutex		open_lock;
 	struct usb_device	*udev;
 	struct usb_interface	*interface;
@@ -781,20 +781,14 @@ static struct videobuf_queue_ops s2255_video_qops = {
 
 static int res_get(struct s2255_fh *fh)
 {
-	struct s2255_dev *dev = fh->dev;
-	/* is it free? */
 	struct s2255_channel *channel = fh->channel;
-	mutex_lock(&dev->lock);
-	if (channel->resources) {
-		/* no, someone else uses it */
-		mutex_unlock(&dev->lock);
-		return 0;
-	}
+	/* is it free? */
+	if (channel->resources)
+		return 0; /* no, someone else uses it */
 	/* it's free, grab it */
 	channel->resources = 1;
 	fh->resources = 1;
 	dprintk(1, "s2255: res: get\n");
-	mutex_unlock(&dev->lock);
 	return 1;
 }
 
@@ -812,11 +806,8 @@ static int res_check(struct s2255_fh *fh)
 static void res_free(struct s2255_fh *fh)
 {
 	struct s2255_channel *channel = fh->channel;
-	struct s2255_dev *dev = fh->dev;
-	mutex_lock(&dev->lock);
 	channel->resources = 0;
 	fh->resources = 0;
-	mutex_unlock(&dev->lock);
 	dprintk(1, "res: put\n");
 }
 
@@ -1219,7 +1210,6 @@ static int s2255_set_mode(struct s2255_channel *channel,
 	__le32 *buffer;
 	unsigned long chn_rev;
 	struct s2255_dev *dev = to_s2255_dev(channel->vdev.v4l2_dev);
-	mutex_lock(&dev->lock);
 	chn_rev = G_chnmap[channel->idx];
 	dprintk(3, "%s channel: %d\n", __func__, channel->idx);
 	/* if JPEG, set the quality */
@@ -1236,7 +1226,6 @@ static int s2255_set_mode(struct s2255_channel *channel,
 	buffer = kzalloc(512, GFP_KERNEL);
 	if (buffer == NULL) {
 		dev_err(&dev->udev->dev, "out of mem\n");
-		mutex_unlock(&dev->lock);
 		return -ENOMEM;
 	}
 	/* set the mode */
@@ -1261,7 +1250,6 @@ static int s2255_set_mode(struct s2255_channel *channel,
 	}
 	/* clear the restart flag */
 	channel->mode.restart = 0;
-	mutex_unlock(&dev->lock);
 	dprintk(1, "%s chn %d, result: %d\n", __func__, channel->idx, res);
 	return res;
 }
@@ -1272,13 +1260,11 @@ static int s2255_cmd_status(struct s2255_channel *channel, u32 *pstatus)
 	__le32 *buffer;
 	u32 chn_rev;
 	struct s2255_dev *dev = to_s2255_dev(channel->vdev.v4l2_dev);
-	mutex_lock(&dev->lock);
 	chn_rev = G_chnmap[channel->idx];
 	dprintk(4, "%s chan %d\n", __func__, channel->idx);
 	buffer = kzalloc(512, GFP_KERNEL);
 	if (buffer == NULL) {
 		dev_err(&dev->udev->dev, "out of mem\n");
-		mutex_unlock(&dev->lock);
 		return -ENOMEM;
 	}
 	/* form the get vid status command */
@@ -1298,7 +1284,6 @@ static int s2255_cmd_status(struct s2255_channel *channel, u32 *pstatus)
 	}
 	*pstatus = channel->vidstatus;
 	dprintk(4, "%s, vid status %d\n", __func__, *pstatus);
-	mutex_unlock(&dev->lock);
 	return res;
 }
 
@@ -1817,7 +1802,8 @@ static int s2255_open(struct file *file)
 				    NULL, &dev->slock,
 				    fh->type,
 				    V4L2_FIELD_INTERLACED,
-				    sizeof(struct s2255_buffer), fh, NULL);
+				    sizeof(struct s2255_buffer),
+				    fh, vdev->lock);
 	return 0;
 }
 
@@ -1900,7 +1886,7 @@ static const struct v4l2_file_operations s2255_fops_v4l = {
 	.open = s2255_open,
 	.release = s2255_release,
 	.poll = s2255_poll,
-	.ioctl = video_ioctl2,	/* V4L2 ioctl handler */
+	.unlocked_ioctl = video_ioctl2,	/* V4L2 ioctl handler */
 	.mmap = s2255_mmap_v4l,
 };
 
@@ -1970,6 +1956,7 @@ static int s2255_probe_v4l(struct s2255_dev *dev)
 		channel->vidq.dev = dev;
 		/* register 4 video devices */
 		channel->vdev = template;
+		channel->vdev.lock = &dev->lock;
 		channel->vdev.v4l2_dev = &dev->v4l2_dev;
 		video_set_drvdata(&channel->vdev, channel);
 		if (video_nr == -1)
@@ -2676,7 +2663,9 @@ static void s2255_disconnect(struct usb_interface *interface)
 	struct s2255_dev *dev = to_s2255_dev(usb_get_intfdata(interface));
 	int i;
 	int channels = atomic_read(&dev->num_channels);
+	mutex_lock(&dev->lock);
 	v4l2_device_disconnect(&dev->v4l2_dev);
+	mutex_unlock(&dev->lock);
 	/*see comments in the uvc_driver.c usb disconnect function */
 	atomic_inc(&dev->num_channels);
 	/* unregister each video device. */


