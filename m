Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:42961 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783AbbAGMOK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Jan 2015 07:14:10 -0500
Date: Wed, 7 Jan 2015 10:14:02 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Joe Perches <joe@perches.com>,
	Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: Re: [PATCHv3 10/20] cx25840: fill the media controller entity
Message-ID: <20150107101402.7928fdc3@concha.lan>
In-Reply-To: <CA+V-a8sJzqbM5T-pRJ-gkZq-0HPDqG4MxO5DRUZy_GwMU-QKkQ@mail.gmail.com>
References: <cover.1420578087.git.mchehab@osg.samsung.com>
	<f312c9563615f8f5666c1621a20d3fa07831ae89.1420578087.git.mchehab@osg.samsung.com>
	<CA+V-a8sJzqbM5T-pRJ-gkZq-0HPDqG4MxO5DRUZy_GwMU-QKkQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Prabhakar,

Em Wed, 7 Jan 2015 11:44:08 +0000
Prabhakar Lad <prabhakar.csengg@gmail.com> escreveu:

> Hi Mauro,
> 
> Thanks for the patch.

Thanks for review.

> On Tue, Jan 6, 2015 at 9:08 PM, Mauro Carvalho Chehab
> <mchehab@osg.samsung.com> wrote:
> > Instead of keeping the media controller entity not initialized,
> > fill it and create the pads for cx25840.
> >
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> >
> > diff --git a/drivers/media/i2c/cx25840/cx25840-core.c b/drivers/media/i2c/cx25840/cx25840-core.c
> > index 573e08826b9b..bdb5bb6b58da 100644
> > --- a/drivers/media/i2c/cx25840/cx25840-core.c
> > +++ b/drivers/media/i2c/cx25840/cx25840-core.c
> > @@ -5137,6 +5137,9 @@ static int cx25840_probe(struct i2c_client *client,
> >         int default_volume;
> >         u32 id;
> >         u16 device_id;
> > +#if defined(CONFIG_MEDIA_CONTROLLER)
> > +       int ret;
> > +#endif
> >
> >         /* Check if the adapter supports the needed features */
> >         if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DATA))
> > @@ -5178,6 +5181,21 @@ static int cx25840_probe(struct i2c_client *client,
> >
> >         sd = &state->sd;
> >         v4l2_i2c_subdev_init(sd, client, &cx25840_ops);
> > +#if defined(CONFIG_MEDIA_CONTROLLER)
> > +       /* TODO: need to represent analog inputs too */
> > +       state->pads[0].flags = MEDIA_PAD_FL_SINK;       /* Tuner or input */
> 
>  | MEDIA_PAD_FL_MUST_CONNECT ?

Maybe. Currently, only omap3 uses this flag. Not sure what difference
it will make.

> > +       state->pads[1].flags = MEDIA_PAD_FL_SOURCE;     /* Video */
> > +       state->pads[2].flags = MEDIA_PAD_FL_SOURCE;     /* VBI */
> 
> Macros for 0,1,2, and 3 would make it more readable.

Yes, but IMHO the best would be to add those macros on some global place,
as all analog demod PADs will look the same: one sync to connect to the
tuner and two PADs, one for video stream and another one for VBI.
A few decoders may have an additional PAD for sliced-VBI.

Doing such definition globally helps to support drivers like em28xx,
where, depending on the board, there are several different alternatives
for the demod, all providing the very same 3 pads.

> > +       sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV_DECODER;
> > +
> > +       ret = media_entity_init(&sd->entity, ARRAY_SIZE(state->pads),
> > +                               state->pads, 0);
> > +       if (ret < 0) {
> > +               v4l_info(client, "failed to initialize media entity!\n");
> > +               kfree(state);
> Not required.

Why not? state were allocated previously in this function. If we don't free
it, it will have a memory leak.

> 
> > +               return -ENODEV;
> return ret; instead ?


Yeah, makes sense. I'll fix that on a next spin of the patch.
> 
> Thanks,
> --Prabhakar Lad


-- 

Cheers,
Mauro
