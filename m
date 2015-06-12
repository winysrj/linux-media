Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:43868 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754098AbbFLJSu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Jun 2015 05:18:50 -0400
Message-ID: <557AA3ED.7000809@xs4all.nl>
Date: Fri, 12 Jun 2015 11:18:37 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: William Towle <william.towle@codethink.co.uk>,
	linux-media@vger.kernel.org, linux-kernel@lists.codethink.co.uk
CC: guennadi liakhovetski <g.liakhovetski@gmx.de>,
	sergei shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH 11/15] media: soc_camera: soc_scale_crop: Use correct
 pad number in try_fmt
References: <1433340002-1691-1-git-send-email-william.towle@codethink.co.uk> <1433340002-1691-12-git-send-email-william.towle@codethink.co.uk>
In-Reply-To: <1433340002-1691-12-git-send-email-william.towle@codethink.co.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/03/2015 03:59 PM, William Towle wrote:
> From: Rob Taylor <rob.taylor@codethink.co.uk>
> 
> Fix calls to subdev try_fmt to use correct pad. Fixes failures with
> subdevs that care about having the right pad number set.
> 
> Signed-off-by: William Towle <william.towle@codethink.co.uk>
> Reviewed-by: Rob Taylor <rob.taylor@codethink.co.uk>
> ---
>  drivers/media/platform/soc_camera/soc_scale_crop.c |   10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/media/platform/soc_camera/soc_scale_crop.c b/drivers/media/platform/soc_camera/soc_scale_crop.c
> index bda29bc..90e2769 100644
> --- a/drivers/media/platform/soc_camera/soc_scale_crop.c
> +++ b/drivers/media/platform/soc_camera/soc_scale_crop.c
> @@ -225,6 +225,10 @@ static int client_set_fmt(struct soc_camera_device *icd,
>  	bool host_1to1;
>  	int ret;
>  
> +#if defined(CONFIG_MEDIA_CONTROLLER)
> +	format->pad = icd->src_pad_idx;
> +#endif

As mentioned in the review of patch 9 it should be possible to drop the
#if defined() here.

> +
>  	ret = v4l2_device_call_until_err(sd->v4l2_dev,
>  					 soc_camera_grp_id(icd), pad,
>  					 set_fmt, NULL, format);
> @@ -261,10 +265,16 @@ static int client_set_fmt(struct soc_camera_device *icd,
>  	/* width <= max_width && height <= max_height - guaranteed by try_fmt */
>  	while ((width > tmp_w || height > tmp_h) &&
>  	       tmp_w < max_width && tmp_h < max_height) {
> +

Spurious whitespace change.

>  		tmp_w = min(2 * tmp_w, max_width);
>  		tmp_h = min(2 * tmp_h, max_height);
>  		mf->width = tmp_w;
>  		mf->height = tmp_h;
> +
> +#if defined(CONFIG_MEDIA_CONTROLLER)
> +		format->pad = icd->src_pad_idx;
> +#endif

Same as the first comment.

> +
>  		ret = v4l2_device_call_until_err(sd->v4l2_dev,
>  					soc_camera_grp_id(icd), pad,
>  					set_fmt, NULL, format);
> 

Regards,

	Hans
