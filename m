Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58071 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965088Ab2B1LD1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Feb 2012 06:03:27 -0500
Message-ID: <4F4CB47B.1020606@redhat.com>
Date: Tue, 28 Feb 2012 08:03:23 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv1 PATCH 5/6] v4l2-common: add new support functions to match
 DV timings.
References: <1328263566-21620-1-git-send-email-hverkuil@xs4all.nl> <68cfc6be5d701f44ae06331be08a57c311169004.1328262332.git.hans.verkuil@cisco.com>
In-Reply-To: <68cfc6be5d701f44ae06331be08a57c311169004.1328262332.git.hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 03-02-2012 08:06, Hans Verkuil escreveu:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/video/v4l2-common.c |  102 ++++++++++++++++++++++++++++++-------
>  include/media/v4l2-common.h       |   15 +++++
>  2 files changed, 99 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/media/video/v4l2-common.c b/drivers/media/video/v4l2-common.c
> index 5c6100f..f133961 100644
> --- a/drivers/media/video/v4l2-common.c
> +++ b/drivers/media/video/v4l2-common.c
> @@ -567,24 +567,24 @@ int v4l_fill_dv_preset_info(u32 preset, struct v4l2_dv_enum_preset *info)
>  		const char *name;
>  	} dv_presets[] = {
>  		{ 0, 0, "Invalid" },		/* V4L2_DV_INVALID */
> -		{ 720,  480, "480p@59.94" },	/* V4L2_DV_480P59_94 */
> -		{ 720,  576, "576p@50" },	/* V4L2_DV_576P50 */
> -		{ 1280, 720, "720p@24" },	/* V4L2_DV_720P24 */
> -		{ 1280, 720, "720p@25" },	/* V4L2_DV_720P25 */
> -		{ 1280, 720, "720p@30" },	/* V4L2_DV_720P30 */
> -		{ 1280, 720, "720p@50" },	/* V4L2_DV_720P50 */
> -		{ 1280, 720, "720p@59.94" },	/* V4L2_DV_720P59_94 */
> -		{ 1280, 720, "720p@60" },	/* V4L2_DV_720P60 */
> -		{ 1920, 1080, "1080i@29.97" },	/* V4L2_DV_1080I29_97 */
> -		{ 1920, 1080, "1080i@30" },	/* V4L2_DV_1080I30 */
> -		{ 1920, 1080, "1080i@25" },	/* V4L2_DV_1080I25 */
> -		{ 1920, 1080, "1080i@50" },	/* V4L2_DV_1080I50 */
> -		{ 1920, 1080, "1080i@60" },	/* V4L2_DV_1080I60 */
> -		{ 1920, 1080, "1080p@24" },	/* V4L2_DV_1080P24 */
> -		{ 1920, 1080, "1080p@25" },	/* V4L2_DV_1080P25 */
> -		{ 1920, 1080, "1080p@30" },	/* V4L2_DV_1080P30 */
> -		{ 1920, 1080, "1080p@50" },	/* V4L2_DV_1080P50 */
> -		{ 1920, 1080, "1080p@60" },	/* V4L2_DV_1080P60 */
> +		{ 720,  480, "720x480p59.94" },	/* V4L2_DV_480P59_94 */
> +		{ 720,  576, "720x576p50" },	/* V4L2_DV_576P50 */
> +		{ 1280, 720, "1280x720p24" },	/* V4L2_DV_720P24 */
> +		{ 1280, 720, "1280x720p25" },	/* V4L2_DV_720P25 */
> +		{ 1280, 720, "1280x720p30" },	/* V4L2_DV_720P30 */
> +		{ 1280, 720, "1280x720p50" },	/* V4L2_DV_720P50 */
> +		{ 1280, 720, "1280x720p59.94" },/* V4L2_DV_720P59_94 */
> +		{ 1280, 720, "1280x720p60" },	/* V4L2_DV_720P60 */

> +		{ 0, 0, "Invalid" },		/* V4L2_DV_1080I29_97 */
> +		{ 0, 0, "Invalid" },		/* V4L2_DV_1080I30 */
> +		{ 0, 0, "Invalid" },		/* V4L2_DV_1080I25 */

Huh? That seems to be causing a regression.

> +		{ 1920, 1080, "1920x1080i50" },	/* V4L2_DV_1080I50 */
> +		{ 1920, 1080, "1920x1080i60" },	/* V4L2_DV_1080I60 */
> +		{ 1920, 1080, "1920x1080p24" },	/* V4L2_DV_1080P24 */
> +		{ 1920, 1080, "1920x1080p25" },	/* V4L2_DV_1080P25 */
> +		{ 1920, 1080, "1920x1080p30" },	/* V4L2_DV_1080P30 */
> +		{ 1920, 1080, "1920x1080p50" },	/* V4L2_DV_1080P50 */
> +		{ 1920, 1080, "1920x1080p60" },	/* V4L2_DV_1080P60 */
>  	};
>  
>  	if (info == NULL || preset >= ARRAY_SIZE(dv_presets))
> @@ -598,6 +598,72 @@ int v4l_fill_dv_preset_info(u32 preset, struct v4l2_dv_enum_preset *info)
>  }
>  EXPORT_SYMBOL_GPL(v4l_fill_dv_preset_info);
>  
> +bool v4l_match_dv_timings(const struct v4l2_dv_timings *t1,
> +			  const struct v4l2_dv_timings *t2)
> +{
> +	if (t1->type != t2->type || t1->type != V4L2_DV_BT_656_1120)
> +		return false;
> +	return !memcmp(&t1->bt, &t2->bt, &t1->bt.standards - &t1->bt.width);
> +}
> +EXPORT_SYMBOL_GPL(v4l_match_dv_timings);
> +
> +bool v4l_match_dv_timings_fuzzy(const struct v4l2_dv_timings *t1,
> +			  const struct v4l2_dv_timings *t2,
> +			  u32 clock_resolution, u32 flags)
> +{
> +	const struct v4l2_bt_timings *bt1, *bt2;
> +	unsigned v_blank1, v_blank2;
> +	u32 clock_diff;
> +
> +	if (t1->type != t2->type || t1->type != V4L2_DV_BT_656_1120)
> +		return false;
> +	bt1 = &t1->bt;
> +	bt2 = &t2->bt;
> +	if (bt1->interlaced != bt2->interlaced)
> +		return false;
> +	v_blank1 = bt1->vfrontporch + bt1->vsync + bt1->vbackporch +
> +		   bt1->il_vfrontporch + bt1->il_vsync + bt1->il_vbackporch;
> +	v_blank2 = bt2->vfrontporch + bt2->vsync + bt2->vbackporch +
> +		   bt2->il_vfrontporch + bt2->il_vsync + bt2->il_vbackporch;
> +	if (bt1->height != bt2->height)
> +		return false;
> +	if ((flags & V4L_MATCH_BT_HAVE_ACTIVE_HEIGHT) &&
> +			v_blank1 != v_blank2)
> +		return false;
> +	if ((flags & V4L_MATCH_BT_HAVE_V_POL) &&
> +			(bt1->polarities & V4L2_DV_VSYNC_POS_POL) !=
> +			(bt2->polarities & V4L2_DV_VSYNC_POS_POL))
> +		return false;
> +	if ((flags & V4L_MATCH_BT_HAVE_H_POL) &&
> +			(bt1->polarities & V4L2_DV_HSYNC_POS_POL) !=
> +			(bt2->polarities & V4L2_DV_HSYNC_POS_POL))
> +		return false;
> +	if ((flags & V4L_MATCH_BT_HAVE_VSYNC) &&
> +			bt1->vsync != bt2->vsync)
> +		return false;
> +	if ((flags & V4L_MATCH_BT_HAVE_HSYNC) &&
> +			bt1->hsync != bt2->hsync)
> +		return false;
> +	if (flags & V4L_MATCH_BT_HAVE_WIDTH) {
> +		unsigned h_blank1 = bt1->hfrontporch + bt1->hsync +
> +					bt1->hbackporch;
> +		unsigned h_blank2 = bt2->hfrontporch + bt2->hsync +
> +					bt2->hbackporch;
> +
> +		if (bt1->width != bt2->width)
> +			return false;
> +		if ((flags & V4L_MATCH_BT_HAVE_ACTIVE_WIDTH) &&
> +				h_blank1 != h_blank2)
> +			return false;
> +	}
> +	if (bt1->pixelclock > bt2->pixelclock)
> +		clock_diff = bt1->pixelclock - bt2->pixelclock;
> +	else
> +		clock_diff = bt2->pixelclock - bt1->pixelclock;
> +	return clock_diff < clock_resolution;
> +}
> +EXPORT_SYMBOL_GPL(v4l_match_dv_timings_fuzzy);
> +
>  const struct v4l2_frmsize_discrete *v4l2_find_nearest_format(
>  		const struct v4l2_discrete_probe *probe,
>  		s32 width, s32 height)
> diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
> index a298ec4..4469696 100644
> --- a/include/media/v4l2-common.h
> +++ b/include/media/v4l2-common.h
> @@ -202,6 +202,21 @@ void v4l_bound_align_image(unsigned int *w, unsigned int wmin,
>  			   unsigned int hmax, unsigned int halign,
>  			   unsigned int salign);
>  int v4l_fill_dv_preset_info(u32 preset, struct v4l2_dv_enum_preset *info);
> +bool v4l_match_dv_timings(const struct v4l2_dv_timings *t1,
> +			  const struct v4l2_dv_timings *t2);
> +
> +#define V4L_MATCH_BT_HAVE_WIDTH		(1 << 0)
> +#define V4L_MATCH_BT_HAVE_ACTIVE_HEIGHT	(1 << 1)
> +#define V4L_MATCH_BT_HAVE_ACTIVE_WIDTH	(1 << 2)
> +#define V4L_MATCH_BT_HAVE_V_POL		(1 << 3)
> +#define V4L_MATCH_BT_HAVE_H_POL		(1 << 4)
> +#define V4L_MATCH_BT_HAVE_VSYNC		(1 << 5)
> +#define V4L_MATCH_BT_HAVE_HSYNC		(1 << 6)
> +
> +bool v4l_match_dv_timings_fuzzy(const struct v4l2_dv_timings *t1,
> +			  const struct v4l2_dv_timings *t2,
> +			  u32 clock_resolution,
> +			  u32 flags);
>  
>  struct v4l2_discrete_probe {
>  	const struct v4l2_frmsize_discrete	*sizes;

