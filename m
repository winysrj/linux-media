Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3020 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754653AbaHNJyT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Aug 2014 05:54:19 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: stoth@kernellabs.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 04/20] cx23885: use core locking, switch to unlocked_ioctl.
Date: Thu, 14 Aug 2014 11:53:49 +0200
Message-Id: <1408010045-24016-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1408010045-24016-1-git-send-email-hverkuil@xs4all.nl>
References: <1408010045-24016-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Enable core locking which allows us to safely switch to unlocked_ioctl.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx23885/cx23885-417.c   |  5 ++--
 drivers/media/pci/cx23885/cx23885-video.c | 43 +++++++------------------------
 2 files changed, 12 insertions(+), 36 deletions(-)

diff --git a/drivers/media/pci/cx23885/cx23885-417.c b/drivers/media/pci/cx23885/cx23885-417.c
index b65de33..395f7a9 100644
--- a/drivers/media/pci/cx23885/cx23885-417.c
+++ b/drivers/media/pci/cx23885/cx23885-417.c
@@ -1235,9 +1235,7 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id id)
 	dev->encodernorm = cx23885_tvnorms[i];
 
 	/* Have the drier core notify the subdevices */
-	mutex_lock(&dev->lock);
 	cx23885_set_tvnorm(dev, id);
-	mutex_unlock(&dev->lock);
 
 	return 0;
 }
@@ -1661,7 +1659,7 @@ static struct v4l2_file_operations mpeg_fops = {
 	.read	       = mpeg_read,
 	.poll          = mpeg_poll,
 	.mmap	       = mpeg_mmap,
-	.ioctl	       = video_ioctl2,
+	.unlocked_ioctl = video_ioctl2,
 };
 
 static const struct v4l2_ioctl_ops mpeg_ioctl_ops = {
@@ -1770,6 +1768,7 @@ int cx23885_417_register(struct cx23885_dev *dev)
 	dev->v4l_device = cx23885_video_dev_alloc(tsport,
 		dev->pci, &cx23885_mpeg_template, "mpeg");
 	video_set_drvdata(dev->v4l_device, dev);
+	dev->v4l_device->lock = &dev->lock;
 	err = video_register_device(dev->v4l_device,
 		VFL_TYPE_GRABBER, -1);
 	if (err < 0) {
diff --git a/drivers/media/pci/cx23885/cx23885-video.c b/drivers/media/pci/cx23885/cx23885-video.c
index d575bfc..ba93e29 100644
--- a/drivers/media/pci/cx23885/cx23885-video.c
+++ b/drivers/media/pci/cx23885/cx23885-video.c
@@ -345,6 +345,7 @@ static struct video_device *cx23885_vdev_init(struct cx23885_dev *dev,
 	*vfd = *template;
 	vfd->v4l2_dev = &dev->v4l2_dev;
 	vfd->release = video_device_release;
+	vfd->lock = &dev->lock;
 	snprintf(vfd->name, sizeof(vfd->name), "%s (%s)",
 		 cx23885_boards[dev->board].name, type);
 	video_set_drvdata(vfd, dev);
@@ -381,17 +382,14 @@ static int res_get(struct cx23885_dev *dev, struct cx23885_fh *fh,
 		return 1;
 
 	/* is it free? */
-	mutex_lock(&dev->lock);
 	if (dev->resources & bit) {
 		/* no, someone else uses it */
-		mutex_unlock(&dev->lock);
 		return 0;
 	}
 	/* it's free, grab it */
 	fh->resources  |= bit;
 	dev->resources |= bit;
 	dprintk(1, "res: get %d\n", bit);
-	mutex_unlock(&dev->lock);
 	return 1;
 }
 
@@ -411,11 +409,9 @@ static void res_free(struct cx23885_dev *dev, struct cx23885_fh *fh,
 	BUG_ON((fh->resources & bits) != bits);
 	dprintk(1, "%s()\n", __func__);
 
-	mutex_lock(&dev->lock);
 	fh->resources  &= ~bits;
 	dev->resources &= ~bits;
 	dprintk(1, "res: put %d\n", bits);
-	mutex_unlock(&dev->lock);
 }
 
 int cx23885_flatiron_write(struct cx23885_dev *dev, u8 reg, u8 data)
@@ -1272,9 +1268,7 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id tvnorms)
 	struct cx23885_dev *dev = ((struct cx23885_fh *)priv)->dev;
 	dprintk(1, "%s()\n", __func__);
 
-	mutex_lock(&dev->lock);
 	cx23885_set_tvnorm(dev, tvnorms);
-	mutex_unlock(&dev->lock);
 
 	return 0;
 }
@@ -1364,13 +1358,11 @@ int cx23885_set_input(struct file *file, void *priv, unsigned int i)
 	if (INPUT(i)->type == 0)
 		return -EINVAL;
 
-	mutex_lock(&dev->lock);
 	cx23885_video_mux(dev, i);
 
 	/* By default establish the default audio input for the card also */
 	/* Caller is free to use VIDIOC_S_AUDIO to override afterwards */
 	cx23885_audio_mux(dev, i);
-	mutex_unlock(&dev->lock);
 	return 0;
 }
 
