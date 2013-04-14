Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:1896 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934Ab3DNP1p (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Apr 2013 11:27:45 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Sri Deevi <Srinivasa.Deevi@conexant.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 05/30] cx25821: remove unused fields, ioctls.
Date: Sun, 14 Apr 2013 17:27:01 +0200
Message-Id: <1365953246-8972-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1365953246-8972-1-git-send-email-hverkuil@xs4all.nl>
References: <1365953246-8972-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Do some spring cleaning:

- there are no board defines with tuners, so remove bogus tuner support.
- tv standard handling has nothing to do with tuners, so keep that.
- replace the deprecated current_norm by g_std.
- querystd isn't implemented, so remove the ioctl.
- remove a bunch of unused fields in cx25821.h

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx25821/cx25821-cards.c |    1 -
 drivers/media/pci/cx25821/cx25821-video.c |  130 +++--------------------------
 drivers/media/pci/cx25821/cx25821-video.h |   13 ---
 drivers/media/pci/cx25821/cx25821.h       |   18 ----
 4 files changed, 10 insertions(+), 152 deletions(-)

diff --git a/drivers/media/pci/cx25821/cx25821-cards.c b/drivers/media/pci/cx25821/cx25821-cards.c
index 99988c9..c09ec68 100644
--- a/drivers/media/pci/cx25821/cx25821-cards.c
+++ b/drivers/media/pci/cx25821/cx25821-cards.c
@@ -30,7 +30,6 @@
 #include <media/cx25840.h>
 
 #include "cx25821.h"
-#include "tuner-xc2028.h"
 
 /* board config info */
 
diff --git a/drivers/media/pci/cx25821/cx25821-video.c b/drivers/media/pci/cx25821/cx25821-video.c
index e785bb9..8ff8fc2 100644
--- a/drivers/media/pci/cx25821/cx25821-video.c
+++ b/drivers/media/pci/cx25821/cx25821-video.c
@@ -138,7 +138,6 @@ void cx25821_video_wakeup(struct cx25821_dev *dev, struct cx25821_dmaqueue *q,
 		pr_err("%s: %d buffers handled (should be 1)\n", __func__, bc);
 }
 
