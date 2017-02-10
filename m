Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:12472 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751058AbdBJHDf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Feb 2017 02:03:35 -0500
Subject: Re: [PATCH v2 3/4] [media] s5p-mfc: Set colorspace in VIDIO_{G,TRY}_FMT
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
Message-id: <2831b146-fbed-855e-4fc5-635bc729ba31@samsung.com>
Date: Fri, 10 Feb 2017 08:03:28 +0100
MIME-version: 1.0
In-reply-to: <20170209200420.3046-4-thibault.saunier@osg.samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
References: <20170209200420.3046-1-thibault.saunier@osg.samsung.com>
 <CGME20170209200635epcas1p3cb8a6feb2a96285876f92157f72f17a6@epcas1p3.samsung.com>
 <20170209200420.3046-4-thibault.saunier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09.02.2017 21:04, Thibault Saunier wrote:
> The media documentation says that the V4L2_COLORSPACE_SMPTE170M colorspace
> should be used for SDTV and V4L2_COLORSPACE_REC709 for HDTV but the driver
> didn't set the colorimetry, also respect usespace setting.
>
> Use 576p display resolution as a threshold to set this.
>
> Signed-off-by: Thibault Saunier <thibault.saunier@osg.samsung.com>
> ---
>  drivers/media/platform/s5p-mfc/s5p_mfc_dec.c | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
>
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> index 367ef8e8dbf0..960d6c7052bd 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> @@ -354,6 +354,15 @@ static int vidioc_g_fmt(struct file *file, void *priv, struct v4l2_format *f)
>  		pix_mp->plane_fmt[0].sizeimage = ctx->luma_size;
>  		pix_mp->plane_fmt[1].bytesperline = ctx->buf_width;
>  		pix_mp->plane_fmt[1].sizeimage = ctx->chroma_size;
> +
> +		if (pix_mp->colorspace != V4L2_COLORSPACE_REC709 &&
> +			pix_mp->colorspace != V4L2_COLORSPACE_SMPTE170M &&
> +			pix_mp->colorspace != V4L2_COLORSPACE_DEFAULT) {
> +		  if (pix_mp->width > 720 && pix_mp->height > 576) /* HD */
> +			pix_mp->colorspace = V4L2_COLORSPACE_REC709;
> +		  else /* SD */
> +			pix_mp->colorspace = V4L2_COLORSPACE_SMPTE170M;
> +		}

Again, in g_fmt you should not check values of fields you have to fill.


Regards
Andrzej

>  	} else if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
>  		/* This is run on OUTPUT
>  		   The buffer contains compressed image
> @@ -378,6 +387,7 @@ static int vidioc_g_fmt(struct file *file, void *priv, struct v4l2_format *f)
>  static int vidioc_try_fmt(struct file *file, void *priv, struct v4l2_format *f)
>  {
>  	struct s5p_mfc_dev *dev = video_drvdata(file);
> +	struct v4l2_pix_format_mplane *pix_mp = &f->fmt.pix_mp;
>  	struct s5p_mfc_fmt *fmt;
>  
>  	mfc_debug(2, "Type is %d\n", f->type);
> @@ -405,6 +415,15 @@ static int vidioc_try_fmt(struct file *file, void *priv, struct v4l2_format *f)
>  			mfc_err("Unsupported format by this MFC version.\n");
>  			return -EINVAL;
>  		}
> +
> +		if (pix_mp->colorspace != V4L2_COLORSPACE_REC709 &&
> +			pix_mp->colorspace != V4L2_COLORSPACE_SMPTE170M &&
> +			pix_mp->colorspace != V4L2_COLORSPACE_DEFAULT) {
> +		  if (pix_mp->width > 720 && pix_mp->height > 576) /* HD */
> +			pix_mp->colorspace = V4L2_COLORSPACE_REC709;
> +		  else /* SD */
> +			pix_mp->colorspace = V4L2_COLORSPACE_SMPTE170M;
> +		}
>  	}
>  
>  	return 0;


