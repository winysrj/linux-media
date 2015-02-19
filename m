Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33441 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308AbbBSVuY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Feb 2015 16:50:24 -0500
Date: Thu, 19 Feb 2015 19:50:20 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Joe Perches <joe@perches.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: Re: [PATCHv4 16/25] [media] cx25840: fill the media controller
 entity
Message-ID: <20150219195020.0dfbb1ce@recife.lan>
In-Reply-To: <20150219175007.6098ae32@recife.lan>
References: <cover.1423867976.git.mchehab@osg.samsung.com>
	<6e028daf7da0bb15af4ff03290a2a67b7b35515c.1423867976.git.mchehab@osg.samsung.com>
	<CA+V-a8tiGyPMfUgdknC=3q2mZUjCsTvfcaP_O7HwCVucA_xYNA@mail.gmail.com>
	<20150219175007.6098ae32@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 19 Feb 2015 17:50:07 -0200
Mauro Carvalho Chehab <mchehab@osg.samsung.com> escreveu:

> Em Wed, 18 Feb 2015 22:48:04 +0000
> "Lad, Prabhakar" <prabhakar.csengg@gmail.com> escreveu:
> 
> > Hi Mauro,
> > 
> > Thanks for the patch.
> 
> Thanks for the review.
> > 
> > On Fri, Feb 13, 2015 at 10:57 PM, Mauro Carvalho Chehab
> > <mchehab@osg.samsung.com> wrote:
> > > Instead of keeping the media controller entity not initialized,
> > > fill it and create the pads for cx25840.
> > >
> > > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> > >
> > > diff --git a/drivers/media/i2c/cx25840/cx25840-core.c b/drivers/media/i2c/cx25840/cx25840-core.c
> > > index 573e08826b9b..bdb5bb6b58da 100644
> > > --- a/drivers/media/i2c/cx25840/cx25840-core.c
> > > +++ b/drivers/media/i2c/cx25840/cx25840-core.c
> > > @@ -5137,6 +5137,9 @@ static int cx25840_probe(struct i2c_client *client,
> > >         int default_volume;
> > >         u32 id;
> > >         u16 device_id;
> > > +#if defined(CONFIG_MEDIA_CONTROLLER)
> > > +       int ret;
> > > +#endif
> > >
> > >         /* Check if the adapter supports the needed features */
> > >         if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DATA))
> > > @@ -5178,6 +5181,21 @@ static int cx25840_probe(struct i2c_client *client,
> > >
> > >         sd = &state->sd;
> > >         v4l2_i2c_subdev_init(sd, client, &cx25840_ops);
> > > +#if defined(CONFIG_MEDIA_CONTROLLER)
> > > +       /* TODO: need to represent analog inputs too */
> > > +       state->pads[0].flags = MEDIA_PAD_FL_SINK;       /* Tuner or input */
> > > +       state->pads[1].flags = MEDIA_PAD_FL_SOURCE;     /* Video */
> > > +       state->pads[2].flags = MEDIA_PAD_FL_SOURCE;     /* VBI */
> > Macros for 0,1,2 would make it more readable.
> 
> I was in doubt, on weather use a macro or not for it. I ended by
> deciding to not use because the code shouldn't assume a particular order
> for the pads. Also, I'm not sure if is there a way to "taint" a PAD for
> VBI or Video, or if it is worth or not do do it.
> 
> So, the comments there are more a reminder than anything else.

On a second thought, indeed it seems better to use an enum here. Just
sent the patch.

Regards,
Mauro
