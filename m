Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:43136 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750798AbeBWKO3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Feb 2018 05:14:29 -0500
Date: Fri, 23 Feb 2018 12:14:25 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Yong Zhi <yong.zhi@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        niklas.soderlund@ragnatech.se, Sebastian Reichel <sre@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 01/13] media: v4l2-fwnode: Let parse_endpoint callback
 decide if no remote is error
Message-ID: <20180223101424.qw67pd7xvv5oy4sw@valkosipuli.retiisi.org.uk>
References: <1519263589-19647-1-git-send-email-steve_longerbeam@mentor.com>
 <3283028.CgXzGkPyKt@avalon>
 <1519379812.7712.1.camel@pengutronix.de>
 <2571855.0gglA1aPyk@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2571855.0gglA1aPyk@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi guys,

On Fri, Feb 23, 2018 at 12:05:38PM +0200, Laurent Pinchart wrote:
> Hi Philipp,
> 
> On Friday, 23 February 2018 11:56:52 EET Philipp Zabel wrote:
> > On Fri, 2018-02-23 at 11:29 +0200, Laurent Pinchart wrote:
> > > On Thursday, 22 February 2018 03:39:37 EET Steve Longerbeam wrote:
> > >> For some subdevices, a fwnode endpoint that has no connection to a
> > >> remote endpoint may not be an error. Let the parse_endpoint callback
> > > make that decision in v4l2_async_notifier_fwnode_parse_endpoint(). If
> > >> the callback indicates that is not an error, skip adding the asd to the
> > >> notifier and return 0.
> > >> 
> > >> For the current users of v4l2_async_notifier_parse_fwnode_endpoints()
> > >> (omap3isp, rcar-vin, intel-ipu3), return -EINVAL in the callback for
> > >> unavailable remote fwnodes to maintain the previous behavior.
> > > 
> > > I'm not sure this should be a per-driver decision.
> > > 
> > > Generally speaking, if an endpoint node has no remote-endpoint property,
> > > the endpoint node is not needed. I've always considered such an endpoint
> > > node as invalid. The OF graphs DT bindings are however not clear on this
> > > subject.
> > 
> > Documentation/devicetree/bindings/graph.txt says:
> > 
> >   Each endpoint should contain a 'remote-endpoint' phandle property
> >   that points to the corresponding endpoint in the port of the remote
> >   device.
> > 
> > ("should", not "must").
> 
> The DT bindings documentation has historically used "should" to mean "must" in 
> many places :-( That was a big mistake.

"Shall", not "must".

Indeed, there's hardly use for an endpoint without the remote-endpoint
property. My understanding is that such nodes might be best ignored, that's
been at least the practice in a lot of DT parsing code. There are arguments
both ways I guess.

What comes to this patch is that I'd rather not burden individual drivers
with such checks.

> 
> > Later, the remote-node property explicitly lists the remote-endpoint
> > property as optional.
> 
> I've seen that too, and that's why I mentioned that the documentation isn't 
> clear on the subject.
> 
> > > I have either failed to notice when they got merged, or they slowly
> > > evolved over time to contain contradictory information. In any case, I
> > > think we should decide on whether such a situation is valid or not from
> > > an OF graph point of view, and then always reject or always accept and
> > > ignore those endpoints.
> > 
> > We are currently using this on i.MX6 to provide empty labeled endpoints
> > in the dtsi files for board DT writers to link to, both for the display
> > output and video capture ports.
> > See for example the endpoints with the labels ipu1_di0_disp0 and
> > ipu1_csi0_mux_from_parallel_sensor in arch/arm/boot/dts/imx6q.dtsi.
> 
> This could also be achieved by adding the endpoints in the board DT files. See 
> for instance the hdmi@fead0000 node in arch/arm64/boot/dts/renesas/
> r8a7795.dtsi and how it gets extended in arch/arm64/boot/dts/renesas/r8a7795-
> salvator-x.dts. On the other hand, I also have empty endpoints in the 
> display@feb00000 node of arch/arm64/boot/dts/renesas/r8a7795.dtsi.
> 
> I think we should first decide what we want to do going forward (allowing for 
> empty endpoints or not), clarify the documentation, and then update the code. 
> In any case I don't think it should be a per-device decision.

I don't think they should be allowed in the documentation. The
implementation could still simply ignore them.

Cc the devicetree list.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
