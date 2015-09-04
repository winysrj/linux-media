Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:33970 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933081AbbIDNZO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Sep 2015 09:25:14 -0400
Message-ID: <55E99B7C.3030908@xs4all.nl>
Date: Fri, 04 Sep 2015 15:24:12 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Prashant Laddha <prladdha@cisco.com>, linux-media@vger.kernel.org
CC: Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH 2/2] vivid: add support for reduced fps in video capture
References: <1440338951-23748-1-git-send-email-prladdha@cisco.com> <1440338951-23748-3-git-send-email-prladdha@cisco.com>
In-Reply-To: <1440338951-23748-3-git-send-email-prladdha@cisco.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/23/2015 04:09 PM, Prashant Laddha wrote:
> With this patch, vivid capture thread can now generate reduced
> fps by factor of 1000 / 1001. This is controlled using a boolean
> VIVID_CID_REDUCED_FPS added in vivid control. For reduced fps,
> capture time is controlled by scaling down timeperframe_vid_cap
> with a factor of 1000 / 1001 if VIVID_CID_REDUCED_FPS is true.
> 
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Signed-off-by: Prashant Laddha <prladdha@cisco.com>
> ---
>  drivers/media/platform/vivid/vivid-core.h    |  1 +
>  drivers/media/platform/vivid/vivid-ctrls.c   | 15 +++++++++++++++
>  drivers/media/platform/vivid/vivid-vid-cap.c |  7 ++++++-
>  3 files changed, 22 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/vivid/vivid-core.h b/drivers/media/platform/vivid/vivid-core.h
> index c72349c..4a2c8b7 100644
> --- a/drivers/media/platform/vivid/vivid-core.h
> +++ b/drivers/media/platform/vivid/vivid-core.h
> @@ -263,6 +263,7 @@ struct vivid_dev {
>  	bool				vflip;
>  	bool				vbi_cap_interlaced;
>  	bool				loop_video;
> +	bool				reduced_fps;
>  
>  	/* Framebuffer */
>  	unsigned long			video_pbase;
> diff --git a/drivers/media/platform/vivid/vivid-ctrls.c b/drivers/media/platform/vivid/vivid-ctrls.c
> index 339c8b7..6becdfe 100644
> --- a/drivers/media/platform/vivid/vivid-ctrls.c
> +++ b/drivers/media/platform/vivid/vivid-ctrls.c
> @@ -78,6 +78,7 @@
>  #define VIVID_CID_TIME_WRAP		(VIVID_CID_VIVID_BASE + 39)
>  #define VIVID_CID_MAX_EDID_BLOCKS	(VIVID_CID_VIVID_BASE + 40)
>  #define VIVID_CID_PERCENTAGE_FILL	(VIVID_CID_VIVID_BASE + 41)
> +#define VIVID_CID_REDUCED_FPS		(VIVID_CID_VIVID_BASE + 42)
>  
>  #define VIVID_CID_STD_SIGNAL_MODE	(VIVID_CID_VIVID_BASE + 60)
>  #define VIVID_CID_STANDARD		(VIVID_CID_VIVID_BASE + 61)
> @@ -422,6 +423,10 @@ static int vivid_vid_cap_s_ctrl(struct v4l2_ctrl *ctrl)
>  		dev->sensor_vflip = ctrl->val;
>  		tpg_s_vflip(&dev->tpg, dev->sensor_vflip ^ dev->vflip);
>  		break;
> +	case VIVID_CID_REDUCED_FPS:
> +		dev->reduced_fps = ctrl->val;
> +		vivid_update_format_cap(dev, true);
> +		break;
>  	case VIVID_CID_HAS_CROP_CAP:
>  		dev->has_crop_cap = ctrl->val;
>  		vivid_update_format_cap(dev, true);
> @@ -599,6 +604,15 @@ static const struct v4l2_ctrl_config vivid_ctrl_vflip = {
>  	.step = 1,
>  };
>  
> +static const struct v4l2_ctrl_config vivid_ctrl_reduced_fps = {
> +	.ops = &vivid_vid_cap_ctrl_ops,
> +	.id = VIVID_CID_REDUCED_FPS,
> +	.name = "Reduced fps",

I think "Reduced Framerate" is a better description.

> +	.type = V4L2_CTRL_TYPE_BOOLEAN,
> +	.max = 1,
> +	.step = 1,
> +};
> +
>  static const struct v4l2_ctrl_config vivid_ctrl_has_crop_cap = {
>  	.ops = &vivid_vid_cap_ctrl_ops,
>  	.id = VIVID_CID_HAS_CROP_CAP,
> @@ -1379,6 +1393,7 @@ int vivid_create_controls(struct vivid_dev *dev, bool show_ccs_cap,
>  		v4l2_ctrl_new_custom(hdl_vid_cap, &vivid_ctrl_vflip, NULL);
>  		v4l2_ctrl_new_custom(hdl_vid_cap, &vivid_ctrl_insert_sav, NULL);
>  		v4l2_ctrl_new_custom(hdl_vid_cap, &vivid_ctrl_insert_eav, NULL);
> +		v4l2_ctrl_new_custom(hdl_vid_cap, &vivid_ctrl_reduced_fps, NULL);
>  		if (show_ccs_cap) {
>  			dev->ctrl_has_crop_cap = v4l2_ctrl_new_custom(hdl_vid_cap,
>  				&vivid_ctrl_has_crop_cap, NULL);
> diff --git a/drivers/media/platform/vivid/vivid-vid-cap.c b/drivers/media/platform/vivid/vivid-vid-cap.c
> index ed0b878..2b26059 100644
> --- a/drivers/media/platform/vivid/vivid-vid-cap.c
> +++ b/drivers/media/platform/vivid/vivid-vid-cap.c
> @@ -401,6 +401,7 @@ void vivid_update_format_cap(struct vivid_dev *dev, bool keep_controls)
>  {
>  	struct v4l2_bt_timings *bt = &dev->dv_timings_cap.bt;
>  	unsigned size;
> +	u64 pixelclock;
>  
>  	switch (dev->input_type[dev->input]) {
>  	case WEBCAM:
> @@ -430,8 +431,12 @@ void vivid_update_format_cap(struct vivid_dev *dev, bool keep_controls)
>  		dev->src_rect.width = bt->width;
>  		dev->src_rect.height = bt->height;
>  		size = V4L2_DV_BT_FRAME_WIDTH(bt) * V4L2_DV_BT_FRAME_HEIGHT(bt);
> +		if (dev->reduced_fps)

This needs a check similar to reduce_fps() in patch 1/2. Except for the fact
that the bt->flags & V4L2_DV_FL_REDUCED_FPS check is invalid for receivers.
Perhaps that check should be moved out of reduce_fps() so that that function
can be shared between capture and output.

The reduced_fps flag should only be honored for timings that allow it.

> +			pixelclock = div_u64((bt->pixelclock * 1000), 1001);

No parenthesis needed around bt->pixelclock * 1000.

> +		else
> +			pixelclock = bt->pixelclock;
>  		dev->timeperframe_vid_cap = (struct v4l2_fract) {
> -			size / 100, (u32)bt->pixelclock / 100
> +			size / 100, (u32)pixelclock / 100
>  		};
>  		if (bt->interlaced)
>  			dev->field_cap = V4L2_FIELD_ALTERNATE;
> 

Regards,

	Hans
