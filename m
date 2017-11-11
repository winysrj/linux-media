Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60066 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751607AbdKKXcg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 11 Nov 2017 18:32:36 -0500
Date: Sun, 12 Nov 2017 01:32:31 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH v10 2/2] media: rcar-csi2: add Renesas R-Car MIPI CSI-2
 receiver driver
Message-ID: <20171111233230.zbrt6mkfcplccuuw@valkosipuli.retiisi.org.uk>
References: <20171110133137.9137-1-niklas.soderlund+renesas@ragnatech.se>
 <20171110133137.9137-3-niklas.soderlund+renesas@ragnatech.se>
 <20171110223227.pug7d4qi7rdi4b4b@valkosipuli.retiisi.org.uk>
 <20171111001113.GB13042@bigcity.dyn.berto.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20171111001113.GB13042@bigcity.dyn.berto.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hejssan, Niklas!

On Sat, Nov 11, 2017 at 01:11:13AM +0100, Niklas Söderlund wrote:
> Hej Sakari,
> 
> On 2017-11-11 00:32:27 +0200, Sakari Ailus wrote:
> > Hej Niklas,
> > 
> > Tack för uppdaterade lappar! Jag har några kommentar nedan... det ser bra
> > ut överallt.
> 
> Tack för din feedback!

Var så god!

...

