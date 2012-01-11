Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:46965 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862Ab2AKOeH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jan 2012 09:34:07 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC/PATCH 2/3] uvcvideo: Return -ENOTTY in case of unknown ioctl
Date: Wed, 11 Jan 2012 15:34:01 +0100
Cc: linux-media@vger.kernel.org
References: <1324252546-18437-1-git-send-email-laurent.pinchart@ideasonboard.com> <1324252546-18437-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1324252546-18437-3-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201201111534.01406.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 19 December 2011 00:55:45 Laurent Pinchart wrote:
> -EINVAL is the wrong error code in that case, replace it with -ENOTTY.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>

> ---
>  drivers/media/video/uvc/uvc_v4l2.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/uvc/uvc_v4l2.c
> b/drivers/media/video/uvc/uvc_v4l2.c index 2ae4f88..f09ee8b 100644
> --- a/drivers/media/video/uvc/uvc_v4l2.c
> +++ b/drivers/media/video/uvc/uvc_v4l2.c
> @@ -1012,7 +1012,7 @@ static long uvc_v4l2_do_ioctl(struct file *file,
> unsigned int cmd, void *arg)
> 
>  	default:
>  		uvc_trace(UVC_TRACE_IOCTL, "Unknown ioctl 0x%08x\n", cmd);
> -		return -EINVAL;
> +		return -ENOTTY;
>  	}
> 
>  	return ret;
