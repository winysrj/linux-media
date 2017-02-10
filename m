Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:48264 "EHLO
        lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751134AbdBJPLv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Feb 2017 10:11:51 -0500
Subject: Re: [PATCH v3 3/4] [media] s5p-mfc: Set colorspace in
 VIDIO_{G,TRY}_FMT
To: Thibault Saunier <thibault.saunier@osg.samsung.com>,
        linux-kernel@vger.kernel.org
References: <20170210141022.25412-1-thibault.saunier@osg.samsung.com>
 <20170210141022.25412-4-thibault.saunier@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kukjin Kim <kgene@kernel.org>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Andi Shyti <andi.shyti@samsung.com>,
        linux-media@vger.kernel.org, Shuah Khan <shuahkh@osg.samsung.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Inki Dae <inki.dae@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Jeongtae Park <jtp.park@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kamil Debski <kamil@wypas.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <4b0714cf-d875-022c-eb73-1556568c0a51@xs4all.nl>
Date: Fri, 10 Feb 2017 16:10:11 +0100
MIME-Version: 1.0
In-Reply-To: <20170210141022.25412-4-thibault.saunier@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/10/2017 03:10 PM, Thibault Saunier wrote:
> The media documentation says that the V4L2_COLORSPACE_SMPTE170M colorspace
> should be used for SDTV and V4L2_COLORSPACE_REC709 for HDTV but the driver
> didn't set the colorimetry, also respect usespace setting.
> 
> Use 576p display resolution as a threshold to set this.
> 
> Signed-off-by: Thibault Saunier <thibault.saunier@osg.samsung.com>
> 
> ---
> 
> Changes in v3:
> - Do not check values in the g_fmt functions as Andrzej explained in previous review
> - Set colorspace if user passed V4L2_COLORSPACE_DEFAULT in
> 
> Changes in v2: None
> 
>  drivers/media/platform/s5p-mfc/s5p_mfc_dec.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> index 367ef8e8dbf0..16bc3eaad0ff 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> @@ -354,6 +354,11 @@ static int vidioc_g_fmt(struct file *file, void *priv, struct v4l2_format *f)
>  		pix_mp->plane_fmt[0].sizeimage = ctx->luma_size;
>  		pix_mp->plane_fmt[1].bytesperline = ctx->buf_width;
>  		pix_mp->plane_fmt[1].sizeimage = ctx->chroma_size;
> +
> +		if (pix_mp->width > 720 && pix_mp->height > 576) /* HD */
> +			pix_mp->colorspace = V4L2_COLORSPACE_REC709;
> +		else /* SD */
> +			pix_mp->colorspace = V4L2_COLORSPACE_SMPTE170M;
>  	} else if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
>  		/* This is run on OUTPUT
>  		   The buffer contains compressed image
> @@ -378,6 +383,7 @@ static int vidioc_g_fmt(struct file *file, void *priv, struct v4l2_format *f)
>  static int vidioc_try_fmt(struct file *file, void *priv, struct v4l2_format *f)
>  {
>  	struct s5p_mfc_dev *dev = video_drvdata(file);
> +	struct v4l2_pix_format_mplane *pix_mp = &f->fmt.pix_mp;
>  	struct s5p_mfc_fmt *fmt;
>  
>  	mfc_debug(2, "Type is %d\n", f->type);
> @@ -405,6 +411,15 @@ static int vidioc_try_fmt(struct file *file, void *priv, struct v4l2_format *f)
>  			mfc_err("Unsupported format by this MFC version.\n");
>  			return -EINVAL;
>  		}
> +
> +		if (pix_mp->colorspace != V4L2_COLORSPACE_REC709 &&
> +			pix_mp->colorspace != V4L2_COLORSPACE_SMPTE170M) {
> +			if (pix_mp->width > 720 &&
> +					pix_mp->height > 576) /* HD */
> +				pix_mp->colorspace = V4L2_COLORSPACE_REC709;
> +			else /* SD */
> +				pix_mp->colorspace = V4L2_COLORSPACE_SMPTE170M;
> +		}
>  	}
>  
>  	return 0;
> 

Same here: it is an mem2mem device, so it just preserves whatever colorspace the
application passes in.

Just look at what several other mem2mem device drivers do.

Regards,

	Hans
