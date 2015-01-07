Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:57839 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625AbbAGLoj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Jan 2015 06:44:39 -0500
Received: by mail-pa0-f48.google.com with SMTP id rd3so4402204pab.7
        for <linux-media@vger.kernel.org>; Wed, 07 Jan 2015 03:44:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <f312c9563615f8f5666c1621a20d3fa07831ae89.1420578087.git.mchehab@osg.samsung.com>
References: <cover.1420578087.git.mchehab@osg.samsung.com> <f312c9563615f8f5666c1621a20d3fa07831ae89.1420578087.git.mchehab@osg.samsung.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Wed, 7 Jan 2015 11:44:08 +0000
Message-ID: <CA+V-a8sJzqbM5T-pRJ-gkZq-0HPDqG4MxO5DRUZy_GwMU-QKkQ@mail.gmail.com>
Subject: Re: [PATCHv3 10/20] cx25840: fill the media controller entity
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Joe Perches <joe@perches.com>,
	Boris BREZILLON <boris.brezillon@free-electrons.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Thanks for the patch.

On Tue, Jan 6, 2015 at 9:08 PM, Mauro Carvalho Chehab
<mchehab@osg.samsung.com> wrote:
> Instead of keeping the media controller entity not initialized,
> fill it and create the pads for cx25840.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>
> diff --git a/drivers/media/i2c/cx25840/cx25840-core.c b/drivers/media/i2c/cx25840/cx25840-core.c
> index 573e08826b9b..bdb5bb6b58da 100644
> --- a/drivers/media/i2c/cx25840/cx25840-core.c
> +++ b/drivers/media/i2c/cx25840/cx25840-core.c
> @@ -5137,6 +5137,9 @@ static int cx25840_probe(struct i2c_client *client,
>         int default_volume;
>         u32 id;
>         u16 device_id;
> +#if defined(CONFIG_MEDIA_CONTROLLER)
> +       int ret;
> +#endif
>
>         /* Check if the adapter supports the needed features */
>         if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DATA))
> @@ -5178,6 +5181,21 @@ static int cx25840_probe(struct i2c_client *client,
>
>         sd = &state->sd;
>         v4l2_i2c_subdev_init(sd, client, &cx25840_ops);
> +#if defined(CONFIG_MEDIA_CONTROLLER)
> +       /* TODO: need to represent analog inputs too */
> +       state->pads[0].flags = MEDIA_PAD_FL_SINK;       /* Tuner or input */

 | MEDIA_PAD_FL_MUST_CONNECT ?

> +       state->pads[1].flags = MEDIA_PAD_FL_SOURCE;     /* Video */
> +       state->pads[2].flags = MEDIA_PAD_FL_SOURCE;     /* VBI */

Macros for 0,1,2, and 3 would make it more readable.

> +       sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV_DECODER;
> +
> +       ret = media_entity_init(&sd->entity, ARRAY_SIZE(state->pads),
> +                               state->pads, 0);
> +       if (ret < 0) {
> +               v4l_info(client, "failed to initialize media entity!\n");
> +               kfree(state);
Not required.

> +               return -ENODEV;
return ret; instead ?

Thanks,
--Prabhakar Lad
