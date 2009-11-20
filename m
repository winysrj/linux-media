Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:1661 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620AbZKTMlQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Nov 2009 07:41:16 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: m-karicheri2@ti.com
Subject: Re: [PATCH] Adding helper function to get dv preset description
Date: Fri, 20 Nov 2009 13:41:18 +0100
Cc: linux-media@vger.kernel.org,
	davinci-linux-open-source@linux.davincidsp.com
References: <1258646987-21515-1-git-send-email-m-karicheri2@ti.com>
In-Reply-To: <1258646987-21515-1-git-send-email-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911201341.18922.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 19 November 2009 17:09:47 m-karicheri2@ti.com wrote:
> From: Muralidharan Karicheri <m-karicheri2@ti.com>
>
> This patch add a helper function to get description of a digital
> video preset added by the video timing API. Hope this will be
> usefull for drivers implementing the above API.
>
> Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
> NOTE: depends on the patch that adds video timing API.

This is very inefficient memory-wise. struct v4l2_dv_enum_preset takes 52 
bytes and since I expect that we will see a lot of presets in the future, 
this can add up very quickly.

IMHO it is better to make a separate struct:

struct v4l2_dv_preset_info {
	u16 width;
	u16 height;
	const char *name;
};

static const struct v4l2_dv_preset_info dv_presets[] = {
	{    0,    0, "Invalid" },	/* V4L2_DV_INVALID */
	{  720,  480, "480p@59.94" },	/* V4L2_DV_480P59_94 */
};

This is a lot more compact, especially with the strings.

> ---
> Applies to V4L-DVB linux-next branch
>
>  drivers/media/video/v4l2-common.c |  135
> +++++++++++++++++++++++++++++++++++++ include/media/v4l2-common.h       |
>    1 +
>  2 files changed, 136 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/media/video/v4l2-common.c
> b/drivers/media/video/v4l2-common.c index f5a93ae..245e727 100644
> --- a/drivers/media/video/v4l2-common.c
> +++ b/drivers/media/video/v4l2-common.c
> @@ -1015,3 +1015,138 @@ void v4l_bound_align_image(u32 *w, unsigned int
> wmin, unsigned int wmax, }
>  }
>  EXPORT_SYMBOL_GPL(v4l_bound_align_image);
> +
> +/**
> + * v4l_fill_dv_preset_info - fill description of a digital video preset
> + * @preset - preset value
> + * @info - pointer to struct v4l2_dv_enum_preset
> + *
> + * drivers can use this helper function to fill description of dv preset
> + * in info.
> + */
> +int v4l_fill_dv_preset_info(u32 preset, struct v4l2_dv_enum_preset
> *info) +{
> +	static const struct v4l2_dv_enum_preset dv_presets[] = {
> +		{
> +			.preset	= V4L2_DV_480P59_94,
> +			.name = "480p@59.94",
> +			.width = 720,
> +			.height = 480,
> +		},
> +		{
> +			.preset	= V4L2_DV_576P50,
> +			.name = "576p@50",
> +			.width = 720,
> +			.height = 576,
> +		},
> +		{
> +			.preset	= V4L2_DV_720P24,
> +			.name = "720p@24",
> +			.width = 1280,
> +			.height = 720,
> +		},
> +		{
> +			.preset	= V4L2_DV_720P25,
> +			.name = "720p@25",
> +			.width = 1280,
> +			.height = 720,
> +		},
> +		{
> +			.preset	= V4L2_DV_720P30,
> +			.name = "720p@30",
> +			.width = 1280,
> +			.height = 720,
> +		},
> +		{
> +			.preset	= V4L2_DV_720P50,
> +			.name = "720p@50",
> +			.width = 1280,
> +			.height = 720,
> +		},
> +		{
> +			.preset	= V4L2_DV_720P59_94,
> +			.name = "720p@59.94",
> +			.width = 1280,
> +			.height = 720,
> +		},
> +		{
> +			.preset	= V4L2_DV_720P60,
> +			.name = "720p@60",
> +			.width = 1280,
> +			.height = 720,
> +		},
> +		{
> +			.preset	= V4L2_DV_1080I29_97,
> +			.name = "1080i@29.97",
> +			.width = 1920,
> +			.height = 1080,
> +		},
> +		{
> +			.preset	= V4L2_DV_1080I30,
> +			.name = "1080i@30",
> +			.width = 1920,
> +			.height = 1080,
> +		},
> +		{
> +			.preset	= V4L2_DV_1080I25,
> +			.name = "1080i@25",
> +			.width = 1920,
> +			.height = 1080,
> +		},
> +		{
> +			.preset	= V4L2_DV_1080I50,
> +			.name = "1080i@50",
> +			.width = 1920,
> +			.height = 1080,
> +		},
> +		{
> +			.preset	= V4L2_DV_1080I60,
> +			.name = "1080i@60",
> +			.width = 1920,
> +			.height = 1080,
> +		},
> +		{
> +			.preset	= V4L2_DV_1080P24,
> +			.name = "1080p@24",
> +			.width = 1920,
> +			.height = 1080,
> +		},
> +		{
> +			.preset	= V4L2_DV_1080P25,
> +			.name = "1080p@25",
> +			.width = 1920,
> +			.height = 1080,
> +		},
> +		{
> +			.preset	= V4L2_DV_1080P30,
> +			.name = "1080p@30",
> +			.width = 1920,
> +			.height = 1080,
> +		},
> +		{
> +			.preset	= V4L2_DV_1080P50,
> +			.name = "1080p@50",
> +			.width = 1920,
> +			.height = 1080,
> +		},
> +		{
> +			.preset	= V4L2_DV_1080P60,
> +			.name = "1080p@60",
> +			.width = 1920,
> +			.height = 1080,
> +		},
> +	};
> +	int i;
> +
> +	if (info == NULL)
> +		return -EINVAL;
> +
> +	for (i = 0; i < ARRAY_SIZE(dv_presets); i++) {
> +		if (preset == dv_presets[i].preset) {
> +			memcpy(info, &dv_presets[i], sizeof(*info));

Shorter to just do: *info = dv_presets[i];

Regards,

	Hans

> +			return 0;
> +		}
> +	}
> +	return -EINVAL;
> +}
> +EXPORT_SYMBOL_GPL(v4l_fill_dv_preset_info);
> diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
> index 1c25b10..ddc040f 100644
> --- a/include/media/v4l2-common.h
> +++ b/include/media/v4l2-common.h
> @@ -213,4 +213,5 @@ void v4l_bound_align_image(unsigned int *w, unsigned
> int wmin, unsigned int hmax, unsigned int halign,
>  			   unsigned int salign);
>
> +int v4l_fill_dv_preset_info(u32 preset, struct v4l2_dv_enum_preset
> *info); #endif /* V4L2_COMMON_H_ */



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
