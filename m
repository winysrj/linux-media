Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:58835 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754647Ab0EKJdf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 May 2010 05:33:35 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Tue, 11 May 2010 15:03:30 +0530
Subject: RE: [PATCH 3/6] [RFC] tvp514x: there is only one supported format,
 so simplify the code
Message-ID: <19F8576C6E063C45BE387C64729E7394044E404BD7@dbde02.ent.ti.com>
References: <cover.1273413060.git.hverkuil@xs4all.nl>
 <f18bb1877d73862190f932efdda30e838660bd34.1273413060.git.hverkuil@xs4all.nl>
In-Reply-To: <f18bb1877d73862190f932efdda30e838660bd34.1273413060.git.hverkuil@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> -----Original Message-----
> From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
> Sent: Sunday, May 09, 2010 7:27 PM
> To: linux-media@vger.kernel.org
> Cc: Hiremath, Vaibhav
> Subject: [PATCH 3/6] [RFC] tvp514x: there is only one supported format, so
> simplify the code
> 
> Get rid of unnecessary code since this driver supports only one
> pixel format. Removing this code will make the transition to the
> mbus API easier as well.
> 
> Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
> ---
>  drivers/media/video/tvp514x.c |   45 ++++++++------------------------------
> --
>  1 files changed, 9 insertions(+), 36 deletions(-)
> 
> diff --git a/drivers/media/video/tvp514x.c b/drivers/media/video/tvp514x.c
> index 9d8d5c8..8c1609f 100644
> --- a/drivers/media/video/tvp514x.c
> +++ b/drivers/media/video/tvp514x.c
> @@ -88,8 +88,6 @@ static int tvp514x_s_stream(struct v4l2_subdev *sd, int
> enable);
>   * @ver: Chip version
>   * @streaming: TVP5146/47 decoder streaming - enabled or disabled.
>   * @pix: Current pixel format
> - * @num_fmts: Number of formats
> - * @fmt_list: Format list
>   * @current_std: Current standard
>   * @num_stds: Number of standards
>   * @std_list: Standards list
> @@ -105,8 +103,6 @@ struct tvp514x_decoder {
>  	int streaming;
> 
>  	struct v4l2_pix_format pix;
> -	int num_fmts;
> -	const struct v4l2_fmtdesc *fmt_list;
> 
>  	enum tvp514x_std current_std;
>  	int num_stds;
> @@ -959,27 +955,18 @@ tvp514x_s_ctrl(struct v4l2_subdev *sd, struct
> v4l2_control *ctrl)
>  static int
>  tvp514x_enum_fmt_cap(struct v4l2_subdev *sd, struct v4l2_fmtdesc *fmt)
>  {
> -	struct tvp514x_decoder *decoder = to_decoder(sd);
> -	int index;
> -
> -	if (fmt == NULL)
> -		return -EINVAL;
> -
> -	index = fmt->index;
> -	if ((index >= decoder->num_fmts) || (index < 0))
> -		/* Index out of bound */
> +	if (fmt == NULL || fmt->index)
>  		return -EINVAL;
> 
>  	if (fmt->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
>  		/* only capture is supported */
>  		return -EINVAL;
> 
> -	memcpy(fmt, &decoder->fmt_list[index],
> -		sizeof(struct v4l2_fmtdesc));
> -
> -	v4l2_dbg(1, debug, sd, "Current FMT: index - %d (%s)",
> -			decoder->fmt_list[index].index,
> -			decoder->fmt_list[index].description);
> +	/* only one format */
> +	fmt->flags = 0;
> +	strlcpy(fmt->description, "8-bit UYVY 4:2:2 Format",
> +					sizeof(fmt->description));
> +	fmt->pixelformat = V4L2_PIX_FMT_UYVY;
>  	return 0;
>  }
> 
> @@ -996,7 +983,6 @@ static int
>  tvp514x_try_fmt_cap(struct v4l2_subdev *sd, struct v4l2_format *f)
>  {
>  	struct tvp514x_decoder *decoder = to_decoder(sd);
> -	int ifmt;
>  	struct v4l2_pix_format *pix;
>  	enum tvp514x_std current_std;
> 
> @@ -1012,28 +998,18 @@ tvp514x_try_fmt_cap(struct v4l2_subdev *sd, struct
> v4l2_format *f)
>  	/* Calculate height and width based on current standard */
>  	current_std = decoder->current_std;
> 
> +	pix->pixelformat = V4L2_PIX_FMT_UYVY;
>  	pix->width = decoder->std_list[current_std].width;
>  	pix->height = decoder->std_list[current_std].height;
> -
> -	for (ifmt = 0; ifmt < decoder->num_fmts; ifmt++) {
> -		if (pix->pixelformat ==
> -			decoder->fmt_list[ifmt].pixelformat)
> -			break;
> -	}
> -	if (ifmt == decoder->num_fmts)
> -		/* None of the format matched, select default */
> -		ifmt = 0;
> -	pix->pixelformat = decoder->fmt_list[ifmt].pixelformat;
> -
>  	pix->field = V4L2_FIELD_INTERLACED;
>  	pix->bytesperline = pix->width * 2;
>  	pix->sizeimage = pix->bytesperline * pix->height;
>  	pix->colorspace = V4L2_COLORSPACE_SMPTE170M;
>  	pix->priv = 0;
> 
> -	v4l2_dbg(1, debug, sd, "Try FMT: pixelformat - %s, bytesperline - %d"
> +	v4l2_dbg(1, debug, sd, "Try FMT: bytesperline - %d"
>  			"Width - %d, Height - %d",
> -			decoder->fmt_list[ifmt].description, pix->bytesperline,
> +			pix->bytesperline,
>  			pix->width, pix->height);
>  	return 0;
>  }
> @@ -1253,9 +1229,6 @@ static const struct v4l2_subdev_ops tvp514x_ops = {
>  static struct tvp514x_decoder tvp514x_dev = {
>  	.streaming = 0,
> 
> -	.fmt_list = tvp514x_fmt_list,
> -	.num_fmts = ARRAY_SIZE(tvp514x_fmt_list),
> -
>  	.pix = {
>  		/* Default to NTSC 8-bit YUV 422 */
>  		.width = NTSC_NUM_ACTIVE_PIXELS,
[Hiremath, Vaibhav] 

Reviewed-by: Vaibhav Hiremath <hvaibhav@ti.com>
Tested-by: Vaibhav Hiremath <hvaibhav@ti.com>
Acked-by: Vaibhav Hiremath <hvaibhav@ti.com>


Thanks,
Vaibhav

> --
> 1.6.4.2

