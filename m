Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:4875 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178Ab3DNP1y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Apr 2013 11:27:54 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Sri Deevi <Srinivasa.Deevi@conexant.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 24/30] cx25821: remove references to subdevices that aren't there.
Date: Sun, 14 Apr 2013 17:27:20 +0200
Message-Id: <1365953246-8972-25-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1365953246-8972-1-git-send-email-hverkuil@xs4all.nl>
References: <1365953246-8972-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This driver does not have subdevices, so why call subdev ops? After
removing that it became apparent that only Composite is supported as
input, so remove also any reference to other inputs.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx25821/cx25821-cards.c |    1 -
 drivers/media/pci/cx25821/cx25821-video.c |  111 ++---------------------------
 drivers/media/pci/cx25821/cx25821.h       |   26 -------
 3 files changed, 7 insertions(+), 131 deletions(-)

diff --git a/drivers/media/pci/cx25821/cx25821-cards.c b/drivers/media/pci/cx25821/cx25821-cards.c
index 2b2f1f4..3b409fe 100644
--- a/drivers/media/pci/cx25821/cx25821-cards.c
+++ b/drivers/media/pci/cx25821/cx25821-cards.c
@@ -42,7 +42,6 @@ struct cx25821_board cx25821_boards[] = {
 		.name = "CX25821",
 		.portb = CX25821_RAW,
 		.portc = CX25821_264,
-		.input[0].type = CX25821_VMUX_COMPOSITE,
 	},
 
 };
diff --git a/drivers/media/pci/cx25821/cx25821-video.c b/drivers/media/pci/cx25821/cx25821-video.c
index d3aa166..4968644 100644
--- a/drivers/media/pci/cx25821/cx25821-video.c
+++ b/drivers/media/pci/cx25821/cx25821-video.c
@@ -111,37 +111,6 @@ void cx25821_video_wakeup(struct cx25821_dev *dev, struct cx25821_dmaqueue *q,
 		pr_err("%s: %d buffers handled (should be 1)\n", __func__, bc);
 }
 
