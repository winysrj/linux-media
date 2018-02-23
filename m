Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:44123 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751351AbeBWLQ3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Feb 2018 06:16:29 -0500
Message-ID: <1519384577.7712.4.camel@pengutronix.de>
Subject: Re: [PATCH 01/13] media: v4l2-fwnode: Let parse_endpoint callback
 decide if no remote is error
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Yong Zhi <yong.zhi@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        niklas.soderlund@ragnatech.se, Sebastian Reichel <sre@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Date: Fri, 23 Feb 2018 12:16:17 +0100
In-Reply-To: <2571855.0gglA1aPyk@avalon>
References: <1519263589-19647-1-git-send-email-steve_longerbeam@mentor.com>
         <3283028.CgXzGkPyKt@avalon> <1519379812.7712.1.camel@pengutronix.de>
         <2571855.0gglA1aPyk@avalon>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Fri, 2018-02-23 at 12:05 +0200, Laurent Pinchart wrote:
> Hi Philipp,
> 
> On Friday, 23 February 2018 11:56:52 EET Philipp Zabel wrote:
> > On Fri, 2018-02-23 at 11:29 +0200, Laurent Pinchart wrote:
> > > On Thursday, 22 February 2018 03:39:37 EET Steve Longerbeam wrote:
> > > > For some subdevices, a fwnode endpoint that has no connection to a
> > > > remote endpoint may not be an error. Let the parse_endpoint callback
> > > 
> > > make that decision in v4l2_async_notifier_fwnode_parse_endpoint(). If
> > > > the callback indicates that is not an error, skip adding the asd to the
> > > > notifier and return 0.
> > > > 
> > > > For the current users of v4l2_async_notifier_parse_fwnode_endpoints()
> > > > (omap3isp, rcar-vin, intel-ipu3), return -EINVAL in the callback for
> > > > unavailable remote fwnodes to maintain the previous behavior.
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

Maybe I could have worded that better? The intention was to let "should"
be read as a strong suggestion, like "it is recommended", but not as a
requirement.

> > Later, the remote-node property explicitly lists the remote-endpoint
> > property as optional.
> 
> I've seen that too, and that's why I mentioned that the documentation isn't 
> clear on the subject.

Do you have a suggestion how to improve the documentation? I thought
listing the remote-endpoint property under a header called "Optional
endpoint properties" was pretty clear.

> This could also be achieved by adding the endpoints in the board DT files. See 
> for instance the hdmi@fead0000 node in arch/arm64/boot/dts/renesas/
> r8a7795.dtsi and how it gets extended in arch/arm64/boot/dts/renesas/r8a7795-
> salvator-x.dts. On the other hand, I also have empty endpoints in the 
> display@feb00000 node of arch/arm64/boot/dts/renesas/r8a7795.dtsi.

Right, that would be possible.

> I think we should first decide what we want to do going forward (allowing for 
> empty endpoints or not), clarify the documentation, and then update the code. 
> In any case I don't think it should be a per-device decision.

There are device trees in the wild that have those empty endpoints, so I
don't think retroactively declaring the remote-endpoint property
required is a good idea.

Is there any driver that currently benefits from throwing an error on
empty endpoints in any way? I'd prefer to just let the core ignore empty
endpoints for all drivers.

regards
Philipp
