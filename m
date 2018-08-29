Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:49334 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727452AbeH2QtS (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Aug 2018 12:49:18 -0400
Date: Wed, 29 Aug 2018 15:52:01 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Steve Longerbeam <steve_longerbeam@mentor.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        slongerbeam@gmail.com, niklas.soderlund@ragnatech.se,
        jacopo@jmondi.org
Subject: Re: [PATCH v2 00/23] V4L2 fwnode rework; support for default
 configuration
Message-ID: <20180829125201.sw66depq5qvualfw@paasikivi.fi.intel.com>
References: <20180827093000.29165-1-sakari.ailus@linux.intel.com>
 <b48fd4d7-22cd-64d5-019c-aa1ab92ad130@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b48fd4d7-22cd-64d5-019c-aa1ab92ad130@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steve,

On Tue, Aug 28, 2018 at 05:53:51PM -0700, Steve Longerbeam wrote:
> Hi Sakari,
> 
> 
> On 08/27/2018 02:29 AM, Sakari Ailus wrote:
> > Hello everyone,
> > 
> > I've long thought the V4L2 fwnode framework requires some work (it's buggy
> > and it does not adequately serve common needs). This set should address in
> > particular these matters:
> > 
> > - Most devices support a particular media bus type but the V4L2 fwnode
> >    framework was not able to use such information, but instead tried to
> >    guess the bus type with varying levels of success while drivers
> >    generally ignored the results. This patchset makes that possible ---
> >    setting a bus type enables parsing configuration for only that bus.
> >    Failing that check results in returning -ENXIO to be returned.
> > 
> > - Support specifying default configuration. If the endpoint has no
> >    configuration, the defaults set by the driver (as documented in DT
> >    bindings) will prevail. Any available configuration will still be read
> >    from the endpoint as one could expect. A common use case for this is
> >    e.g. the number of CSI-2 lanes. Few devices support lane mapping, and
> >    default 1:1 mapping is provided in absence of a valid default or
> >    configuration read OF.
> > 
> > - Debugging information is greatly improved.
> > 
> > - Recognition of the differences between CSI-2 D-PHY and C-PHY. All
> >    currently supported hardware (or at least drivers) is D-PHY only, so
> >    this change is still easy.
> > 
> > The smiapp driver is converted to use the new functionality. This patchset
> > does not address remaining issues such as supporting setting defaults for
> > e.g. bridge drivers with multiple ports, but with Steve Longerbeam's
> > patchset we're much closer to that goal. I've rebased this set on top of
> > Steve's. Albeit the two deal with the same files, there were only a few
> > trivial conflicts.
> > 
> > Note that I've only tested parsing endpoints for the CSI-2 bus (no
> > parallel IF hardware). Jacopo has tested an earlier version of the set
> > with a few changes to the parallel bus handling compared to this one.
> > 
> > Comments are welcome.
> 
> I got around to testing this. The following diff needs to be added
> to initialize bus_type before calling v4l2_fwnode_endpoint_parse()
> in imx-media driver, this should probably be squashed with
> "v4l: fwnode: Initialise the V4L2 fwnode endpoints to zero":

Thanks for the patch. Apologies for missing the IMX changes; I guess it
happened as it was the only driver that needed the changes in the staging
tree.

I've merged the changes below. Btw. your email client doesn't seem to like
tabs; I replaced the spaces with tabs and the changes were merged fine.

> 
> diff --git a/drivers/staging/media/imx/imx-media-csi.c
> b/drivers/staging/media/imx/imx-media-csi.c
> index 539159d..ac9d718 100644
> --- a/drivers/staging/media/imx/imx-media-csi.c
> +++ b/drivers/staging/media/imx/imx-media-csi.c
> @@ -1050,7 +1050,7 @@ static int csi_link_validate(struct v4l2_subdev *sd,
>                              struct v4l2_subdev_format *sink_fmt)
>  {
>         struct csi_priv *priv = v4l2_get_subdevdata(sd);
> -       struct v4l2_fwnode_endpoint upstream_ep = {};
> +       struct v4l2_fwnode_endpoint upstream_ep = { .bus_type = 0 };
>         bool is_csi2;
>         int ret;
> 
> @@ -1164,7 +1164,7 @@ static int csi_enum_mbus_code(struct v4l2_subdev *sd,
>                               struct v4l2_subdev_mbus_code_enum *code)
>  {
>         struct csi_priv *priv = v4l2_get_subdevdata(sd);
> -       struct v4l2_fwnode_endpoint upstream_ep;
> +       struct v4l2_fwnode_endpoint upstream_ep = { .bus_type = 0 };
>         const struct imx_media_pixfmt *incc;
>         struct v4l2_mbus_framefmt *infmt;
>         int ret = 0;
> @@ -1403,7 +1403,7 @@ static int csi_set_fmt(struct v4l2_subdev *sd,
>  {
>         struct csi_priv *priv = v4l2_get_subdevdata(sd);
>         struct imx_media_video_dev *vdev = priv->vdev;
> -       struct v4l2_fwnode_endpoint upstream_ep;
> +       struct v4l2_fwnode_endpoint upstream_ep = { .bus_type = 0 };
>         const struct imx_media_pixfmt *cc;
>         struct v4l2_pix_format vdev_fmt;
>         struct v4l2_mbus_framefmt *fmt;
> @@ -1542,7 +1542,7 @@ static int csi_set_selection(struct v4l2_subdev *sd,
>                              struct v4l2_subdev_selection *sel)
>  {
>         struct csi_priv *priv = v4l2_get_subdevdata(sd);
> -       struct v4l2_fwnode_endpoint upstream_ep;
> +       struct v4l2_fwnode_endpoint upstream_ep = { .bus_type = 0 };
>         struct v4l2_mbus_framefmt *infmt;
>         struct v4l2_rect *crop, *compose;
>         int pad, ret;
> 
> 
> After making that change, capture from CSI-2 OV5640 and parallel
> OV5642 on the imx6q Sabrelite is working fine. Feel free to add my
> Tested-by on that platform.

Thanks!

> 
> > 
> > I've pushed the patches (including Steve's) here:
> > 
> > <URL:https://git.linuxtv.org/sailus/media_tree.git/log/?h=v4l2-fwnode-next>
> > 
> > since v1:
> > 
> > - Rebase it all on current media tree master --- there was a conflict in
> >    drivers/media/platform/qcom/camss/camss.c in Steve's patch "media:
> >    platform: Switch to v4l2_async_notifier_add_subdev"; I hope the
> >    resolution was fine.
> 
> I checked your resolution to camss.c and it was the same resolution I
> made as well.

Ack.

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
