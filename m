Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59422 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756611Ab2IMKQo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Sep 2012 06:16:44 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv2 API PATCH 24/28] v4l2-dev: add new VFL_DIR_ defines.
Date: Thu, 13 Sep 2012 04:36:27 +0200
Message-ID: <3100048.RJKoMcdZ5k@avalon>
In-Reply-To: <e2043c0ca47cc3ed1fd45f62a6bce14e3ed5e2e8.1347023744.git.hans.verkuil@cisco.com>
References: <1347024568-32602-1-git-send-email-hverkuil@xs4all.nl> <e2043c0ca47cc3ed1fd45f62a6bce14e3ed5e2e8.1347023744.git.hans.verkuil@cisco.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the patch.

On Friday 07 September 2012 15:29:24 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> These will be used by v4l2-dev.c to improve ioctl checking.
> I.e. ioctls for capture should return -ENOTTY when called for
> an output device.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  include/media/v4l2-dev.h |    9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
> index 6ee8897..95d1c91 100644
> --- a/include/media/v4l2-dev.h
> +++ b/include/media/v4l2-dev.h
> @@ -26,6 +26,12 @@
>  #define VFL_TYPE_SUBDEV		3
>  #define VFL_TYPE_MAX		4
> 
> +/* Is this a receiver, transmitter or mem-to-mem? */
> +/* Ignored for VFL_TYPE_SUBDEV. */
> +#define VFL_DIR_RX		0
> +#define VFL_DIR_TX		1
> +#define VFL_DIR_M2M		2
> +

Wouldn't VFL_DIR_CAPTURE and VFL_DIR_OUTPUT sound more familiar ?

>  struct v4l2_ioctl_callbacks;
>  struct video_device;
>  struct v4l2_device;
> @@ -105,7 +111,8 @@ struct video_device
> 
>  	/* device info */
>  	char name[32];
> -	int vfl_type;
> +	int vfl_type;	/* device type */
> +	int vfl_dir;	/* receiver, transmitter or m2m */

Would combining vfl_dir with vfl_type using bitflags be an option ? The 
direction is somehow part of (or closely related to) the type.

>  	/* 'minor' is set to -1 if the registration failed */
>  	int minor;
>  	u16 num;

-- 
Regards,

Laurent Pinchart

