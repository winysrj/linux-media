Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:52115 "EHLO
        relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726889AbeH2EtB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Aug 2018 00:49:01 -0400
Subject: Re: [PATCH v2 00/23] V4L2 fwnode rework; support for default
 configuration
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        <linux-media@vger.kernel.org>
CC: <devicetree@vger.kernel.org>, <slongerbeam@gmail.com>,
        <niklas.soderlund@ragnatech.se>, <jacopo@jmondi.org>
References: <20180827093000.29165-1-sakari.ailus@linux.intel.com>
From: Steve Longerbeam <steve_longerbeam@mentor.com>
Message-ID: <b48fd4d7-22cd-64d5-019c-aa1ab92ad130@mentor.com>
Date: Tue, 28 Aug 2018 17:53:51 -0700
MIME-Version: 1.0
In-Reply-To: <20180827093000.29165-1-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,


On 08/27/2018 02:29 AM, Sakari Ailus wrote:
> Hello everyone,
>
> I've long thought the V4L2 fwnode framework requires some work (it's buggy
> and it does not adequately serve common needs). This set should address in
> particular these matters:
>
> - Most devices support a particular media bus type but the V4L2 fwnode
>    framework was not able to use such information, but instead tried to
>    guess the bus type with varying levels of success while drivers
>    generally ignored the results. This patchset makes that possible ---
>    setting a bus type enables parsing configuration for only that bus.
>    Failing that check results in returning -ENXIO to be returned.
>
> - Support specifying default configuration. If the endpoint has no
>    configuration, the defaults set by the driver (as documented in DT
>    bindings) will prevail. Any available configuration will still be read
>    from the endpoint as one could expect. A common use case for this is
>    e.g. the number of CSI-2 lanes. Few devices support lane mapping, and
>    default 1:1 mapping is provided in absence of a valid default or
>    configuration read OF.
>
> - Debugging information is greatly improved.
>
> - Recognition of the differences between CSI-2 D-PHY and C-PHY. All
>    currently supported hardware (or at least drivers) is D-PHY only, so
>    this change is still easy.
>
> The smiapp driver is converted to use the new functionality. This patchset
> does not address remaining issues such as supporting setting defaults for
> e.g. bridge drivers with multiple ports, but with Steve Longerbeam's
> patchset we're much closer to that goal. I've rebased this set on top of
> Steve's. Albeit the two deal with the same files, there were only a few
> trivial conflicts.
>
> Note that I've only tested parsing endpoints for the CSI-2 bus (no
> parallel IF hardware). Jacopo has tested an earlier version of the set
> with a few changes to the parallel bus handling compared to this one.
>
> Comments are welcome.

I got around to testing this. The following diff needs to be added
to initialize bus_type before calling v4l2_fwnode_endpoint_parse()
in imx-media driver, this should probably be squashed with
"v4l: fwnode: Initialise the V4L2 fwnode endpoints to zero":

