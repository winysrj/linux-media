Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:46555 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754107AbdGUSVL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Jul 2017 14:21:11 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sylwester Nawrocki <snawrocki@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv2 1/5] media-device: set driver_version directly
Date: Fri, 21 Jul 2017 21:21:18 +0300
Message-ID: <46898907.CNK0lmMHIT@avalon>
In-Reply-To: <20170721105706.40703-2-hverkuil@xs4all.nl>
References: <20170721105706.40703-1-hverkuil@xs4all.nl> <20170721105706.40703-2-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patch.

On Friday 21 Jul 2017 12:57:02 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Don't use driver_version from struct media_device, just return
> LINUX_VERSION_CODE as the other media subsystems do.
> 
> The driver_version field in struct media_device will be removed
> in the following patches.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/media-device.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> index fce91b543c14..7ff8e2d5bb07 100644
> --- a/drivers/media/media-device.c
> +++ b/drivers/media/media-device.c
> @@ -71,7 +71,7 @@ static int media_device_get_info(struct media_device *dev,
> 
>  	info->media_version = MEDIA_API_VERSION;
>  	info->hw_revision = dev->hw_revision;
> -	info->driver_version = dev->driver_version;
> +	info->driver_version = LINUX_VERSION_CODE;
> 
>  	return 0;
>  }

-- 
Regards,

Laurent Pinchart
