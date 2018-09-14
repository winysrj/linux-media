Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:33790 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726748AbeIOAN5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Sep 2018 20:13:57 -0400
Date: Fri, 14 Sep 2018 15:57:56 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Marco Felsch <m.felsch@pengutronix.de>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>, mchehab@kernel.org,
        robh+dt@kernel.org, mark.rutland@arm.com, kernel@pengutronix.de,
        devicetree@vger.kernel.org, p.zabel@pengutronix.de,
        javierm@redhat.com, laurent.pinchart@ideasonboard.com,
        afshin.nasser@gmail.com, linux-media@vger.kernel.org
Subject: Re: [PATCH v2 7/7] [media] tvp5150: add s_power callback
Message-ID: <20180914155756.1734a15c@coco.lan>
In-Reply-To: <20180914182046.y73rpgdwxfm2uchu@pengutronix.de>
References: <20180813092508.1334-1-m.felsch@pengutronix.de>
        <20180813092508.1334-8-m.felsch@pengutronix.de>
        <20180914132352.ta2g64slkttr5bdo@paasikivi.fi.intel.com>
        <20180914182046.y73rpgdwxfm2uchu@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 14 Sep 2018 20:20:46 +0200
Marco Felsch <m.felsch@pengutronix.de> escreveu:

> Hi Sakari,
> 
> On 18-09-14 16:23, Sakari Ailus wrote:
> > Hi Marco,
> > 
> > On Mon, Aug 13, 2018 at 11:25:08AM +0200, Marco Felsch wrote:  
> > > Don't en-/disable the interrupts during s_stream because someone can
> > > disable the stream but wants to get informed if the stream is locked
> > > again. So keep the interrupts enabled the whole time the pipeline is
> > > opened.
> > > 
> > > Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
> > > ---
> > >  drivers/media/i2c/tvp5150.c | 23 +++++++++++++++++------
> > >  1 file changed, 17 insertions(+), 6 deletions(-)
> > > 
> > > diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
> > > index e736f609fecd..e296f5bfae21 100644
> > > --- a/drivers/media/i2c/tvp5150.c
> > > +++ b/drivers/media/i2c/tvp5150.c
> > > @@ -1389,11 +1389,26 @@ static const struct media_entity_operations tvp5150_sd_media_ops = {
> > >  /****************************************************************************
> > >  			I2C Command
> > >   ****************************************************************************/
> > > +static int tvp5150_s_power(struct  v4l2_subdev *sd, int on)
> > > +{
> > > +	struct tvp5150 *decoder = to_tvp5150(sd);
> > > +	unsigned int val = 0;
> > > +
> > > +	if (on)
> > > +		val = TVP5150_INT_A_LOCK;
> > > +
> > > +	if (decoder->irq)
> > > +		/* Enable / Disable lock interrupt */
> > > +		regmap_update_bits(decoder->regmap, TVP5150_INT_ENABLE_REG_A,
> > > +				   TVP5150_INT_A_LOCK, val);  
> > 
> > Could you use runtime PM instead?  
> 
> I will test it next monday. What's the different between s_power and
> runtime PM?
> 
> > 
> > For an example, the dw9714 driver does this: drivers/media/i2c/dw9714.c .  
> 
> Hopefully I got you right, should I use the
> v4l2_subdev_internal_ops.open/close and call the pm_runtime_put/get
> there or did you mean the driver.pm callbacks? I'm not that familiar
> with the pm ops at the moment, sorry.

I guess the main issue here is: will this work if the bridge
driver is em28xx?

Whatever change we do, tvp5150 should still fully work with em28xx,
as several devices use this demod there.

Changing em28xx to cope with runtime PM would be *very* complex,
as there are lots of other drivers that can work with it, and
touching those will affect lots of other drivers. At the end, it
will very likely affect all PCI/PCIe V4L2 drivers, and several
USB ones.

If it can be done without affecting PM with em28xx, let's do it.
Otherwise, let's stick with s_power on this series, and let 
the mass PM rework on non-platform drivers to happen on some
separate patchset.

Thanks,
Mauro
