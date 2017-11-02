Return-path: <linux-media-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:4595 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934168AbdKBDEU (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 1 Nov 2017 23:04:20 -0400
Subject: Re: [PATCH] media: atmel-isc: get rid of an unused var
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Songjun Wu <songjun.wu@microchip.com>
References: <ec62464e83beacd8b8856e8313a4cae4a91ea90b.1509442643.git.mchehab@s-opensource.com>
From: "Yang, Wenyou" <Wenyou.Yang@Microchip.com>
Message-ID: <8c997a12-2f85-ad32-88dc-1e6d196833d7@Microchip.com>
Date: Thu, 2 Nov 2017 11:04:15 +0800
MIME-Version: 1.0
In-Reply-To: <ec62464e83beacd8b8856e8313a4cae4a91ea90b.1509442643.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 2017/10/31 17:37, Mauro Carvalho Chehab wrote:
> drivers/media/platform/atmel/atmel-isc.c: In function 'isc_async_complete':
> drivers/media/platform/atmel/atmel-isc.c:1900:28: warning: variable 'sd_entity' set but not used [-Wunused-but-set-variable]
>    struct isc_subdev_entity *sd_entity;
>                              ^~~~~~~~~
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Acked-by: Wenyou Yang <wenyou.yang@microchip.com>

> ---
>   drivers/media/platform/atmel/atmel-isc.c | 3 ---
>   1 file changed, 3 deletions(-)
>
> diff --git a/drivers/media/platform/atmel/atmel-isc.c b/drivers/media/platform/atmel/atmel-isc.c
> index 2c40a7886542..8b37656f035d 100644
> --- a/drivers/media/platform/atmel/atmel-isc.c
> +++ b/drivers/media/platform/atmel/atmel-isc.c
> @@ -1897,7 +1897,6 @@ static int isc_async_complete(struct v4l2_async_notifier *notifier)
>   {
>   	struct isc_device *isc = container_of(notifier->v4l2_dev,
>   					      struct isc_device, v4l2_dev);
> -	struct isc_subdev_entity *sd_entity;
>   	struct video_device *vdev = &isc->video_dev;
>   	struct vb2_queue *q = &isc->vb2_vidq;
>   	int ret;
> @@ -1910,8 +1909,6 @@ static int isc_async_complete(struct v4l2_async_notifier *notifier)
>   
>   	isc->current_subdev = container_of(notifier,
>   					   struct isc_subdev_entity, notifier);
> -	sd_entity = isc->current_subdev;
> -
>   	mutex_init(&isc->lock);
>   	init_completion(&isc->comp);
>   

Best Regards,
Wenyou Yang
