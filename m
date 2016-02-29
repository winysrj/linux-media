Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:51755 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755800AbcB2P2h (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Feb 2016 10:28:37 -0500
Subject: Re: [PATCH] bttv: Width must be a multiple of 16 when capturing
 planar formats
To: Hans de Goede <hdegoede@redhat.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
References: <1454860203-10748-1-git-send-email-hdegoede@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56D4639F.1020109@xs4all.nl>
Date: Mon, 29 Feb 2016 16:28:31 +0100
MIME-Version: 1.0
In-Reply-To: <1454860203-10748-1-git-send-email-hdegoede@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/07/2016 04:50 PM, Hans de Goede wrote:
> On my bttv card "Hauppauge WinTV [card=10]" capturing in YV12 fmt at max
> size results in a solid green rectangle being captured (all colors 0 in
> YUV).
> 
> This turns out to be caused by max-width (924) not being a multiple of 16.
> 
> We've likely never hit this problem before since normally xawtv / tvtime,
> etc. will prefer packed pixel formats. But when using a video card which
> is using xf86-video-modesetting + glamor, only planar XVideo fmts are
> available, and xawtv will chose a matching capture format to avoid needing
> to do conversion, triggering the solid green window problem.
> 
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  drivers/media/pci/bt8xx/bttv-driver.c | 26 ++++++++++++++++++++------
>  1 file changed, 20 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
> index 9400e99..bedbd51 100644
> --- a/drivers/media/pci/bt8xx/bttv-driver.c
> +++ b/drivers/media/pci/bt8xx/bttv-driver.c
> @@ -2334,6 +2334,19 @@ static int bttv_g_fmt_vid_overlay(struct file *file, void *priv,
>  	return 0;
>  }
>  
> +static void bttv_get_width_mask_vid_cap(const struct bttv_format *fmt,
> +					unsigned int *width_mask,
> +					unsigned int *width_bias)
> +{
> +	if (fmt->flags & FORMAT_FLAGS_PLANAR) {
> +		*width_mask = ~15; /* width must be a multiple of 16 pixels */
> +		*width_bias = 8;   /* nearest */
> +	} else {
> +		*width_mask = ~3; /* width must be a multiple of 4 pixels */
> +		*width_bias = 2;  /* nearest */
> +	}
> +}
> +
>  static int bttv_try_fmt_vid_cap(struct file *file, void *priv,
>  						struct v4l2_format *f)
>  {
> @@ -2343,6 +2356,7 @@ static int bttv_try_fmt_vid_cap(struct file *file, void *priv,
>  	enum v4l2_field field;
>  	__s32 width, height;
>  	__s32 height2;
> +	unsigned int width_mask, width_bias;
>  	int rc;
>  
>  	fmt = format_by_fourcc(f->fmt.pix.pixelformat);
> @@ -2375,9 +2389,9 @@ static int bttv_try_fmt_vid_cap(struct file *file, void *priv,
>  	width = f->fmt.pix.width;
>  	height = f->fmt.pix.height;
>  
> +	bttv_get_width_mask_vid_cap(fmt, &width_mask, &width_bias);
>  	rc = limit_scaled_size_lock(fh, &width, &height, field,
> -			       /* width_mask: 4 pixels */ ~3,
> -			       /* width_bias: nearest */ 2,
> +			       width_mask, width_bias,
>  			       /* adjust_size */ 1,
>  			       /* adjust_crop */ 0);
>  	if (0 != rc)
> @@ -2410,6 +2424,7 @@ static int bttv_s_fmt_vid_cap(struct file *file, void *priv,
>  	struct bttv_fh *fh = priv;
>  	struct bttv *btv = fh->btv;
>  	__s32 width, height;
> +	unsigned int width_mask, width_bias;
>  	enum v4l2_field field;
>  
>  	retval = bttv_switch_type(fh, f->type);
> @@ -2424,9 +2439,10 @@ static int bttv_s_fmt_vid_cap(struct file *file, void *priv,
>  	height = f->fmt.pix.height;
>  	field = f->fmt.pix.field;
>  
> +	fmt = format_by_fourcc(f->fmt.pix.pixelformat);
> +	bttv_get_width_mask_vid_cap(fmt, &width_mask, &width_bias);
>  	retval = limit_scaled_size_lock(fh, &width, &height, f->fmt.pix.field,
> -			       /* width_mask: 4 pixels */ ~3,
> -			       /* width_bias: nearest */ 2,
> +			       width_mask, width_bias,
>  			       /* adjust_size */ 1,
>  			       /* adjust_crop */ 1);
>  	if (0 != retval)
> @@ -2434,8 +2450,6 @@ static int bttv_s_fmt_vid_cap(struct file *file, void *priv,
>  
>  	f->fmt.pix.field = field;
>  
> -	fmt = format_by_fourcc(f->fmt.pix.pixelformat);
> -
>  	/* update our state informations */
>  	fh->fmt              = fmt;
>  	fh->cap.field        = f->fmt.pix.field;
> 

