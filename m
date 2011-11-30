Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:48963 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754661Ab1K3BWi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Nov 2011 20:22:38 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Haogang Chen <haogangchen@gmail.com>
Subject: Re: [PATCH] Media: video: uvc: integer overflow in uvc_ioctl_ctrl_map()
Date: Wed, 30 Nov 2011 02:22:32 +0100
Cc: mchehab@infradead.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1322602345-26279-1-git-send-email-haogangchen@gmail.com>
In-Reply-To: <1322602345-26279-1-git-send-email-haogangchen@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201111300222.42162.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Haogang,

On Tuesday 29 November 2011 22:32:25 Haogang Chen wrote:
> There is a potential integer overflow in uvc_ioctl_ctrl_map(). When a
> large xmap->menu_count is passed from the userspace, the subsequent call
> to kmalloc() will allocate a buffer smaller than expected.
> map->menu_count and map->menu_info would later be used in a loop (e.g.
> in uvc_query_v4l2_ctrl), which leads to out-of-bound access.
> 
> The patch checks the ioctl argument and returns -EINVAL for zero or too
> large values in xmap->menu_count.

Thanks for the patch.

> Signed-off-by: Haogang Chen <haogangchen@gmail.com>
> ---
>  drivers/media/video/uvc/uvc_v4l2.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/uvc/uvc_v4l2.c
> b/drivers/media/video/uvc/uvc_v4l2.c index dadf11f..9a180d6 100644
> --- a/drivers/media/video/uvc/uvc_v4l2.c
> +++ b/drivers/media/video/uvc/uvc_v4l2.c
> @@ -58,6 +58,12 @@ static int uvc_ioctl_ctrl_map(struct uvc_video_chain
> *chain, break;
> 
>  	case V4L2_CTRL_TYPE_MENU:
> +		if (xmap->menu_count == 0 ||
> +		    xmap->menu_count > INT_MAX / sizeof(*map->menu_info)) {

I'd like to prevent excessive memory consumption by limiting the number of 
menu entries, similarly to how the driver limits the number of mappings. 
Defining UVC_MAX_CONTROL_MENU_ENTRIES to 32 in uvcvideo.h should be a 
reasonable value.

> +			kfree(map);
> +			return -EINVAL;

I'd rather do

	ret = -EINVAL;
	goto done;

to centralize error handling.

If you're fine with both changes I can modify the patch, there's no need to 
resubmit.

> +		}
> +
>  		size = xmap->menu_count * sizeof(*map->menu_info);
>  		map->menu_info = kmalloc(size, GFP_KERNEL);
>  		if (map->menu_info == NULL) {

-- 
Regards,

Laurent Pinchart
