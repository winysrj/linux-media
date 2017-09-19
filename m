Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:38215 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751283AbdISMd4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Sep 2017 08:33:56 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        maxime.ripard@free-electrons.com, robh@kernel.org,
        hverkuil@xs4all.nl, devicetree@vger.kernel.org, pavel@ucw.cz,
        sre@kernel.org
Subject: Re: [PATCH v13 05/25] v4l: fwnode: Support generic parsing of graph endpoints in a device
Date: Tue, 19 Sep 2017 15:34:00 +0300
Message-ID: <1575295.QEfORVYfti@avalon>
In-Reply-To: <20170919121131.6m4cf4ftzhq7vpnc@paasikivi.fi.intel.com>
References: <20170915141724.23124-1-sakari.ailus@linux.intel.com> <2463205.SWm3RcFI57@avalon> <20170919121131.6m4cf4ftzhq7vpnc@paasikivi.fi.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Tuesday, 19 September 2017 15:11:32 EEST Sakari Ailus wrote:
> On Tue, Sep 19, 2017 at 02:35:01PM +0300, Laurent Pinchart wrote:
> > On Friday, 15 September 2017 17:17:04 EEST Sakari Ailus wrote:
> >> Add two functions for parsing devices graph endpoints:
> >> v4l2_async_notifier_parse_fwnode_endpoints and
> >> v4l2_async_notifier_parse_fwnode_endpoints_by_port. The former iterates
> >> over all endpoints whereas the latter only iterates over the endpoints
> >> in a given port.
> >> 
> >> The former is mostly useful for existing drivers that currently
> >> implement the iteration over all the endpoints themselves whereas the
> >> latter is especially intended for devices with both sinks and sources:
> >> async sub-devices for external devices connected to the device's sources
> >> will have already been set up, or they are part of the master device.
> > 
> > Did you mean s/or they/as they/ ?
> 
> No. There are two options here: either the sub-devices a sub-device is
> connected to (through a graph endpoint) is instantiated through the async
> framework *or* through the master device driver. But not by both of them at
> the same time.

The message is then contradicting itself:

"async sub-devices for external devices connected to the device's sources will 
have already been set up, or they are part of the master device."

They refers to "async sub-devices". If they're part of the master device, 
they're not async sub-devices.

-- 
Regards,

Laurent Pinchart
