Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:54860 "EHLO
        mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751846AbdBUKT0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Feb 2017 05:19:26 -0500
Subject: Re: [PATCH v4 4/4] [media] s5p-mfc: Check and set
 'v4l2_pix_format:field' field in try_fmt
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
Message-id: <b5d7571f-7564-bf41-f2b8-e75fc1036d40@samsung.com>
Date: Tue, 21 Feb 2017 11:19:10 +0100
MIME-version: 1.0
In-reply-to: <20170213190836.26972-5-thibault.saunier@osg.samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
References: <20170213190836.26972-1-thibault.saunier@osg.samsung.com>
 <CGME20170213190920epcas2p4fb3f3c683f559cc2d5d9606130d85b55@epcas2p4.samsung.com>
 <20170213190836.26972-5-thibault.saunier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 13.02.2017 20:08, Thibault Saunier wrote:
> It is required by the standard that the field order is set by the
> driver.
>
> Signed-off-by: Thibault Saunier <thibault.saunier@osg.samsung.com>
>
> ---
>
> Changes in v4: None
> Changes in v3:
> - Do not check values in the g_fmt functions as Andrzej explained in previous review
>
> Changes in v2:
> - Fix a silly build error that slipped in while rebasing the patches
>
>  drivers/media/platform/s5p-mfc/s5p_mfc_dec.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
>
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> index 0976c3e0a5ce..c954b34cb988 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> @@ -385,6 +385,20 @@ static int vidioc_try_fmt(struct file *file, void *priv, struct v4l2_format *f)
>  	struct s5p_mfc_dev *dev = video_drvdata(file);
>  	struct v4l2_pix_format_mplane *pix_mp = &f->fmt.pix_mp;
>  	struct s5p_mfc_fmt *fmt;
> +	enum v4l2_field field;
> +
> +	field = f->fmt.pix.field;
> +	if (field == V4L2_FIELD_ANY) {
> +		field = V4L2_FIELD_NONE;
> +	} else if (field != V4L2_FIELD_NONE) {
> +		mfc_debug(2, "Not supported field order(%d)\n", pix_mp->field);
> +		return -EINVAL;
> +	}
> +
> +	/* V4L2 specification suggests the driver corrects the format struct
> +	 * if any of the dimensions is unsupported
> +	 */
> +	f->fmt.pix.field = field;

It looks like you missed my previous comment.
--
Regards
Andrzej

>  
>  	mfc_debug(2, "Type is %d\n", f->type);
>  	if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
