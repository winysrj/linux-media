Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:42523 "EHLO
        mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751131AbdBWNxf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 23 Feb 2017 08:53:35 -0500
Subject: Re: [PATCH v5 2/3] [media] s5p-mfc: Set colorspace in
 VIDIO_{G,TRY}_FMT if DEFAULT provided
To: Thibault Saunier <thibault.saunier@osg.samsung.com>,
        linux-kernel@vger.kernel.org
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
        Jeongtae Park <jtp.park@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kamil Debski <kamil@wypas.org>
From: Andrzej Hajda <a.hajda@samsung.com>
Message-id: <d926308d-10c1-f6e9-a023-372ebf35d6de@samsung.com>
Date: Thu, 23 Feb 2017 14:42:04 +0100
MIME-version: 1.0
In-reply-to: <20170221192059.29745-3-thibault.saunier@osg.samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
References: <20170221192059.29745-1-thibault.saunier@osg.samsung.com>
 <CGME20170221192320epcas4p2d8933310c2ba3f5fc0c5dca97c973890@epcas4p2.samsung.com>
 <20170221192059.29745-3-thibault.saunier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 21.02.2017 20:20, Thibault Saunier wrote:
> The media documentation says that the V4L2_COLORSPACE_SMPTE170M colorspace
> should be used for SDTV and V4L2_COLORSPACE_REC709 for HDTV but the driver
> didn't set the colorimetry when userspace provided
> V4L2_COLORSPACE_DEFAULT.
>
> Use 576p display resolution as a threshold to set this as suggested by
> EIA CEA 861B.
>
> Signed-off-by: Thibault Saunier <thibault.saunier@osg.samsung.com>
>
> ---
>
> Changes in v5: None
> Changes in v4:
> - Set the colorspace only if the user passed V4L2_COLORSPACE_DEFAULT, in
>   all other cases just use what userspace provided.
>
> Changes in v3:
> - Do not check values in the g_fmt functions as Andrzej explained in previous review
> - Set colorspace if user passed V4L2_COLORSPACE_DEFAULT in
>
> Changes in v2: None
>
>  drivers/media/platform/s5p-mfc/s5p_mfc_dec.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
>
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> index 367ef8e8dbf0..0976c3e0a5ce 100644
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

Again, it seems much more complicated for decoder, I suppose colorspace
field should be filled according to decoded information from the header
of byte stream. It looks like MFC does not parse  stream header for such
info. So it should be done either by the driver, either by userspace, if
userspace is able to get such info. For example in H.264 this info is
encoded in VUI header [1], I do not know about other codecs. I guess the
best solution for now is to not touch this field unless you can retrieve
this info from MFC.

[1]:
https://github.com/copiousfreetime/mp4parser/blob/master/isoparser/src/main/java/com/googlecode/mp4parser/h264/model/SeqParameterSet.java#L227

Regards
Andrzej

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
> @@ -405,6 +411,14 @@ static int vidioc_try_fmt(struct file *file, void *priv, struct v4l2_format *f)
>  			mfc_err("Unsupported format by this MFC version.\n");
>  			return -EINVAL;
>  		}
> +
> +		if (pix_mp->colorspace == V4L2_COLORSPACE_DEFAULT) {
> +			if (pix_mp->width > 720 &&
> +					pix_mp->height > 576) /* HD */
> +				pix_mp->colorspace = V4L2_COLORSPACE_REC709;
> +			else /* SD */
> +				pix_mp->colorspace = V4L2_COLORSPACE_SMPTE170M;
> +		}
>  	}
>  
>  	return 0;