diff --git a/drivers/staging/media/imx/imx-media-csi.c 
b/drivers/staging/media/imx/imx-media-csi.c
index 539159d..ac9d718 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -1050,7 +1050,7 @@ static int csi_link_validate(struct v4l2_subdev *sd,
                              struct v4l2_subdev_format *sink_fmt)
  {
         struct csi_priv *priv = v4l2_get_subdevdata(sd);
-       struct v4l2_fwnode_endpoint upstream_ep = {};
+       struct v4l2_fwnode_endpoint upstream_ep = { .bus_type = 0 };
         bool is_csi2;
         int ret;

@@ -1164,7 +1164,7 @@ static int csi_enum_mbus_code(struct v4l2_subdev *sd,
                               struct v4l2_subdev_mbus_code_enum *code)
  {
         struct csi_priv *priv = v4l2_get_subdevdata(sd);
-       struct v4l2_fwnode_endpoint upstream_ep;
+       struct v4l2_fwnode_endpoint upstream_ep = { .bus_type = 0 };
         const struct imx_media_pixfmt *incc;
         struct v4l2_mbus_framefmt *infmt;
         int ret = 0;
@@ -1403,7 +1403,7 @@ static int csi_set_fmt(struct v4l2_subdev *sd,
  {
         struct csi_priv *priv = v4l2_get_subdevdata(sd);
         struct imx_media_video_dev *vdev = priv->vdev;
-       struct v4l2_fwnode_endpoint upstream_ep;
+       struct v4l2_fwnode_endpoint upstream_ep = { .bus_type = 0 };
         const struct imx_media_pixfmt *cc;
         struct v4l2_pix_format vdev_fmt;
         struct v4l2_mbus_framefmt *fmt;
@@ -1542,7 +1542,7 @@ static int csi_set_selection(struct v4l2_subdev *sd,
                              struct v4l2_subdev_selection *sel)
  {
         struct csi_priv *priv = v4l2_get_subdevdata(sd);
-       struct v4l2_fwnode_endpoint upstream_ep;
+       struct v4l2_fwnode_endpoint upstream_ep = { .bus_type = 0 };
         struct v4l2_mbus_framefmt *infmt;
         struct v4l2_rect *crop, *compose;
         int pad, ret;


After making that change, capture from CSI-2 OV5640 and parallel
OV5642 on the imx6q Sabrelite is working fine. Feel free to add my
Tested-by on that platform.

>
> I've pushed the patches (including Steve's) here:
>
> <URL:https://git.linuxtv.org/sailus/media_tree.git/log/?h=v4l2-fwnode-next>
>
> since v1:
>
> - Rebase it all on current media tree master --- there was a conflict in
>    drivers/media/platform/qcom/camss/camss.c in Steve's patch "media:
>    platform: Switch to v4l2_async_notifier_add_subdev"; I hope the
>    resolution was fine.

I checked your resolution to camss.c and it was the same resolution I
made as well.

Thanks,
Steve

>
> - Default to Bt.656 bus in guessing the bus type if no properties
>    suggesting otherwise are set. In v1 and error was returned, which would
>    have been troublesome for the existing drivers.
>
> - Set the bus_type field to zero (i.e. guess) for existing callers of
>    v4l2_fwnode_endpoint_(alloc_)parse.
>
> - Improved documentation for v4l2_fwnode_endpoint_parse and
>    v4l2_fwnode_endpoint_alloc_parse.
>
> Sakari Ailus (23):
>    v4l: fwnode: Add debug prints for V4L2 endpoint property parsing
>    v4l: fwnode: Use fwnode_graph_for_each_endpoint
>    v4l: fwnode: The CSI-2 clock is continuous if it's not non-continuous
>    dt-bindings: media: Specify bus type for MIPI D-PHY, others,
>      explicitly
>    v4l: fwnode: Add definitions for CSI-2 D-PHY, parallel and Bt.656
>      busses
>    v4l: mediabus: Recognise CSI-2 D-PHY and C-PHY
>    v4l: fwnode: Let the caller provide V4L2 fwnode endpoint
>    v4l: fwnode: Detect bus type correctly
>    v4l: fwnode: Make use of newly specified bus types
>    v4l: fwnode: Read lane inversion information despite lane numbering
>    v4l: fwnode: Only assign configuration if there is no error
>    v4l: fwnode: Support driver-defined lane mapping defaults
>    v4l: fwnode: Support default CSI-2 lane mapping for drivers
>    v4l: fwnode: Parse the graph endpoint as last
>    v4l: fwnode: Use default parallel flags
>    v4l: fwnode: Initialise the V4L2 fwnode endpoints to zero
>    v4l: fwnode: Only zero the struct if bus type is set to
>      V4L2_MBUS_UNKNOWN
>    v4l: fwnode: Use media bus type for bus parser selection
>    v4l: fwnode: Print bus type
>    v4l: fwnode: Use V4L2 fwnode endpoint media bus type if set
>    v4l: fwnode: Support parsing of CSI-2 C-PHY endpoints
>    v4l: fwnode: Update V4L2 fwnode endpoint parsing documentation
>    smiapp: Query the V4L2 endpoint for a specific bus type
>
>   .../devicetree/bindings/media/video-interfaces.txt |   4 +-
>   drivers/gpu/ipu-v3/ipu-csi.c                       |   2 +-
>   drivers/media/i2c/adv7180.c                        |   2 +-
>   drivers/media/i2c/adv7604.c                        |   2 +-
>   drivers/media/i2c/mt9v032.c                        |   2 +-
>   drivers/media/i2c/ov2659.c                         |  14 +-
>   drivers/media/i2c/ov5640.c                         |   4 +-
>   drivers/media/i2c/ov5645.c                         |   2 +-
>   drivers/media/i2c/ov5647.c                         |   2 +-
>   drivers/media/i2c/ov7251.c                         |   4 +-
>   drivers/media/i2c/ov7670.c                         |   2 +-
>   drivers/media/i2c/s5c73m3/s5c73m3-core.c           |   4 +-
>   drivers/media/i2c/s5k5baf.c                        |   6 +-
>   drivers/media/i2c/s5k6aa.c                         |   2 +-
>   drivers/media/i2c/smiapp/smiapp-core.c             |  34 +-
>   drivers/media/i2c/soc_camera/ov5642.c              |   2 +-
>   drivers/media/i2c/tc358743.c                       |  28 +-
>   drivers/media/i2c/tda1997x.c                       |   2 +-
>   drivers/media/i2c/tvp514x.c                        |   2 +-
>   drivers/media/i2c/tvp5150.c                        |   2 +-
>   drivers/media/i2c/tvp7002.c                        |   2 +-
>   drivers/media/pci/intel/ipu3/ipu3-cio2.c           |   2 +-
>   drivers/media/platform/am437x/am437x-vpfe.c        |   2 +-
>   drivers/media/platform/atmel/atmel-isc.c           |   3 +-
>   drivers/media/platform/atmel/atmel-isi.c           |   2 +-
>   drivers/media/platform/cadence/cdns-csi2rx.c       |   4 +-
>   drivers/media/platform/cadence/cdns-csi2tx.c       |   4 +-
>   drivers/media/platform/davinci/vpif_capture.c      |   2 +-
>   drivers/media/platform/exynos4-is/media-dev.c      |   2 +-
>   drivers/media/platform/exynos4-is/mipi-csis.c      |   2 +-
>   drivers/media/platform/marvell-ccic/mcam-core.c    |   4 +-
>   drivers/media/platform/marvell-ccic/mmp-driver.c   |   2 +-
>   drivers/media/platform/omap3isp/isp.c              |   2 +-
>   drivers/media/platform/pxa_camera.c                |   4 +-
>   drivers/media/platform/rcar-vin/rcar-csi2.c        |   4 +-
>   drivers/media/platform/renesas-ceu.c               |   3 +-
>   drivers/media/platform/soc_camera/soc_mediabus.c   |   2 +-
>   drivers/media/platform/stm32/stm32-dcmi.c          |   4 +-
>   drivers/media/platform/ti-vpe/cal.c                |   2 +-
>   drivers/media/v4l2-core/v4l2-fwnode.c              | 508 ++++++++++++++++-----
>   drivers/staging/media/imx/imx-media-csi.c          |   2 +-
>   drivers/staging/media/imx/imx6-mipi-csi2.c         |   2 +-
>   drivers/staging/media/imx074/imx074.c              |   2 +-
>   include/media/v4l2-fwnode.h                        |  60 ++-
>   include/media/v4l2-mediabus.h                      |   8 +-
>   45 files changed, 536 insertions(+), 220 deletions(-)
>
