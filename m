Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:57836 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751726AbcGUNod (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jul 2016 09:44:33 -0400
Subject: Re: [PATCH v3 1/2] SDI: add flag for SDI formats and SMPTE 125M
 definition
To: Charles-Antoine Couret <charles-antoine.couret@nexvision.fr>,
	linux-media@vger.kernel.org
References: <1469104482-20119-1-git-send-email-charles-antoine.couret@nexvision.fr>
 <1469104482-20119-2-git-send-email-charles-antoine.couret@nexvision.fr>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <9230ca8e-b824-1cdc-33db-08ff18be7af6@xs4all.nl>
Date: Thu, 21 Jul 2016 15:44:27 +0200
MIME-Version: 1.0
In-Reply-To: <1469104482-20119-2-git-send-email-charles-antoine.couret@nexvision.fr>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 07/21/2016 02:34 PM, Charles-Antoine Couret wrote:
> Adding others generic flags, which could be used by many
> components like GS1662.
> 
> Signed-off-by: Charles-Antoine Couret <charles-antoine.couret@nexvision.fr>
> ---
>  drivers/media/v4l2-core/v4l2-dv-timings.c | 11 +++++++----
>  include/uapi/linux/v4l2-dv-timings.h      | 12 ++++++++++++
>  include/uapi/linux/videodev2.h            |  5 +++++
>  3 files changed, 24 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-dv-timings.c b/drivers/media/v4l2-core/v4l2-dv-timings.c
> index 889de0a..13fbbde 100644
> --- a/drivers/media/v4l2-core/v4l2-dv-timings.c
> +++ b/drivers/media/v4l2-core/v4l2-dv-timings.c
> @@ -306,7 +306,7 @@ void v4l2_print_dv_timings(const char *dev_prefix, const char *prefix,
>  			(bt->polarities & V4L2_DV_VSYNC_POS_POL) ? "+" : "-",
>  			bt->il_vsync, bt->il_vbackporch);
>  	pr_info("%s: pixelclock: %llu\n", dev_prefix, bt->pixelclock);
> -	pr_info("%s: flags (0x%x):%s%s%s%s%s%s\n", dev_prefix, bt->flags,
> +	pr_info("%s: flags (0x%x):%s%s%s%s%s%s%s\n", dev_prefix, bt->flags,
>  			(bt->flags & V4L2_DV_FL_REDUCED_BLANKING) ?
>  			" REDUCED_BLANKING" : "",
>  			((bt->flags & V4L2_DV_FL_REDUCED_BLANKING) &&
> @@ -318,12 +318,15 @@ void v4l2_print_dv_timings(const char *dev_prefix, const char *prefix,
>  			(bt->flags & V4L2_DV_FL_HALF_LINE) ?
>  			" HALF_LINE" : "",
>  			(bt->flags & V4L2_DV_FL_IS_CE_VIDEO) ?
> -			" CE_VIDEO" : "");
> -	pr_info("%s: standards (0x%x):%s%s%s%s\n", dev_prefix, bt->standards,
> +			" CE_VIDEO" : "",
> +			(bt->flags & V4L2_DV_FIRST_FIELD_EXTRA_LINE) ?
> +			" FIRST_FIELD_EXTRA_LINE" : "");
> +	pr_info("%s: standards (0x%x):%s%s%s%s%s\n", dev_prefix, bt->standards,
>  			(bt->standards & V4L2_DV_BT_STD_CEA861) ?  " CEA" : "",
>  			(bt->standards & V4L2_DV_BT_STD_DMT) ?  " DMT" : "",
>  			(bt->standards & V4L2_DV_BT_STD_CVT) ?  " CVT" : "",
> -			(bt->standards & V4L2_DV_BT_STD_GTF) ?  " GTF" : "");
> +			(bt->standards & V4L2_DV_BT_STD_GTF) ?  " GTF" : "",
> +			(bt->standards & V4L2_DV_BT_STD_SDI) ?  " SDI" : "");
>  }
>  EXPORT_SYMBOL_GPL(v4l2_print_dv_timings);
>  
> diff --git a/include/uapi/linux/v4l2-dv-timings.h b/include/uapi/linux/v4l2-dv-timings.h
> index 086168e..6ee01f1 100644
> --- a/include/uapi/linux/v4l2-dv-timings.h
> +++ b/include/uapi/linux/v4l2-dv-timings.h
> @@ -934,4 +934,16 @@
>  		V4L2_DV_FL_REDUCED_BLANKING) \
>  }
>  
> +/* SDI timings definitions */
> +
> +/* SMPTE-125M */
> +#define V4L2_DV_BT_SDI_720X487I60 { \
> +	.type = V4L2_DV_BT_656_1120, \
> +	V4L2_INIT_BT_TIMINGS(720, 487, 1, \
> +		V4L2_DV_HSYNC_POS_POL, \
> +		13500000, 0, 137, 0, 0, 19, 0, 0, 19, 0, \
> +		V4L2_DV_BT_STD_SDI, \
> +		V4L2_DV_FIRST_FIELD_EXTRA_LINE) \
> +}
> +
>  #endif
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index 8f95191..4641f13 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -1259,6 +1259,7 @@ struct v4l2_bt_timings {
>  #define V4L2_DV_BT_STD_DMT	(1 << 1)  /* VESA Discrete Monitor Timings */
>  #define V4L2_DV_BT_STD_CVT	(1 << 2)  /* VESA Coordinated Video Timings */
>  #define V4L2_DV_BT_STD_GTF	(1 << 3)  /* VESA Generalized Timings Formula */
> +#define V4L2_DV_BT_STD_SDI	(1 << 4)  /* SDI Timings */
>  
>  /* Flags */
>  
> @@ -1363,6 +1364,8 @@ struct v4l2_bt_timings_cap {
>  #define V4L2_DV_BT_CAP_REDUCED_BLANKING	(1 << 2)
>  /* Supports custom formats */
>  #define V4L2_DV_BT_CAP_CUSTOM		(1 << 3)
> +/* In case of odd format, to know the field which has the extra line */
> +#define V4L2_DV_FIRST_FIELD_EXTRA_LINE	(1 << 4)

This isn't a capability, it is a flag, so this should be next to the other
V4L2_DV_FL_* defines, and its prefix should be V4L2_DV_FL_ (note the FL).

>  
>  /** struct v4l2_dv_timings_cap - DV timings capabilities
>   * @type:	the type of the timings (same as in struct v4l2_dv_timings)
> @@ -1413,6 +1416,8 @@ struct v4l2_input {
>  /* field 'status' - analog */
>  #define V4L2_IN_ST_NO_H_LOCK   0x00000100  /* No horizontal sync lock */
>  #define V4L2_IN_ST_COLOR_KILL  0x00000200  /* Color killer is active */
> +#define V4L2_IN_ST_NO_V_LOCK   0x00000400  /* No vertical sync lock */
> +#define V4L2_IN_ST_NO_STD_LOCK 0x00000800  /* No standard format lock */
>  
>  /* field 'status' - digital */
>  #define V4L2_IN_ST_NO_SYNC     0x00010000  /* No synchronization lock */
> 

Regards,

	Hans
