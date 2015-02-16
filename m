Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:60466 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755255AbbBPLLX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Feb 2015 06:11:23 -0500
Date: Mon, 16 Feb 2015 09:11:16 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Joe Perches <joe@perches.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: Re: [PATCHv4 16/25] [media] cx25840: fill the media controller
 entity
Message-ID: <20150216091116.6852bd1c@recife.lan>
In-Reply-To: <54E1B45F.3080000@xs4all.nl>
References: <cover.1423867976.git.mchehab@osg.samsung.com>
	<6e028daf7da0bb15af4ff03290a2a67b7b35515c.1423867976.git.mchehab@osg.samsung.com>
	<54E1B45F.3080000@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 16 Feb 2015 10:11:59 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 02/13/2015 11:57 PM, Mauro Carvalho Chehab wrote:
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
> >  	int default_volume;
> >  	u32 id;
> >  	u16 device_id;
> > +#if defined(CONFIG_MEDIA_CONTROLLER)
> > +	int ret;
> > +#endif
> >  
> >  	/* Check if the adapter supports the needed features */
> >  	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DATA))
> > @@ -5178,6 +5181,21 @@ static int cx25840_probe(struct i2c_client *client,
> >  
> >  	sd = &state->sd;
> >  	v4l2_i2c_subdev_init(sd, client, &cx25840_ops);
> > +#if defined(CONFIG_MEDIA_CONTROLLER)
> > +	/* TODO: need to represent analog inputs too */
> 
> Which analog inputs? Do you mean 'audio inputs' instead?

I mean analog video inputs like composite, svideo, etc, e. g.
having multiple input pads for the analog demods, like:

                ___________
TUNER --------> |         |
                |         |
SVIDEO .......> | cx25840 |
                |         |
COMPOSITE1 ...> |_________|


(in the above, dashes represent the enabled link, and periods
represent the disabled ones)

In other words, if we want to properly represent the pipeline, 
it should be possible to see via the media controller if the tuner
is being used as an image source, or if the source is something else.

I didn't map those other inputs here yet, due to a few things:
- Not sure if it is really worth
- The extra inputs would require subdevs that won't be controlled
- I was in doubt about the best way for doing that
- That would likely require some extra setup for cx25840 caller
  drivers, in order to represent what of the possible internal
  inputs are actually used on each specific board
- I was too lazy to do it ;)

Actually, I didn't see much benefit on adding such map now, so I
decided to just add a comment inside the source code.

Regards,
Mauro
