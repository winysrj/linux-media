Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:39587 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843AbcCXIlL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Mar 2016 04:41:11 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 3/4] [media] media-device: get rid of a leftover comment
Date: Thu, 24 Mar 2016 10:41:12 +0200
Message-ID: <2402948.hqpVnj68aO@avalon>
In-Reply-To: <90a95b96574f87c87a7a101926aa8c4cd5f74139.1458760750.git.mchehab@osg.samsung.com>
References: <cover.1458760750.git.mchehab@osg.samsung.com> <90a95b96574f87c87a7a101926aa8c4cd5f74139.1458760750.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 23 Mar 2016 16:27:45 Mauro Carvalho Chehab wrote:
> The comment there is not pertinent.
> 
> Fixes: 44ff16d0b7cc ("media-device: use kref for media_device instance")
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> Suggested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/media-device.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> index 4b5a2ab17b7e..10cc4766de10 100644
> --- a/drivers/media/media-device.c
> +++ b/drivers/media/media-device.c
> @@ -720,7 +720,6 @@ int __must_check __media_device_register(struct
> media_device *mdev, {
>  	int ret;
> 
> -	/* Check if mdev was ever registered at all */
>  	mutex_lock(&mdev->graph_mutex);
> 
>  	/* Register the device node. */

-- 
Regards,

Laurent Pinchart

