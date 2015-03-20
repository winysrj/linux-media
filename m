Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:32898 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750916AbbCTQJp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Mar 2015 12:09:45 -0400
Message-ID: <550C4644.6060504@xs4all.nl>
Date: Fri, 20 Mar 2015 17:09:40 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Prashant Laddha <prladdha@cisco.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH v2 2/2] vivid: add support to set CVT, GTF timings
References: <1426862897-26789-1-git-send-email-prladdha@cisco.com>
In-Reply-To: <1426862897-26789-1-git-send-email-prladdha@cisco.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Prashant,

On 03/20/2015 03:48 PM, Prashant Laddha wrote:
> In addition to v4l2_find_dv_timings_cap(), where timings are searched
> against the list of preset timings, the incoming timing from v4l2-ctl
> is checked against CVT and GTF standards. If it confirms to be CVT or
> GTF, it is treated as valid timing and vivid format is updated with
> new timings.
> 
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Signed-off-by: Prashant Laddha <prladdha@cisco.com>
> ---
>  drivers/media/platform/vivid/vivid-vid-cap.c | 61 +++++++++++++++++++++++++++-
>  1 file changed, 60 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/vivid/vivid-vid-cap.c b/drivers/media/platform/vivid/vivid-vid-cap.c
> index 867a29a..b4ec9b0 100644
> --- a/drivers/media/platform/vivid/vivid-vid-cap.c
> +++ b/drivers/media/platform/vivid/vivid-vid-cap.c
> @@ -1552,6 +1552,63 @@ int vivid_vid_cap_s_std(struct file *file, void *priv, v4l2_std_id id)
>  	return 0;
>  }
>  
> +static void find_aspect_ratio(u32 width, u32 height,
> +			       u32 *num, u32 *denom)
> +{
> +	if (!(height % 3) && ((height * 4 / 3) == width)) {
> +		*num = 4;
> +		*denom = 3;
> +	} else if (!(height % 9) && ((height * 16 / 9) == width)) {
> +		*num = 16;
> +		*denom = 9;
> +	} else if (!(height % 10) && ((height * 16 / 10) == width)) {
> +		*num = 16;
> +		*denom = 10;
> +	} else if (!(height % 4) && ((height * 5 / 4) == width)) {
> +		*num = 5;
> +		*denom = 4;
> +	} else if (!(height % 9) && ((height * 15 / 9) == width)) {
> +		*num = 15;
> +		*denom = 9;
> +	} else { /* default to 16:9 */
> +		*num = 16;
> +		*denom = 9;
> +	}
> +}
> +
> +static bool valid_cvt_gtf_timings(struct v4l2_dv_timings *timings)
> +{
> +	struct v4l2_bt_timings *bt = &timings->bt;
> +	u32 total_h_pixel;
> +	u32 total_v_lines;
> +	u32 h_freq;
> +
> +	if (!v4l2_valid_dv_timings(timings, &vivid_dv_timings_cap,
> +				NULL, NULL))
> +		return false;
> +
> +	total_h_pixel = V4L2_DV_BT_FRAME_WIDTH(bt);
> +	total_v_lines = V4L2_DV_BT_FRAME_HEIGHT(bt);
> +
> +	h_freq = (u32)bt->pixelclock / total_h_pixel;
> +
> +	if (bt->standards == V4L2_DV_BT_STD_CVT)

This test and the next isn't right. Apologies that I didn't see that
when I reviewed v1.

The correct test is:

	if (bt->standard == 0 || (bt->standards & V4L2_DV_BT_STD_CVT))


> +		return v4l2_detect_cvt(total_v_lines, h_freq, bt->vsync,
> +				       bt->polarities, timings);

Just returning here isn't right either: if a CVT format is detected, then
it can return true, otherwise it should continue and try the GTF format.

> +
> +	if (bt->standards == V4L2_DV_BT_STD_GTF) {

And this becomes:

	if (bt->standard == 0 || (bt->standards & V4L2_DV_BT_STD_GTF))

When it comes to autodetecting formats the driver can often detect
only a few timing properties, and it is rarely able to say if it
will be a CVT or GTF timing. So often they leave bt->standard to 0.

Regards,

	Hans

> +		struct v4l2_fract aspect_ratio;
> +
> +		find_aspect_ratio(bt->width, bt->height,
> +				  &aspect_ratio.numerator,
> +				  &aspect_ratio.denominator);
> +		return v4l2_detect_gtf(total_v_lines, h_freq, bt->vsync,
> +				       bt->polarities, aspect_ratio, timings);
> +	}
> +
> +	return false;
> +}
> +
>  int vivid_vid_cap_s_dv_timings(struct file *file, void *_fh,
>  				    struct v4l2_dv_timings *timings)
>  {
> @@ -1561,8 +1618,10 @@ int vivid_vid_cap_s_dv_timings(struct file *file, void *_fh,
>  		return -ENODATA;
>  	if (vb2_is_busy(&dev->vb_vid_cap_q))
>  		return -EBUSY;
> +
>  	if (!v4l2_find_dv_timings_cap(timings, &vivid_dv_timings_cap,
> -				0, NULL, NULL))
> +				      0, NULL, NULL)
> +	    && !valid_cvt_gtf_timings(timings))
>  		return -EINVAL;
>  	if (v4l2_match_dv_timings(timings, &dev->dv_timings_cap, 0))
>  		return 0;
> 
