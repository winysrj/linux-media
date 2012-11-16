Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.mnsspb.ru ([84.204.75.2]:56041 "EHLO mail.mnsspb.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752375Ab2KPOsA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Nov 2012 09:48:00 -0500
Date: Fri, 16 Nov 2012 18:48:41 +0400
From: Kirill Smelkov <kirr@mns.spb.ru>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v5] [media] vivi: Teach it to tune FPS
Message-ID: <20121116144841.GA14917@tugrik.mns.mnsspb.ru>
References: <1350914084-31618-1-git-send-email-kirr@mns.spb.ru>
 <201211021542.21944.hverkuil@xs4all.nl>
 <20121107113001.GA3097@tugrik.mns.mnsspb.ru>
 <201211161438.09046.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201211161438.09046.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Nov 16, 2012 at 02:38:09PM +0100, Hans Verkuil wrote:
> On Wed November 7 2012 12:30:01 Kirill Smelkov wrote:
[...]

> > diff --git a/drivers/media/platform/vivi.c b/drivers/media/platform/vivi.c
> > index 37d0af8..5d1b374 100644
> > --- a/drivers/media/platform/vivi.c
> > +++ b/drivers/media/platform/vivi.c
> > @@ -65,8 +65,11 @@ MODULE_PARM_DESC(vid_limit, "capture memory limit in megabytes");
> >  /* Global font descriptor */
> >  static const u8 *font8x16;
> >  
> > -/* default to NTSC timeperframe */
> > -static const struct v4l2_fract TPF_DEFAULT = {.numerator = 1001, .denominator = 30000};
> > +/* timeperframe: min/max and default */
> > +static const struct v4l2_fract
> > +	tpf_min     = {.numerator = 1,		.denominator = UINT_MAX},  /* 1/infty */
> > +	tpf_max     = {.numerator = UINT_MAX,	.denominator = 1},         /* infty */
> 
> I understand your reasoning here, but I wouldn't go with UINT_MAX here. Something like
> 1/1000 tpf (or 1 ms) up to 86400/1 tpf (or once a day). With UINT_MAX I am afraid we
> might hit application errors when they manipulate these values. The shortest time
> between frames is 1 ms anyway.
> 
> It's the only comment I have, it looks good otherwise.

Thanks, Let's then merge it with 1/1000 - 1000/1 limit. Ok?

Thanks again,
Kirill


---- 8< ----
From: Kirill Smelkov <kirr@mns.spb.ru>
Date: Tue, 23 Oct 2012 16:56:59 +0400
Subject: [PATCH v5] [media] vivi: Teach it to tune FPS

I was testing my video-over-ethernet subsystem recently, and vivi
seemed to be perfect video source for testing when one don't have lots
of capture boards and cameras. Only its framerate was hardcoded to
NTSC's 30fps, while in my country we usually use PAL (25 fps) and I
needed that to precisely simulate bandwidth.

That's why here is this patch with ->enum_frameintervals() and
->{g,s}_parm() implemented as suggested by Hans Verkuil which passes
v4l2-compliance and manual testing through v4l2-ctl -P / -p <fps>.

Regarding newly introduced __get_format(u32 pixelformat) I decided not
to convert original get_format() to operate on fourcc codes, since >= 3
places in driver need to deal with v4l2_format and otherwise it won't be
handy.

Thanks.

Signed-off-by: Kirill Smelkov <kirr@mns.spb.ru>
---
 drivers/media/platform/vivi.c | 92 ++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 83 insertions(+), 9 deletions(-)

V5:
    - changed  1/infty - infty/1  limits to  1/1000 - 1000/1, to avoid
      hitting aplication errors when they try to manipulato those
      values, as suggested by Hans Verkuil.

V4:
    - corrected fival->stepwise setting and added its check to s_parm();
      also cosmetics - all as per Hans Verkuil review.

V3:
    - corrected issues with V4L2 spec compliance as pointed by Hans
      Verkuil.

V2:

    - reworked FPS setting from module param to via ->{g,s}_parm() as suggested
      by Hans Verkuil.

diff --git a/drivers/media/platform/vivi.c b/drivers/media/platform/vivi.c
index 6e6dd25..793d7ee 100644
--- a/drivers/media/platform/vivi.c
+++ b/drivers/media/platform/vivi.c
@@ -36,10 +36,6 @@
 
 #define VIVI_MODULE_NAME "vivi"
 
-/* Wake up at about 30 fps */
-#define WAKE_NUMERATOR 30
-#define WAKE_DENOMINATOR 1001
-
 #define MAX_WIDTH 1920
 #define MAX_HEIGHT 1200
 
@@ -69,6 +65,12 @@ MODULE_PARM_DESC(vid_limit, "capture memory limit in megabytes");
 /* Global font descriptor */
 static const u8 *font8x16;
 
+/* timeperframe: min/max and default */
+static const struct v4l2_fract
+	tpf_min     = {.numerator = 1,		.denominator = 1000},	/* ~1/infty */
+	tpf_max     = {.numerator = 1000,	.denominator = 1},	/* ~infty */
+	tpf_default = {.numerator = 1001,	.denominator = 30000};	/* NTSC */
+
 #define dprintk(dev, level, fmt, arg...) \
 	v4l2_dbg(level, debug, &dev->v4l2_dev, fmt, ## arg)
 
@@ -150,14 +152,14 @@ static struct vivi_fmt formats[] = {
 	},
 };
 
