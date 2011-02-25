Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42179 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297Ab1BYM63 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Feb 2011 07:58:29 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: riverful.kim@samsung.com
Subject: Re: [RFC PATCH RESEND v2 2/3] v4l2-ctrls: modify uvc driver to use new menu type of V4L2_CID_FOCUS_AUTO
Date: Fri, 25 Feb 2011 13:58:28 +0100
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>
References: <4D67A489.2050808@samsung.com>
In-Reply-To: <4D67A489.2050808@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201102251358.29116.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

On Friday 25 February 2011 13:46:01 Kim, HeungJun wrote:
> As following to change the boolean type of V4L2_CID_FOCUS_AUTO to menu
> type, this uvc is modified the usage of V4L2_CID_FOCUS_AUTO.
> 
> Signed-off-by: Heungjun Kim <riverful.kim@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/media/video/uvc/uvc_ctrl.c |    9 ++++++++-
>  1 files changed, 8 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/uvc/uvc_ctrl.c
> b/drivers/media/video/uvc/uvc_ctrl.c index 59f8a9a..b98b9f1 100644
> --- a/drivers/media/video/uvc/uvc_ctrl.c
> +++ b/drivers/media/video/uvc/uvc_ctrl.c
> @@ -333,6 +333,11 @@ static struct uvc_menu_info exposure_auto_controls[] =
> { { 8, "Aperture Priority Mode" },
>  };
> 
> +static struct uvc_menu_info focus_auto_controls[] = {
> +	{ 1, "Auto Mode" },
> +	{ 0, "Manual Mode" },

Now that manual focus has value 0 and auto focus value 1, the menu entries 
need to be the other way around.

> +};
> +
>  static __s32 uvc_ctrl_get_zoom(struct uvc_control_mapping *mapping,
>  	__u8 query, const __u8 *data)
>  {
> @@ -560,8 +565,10 @@ static struct uvc_control_mapping uvc_ctrl_mappings[]
> = { .selector	= UVC_CT_FOCUS_AUTO_CONTROL,
>  		.size		= 1,
>  		.offset		= 0,
> -		.v4l2_type	= V4L2_CTRL_TYPE_BOOLEAN,
> +		.v4l2_type	= V4L2_CTRL_TYPE_MENU,
>  		.data_type	= UVC_CTRL_DATA_TYPE_BOOLEAN,
> +		.menu_info	= focus_auto_controls,
> +		.menu_count	= ARRAY_SIZE(focus_auto_controls),
>  	},
>  	{
>  		.id		= V4L2_CID_IRIS_ABSOLUTE,

-- 
Regards,

Laurent Pinchart
