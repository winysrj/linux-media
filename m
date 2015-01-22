Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:57686 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750754AbbAVPPO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Jan 2015 10:15:14 -0500
Message-ID: <54C113C1.7020701@xs4all.nl>
Date: Thu, 22 Jan 2015 16:14:09 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
CC: sadegh abbasi <sadegh612000@yahoo.co.uk>
Subject: Re: [PATCH 5/7] Revert "[media] v4l: omap4iss: Add module debug parameter"
References: <1421938126-17747-1-git-send-email-laurent.pinchart@ideasonboard.com> <1421938126-17747-6-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1421938126-17747-6-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/22/15 15:48, Laurent Pinchart wrote:
> This reverts commit 186612342500b0af8498d7c8bc6b3ac32ac7a48e.
> 
> The video_device debug field has been renamed to dev_debug, resulting in
> a compilation failure. As v4l2 debugging is supposed to be controlled
> through a sysfs attribute created by the v4l2 core, there's no need to
> duplicate debug control through a module parameter. Remove it.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Oops!

Fixed the daily build so that the omap4 driver is now compiled.

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  drivers/staging/media/omap4iss/iss_video.c | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/drivers/staging/media/omap4iss/iss_video.c b/drivers/staging/media/omap4iss/iss_video.c
> index 2085f69..6955044 100644
> --- a/drivers/staging/media/omap4iss/iss_video.c
> +++ b/drivers/staging/media/omap4iss/iss_video.c
> @@ -25,9 +25,6 @@
>  #include "iss_video.h"
>  #include "iss.h"
>  
> -static unsigned debug;
> -module_param(debug, uint, 0644);
> -MODULE_PARM_DESC(debug, "activates debug info");
>  
>  /* -----------------------------------------------------------------------------
>   * Helper functions
> @@ -1053,8 +1050,6 @@ static int iss_video_open(struct file *file)
>  	if (handle == NULL)
>  		return -ENOMEM;
>  
> -	video->video.debug = debug;
> -
>  	v4l2_fh_init(&handle->vfh, &video->video);
>  	v4l2_fh_add(&handle->vfh);
>  
> 

