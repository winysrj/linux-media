Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:57314 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751571AbbBRPkF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Feb 2015 10:40:05 -0500
Message-ID: <54E4B23F.3010106@xs4all.nl>
Date: Wed, 18 Feb 2015 16:39:43 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Boris BREZILLON <boris.brezillon@free-electrons.com>,
	Ramakrishnan Muthukrishnan <ramakrmu@cisco.com>,
	Peter Senna Tschudin <peter.senna@gmail.com>
Subject: Re: [PATCH 6/7] [media] cx231xx: Improve the media controller comment
References: <110dcdca23da9714db1a2d95800abc4c9d33b512.1424273378.git.mchehab@osg.samsung.com> <8b03c5e79532023025ba18649aecd334e36a6f14.1424273378.git.mchehab@osg.samsung.com>
In-Reply-To: <8b03c5e79532023025ba18649aecd334e36a6f14.1424273378.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/18/2015 04:30 PM, Mauro Carvalho Chehab wrote:
> There are two problems at the comment:
> - it is badly idented;
> - its comment doesn't mean anything.
> 
> Fix it.
> 
> Requested-by: Hans Verkuil <hverkuil@xs4all.nl>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
> diff --git a/drivers/media/usb/cx231xx/cx231xx-video.c b/drivers/media/usb/cx231xx/cx231xx-video.c
> index 634763535d60..87c9e27505f4 100644
> --- a/drivers/media/usb/cx231xx/cx231xx-video.c
> +++ b/drivers/media/usb/cx231xx/cx231xx-video.c
> @@ -714,12 +714,13 @@ static int cx231xx_enable_analog_tuner(struct cx231xx *dev)
>  	if (!mdev)
>  		return 0;
>  
> -/*
> - * This will find the tuner that it is connected into the decoder.
> - * Technically, this is not 100% correct, as the device may be using an
> - * analog input instead of the tuner. However, we can't use the DVB for dvb
> - * while the DMA engine is being used for V4L2.
> - */
> +	/*
> +	 * This will find the tuner that it is connected into the decoder.

s/that it is/that is/

> +	 * Technically, this is not 100% correct, as the device may be
> +	 * using an analog input instead of the tuner. However, as we can't
> +	 * do DVB streaming  while the DMA engine is being used for V4L2,

Two spaces between 'streaming' and 'while'. I know, a nitpick :-)

With those changes:

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> +	 * this should be enough for the actual needs.
> +	 */
>  	media_device_for_each_entity(entity, mdev) {
>  		if (entity->type == MEDIA_ENT_T_V4L2_SUBDEV_DECODER) {
>  			decoder = entity;
> 

