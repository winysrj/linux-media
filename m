Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:45656 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759083AbbIDNGC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Sep 2015 09:06:02 -0400
Message-ID: <55E996FB.1080009@xs4all.nl>
Date: Fri, 04 Sep 2015 15:04:59 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Prashant Laddha <prladdha@cisco.com>, linux-media@vger.kernel.org
CC: Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH 1/2] vivid: add support for reduced fps in video out.
References: <1440338951-23748-1-git-send-email-prladdha@cisco.com> <1440338951-23748-2-git-send-email-prladdha@cisco.com>
In-Reply-To: <1440338951-23748-2-git-send-email-prladdha@cisco.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Prashant,

Sorry for the late review, but here it is (finally):

On 08/23/2015 04:09 PM, Prashant Laddha wrote:
> If bt timing has REDUCED_FPS flag set, then reduce the frame rate
> by factor of 1000 / 1001. For vivid, timeperframe_vid_out indicates
> the frame timings used by video out thread. The timeperframe_vid_out
> is derived from pixel clock. Adjusting the timeperframe_vid_out by
> scaling down pixel clock with factor of 1000 / 1001.
> 
> The reduced fps is supported for CVT timings if reduced blanking v2
> (indicated by vsync = 8) is true. For CEA861 timings, reduced fps is
> supported if V4L2_DV_FL_CAN_REDUCE_FPS flag is true. For GTF timings,
> reduced fps is not supported.
> 
> The reduced fps will allow refresh rates like 29.97, 59.94 etc.
> 
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Signed-off-by: Prashant Laddha <prladdha@cisco.com>
> ---
>  drivers/media/platform/vivid/vivid-vid-out.c | 30 +++++++++++++++++++++++++++-
>  drivers/media/v4l2-core/v4l2-dv-timings.c    |  5 +++++
>  2 files changed, 34 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/vivid/vivid-vid-out.c b/drivers/media/platform/vivid/vivid-vid-out.c
> index c404e27..ca6ec78 100644
> --- a/drivers/media/platform/vivid/vivid-vid-out.c
> +++ b/drivers/media/platform/vivid/vivid-vid-out.c
> @@ -213,6 +213,27 @@ const struct vb2_ops vivid_vid_out_qops = {
>  };
>  
>  /*
> + * Called to check conditions for reduced fps. For CVT timings, reduced
> + * fps is allowed only with reduced blanking v2 (vsync == 8). For CEA861
> + * timings, reduced fps is allowed if V4L2_DV_FL_CAN_REDUCE_FPS flag is
> + * true.
> + */
> +static bool reduce_fps(struct v4l2_bt_timings *bt)
> +{
> +	if (!(bt->flags & V4L2_DV_FL_REDUCED_FPS))
> +		return false;
> +
> +	if ((bt->standards & V4L2_DV_BT_STD_CVT) && (bt->vsync == 8))

I propose that you add a static inline helper function to v4l2-dv-timings.h
to test for reduced blanking v2. This condition is way too magical...

If you add such a helper, then you should check if there is existing code
that could switch to this helper.

> +			return true;

Bad indentation (one tab too far to the right).

> +
> +	if ((bt->standards & V4L2_DV_BT_STD_CEA861) &&
> +	    (bt->flags & V4L2_DV_FL_CAN_REDUCE_FPS))
> +			return true;

Ditto.

> +
> +	return false;
> +}
> +
> +/*
>   * Called whenever the format has to be reset which can occur when
>   * changing outputs, standard, timings, etc.
>   */
> @@ -220,6 +241,7 @@ void vivid_update_format_out(struct vivid_dev *dev)
>  {
>  	struct v4l2_bt_timings *bt = &dev->dv_timings_out.bt;
>  	unsigned size, p;
> +	u64 pixelclock;
>  
>  	switch (dev->output_type[dev->output]) {
>  	case SVID:
> @@ -241,8 +263,14 @@ void vivid_update_format_out(struct vivid_dev *dev)
>  		dev->sink_rect.width = bt->width;
>  		dev->sink_rect.height = bt->height;
>  		size = V4L2_DV_BT_FRAME_WIDTH(bt) * V4L2_DV_BT_FRAME_HEIGHT(bt);
> +
> +		if (reduce_fps(bt))
> +			pixelclock = div_u64((bt->pixelclock * 1000), 1001);

No need for the parenthesis around bt->pixelclock * 1000.

> +		else
> +			pixelclock = bt->pixelclock;
> +
>  		dev->timeperframe_vid_out = (struct v4l2_fract) {
> -			size / 100, (u32)bt->pixelclock / 100
> +			size / 100, (u32)pixelclock / 100
>  		};
>  		if (bt->interlaced)
>  			dev->field_out = V4L2_FIELD_ALTERNATE;
> diff --git a/drivers/media/v4l2-core/v4l2-dv-timings.c b/drivers/media/v4l2-core/v4l2-dv-timings.c
> index 6a83d61..adc03bd 100644
> --- a/drivers/media/v4l2-core/v4l2-dv-timings.c
> +++ b/drivers/media/v4l2-core/v4l2-dv-timings.c
> @@ -210,7 +210,12 @@ bool v4l2_find_dv_timings_cap(struct v4l2_dv_timings *t,
>  					  fnc, fnc_handle) &&
>  		    v4l2_match_dv_timings(t, v4l2_dv_timings_presets + i,
>  					  pclock_delta)) {
> +			u32 flags = t->bt.flags & V4L2_DV_FL_REDUCED_FPS;
> +
>  			*t = v4l2_dv_timings_presets[i];
> +			if (t->bt.flags & V4L2_DV_FL_CAN_REDUCE_FPS)
> +				t->bt.flags |= flags;
> +

This isn't quite right. This doesn't support V4L2_DV_BT_DMT_4096X2160P60_RB
which is a CVT format with reduced blanking v2 and so it should support reduced
fps.

In theory the 'if' above should check for both the V4L2_DV_FL_CAN_REDUCE_FPS and
for CVT RB v2 (using the helper function I've proposed). However, that would
cause weird behavior with the V4L2_DV_BT_DMT_4096X2160P59_94_RB timings since
these are already reduced fps.

I think the best approach is to add V4L2_DV_FL_CAN_REDUCE_FPS to the
V4L2_DV_BT_DMT_4096X2160P60_RB definition in v4l2-dv-timings.h.

That way the code above is unchanged, and it will work as expected with
V4L2_DV_BT_DMT_4096X2160P60_RB.

Regards,

	Hans
