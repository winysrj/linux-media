Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:34860 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932963AbcA2SWZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jan 2016 13:22:25 -0500
Subject: Re: [PATCH 11/13] [media] tvp5150: identify it as a
 MEDIA_ENT_F_ATV_DECODER
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <cover.1454067262.git.mchehab@osg.samsung.com>
 <c1252a1287c86a763b72458e3d8619c23b5d0eaf.1454067262.git.mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Eduard Gavin <egavinc@gmail.com>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Message-ID: <56ABADDB.4080701@osg.samsung.com>
Date: Fri, 29 Jan 2016 15:22:19 -0300
MIME-Version: 1.0
In-Reply-To: <c1252a1287c86a763b72458e3d8619c23b5d0eaf.1454067262.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro,

On 01/29/2016 09:11 AM, Mauro Carvalho Chehab wrote:
> The tvp5150 is an analog TV decoder. Identify as such at
> the media graph, or otherwise devices using it would fail.
>
> That avoids the following warning:
> 	[ 1546.669139] usb 2-3.3: Entity type for entity tvp5150 5-005c was not initialized!
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> ---
>   drivers/media/i2c/tvp5150.c | 3 +++
>   1 file changed, 3 insertions(+)
>
> diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
> index 20428f052506..19b52736b24e 100644
> --- a/drivers/media/i2c/tvp5150.c
> +++ b/drivers/media/i2c/tvp5150.c
> @@ -1319,6 +1319,9 @@ static int tvp5150_probe(struct i2c_client *c,
>   	core->pads[DEMOD_PAD_IF_INPUT].flags = MEDIA_PAD_FL_SINK;
>   	core->pads[DEMOD_PAD_VID_OUT].flags = MEDIA_PAD_FL_SOURCE;
>   	core->pads[DEMOD_PAD_VBI_OUT].flags = MEDIA_PAD_FL_SOURCE;
> +
> +	sd->entity.function = MEDIA_ENT_F_ATV_DECODER;
> +
>   	res = media_entity_pads_init(&sd->entity, DEMOD_NUM_PADS, core->pads);
>   	if (res < 0)
>   		return res;
>

Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
