Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:55573 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752090AbeB0JNR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Feb 2018 04:13:17 -0500
Message-ID: <1519722784.3402.12.camel@pengutronix.de>
Subject: Re: [PATCH 01/13] media: v4l2-fwnode: Let parse_endpoint callback
 decide if no remote is error
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Yong Zhi <yong.zhi@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        niklas.soderlund@ragnatech.se, Sebastian Reichel <sre@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        devicetree@vger.kernel.org
Date: Tue, 27 Feb 2018 10:13:04 +0100
In-Reply-To: <20180223124741.d4l4vjahe6beqe65@paasikivi.fi.intel.com>
References: <1519263589-19647-1-git-send-email-steve_longerbeam@mentor.com>
         <3283028.CgXzGkPyKt@avalon> <1519379812.7712.1.camel@pengutronix.de>
         <2571855.0gglA1aPyk@avalon> <1519384577.7712.4.camel@pengutronix.de>
         <20180223124741.d4l4vjahe6beqe65@paasikivi.fi.intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Fri, 2018-02-23 at 14:47 +0200, Sakari Ailus wrote:
> Hi Philipp,
> 
> On Fri, Feb 23, 2018 at 12:16:17PM +0100, Philipp Zabel wrote:
> > Hi Laurent,
> > 
> > On Fri, 2018-02-23 at 12:05 +0200, Laurent Pinchart wrote:
> > > Hi Philipp,
> > > 
> > > On Friday, 23 February 2018 11:56:52 EET Philipp Zabel wrote:
> > > > On Fri, 2018-02-23 at 11:29 +0200, Laurent Pinchart wrote:
> > > > > On Thursday, 22 February 2018 03:39:37 EET Steve Longerbeam wrote:
> > > > > > For some subdevices, a fwnode endpoint that has no connection to a
> > > > > > remote endpoint may not be an error. Let the parse_endpoint callback
> > > > > 
> > > > > make that decision in v4l2_async_notifier_fwnode_parse_endpoint(). If
> > > > > > the callback indicates that is not an error, skip adding the asd to the
> > > > > > notifier and return 0.
> > > > > > 
> > > > > > For the current users of v4l2_async_notifier_parse_fwnode_endpoints()
> > > > > > (omap3isp, rcar-vin, intel-ipu3), return -EINVAL in the callback for
> > > > > > unavailable remote fwnodes to maintain the previous behavior.
> > > > > 
> > > > > I'm not sure this should be a per-driver decision.
> > > > > 
> > > > > Generally speaking, if an endpoint node has no remote-endpoint property,
> > > > > the endpoint node is not needed. I've always considered such an endpoint
> > > > > node as invalid. The OF graphs DT bindings are however not clear on this
> > > > > subject.
> > > > 
> > > > Documentation/devicetree/bindings/graph.txt says:
> > > > 
> > > >   Each endpoint should contain a 'remote-endpoint' phandle property
> > > >   that points to the corresponding endpoint in the port of the remote
> > > >   device.
> > > > 
> > > > ("should", not "must").
> > > 
> > > The DT bindings documentation has historically used "should" to mean "must" in 
> > > many places :-( That was a big mistake.
> > 
> > Maybe I could have worded that better? The intention was to let "should"
> > be read as a strong suggestion, like "it is recommended", but not as a
> > requirement.
> 
> Is there a reason for have an endpoint without a remote-endpoint property?

It allows to slightly reduce boilerplate in board device trees at the
cost of empty endpoint nodes included from the dtsi in board DTs that
don't use them.

> The problem with should (in general when it is used when the intention is
> "shall") is that it lets the developer to write broken DT source that is
> still conforming to the spec.
>
> I don't have a strong preference to change should to shall in this
> particular case now but I would have used "shall" to begin with.

I used "should" on purpose, but I'd be fine with giving up on it when
all current users of this loophole are transitioned away from it:

  git grep -A1 "endpoint {" arch/ | grep -B1 "};"

I'm very much against enforcing a required remote-endpoint property in
core DT parsing code, though.

> > > > Later, the remote-node property explicitly lists the remote-endpoint
> > > > property as optional.
> > > 
> > > I've seen that too, and that's why I mentioned that the documentation isn't 
> > > clear on the subject.
> > 
> > Do you have a suggestion how to improve the documentation? I thought
> > listing the remote-endpoint property under a header called "Optional
> > endpoint properties" was pretty clear.
> > 
> > > This could also be achieved by adding the endpoints in the board DT files. See 
> > > for instance the hdmi@fead0000 node in arch/arm64/boot/dts/renesas/
> > > r8a7795.dtsi and how it gets extended in arch/arm64/boot/dts/renesas/r8a7795-
> > > salvator-x.dts. On the other hand, I also have empty endpoints in the 
> > > display@feb00000 node of arch/arm64/boot/dts/renesas/r8a7795.dtsi.
> > 
> > Right, that would be possible.
> > 
> > > I think we should first decide what we want to do going forward (allowing for 
> > > empty endpoints or not), clarify the documentation, and then update the code. 
> > > In any case I don't think it should be a per-device decision.
> > 
> > There are device trees in the wild that have those empty endpoints, so I
> > don't think retroactively declaring the remote-endpoint property
> > required is a good idea.
> 
> You could IMO, but the kernel (and existing drivers) would still need to
> work with DT binaries without those bits. And leave comments in the code
> why it's there.
>
> > 
> > Is there any driver that currently benefits from throwing an error on
> > empty endpoints in any way? I'd prefer to just let the core ignore empty
> > endpoints for all drivers.
> 
> Not necessarily, but it's overhead in parsing the DT as well as in the
> DT source and in the DT binary.

True. I suppose whether or not that is enough reason to change the
wording in the existing of-graph bindings is something to be decided on
the devicetree list (in Cc).

regards
Philipp
