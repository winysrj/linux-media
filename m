Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:2982 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbZKUJzZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Nov 2009 04:55:25 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: m-karicheri2@ti.com
Subject: Re: [PATCH - v1]V4L - Adding helper function to get dv preset description
Date: Sat, 21 Nov 2009 10:55:27 +0100
Cc: linux-media@vger.kernel.org,
	davinci-linux-open-source@linux.davincidsp.com
References: <1258757598-14216-1-git-send-email-m-karicheri2@ti.com>
In-Reply-To: <1258757598-14216-1-git-send-email-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911211055.27735.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 20 November 2009 23:53:18 m-karicheri2@ti.com wrote:
> From: Muralidharan Karicheri <m-karicheri2@ti.com>
>
> Resending adding Reviewed-by...
>
> Updated based on review comments

And see more review comments below!

> This patch adds a helper function to get description of a digital
> video preset added by the video timing API. This will be usefull for
> drivers implementing the above API.
>
> Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
> Reviewed-by: Hans Verkuil <hverkuil@xs4all.nl>
> NOTE: depends on the patch that adds video timing API.
> ---
> Applies to V4L-DVB linux-next branch
>  drivers/media/video/v4l2-common.c |   43
> +++++++++++++++++++++++++++++++++++++ include/media/v4l2-common.h       |
>    7 ++++++
>  2 files changed, 50 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/media/video/v4l2-common.c
> b/drivers/media/video/v4l2-common.c index f5a93ae..8b13d8e 100644
> --- a/drivers/media/video/v4l2-common.c
> +++ b/drivers/media/video/v4l2-common.c
> @@ -1015,3 +1015,46 @@ void v4l_bound_align_image(u32 *w, unsigned int
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
> +	static const struct v4l2_dv_preset_info dv_presets[] = {
> +		{0, 0, "Invalid"},/* V4L2_DV_INVALID */
> +		{720,  480, "480p@59.94"},/* V4L2_DV_480P59_94 */
> +		{720,  576, "576p@50"},/* V4L2_DV_576P50 */
> +		{1280, 720, "720p@24"},/* V4L2_DV_720P24 */
> +		{1280, 720, "720p@25"},/* V4L2_DV_720P25 */
> +		{1280, 720, "720p@30"},/* V4L2_DV_720P30 */
> +		{1280, 720, "720p@50"},/* V4L2_DV_720P50 */
> +		{1280, 720, "720p@59.94"},/* V4L2_DV_720P59_94 */
> +		{1280, 720, "720p@60"},/* V4L2_DV_720P60 */
> +		{1920, 1080, "1080i@29.97"},/* V4L2_DV_1080I29_97 */
> +		{1920, 1080, "1080i@30"},/* V4L2_DV_1080I30 */
> +		{1920, 1080, "1080i@25"},/* V4L2_DV_1080I25 */
> +		{1920, 1080, "1080i@50"},/* V4L2_DV_1080I50 */
> +		{1920, 1080, "1080i@60"},/* V4L2_DV_1080I60 */
> +		{1920, 1080, "1080p@24"},/* V4L2_DV_1080P24 */
> +		{1920, 1080, "1080p@25"},/* V4L2_DV_1080P25 */
> +		{1920, 1080, "1080p@30"},/* V4L2_DV_1080P30 */
> +		{1920, 1080, "1080p@50"},/* V4L2_DV_1080P50 */
> +		{1920, 1080, "1080p@60"},/* V4L2_DV_1080P60 */

Please add spaces after {, before } and before /*. Actually, it would be 
nice if the comments all are aligned vertically, that makes this a nice 
looking table.

> +	};
> +
> +	if (info == NULL || preset >= ARRAY_SIZE(dv_presets))
> +		return -EINVAL;
> +
> +	info->preset = preset;
> +	info->width = dv_presets[preset].width;
> +	info->height = dv_presets[preset].height;
> +	strcpy(info->name, dv_presets[preset].name);

Use strlcpy instead of strcpy. That prevents accidental buffer overruns.

> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(v4l_fill_dv_preset_info);
> diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
> index 1c25b10..6ec9986 100644
> --- a/include/media/v4l2-common.h
> +++ b/include/media/v4l2-common.h
> @@ -213,4 +213,11 @@ void v4l_bound_align_image(unsigned int *w, unsigned
> int wmin, unsigned int hmax, unsigned int halign,
>  			   unsigned int salign);
>
> +struct v4l2_dv_preset_info {
> +	u16 width;
> +	u16 height;
> +	const char *name;
> +};

This header is only used in v4l_fill_dv_preset_info, so can be defined 
there:

static const struct v4l2_dv_preset_info {
	u16 width;
	u16 height;
	const char *name;
} dv_presets[] = {
...
};

> +
> +int v4l_fill_dv_preset_info(u32 preset, struct v4l2_dv_enum_preset
> *info); #endif /* V4L2_COMMON_H_ */

As usual, thanks for all your work on this!

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
