Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:65476 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750990AbdBJHJc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Feb 2017 02:09:32 -0500
Subject: Re: [PATCH v2 4/4] [media] s5p-mfc: Always check and set
 'v4l2_pix_format:field' field
To: Thibault Saunier <thibault.saunier@osg.samsung.com>,
        linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Andi Shyti <andi.shyti@samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Inki Dae <inki.dae@samsung.com>,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kukjin Kim <kgene@kernel.org>,
        linux-samsung-soc@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        linux-media@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Ulf Hansson <ulf.hansson@linaro.org>
From: Andrzej Hajda <a.hajda@samsung.com>
Message-id: <828ec5c5-fddd-f3d1-264e-41adb2d8a69f@samsung.com>
Date: Fri, 10 Feb 2017 08:08:04 +0100
MIME-version: 1.0
In-reply-to: <20170209200420.3046-5-thibault.saunier@osg.samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
References: <20170209200420.3046-1-thibault.saunier@osg.samsung.com>
 <CGME20170209200606epcas2p2ba463850690a45b526b7b6d496545039@epcas2p2.samsung.com>
 <20170209200420.3046-5-thibault.saunier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09.02.2017 21:04, Thibault Saunier wrote:
> It is required by the standard that the field order is set by the
> driver.
>
> Signed-off-by: Thibault Saunier <thibault.saunier@osg.samsung.com>
> ---
>  drivers/media/platform/s5p-mfc/s5p_mfc_dec.c | 23 +++++++++++++++++++++--
>  1 file changed, 21 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> index 960d6c7052bd..309b0a1bbca5 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> @@ -345,7 +345,6 @@ static int vidioc_g_fmt(struct file *file, void *priv, struct v4l2_format *f)
>  		   rectangle. */
>  		pix_mp->width = ctx->buf_width;
>  		pix_mp->height = ctx->buf_height;
> -		pix_mp->field = V4L2_FIELD_NONE;
>  		pix_mp->num_planes = 2;
>  		/* Set pixelformat to the format in which MFC
>  		   outputs the decoded frame */
> @@ -369,7 +368,6 @@ static int vidioc_g_fmt(struct file *file, void *priv, struct v4l2_format *f)
>  		   so width and height have no meaning */
>  		pix_mp->width = 0;
>  		pix_mp->height = 0;
> -		pix_mp->field = V4L2_FIELD_NONE;
>  		pix_mp->plane_fmt[0].bytesperline = ctx->dec_src_buf_size;
>  		pix_mp->plane_fmt[0].sizeimage = ctx->dec_src_buf_size;
>  		pix_mp->pixelformat = ctx->src_fmt->fourcc;
> @@ -379,6 +377,14 @@ static int vidioc_g_fmt(struct file *file, void *priv, struct v4l2_format *f)
>  		mfc_debug(2, "%s-- with error\n", __func__);
>  		return -EINVAL;
>  	}
> +
> +	if (pix_mp->field == V4L2_FIELD_ANY) {
> +		pix_mp->field = V4L2_FIELD_NONE;
> +	} else if (pix_mp->field != V4L2_FIELD_NONE) {
> +		mfc_err("Not supported field order(%d)\n", pix_mp->field);
> +		return -EINVAL;
> +	}
> +

Again in g_fmt you should not check current value of the field.

>  	mfc_debug_leave();
>  	return 0;
>  }
> @@ -389,6 +395,19 @@ static int vidioc_try_fmt(struct file *file, void *priv, struct v4l2_format *f)
>  	struct s5p_mfc_dev *dev = video_drvdata(file);
>  	struct v4l2_pix_format_mplane *pix_mp = &f->fmt.pix_mp;
>  	struct s5p_mfc_fmt *fmt;
> +	enum v4l2_field field;
> +
> +	field = f->fmt.pix.field;
> +	if (field == V4L2_FIELD_ANY) {
> +		field = V4L2_FIELD_NONE;
> +	} else if (V4L2_FIELD_NONE != field) {
> +		mfc_debug(2, "Not supported field order(%d)\n", pix_mp->field);
> +		return -EINVAL;
> +	}
> +
> +	/* V4L2 specification suggests the driver corrects the format struct
> +	 * if any of the dimensions is unsupported */
> +	f->fmt.pix.field = field;

According to docs [1], you should just adjust the field.

[1]:
http://hverkuil.home.xs4all.nl/spec/uapi/v4l/vidioc-g-fmt.html?highlight=g_fmt#c.VIDIOC_G_FMT

Regards
Andrzej

>  
>  	mfc_debug(2, "Type is %d\n", f->type);
>  	if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {


