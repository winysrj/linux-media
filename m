Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34324 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1030862AbdIZU4I (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Sep 2017 16:56:08 -0400
Date: Tue, 26 Sep 2017 23:56:05 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, niklas.soderlund@ragnatech.se,
        maxime.ripard@free-electrons.com, robh@kernel.org,
        hverkuil@xs4all.nl, devicetree@vger.kernel.org, pavel@ucw.cz,
        sre@kernel.org
Subject: Re: [PATCH v13 05/25] v4l: fwnode: Support generic parsing of graph
 endpoints in a device
Message-ID: <20170926205604.ds2pmwqhma7246qz@valkosipuli.retiisi.org.uk>
References: <20170915141724.23124-1-sakari.ailus@linux.intel.com>
 <2463205.SWm3RcFI57@avalon>
 <20170919121131.6m4cf4ftzhq7vpnc@paasikivi.fi.intel.com>
 <1575295.QEfORVYfti@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1575295.QEfORVYfti@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Sep 19, 2017 at 03:34:00PM +0300, Laurent Pinchart wrote:
> Hi Sakari,
> 
> On Tuesday, 19 September 2017 15:11:32 EEST Sakari Ailus wrote:
> > On Tue, Sep 19, 2017 at 02:35:01PM +0300, Laurent Pinchart wrote:
> > > On Friday, 15 September 2017 17:17:04 EEST Sakari Ailus wrote:
> > >> Add two functions for parsing devices graph endpoints:
> > >> v4l2_async_notifier_parse_fwnode_endpoints and
> > >> v4l2_async_notifier_parse_fwnode_endpoints_by_port. The former iterates
> > >> over all endpoints whereas the latter only iterates over the endpoints
> > >> in a given port.
> > >> 
> > >> The former is mostly useful for existing drivers that currently
> > >> implement the iteration over all the endpoints themselves whereas the
> > >> latter is especially intended for devices with both sinks and sources:
> > >> async sub-devices for external devices connected to the device's sources
> > >> will have already been set up, or they are part of the master device.
> > > 
> > > Did you mean s/or they/as they/ ?
> > 
> > No. There are two options here: either the sub-devices a sub-device is
> > connected to (through a graph endpoint) is instantiated through the async
> > framework *or* through the master device driver. But not by both of them at
> > the same time.
> 
> The message is then contradicting itself:
> 
> "async sub-devices for external devices connected to the device's sources will 
> have already been set up, or they are part of the master device."
> 
> They refers to "async sub-devices". If they're part of the master device, 
> they're not async sub-devices.

Ah, now I see what you mean. I'll replace "they" with "the external
sub-devices". The paragraph becomes:

The former is mostly useful for existing drivers that currently implement
the iteration over all the endpoints themselves whereas the latter is
especially intended for devices with both sinks and sources: async
sub-devices for external devices connected to the device's sources will
have already been set up, or the external sub-devices are part of the  
master device.

How about that?

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
