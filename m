Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:60738 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753241AbcDVOID (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Apr 2016 10:08:03 -0400
Subject: Re: [PATCH v3 5/7] media: rcar-vin: add DV timings support
To: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>,
	hans.verkuil@cisco.com, niklas.soderlund@ragnatech.se
References: <1460650670-20849-1-git-send-email-ulrich.hecht+renesas@gmail.com>
 <1460650670-20849-6-git-send-email-ulrich.hecht+renesas@gmail.com>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	magnus.damm@gmail.com, laurent.pinchart@ideasonboard.com,
	ian.molton@codethink.co.uk, lars@metafoo.de,
	william.towle@codethink.co.uk
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <571A303D.3040700@xs4all.nl>
Date: Fri, 22 Apr 2016 16:07:57 +0200
MIME-Version: 1.0
In-Reply-To: <1460650670-20849-6-git-send-email-ulrich.hecht+renesas@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/14/2016 06:17 PM, Ulrich Hecht wrote:
> Adds ioctls DV_TIMINGS_CAP, ENUM_DV_TIMINGS, G_DV_TIMINGS, S_DV_TIMINGS,
> and QUERY_DV_TIMINGS.
> 
> Signed-off-by: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
> ---
>  drivers/media/platform/rcar-vin/rcar-v4l2.c | 69 +++++++++++++++++++++++++++++
>  1 file changed, 69 insertions(+)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> index d8d5f3a..ba2ed4e 100644
> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> @@ -413,12 +413,17 @@ static int rvin_enum_input(struct file *file, void *priv,
>  			   struct v4l2_input *i)
>  {
>  	struct rvin_dev *vin = video_drvdata(file);
> +	struct v4l2_subdev *sd = vin_to_sd(vin);
>  
>  	if (i->index != 0)
>  		return -EINVAL;
>  
>  	i->type = V4L2_INPUT_TYPE_CAMERA;
>  	i->std = vin->vdev.tvnorms;
> +
> +	if (v4l2_subdev_has_op(sd, pad, dv_timings_cap))
> +		i->capabilities = V4L2_IN_CAP_DV_TIMINGS;
> +
>  	strlcpy(i->name, "Camera", sizeof(i->name));
>  
>  	return 0;
> @@ -461,6 +466,64 @@ static int rvin_g_std(struct file *file, void *priv, v4l2_std_id *a)
>  	return v4l2_subdev_call(sd, video, g_std, a);
>  }
>  
> +static int rvin_enum_dv_timings(struct file *file, void *priv_fh,
> +				    struct v4l2_enum_dv_timings *timings)
> +{
> +	struct rvin_dev *vin = video_drvdata(file);
> +	struct v4l2_subdev *sd = vin_to_sd(vin);
> +
> +	timings->pad = 0;
> +	return v4l2_subdev_call(sd,
> +			pad, enum_dv_timings, timings);
> +}
> +
> +static int rvin_s_dv_timings(struct file *file, void *priv_fh,
> +				    struct v4l2_dv_timings *timings)
> +{
> +	struct rvin_dev *vin = video_drvdata(file);
> +	struct v4l2_subdev *sd = vin_to_sd(vin);
> +	int err;
> +
> +	err = v4l2_subdev_call(sd,
> +			video, s_dv_timings, timings);
> +	if (!err) {
> +		vin->sensor.width = timings->bt.width;
> +		vin->sensor.height = timings->bt.height;

This updates the sensor w and h, but it should do the same with
vin->format.width and height.

Regards,

	Hans

