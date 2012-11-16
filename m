Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:4790 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599Ab2KPNi6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Nov 2012 08:38:58 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Kirill Smelkov <kirr@mns.spb.ru>
Subject: Re: [PATCH v4] [media] vivi: Teach it to tune FPS
Date: Fri, 16 Nov 2012 14:38:09 +0100
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
References: <1350914084-31618-1-git-send-email-kirr@mns.spb.ru> <201211021542.21944.hverkuil@xs4all.nl> <20121107113001.GA3097@tugrik.mns.mnsspb.ru>
In-Reply-To: <20121107113001.GA3097@tugrik.mns.mnsspb.ru>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201211161438.09046.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed November 7 2012 12:30:01 Kirill Smelkov wrote:
> On Fri, Nov 02, 2012 at 03:42:21PM +0100, Hans Verkuil wrote:
> > Thanks for the ping, I forgot about this patch...
> 
> Thanks for feedback and for waiting. I'm here again...
> 
> 
> > On Tue October 23 2012 15:35:21 Kirill Smelkov wrote:
> > > On Tue, Oct 23, 2012 at 08:40:04AM +0200, Hans Verkuil wrote:
> > > > On Mon October 22 2012 19:01:40 Kirill Smelkov wrote:
> > > > > On Mon, Oct 22, 2012 at 04:16:14PM +0200, Hans Verkuil wrote:
> > > > > > On Mon October 22 2012 15:54:44 Kirill Smelkov wrote:
> > > > > > > I was testing my video-over-ethernet subsystem today, and vivi seemed to
> > > > > > > be perfect video source for testing when one don't have lots of capture
> > > > > > > boards and cameras. Only its framerate was hardcoded to NTSC's 30fps,
> > > > > > > while in my country we usually use PAL (25 fps). That's why the patch.
> > > > > > > Thanks.
> > > > > > 
> > > > > > Rather than introducing a module option, it's much nicer if you can
> > > > > > implement enum_frameintervals and g/s_parm. This can be made quite flexible
> > > > > > allowing you to also support 50/59.94/60 fps.
> > > > > 
> > > > > Thanks for feedback. I've reworked the patch for FPS to be set via
> > > > > ->{g,s}_parm(), and yes now it is more flexble, because one can set
> > > > > different FPS on different vivi devices. Only I don't know V4L2 ioctls
> > > > > details well enough and various drivers do things differently. The patch
> > > > > is below. Is it ok?
> > > > 
> > > > Close, but it's not quite there.
> > > > 
> > > > You should run the v4l2-compliance tool from the v4l-utils.git repository
> > > > (take the master branch). That will report any errors in your implementation.
> > > > 
> > > > In this case g/s_parm doesn't set readbuffers (set it to 1) and if timeperframe
> > > > equals { 0, 0 }, then you should get a nominal framerate (let's stick to 29.97
> > > > for that). I would set the nominal framerate whenever the denominator == 0.
> > > > 
> > > > For vidioc_enum_frameintervals you need to check the IN fields and fill in the
> > > > stepwise struct.
> > > 
> > > Thanks for pointers and info about v4l2-compliance handy-tool. I've
> > > tried to correct all the issues you mentioned above and here is the
> > > patch.
> > > 
> > > (Only requirement to set stepwise.step to 1.0 for
> > >  V4L2_FRMIVAL_TYPE_CONTINUOUS seems a bit illogical to me, but anyway,
> > >  that's what the V4L2 spec requires...)
> > > 
> > > Thanks,
> > > Kirill
> > > 
> > > ---- 8< ----
> > > From: Kirill Smelkov <kirr@mns.spb.ru>
> > > Date: Tue, 23 Oct 2012 16:56:59 +0400
> > > Subject: [PATCH v3] [media] vivi: Teach it to tune FPS
> > > 
> > > I was testing my video-over-ethernet subsystem yesterday, and vivi
> > > seemed to be perfect video source for testing when one don't have lots
> > > of capture boards and cameras. Only its framerate was hardcoded to
> > > NTSC's 30fps, while in my country we usually use PAL (25 fps) and I
> > > needed that to precisely simulate bandwidth.
> > > 
> > > That's why here is this patch with ->enum_frameintervals() and
> > > ->{g,s}_parm() implemented as suggested by Hans Verkuil which passes
> > > v4l2-compliance and manual testing through v4l2-ctl -P / -p <fps>.
> > > 
> > > Regarding newly introduced __get_format(u32 pixelformat) I decided not
> > > to convert original get_format() to operate on fourcc codes, since >= 3
> > > places in driver need to deal with v4l2_format and otherwise it won't be
> > > handy.
> > > 
> > > Thanks.
> > > 
> > > Signed-off-by: Kirill Smelkov <kirr@mns.spb.ru>
> > > ---
> > >  drivers/media/platform/vivi.c | 84 ++++++++++++++++++++++++++++++++++++++-----
> > >  1 file changed, 75 insertions(+), 9 deletions(-)
> > > 
> > > V3:
> > >     - corrected issues with V4L2 spec compliance as pointed by Hans
> > >       Verkuil.
> > > 
> > > V2:
> > > 
> > >     - reworked FPS setting from module param to via ->{g,s}_parm() as suggested
> > >       by Hans Verkuil.
> > > 
> > > 
> > > diff --git a/drivers/media/platform/vivi.c b/drivers/media/platform/vivi.c
> > > index 3e6902a..3adea58 100644
> > > --- a/drivers/media/platform/vivi.c
> > > +++ b/drivers/media/platform/vivi.c
> > > @@ -36,10 +36,6 @@
> > >  
> > >  #define VIVI_MODULE_NAME "vivi"
> > >  
> > > -/* Wake up at about 30 fps */
> > > -#define WAKE_NUMERATOR 30
> > > -#define WAKE_DENOMINATOR 1001
> > > -
> > >  #define MAX_WIDTH 1920
> > >  #define MAX_HEIGHT 1200
> > >  
> > > @@ -69,6 +65,9 @@ MODULE_PARM_DESC(vid_limit, "capture memory limit in megabytes");
> > >  /* Global font descriptor */
> > >  static const u8 *font8x16;
> > >  
> > > +/* default to NTSC timeperframe */
> > > +static const struct v4l2_fract TPF_DEFAULT = {.numerator = 1001, .denominator = 30000};
> > 
> > Keep the name lower case: tpf_default. Upper case is for defines only.
> 
> ok
> 
> [...]
> 
> > > @@ -1049,6 +1054,63 @@ static int vidioc_s_input(struct file *file, void *priv, unsigned int i)
> > >  	return 0;
> > >  }
> > >  
> > > +/* timeperframe is arbitrary and continous */
> > > +static int vidioc_enum_frameintervals(struct file *file, void *priv,
> > > +					     struct v4l2_frmivalenum *fival)
> > > +{
> > > +	struct vivi_fmt *fmt;
> > > +
> > > +	if (fival->index)
> > > +		return -EINVAL;
> > > +
> > > +	fmt = __get_format(fival->pixel_format);
> > > +	if (!fmt)
> > > +		return -EINVAL;
> > > +
> > > +	/* regarding width width & height - we support any */
> > > +
> > > +	fival->type = V4L2_FRMIVAL_TYPE_CONTINUOUS;
> > > +
> > > +	/* fill in stepwise as required by V4L2 spec, i.e.
> > > +	 *
> > > +	 * min <= (step = 1.0) <= max
> > > +	 */
> > > +	fival->stepwise.step = (struct v4l2_fract) {1, 1};
> > > +	fival->stepwise.min  = (struct v4l2_fract) {1, 1};
> > > +	fival->stepwise.max  = (struct v4l2_fract) {2, 1};
> > 
> > Shouldn't max for {60, 1} or perhaps even {120, 1} if you want to be able to test 120 Hz
> > framerates? {2, 1} is 2 fps, which is a bit low :-)
> 
>  [ see below ... ]
> 
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +static int vidioc_g_parm(struct file *file, void *priv, struct v4l2_streamparm *parm)
> > > +{
> > > +	struct vivi_dev *dev = video_drvdata(file);
> > > +
> > > +	if (parm->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> > > +		return -EINVAL;
> > > +
> > > +	parm->parm.capture.capability   = V4L2_CAP_TIMEPERFRAME;
> > > +	parm->parm.capture.timeperframe = dev->timeperframe;
> > > +	parm->parm.capture.readbuffers  = 1;
> > > +	return 0;
> > > +}
> > > +
> > > +static int vidioc_s_parm(struct file *file, void *priv, struct v4l2_streamparm *parm)
> > > +{
> > > +	struct vivi_dev *dev = video_drvdata(file);
> > > +
> > > +	if (parm->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> > > +		return -EINVAL;
> > > +
> > > +	dev->timeperframe = parm->parm.capture.timeperframe.denominator ?
> > 
> > This should check that the fps is between the min and max values as reported by
> > vidioc_enum_frameintervals(). Fall back to the default if the values are out of
> > range.
> 
> {2, 1} is 0.5 fps and {120, 1} is 1/120 fps :) but anyway, why should we
> set that artificial limits here?
> 
> Thanks for catching the actual bug, but I propose we set min=1/infty and
> max=infty so that the user chooses which tpf/fps he/she needs, be it
> 9000 fps or 1 frame per hour. And imho it's better to clip the value,
> than to fallback to default (but we still reset it if */0 is coming from
> userspace).
> 
> Said all that, here is the interdiff and updated patch.
> 
> Thanks,
> Kirill
> 
> diff --git a/drivers/media/platform/vivi.c b/drivers/media/platform/vivi.c
> index 37d0af8..5d1b374 100644
> --- a/drivers/media/platform/vivi.c
> +++ b/drivers/media/platform/vivi.c
> @@ -65,8 +65,11 @@ MODULE_PARM_DESC(vid_limit, "capture memory limit in megabytes");
>  /* Global font descriptor */
>  static const u8 *font8x16;
>  
> -/* default to NTSC timeperframe */
> -static const struct v4l2_fract TPF_DEFAULT = {.numerator = 1001, .denominator = 30000};
> +/* timeperframe: min/max and default */
> +static const struct v4l2_fract
> +	tpf_min     = {.numerator = 1,		.denominator = UINT_MAX},  /* 1/infty */
> +	tpf_max     = {.numerator = UINT_MAX,	.denominator = 1},         /* infty */

I understand your reasoning here, but I wouldn't go with UINT_MAX here. Something like
1/1000 tpf (or 1 ms) up to 86400/1 tpf (or once a day). With UINT_MAX I am afraid we
might hit application errors when they manipulate these values. The shortest time
between frames is 1 ms anyway.

It's the only comment I have, it looks good otherwise.

Regards,

	Hans

> +	tpf_default = {.numerator = 1001,	.denominator = 30000};     /* NTSC */
>  
>  #define dprintk(dev, level, fmt, arg...) \
>  	v4l2_dbg(level, debug, &dev->v4l2_dev, fmt, ## arg)
> @@ -1098,17 +1101,14 @@ static int vidioc_enum_frameintervals(struct file *file, void *priv,
>  	if (!fmt)
>  		return -EINVAL;
>  
> -	/* regarding width width & height - we support any */
> +	/* regarding width & height - we support any */
>  
>  	fival->type = V4L2_FRMIVAL_TYPE_CONTINUOUS;
>  
> -	/* fill in stepwise as required by V4L2 spec, i.e.
> -	 *
> -	 * min <= (step = 1.0) <= max
> -	 */
> +	/* fill in stepwise (step=1.0 is requred by V4L2 spec) */
> +	fival->stepwise.min  = tpf_min;
> +	fival->stepwise.max  = tpf_max;
>  	fival->stepwise.step = (struct v4l2_fract) {1, 1};
> -	fival->stepwise.min  = (struct v4l2_fract) {1, 1};
> -	fival->stepwise.max  = (struct v4l2_fract) {2, 1};
>  
>  	return 0;
>  }
> @@ -1126,18 +1126,26 @@ static int vidioc_g_parm(struct file *file, void *priv, struct v4l2_streamparm *
>  	return 0;
>  }
>  
> +#define FRACT_CMP(a, OP, b)	\
> +	( (u64)(a).numerator * (b).denominator  OP  (u64)(b).numerator * (a).denominator )
> +
>  static int vidioc_s_parm(struct file *file, void *priv, struct v4l2_streamparm *parm)
>  {
>  	struct vivi_dev *dev = video_drvdata(file);
> +	struct v4l2_fract tpf;
>  
>  	if (parm->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
>  		return -EINVAL;
>  
> -	dev->timeperframe = parm->parm.capture.timeperframe.denominator ?
> -		parm->parm.capture.timeperframe :
> -		TPF_DEFAULT;	/* {*, 0} resets timing */
> +	tpf = parm->parm.capture.timeperframe;
>  
> -	parm->parm.capture.timeperframe = dev->timeperframe;
> +	/* tpf: {*, 0} resets timing; clip to [min, max]*/
> +	tpf = tpf.denominator ? tpf : tpf_default;
> +	tpf = FRACT_CMP(tpf, <, tpf_min) ? tpf_min : tpf;
> +	tpf = FRACT_CMP(tpf, >, tpf_max) ? tpf_max : tpf;
> +
> +	dev->timeperframe = tpf;
> +	parm->parm.capture.timeperframe = tpf;
>  	parm->parm.capture.readbuffers  = 1;
>  	return 0;
>  }
> @@ -1361,7 +1369,7 @@ static int __init vivi_create_instance(int inst)
>  		goto free_dev;
>  
>  	dev->fmt = &formats[0];
> -	dev->timeperframe = TPF_DEFAULT;
> +	dev->timeperframe = tpf_default;
>  	dev->width = 640;
>  	dev->height = 480;
>  	dev->pixelsize = dev->fmt->depth / 8;
> 
> 
> 
> ---- 8< ----
> From: Kirill Smelkov <kirr@mns.spb.ru>
> Date: Tue, 23 Oct 2012 16:56:59 +0400
> Subject: [PATCH v4] [media] vivi: Teach it to tune FPS
> 
> I was testing my video-over-ethernet subsystem recently, and vivi
> seemed to be perfect video source for testing when one don't have lots
> of capture boards and cameras. Only its framerate was hardcoded to
> NTSC's 30fps, while in my country we usually use PAL (25 fps) and I
> needed that to precisely simulate bandwidth.
> 
> That's why here is this patch with ->enum_frameintervals() and
> ->{g,s}_parm() implemented as suggested by Hans Verkuil which passes
> v4l2-compliance and manual testing through v4l2-ctl -P / -p <fps>.
> 
> Regarding newly introduced __get_format(u32 pixelformat) I decided not
> to convert original get_format() to operate on fourcc codes, since >= 3
> places in driver need to deal with v4l2_format and otherwise it won't be
> handy.
> 
> Thanks.
> 
> Signed-off-by: Kirill Smelkov <kirr@mns.spb.ru>
> ---
>  drivers/media/platform/vivi.c | 92 ++++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 83 insertions(+), 9 deletions(-)
> 
> V4:
>     - corrected fival->stepwise setting and added its check to s_parm();
>       also cosmetics - all as per Hans Verkuil review.
> 
> V3:
>     - corrected issues with V4L2 spec compliance as pointed by Hans
>       Verkuil.
> 
> V2:
> 
>     - reworked FPS setting from module param to via ->{g,s}_parm() as suggested
>       by Hans Verkuil.
> 
> 
> diff --git a/drivers/media/platform/vivi.c b/drivers/media/platform/vivi.c
> index 6e6dd25..5d1b374 100644
> --- a/drivers/media/platform/vivi.c
> +++ b/drivers/media/platform/vivi.c
> @@ -36,10 +36,6 @@
>  
>  #define VIVI_MODULE_NAME "vivi"
>  
> -/* Wake up at about 30 fps */
> -#define WAKE_NUMERATOR 30
> -#define WAKE_DENOMINATOR 1001
> -
>  #define MAX_WIDTH 1920
>  #define MAX_HEIGHT 1200
>  
> @@ -69,6 +65,12 @@ MODULE_PARM_DESC(vid_limit, "capture memory limit in megabytes");
>  /* Global font descriptor */
>  static const u8 *font8x16;
>  
> +/* timeperframe: min/max and default */
> +static const struct v4l2_fract
> +	tpf_min     = {.numerator = 1,		.denominator = UINT_MAX},  /* 1/infty */
> +	tpf_max     = {.numerator = UINT_MAX,	.denominator = 1},         /* infty */
> +	tpf_default = {.numerator = 1001,	.denominator = 30000};     /* NTSC */
> +
>  #define dprintk(dev, level, fmt, arg...) \
>  	v4l2_dbg(level, debug, &dev->v4l2_dev, fmt, ## arg)
>  
> @@ -150,14 +152,14 @@ static struct vivi_fmt formats[] = {
>  	},
>  };
>  
> -static struct vivi_fmt *get_format(struct v4l2_format *f)
> +static struct vivi_fmt *__get_format(u32 pixelformat)
>  {
>  	struct vivi_fmt *fmt;
>  	unsigned int k;
>  
>  	for (k = 0; k < ARRAY_SIZE(formats); k++) {
>  		fmt = &formats[k];
> -		if (fmt->fourcc == f->fmt.pix.pixelformat)
> +		if (fmt->fourcc == pixelformat)
>  			break;
>  	}
>  
> @@ -167,6 +169,11 @@ static struct vivi_fmt *get_format(struct v4l2_format *f)
>  	return &formats[k];
>  }
>  
> +static struct vivi_fmt *get_format(struct v4l2_format *f)
> +{
> +	return __get_format(f->fmt.pix.pixelformat);
> +}
> +
>  /* buffer for one video frame */
>  struct vivi_buffer {
>  	/* common v4l buffer stuff -- must be first */
> @@ -232,6 +239,7 @@ struct vivi_dev {
>  
>  	/* video capture */
>  	struct vivi_fmt            *fmt;
> +	struct v4l2_fract          timeperframe;
>  	unsigned int               width, height;
>  	struct vb2_queue	   vb_vidq;
>  	unsigned int		   field_count;
> @@ -691,8 +699,8 @@ static void vivi_thread_tick(struct vivi_dev *dev)
>  	dprintk(dev, 2, "[%p/%d] done\n", buf, buf->vb.v4l2_buf.index);
>  }
>  
> -#define frames_to_ms(frames)					\
> -	((frames * WAKE_NUMERATOR * 1000) / WAKE_DENOMINATOR)
> +#define frames_to_ms(dev, frames)				\
> +	((frames * dev->timeperframe.numerator * 1000) / dev->timeperframe.denominator)
>  
>  static void vivi_sleep(struct vivi_dev *dev)
>  {
> @@ -708,7 +716,7 @@ static void vivi_sleep(struct vivi_dev *dev)
>  		goto stop_task;
>  
>  	/* Calculate time to wake up */
> -	timeout = msecs_to_jiffies(frames_to_ms(1));
> +	timeout = msecs_to_jiffies(frames_to_ms(dev, 1));
>  
>  	vivi_thread_tick(dev);
>  
> @@ -1080,6 +1088,68 @@ static int vidioc_s_input(struct file *file, void *priv, unsigned int i)
>  	return 0;
>  }
>  
> +/* timeperframe is arbitrary and continous */
> +static int vidioc_enum_frameintervals(struct file *file, void *priv,
> +					     struct v4l2_frmivalenum *fival)
> +{
> +	struct vivi_fmt *fmt;
> +
> +	if (fival->index)
> +		return -EINVAL;
> +
> +	fmt = __get_format(fival->pixel_format);
> +	if (!fmt)
> +		return -EINVAL;
> +
> +	/* regarding width & height - we support any */
> +
> +	fival->type = V4L2_FRMIVAL_TYPE_CONTINUOUS;
> +
> +	/* fill in stepwise (step=1.0 is requred by V4L2 spec) */
> +	fival->stepwise.min  = tpf_min;
> +	fival->stepwise.max  = tpf_max;
> +	fival->stepwise.step = (struct v4l2_fract) {1, 1};
> +
> +	return 0;
> +}
> +
> +static int vidioc_g_parm(struct file *file, void *priv, struct v4l2_streamparm *parm)
> +{
> +	struct vivi_dev *dev = video_drvdata(file);
> +
> +	if (parm->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +		return -EINVAL;
> +
> +	parm->parm.capture.capability   = V4L2_CAP_TIMEPERFRAME;
> +	parm->parm.capture.timeperframe = dev->timeperframe;
> +	parm->parm.capture.readbuffers  = 1;
> +	return 0;
> +}
> +
> +#define FRACT_CMP(a, OP, b)	\
> +	( (u64)(a).numerator * (b).denominator  OP  (u64)(b).numerator * (a).denominator )
> +
> +static int vidioc_s_parm(struct file *file, void *priv, struct v4l2_streamparm *parm)
> +{
> +	struct vivi_dev *dev = video_drvdata(file);
> +	struct v4l2_fract tpf;
> +
> +	if (parm->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +		return -EINVAL;
> +
> +	tpf = parm->parm.capture.timeperframe;
> +
> +	/* tpf: {*, 0} resets timing; clip to [min, max]*/
> +	tpf = tpf.denominator ? tpf : tpf_default;
> +	tpf = FRACT_CMP(tpf, <, tpf_min) ? tpf_min : tpf;
> +	tpf = FRACT_CMP(tpf, >, tpf_max) ? tpf_max : tpf;
> +
> +	dev->timeperframe = tpf;
> +	parm->parm.capture.timeperframe = tpf;
> +	parm->parm.capture.readbuffers  = 1;
> +	return 0;
> +}
> +
>  /* --- controls ---------------------------------------------- */
>  
>  static int vivi_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
> @@ -1238,6 +1308,9 @@ static const struct v4l2_ioctl_ops vivi_ioctl_ops = {
>  	.vidioc_enum_input    = vidioc_enum_input,
>  	.vidioc_g_input       = vidioc_g_input,
>  	.vidioc_s_input       = vidioc_s_input,
> +	.vidioc_enum_frameintervals = vidioc_enum_frameintervals,
> +	.vidioc_g_parm        = vidioc_g_parm,
> +	.vidioc_s_parm        = vidioc_s_parm,
>  	.vidioc_streamon      = vb2_ioctl_streamon,
>  	.vidioc_streamoff     = vb2_ioctl_streamoff,
>  	.vidioc_log_status    = v4l2_ctrl_log_status,
> @@ -1296,6 +1369,7 @@ static int __init vivi_create_instance(int inst)
>  		goto free_dev;
>  
>  	dev->fmt = &formats[0];
> +	dev->timeperframe = tpf_default;
>  	dev->width = 640;
>  	dev->height = 480;
>  	dev->pixelsize = dev->fmt->depth / 8;
> 
