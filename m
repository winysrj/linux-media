Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:2207 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176Ab3DNP1y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Apr 2013 11:27:54 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Sri Deevi <Srinivasa.Deevi@conexant.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 25/30] cx25821: setup output nodes correctly.
Date: Sun, 14 Apr 2013 17:27:21 +0200
Message-Id: <1365953246-8972-26-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1365953246-8972-1-git-send-email-hverkuil@xs4all.nl>
References: <1365953246-8972-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Drop the custom ioctls and enable the video output nodes again, this time
using standard ioctls.

The next step will be to provide a proper write() interface.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx25821/cx25821-core.c  |   30 ----
 drivers/media/pci/cx25821/cx25821-video.c |  214 +++++++++--------------------
 drivers/media/pci/cx25821/cx25821-video.h |    7 -
 drivers/media/pci/cx25821/cx25821.h       |   16 ---
 4 files changed, 67 insertions(+), 200 deletions(-)

diff --git a/drivers/media/pci/cx25821/cx25821-core.c b/drivers/media/pci/cx25821/cx25821-core.c
index ba417c9..9068d53 100644
--- a/drivers/media/pci/cx25821/cx25821-core.c
+++ b/drivers/media/pci/cx25821/cx25821-core.c
@@ -956,36 +956,6 @@ static int cx25821_dev_setup(struct cx25821_dev *dev)
 	return 0;
 }
 
-void cx25821_start_upstream_video_ch1(struct cx25821_dev *dev,
-				      struct upstream_user_struct *up_data)
-{
-	dev->_isNTSC = !strcmp(dev->vid_stdname, "NTSC") ? 1 : 0;
-
-	dev->tvnorm = !dev->_isNTSC ? V4L2_STD_PAL_BG : V4L2_STD_NTSC_M;
-	medusa_set_videostandard(dev);
-
-	cx25821_vidupstream_init_ch1(dev, dev->channel_select,
-				     dev->pixel_format);
-}
-
-void cx25821_start_upstream_video_ch2(struct cx25821_dev *dev,
-				      struct upstream_user_struct *up_data)
-{
-	dev->_isNTSC_ch2 = !strcmp(dev->vid_stdname_ch2, "NTSC") ? 1 : 0;
-
-	dev->tvnorm = !dev->_isNTSC_ch2 ? V4L2_STD_PAL_BG : V4L2_STD_NTSC_M;
-	medusa_set_videostandard(dev);
-
-	cx25821_vidupstream_init_ch2(dev, dev->channel_select_ch2,
-				     dev->pixel_format_ch2);
-}
-
-void cx25821_start_upstream_audio(struct cx25821_dev *dev,
-				  struct upstream_user_struct *up_data)
-{
-	cx25821_audio_upstream_init(dev, AUDIO_UPSTREAM_SRAM_CHANNEL_B);
-}
-
 void cx25821_dev_unregister(struct cx25821_dev *dev)
 {
 	int i;
diff --git a/drivers/media/pci/cx25821/cx25821-video.c b/drivers/media/pci/cx25821/cx25821-video.c
index 4968644..8d5d13b 100644
--- a/drivers/media/pci/cx25821/cx25821-video.c
+++ b/drivers/media/pci/cx25821/cx25821-video.c
@@ -826,140 +826,27 @@ static int cx25821_s_ctrl(struct v4l2_ctrl *ctrl)
 	return 0;
 }
 
-static long video_ioctl_upstream9(struct file *file, unsigned int cmd,
-				 unsigned long arg)
+static int cx25821_vidioc_enum_output(struct file *file, void *priv,
+			      struct v4l2_output *o)
 {
-	struct cx25821_channel *chan = video_drvdata(file);
-	struct cx25821_dev *dev = chan->dev;
-	int command = 0;
-	struct upstream_user_struct *data_from_user;
-
-	data_from_user = (struct upstream_user_struct *)arg;
-
-	if (!data_from_user) {
-		pr_err("%s(): Upstream data is INVALID. Returning\n", __func__);
-		return 0;
-	}
-
-	command = data_from_user->command;
-
-	if (command != UPSTREAM_START_VIDEO && command != UPSTREAM_STOP_VIDEO)
-		return 0;
-
-	dev->input_filename = data_from_user->input_filename;
-	dev->input_audiofilename = data_from_user->input_filename;
-	dev->vid_stdname = data_from_user->vid_stdname;
-	dev->pixel_format = data_from_user->pixel_format;
-	dev->channel_select = data_from_user->channel_select;
-	dev->command = data_from_user->command;
-
-	switch (command) {
-	case UPSTREAM_START_VIDEO:
-		cx25821_start_upstream_video_ch1(dev, data_from_user);
-		break;
-
-	case UPSTREAM_STOP_VIDEO:
-		cx25821_stop_upstream_video_ch1(dev);
-		break;
-	}
+	if (o->index)
+		return -EINVAL;
 
+	o->type = V4L2_INPUT_TYPE_CAMERA;
+	o->std = CX25821_NORMS;
+	strcpy(o->name, "Composite");
 	return 0;
 }
 
