Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:40386 "EHLO
        lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752643AbdFVPUC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Jun 2017 11:20:02 -0400
Subject: Re: [PATCH v1 3/5] [media] stm32-dcmi: crop sensor image to match
 user resolution
To: Hugues Fruchet <hugues.fruchet@st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Yannick Fertre <yannick.fertre@st.com>
References: <1498144371-13310-1-git-send-email-hugues.fruchet@st.com>
 <1498144371-13310-4-git-send-email-hugues.fruchet@st.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <ee46bbd4-9343-7060-3c1b-455486eb7a9c@xs4all.nl>
Date: Thu, 22 Jun 2017 17:19:55 +0200
MIME-Version: 1.0
In-Reply-To: <1498144371-13310-4-git-send-email-hugues.fruchet@st.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/22/2017 05:12 PM, Hugues Fruchet wrote:
> Add flexibility on supported resolutions by cropping sensor
> image to fit user resolution format request.
> 
> Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
> ---
>   drivers/media/platform/stm32/stm32-dcmi.c | 54 ++++++++++++++++++++++++++++++-
>   1 file changed, 53 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/stm32/stm32-dcmi.c b/drivers/media/platform/stm32/stm32-dcmi.c
> index 75d53aa..bc5e052 100644
> --- a/drivers/media/platform/stm32/stm32-dcmi.c
> +++ b/drivers/media/platform/stm32/stm32-dcmi.c
> @@ -131,6 +131,8 @@ struct stm32_dcmi {
>   	struct v4l2_async_notifier	notifier;
>   	struct dcmi_graph_entity	entity;
>   	struct v4l2_format		fmt;
> +	struct v4l2_rect		crop;
> +	bool				do_crop;
>   
>   	const struct dcmi_format	**user_formats;
>   	unsigned int			num_user_formats;
> @@ -538,6 +540,27 @@ static int dcmi_start_streaming(struct vb2_queue *vq, unsigned int count)
>   	if (dcmi->bus.flags & V4L2_MBUS_PCLK_SAMPLE_RISING)
>   		val |= CR_PCKPOL;
>   
> +	if (dcmi->do_crop) {
> +		u32 size, start;
> +
> +		/* Crop resolution */
> +		size = ((dcmi->crop.height - 1) << 16) |
> +			((dcmi->crop.width << 1) - 1);
> +		reg_write(dcmi->regs, DCMI_CWSIZE, size);
> +
> +		/* Crop start point */
> +		start = ((dcmi->crop.top) << 16) |
> +			 ((dcmi->crop.left << 1));
> +		reg_write(dcmi->regs, DCMI_CWSTRT, start);
> +
> +		dev_dbg(dcmi->dev, "Cropping to %ux%u@%u:%u\n",
> +			dcmi->crop.width, dcmi->crop.height,
> +			dcmi->crop.left, dcmi->crop.top);
> +
> +		/* Enable crop */
> +		val |= CR_CROP;
> +	};
> +
>   	reg_write(dcmi->regs, DCMI_CR, val);
>   
>   	/* Enable dcmi */
> @@ -707,6 +730,8 @@ static int dcmi_try_fmt(struct stm32_dcmi *dcmi, struct v4l2_format *f,
>   		.which = V4L2_SUBDEV_FORMAT_TRY,
>   	};
>   	int ret;
> +	__u32 width, height;
> +	struct v4l2_mbus_framefmt *mf = &format.format;
>   
>   	dcmi_fmt = find_format_by_fourcc(dcmi, pixfmt->pixelformat);
>   	if (!dcmi_fmt) {
> @@ -724,8 +749,18 @@ static int dcmi_try_fmt(struct stm32_dcmi *dcmi, struct v4l2_format *f,
>   	if (ret < 0)
>   		return ret;
>   
> +	/* Align format on what sensor can do */
> +	width = pixfmt->width;
> +	height = pixfmt->height;
>   	v4l2_fill_pix_format(pixfmt, &format.format);
>   
> +	/* We can do any resolution thanks to crop */
> +	if ((mf->width > width) || (mf->height > height)) {
> +		/* Restore width/height */
> +		pixfmt->width = width;
> +		pixfmt->height = height;
> +	};
> +
>   	pixfmt->field = V4L2_FIELD_NONE;
>   	pixfmt->bytesperline = pixfmt->width * dcmi_fmt->bpp;
>   	pixfmt->sizeimage = pixfmt->bytesperline * pixfmt->height;
> @@ -741,6 +776,8 @@ static int dcmi_set_fmt(struct stm32_dcmi *dcmi, struct v4l2_format *f)
>   	struct v4l2_subdev_format format = {
>   		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
>   	};
> +	struct v4l2_mbus_framefmt *mf = &format.format;
> +	struct v4l2_pix_format *pixfmt = &f->fmt.pix;
>   	const struct dcmi_format *current_fmt;
>   	int ret;
>   
> @@ -748,13 +785,28 @@ static int dcmi_set_fmt(struct stm32_dcmi *dcmi, struct v4l2_format *f)
>   	if (ret)
>   		return ret;
>   
> -	v4l2_fill_mbus_format(&format.format, &f->fmt.pix,
> +	v4l2_fill_mbus_format(&format.format, pixfmt,
>   			      current_fmt->mbus_code);
>   	ret = v4l2_subdev_call(dcmi->entity.subdev, pad,
>   			       set_fmt, NULL, &format);
>   	if (ret < 0)
>   		return ret;
>   
> +	/* Enable crop if sensor resolution is larger than request */
> +	dcmi->do_crop = false;
> +	if ((mf->width > pixfmt->width) || (mf->height > pixfmt->height)) {
> +		dcmi->crop.width = pixfmt->width;
> +		dcmi->crop.height = pixfmt->height;
> +		dcmi->crop.left = (mf->width - pixfmt->width) / 2;
> +		dcmi->crop.top = (mf->height - pixfmt->height) / 2;
> +		dcmi->do_crop = true;

Why not implement the selection API instead? I assume that you can crop from any
region of the sensor, not just the center part.

Regards,

	Hans

> +
> +		dev_dbg(dcmi->dev, "%ux%u cropped to %ux%u@(%u,%u)\n",
> +			mf->width, mf->height,
> +			dcmi->crop.width, dcmi->crop.height,
> +			dcmi->crop.left, dcmi->crop.top);
> +	};
> +
>   	dcmi->fmt = *f;
>   	dcmi->current_fmt = current_fmt;
>   
> 
