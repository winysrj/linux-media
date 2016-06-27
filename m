Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:42991 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751664AbcF0J26 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jun 2016 05:28:58 -0400
Subject: Re: [PATCH v4 5/8] media: rcar-vin: add DV timings support
To: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>,
	hans.verkuil@cisco.com, niklas.soderlund@ragnatech.se
References: <1462975376-491-1-git-send-email-ulrich.hecht+renesas@gmail.com>
 <1462975376-491-6-git-send-email-ulrich.hecht+renesas@gmail.com>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	magnus.damm@gmail.com, laurent.pinchart@ideasonboard.com,
	ian.molton@codethink.co.uk, lars@metafoo.de,
	william.towle@codethink.co.uk
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5af387b3-76ac-9007-71b1-bf694c78fcb3@xs4all.nl>
Date: Mon, 27 Jun 2016 11:28:52 +0200
MIME-Version: 1.0
In-Reply-To: <1462975376-491-6-git-send-email-ulrich.hecht+renesas@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/11/2016 04:02 PM, Ulrich Hecht wrote:
> Adds ioctls DV_TIMINGS_CAP, ENUM_DV_TIMINGS, G_DV_TIMINGS, S_DV_TIMINGS,
> and QUERY_DV_TIMINGS.
> 
> Signed-off-by: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  drivers/media/platform/rcar-vin/rcar-v4l2.c | 82 +++++++++++++++++++++++++++++
>  1 file changed, 82 insertions(+)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> index 3788f8a..10a5c10 100644
> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> @@ -400,6 +400,10 @@ static int rvin_enum_input(struct file *file, void *priv,
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
> @@ -478,6 +482,78 @@ static int rvin_subscribe_event(struct v4l2_fh *fh,
>  	return v4l2_ctrl_subscribe_event(fh, sub);
>  }
>  
> +static int rvin_enum_dv_timings(struct file *file, void *priv_fh,
> +				    struct v4l2_enum_dv_timings *timings)
> +{
> +	struct rvin_dev *vin = video_drvdata(file);
> +	struct v4l2_subdev *sd = vin_to_source(vin);
> +	int pad, ret;
> +
> +	pad = timings->pad;
> +	timings->pad = vin->src_pad_idx;
> +
> +	ret = v4l2_subdev_call(sd, pad, enum_dv_timings, timings);
> +
> +	timings->pad = pad;
> +
> +	return ret;
> +}
> +
> +static int rvin_s_dv_timings(struct file *file, void *priv_fh,
> +				    struct v4l2_dv_timings *timings)
> +{
> +	struct rvin_dev *vin = video_drvdata(file);
> +	struct v4l2_subdev *sd = vin_to_source(vin);
> +	int err;
> +
> +	err = v4l2_subdev_call(sd,
> +			video, s_dv_timings, timings);
> +	if (!err) {
> +		vin->source.width = timings->bt.width;
> +		vin->source.height = timings->bt.height;
> +		vin->format.width = timings->bt.width;
> +		vin->format.height = timings->bt.height;
> +	}
> +	return err;
> +}
> +
> +static int rvin_g_dv_timings(struct file *file, void *priv_fh,
> +				    struct v4l2_dv_timings *timings)
> +{
> +	struct rvin_dev *vin = video_drvdata(file);
> +	struct v4l2_subdev *sd = vin_to_source(vin);
> +
> +	return v4l2_subdev_call(sd,
> +			video, g_dv_timings, timings);
> +}
> +
> +static int rvin_query_dv_timings(struct file *file, void *priv_fh,
> +				    struct v4l2_dv_timings *timings)
> +{
> +	struct rvin_dev *vin = video_drvdata(file);
> +	struct v4l2_subdev *sd = vin_to_source(vin);
> +
> +	return v4l2_subdev_call(sd,
> +			video, query_dv_timings, timings);
> +}
> +
> +static int rvin_dv_timings_cap(struct file *file, void *priv_fh,
> +				    struct v4l2_dv_timings_cap *cap)
> +{
> +	struct rvin_dev *vin = video_drvdata(file);
> +	struct v4l2_subdev *sd = vin_to_source(vin);
> +	int pad, ret;
> +
> +	pad = cap->pad;
> +	cap->pad = vin->src_pad_idx;
> +
> +	ret = v4l2_subdev_call(sd, pad, dv_timings_cap, cap);
> +
> +	cap->pad = pad;
> +
> +	return ret;
> +}
> +
>  static const struct v4l2_ioctl_ops rvin_ioctl_ops = {
>  	.vidioc_querycap		= rvin_querycap,
>  	.vidioc_try_fmt_vid_cap		= rvin_try_fmt_vid_cap,
> @@ -494,6 +570,12 @@ static const struct v4l2_ioctl_ops rvin_ioctl_ops = {
>  	.vidioc_g_input			= rvin_g_input,
>  	.vidioc_s_input			= rvin_s_input,
>  
> +	.vidioc_dv_timings_cap		= rvin_dv_timings_cap,
> +	.vidioc_enum_dv_timings		= rvin_enum_dv_timings,
> +	.vidioc_g_dv_timings		= rvin_g_dv_timings,
> +	.vidioc_s_dv_timings		= rvin_s_dv_timings,
> +	.vidioc_query_dv_timings	= rvin_query_dv_timings,
> +
>  	.vidioc_querystd		= rvin_querystd,
>  	.vidioc_g_std			= rvin_g_std,
>  	.vidioc_s_std			= rvin_s_std,
> 