-static int cx25821_set_tvnorm(struct cx25821_dev *dev, v4l2_std_id norm)
-{
-	dprintk(1, "%s(norm = 0x%08x) name: [%s]\n",
-		__func__, (unsigned int)norm, v4l2_norm_to_name(norm));
-
-	dev->tvnorm = norm;
-
-	/* Tell the internal A/V decoder */
-	cx25821_call_all(dev, core, s_std, norm);
-
-	return 0;
-}
-
-static int cx25821_video_mux(struct cx25821_dev *dev, unsigned int input)
-{
-	struct v4l2_routing route;
-	memset(&route, 0, sizeof(route));
-
-	dprintk(1, "%s(): video_mux: %d [vmux=%d, gpio=0x%x,0x%x,0x%x,0x%x]\n",
-		__func__, input, INPUT(input)->vmux, INPUT(input)->gpio0,
-		INPUT(input)->gpio1, INPUT(input)->gpio2, INPUT(input)->gpio3);
-	dev->input = input;
-
-	route.input = INPUT(input)->vmux;
-
-	/* Tell the internal A/V decoder */
-	cx25821_call_all(dev, video, s_routing, INPUT(input)->vmux, 0, 0);
-
-	return 0;
-}
-
 int cx25821_start_video_dma(struct cx25821_dev *dev,
 			    struct cx25821_dmaqueue *q,
 			    struct cx25821_buffer *buf,
@@ -673,9 +642,8 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 {
 	struct cx25821_channel *chan = video_drvdata(file);
 	struct cx25821_dev *dev = chan->dev;
-	struct v4l2_mbus_framefmt mbus_fmt;
-	int err;
 	int pix_format = PIXEL_FRMT_422;
+	int err;
 
 	err = cx25821_vidioc_try_fmt_vid_cap(file, priv, f);
 
@@ -702,10 +670,6 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 
 	chan->cif_width = chan->width;
 	medusa_set_resolution(dev, chan->width, SRAM_CH00);
-
-	v4l2_fill_mbus_format(&mbus_fmt, &f->fmt.pix, V4L2_MBUS_FMT_FIXED);
-	cx25821_call_all(dev, video, s_mbus_fmt, &mbus_fmt);
-
 	return 0;
 }
 
@@ -727,7 +691,6 @@ static int vidioc_log_status(struct file *file, void *priv)
 	const struct sram_channel *sram_ch = chan->sram_channels;
 	u32 tmp = 0;
 
-	cx25821_call_all(dev, core, log_status);
 	tmp = cx_read(sram_ch->dma_ctl);
 	pr_info("Video input 0 is %s\n",
 		(tmp & 0x11) ? "streaming" : "stopped");
@@ -806,7 +769,7 @@ int cx25821_vidioc_s_std(struct file *file, void *priv, v4l2_std_id tvnorms)
 	if (dev->tvnorm == tvnorms)
 		return 0;
 
-	cx25821_set_tvnorm(dev, tvnorms);
+	dev->tvnorm = tvnorms;
 	chan->width = 720;
 	chan->height = (dev->tvnorm & V4L2_STD_625_50) ? 576 : 480;
 
@@ -818,81 +781,26 @@ int cx25821_vidioc_s_std(struct file *file, void *priv, v4l2_std_id tvnorms)
 static int cx25821_vidioc_enum_input(struct file *file, void *priv,
 			      struct v4l2_input *i)
 {
-	static const char * const iname[] = {
-		[CX25821_VMUX_COMPOSITE] = "Composite",
-		[CX25821_VMUX_SVIDEO] = "S-Video",
-		[CX25821_VMUX_DEBUG] = "for debug only",
-	};
-	struct cx25821_channel *chan = video_drvdata(file);
-	struct cx25821_dev *dev = chan->dev;
-	unsigned int n;
-
-	n = i->index;
-	if (n >= CX25821_NR_INPUT)
-		return -EINVAL;
-
-	if (0 == INPUT(n)->type)
+	if (i->index)
 		return -EINVAL;
 
 	i->type = V4L2_INPUT_TYPE_CAMERA;
-	strcpy(i->name, iname[INPUT(n)->type]);
-
 	i->std = CX25821_NORMS;
+	strcpy(i->name, "Composite");
 	return 0;
 }
 
 static int cx25821_vidioc_g_input(struct file *file, void *priv, unsigned int *i)
 {
-	struct cx25821_channel *chan = video_drvdata(file);
-	struct cx25821_dev *dev = chan->dev;
-
-	*i = dev->input;
+	*i = 0;
 	return 0;
 }
 
 static int cx25821_vidioc_s_input(struct file *file, void *priv, unsigned int i)
 {
-	struct cx25821_channel *chan = video_drvdata(file);
-	struct cx25821_dev *dev = chan->dev;
-
-	if (i >= CX25821_NR_INPUT || INPUT(i)->type == 0)
-		return -EINVAL;
-
-	cx25821_video_mux(dev, i);
-	return 0;
+	return i ? -EINVAL : 0;
 }
 
-#ifdef CONFIG_VIDEO_ADV_DEBUG
-int cx25821_vidioc_g_register(struct file *file, void *fh,
-		      struct v4l2_dbg_register *reg)
-{
-	struct cx25821_channel *chan = video_drvdata(file);
-	struct cx25821_dev *dev = chan->dev;
-
-	if (!v4l2_chip_match_host(&reg->match))
-		return -EINVAL;
-
-	cx25821_call_all(dev, core, g_register, reg);
-
-	return 0;
-}
-
-int cx25821_vidioc_s_register(struct file *file, void *fh,
-		      const struct v4l2_dbg_register *reg)
-{
-	struct cx25821_channel *chan = video_drvdata(file);
-	struct cx25821_dev *dev = chan->dev;
-
-	if (!v4l2_chip_match_host(&reg->match))
-		return -EINVAL;
-
-	cx25821_call_all(dev, core, s_register, reg);
-
-	return 0;
-}
-
-#endif
-
 static int cx25821_s_ctrl(struct v4l2_ctrl *ctrl)
 {
 	struct cx25821_channel *chan =
@@ -1088,10 +996,6 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_log_status = vidioc_log_status,
 	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
-#ifdef CONFIG_VIDEO_ADV_DEBUG
-	.vidioc_g_register = cx25821_vidioc_g_register,
-	.vidioc_s_register = cx25821_vidioc_s_register,
-#endif
 };
 
 static const struct video_device cx25821_video_device = {
@@ -1122,8 +1026,7 @@ int cx25821_video_register(struct cx25821_dev *dev)
 	int i;
 
 	/* initial device configuration */
-	dev->tvnorm = V4L2_STD_NTSC_M,
-	cx25821_set_tvnorm(dev, dev->tvnorm);
+	dev->tvnorm = V4L2_STD_NTSC_M;
 
 	spin_lock_init(&dev->slock);
 
diff --git a/drivers/media/pci/cx25821/cx25821.h b/drivers/media/pci/cx25821/cx25821.h
index cfda5ac..67b3c55 100644
--- a/drivers/media/pci/cx25821/cx25821.h
+++ b/drivers/media/pci/cx25821/cx25821.h
@@ -62,7 +62,6 @@
 
 /* Max number of inputs by card */
 #define MAX_CX25821_INPUT     8
-#define INPUT(nr) (&cx25821_boards[dev->board].input[nr])
 #define RESOURCE_VIDEO0       1
 #define RESOURCE_VIDEO1       2
 #define RESOURCE_VIDEO2       4
@@ -91,7 +90,6 @@
 #define CX25821_BOARD_CONEXANT_ATHENA10 1
 #define MAX_VID_CHANNEL_NUM     12
 #define VID_CHANNEL_NUM 8
-#define CX25821_NR_INPUT 2
 
 struct cx25821_fmt {
 	char *name;
@@ -101,14 +99,6 @@ struct cx25821_fmt {
 	u32 cxformat;
 };
 
-struct cx25821_ctrl {
-	struct v4l2_queryctrl v;
-	u32 off;
-	u32 reg;
-	u32 mask;
-	u32 shift;
-};
-
 struct cx25821_tvnorm {
 	char *name;
 	v4l2_std_id id;
@@ -116,12 +106,6 @@ struct cx25821_tvnorm {
 	u32 cxoformat;
 };
 
-enum cx25821_itype {
-	CX25821_VMUX_COMPOSITE = 1,
-	CX25821_VMUX_SVIDEO,
-	CX25821_VMUX_DEBUG,
-};
-
 enum cx25821_src_sel_type {
 	CX25821_SRC_SEL_EXT_656_VIDEO = 0,
 	CX25821_SRC_SEL_PARALLEL_MPEG_VIDEO
@@ -139,12 +123,6 @@ struct cx25821_buffer {
 	u32 count;
 };
 
-struct cx25821_input {
-	enum cx25821_itype type;
-	unsigned int vmux;
-	u32 gpio0, gpio1, gpio2, gpio3;
-};
-
 enum port {
 	CX25821_UNDEFINED = 0,
 	CX25821_RAW,
@@ -158,7 +136,6 @@ struct cx25821_board {
 	enum port portc;
 
 	u32 clk_freq;
-	struct cx25821_input input[CX25821_NR_INPUT];
 };
 
 struct cx25821_i2c {
@@ -365,9 +342,6 @@ static inline struct cx25821_dev *get_cx25821(struct v4l2_device *v4l2_dev)
 	return container_of(v4l2_dev, struct cx25821_dev, v4l2_dev);
 }
 
-#define cx25821_call_all(dev, o, f, args...) \
-	v4l2_device_call_all(&dev->v4l2_dev, 0, o, f, ##args)
-
 extern struct cx25821_board cx25821_boards[];
 
 #define SRAM_CH00  0		/* Video A */
-- 
1.7.10.4

