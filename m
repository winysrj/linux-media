Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:56484 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933244Ab2EQVhu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 May 2012 17:37:50 -0400
Received: by wgbdr13 with SMTP id dr13so2152330wgb.1
        for <linux-media@vger.kernel.org>; Thu, 17 May 2012 14:37:49 -0700 (PDT)
Message-ID: <4FB56FAB.7030308@gmail.com>
Date: Thu, 17 May 2012 23:37:47 +0200
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	s.nawrocki@samsung.com, Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 1/1] v4l: Remove "_ACTUAL" from subdev selection API target
 definition names
References: <1337015823-13603-1-git-send-email-s.nawrocki@samsung.com> <1337289325-19336-1-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1337289325-19336-1-git-send-email-sakari.ailus@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

thanks for the patch.

On 05/17/2012 11:15 PM, Sakari Ailus wrote:
> The string "_ACTUAL" does not say anything more about the target names. Drop
> it. V4L2 selection API was changed by "V4L: Rename V4L2_SEL_TGT_[CROP/COMPOSE]_ACTIVE to
> V4L2_SEL_TGT_[CROP/COMPOSE]" by Sylwester Nawrocki. This patch does the same
> for the V4L2 subdev API.
> 
> Signed-off-by: Sakari Ailus<sakari.ailus@iki.fi>

Are these all changes, or do you think we could try to drop the _SUBDEV
part as well from the below selection target names, so they are same
across V4L2 and subdev API ? :-)

I realize it might me quite a bit of documentation work and it's pretty 
late for getting these patches in for v3.5.

I still have a dependency on my previous pull request which is pending
for the patch you mentioned. Do you think we should leave "_SUBDEV"
in subdev selection target names for now (/ever) ? 

Regards,
Sylwester

> ---
...
> diff --git a/include/linux/v4l2-subdev.h b/include/linux/v4l2-subdev.h
> index 812019e..01eee06 100644
> --- a/include/linux/v4l2-subdev.h
> +++ b/include/linux/v4l2-subdev.h
> @@ -128,11 +128,11 @@ struct v4l2_subdev_frame_interval_enum {
>   #define V4L2_SUBDEV_SEL_FLAG_KEEP_CONFIG		(1<<  2)
> 
>   /* active cropping area */
> -#define V4L2_SUBDEV_SEL_TGT_CROP_ACTUAL			0x0000
> +#define V4L2_SUBDEV_SEL_TGT_CROP			0x0000
>   /* cropping bounds */
>   #define V4L2_SUBDEV_SEL_TGT_CROP_BOUNDS			0x0002
>   /* current composing area */
> -#define V4L2_SUBDEV_SEL_TGT_COMPOSE_ACTUAL		0x0100
> +#define V4L2_SUBDEV_SEL_TGT_COMPOSE			0x0100
>   /* composing bounds */
>   #define V4L2_SUBDEV_SEL_TGT_COMPOSE_BOUNDS		0x0102
> 

