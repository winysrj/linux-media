Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:56258 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817AbbLFBzT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Dec 2015 20:55:19 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Andrzej Hajda <a.hajda@samsung.com>
Subject: Re: [PATCH v8 35/55] [media] s5k5baf: fix subdev type
Date: Sun, 06 Dec 2015 03:55:32 +0200
Message-ID: <2154292.e5cNedqy2f@avalon>
In-Reply-To: <7ed3721139e459f5dd4cdd05bd1e58f248fc0781.1440902901.git.mchehab@osg.samsung.com>
References: <cover.1440902901.git.mchehab@osg.samsung.com> <7ed3721139e459f5dd4cdd05bd1e58f248fc0781.1440902901.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Thank you for the patch.

On Sunday 30 August 2015 00:06:46 Mauro Carvalho Chehab wrote:
> X-Patchwork-Delegate: m.chehab@samsung.com
> This sensor driver is abusing MEDIA_ENT_T_V4L2_SUBDEV, creating
> some subdevs with a non-existing type.
> 
> As this is a sensor driver, the proper type is likely
> MEDIA_ENT_T_V4L2_SUBDEV_SENSOR.

That's actually not correct. The driver creates two subdevs, one for the image 
sensor pixel array (and the related readout logic) and one for an ISP. The 
first subdev already uses the MEDIA_ENT_T_V4L2_SUBDEV_SENSOR type, but the 
second subdev isn't a sensor pixel array.

> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
> diff --git a/drivers/media/i2c/s5k5baf.c b/drivers/media/i2c/s5k5baf.c
> index d3bff30bcb6f..0513196bd48c 100644
> --- a/drivers/media/i2c/s5k5baf.c
> +++ b/drivers/media/i2c/s5k5baf.c
> @@ -1919,7 +1919,7 @@ static int s5k5baf_configure_subdevs(struct s5k5baf
> *state,
> 
>  	state->pads[PAD_CIS].flags = MEDIA_PAD_FL_SINK;
>  	state->pads[PAD_OUT].flags = MEDIA_PAD_FL_SOURCE;
> -	sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV;
> +	sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV_SENSOR;
>  	ret = media_entity_init(&sd->entity, NUM_ISP_PADS, state->pads);
> 
>  	if (!ret)

-- 
Regards,

Laurent Pinchart