@@ -1544,7 +1536,6 @@ static int cx23885_set_freq(struct cx23885_dev *dev, const struct v4l2_frequency
 	if (unlikely(f->tuner != 0))
 		return -EINVAL;
 
-	mutex_lock(&dev->lock);
 	dev->freq = f->frequency;
 
 	/* I need to mute audio here */
@@ -1561,8 +1552,6 @@ static int cx23885_set_freq(struct cx23885_dev *dev, const struct v4l2_frequency
 	ctrl.value = 0;
 	cx23885_set_control(dev, &ctrl);
 
-	mutex_unlock(&dev->lock);
-
 	return 0;
 }
 
@@ -1580,7 +1569,6 @@ static int cx23885_set_freq_via_ops(struct cx23885_dev *dev,
 		.frequency = f->frequency
 	};
 
-	mutex_lock(&dev->lock);
 	dev->freq = f->frequency;
 
 	/* I need to mute audio here */
@@ -1594,7 +1582,6 @@ static int cx23885_set_freq_via_ops(struct cx23885_dev *dev,
 
 	vfe = videobuf_dvb_get_frontend(&dev->ts2.frontends, 1);
 	if (!vfe) {
-		mutex_unlock(&dev->lock);
 		return -EINVAL;
 	}
 
@@ -1619,8 +1606,6 @@ static int cx23885_set_freq_via_ops(struct cx23885_dev *dev,
 	ctrl.value = 0;
 	cx23885_set_control(dev, &ctrl);
 
-	mutex_unlock(&dev->lock);
-
 	return 0;
 }
 
@@ -1742,7 +1727,7 @@ static const struct v4l2_file_operations video_fops = {
 	.read	       = video_read,
 	.poll          = video_poll,
 	.mmap	       = video_mmap,
-	.ioctl	       = video_ioctl2,
+	.unlocked_ioctl = video_ioctl2,
 };
 
 static const struct v4l2_ioctl_ops video_ioctl_ops = {
@@ -1791,14 +1776,6 @@ static struct video_device cx23885_video_template = {
 	.tvnorms              = CX23885_NORMS,
 };
 
-static const struct v4l2_file_operations radio_fops = {
-	.owner         = THIS_MODULE,
-	.open          = video_open,
-	.release       = video_release,
-	.ioctl         = video_ioctl2,
-};
-
-
 void cx23885_video_unregister(struct cx23885_dev *dev)
 {
 	dprintk(1, "%s()\n", __func__);
@@ -1909,6 +1886,14 @@ int cx23885_video_register(struct cx23885_dev *dev)
 		}
 	}
 
+	/* initial device configuration */
+	mutex_lock(&dev->lock);
+	cx23885_set_tvnorm(dev, dev->tvnorm);
+	init_controls(dev);
+	cx23885_video_mux(dev, 0);
+	cx23885_audio_mux(dev, 0);
+	mutex_unlock(&dev->lock);
+
 	/* register Video device */
 	dev->video_dev = cx23885_vdev_init(dev, dev->pci,
 		&cx23885_video_template, "video");
@@ -1938,14 +1923,6 @@ int cx23885_video_register(struct cx23885_dev *dev)
 	/* Register ALSA audio device */
 	dev->audio_dev = cx23885_audio_register(dev);
 
-	/* initial device configuration */
-	mutex_lock(&dev->lock);
-	cx23885_set_tvnorm(dev, dev->tvnorm);
-	init_controls(dev);
-	cx23885_video_mux(dev, 0);
-	cx23885_audio_mux(dev, 0);
-	mutex_unlock(&dev->lock);
-
 	return 0;
 
 fail_unreg:
-- 
2.1.0.rc1

