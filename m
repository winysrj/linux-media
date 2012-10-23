Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:2605 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817Ab2JWGkz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Oct 2012 02:40:55 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Kirill Smelkov <kirr@mns.spb.ru>
Subject: Re: [PATCH 2/2] [media] vivi: Teach it to tune FPS
Date: Tue, 23 Oct 2012 08:40:04 +0200
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
References: <1350914084-31618-1-git-send-email-kirr@mns.spb.ru> <201210221616.14299.hverkuil@xs4all.nl> <20121022170139.GA23735@tugrik.mns.mnsspb.ru>
In-Reply-To: <20121022170139.GA23735@tugrik.mns.mnsspb.ru>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201210230840.04382.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon October 22 2012 19:01:40 Kirill Smelkov wrote:
> On Mon, Oct 22, 2012 at 04:16:14PM +0200, Hans Verkuil wrote:
> > On Mon October 22 2012 15:54:44 Kirill Smelkov wrote:
> > > I was testing my video-over-ethernet subsystem today, and vivi seemed to
> > > be perfect video source for testing when one don't have lots of capture
> > > boards and cameras. Only its framerate was hardcoded to NTSC's 30fps,
> > > while in my country we usually use PAL (25 fps). That's why the patch.
> > > Thanks.
> > 
> > Rather than introducing a module option, it's much nicer if you can
> > implement enum_frameintervals and g/s_parm. This can be made quite flexible
> > allowing you to also support 50/59.94/60 fps.
> 
> Thanks for feedback. I've reworked the patch for FPS to be set via
> ->{g,s}_parm(), and yes now it is more flexble, because one can set
> different FPS on different vivi devices. Only I don't know V4L2 ioctls
> details well enough and various drivers do things differently. The patch
> is below. Is it ok?

Close, but it's not quite there.

You should run the v4l2-compliance tool from the v4l-utils.git repository
(take the master branch). That will report any errors in your implementation.

In this case g/s_parm doesn't set readbuffers (set it to 1) and if timeperframe
equals { 0, 0 }, then you should get a nominal framerate (let's stick to 29.97
for that). I would set the nominal framerate whenever the denominator == 0.

For vidioc_enum_frameintervals you need to check the IN fields and fill in the
stepwise struct.

Regards,

	Hans

> 
> Thanks,
> Kirill
> 
> 
> ---- 8< ----
> From: Kirill Smelkov <kirr@mns.spb.ru>
> Date: Mon, 22 Oct 2012 17:25:24 +0400
> Subject: [PATCH v2] [media] vivi: Teach it to tune FPS
> 
> I was testing my video-over-ethernet subsystem today, and vivi seemed to
> be perfect video source for testing when one don't have lots of capture
> boards and cameras. Only its framerate was hardcoded to NTSC's 30fps,
> while in my country we usually use PAL (25 fps).
> 
> That's why here is this patch with ->enum_frameintervals and
> ->{g,s}_parm implemented as suggested by Hans Verkuil. Not sure I've
> done ->g_parm right -- some drivers clear parm memory before setting
> fields, some don't. As at is at least it works for me (tested via
> v4l2-ctl -P / -p <fps>).
> 
> Thanks.
> 
> Signed-off-by: Kirill Smelkov <kirr@mns.spb.ru>
> ---
>  drivers/media/platform/vivi.c | 50 +++++++++++++++++++++++++++++++++++++------
>  1 file changed, 43 insertions(+), 7 deletions(-)
> 
> V2:
> 
>     - reworked FPS setting from module param to via ->{g,s}_parm() as suggested
>       by Hans Verkuil.
> 
> diff --git a/drivers/media/platform/vivi.c b/drivers/media/platform/vivi.c
> index 3e6902a..c0855a5 100644
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
> @@ -232,6 +228,7 @@ struct vivi_dev {
>  
>  	/* video capture */
>  	struct vivi_fmt            *fmt;
> +	struct v4l2_fract          timeperframe;
>  	unsigned int               width, height;
>  	struct vb2_queue	   vb_vidq;
>  	unsigned int		   field_count;
> @@ -660,8 +657,8 @@ static void vivi_thread_tick(struct vivi_dev *dev)
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
> @@ -677,7 +674,8 @@ static void vivi_sleep(struct vivi_dev *dev)
>  		goto stop_task;
>  
>  	/* Calculate time to wake up */
> -	timeout = msecs_to_jiffies(frames_to_ms(1));
> +	timeout = msecs_to_jiffies(frames_to_ms(dev, 1));
> +
>  
>  	vivi_thread_tick(dev);
>  
> @@ -1049,6 +1047,39 @@ static int vidioc_s_input(struct file *file, void *priv, unsigned int i)
>  	return 0;
>  }
>  
> +/* timeperframe is arbitrary and continous */
> +static int vidioc_enum_frameintervals(struct file *file, void *priv,
> +					     struct v4l2_frmivalenum *fival)
> +{
> +	fival->type = V4L2_FRMIVAL_TYPE_CONTINUOUS;
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
> +	return 0;
> +}
> +
> +static int vidioc_s_parm(struct file *file, void *priv, struct v4l2_streamparm *parm)
> +{
> +	struct vivi_dev *dev = video_drvdata(file);
> +
> +	if (parm->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +		return -EINVAL;
> +
> +	dev->timeperframe.numerator	= parm->parm.capture.timeperframe.numerator;
> +	dev->timeperframe.denominator	= parm->parm.capture.timeperframe.denominator ?: 1;
> +
> +	return 0;
> +}
> +
>  /* --- controls ---------------------------------------------- */
>  
>  static int vivi_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
> @@ -1207,6 +1238,9 @@ static const struct v4l2_ioctl_ops vivi_ioctl_ops = {
>  	.vidioc_enum_input    = vidioc_enum_input,
>  	.vidioc_g_input       = vidioc_g_input,
>  	.vidioc_s_input       = vidioc_s_input,
> +	.vidioc_enum_frameintervals = vidioc_enum_frameintervals,
> +	.vidioc_g_parm        = vidioc_g_parm,
> +	.vidioc_s_parm        = vidioc_s_parm,
>  	.vidioc_streamon      = vb2_ioctl_streamon,
>  	.vidioc_streamoff     = vb2_ioctl_streamoff,
>  	.vidioc_log_status    = v4l2_ctrl_log_status,
> @@ -1265,6 +1299,8 @@ static int __init vivi_create_instance(int inst)
>  		goto free_dev;
>  
>  	dev->fmt = &formats[0];
> +	dev->timeperframe.numerator = 1001;
> +	dev->timeperframe.denominator = 30000;
>  	dev->width = 640;
>  	dev->height = 480;
>  	dev->pixelsize = dev->fmt->depth / 8;
> 
