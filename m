Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:2763 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685Ab2L1PEn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Dec 2012 10:04:43 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Kirill Smelkov <kirr@navytux.spb.ru>
Subject: Re: [PATCH,v2] [media] vivi: Constify structures
Date: Fri, 28 Dec 2012 16:04:24 +0100
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1356535783-24173-1-git-send-email-kirr@navytux.spb.ru> <201212271255.11159.hverkuil@xs4all.nl> <20121228131256.GA2688@mini.zxlink>
In-Reply-To: <20121228131256.GA2688@mini.zxlink>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201212281604.24351.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri December 28 2012 14:12:56 Kirill Smelkov wrote:
> On Thu, Dec 27, 2012 at 12:55:11PM +0100, Hans Verkuil wrote:
> > On Wed December 26 2012 16:29:43 Kirill Smelkov wrote:
> > > Most of *_ops and other structures in vivi.c were already declared const
> > > but some have not. Constify and code/data will take less space:
> > > 
> > >     $ size drivers/media/platform/vivi.o
> > >               text    data     bss     dec     hex filename
> > >     before:  12569     248       8   12825    3219 drivers/media/platform/vivi.o
> > >     after:   12308      20       8   12336    3030 drivers/media/platform/vivi.o
> > > 
> > > i.e. vivi.o is now ~500 bytes less.
> > > 
> > > Signed-off-by: Kirill Smelkov <kirr@navytux.spb.ru>
> > > ---
> > >  drivers/media/platform/vivi.c | 26 +++++++++++++-------------
> > >  1 file changed, 13 insertions(+), 13 deletions(-)
> > > 
> > > diff --git a/drivers/media/platform/vivi.c b/drivers/media/platform/vivi.c
> > > index ec65089..bed04e1 100644
> > > --- a/drivers/media/platform/vivi.c
> > > +++ b/drivers/media/platform/vivi.c
> > > @@ -91,13 +91,13 @@ static const struct v4l2_fract
> > >     ------------------------------------------------------------------*/
> > >  
> > >  struct vivi_fmt {
> > > -	char  *name;
> > > +	const char  *name;
> > 
> > Just use one space before '*' since it no longer lines up to anything.
> 
> [...]
> > > @@ -191,7 +191,7 @@ struct vivi_buffer {
> > >  	/* common v4l buffer stuff -- must be first */
> > >  	struct vb2_buffer	vb;
> > >  	struct list_head	list;
> > > -	struct vivi_fmt        *fmt;
> > > +	struct vivi_fmt const  *fmt;
> > >  };
> > >  
> > >  struct vivi_dmaqueue {
> > > @@ -250,7 +250,7 @@ struct vivi_dev {
> > >  	int			   input;
> > >  
> > >  	/* video capture */
> > > -	struct vivi_fmt            *fmt;
> > > +	struct vivi_fmt const      *fmt;
> > 
> > 'const' should be before 'struct' for consistency reasons.
> 
> It's just a matter of style, and in this case I though putting const
> after would not distract from the fact that fmt is `struct vivi_fmt *`
> and also to align types beginning with non-const ones.
> 
> But anyway, style is style and this is not a big deal, so here you are
> with corrected patch.

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> 
> Thanks,
> Kirill
> 
> ---- 8< ----
> From: Kirill Smelkov <kirr@navytux.spb.ru>
> Date: Wed, 26 Dec 2012 19:23:26 +0400
> Subject: [PATCH,v2] [media] vivi: Constify structures
> 
> Most of *_ops and other structures in vivi.c were already declared const
> but some have not. Constify and code/data will take less space:
> 
>     $ size drivers/media/platform/vivi.o
>               text    data     bss     dec     hex filename
>     before:  12569     248       8   12825    3219 drivers/media/platform/vivi.o
>     after:   12308      20       8   12336    3030 drivers/media/platform/vivi.o
> 
> i.e. vivi.o is now ~500 bytes less.
> 
> Signed-off-by: Kirill Smelkov <kirr@navytux.spb.ru>
> ---
>  drivers/media/platform/vivi.c | 26 +++++++++++++-------------
>  1 file changed, 13 insertions(+), 13 deletions(-)
> 
>  v2:
>     
>     - put 'const' always before anything, as noted by Hans Verkuil.
>     - no changes otherwise.
> 
> 
> diff --git a/drivers/media/platform/vivi.c b/drivers/media/platform/vivi.c
> index ec65089..8a33a71 100644
> --- a/drivers/media/platform/vivi.c
> +++ b/drivers/media/platform/vivi.c
> @@ -91,13 +91,13 @@ static const struct v4l2_fract
>     ------------------------------------------------------------------*/
>  
>  struct vivi_fmt {
> -	char  *name;
> +	const char *name;
>  	u32   fourcc;          /* v4l2 format id */
>  	u8    depth;
>  	bool  is_yuv;
>  };
>  
> -static struct vivi_fmt formats[] = {
> +static const struct vivi_fmt formats[] = {
>  	{
>  		.name     = "4:2:2, packed, YUYV",
>  		.fourcc   = V4L2_PIX_FMT_YUYV,
> @@ -164,9 +164,9 @@ static struct vivi_fmt formats[] = {
>  	},
>  };
>  
> -static struct vivi_fmt *__get_format(u32 pixelformat)
> +static const struct vivi_fmt *__get_format(u32 pixelformat)
>  {
> -	struct vivi_fmt *fmt;
> +	const struct vivi_fmt *fmt;
>  	unsigned int k;
>  
>  	for (k = 0; k < ARRAY_SIZE(formats); k++) {
> @@ -181,7 +181,7 @@ static struct vivi_fmt *__get_format(u32 pixelformat)
>  	return &formats[k];
>  }
>  
> -static struct vivi_fmt *get_format(struct v4l2_format *f)
> +static const struct vivi_fmt *get_format(struct v4l2_format *f)
>  {
>  	return __get_format(f->fmt.pix.pixelformat);
>  }
> @@ -191,7 +191,7 @@ struct vivi_buffer {
>  	/* common v4l buffer stuff -- must be first */
>  	struct vb2_buffer	vb;
>  	struct list_head	list;
> -	struct vivi_fmt        *fmt;
> +	const struct vivi_fmt  *fmt;
>  };
>  
>  struct vivi_dmaqueue {
> @@ -250,7 +250,7 @@ struct vivi_dev {
>  	int			   input;
>  
>  	/* video capture */
> -	struct vivi_fmt            *fmt;
> +	const struct vivi_fmt      *fmt;
>  	struct v4l2_fract          timeperframe;
>  	unsigned int               width, height;
>  	struct vb2_queue	   vb_vidq;
> @@ -297,7 +297,7 @@ struct bar_std {
>  
>  /* Maximum number of bars are 10 - otherwise, the input print code
>     should be modified */
> -static struct bar_std bars[] = {
> +static const struct bar_std bars[] = {
>  	{	/* Standard ITU-R color bar sequence */
>  		{ COLOR_WHITE, COLOR_AMBER, COLOR_CYAN, COLOR_GREEN,
>  		  COLOR_MAGENTA, COLOR_RED, COLOR_BLUE, COLOR_BLACK, COLOR_BLACK }
> @@ -926,7 +926,7 @@ static void vivi_unlock(struct vb2_queue *vq)
>  }
>  
>  
> -static struct vb2_ops vivi_video_qops = {
> +static const struct vb2_ops vivi_video_qops = {
>  	.queue_setup		= queue_setup,
>  	.buf_prepare		= buffer_prepare,
>  	.buf_queue		= buffer_queue,
> @@ -957,7 +957,7 @@ static int vidioc_querycap(struct file *file, void  *priv,
>  static int vidioc_enum_fmt_vid_cap(struct file *file, void  *priv,
>  					struct v4l2_fmtdesc *f)
>  {
> -	struct vivi_fmt *fmt;
> +	const struct vivi_fmt *fmt;
>  
>  	if (f->index >= ARRAY_SIZE(formats))
>  		return -EINVAL;
> @@ -993,7 +993,7 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
>  			struct v4l2_format *f)
>  {
>  	struct vivi_dev *dev = video_drvdata(file);
> -	struct vivi_fmt *fmt;
> +	const struct vivi_fmt *fmt;
>  
>  	fmt = get_format(f);
>  	if (!fmt) {
> @@ -1102,7 +1102,7 @@ static int vidioc_s_input(struct file *file, void *priv, unsigned int i)
>  static int vidioc_enum_frameintervals(struct file *file, void *priv,
>  					     struct v4l2_frmivalenum *fival)
>  {
> -	struct vivi_fmt *fmt;
> +	const struct vivi_fmt *fmt;
>  
>  	if (fival->index)
>  		return -EINVAL;
> @@ -1330,7 +1330,7 @@ static const struct v4l2_ioctl_ops vivi_ioctl_ops = {
>  	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
>  };
>  
> -static struct video_device vivi_template = {
> +static const struct video_device vivi_template = {
>  	.name		= "vivi",
>  	.fops           = &vivi_fops,
>  	.ioctl_ops 	= &vivi_ioctl_ops,
> 
