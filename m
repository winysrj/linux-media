Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49006 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751740AbdLBOFL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 2 Dec 2017 09:05:11 -0500
Date: Sat, 2 Dec 2017 16:05:08 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH v12 2/2] rcar-csi2: add Renesas R-Car MIPI CSI-2 receiver
 driver
Message-ID: <20171202140508.njr67jfsob2yfwwv@valkosipuli.retiisi.org.uk>
References: <20171129193235.25423-1-niklas.soderlund+renesas@ragnatech.se>
 <20171129193235.25423-3-niklas.soderlund+renesas@ragnatech.se>
 <20171201130136.vmskp34z7pfpg422@valkosipuli.retiisi.org.uk>
 <20171202110821.GC26548@bigcity.dyn.berto.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20171202110821.GC26548@bigcity.dyn.berto.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hejssan,

On Sat, Dec 02, 2017 at 12:08:21PM +0100, Niklas S�derlund wrote:
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
> > 
> > To continue the discussion from v10 --- how does this work? The V4L2 async
> > framework does still matching for the node of the device, not the endpoint.
> > 
> > My suggestion is to handle this in match_fwnode until all drivers have been
> > converted. The V4L2 fwnode helper should be changed as well, then you could
> > use it here, too.
> 
> I agree that the V4L2 async framework should be changed to work with 
> endpoints and not the node of the device. I also agree on how this 
> change should be introduced.
> 
> But I don't feel that this change of the framework needs to block this 
> patch-set. Once the framework is updated to work with endpoints it 
> should be a trivial patch to change rcar-csi2 to use the new helper. Do 
> you agree whit this or do you feel that this patch-set should depend on 
> such change of the framework?

Without changes to the framework, I don't think this would work since the
async framework (or individual drivers) will assign the device's fwnode,
not that of the endpoint, to the fwnode against which to match the async
sub-device.

Therefore you'll need these changes for this driver to work. Or if you
introduce a sub-device driver that uses endpoints as well, then we have two
non-interoperable sets of ISP (or bridge) and sub-device drivers. That'd be
quite undesirable.

Or, if you don't care whether it'd work with your use case right now, you
could use the helper function without changes. :-)

> > > +{
> > > +	const struct soc_device_attribute *attr;
> > > +	struct rcar_csi2 *priv;
> > > +	unsigned int i;
> > > +	int ret;
> > > +
> > > +	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
> > > +	if (!priv)
> > > +		return -ENOMEM;
> > > +
> > > +	priv->info = of_device_get_match_data(&pdev->dev);
> > > +
> > > +	/* r8a7795 ES1.x behaves different then ES2.0+ but no own compat */
> > > +	attr = soc_device_match(r8a7795es1);
> > > +	if (attr)
> > > +		priv->info = attr->data;
> > > +
> > > +	priv->dev = &pdev->dev;
> > > +
> > > +	mutex_init(&priv->lock);
> > > +	priv->stream_count = 0;
> > > +
> > > +	ret = rcar_csi2_probe_resources(priv, pdev);
> > > +	if (ret) {
> > > +		dev_err(priv->dev, "Failed to get resources\n");
> > > +		return ret;
> > > +	}
> > > +
> > > +	platform_set_drvdata(pdev, priv);
> > > +
> > > +	ret = rcar_csi2_parse_dt(priv);
> > > +	if (ret)
> > > +		return ret;
> > > +
> > > +	priv->subdev.owner = THIS_MODULE;
> > > +	priv->subdev.dev = &pdev->dev;
> > > +	v4l2_subdev_init(&priv->subdev, &rcar_csi2_subdev_ops);
> > > +	v4l2_set_subdevdata(&priv->subdev, &pdev->dev);
> > > +	snprintf(priv->subdev.name, V4L2_SUBDEV_NAME_SIZE, "%s %s",
> > > +		 KBUILD_MODNAME, dev_name(&pdev->dev));
> > > +	priv->subdev.flags = V4L2_SUBDEV_FL_HAS_DEVNODE;
> > > +
> > > +	priv->subdev.entity.function = MEDIA_ENT_F_PROC_VIDEO_PIXEL_FORMATTER;
> > > +	priv->subdev.entity.ops = &rcar_csi2_entity_ops;
> > > +
> > > +	priv->pads[RCAR_CSI2_SINK].flags = MEDIA_PAD_FL_SINK;
> > > +	for (i = RCAR_CSI2_SOURCE_VC0; i < NR_OF_RCAR_CSI2_PAD; i++)
> > > +		priv->pads[i].flags = MEDIA_PAD_FL_SOURCE;
> > > +
> > > +	ret = media_entity_pads_init(&priv->subdev.entity, NR_OF_RCAR_CSI2_PAD,
> > > +				     priv->pads);
> > > +	if (ret)
> > > +		goto error;
> > > +
> > > +	ret = v4l2_async_register_subdev(&priv->subdev);
> > > +	if (ret < 0)
> > > +		goto error;
> > > +
> > > +	pm_runtime_enable(&pdev->dev);
> > 
> > Is this enough for platform devices? Just wondering.
> 
> As far as I can tell from the documentation this should be enough. I'm 
> no expert on PM so if I'm wrong please let me know.
> 
> Geert: do I understand the documentation correctly?
> 
> > 
> > > +
> > > +	dev_info(priv->dev, "%d lanes found\n", priv->lanes);
> > 
> > I'd use dev_dbg.
> 
> I'm thorn about this one. I agree that the information printed is not 
> critical. But I have found this useful when receiving logs from users 
> who have misconfigured there DTS with the wrong number of lines.
> 
> I'm open to changing this, but if it's a matter of taste I prefer to 
> keep it at a info level.

No objections. There are a bunch of stuff that can go wrong, this is just
one small piece of that. Thinking about it, it might be nice to add debug
prints for endpoint parsing so we'd have a generic way to print this
information.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
