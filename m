Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:39311 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726261AbeK0BLY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Nov 2018 20:11:24 -0500
Date: Mon, 26 Nov 2018 15:16:56 +0100
From: Marco Felsch <m.felsch@pengutronix.de>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: mark.rutland@arm.com, devicetree@vger.kernel.org,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        enrico.scholz@sigma-chemnitz.de, akinobu.mita@gmail.com,
        robh+dt@kernel.org, sakari.ailus@linux.intel.com,
        mchehab@kernel.org, graphics@pengutronix.de,
        linux-media@vger.kernel.org
Subject: Re: [PATCH v2 4/6] media: mt9m111: allow to setup pixclk polarity
Message-ID: <20181126141656.42fehzooxd6aruf7@pengutronix.de>
References: <20181029182410.18783-1-m.felsch@pengutronix.de>
 <20181029182410.18783-5-m.felsch@pengutronix.de>
 <20181116133235.kge7xept2sgfnnwo@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181116133235.kge7xept2sgfnnwo@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 18-11-16 15:32, Sakari Ailus wrote:
> Hi Marco, Enrico,
> 
> On Mon, Oct 29, 2018 at 07:24:08PM +0100, Marco Felsch wrote:
> > From: Enrico Scholz <enrico.scholz@sigma-chemnitz.de>
> > 
> > The chip can be configured to output data transitions on the
> > rising or falling edge of PIXCLK (Datasheet R58:1[9]), default is on the
> > falling edge.
> > 
> > Parsing the fw-node is made in a subfunction to bundle all (future)
> > dt-parsing / fw-parsing stuff.
> > 
> > Signed-off-by: Enrico Scholz <enrico.scholz@sigma-chemnitz.de>
> > (m.grzeschik@pengutronix.de: Fix inverting clock. INV_PIX_CLOCK bit is set
> > per default. Set bit to 0 (enable mask bit without value) to enable
> > falling edge sampling.)
> > Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
> > (m.felsch@pengutronix.de: use fwnode helpers)
> > (m.felsch@pengutronix.de: mv fw parsing into own function)
> > (m.felsch@pengutronix.de: adapt commit msg)
> > Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
> > 
> > ---
> > Changelog:
> > 
> > v2:
> > - make use of fwnode_*() to drop OF dependency and ifdef's
> > - mt9m111_g_mbus_config: fix pclk_sample logic which I made due the
> >   conversion from Enrico's patch.
> > 
> >  drivers/media/i2c/mt9m111.c | 46 ++++++++++++++++++++++++++++++++++++-
> >  1 file changed, 45 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/media/i2c/mt9m111.c b/drivers/media/i2c/mt9m111.c
> > index e9879e111f58..112eaa5ba917 100644
> > --- a/drivers/media/i2c/mt9m111.c
> > +++ b/drivers/media/i2c/mt9m111.c
> > @@ -15,12 +15,14 @@
> >  #include <linux/delay.h>
> >  #include <linux/v4l2-mediabus.h>
> >  #include <linux/module.h>
> > +#include <linux/property.h>
> >  
> >  #include <media/v4l2-async.h>
> >  #include <media/v4l2-clk.h>
> >  #include <media/v4l2-common.h>
> >  #include <media/v4l2-ctrls.h>
> >  #include <media/v4l2-device.h>
> > +#include <media/v4l2-fwnode.h>
> >  
> >  /*
> >   * MT9M111, MT9M112 and MT9M131:
> > @@ -239,6 +241,8 @@ struct mt9m111 {
> >  	const struct mt9m111_datafmt *fmt;
> >  	int lastpage;	/* PageMap cache value */
> >  	bool is_streaming;
> > +	/* user point of view - 0: falling 1: rising edge */
> > +	unsigned int pclk_sample:1;
> 
> You could use a bool. Up to you.

I find it more precise to use a unsigned int, because using a bool is
more like a statement e.g. invert_pclk.

[Snip]

> >  static int mt9m111_probe(struct i2c_client *client,
> >  			 const struct i2c_device_id *did)
> >  {
> > @@ -1147,6 +1187,10 @@ static int mt9m111_probe(struct i2c_client *client,
> >  	/* Default HIGHPOWER context */
> >  	mt9m111->ctx = &context_b;
> >  
> > +	ret = mt9m111_probe_fw(client, mt9m111);
> > +	if (ret)
> > +		return ret;
> 
> Can you do this before v4l2_clk_get()? That'll go anyway, but for now,
> you'd need extra error handling for it.

Sure, I will move it above v4l2_clk_get().

> > +
> >  	v4l2_i2c_subdev_init(&mt9m111->subdev, client, &mt9m111_subdev_ops);
> >  	mt9m111->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> >  
> 
> Please also put this patch after the DT binding changes.

Okay, I will reorder it.

Regards,
Marco

> -- 
> Kind regards,
> 
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi
