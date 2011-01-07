Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50412 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263Ab1AGW3V (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Jan 2011 17:29:21 -0500
Received: by fxm20 with SMTP id 20so17368694fxm.19
        for <linux-media@vger.kernel.org>; Fri, 07 Jan 2011 14:29:19 -0800 (PST)
Message-ID: <4D2793BD.9070108@gmail.com>
Date: Fri, 07 Jan 2011 23:29:17 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC PATCH 1/5] v4l2-subdev: remove core.s_config and v4l2_i2c_new_subdev_cfg()
References: <1294404455-22050-1-git-send-email-hverkuil@xs4all.nl> <cc5591b13e048b8fbc1482db6dffeb7d48f9134b.1294402580.git.hverkuil@xs4all.nl>
In-Reply-To: <cc5591b13e048b8fbc1482db6dffeb7d48f9134b.1294402580.git.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans,

On 01/07/2011 01:47 PM, Hans Verkuil wrote:
> The core.s_config op was meant for legacy drivers that needed to work with old
> pre-2.6.26 kernels. This is no longer relevant. Unfortunately, this op was
> incorrectly called from several drivers.
>
> Replace those occurences with proper i2c_board_info structs and call
> v4l2_i2c_new_subdev_board.
>
> After these changes v4l2_i2c_new_subdev_cfg() was no longer used, so remove
> that function as well.
>
> Signed-off-by: Hans Verkuil<hverkuil@xs4all.nl>
> ---
>   drivers/media/video/cafe_ccic.c            |   11 +++-
>   drivers/media/video/cx25840/cx25840-core.c |   22 ++------
>   drivers/media/video/em28xx/em28xx-cards.c  |   18 ++++---
>   drivers/media/video/ivtv/ivtv-i2c.c        |    9 +++-
>   drivers/media/video/mt9v011.c              |   29 ++++-------
>   drivers/media/video/mt9v011.h              |   36 -------------
>   drivers/media/video/mt9v011_regs.h         |   36 +++++++++++++
>   drivers/media/video/ov7670.c               |   74 ++++++++++++----------------
>   drivers/media/video/sr030pc30.c            |   10 ----
>   drivers/media/video/v4l2-common.c          |   19 +------
>   include/media/mt9v011.h                    |   17 ++++++
>   include/media/v4l2-common.h                |   13 +-----
>   include/media/v4l2-subdev.h                |    6 +--
>   13 files changed, 130 insertions(+), 170 deletions(-)
>   delete mode 100644 drivers/media/video/mt9v011.h
>   create mode 100644 drivers/media/video/mt9v011_regs.h
>   create mode 100644 include/media/mt9v011.h
>
...
>
> diff --git a/drivers/media/video/sr030pc30.c b/drivers/media/video/sr030pc30.c
> index 864696b..c901721 100644
> --- a/drivers/media/video/sr030pc30.c
> +++ b/drivers/media/video/sr030pc30.c
> @@ -714,15 +714,6 @@ static int sr030pc30_base_config(struct v4l2_subdev *sd)
>   	return ret;
>   }
>
> -static int sr030pc30_s_config(struct v4l2_subdev *sd,
> -			      int irq, void *platform_data)
> -{
> -	struct sr030pc30_info *info = to_sr030pc30(sd);
> -
> -	info->pdata = platform_data;
> -	return 0;
> -}
> -
>   static int sr030pc30_s_stream(struct v4l2_subdev *sd, int enable)
>   {
>   	return 0;
> @@ -763,7 +754,6 @@ static int sr030pc30_s_power(struct v4l2_subdev *sd, int on)
>   }
>
>   static const struct v4l2_subdev_core_ops sr030pc30_core_ops = {
> -	.s_config	= sr030pc30_s_config,
>   	.s_power	= sr030pc30_s_power,
>   	.queryctrl	= sr030pc30_queryctrl,
>   	.s_ctrl		= sr030pc30_s_ctrl,
>

I've just had prepared a patch removing s_config as well as an empty 
s_stream op. So now there is only one left for me ;)
Thanks for handling that, and sorry for the trouble. I've got also
prepared a patch converting sr030pc30 driver to the control framework,
just need to find a time slot to test it.
An another one replacing the set_power callback with the regulator API.


Regards,
Sylwester


