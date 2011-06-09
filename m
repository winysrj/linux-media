Return-path: <mchehab@pedra>
Received: from sj-iport-1.cisco.com ([171.71.176.70]:36843 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633Ab1FIICU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Jun 2011 04:02:20 -0400
From: Hans Verkuil <hansverk@cisco.com>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [PATCH 1/3] v4l: add macro for 1080p59_54 preset
Date: Thu, 9 Jun 2011 10:01:25 +0200
Cc: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com,
	sakari.ailus@maxwell.research.nokia.com, mchehab@redhat.com
References: <1307534611-32283-1-git-send-email-t.stanislaws@samsung.com> <1307534611-32283-2-git-send-email-t.stanislaws@samsung.com>
In-Reply-To: <1307534611-32283-2-git-send-email-t.stanislaws@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201106091001.25127.hansverk@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wednesday, June 08, 2011 14:03:29 Tomasz Stanislawski wrote:
> The 1080p59_94 is supported in latest Samusng SoC.

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> 
> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/media/video/v4l2-common.c |    1 +
>  include/linux/videodev2.h         |    1 +
>  2 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/v4l2-common.c b/drivers/media/video/v4l2-
common.c
> index 06b9f9f..003e648 100644
> --- a/drivers/media/video/v4l2-common.c
> +++ b/drivers/media/video/v4l2-common.c
> @@ -582,6 +582,7 @@ int v4l_fill_dv_preset_info(u32 preset, struct 
v4l2_dv_enum_preset *info)
>  		{ 1920, 1080, "1080p@30" },	/* V4L2_DV_1080P30 */
>  		{ 1920, 1080, "1080p@50" },	/* V4L2_DV_1080P50 */
>  		{ 1920, 1080, "1080p@60" },	/* V4L2_DV_1080P60 */
> +		{ 1920, 1080, "1080p@59.94" },	/* V4L2_DV_1080P59_94 */
>  	};
>  
>  	if (info == NULL || preset >= ARRAY_SIZE(dv_presets))
> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index 8a4c309..7c77c4e 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -872,6 +872,7 @@ struct v4l2_dv_enum_preset {
>  #define		V4L2_DV_1080P30		16 /* SMPTE 296M */
>  #define		V4L2_DV_1080P50		17 /* BT.1120 */
>  #define		V4L2_DV_1080P60		18 /* BT.1120 */
> +#define		V4L2_DV_1080P59_94	19
>  
>  /*
>   *	D V 	B T	T I M I N G S
> -- 
> 1.7.5.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