-static struct vivi_fmt *get_format(struct v4l2_format *f)
+static struct vivi_fmt *__get_format(u32 pixelformat)
 {
 	struct vivi_fmt *fmt;
 	unsigned int k;
 
 	for (k = 0; k < ARRAY_SIZE(formats); k++) {
 		fmt = &formats[k];
-		if (fmt->fourcc == f->fmt.pix.pixelformat)
+		if (fmt->fourcc == pixelformat)
 			break;
 	}
 
@@ -167,6 +169,11 @@ static struct vivi_fmt *get_format(struct v4l2_format *f)
 	return &formats[k];
 }
 
+static struct vivi_fmt *get_format(struct v4l2_format *f)
+{
+	return __get_format(f->fmt.pix.pixelformat);
+}
+
 /* buffer for one video frame */
 struct vivi_buffer {
 	/* common v4l buffer stuff -- must be first */
@@ -232,6 +239,7 @@ struct vivi_dev {
 
 	/* video capture */
 	struct vivi_fmt            *fmt;
+	struct v4l2_fract          timeperframe;
 	unsigned int               width, height;
 	struct vb2_queue	   vb_vidq;
 	unsigned int		   field_count;
@@ -691,8 +699,8 @@ static void vivi_thread_tick(struct vivi_dev *dev)
 	dprintk(dev, 2, "[%p/%d] done\n", buf, buf->vb.v4l2_buf.index);
 }
 
-#define frames_to_ms(frames)					\
-	((frames * WAKE_NUMERATOR * 1000) / WAKE_DENOMINATOR)
+#define frames_to_ms(dev, frames)				\
+	((frames * dev->timeperframe.numerator * 1000) / dev->timeperframe.denominator)
 
 static void vivi_sleep(struct vivi_dev *dev)
 {
@@ -708,7 +716,7 @@ static void vivi_sleep(struct vivi_dev *dev)
 		goto stop_task;
 
 	/* Calculate time to wake up */
-	timeout = msecs_to_jiffies(frames_to_ms(1));
+	timeout = msecs_to_jiffies(frames_to_ms(dev, 1));
 
 	vivi_thread_tick(dev);
 
@@ -1080,6 +1088,68 @@ static int vidioc_s_input(struct file *file, void *priv, unsigned int i)
 	return 0;
 }
 
+/* timeperframe is arbitrary and continous */
+static int vidioc_enum_frameintervals(struct file *file, void *priv,
+					     struct v4l2_frmivalenum *fival)
+{
+	struct vivi_fmt *fmt;
+
+	if (fival->index)
+		return -EINVAL;
+
+	fmt = __get_format(fival->pixel_format);
+	if (!fmt)
+		return -EINVAL;
+
+	/* regarding width & height - we support any */
+
+	fival->type = V4L2_FRMIVAL_TYPE_CONTINUOUS;
+
+	/* fill in stepwise (step=1.0 is requred by V4L2 spec) */
+	fival->stepwise.min  = tpf_min;
+	fival->stepwise.max  = tpf_max;
+	fival->stepwise.step = (struct v4l2_fract) {1, 1};
+
+	return 0;
+}
+
+static int vidioc_g_parm(struct file *file, void *priv, struct v4l2_streamparm *parm)
+{
+	struct vivi_dev *dev = video_drvdata(file);
+
+	if (parm->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	parm->parm.capture.capability   = V4L2_CAP_TIMEPERFRAME;
+	parm->parm.capture.timeperframe = dev->timeperframe;
+	parm->parm.capture.readbuffers  = 1;
+	return 0;
+}
+
+#define FRACT_CMP(a, OP, b)	\
+	( (u64)(a).numerator * (b).denominator  OP  (u64)(b).numerator * (a).denominator )
+
+static int vidioc_s_parm(struct file *file, void *priv, struct v4l2_streamparm *parm)
+{
+	struct vivi_dev *dev = video_drvdata(file);
+	struct v4l2_fract tpf;
+
+	if (parm->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	tpf = parm->parm.capture.timeperframe;
+
+	/* tpf: {*, 0} resets timing; clip to [min, max]*/
+	tpf = tpf.denominator ? tpf : tpf_default;
+	tpf = FRACT_CMP(tpf, <, tpf_min) ? tpf_min : tpf;
+	tpf = FRACT_CMP(tpf, >, tpf_max) ? tpf_max : tpf;
+
+	dev->timeperframe = tpf;
+	parm->parm.capture.timeperframe = tpf;
+	parm->parm.capture.readbuffers  = 1;
+	return 0;
+}
+
 /* --- controls ---------------------------------------------- */
 
 static int vivi_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
@@ -1238,6 +1308,9 @@ static const struct v4l2_ioctl_ops vivi_ioctl_ops = {
 	.vidioc_enum_input    = vidioc_enum_input,
 	.vidioc_g_input       = vidioc_g_input,
 	.vidioc_s_input       = vidioc_s_input,
+	.vidioc_enum_frameintervals = vidioc_enum_frameintervals,
+	.vidioc_g_parm        = vidioc_g_parm,
+	.vidioc_s_parm        = vidioc_s_parm,
 	.vidioc_streamon      = vb2_ioctl_streamon,
 	.vidioc_streamoff     = vb2_ioctl_streamoff,
 	.vidioc_log_status    = v4l2_ctrl_log_status,
@@ -1296,6 +1369,7 @@ static int __init vivi_create_instance(int inst)
 		goto free_dev;
 
 	dev->fmt = &formats[0];
+	dev->timeperframe = tpf_default;
 	dev->width = 640;
 	dev->height = 480;
 	dev->pixelsize = dev->fmt->depth / 8;
-- 
1.8.0.289.g7a667bc

