Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:48698 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751462AbbEUF6Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 May 2015 01:58:25 -0400
Message-ID: <555D73FA.3030208@xs4all.nl>
Date: Thu, 21 May 2015 07:58:18 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: William Towle <william.towle@codethink.co.uk>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
CC: g.liakhovetski@gmx.de, sergei.shtylyov@cogentembedded.com,
	rob.taylor@codethink.co.uk
Subject: Re: [PATCH 09/20] media: rcar_vin: Use correct pad number in try_fmt
References: <1432139980-12619-1-git-send-email-william.towle@codethink.co.uk> <1432139980-12619-10-git-send-email-william.towle@codethink.co.uk>
In-Reply-To: <1432139980-12619-10-git-send-email-william.towle@codethink.co.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/20/2015 06:39 PM, William Towle wrote:
> From: Rob Taylor <rob.taylor@codethink.co.uk>
> 
> Fix rcar_vin_try_fmt to use the correct pad number when calling the
> subdev set_fmt. Previously pad number 0 was always used, resulting in
> EINVAL if the subdev cares about the pad number (e.g. ADV7612).
> 
> Signed-off-by: William Towle  Taylor <rob.taylor@codethink.co.uk>
> Reviewed-by: Rob Taylor <rob.taylor@codethink.co.uk>
> ---
>  drivers/media/platform/soc_camera/rcar_vin.c |   29 +++++++++++++++++---------
>  1 file changed, 19 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
> index b4e9b43..571ab20 100644
> --- a/drivers/media/platform/soc_camera/rcar_vin.c
> +++ b/drivers/media/platform/soc_camera/rcar_vin.c
> @@ -1707,12 +1707,13 @@ static int rcar_vin_try_fmt(struct soc_camera_device *icd,
>  	const struct soc_camera_format_xlate *xlate;
>  	struct v4l2_pix_format *pix = &f->fmt.pix;
>  	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
> -	struct v4l2_subdev_pad_config pad_cfg;
> +	struct v4l2_subdev_pad_config pad_cfg[sd->entity.num_pads];

Same problem: this relies on the presence of CONFIG_MEDIA_CONTROLLER.
This array can also get large which is bad when it is on the stack.

Laurent, I remember that you had plans to add an op that would allocate
and initialize this for you. Any progress on that?

Regards,

	Hans

>  	struct v4l2_subdev_format format = {
>  		.which = V4L2_SUBDEV_FORMAT_TRY,
>  	};
>  	struct v4l2_mbus_framefmt *mf = &format.format;
>  	__u32 pixfmt = pix->pixelformat;
> +	struct media_pad *remote_pad;
>  	int width, height;
>  	int ret;
>  
> @@ -1744,17 +1745,24 @@ static int rcar_vin_try_fmt(struct soc_camera_device *icd,
>  	mf->code = xlate->code;
>  	mf->colorspace = pix->colorspace;
>  
> -	ret = v4l2_device_call_until_err(sd->v4l2_dev, soc_camera_grp_id(icd),
> -					 pad, set_fmt, &pad_cfg, &format);
> +	remote_pad = media_entity_remote_pad(
> +				&icd->vdev->entity.pads[0]);
> +	format.pad = remote_pad->index;
> +
> +	ret = v4l2_device_call_until_err(sd->v4l2_dev,
> +					soc_camera_grp_id(icd), pad,
> +					set_fmt, pad_cfg,
> +					&format);
>  	if (ret < 0)
>  		return ret;
>  
> -	/* Adjust only if VIN cannot scale */
> -	if (pix->width > mf->width * 2)
> -		pix->width = mf->width * 2;
> -	if (pix->height > mf->height * 3)
> -		pix->height = mf->height * 3;
> -
> +	/*  In case the driver has adjusted 'fmt' to match the
> +	 *  resolution of the live stream, 'pix' needs to pass this
> +	 *  change out so that the buffer userland creates for the
> +	 *  captured image/video has these dimensions
> +	 */
> +	pix->width = mf->width;
> +	pix->height = mf->height;
>  	pix->field = mf->field;
>  	pix->colorspace = mf->colorspace;
>  
> @@ -1769,9 +1777,10 @@ static int rcar_vin_try_fmt(struct soc_camera_device *icd,
>  			 */
>  			mf->width = VIN_MAX_WIDTH;
>  			mf->height = VIN_MAX_HEIGHT;
> +			format.pad = remote_pad->index;
>  			ret = v4l2_device_call_until_err(sd->v4l2_dev,
>  							 soc_camera_grp_id(icd),
> -							 pad, set_fmt, &pad_cfg,
> +							 pad, set_fmt, pad_cfg,
>  							 &format);
>  			if (ret < 0) {
>  				dev_err(icd->parent,
> 