-#ifdef TUNER_FLAG
 int cx25821_set_tvnorm(struct cx25821_dev *dev, v4l2_std_id norm)
 {
 	dprintk(1, "%s(norm = 0x%08x) name: [%s]\n",
@@ -151,7 +150,6 @@ int cx25821_set_tvnorm(struct cx25821_dev *dev, v4l2_std_id norm)
 
 	return 0;
 }
-#endif
 
 struct video_device *cx25821_vdev_init(struct cx25821_dev *dev,
 				       struct pci_dev *pci,
@@ -1036,8 +1034,6 @@ int cx25821_vidioc_querycap(struct file *file, void *priv,
 	cap->version = CX25821_VERSION_CODE;
 	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_READWRITE |
 		V4L2_CAP_STREAMING;
-	if (UNSET != dev->tuner_type)
-		cap->capabilities |= V4L2_CAP_TUNER;
 	return 0;
 }
 
@@ -1093,7 +1089,14 @@ int cx25821_vidioc_s_priority(struct file *file, void *f,
 			prio);
 }
 
-#ifdef TUNER_FLAG
+int cx25821_vidioc_g_std(struct file *file, void *priv, v4l2_std_id *tvnorms)
+{
+	struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
+
+	*tvnorms = dev->tvnorm;
+	return 0;
+}
+
 int cx25821_vidioc_s_std(struct file *file, void *priv, v4l2_std_id tvnorms)
 {
 	struct cx25821_fh *fh = priv;
@@ -1120,7 +1123,6 @@ int cx25821_vidioc_s_std(struct file *file, void *priv, v4l2_std_id tvnorms)
 
 	return 0;
 }
-#endif
 
 int cx25821_enum_input(struct cx25821_dev *dev, struct v4l2_input *i)
 {
@@ -1189,57 +1191,6 @@ int cx25821_vidioc_s_input(struct file *file, void *priv, unsigned int i)
 	return 0;
 }
 
-#ifdef TUNER_FLAG
-int cx25821_vidioc_g_frequency(struct file *file, void *priv,
-			       struct v4l2_frequency *f)
-{
-	struct cx25821_fh *fh = priv;
-	struct cx25821_dev *dev = fh->dev;
-
-	f->frequency = dev->freq;
-
-	cx25821_call_all(dev, tuner, g_frequency, f);
-
-	return 0;
-}
-
-int cx25821_set_freq(struct cx25821_dev *dev, const struct v4l2_frequency *f)
-{
-	mutex_lock(&dev->lock);
-	dev->freq = f->frequency;
-
-	cx25821_call_all(dev, tuner, s_frequency, f);
-
-	/* When changing channels it is required to reset TVAUDIO */
-	msleep(10);
-
-	mutex_unlock(&dev->lock);
-
-	return 0;
-}
-
-int cx25821_vidioc_s_frequency(struct file *file, void *priv,
-			       const struct v4l2_frequency *f)
-{
-	struct cx25821_fh *fh = priv;
-	struct cx25821_dev *dev;
-	int err;
-
-	if (fh) {
-		dev = fh->dev;
-		err = v4l2_prio_check(&dev->channels[fh->channel_id].prio,
-				      fh->prio);
-		if (0 != err)
-			return err;
-	} else {
-		pr_err("Invalid fh pointer!\n");
-		return -EINVAL;
-	}
-
-	return cx25821_set_freq(dev, f);
-}
-#endif
-
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 int cx25821_vidioc_g_register(struct file *file, void *fh,
 		      struct v4l2_dbg_register *reg)
@@ -1269,48 +1220,6 @@ int cx25821_vidioc_s_register(struct file *file, void *fh,
 
 #endif
 
-#ifdef TUNER_FLAG
-int cx25821_vidioc_g_tuner(struct file *file, void *priv, struct v4l2_tuner *t)
-{
-	struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
-
-	if (unlikely(UNSET == dev->tuner_type))
-		return -EINVAL;
-	if (0 != t->index)
-		return -EINVAL;
-
-	strcpy(t->name, "Television");
-	t->type = V4L2_TUNER_ANALOG_TV;
-	t->capability = V4L2_TUNER_CAP_NORM;
-	t->rangehigh = 0xffffffffUL;
-
-	t->signal = 0xffff;	/* LOCKED */
-	return 0;
-}
-
-int cx25821_vidioc_s_tuner(struct file *file, void *priv, const struct v4l2_tuner *t)
-{
-	struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
-	struct cx25821_fh *fh = priv;
-	int err;
-
-	if (fh) {
-		err = v4l2_prio_check(&dev->channels[fh->channel_id].prio,
-				      fh->prio);
-		if (0 != err)
-			return err;
-	}
-
-	dprintk(1, "%s()\n", __func__);
-	if (UNSET == dev->tuner_type)
-		return -EINVAL;
-	if (0 != t->index)
-		return -EINVAL;
-
-	return 0;
-}
-
-#endif
 /*****************************************************************************/
 static const struct v4l2_queryctrl no_ctl = {
 	.name = "42",
@@ -1523,14 +1432,6 @@ int cx25821_vidioc_g_crop(struct file *file, void *priv, struct v4l2_crop *crop)
 	return -EINVAL;
 }
 
-int cx25821_vidioc_querystd(struct file *file, void *priv, v4l2_std_id * norm)
-{
-	/* medusa does not support video standard sensing of current input */
-	*norm = CX25821_NORMS;
-
-	return 0;
-}
-
 int cx25821_is_valid_width(u32 width, v4l2_std_id tvnorm)
 {
 	if (tvnorm == V4L2_STD_PAL_BG) {
@@ -1842,10 +1743,8 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_querybuf = cx25821_vidioc_querybuf,
 	.vidioc_qbuf = cx25821_vidioc_qbuf,
 	.vidioc_dqbuf = vidioc_dqbuf,
-#ifdef TUNER_FLAG
+	.vidioc_g_std = cx25821_vidioc_g_std,
 	.vidioc_s_std = cx25821_vidioc_s_std,
-	.vidioc_querystd = cx25821_vidioc_querystd,
-#endif
 	.vidioc_cropcap = cx25821_vidioc_cropcap,
 	.vidioc_s_crop = cx25821_vidioc_s_crop,
 	.vidioc_g_crop = cx25821_vidioc_g_crop,
@@ -1860,12 +1759,6 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_log_status = vidioc_log_status,
 	.vidioc_g_priority = cx25821_vidioc_g_priority,
 	.vidioc_s_priority = cx25821_vidioc_s_priority,
-#ifdef TUNER_FLAG
-	.vidioc_g_tuner = cx25821_vidioc_g_tuner,
-	.vidioc_s_tuner = cx25821_vidioc_s_tuner,
-	.vidioc_g_frequency = cx25821_vidioc_g_frequency,
-	.vidioc_s_frequency = cx25821_vidioc_s_frequency,
-#endif
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.vidioc_g_register = cx25821_vidioc_g_register,
 	.vidioc_s_register = cx25821_vidioc_s_register,
@@ -1878,7 +1771,6 @@ static const struct video_device cx25821_video_device = {
 	.minor = -1,
 	.ioctl_ops = &video_ioctl_ops,
 	.tvnorms = CX25821_NORMS,
-	.current_norm = V4L2_STD_NTSC_M,
 };
 
 void cx25821_video_unregister(struct cx25821_dev *dev, int chan_num)
@@ -1953,10 +1845,8 @@ int cx25821_video_register(struct cx25821_dev *dev)
 
 	/* initial device configuration */
 	mutex_lock(&dev->lock);
-#ifdef TUNER_FLAG
-	dev->tvnorm = cx25821_video_device.current_norm;
+	dev->tvnorm = V4L2_STD_NTSC_M,
 	cx25821_set_tvnorm(dev, dev->tvnorm);
-#endif
 	mutex_unlock(&dev->lock);
 
 	return 0;
diff --git a/drivers/media/pci/cx25821/cx25821-video.h b/drivers/media/pci/cx25821/cx25821-video.h
index 37cb0c1..eb12e35 100644
--- a/drivers/media/pci/cx25821/cx25821-video.h
+++ b/drivers/media/pci/cx25821/cx25821-video.h
@@ -40,8 +40,6 @@
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
 
-#define TUNER_FLAG
-
 #define VIDEO_DEBUG 0
 
 #define dprintk(level, fmt, arg...)					\
@@ -88,9 +86,7 @@ extern struct cx25821_data timeout_data[MAX_VID_CHANNEL_NUM];
 extern void cx25821_video_wakeup(struct cx25821_dev *dev,
 				 struct cx25821_dmaqueue *q, u32 count);
 
-#ifdef TUNER_FLAG
 extern int cx25821_set_tvnorm(struct cx25821_dev *dev, v4l2_std_id norm);
-#endif
 
 extern int cx25821_res_get(struct cx25821_dev *dev, struct cx25821_fh *fh,
 			   unsigned int bit);
@@ -146,19 +142,10 @@ extern int cx25821_vidioc_g_ctrl(struct file *file, void *priv,
 				 struct v4l2_control *ctl);
 extern int cx25821_vidioc_g_fmt_vid_cap(struct file *file, void *priv,
 					struct v4l2_format *f);
-extern int cx25821_vidioc_g_frequency(struct file *file, void *priv,
-				      struct v4l2_frequency *f);
-extern int cx25821_set_freq(struct cx25821_dev *dev, const struct v4l2_frequency *f);
-extern int cx25821_vidioc_s_frequency(struct file *file, void *priv,
-				      const struct v4l2_frequency *f);
 extern int cx25821_vidioc_g_register(struct file *file, void *fh,
 				     struct v4l2_dbg_register *reg);
 extern int cx25821_vidioc_s_register(struct file *file, void *fh,
 				     const struct v4l2_dbg_register *reg);
-extern int cx25821_vidioc_g_tuner(struct file *file, void *priv,
-				  struct v4l2_tuner *t);
-extern int cx25821_vidioc_s_tuner(struct file *file, void *priv,
-				  const struct v4l2_tuner *t);
 
 extern int cx25821_is_valid_width(u32 width, v4l2_std_id tvnorm);
 extern int cx25821_is_valid_height(u32 height, v4l2_std_id tvnorm);
diff --git a/drivers/media/pci/cx25821/cx25821.h b/drivers/media/pci/cx25821/cx25821.h
index 04c3cb0..fdeecdf 100644
--- a/drivers/media/pci/cx25821/cx25821.h
+++ b/drivers/media/pci/cx25821/cx25821.h
@@ -33,7 +33,6 @@
 
 #include <media/v4l2-common.h>
 #include <media/v4l2-device.h>
-#include <media/tuner.h>
 #include <media/tveeprom.h>
 #include <media/videobuf-dma-sg.h>
 #include <media/videobuf-dvb.h>
@@ -43,7 +42,6 @@
 #include "cx25821-medusa-reg.h"
 #include "cx25821-sram.h"
 #include "cx25821-audio.h"
-#include "media/cx2341x.h"
 
 #include <linux/version.h>
 #include <linux/mutex.h>
@@ -184,8 +182,6 @@ struct cx25821_board {
 	enum port porta;
 	enum port portb;
 	enum port portc;
-	unsigned int tuner_type;
-	unsigned char tuner_addr;
 
 	u32 clk_freq;
 	struct cx25821_input input[CX25821_NR_INPUT];
@@ -283,12 +279,7 @@ struct cx25821_dev {
 	/* Analog video */
 	u32 resources;
 	unsigned int input;
-	u32 tvaudio;
 	v4l2_std_id tvnorm;
-	unsigned int tuner_type;
-	unsigned char tuner_addr;
-	unsigned int videc_type;
-	unsigned char videc_addr;
 	unsigned short _max_num_decoders;
 
 	/* Analog Audio Upstream */
@@ -314,8 +305,6 @@ struct cx25821_dev {
 	char *_audiofilename;
 
 	/* V4l */
-	u32 freq;
-
 	spinlock_t slock;
 
 	/* Video Upstream */
@@ -363,13 +352,6 @@ struct cx25821_dev {
 	char *_filename_ch2;
 	char *_defaultname_ch2;
 
-	/* MPEG Encoder ONLY settings */
-	u32 cx23417_mailbox;
-	struct cx2341x_mpeg_params mpeg_params;
-	struct video_device *v4l_device;
-	atomic_t v4l_reader_count;
-	struct cx25821_tvnorm encodernorm;
-
 	u32 upstream_riscbuf_size;
 	u32 upstream_databuf_size;
 	u32 upstream_riscbuf_size_ch2;
-- 
1.7.10.4