-static long video_ioctl_upstream10(struct file *file, unsigned int cmd,
-				  unsigned long arg)
+static int cx25821_vidioc_g_output(struct file *file, void *priv, unsigned int *o)
 {
-	struct cx25821_channel *chan = video_drvdata(file);
-	struct cx25821_dev *dev = chan->dev;
-	int command = 0;
-	struct upstream_user_struct *data_from_user;
-
-	data_from_user = (struct upstream_user_struct *)arg;
-
-	if (!data_from_user) {
-		pr_err("%s(): Upstream data is INVALID. Returning\n", __func__);
-		return 0;
-	}
-
-	command = data_from_user->command;
-
-	if (command != UPSTREAM_START_VIDEO && command != UPSTREAM_STOP_VIDEO)
-		return 0;
-
-	dev->input_filename_ch2 = data_from_user->input_filename;
-	dev->input_audiofilename = data_from_user->input_filename;
-	dev->vid_stdname_ch2 = data_from_user->vid_stdname;
-	dev->pixel_format_ch2 = data_from_user->pixel_format;
-	dev->channel_select_ch2 = data_from_user->channel_select;
-	dev->command_ch2 = data_from_user->command;
-
-	switch (command) {
-	case UPSTREAM_START_VIDEO:
-		cx25821_start_upstream_video_ch2(dev, data_from_user);
-		break;
-
-	case UPSTREAM_STOP_VIDEO:
-		cx25821_stop_upstream_video_ch2(dev);
-		break;
-	}
-
+	*o = 0;
 	return 0;
 }
 