> > > +static int rcar_csi2_calc_phypll(struct rcar_csi2 *priv,
> > > +				 struct v4l2_subdev *source,
> > > +				 struct v4l2_mbus_framefmt *mf,
> > > +				 u32 *phypll)
> > > +{
> > > +	const struct phypll_hsfreqrange *hsfreq;
> > > +	const struct rcar_csi2_format *format;
> > > +	struct v4l2_ctrl *ctrl;
> > > +	u64 mbps;
> > > +
> > > +	ctrl = v4l2_ctrl_find(source->ctrl_handler, V4L2_CID_PIXEL_RATE);
> > 
> > How about LINK_FREQ instead? It'd be more straightforward to calculate
> > this. Up to you.
> 
> I need to use PIXEL_RATE as my test setup uses the adv748x driver which 
> only implement that control. In the short term I would like to support 
> both, but I need a setup to test that before I can add support for it.  
> In the long term, maybe we should deprecate one of the controls?

Hmm. At least we musn't give the responsibility to calculate the pixel rate
to the end user: this depends on the bus and that is not visible to the
user space.

The link frequency is usually chosen from a few alternatives (or there's
just a single choice). And the pixel rate depends on the pixel code chosen
--- so you'd have a menu with menu entries changing based on format. That'd
be odd.

Perhaps just leave it as-is, as suggested by Laurent?

...

> > > +
> > > +	dev_dbg(priv->dev, "Using source %s pad: %u\n", source->name,
> > > +		source_pad->index);
> > > +
> > > +	fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
> > > +	fmt.pad = source_pad->index;
> > > +	ret = v4l2_subdev_call(source, pad, get_fmt, NULL, &fmt);
> > > +	if (ret)
> > > +		return ret;
> > 
> > The link format has been validated already by this point this isn't
> > supposed to fail or produce different results than in link validation.
> > 
> > You could get the same format from the local pad, too.
> 
> Another good catch, I will use the format stored locally to make the 
> code simpler. As you state the formats are already validated so it's 
> safe to do so. I still need to get the remote subdevice to be able to 
> read the PIXEL_RATE control, but I can move that to 
> rcar_csi2_calc_phypll() where it's actually used.

Sounds good to me.
 
...

> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +static int rcar_csi2_set_pad_format(struct v4l2_subdev *sd,
> > > +				    struct v4l2_subdev_pad_config *cfg,
> > > +				    struct v4l2_subdev_format *format)
> > > +{
> > > +	struct rcar_csi2 *priv = sd_to_csi2(sd);
> > > +	struct v4l2_mbus_framefmt *framefmt;
> > > +
> > 
> > Is everything possible? For instance, are there limits regarding width or
> > height? Or the pixel code? They should be checked here.
> 
> Yes it do care about pixel code which was only validated at s_stream() 
> time, will move the check here thanks!
> 
> > 
> > Also the format on the source pad is, presumably, dependent on the format
> > on the sink pad.
> 
> Yes, but since this driver can't change the format in any way is there 
> any harm in mirror whatever is set on one pad on the other(s)? This will 
> change once multiple stream support is added in a later series.

If the hardware does not have functionality that may affect the size or the
pixel code, then the format on the source pad shouldn't be settable.

Yes, this will change when support for multiple streams is added. You'll
get more pads, and the sink pad no longer will have a format. But... it's a
good question how to prepare for this --- is it possible without changing
the user space API? I'm sure we'll have other such cases, such as the
smiapp driver with sensor embedded data.

...

> > > +static int rcar_csi2_parse_dt(struct rcar_csi2 *priv)
> > > +{
> > > +	struct device_node *ep;
> > > +	struct v4l2_fwnode_endpoint v4l2_ep;
> > > +	int ret;
> > > +
> > > +	ep = of_graph_get_endpoint_by_regs(priv->dev->of_node, 0, 0);
> > > +	if (!ep) {
> > > +		dev_err(priv->dev, "Not connected to subdevice\n");
> > > +		return -EINVAL;
> > > +	}
> > > +
> > > +	ret = v4l2_fwnode_endpoint_parse(of_fwnode_handle(ep), &v4l2_ep);
> > > +	if (ret) {
> > > +		dev_err(priv->dev, "Could not parse v4l2 endpoint\n");
> > > +		of_node_put(ep);
> > > +		return -EINVAL;
> > > +	}
> > > +
> > > +	ret = rcar_csi2_parse_v4l2(priv, &v4l2_ep);
> > > +	if (ret)
> > > +		return ret;
> > > +
> > > +	priv->remote.match.fwnode.fwnode =
> > > +		fwnode_graph_get_remote_endpoint(of_fwnode_handle(ep));
> > > +	priv->remote.match_type = V4L2_ASYNC_MATCH_FWNODE;
> > > +
> > > +	of_node_put(ep);
> > > +
> > > +	priv->notifier.subdevs = devm_kzalloc(priv->dev,
> > > +					      sizeof(*priv->notifier.subdevs),
> > > +					      GFP_KERNEL);
> > > +	if (priv->notifier.subdevs == NULL)
> > > +		return -ENOMEM;
> > > +
> > > +	priv->notifier.num_subdevs = 1;
> > > +	priv->notifier.subdevs[0] = &priv->remote;
> > > +	priv->notifier.ops = &rcar_csi2_notify_ops;
> > > +
> > > +	dev_dbg(priv->dev, "Found '%pOF'\n",
> > > +		to_of_node(priv->remote.match.fwnode.fwnode));
> > > +
> > > +	return v4l2_async_subdev_notifier_register(&priv->subdev,
> > > +						   &priv->notifier);
> > 
> > Could you use v4l2_async_notifier_parse_fwnode_endpoints_by_port() or does
> > something bad happen if you do? The intent with that was to avoid functions
> > like the above in drivers.
> 
> Unfortunately not :-(
> 
> I have a local patch which do this, but it won't work since this driver 
> needs to register remote endpoints (fwnode_graph_get_remote_endpoint() 
> above) and not the remote parent in the async framework. The reason for 
> this is that that is what the adv748x driver registers with the async 
> framework given that it only have one node in DT but registers multiple 
> subdevices. I would love to in the future resolve this in the helper 
> functions and switch to such a helper here.

Right. How does the fwnode matching work then? Don't you need to do
endpoint node matching here, i.e. the patch for the fwnode framework, too?

Could you change how the framework assigns the matched fwnode?

What I'd like to do still is to decouple registering async sub-devices and
parsing the endpoints. The two are quite entangled and I just haven't been
able to come up with a good API for that yet.

-- 
Trevliga hälsningar,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
