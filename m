Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:62169 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752168AbbFTLqD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Jun 2015 07:46:03 -0400
Date: Sat, 20 Jun 2015 13:45:58 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: William Towle <william.towle@codethink.co.uk>
cc: linux-media@vger.kernel.org, linux-kernel@lists.codethink.co.uk,
	sergei shtylyov <sergei.shtylyov@cogentembedded.com>,
	hans verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH 11/15] media: soc_camera: soc_scale_crop: Use correct
 pad number in try_fmt
In-Reply-To: <1433340002-1691-12-git-send-email-william.towle@codethink.co.uk>
Message-ID: <Pine.LNX.4.64.1506201345160.31977@axis700.grange>
References: <1433340002-1691-1-git-send-email-william.towle@codethink.co.uk>
 <1433340002-1691-12-git-send-email-william.towle@codethink.co.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 3 Jun 2015, William Towle wrote:

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
> +
>  	ret = v4l2_device_call_until_err(sd->v4l2_dev,
>  					 soc_camera_grp_id(icd), pad,
>  					 set_fmt, NULL, format);
> @@ -261,10 +265,16 @@ static int client_set_fmt(struct soc_camera_device *icd,
>  	/* width <= max_width && height <= max_height - guaranteed by try_fmt */
>  	while ((width > tmp_w || height > tmp_h) &&
>  	       tmp_w < max_width && tmp_h < max_height) {
> +
>  		tmp_w = min(2 * tmp_w, max_width);
>  		tmp_h = min(2 * tmp_h, max_height);
>  		mf->width = tmp_w;
>  		mf->height = tmp_h;
> +
> +#if defined(CONFIG_MEDIA_CONTROLLER)
> +		format->pad = icd->src_pad_idx;

BTW, can format->pad be changed by subdev's .set_fmt()? Do you really have 
to set it in a loop?

Thanks
Guennadi

> +#endif
> +
>  		ret = v4l2_device_call_until_err(sd->v4l2_dev,
>  					soc_camera_grp_id(icd), pad,
>  					set_fmt, NULL, format);
> -- 
> 1.7.10.4
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
