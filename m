Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:3087 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756077Ab2K3LMN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Nov 2012 06:12:13 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Kirill Smelkov <kirr@mns.spb.ru>
Subject: Re: [PATCH v6] [media] vivi: Teach it to tune FPS
Date: Fri, 30 Nov 2012 12:10:59 +0100
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
References: <1350914084-31618-1-git-send-email-kirr@mns.spb.ru> <20121119055236.GA5486@tugrik.mns.mnsspb.ru> <20121130110214.GA10056@tugrik.mns.mnsspb.ru>
In-Reply-To: <20121130110214.GA10056@tugrik.mns.mnsspb.ru>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201211301210.59509.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri November 30 2012 12:02:14 Kirill Smelkov wrote:
> On Mon, Nov 19, 2012 at 09:52:36AM +0400, Kirill Smelkov wrote:
> > On Sun, Nov 18, 2012 at 07:25:38AM -0200, Mauro Carvalho Chehab wrote:
> > > Em 18-11-2012 07:24, Mauro Carvalho Chehab escreveu:
> > > >Em 17-11-2012 08:45, Kirill Smelkov escreveu:
> > > >>On Fri, Nov 16, 2012 at 01:46:58PM -0200, Mauro Carvalho Chehab wrote:
> > > >>>Em 16-11-2012 11:38, Hans Verkuil escreveu:
> > > >>>>On Wed November 7 2012 12:30:01 Kirill Smelkov wrote:
> > > >>[...]
> > > >>
> > > >>>>>diff --git a/drivers/media/platform/vivi.c b/drivers/media/platform/vivi.c
> > > >>>>>index 37d0af8..5d1b374 100644
> > > >>>>>--- a/drivers/media/platform/vivi.c
> > > >>>>>+++ b/drivers/media/platform/vivi.c
> > > >>>>>@@ -65,8 +65,11 @@ MODULE_PARM_DESC(vid_limit, "capture memory limit in megabytes");
> > > >>>>>  /* Global font descriptor */
> > > >>>>>  static const u8 *font8x16;
> > > >>>>>
> > > >>>>>-/* default to NTSC timeperframe */
> > > >>>>>-static const struct v4l2_fract TPF_DEFAULT = {.numerator = 1001, .denominator = 30000};
> > > >>>>>+/* timeperframe: min/max and default */
> > > >>>>>+static const struct v4l2_fract
> > > >>>>>+    tpf_min     = {.numerator = 1,        .denominator = UINT_MAX},  /* 1/infty */
> > > >>>>>+    tpf_max     = {.numerator = UINT_MAX,    .denominator = 1},         /* infty */
> > > >>>>
> > > >>>>I understand your reasoning here, but I wouldn't go with UINT_MAX here. Something like
> > > >>>>1/1000 tpf (or 1 ms) up to 86400/1 tpf (or once a day). With UINT_MAX I am afraid we
> > > >>>>might hit application errors when they manipulate these values. The shortest time
> > > >>>>between frames is 1 ms anyway.
> > > >>>>
> > > >>>>It's the only comment I have, it looks good otherwise.
> > > >>>
> > > >>>As those will be a arbitrary values, I suggest to declare a macro for it at the
> > > >>>beginning of vivi.c file, with some comment explaining the rationale of the choose,
> > > >>>and what else needs to be changed, if this changes (e. g. less than 1ms would require
> > > >>>changing the image generation logic, to avoid producing frames with equal content).
> > > >>
> > > >>Maybe something like this? (please note, I'm not a good text writer. If
> > > >>this needs adjustment please help me shape the text up)
> > > >>
> > > >>
> > > >>diff --git a/drivers/media/platform/vivi.c b/drivers/media/platform/vivi.c
> > > >>index 5d1b374..45b8a81 100644
> > > >>--- a/drivers/media/platform/vivi.c
> > > >>+++ b/drivers/media/platform/vivi.c
> > > >>@@ -36,6 +36,18 @@
> > > >>
> > > >>  #define VIVI_MODULE_NAME "vivi"
> > > >>
> > > >>+/* Maximum allowed frame rate
> > > >>+ *
> > > >>+ * Vivi will allow setting timeperframe in [1/FPS_MAX - FPS_MAX/1] range.
> > > >>+ *
> > > >>+ * Ideally FPS_MAX should be infinity, i.e. practically UINT_MAX, but that
> > > >>+ * might hit application errors when they manipulate these values.
> > > >>+ *
> > > >>+ * Besides, for tpf < 1ms image-generation logic should be changed, to avoid
> > > >>+ * producing frames with equal content.
> > > >>+ */
> > > >>+#define FPS_MAX 1000
> > > >>+
> > > >>  #define MAX_WIDTH 1920
> > > >>  #define MAX_HEIGHT 1200
> > > >>
> > > >>@@ -67,8 +79,8 @@ static const u8 *font8x16;
> > > >>
> > > >>  /* timeperframe: min/max and default */
> > > >>  static const struct v4l2_fract
> > > >>-    tpf_min     = {.numerator = 1,        .denominator = UINT_MAX},  /* 1/infty */
> > > >>-    tpf_max     = {.numerator = UINT_MAX,    .denominator = 1},         /* infty */
> > > >>+    tpf_min     = {.numerator = 1,        .denominator = FPS_MAX},   /* ~1/infty */
> > > >>+    tpf_max     = {.numerator = FPS_MAX,    .denominator = 1},         /* ~infty */
> > > 
> > > Was too fast answering it... The comments there should also be dropped, as it doesn't
> > > range anymore to infty.
> > 
> > Ok, agree, let's drop those ~infty comments and be done with it.
> > 
> > 
> > ---- 8< ----
> > From: Kirill Smelkov <kirr@mns.spb.ru>
> > Date: Tue, 23 Oct 2012 16:56:59 +0400
> > Subject: [PATCH v6] [media] vivi: Teach it to tune FPS
> > 
> > I was testing my video-over-ethernet subsystem recently, and vivi
> > seemed to be perfect video source for testing when one don't have lots
> > of capture boards and cameras. Only its framerate was hardcoded to
> > NTSC's 30fps, while in my country we usually use PAL (25 fps) and I
> > needed that to precisely simulate bandwidth.
> > 
> > That's why here is this patch with ->enum_frameintervals() and
> > ->{g,s}_parm() implemented as suggested by Hans Verkuil which passes
> > v4l2-compliance and manual testing through v4l2-ctl -P / -p <fps>.
> > 
> > Regarding newly introduced __get_format(u32 pixelformat) I decided not
> > to convert original get_format() to operate on fourcc codes, since >= 3
> > places in driver need to deal with v4l2_format and otherwise it won't be
> > handy.
> > 
> > Thanks.
> > 
> > Signed-off-by: Kirill Smelkov <kirr@mns.spb.ru>
> > ---
> >  drivers/media/platform/vivi.c | 102 ++++++++++++++++++++++++++++++++++++++----
> >  1 file changed, 94 insertions(+), 8 deletions(-)
> > 
> > V6:
> >     - Moved TPF/FPS limit to beginning of vivi.c and added comment there
> >       why that limit is used, to avoid overlows, as suggested by Mauro
> >       Carvalho Chehab.
> > 
> > V5:
> >     - changed  1/infty - infty/1  limits to  1/1000 - 1000/1, to avoid
> >       hitting aplication errors when they try to manipulato those
> >       values, as suggested by Hans Verkuil.
> > 
> > V4:
> >     - corrected fival->stepwise setting and added its check to s_parm();
> >       also cosmetics - all as per Hans Verkuil review.
> > 
> > V3:
> >     - corrected issues with V4L2 spec compliance as pointed by Hans
> >       Verkuil.
> > 
> > V2:
> > 
> >     - reworked FPS setting from module param to via ->{g,s}_parm() as suggested
> >       by Hans Verkuil.
> > 
> > 
> > diff --git a/drivers/media/platform/vivi.c b/drivers/media/platform/vivi.c
> > index 6e6dd25..9ca920e 100644
> > --- a/drivers/media/platform/vivi.c
> > +++ b/drivers/media/platform/vivi.c
> > @@ -36,9 +36,17 @@
> >  
> >  #define VIVI_MODULE_NAME "vivi"
> >  
> > -/* Wake up at about 30 fps */
> > -#define WAKE_NUMERATOR 30
> > -#define WAKE_DENOMINATOR 1001
> > +/* Maximum allowed frame rate
> > + *
> > + * Vivi will allow setting timeperframe in [1/FPS_MAX - FPS_MAX/1] range.
> > + *
> > + * Ideally FPS_MAX should be infinity, i.e. practically UINT_MAX, but that
> > + * might hit application errors when they manipulate these values.
> > + *
> > + * Besides, for tpf < 1ms image-generation logic should be changed, to avoid
> > + * producing frames with equal content.
> > + */
> > +#define FPS_MAX 1000
> >  
> >  #define MAX_WIDTH 1920
> >  #define MAX_HEIGHT 1200
> > @@ -69,6 +77,12 @@ MODULE_PARM_DESC(vid_limit, "capture memory limit in megabytes");
> >  /* Global font descriptor */
> >  static const u8 *font8x16;
> >  
> > +/* timeperframe: min/max and default */
> > +static const struct v4l2_fract
> > +	tpf_min     = {.numerator = 1,		.denominator = FPS_MAX},
> > +	tpf_max     = {.numerator = FPS_MAX,	.denominator = 1},
> > +	tpf_default = {.numerator = 1001,	.denominator = 30000};	/* NTSC */
> > +
> >  #define dprintk(dev, level, fmt, arg...) \
> >  	v4l2_dbg(level, debug, &dev->v4l2_dev, fmt, ## arg)
> >  
> > @@ -150,14 +164,14 @@ static struct vivi_fmt formats[] = {
> >  	},
> >  };
> >  
> > -static struct vivi_fmt *get_format(struct v4l2_format *f)
> > +static struct vivi_fmt *__get_format(u32 pixelformat)
> >  {
> >  	struct vivi_fmt *fmt;
> >  	unsigned int k;
> >  
> >  	for (k = 0; k < ARRAY_SIZE(formats); k++) {
> >  		fmt = &formats[k];
> > -		if (fmt->fourcc == f->fmt.pix.pixelformat)
> > +		if (fmt->fourcc == pixelformat)
> >  			break;
> >  	}
> >  
> > @@ -167,6 +181,11 @@ static struct vivi_fmt *get_format(struct v4l2_format *f)
> >  	return &formats[k];
> >  }
> >  
> > +static struct vivi_fmt *get_format(struct v4l2_format *f)
> > +{
> > +	return __get_format(f->fmt.pix.pixelformat);
> > +}
> > +
> >  /* buffer for one video frame */
> >  struct vivi_buffer {
> >  	/* common v4l buffer stuff -- must be first */
> > @@ -232,6 +251,7 @@ struct vivi_dev {
> >  
> >  	/* video capture */
> >  	struct vivi_fmt            *fmt;
> > +	struct v4l2_fract          timeperframe;
> >  	unsigned int               width, height;
> >  	struct vb2_queue	   vb_vidq;
> >  	unsigned int		   field_count;
> > @@ -691,8 +711,8 @@ static void vivi_thread_tick(struct vivi_dev *dev)
> >  	dprintk(dev, 2, "[%p/%d] done\n", buf, buf->vb.v4l2_buf.index);
> >  }
> >  
> > -#define frames_to_ms(frames)					\
> > -	((frames * WAKE_NUMERATOR * 1000) / WAKE_DENOMINATOR)
> > +#define frames_to_ms(dev, frames)				\
> > +	((frames * dev->timeperframe.numerator * 1000) / dev->timeperframe.denominator)
> >  
> >  static void vivi_sleep(struct vivi_dev *dev)
> >  {
> > @@ -708,7 +728,7 @@ static void vivi_sleep(struct vivi_dev *dev)
> >  		goto stop_task;
> >  
> >  	/* Calculate time to wake up */
> > -	timeout = msecs_to_jiffies(frames_to_ms(1));
> > +	timeout = msecs_to_jiffies(frames_to_ms(dev, 1));
> >  
> >  	vivi_thread_tick(dev);
> >  
> > @@ -1080,6 +1100,68 @@ static int vidioc_s_input(struct file *file, void *priv, unsigned int i)
> >  	return 0;
> >  }
> >  
> > +/* timeperframe is arbitrary and continous */
> > +static int vidioc_enum_frameintervals(struct file *file, void *priv,
> > +					     struct v4l2_frmivalenum *fival)
> > +{
> > +	struct vivi_fmt *fmt;
> > +
> > +	if (fival->index)
> > +		return -EINVAL;
> > +
> > +	fmt = __get_format(fival->pixel_format);
> > +	if (!fmt)
> > +		return -EINVAL;
> > +
> > +	/* regarding width & height - we support any */
> > +
> > +	fival->type = V4L2_FRMIVAL_TYPE_CONTINUOUS;
> > +
> > +	/* fill in stepwise (step=1.0 is requred by V4L2 spec) */
> > +	fival->stepwise.min  = tpf_min;
> > +	fival->stepwise.max  = tpf_max;
> > +	fival->stepwise.step = (struct v4l2_fract) {1, 1};
> > +
> > +	return 0;
> > +}
> > +
> > +static int vidioc_g_parm(struct file *file, void *priv, struct v4l2_streamparm *parm)
> > +{
> > +	struct vivi_dev *dev = video_drvdata(file);
> > +
> > +	if (parm->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> > +		return -EINVAL;
> > +
> > +	parm->parm.capture.capability   = V4L2_CAP_TIMEPERFRAME;
> > +	parm->parm.capture.timeperframe = dev->timeperframe;
> > +	parm->parm.capture.readbuffers  = 1;
> > +	return 0;
> > +}
> > +
> > +#define FRACT_CMP(a, OP, b)	\
> > +	( (u64)(a).numerator * (b).denominator  OP  (u64)(b).numerator * (a).denominator )
> > +
> > +static int vidioc_s_parm(struct file *file, void *priv, struct v4l2_streamparm *parm)
> > +{
> > +	struct vivi_dev *dev = video_drvdata(file);
> > +	struct v4l2_fract tpf;
> > +
> > +	if (parm->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> > +		return -EINVAL;
> > +
> > +	tpf = parm->parm.capture.timeperframe;
> > +
> > +	/* tpf: {*, 0} resets timing; clip to [min, max]*/
> > +	tpf = tpf.denominator ? tpf : tpf_default;
> > +	tpf = FRACT_CMP(tpf, <, tpf_min) ? tpf_min : tpf;
> > +	tpf = FRACT_CMP(tpf, >, tpf_max) ? tpf_max : tpf;
> > +
> > +	dev->timeperframe = tpf;
> > +	parm->parm.capture.timeperframe = tpf;
> > +	parm->parm.capture.readbuffers  = 1;
> > +	return 0;
> > +}
> > +
> >  /* --- controls ---------------------------------------------- */
> >  
> >  static int vivi_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
> > @@ -1238,6 +1320,9 @@ static const struct v4l2_ioctl_ops vivi_ioctl_ops = {
> >  	.vidioc_enum_input    = vidioc_enum_input,
> >  	.vidioc_g_input       = vidioc_g_input,
> >  	.vidioc_s_input       = vidioc_s_input,
> > +	.vidioc_enum_frameintervals = vidioc_enum_frameintervals,
> > +	.vidioc_g_parm        = vidioc_g_parm,
> > +	.vidioc_s_parm        = vidioc_s_parm,
> >  	.vidioc_streamon      = vb2_ioctl_streamon,
> >  	.vidioc_streamoff     = vb2_ioctl_streamoff,
> >  	.vidioc_log_status    = v4l2_ctrl_log_status,
> > @@ -1296,6 +1381,7 @@ static int __init vivi_create_instance(int inst)
> >  		goto free_dev;
> >  
> >  	dev->fmt = &formats[0];
> > +	dev->timeperframe = tpf_default;
> >  	dev->width = 640;
> >  	dev->height = 480;
> >  	dev->pixelsize = dev->fmt->depth / 8;
> 
> 
> Mauro, Hans, what's the state of this patch? Just a ping, I know you are
> under load.
> 
> Thanks,
> Kirill
> 
> 
> P.S. Hans, if this is ok for you, would you please add your ack?
> 

Looks good to me!

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks,

	Hans
