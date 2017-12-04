Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46184 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751733AbdLDVJz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 4 Dec 2017 16:09:55 -0500
Date: Mon, 4 Dec 2017 23:09:52 +0200
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
Message-ID: <20171204210952.tjme3sz2bnablb5g@valkosipuli.retiisi.org.uk>
References: <20171129193235.25423-1-niklas.soderlund+renesas@ragnatech.se>
 <20171129193235.25423-3-niklas.soderlund+renesas@ragnatech.se>
 <20171201130136.vmskp34z7pfpg422@valkosipuli.retiisi.org.uk>
 <20171202110821.GC26548@bigcity.dyn.berto.se>
 <20171202140508.njr67jfsob2yfwwv@valkosipuli.retiisi.org.uk>
 <20171202145021.GE26548@bigcity.dyn.berto.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20171202145021.GE26548@bigcity.dyn.berto.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hejssan!!

On Sat, Dec 02, 2017 at 03:50:21PM +0100, Niklas Söderlund wrote:
> Hej Sakari,
> 
> Thanks for your feedback.
> 
> On 2017-12-02 16:05:08 +0200, Sakari Ailus wrote:
> > Hejssan,
> > 
> > On Sat, Dec 02, 2017 at 12:08:21PM +0100, Niklas Söderlund wrote:
> > ...
> > > > > +static int rcar_csi2_parse_dt(struct rcar_csi2 *priv)
> > > > > +{
> > > > > +	struct device_node *ep;
> > > > > +	struct v4l2_fwnode_endpoint v4l2_ep;
> > > > > +	int ret;
> > > > > +
> > > > > +	ep = of_graph_get_endpoint_by_regs(priv->dev->of_node, 0, 0);
> > > > > +	if (!ep) {
> > > > > +		dev_err(priv->dev, "Not connected to subdevice\n");
> > > > > +		return -EINVAL;
> > > > > +	}
> > > > > +
> > > > > +	ret = v4l2_fwnode_endpoint_parse(of_fwnode_handle(ep), &v4l2_ep);
> > > > > +	if (ret) {
> > > > > +		dev_err(priv->dev, "Could not parse v4l2 endpoint\n");
> > > > > +		of_node_put(ep);
> > > > > +		return -EINVAL;
> > > > > +	}
> > > > > +
> > > > > +	ret = rcar_csi2_parse_v4l2(priv, &v4l2_ep);
> > > > > +	if (ret)
> > > > > +		return ret;
> > > > > +
> > > > > +	priv->remote.match.fwnode.fwnode =
> > > > > +		fwnode_graph_get_remote_endpoint(of_fwnode_handle(ep));
> > > > 
> > > > To continue the discussion from v10 --- how does this work? The V4L2 async
> > > > framework does still matching for the node of the device, not the endpoint.
> > > > 
> > > > My suggestion is to handle this in match_fwnode until all drivers have been
> > > > converted. The V4L2 fwnode helper should be changed as well, then you could
> > > > use it here, too.
> > > 
> > > I agree that the V4L2 async framework should be changed to work with 
> > > endpoints and not the node of the device. I also agree on how this 
> > > change should be introduced.
> > > 
> > > But I don't feel that this change of the framework needs to block this 
> > > patch-set. Once the framework is updated to work with endpoints it 
> > > should be a trivial patch to change rcar-csi2 to use the new helper. Do 
> > > you agree whit this or do you feel that this patch-set should depend on 
> > > such change of the framework?
> > 
> > Without changes to the framework, I don't think this would work since the
> > async framework (or individual drivers) will assign the device's fwnode,
> > not that of the endpoint, to the fwnode against which to match the async
> > sub-device.
> > 
> > Therefore you'll need these changes for this driver to work. Or if you
> > introduce a sub-device driver that uses endpoints as well, then we have two
> > non-interoperable sets of ISP (or bridge) and sub-device drivers. That'd be
> > quite undesirable.
> 
> Such a driver is already upstream, the adv748x driver register its 
> subdevices using endpoints rather then the node of the device itself.
> 
> <snip from adv748x-csi2.c in v4.15-rc1>
> int adv748x_csi2_init(...)
> {
> 
>     ...
> 
>     /* Ensure that matching is based upon the endpoint fwnodes */
>     tx->sd.fwnode = of_fwnode_handle(ep);
> 
>     ...
> }
> </snip>
> 
> A related patch to when the adv748x driver was unstreamed where 
> 'v4l2-async: Match parent devices' by Kieran to make this change in
> behavior not to cause the non-interoperable sets your mention. It seems 
> however that that change have fallen thru the cracks.

Please see the other patch I just sent you (plus linux-media).

> 
> > 
> > Or, if you don't care whether it'd work with your use case right now, you
> > could use the helper function without changes. :-)
> 
> The adv748x is the primary use-case for the rcar-csi2 driver at the 
> moment. So I must either keep this workaround in the driver or make this 
> patch-set depend on future framework fixes. I would prefer to be able to 
> use the helper as it makes the driver less complex. At the same time I 
> don't want yet another framework change as a blocker for this patch-set 
> :-)
> 
> Once I'm back from my short vacation I will give the framework update a 
> try and if it turns out OK I will make this patch-set dependent on those 
> changes and squash in my patch which converts rcar-csi2 to use the 
> helper which is already done in preparation of future framework updates.
> 
> If it turns out the changes needed are complex or get stuck in review I 
> would prefer if it was possible to move forward with the workaround in 
> the driver for now and move it to the helper once it's available. Do 
> this sound like a agreeable plan to you?

Yes, but I think changing the framework should be fine.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
