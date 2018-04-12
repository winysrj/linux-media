Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:54175 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751719AbeDLJ5i (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Apr 2018 05:57:38 -0400
Date: Thu, 12 Apr 2018 12:57:10 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: jacopo mondi <jacopo@jmondi.org>
Cc: Andy Yeh <andy.yeh@intel.com>, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, tfiga@chromium.org,
        Alan Chiang <alanx.chiang@intel.com>
Subject: Re: [RESEND PATCH v7 2/2] media: dw9807: Add dw9807 vcm driver
Message-ID: <20180412095710.tqcpyix6sn772siw@paasikivi.fi.intel.com>
References: <1523375324-27856-1-git-send-email-andy.yeh@intel.com>
 <1523375324-27856-3-git-send-email-andy.yeh@intel.com>
 <20180412085701.GJ20945@w540>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180412085701.GJ20945@w540>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

On Thu, Apr 12, 2018 at 10:57:01AM +0200, jacopo mondi wrote:
...
> > +		if (MAX_RETRY == ++retry) {
> > +			dev_err(&client->dev,
> > +				"Cannot do the write operation because VCM is busy\n");
> 
> Nit: this is over 80 cols, it's fine, but I think you can really
> shorten the error messag without losing context.

dev_warn() or dev_info() might be more appropriate actually. Or even
dev_dbg(). This isn't a grave problem; just a sign the user space is trying
to move the lens before it has reached its previous target position.

> 
> > +			return -EIO;
> > +		}
> > +		usleep_range(DW9807_CTRL_DELAY_US, DW9807_CTRL_DELAY_US + 10);
> 
> mmm, I wonder if a sleep range of 10usecs is really a strict
> requirement. Have a look at Documentation/timers/timers-howto.txt.
> With such a small range you're likely fire some unrequired interrupt.

If the user is trying to tell where to move the lens next, no time should
be wasted on waiting. It'd perhaps rather make sense to return an error
(-EBUSY): the user application (as well as the application developer) would
know about the attempt to move the lens too fast and could take an informed
decision on what to do next. This could include changing the target
position, waiting more or changing the program to adjust the 3A loop
behaviour.

...

> > +static int dw9807_probe(struct i2c_client *client)
> > +{
> > +	struct dw9807_device *dw9807_dev;
> > +	int rval;
> > +
> > +	dw9807_dev = devm_kzalloc(&client->dev, sizeof(*dw9807_dev),
> > +				  GFP_KERNEL);
> > +	if (!dw9807_dev)
> > +		return -ENOMEM;
> > +
> > +	v4l2_i2c_subdev_init(&dw9807_dev->sd, client, &dw9807_ops);
> > +	dw9807_dev->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> > +	dw9807_dev->sd.internal_ops = &dw9807_int_ops;
> > +
> > +	rval = dw9807_init_controls(dw9807_dev);
> > +	if (rval)
> > +		goto err_cleanup;
> > +
> > +	rval = media_entity_pads_init(&dw9807_dev->sd.entity, 0, NULL);
> > +	if (rval < 0)
> > +		goto err_cleanup;
> > +
> > +	dw9807_dev->sd.entity.function = MEDIA_ENT_F_LENS;
> 
> Not super sure here, Sakari may confirm or not, but you don't have
> pads, you don't have pad operations, why are initializing entity pads
> and depend on MEDIA_CONTROLLER in Kconfig? I -think- you can remove
> these lines above here.

You could omit media_entity_pads_init() but not setting the entity
function. The function un-doing what media_entity_pads_init() does is
media_entity_cleanup() which is currently empty; it wasn't always that way:
the idea is that there would be work to be done to clean up an entity going
forward.

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
