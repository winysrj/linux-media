Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:12323 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728443AbeHMKMT (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Aug 2018 06:12:19 -0400
Date: Mon, 13 Aug 2018 10:31:04 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: jacopo mondi <jacopo@jmondi.org>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        slongerbeam@gmail.com, niklas.soderlund@ragnatech.se
Subject: Re: [PATCH 00/21] V4L2 fwnode rework; support for default
 configuration
Message-ID: <20180813073104.buh6kkl7yjsnttoz@paasikivi.fi.intel.com>
References: <20180723134706.15334-1-sakari.ailus@linux.intel.com>
 <20180810103857.GD7060@w540>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180810103857.GD7060@w540>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

On Fri, Aug 10, 2018 at 12:38:57PM +0200, jacopo mondi wrote:
> Hi Sakari,
>    thanks for this nice rework
> 
> On Mon, Jul 23, 2018 at 04:46:45PM +0300, Sakari Ailus wrote:
> > Hello everyone,
> >
> > I've long thought the V4L2 fwnode framework requires some work (it's buggy
> > and it does not adequately serve common needs). This set should address in
> > particular these matters:
> >
> > - Most devices support a particular media bus type but the V4L2 fwnode
> >   framework was not able to use such information, but instead tried to
> >   guess the bus type with varying levels of success while drivers
> >   generally ignored the results. This patchset makes that possible ---
> >   setting a bus type enables parsing configuration for only that bus.
> >   Failing that check results in returning -ENXIO to be returned.
> >
> > - Support specifying default configuration. If the endpoint has no
> >   configuration, the defaults set by the driver (as documented in DT
> >   bindings) will prevail. Any available configuration will still be read
> >   from the endpoint as one could expect. A common use case for this is
> >   e.g. the number of CSI-2 lanes. Few devices support lane mapping, and
> >   default 1:1 mapping is provided in absence of a valid default or
> >   configuration read OF.
> >
> > - Debugging information is greatly improved.
> >
> > - Recognition of the differences between CSI-2 D-PHY and C-PHY. All
> >   currently supported hardware (or at least drivers) is D-PHY only, so
> >   this change is still easy.
> >
> > The smiapp driver is converted to use the new functionality. This patchset
> > does not address remaining issues such as supporting setting defaults for
> > e.g. bridge drivers with multiple ports, but with Steve Longerbeam's
> > patchset we're much closer with that goal. I've rebased this set on top of
> > Steve's. Albeit the two deal with the same files, there were only a few
> > trivial conflicts.
> >
> > Note that I've only tested parsing endpoints for the CSI-2 bus (no
> > parallel IF hardware). Testing in general would be beneficial: the code
> > flows are rather convoluted and different hardware tends to excercise
> > different flows while the use of the use of defaults has a similar
> > effect.
> >
> 
> I have tested on a parallel device, and so far it's all good. I would
> like to test default settings next, and see how they behave.

Thanks a lot!

> 
> > Comments are welcome.
> >
> 
> In the meantine, looking at your (anticipated) v2, and in particular
> to this commit
> https://git.linuxtv.org/sailus/media_tree.git/commit/?h=v4l2-fwnode-next&id=077d73a3e1b66f9fbb1227245b1332cc1c7871d4
> I'm wondering if introducing an API to query the bus type from the
> firmware wouldn't be beneficial for bridge drivers (and possibly for
> sensor drivers too).

The current API are basically gives you two options:

1. Try with a given bus type, in which case you'll be able to set default
parameters as well. This is preferred as it allows setting defaults.

2. Let the fwnode framework decide.

Adding one more API function to tell the bus type to the driver wouldn't
change much. To be useful, one of the inputs would need to be a list of
possible bus types, and the fwnode framework would need to parse the
properties once again.

The way I see it is that it'd be likely most practical to simply try: for
hardware that supports more than one bus type, the bus-type property is
quasi mandatory. If there's an error, i.e. -ENXIO, the driver simply tries
a differen bus type --- with default parameters specific to that bus.

Usually there are just two possibilities, so there's not that many to
choose from anyway.

> 
> I see in that commit most drivers will set the bus type to 0 and rely
> on autoguessing, which is fine, but I'm thinking at peripheral that

Yes, the patchset at least currently does not try to improve those drivers
but just to maintain the functionality unchanged. There are quite few
changes already in the patchset and I'm trying to avoid regressions.

> can support two different media busses (eg. Parallel and BT.656) or
> sensor that can work with parallel or CSI-2 interface, and in that
> case would you consider something like:
> 
> static int bridge_driver_parse_of(struct device_node *np):
>         struct v4l2_fwnode_endpoint bus_cfg ;
> 
>         bus_type = v4l2_fwnode_get_bus_type(fwnode_handle(np);
>         if (bus_type != V4L2_MBUS_PARALLEL &&
>             bus_type != V4L2_MBUS_BT656)
>             return -ENXIO;

Very few drivers actually check the bus type currently, and then proceed
with accessing parameters of the bus they support --- whether or not it was
parsed by the V4L2 fwnode framework (or not).

> 
>         bus_cfg.bus_type = bus_type;
>         v4l2_fwnode_endpoint_parse(of_fwnode_handle(np), &bus_cfg);

Here, you'd set the default parameters for that bus.

> 
> Adding a function to retrieve the bus type specified in firmware would
> make easier for drivers to check if the configuration is acceptable (as
> this is a device specific decision) and use this information later to
> provide to v4l2_fwnode_endpoint_parse() a v4l2_fwnode_endpoint with
> the bus_type initialized, so it does not need to rely on autoguessing.
> 
> Otherwise, if I got this right, the only way not to go with
> autoguessing is to restrict the supported media bus type to a single
> one, which for some devices is a limitation.

Not quite. You can call v4l2_fwnode_endpoint_parse() multiple times --- as
the smiapp driver does.

For a driver point of view I don't see much difference whether you try all
(one or two) options or if you first query the bus type and then proceed
with parsing properties for that particular bus type.

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
