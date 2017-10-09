Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:51056 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751693AbdJILCa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 9 Oct 2017 07:02:30 -0400
Subject: Re: [PATCH 09/24] media: v4l2-dev: document video_device flags
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
References: <cover.1507544011.git.mchehab@s-opensource.com>
 <e639d4ff59747c9b300ea0328ffa82fb5bca9679.1507544011.git.mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <4e6c380f-6513-88e0-afab-364f79586c93@xs4all.nl>
Date: Mon, 9 Oct 2017 13:02:28 +0200
MIME-Version: 1.0
In-Reply-To: <e639d4ff59747c9b300ea0328ffa82fb5bca9679.1507544011.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/10/17 12:19, Mauro Carvalho Chehab wrote:
> Convert #defines to enums and add kernel-doc markups for V4L2
> video_device flags.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  include/media/v4l2-dev.h | 25 ++++++++++++++++++-------
>  1 file changed, 18 insertions(+), 7 deletions(-)
> 
> diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
> index 87dac58c7799..33a5256232f8 100644
> --- a/include/media/v4l2-dev.h
> +++ b/include/media/v4l2-dev.h
> @@ -61,12 +61,22 @@ struct video_device;
>  struct v4l2_device;
>  struct v4l2_ctrl_handler;
>  
> -/* Flag to mark the video_device struct as registered.
> -   Drivers can clear this flag if they want to block all future
> -   device access. It is cleared by video_unregister_device. */
> -#define V4L2_FL_REGISTERED	(0)
> -/* file->private_data points to struct v4l2_fh */
> -#define V4L2_FL_USES_V4L2_FH	(1)
> +/**
> + * enum v4l2_video_device_flags - Flags used by &struct video_device
> + *
> + * @V4L2_FL_REGISTERED:
> + * 	indicates that a &struct video_device is registered.
> + *	Drivers can clear this flag if they want to block all future
> + *	device access. It is cleared by video_unregister_device.
> + * @V4L2_FL_USES_V4L2_FH:
> + *	indicates that file->private_data points to &struct v4l2_fh.
> + *	This flag is set by the core when v4l2_fh_init() is called.
> + *	All new drivers should use it.
> + */
> +enum v4l2_video_device_flags {
> +	V4L2_FL_REGISTERED	= 0,
> +	V4L2_FL_USES_V4L2_FH	= 1,
> +};
>  
>  /* Priority helper functions */
>  
> @@ -214,7 +224,8 @@ struct v4l2_file_operations {
>   * @vfl_dir: V4L receiver, transmitter or m2m
>   * @minor: device node 'minor'. It is set to -1 if the registration failed
>   * @num: number of the video device node
> - * @flags: video device flags. Use bitops to set/clear/test flags
> + * @flags: video device flags. Use bitops to set/clear/test flags.
> + *	   Contains a set of &enum v4l2_video_device_flags.
>   * @index: attribute to differentiate multiple indices on one physical device
>   * @fh_lock: Lock for all v4l2_fhs
>   * @fh_list: List of &struct v4l2_fh
> 
