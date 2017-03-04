Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60422 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751814AbdCDMd3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 4 Mar 2017 07:33:29 -0500
Date: Sat, 4 Mar 2017 14:30:11 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: sre@kernel.org, pali.rohar@gmail.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, laurent.pinchart@ideasonboard.com,
        mchehab@kernel.org, ivo.g.dimitrov.75@gmail.com
Subject: Re: camera subdevice support was Re: [PATCH 1/4] v4l2:
 device_register_subdev_nodes: allow calling multiple times
Message-ID: <20170304123010.GT3220@valkosipuli.retiisi.org.uk>
References: <20170220103114.GA9800@amd>
 <20170220130912.GT16975@valkosipuli.retiisi.org.uk>
 <20170220135636.GU16975@valkosipuli.retiisi.org.uk>
 <20170221110721.GD5021@amd>
 <20170221111104.GD16975@valkosipuli.retiisi.org.uk>
 <20170225000918.GB23662@amd>
 <20170225134444.6qzumpvasaow5qoj@ihha.localdomain>
 <20170225215321.GA29886@amd>
 <20170225231754.GY16975@valkosipuli.retiisi.org.uk>
 <20170304085551.GA19769@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170304085551.GA19769@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Mar 04, 2017 at 09:55:51AM +0100, Pavel Machek wrote:
> Dobry den! :-)

Huomenta! :-)

> 
> > > > > Ok, I got the camera sensor to work. No subdevices support, so I don't
> > > > > have focus (etc) working, but that's a start. I also had to remove
> > > > > video-bus-switch support; but I guess it will be easier to use
> > > > > video-multiplexer patches... 
> > > > > 
> > > > > I'll have patches over weekend.
> > > > 
> > > > I briefly looked at what's there --- you do miss the video nodes for the
> > > > non-sensor sub-devices, and they also don't show up in the media graph,
> > > > right?
> > > 
> > > Yes.
> > > 
> > > > I guess they don't end up matching in the async list.
> > > 
> > > How should they get to the async list?
> > 
> > The patch you referred to does that. The problem is, it does make the bus
> > configuration a pointer as well. There should be two patches. That's not a
> > lot of work to separate them though. But it should be done.
> > 
> > > 
> > > > I think we need to make the non-sensor sub-device support more generic;
> > > > it's not just the OMAP 3 ISP that needs it. I think we need to document
> > > > the property for the flash phandle as well; I can write one, or refresh
> > > > an existing one that I believe already exists.
> > > > 
> > > > How about calling it either simply "flash" or "camera-flash"? Similarly
> > > > for lens: "lens" or "camera-lens". I have a vague feeling the "camera-"
> > > > prefix is somewhat redundant, so I'd just go for "flash" or "lens".
> > > 
> > > Actually, I'd go for "flash" and "focus-coil". There may be other
> > > lens properties, such as zoom, mirror movement, lens identification,
> > > ...
> > 
> > Good point. Still there may be other ways to move the lens than the voice
> > coil (which sure is cheap), so how about "flash" and "lens-focus"?
> 
> Ok, so something like this? (Yes, needs binding documentation and you
> wanted it in the core.. can fix.)
> 
> BTW, fwnode_handle_put() seems to be missing in the success path of
> isp_fwnodes_parse() -- can you check that?

Where exactly? I noticed that if notifier->num_subdevs hits the limit the
last node isn't put properly. I'll fix that. Is that what you meant?

> 
> Best regards,
> 								Pavel
> 
> 
> diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
> index c80397a..6f6fbed 100644
> --- a/drivers/media/platform/omap3isp/isp.c
> +++ b/drivers/media/platform/omap3isp/isp.c
> @@ -2114,7 +2114,7 @@ static int isp_fwnode_parse(struct device *dev, struct fwnode_handle *fwn,
>  			buscfg->bus.ccp2.lanecfg.data[0].pol =
>  				vfwn.bus.mipi_csi1.lane_polarity[1];
>  
> -			dev_dbg(dev, "data lane %u polarity %u, pos %u\n", i,
> +			dev_dbg(dev, "data lane %u polarity %u, pos %u\n", 0,

Why?

>  				buscfg->bus.ccp2.lanecfg.data[0].pol,
>  				buscfg->bus.ccp2.lanecfg.data[0].pos);
>  
> @@ -2162,10 +2162,64 @@ static int isp_fwnode_parse(struct device *dev, struct fwnode_handle *fwn,
>  	return 0;
>  }
>  
> +static int camera_subdev_parse(struct device *dev, struct v4l2_async_notifier *notifier,
> +			       const char *key)
> +{
> +	struct device_node *node;
> +	struct isp_async_subdev *isd;
> +
> +	printk("Looking for %s\n", key);
> +	
> +	node = of_parse_phandle(dev->of_node, key, 0);

There may be more than one flash associated with a sensor. Speaking of which
--- how is it associated to the sensors?

One way to do this could be to simply move the flash property to the sensor
OF node. We could have it here, too, if the flash was not associated with
any sensor, but I doubt that will ever be needed.

This really calls fork moving this part to the framework away from drivers.

> +	if (!node)
> +		return 0;
> +
> +	printk("Having subdevice: %p\n", node);
> +		
> +	isd = devm_kzalloc(dev, sizeof(*isd), GFP_KERNEL);
> +	if (!isd)
> +		return -ENOMEM;
> +
> +	notifier->subdevs[notifier->num_subdevs] = &isd->asd;
> +
> +	isd->asd.match.of.node = node;
> +	if (!isd->asd.match.of.node) {

You should check node here first.

> +		dev_warn(dev, "bad remote port parent\n");
> +		return -EIO;
> +	}
> +

And then assign it here.

isd->asd.match.fwnode.fwn = of_fwnode_handle(node);

> +	isd->asd.match_type = V4L2_ASYNC_MATCH_OF;

V4L2_ASYNC_MATCH_FWNODE, please.

> +	notifier->num_subdevs++;
> +
> +	return 0;
> +}
> +
> +static int camera_subdevs_parse(struct device *dev, struct v4l2_async_notifier *notifier,
> +				int max)
> +{
> +	int res = 0;

No need to assign res here.

> +
> +	printk("Going through camera-flashes\n");
> +	if (notifier->num_subdevs < max) {
> +		res = camera_subdev_parse(dev, notifier, "flash");
> +		if (res)
> +			return res;
> +	}
> +
> +	if (notifier->num_subdevs < max) {
> +		res = camera_subdev_parse(dev, notifier, "lens-focus");
> +		if (res)
> +			return res;
> +	}
> +	
> +	return 0;
> +}
> +
>  static int isp_fwnodes_parse(struct device *dev,
>  			     struct v4l2_async_notifier *notifier)
>  {
>  	struct fwnode_handle *fwn = NULL;
> +	int res = 0;
>  
>  	notifier->subdevs = devm_kcalloc(
>  		dev, ISP_MAX_SUBDEVS, sizeof(*notifier->subdevs), GFP_KERNEL);
> @@ -2199,6 +2253,15 @@ static int isp_fwnodes_parse(struct device *dev,
>  		notifier->num_subdevs++;
>  	}
>  
> +	/* FIXME: missing put in the success path? */
> +
> +	res = camera_subdevs_parse(dev, notifier, ISP_MAX_SUBDEVS);
> +	if (res)
> +		goto error;
> +
> +	if (notifier->num_subdevs == ISP_MAX_SUBDEVS) {
> +		printk("isp: Maybe too many devices?\n");
> +	}
>  	return notifier->num_subdevs;
>  
>  error:
> 
> 

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
