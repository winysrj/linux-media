Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:46491 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932222Ab1BYJVC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Feb 2011 04:21:02 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: riverful.kim@samsung.com
Subject: Re: [RFC PATCH v2 2/3] v4l2-ctrls: modify uvc driver to use new menu type of V4L2_CID_FOCUS_AUTO
Date: Fri, 25 Feb 2011 10:20:59 +0100
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>
References: <4D674A6C.8000401@samsung.com>
In-Reply-To: <4D674A6C.8000401@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201102251020.59615.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Friday 25 February 2011 07:21:32 Kim, HeungJun wrote:
> As following to change the boolean type of V4L2_CID_FOCUS_AUTO to menu
> type, this uvc is modified the usage of V4L2_CID_FOCUS_AUTO.
> 
> Signed-off-by: Heungjun Kim <riverful.kim@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/media/video/uvc/uvc_ctrl.c |   13 ++++++++++---
>  1 files changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/video/uvc/uvc_ctrl.c
> b/drivers/media/video/uvc/uvc_ctrl.c index 59f8a9a..795fd3f 100644
> --- a/drivers/media/video/uvc/uvc_ctrl.c
> +++ b/drivers/media/video/uvc/uvc_ctrl.c
> @@ -333,6 +333,11 @@ static struct uvc_menu_info exposure_auto_controls[] =
> { { 8, "Aperture Priority Mode" },
>  };
> 
> +static struct uvc_menu_info focus_auto_controls[] = {
> +	{ 2, "Auto Mode" },
> +	{ 1, "Manual Mode" },

According to the UVC spec, this should be 0 for manual mode and 1 for auto 
mode.

> +};
> +
>  static __s32 uvc_ctrl_get_zoom(struct uvc_control_mapping *mapping,
>  	__u8 query, const __u8 *data)
>  {
> @@ -558,10 +563,12 @@ static struct uvc_control_mapping uvc_ctrl_mappings[]
> = { .name		= "Focus, Auto",
>  		.entity		= UVC_GUID_UVC_CAMERA,
>  		.selector	= UVC_CT_FOCUS_AUTO_CONTROL,
> -		.size		= 1,
> +		.size		= 2,

Why do you change the control size ?

>  		.offset		= 0,
> -		.v4l2_type	= V4L2_CTRL_TYPE_BOOLEAN,
> -		.data_type	= UVC_CTRL_DATA_TYPE_BOOLEAN,
> +		.v4l2_type	= V4L2_CTRL_TYPE_MENU,
> +		.data_type	= UVC_CTRL_DATA_TYPE_BITMASK,

The UVC control is still a boolean.

> +		.menu_info	= focus_auto_controls,
> +		.menu_count	= ARRAY_SIZE(focus_auto_controls),
>  	},
>  	{
>  		.id		= V4L2_CID_IRIS_ABSOLUTE,

-- 
Regards,

Laurent Pinchart
