Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-3.cisco.com ([144.254.224.146]:3418 "EHLO
	ams-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237Ab3H3LY2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Aug 2013 07:24:28 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Gianluca Gennari <gennarone@gmail.com>
Subject: Re: [RFC PATCH] adv7842: fix compilation with GCC < 4.4.6
Date: Fri, 30 Aug 2013 13:24:11 +0200
Cc: linux-media@vger.kernel.org, m.chehab@samsung.com,
	hans.verkuil@cisco.com
References: <1377856227-22601-1-git-send-email-gennarone@gmail.com>
In-Reply-To: <1377856227-22601-1-git-send-email-gennarone@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201308301324.11177.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Gianluca,

On Fri 30 August 2013 11:50:27 Gianluca Gennari wrote:
> With GCC 4.4.3 (Ubuntu 10.04) the compilation of the new adv7842 driver
> fails with this error:
> 
> CC [M]  adv7842.o
> adv7842.c:549: error: unknown field 'bt' specified in initializer
> adv7842.c:550: error: field name not in record or union initializer
> adv7842.c:550: error: (near initialization for 'adv7842_timings_cap_analog.reserved')
> adv7842.c:551: error: field name not in record or union initializer
> adv7842.c:551: error: (near initialization for 'adv7842_timings_cap_analog.reserved')
> adv7842.c:552: error: field name not in record or union initializer
> adv7842.c:552: error: (near initialization for 'adv7842_timings_cap_analog.reserved')
> adv7842.c:553: error: field name not in record or union initializer
> adv7842.c:553: error: (near initialization for 'adv7842_timings_cap_analog.reserved')
> adv7842.c:553: warning: excess elements in array initializer
> ...
> 
> This is caused by the old GCC version, as explained in file v4l2-dv-timings.h.
> The proposed fix uses the V4L2_INIT_BT_TIMINGS macro defined there.
> Please note that I have also to init the reserved space as otherwise GCC fails with this error:
> 
> CC [M]  adv7842.o
> adv7842.c:549: error: field name not in record or union initializer
> adv7842.c:549: error: (near initialization for 'adv7842_timings_cap_analog.reserved')
> adv7842.c:549: warning: braces around scalar initializer
> adv7842.c:549: warning: (near initialization for 'adv7842_timings_cap_analog.reserved[0]')
> ...
> 
> Maybe the reserved space in struct v4l2_dv_timings_cap could be moved after
> the 'bt' field to avoid this?

No, it's part of the public API, so it can't be changed. It's OK to init the
reserved space, although you should prefix it with a small comment saying that
this is necessary when compiling with a gcc < 4.6.

> 
> The same issue applies to other drivers too: ths8200, adv7511 and ad9389b.
> If the fix is approved, I can post a patch serie fixing all of them.

Other than the point I made above it all looks fine.

Regards,

	Hans

> 
> Signed-off-by: Gianluca Gennari <gennarone@gmail.com>
> ---
>  drivers/media/i2c/adv7842.c | 28 ++++++++++------------------
>  1 file changed, 10 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
> index d174890..c21621b 100644
> --- a/drivers/media/i2c/adv7842.c
> +++ b/drivers/media/i2c/adv7842.c
> @@ -546,30 +546,22 @@ static inline bool is_digital_input(struct v4l2_subdev *sd)
>  
>  static const struct v4l2_dv_timings_cap adv7842_timings_cap_analog = {
>  	.type = V4L2_DV_BT_656_1120,
> -	.bt = {
> -		.max_width = 1920,
> -		.max_height = 1200,
> -		.min_pixelclock = 25000000,
> -		.max_pixelclock = 170000000,
> -		.standards = V4L2_DV_BT_STD_CEA861 | V4L2_DV_BT_STD_DMT |
> +	.reserved = { 0 },
> +	V4L2_INIT_BT_TIMINGS(0, 1920, 0, 1200, 25000000, 170000000,
> +		V4L2_DV_BT_STD_CEA861 | V4L2_DV_BT_STD_DMT |
>  			V4L2_DV_BT_STD_GTF | V4L2_DV_BT_STD_CVT,
> -		.capabilities = V4L2_DV_BT_CAP_PROGRESSIVE |
> -			V4L2_DV_BT_CAP_REDUCED_BLANKING | V4L2_DV_BT_CAP_CUSTOM,
> -	},
> +		V4L2_DV_BT_CAP_PROGRESSIVE | V4L2_DV_BT_CAP_REDUCED_BLANKING |
> +			V4L2_DV_BT_CAP_CUSTOM)
>  };
>  
>  static const struct v4l2_dv_timings_cap adv7842_timings_cap_digital = {
>  	.type = V4L2_DV_BT_656_1120,
> -	.bt = {
> -		.max_width = 1920,
> -		.max_height = 1200,
> -		.min_pixelclock = 25000000,
> -		.max_pixelclock = 225000000,
> -		.standards = V4L2_DV_BT_STD_CEA861 | V4L2_DV_BT_STD_DMT |
> +	.reserved = { 0 },
> +	V4L2_INIT_BT_TIMINGS(0, 1920, 0, 1200, 25000000, 225000000,
> +		V4L2_DV_BT_STD_CEA861 | V4L2_DV_BT_STD_DMT |
>  			V4L2_DV_BT_STD_GTF | V4L2_DV_BT_STD_CVT,
> -		.capabilities = V4L2_DV_BT_CAP_PROGRESSIVE |
> -			V4L2_DV_BT_CAP_REDUCED_BLANKING | V4L2_DV_BT_CAP_CUSTOM,
> -	},
> +		V4L2_DV_BT_CAP_PROGRESSIVE | V4L2_DV_BT_CAP_REDUCED_BLANKING |
> +			V4L2_DV_BT_CAP_CUSTOM)
>  };
>  
>  static inline const struct v4l2_dv_timings_cap *
> 