-static long video_ioctl_upstream11(struct file *file, unsigned int cmd,
-				  unsigned long arg)
+static int cx25821_vidioc_s_output(struct file *file, void *priv, unsigned int o)
 {
-	struct cx25821_channel *chan = video_drvdata(file);
-	struct cx25821_dev *dev = chan->dev;
-	int command = 0;
-	struct upstream_user_struct *data_from_user;
-
-	data_from_user = (struct upstream_user_struct *)arg;
-
-	if (!data_from_user) {
-		pr_err("%s(): Upstream data is INVALID. Returning\n", __func__);
-		return 0;
-	}
-
-	command = data_from_user->command;
-
-	if (command != UPSTREAM_START_AUDIO && command != UPSTREAM_STOP_AUDIO)
-		return 0;
-
-	dev->input_filename = data_from_user->input_filename;
-	dev->input_audiofilename = data_from_user->input_filename;
-	dev->vid_stdname = data_from_user->vid_stdname;
-	dev->pixel_format = data_from_user->pixel_format;
-	dev->channel_select = data_from_user->channel_select;
-	dev->command = data_from_user->command;
-
-	switch (command) {
-	case UPSTREAM_START_AUDIO:
-		cx25821_start_upstream_audio(dev, data_from_user);
-		break;
-
-	case UPSTREAM_STOP_AUDIO:
-		cx25821_stop_upstream_audio(dev);
-		break;
-	}
-
-	return 0;
-}
-
-static long cx25821_video_ioctl(struct file *file,
-				unsigned int cmd, unsigned long arg)
-{
-	struct cx25821_channel *chan = video_drvdata(file);
-
-	/* check to see if it's the video upstream */
-	if (chan->id == SRAM_CH09)
-		return video_ioctl_upstream9(file, cmd, arg);
-	if (chan->id == SRAM_CH10)
-		return video_ioctl_upstream10(file, cmd, arg);
-	if (chan->id == SRAM_CH11)
-		return video_ioctl_upstream11(file, cmd, arg);
-
-	return video_ioctl2(file, cmd, arg);
+	return o ? -EINVAL : 0;
 }
 
 static const struct v4l2_ctrl_ops cx25821_ctrl_ops = {
@@ -973,7 +860,7 @@ static const struct v4l2_file_operations video_fops = {
 	.read = video_read,
 	.poll = video_poll,
 	.mmap = cx25821_video_mmap,
-	.unlocked_ioctl = cx25821_video_ioctl,
+	.unlocked_ioctl = video_ioctl2,
 };
 
 static const struct v4l2_ioctl_ops video_ioctl_ops = {
@@ -1007,6 +894,32 @@ static const struct video_device cx25821_video_device = {
 	.tvnorms = CX25821_NORMS,
 };
 
+static const struct v4l2_file_operations video_out_fops = {
+	.owner = THIS_MODULE,
+	.open = v4l2_fh_open,
+	.release = v4l2_fh_release,
+	.unlocked_ioctl = video_ioctl2,
+};
+
+static const struct v4l2_ioctl_ops video_out_ioctl_ops = {
+	.vidioc_querycap = cx25821_vidioc_querycap,
+	.vidioc_g_std = cx25821_vidioc_g_std,
+	.vidioc_s_std = cx25821_vidioc_s_std,
+	.vidioc_enum_output = cx25821_vidioc_enum_output,
+	.vidioc_g_output = cx25821_vidioc_g_output,
+	.vidioc_s_output = cx25821_vidioc_s_output,
+	.vidioc_log_status = vidioc_log_status,
+};
+
+static const struct video_device cx25821_video_out_device = {
+	.name = "cx25821-video",
+	.fops = &video_out_fops,
+	.release = video_device_release_empty,
+	.minor = -1,
+	.ioctl_ops = &video_out_ioctl_ops,
+	.tvnorms = CX25821_NORMS,
+};
+
 void cx25821_video_unregister(struct cx25821_dev *dev, int chan_num)
 {
 	cx_clear(PCI_INT_MSK, 1);
@@ -1030,30 +943,33 @@ int cx25821_video_register(struct cx25821_dev *dev)
 
 	spin_lock_init(&dev->slock);
 
-	for (i = 0; i < VID_CHANNEL_NUM; ++i) {
+	for (i = 0; i < MAX_VID_CHANNEL_NUM - 1; ++i) {
 		struct cx25821_channel *chan = &dev->channels[i];
 		struct video_device *vdev = &chan->vdev;
 		struct v4l2_ctrl_handler *hdl = &chan->hdl;
+		bool is_output = i > SRAM_CH08;
 
 		if (i == SRAM_CH08) /* audio channel */
 			continue;
 
-		v4l2_ctrl_handler_init(hdl, 4);
-		v4l2_ctrl_new_std(hdl, &cx25821_ctrl_ops,
-			V4L2_CID_BRIGHTNESS, 0, 10000, 1, 6200);
-		v4l2_ctrl_new_std(hdl, &cx25821_ctrl_ops,
-			V4L2_CID_CONTRAST, 0, 10000, 1, 5000);
-		v4l2_ctrl_new_std(hdl, &cx25821_ctrl_ops,
-			V4L2_CID_SATURATION, 0, 10000, 1, 5000);
-		v4l2_ctrl_new_std(hdl, &cx25821_ctrl_ops,
-			V4L2_CID_HUE, 0, 10000, 1, 5000);
-		if (hdl->error) {
-			err = hdl->error;
-			goto fail_unreg;
+		if (!is_output) {
+			v4l2_ctrl_handler_init(hdl, 4);
+			v4l2_ctrl_new_std(hdl, &cx25821_ctrl_ops,
+					V4L2_CID_BRIGHTNESS, 0, 10000, 1, 6200);
+			v4l2_ctrl_new_std(hdl, &cx25821_ctrl_ops,
+					V4L2_CID_CONTRAST, 0, 10000, 1, 5000);
+			v4l2_ctrl_new_std(hdl, &cx25821_ctrl_ops,
+					V4L2_CID_SATURATION, 0, 10000, 1, 5000);
+			v4l2_ctrl_new_std(hdl, &cx25821_ctrl_ops,
+					V4L2_CID_HUE, 0, 10000, 1, 5000);
+			if (hdl->error) {
+				err = hdl->error;
+				goto fail_unreg;
+			}
+			err = v4l2_ctrl_handler_setup(hdl);
+			if (err)
+				goto fail_unreg;
 		}
-		err = v4l2_ctrl_handler_setup(hdl);
-		if (err)
-			goto fail_unreg;
 
 		cx25821_risc_stopper(dev->pci, &chan->dma_vidq.stopper,
 			chan->sram_channels->dma_ctl, 0x11, 0);
@@ -1081,15 +997,19 @@ int cx25821_video_register(struct cx25821_dev *dev)
 		chan->dma_vidq.timeout.data = (unsigned long)&chan->timeout_data;
 		init_timer(&chan->dma_vidq.timeout);
 
-		videobuf_queue_sg_init(&chan->vidq, &cx25821_video_qops, &dev->pci->dev,
-			&dev->slock, V4L2_BUF_TYPE_VIDEO_CAPTURE,
-			V4L2_FIELD_INTERLACED, sizeof(struct cx25821_buffer),
-			chan, &dev->lock);
+		if (!is_output)
+			videobuf_queue_sg_init(&chan->vidq, &cx25821_video_qops, &dev->pci->dev,
+				&dev->slock, V4L2_BUF_TYPE_VIDEO_CAPTURE,
+				V4L2_FIELD_INTERLACED, sizeof(struct cx25821_buffer),
+				chan, &dev->lock);
 
 		/* register v4l devices */
-		*vdev = cx25821_video_device;
+		*vdev = is_output ? cx25821_video_out_device : cx25821_video_device;
 		vdev->v4l2_dev = &dev->v4l2_dev;
-		vdev->ctrl_handler = hdl;
+		if (!is_output)
+			vdev->ctrl_handler = hdl;
+		else
+			vdev->vfl_dir = VFL_DIR_TX;
 		vdev->lock = &dev->lock;
 		set_bit(V4L2_FL_USE_FH_PRIO, &vdev->flags);
 		snprintf(vdev->name, sizeof(vdev->name), "%s #%d", dev->name, i);
diff --git a/drivers/media/pci/cx25821/cx25821-video.h b/drivers/media/pci/cx25821/cx25821-video.h
index 8871c4e..ab63b38 100644
--- a/drivers/media/pci/cx25821/cx25821-video.h
+++ b/drivers/media/pci/cx25821/cx25821-video.h
@@ -49,13 +49,6 @@ do {									\
 		printk(KERN_DEBUG "%s/0: " fmt, dev->name, ##arg);	\
 } while (0)
 
-/* For IOCTL to identify running upstream */
-#define UPSTREAM_START_VIDEO        700
-#define UPSTREAM_STOP_VIDEO         701
-#define UPSTREAM_START_AUDIO        702
-#define UPSTREAM_STOP_AUDIO         703
-#define UPSTREAM_DUMP_REGISTERS     702
-
 #define FORMAT_FLAGS_PACKED       0x01
 extern void cx25821_video_wakeup(struct cx25821_dev *dev,
 				 struct cx25821_dmaqueue *q, u32 count);
diff --git a/drivers/media/pci/cx25821/cx25821.h b/drivers/media/pci/cx25821/cx25821.h
index 67b3c55..156ad6f 100644
--- a/drivers/media/pci/cx25821/cx25821.h
+++ b/drivers/media/pci/cx25821/cx25821.h
@@ -329,14 +329,6 @@ struct cx25821_dev {
 	int command;
 };
 
-struct upstream_user_struct {
-	char *input_filename;
-	char *vid_stdname;
-	int pixel_format;
-	int channel_select;
-	int command;
-};
-
 static inline struct cx25821_dev *get_cx25821(struct v4l2_device *v4l2_dev)
 {
 	return container_of(v4l2_dev, struct cx25821_dev, v4l2_dev);
@@ -480,14 +472,6 @@ extern int cx25821_audio_upstream_init(struct cx25821_dev *dev,
 extern void cx25821_free_mem_upstream_ch1(struct cx25821_dev *dev);
 extern void cx25821_free_mem_upstream_ch2(struct cx25821_dev *dev);
 extern void cx25821_free_mem_upstream_audio(struct cx25821_dev *dev);
-extern void cx25821_start_upstream_video_ch1(struct cx25821_dev *dev,
-					     struct upstream_user_struct
-					     *up_data);
-extern void cx25821_start_upstream_video_ch2(struct cx25821_dev *dev,
-					     struct upstream_user_struct
-					     *up_data);
-extern void cx25821_start_upstream_audio(struct cx25821_dev *dev,
-					 struct upstream_user_struct *up_data);
 extern void cx25821_stop_upstream_video_ch1(struct cx25821_dev *dev);
 extern void cx25821_stop_upstream_video_ch2(struct cx25821_dev *dev);
 extern void cx25821_stop_upstream_audio(struct cx25821_dev *dev);
-- 
1.7.10.4

