Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:60431 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727381AbeHJNIU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Aug 2018 09:08:20 -0400
Date: Fri, 10 Aug 2018 12:38:57 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        slongerbeam@gmail.com, niklas.soderlund@ragnatech.se
Subject: Re: [PATCH 00/21] V4L2 fwnode rework; support for default
 configuration
Message-ID: <20180810103857.GD7060@w540>
References: <20180723134706.15334-1-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="8w3uRX/HFJGApMzv"
Content-Disposition: inline
In-Reply-To: <20180723134706.15334-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--8w3uRX/HFJGApMzv
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Sakari,
   thanks for this nice rework

On Mon, Jul 23, 2018 at 04:46:45PM +0300, Sakari Ailus wrote:
> Hello everyone,
>
> I've long thought the V4L2 fwnode framework requires some work (it's buggy
> and it does not adequately serve common needs). This set should address in
> particular these matters:
>
> - Most devices support a particular media bus type but the V4L2 fwnode
>   framework was not able to use such information, but instead tried to
>   guess the bus type with varying levels of success while drivers
>   generally ignored the results. This patchset makes that possible ---
>   setting a bus type enables parsing configuration for only that bus.
>   Failing that check results in returning -ENXIO to be returned.
>
> - Support specifying default configuration. If the endpoint has no
>   configuration, the defaults set by the driver (as documented in DT
>   bindings) will prevail. Any available configuration will still be read
>   from the endpoint as one could expect. A common use case for this is
>   e.g. the number of CSI-2 lanes. Few devices support lane mapping, and
>   default 1:1 mapping is provided in absence of a valid default or
>   configuration read OF.
>
> - Debugging information is greatly improved.
>
> - Recognition of the differences between CSI-2 D-PHY and C-PHY. All
>   currently supported hardware (or at least drivers) is D-PHY only, so
>   this change is still easy.
>
> The smiapp driver is converted to use the new functionality. This patchset
> does not address remaining issues such as supporting setting defaults for
> e.g. bridge drivers with multiple ports, but with Steve Longerbeam's
> patchset we're much closer with that goal. I've rebased this set on top of
> Steve's. Albeit the two deal with the same files, there were only a few
> trivial conflicts.
>
> Note that I've only tested parsing endpoints for the CSI-2 bus (no
> parallel IF hardware). Testing in general would be beneficial: the code
> flows are rather convoluted and different hardware tends to excercise
> different flows while the use of the use of defaults has a similar
> effect.
>

I have tested on a parallel device, and so far it's all good. I would
like to test default settings next, and see how they behave.

> Comments are welcome.
>

In the meantine, looking at your (anticipated) v2, and in particular
to this commit
https://git.linuxtv.org/sailus/media_tree.git/commit/?h=v4l2-fwnode-next&id=077d73a3e1b66f9fbb1227245b1332cc1c7871d4
I'm wondering if introducing an API to query the bus type from the
firmware wouldn't be beneficial for bridge drivers (and possibly for
sensor drivers too).

I see in that commit most drivers will set the bus type to 0 and rely
on autoguessing, which is fine, but I'm thinking at peripheral that
can support two different media busses (eg. Parallel and BT.656) or
sensor that can work with parallel or CSI-2 interface, and in that
case would you consider something like:

