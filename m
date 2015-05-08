Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:16019 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203AbbEHNv0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 May 2015 09:51:26 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0NO1001Y0AHNL910@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 08 May 2015 14:51:23 +0100 (BST)
Message-id: <554CBF54.4050000@samsung.com>
Date: Fri, 08 May 2015 15:51:16 +0200
From: Andrzej Hajda <a.hajda@samsung.com>
MIME-version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 13/18] s5k5baf: fix subdev type
References: <cover.1431046915.git.mchehab@osg.samsung.com>
 <d37f5695458429869abaae3f7974d296c3fa8349.1431046915.git.mchehab@osg.samsung.com>
In-reply-to: <d37f5695458429869abaae3f7974d296c3fa8349.1431046915.git.mchehab@osg.samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On 05/08/2015 03:12 AM, Mauro Carvalho Chehab wrote:
> This sensor driver is abusing MEDIA_ENT_T_V4L2_SUBDEV, creating
> some subdevs with a non-existing type.
>
> As this is a sensor driver, the proper type is likely
> MEDIA_ENT_T_CAM_SENSOR.

This driver exposes two media entities:
- pure camera sensor, it has type
MEDIA_ENT_T_V4L2_SUBDEV_SENSOR/MEDIA_ENT_T_CAM_SENSOR,
- image processing entity, I have assigned to it MEDIA_ENT_T_V4L2_SUBDEV
type,
as there were no better option.
Maybe it would be better to introduce another define for such entities,
for example MEDIA_ENT_T_CAM_ISP?
The same applies to s5c73m3 driver.

Anyway this patch breaks current code as type field is used internally
to distinguish both entities in subdev callbacks  -
s5k5baf_is_cis_subdev function.
Of course the function can be rewritten if necessary.

Regards
Andrzej

>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>
> diff --git a/drivers/media/i2c/s5k5baf.c b/drivers/media/i2c/s5k5baf.c
> index fadd48d35a55..8373552847ab 100644
> --- a/drivers/media/i2c/s5k5baf.c
> +++ b/drivers/media/i2c/s5k5baf.c
> @@ -1919,7 +1919,7 @@ static int s5k5baf_configure_subdevs(struct s5k5baf *state,
>  
>  	state->pads[PAD_CIS].flags = MEDIA_PAD_FL_SINK;
>  	state->pads[PAD_OUT].flags = MEDIA_PAD_FL_SOURCE;
> -	sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV;
> +	sd->entity.type = MEDIA_ENT_T_CAM_SENSOR;
>  	ret = media_entity_init(&sd->entity, NUM_ISP_PADS, state->pads, 0);
>  
>  	if (!ret)

