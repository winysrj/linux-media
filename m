Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:45380 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751882AbbBSTuN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Feb 2015 14:50:13 -0500
Date: Thu, 19 Feb 2015 17:50:07 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Joe Perches <joe@perches.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: Re: [PATCHv4 16/25] [media] cx25840: fill the media controller
 entity
Message-ID: <20150219175007.6098ae32@recife.lan>
In-Reply-To: <CA+V-a8tiGyPMfUgdknC=3q2mZUjCsTvfcaP_O7HwCVucA_xYNA@mail.gmail.com>
References: <cover.1423867976.git.mchehab@osg.samsung.com>
	<6e028daf7da0bb15af4ff03290a2a67b7b35515c.1423867976.git.mchehab@osg.samsung.com>
	<CA+V-a8tiGyPMfUgdknC=3q2mZUjCsTvfcaP_O7HwCVucA_xYNA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 18 Feb 2015 22:48:04 +0000
"Lad, Prabhakar" <prabhakar.csengg@gmail.com> escreveu:

> Hi Mauro,
> 
> Thanks for the patch.

Thanks for the review.
> 
> On Fri, Feb 13, 2015 at 10:57 PM, Mauro Carvalho Chehab
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
> > +       state->pads[1].flags = MEDIA_PAD_FL_SOURCE;     /* Video */
> > +       state->pads[2].flags = MEDIA_PAD_FL_SOURCE;     /* VBI */
> Macros for 0,1,2 would make it more readable.

I was in doubt, on weather use a macro or not for it. I ended by
deciding to not use because the code shouldn't assume a particular order
for the pads. Also, I'm not sure if is there a way to "taint" a PAD for
VBI or Video, or if it is worth or not do do it.

So, the comments there are more a reminder than anything else.

> 
> > +       sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV_DECODER;
> > +
> > +       ret = media_entity_init(&sd->entity, ARRAY_SIZE(state->pads),
> > +                               state->pads, 0);
> > +       if (ret < 0) {
> > +               v4l_info(client, "failed to initialize media entity!\n");
> > +               kfree(state);
> not needed as state is allocated using devm_kzalloc()
> 
> > +               return -ENODEV;
> return ret instead ?

Yeah, both comments make sense. I'll write a patch changing it.

> 
> > +       }
> > +#endif
> >
> >         switch (id) {
> >         case CX23885_AV:
> > diff --git a/drivers/media/i2c/cx25840/cx25840-core.h b/drivers/media/i2c/cx25840/cx25840-core.h
> > index 37bc04217c44..17b409f55445 100644
> > --- a/drivers/media/i2c/cx25840/cx25840-core.h
> > +++ b/drivers/media/i2c/cx25840/cx25840-core.h
> > @@ -64,6 +64,9 @@ struct cx25840_state {
> >         wait_queue_head_t fw_wait;    /* wake up when the fw load is finished */
> >         struct work_struct fw_work;   /* work entry for fw load */
> >         struct cx25840_ir_state *ir_state;
> > +#if defined(CONFIG_MEDIA_CONTROLLER)
> > +       struct media_pad        pads[3];
> Macro for 3 ?

Not much sense, as this is used only here. Ok, if we're adding an
enum (or defines) for the pads, then it makes sense to have an alias
for the number of pads.

Regards,
Mauro
