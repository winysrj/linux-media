Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:38117 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751089AbeBWJ5F (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Feb 2018 04:57:05 -0500
Message-ID: <1519379812.7712.1.camel@pengutronix.de>
Subject: Re: [PATCH 01/13] media: v4l2-fwnode: Let parse_endpoint callback
 decide if no remote is error
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Steve Longerbeam <slongerbeam@gmail.com>
Cc: Yong Zhi <yong.zhi@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        niklas.soderlund@ragnatech.se, Sebastian Reichel <sre@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Date: Fri, 23 Feb 2018 10:56:52 +0100
In-Reply-To: <3283028.CgXzGkPyKt@avalon>
References: <1519263589-19647-1-git-send-email-steve_longerbeam@mentor.com>
         <1519263589-19647-2-git-send-email-steve_longerbeam@mentor.com>
         <3283028.CgXzGkPyKt@avalon>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Fri, 2018-02-23 at 11:29 +0200, Laurent Pinchart wrote:
> Hi Steve,
> 
> Thank you for the patch.
> 
> On Thursday, 22 February 2018 03:39:37 EET Steve Longerbeam wrote:
> > For some subdevices, a fwnode endpoint that has no connection to a remote
> > endpoint may not be an error. Let the parse_endpoint callback make that
> > decision in v4l2_async_notifier_fwnode_parse_endpoint(). If the callback
> > indicates that is not an error, skip adding the asd to the notifier and
> > return 0.
> > 
> > For the current users of v4l2_async_notifier_parse_fwnode_endpoints()
> > (omap3isp, rcar-vin, intel-ipu3), return -EINVAL in the callback for
> > unavailable remote fwnodes to maintain the previous behavior.
> 
> I'm not sure this should be a per-driver decision.
> 
> Generally speaking, if an endpoint node has no remote-endpoint property, the 
> endpoint node is not needed. I've always considered such an endpoint node as 
> invalid. The OF graphs DT bindings are however not clear on this subject.

Documentation/devicetree/bindings/graph.txt says:

  Each endpoint should contain a 'remote-endpoint' phandle property
  that points to the corresponding endpoint in the port of the remote
  device.

("should", not "must"). Later, the remote-node property explicitly lists
the remote-endpoint property as optional.

> I have either failed to notice when they got merged, or they slowly evolved over 
> time to contain contradictory information. In any case, I think we should 
> decide on whether such a situation is valid or not from an OF graph point of 
> view, and then always reject or always accept and ignore those endpoints.

We are currently using this on i.MX6 to provide empty labeled endpoints
in the dtsi files for board DT writers to link to, both for the display
output and video capture ports.
See for example the endpoints with the labels ipu1_di0_disp0 and
ipu1_csi0_mux_from_parallel_sensor in arch/arm/boot/dts/imx6q.dtsi.

regards
Philipp