static int bridge_driver_parse_of(struct device_node *np):
        struct v4l2_fwnode_endpoint bus_cfg ;

        bus_type = v4l2_fwnode_get_bus_type(fwnode_handle(np);
        if (bus_type != V4L2_MBUS_PARALLEL &&
            bus_type != V4L2_MBUS_BT656)
            return -ENXIO;

        bus_cfg.bus_type = bus_type;
        v4l2_fwnode_endpoint_parse(of_fwnode_handle(np), &bus_cfg);

Adding a function to retrieve the bus type specified in firmware would
make easier for drivers to check if the configuration is acceptable (as
this is a device specific decision) and use this information later to
provide to v4l2_fwnode_endpoint_parse() a v4l2_fwnode_endpoint with
the bus_type initialized, so it does not need to rely on autoguessing.

Otherwise, if I got this right, the only way not to go with
autoguessing is to restrict the supported media bus type to a single
one, which for some devices is a limitation.

Does this makes sense to you?

Thanks
   j

> I've pushed the patches (including Steve's) here:
>
> <URL:https://git.linuxtv.org/sailus/media_tree.git/log/?h=v4l2-fwnode>
>
> Sakari Ailus (21):
>   v4l: fwnode: Add debug prints for V4L2 endpoint property parsing
>   v4l: fwnode: Use fwnode_graph_for_each_endpoint
>   v4l: fwnode: Detect bus type correctly
>   v4l: fwnode: The CSI-2 clock is continuous if it's not non-continuous
>   dt-bindings: media: Specify bus type for MIPI D-PHY, others,
>     explicitly
>   v4l: fwnode: Add definitions for CSI-2 D-PHY, parallel and Bt.656
>     busses
>   v4l: mediabus: Recognise CSI-2 D-PHY and C-PHY
>   v4l: fwnode: Make use of newly specified bus types
>   v4l: fwnode: Read lane inversion information despite lane numbering
>   v4l: fwnode: Only assign configuration if there is no error
>   v4l: fwnode: Support driver-defined lane mapping defaults
>   v4l: fwnode: Support default CSI-2 lane mapping for drivers
>   v4l: fwnode: Parse the graph endpoint as last
>   v4l: fwnode: Use default parallel flags
>   v4l: fwnode: Allow setting default parameters
>   v4l: fwnode: Use media bus type for bus parser selection
>   v4l: fwnode: Print bus type
>   v4l: fwnode: Use V4L2 fwnode endpoint media bus type if set
>   v4l: fwnode: Support parsing of CSI-2 C-PHY endpoints
>   v4l: fwnode: Update V4L2 fwnode endpoint parsing documentation
>   smiapp: Query the V4L2 endpoint for a specific bus type
>
>  .../devicetree/bindings/media/video-interfaces.txt |   4 +-
>  drivers/gpu/ipu-v3/ipu-csi.c                       |   2 +-
>  drivers/media/i2c/adv7180.c                        |   2 +-
>  drivers/media/i2c/ov2659.c                         |  14 +-
>  drivers/media/i2c/ov5640.c                         |   4 +-
>  drivers/media/i2c/ov5645.c                         |   2 +-
>  drivers/media/i2c/ov7251.c                         |   4 +-
>  drivers/media/i2c/s5c73m3/s5c73m3-core.c           |   2 +-
>  drivers/media/i2c/s5k5baf.c                        |   4 +-
>  drivers/media/i2c/s5k6aa.c                         |   2 +-
>  drivers/media/i2c/smiapp/smiapp-core.c             |  34 +-
>  drivers/media/i2c/soc_camera/ov5642.c              |   2 +-
>  drivers/media/i2c/tc358743.c                       |  28 +-
>  drivers/media/pci/intel/ipu3/ipu3-cio2.c           |   2 +-
>  drivers/media/platform/cadence/cdns-csi2rx.c       |   2 +-
>  drivers/media/platform/cadence/cdns-csi2tx.c       |   2 +-
>  drivers/media/platform/marvell-ccic/mcam-core.c    |   4 +-
>  drivers/media/platform/marvell-ccic/mmp-driver.c   |   2 +-
>  drivers/media/platform/omap3isp/isp.c              |   2 +-
>  drivers/media/platform/pxa_camera.c                |   2 +-
>  drivers/media/platform/rcar-vin/rcar-csi2.c        |   2 +-
>  drivers/media/platform/soc_camera/soc_mediabus.c   |   2 +-
>  drivers/media/platform/stm32/stm32-dcmi.c          |   2 +-
>  drivers/media/platform/ti-vpe/cal.c                |   2 +-
>  drivers/media/v4l2-core/v4l2-fwnode.c              | 510 ++++++++++++++++-----
>  drivers/staging/media/imx/imx-media-csi.c          |   2 +-
>  drivers/staging/media/imx/imx6-mipi-csi2.c         |   2 +-
>  drivers/staging/media/imx074/imx074.c              |   2 +-
>  include/media/v4l2-fwnode.h                        |  33 +-
>  include/media/v4l2-mediabus.h                      |   8 +-
>  30 files changed, 505 insertions(+), 180 deletions(-)
>
> --
> 2.11.0

--8w3uRX/HFJGApMzv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJbbWtBAAoJEHI0Bo8WoVY8BrkP/2OX8Q/thsw8zftjQHRWKSAb
TOI+R+uyVjbOjEi781mb81vf7CZsQgh6bFYzhbyHuu1eqtvRTdkfG119XR5aI0VQ
nv1SSphuUcC3HS29/xnBb9NhtzR0xDv3EWrvKZHneAsRafZ2n0w4gt0PWfnIChdt
5edh0j2kBNs1vp9jKG14++zXk8YxsSisgtHhbnwHkRayy8vcuiohTs0SKm23zWPq
zfq45aRUu2wb/q7lr7bOfNRqaXLBMY9C1Z/LAUyLPHQCMBK1paqtfhQHaz0Mn/iZ
vxjObSxyzSDFFcHsS2CgLcQ2WTySrjPrQE5G5kHk00qVRsFJ5APKAlVUDEIyHeds
Q9+Lc3kqi0AcJSVfGGzaQkHyHMC9PQN4GMPrxeDIFFHXKE/ePI0trzv0omxMoHv8
SRRtrO2yy5romQv414fKI50RAh9kZcWQpPdixa+dalEOE6cMkmNsDiJXYc3EtaBH
+WxZkaMzSsc9G66Xb4lQ6/H/uGz6zE8xofKUCqFZm5Y8W2uLO8irKMnihIeyTesf
BMgE5sCzzeHr9C+9Aq0SrAKMq/ivUT92YqitGcmQdhSe+qYYfNIa/oJGcw+5ohlQ
XVDICVZvk68NhMr8FcRb/RykroTDH4uagLu50svYhlFOUwm9OBtcaKBFAva52uaT
DydKqTrhqRIomRNuTHKP
=m13A
-----END PGP SIGNATURE-----

--8w3uRX/HFJGApMzv--
