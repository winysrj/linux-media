Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:39586 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbcCXIke (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Mar 2016 04:40:34 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 1/4] [media] media-device: Simplify compat32 logic
Date: Thu, 24 Mar 2016 10:40:33 +0200
Message-ID: <1719837.HF58P2gl46@avalon>
In-Reply-To: <442844a1add7446a8d5d2d91229fc0f043363381.1458760750.git.mchehab@osg.samsung.com>
References: <cover.1458760750.git.mchehab@osg.samsung.com> <442844a1add7446a8d5d2d91229fc0f043363381.1458760750.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 23 Mar 2016 16:27:43 Mauro Carvalho Chehab wrote:
> Only MEDIA_IOC_ENUM_LINKS32 require an special logic when
> userspace is 32 bits and Kernel is 64 bits.
> 
> For the rest, media_device_ioctl() will do the right thing,
> and will return -ENOIOCTLCMD if the ioctl is unknown.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> ---
>  drivers/media/media-device.c | 8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)
> 
> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> index 4a97d92a7e7d..4b5a2ab17b7e 100644
> --- a/drivers/media/media-device.c
> +++ b/drivers/media/media-device.c
> @@ -508,10 +508,7 @@ static long media_device_compat_ioctl(struct file
> *filp, unsigned int cmd, long ret;
> 
>  	switch (cmd) {
> -	case MEDIA_IOC_DEVICE_INFO:
> -	case MEDIA_IOC_ENUM_ENTITIES:
> -	case MEDIA_IOC_SETUP_LINK:
> -	case MEDIA_IOC_G_TOPOLOGY:
> +	default:
>  		return media_device_ioctl(filp, cmd, arg);

I'd move the default case last as done usually. Apart from that,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> 
>  	case MEDIA_IOC_ENUM_LINKS32:
> @@ -520,9 +517,6 @@ static long media_device_compat_ioctl(struct file *filp,
> unsigned int cmd, (struct media_links_enum32 __user *)arg);
>  		mutex_unlock(&dev->graph_mutex);
>  		break;
> -
> -	default:
> -		ret = -ENOIOCTLCMD;
>  	}
> 
>  	return ret;

-- 
Regards,

Laurent Pinchart

