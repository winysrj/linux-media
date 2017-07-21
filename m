Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:35509 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750794AbdGULGl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Jul 2017 07:06:41 -0400
Subject: Re: [PATCHv2 1/5] media-device: set driver_version directly
To: linux-media@vger.kernel.org
References: <20170721105706.40703-1-hverkuil@xs4all.nl>
 <20170721105706.40703-2-hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sylwester Nawrocki <snawrocki@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <aba5357e-5039-ed75-1ea1-1da76bfb6590@xs4all.nl>
Date: Fri, 21 Jul 2017 13:06:38 +0200
MIME-Version: 1.0
In-Reply-To: <20170721105706.40703-2-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 21/07/17 12:57, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Don't use driver_version from struct media_device, just return
> LINUX_VERSION_CODE as the other media subsystems do.
> 
> The driver_version field in struct media_device will be removed
> in the following patches.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
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

Related question about media_version: would it make sense to change this to
LINUX_VERSION_CODE as well? This too has never been changed from when it was
first introduced, making it pointless as a way for applications to detect
when features were added.

Unfortunately MEDIA_API_VERSION is defined in the public media.h header, but
we can mark it unused. This define isn't documented in the spec, BTW.

Regards,

	Hans

>  	info->hw_revision = dev->hw_revision;
> -	info->driver_version = dev->driver_version;
> +	info->driver_version = LINUX_VERSION_CODE;
>  
>  	return 0;
>  }
> 
