Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:45105 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721Ab2FKHtV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jun 2012 03:49:21 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] v4l: Remove __user from interface structure definitions
Date: Mon, 11 Jun 2012 09:49:25 +0200
Message-ID: <2510696.MjJJuAAVnT@avalon>
In-Reply-To: <1338062869-23922-1-git-send-email-sakari.ailus@iki.fi>
References: <1338062869-23922-1-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Saturday 26 May 2012 23:07:49 Sakari Ailus wrote:
> The __user macro is not strictly needed in videodev2.h, and it also prevents
> using the header file as such in the user space. __user is already not used
> in many of the interface structs containing pointers.
> 
> Stop using __user in videodev2.h.

Please don't. __user is useful. You should not use kernel headers as-is in 
userspace, they need to be installed use make headers_install first.

> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> ---
>  include/linux/videodev2.h |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index 370d111..c8e1bb0 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -708,16 +708,16 @@ struct v4l2_framebuffer {
> 
>  struct v4l2_clip {
>  	struct v4l2_rect        c;
> -	struct v4l2_clip	__user *next;
> +	struct v4l2_clip	*next;
>  };
> 
>  struct v4l2_window {
>  	struct v4l2_rect        w;
>  	__u32			field;	 /* enum v4l2_field */
>  	__u32			chromakey;
> -	struct v4l2_clip	__user *clips;
> +	struct v4l2_clip	*clips;
>  	__u32			clipcount;
> -	void			__user *bitmap;
> +	void			*bitmap;
>  	__u8                    global_alpha;
>  };

-- 
Regards,

Laurent Pinchart

