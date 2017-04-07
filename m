Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:43562 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750705AbdDGK6k (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Apr 2017 06:58:40 -0400
Date: Fri, 7 Apr 2017 13:58:06 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-acpi@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v2 5/8] v4l: Switch from V4L2 OF not V4L2 fwnode API
Message-ID: <20170407105805.GG4192@valkosipuli.retiisi.org.uk>
References: <1491484330-12040-1-git-send-email-sakari.ailus@linux.intel.com>
 <1491484330-12040-6-git-send-email-sakari.ailus@linux.intel.com>
 <14918382.izlyCngq8n@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14918382.izlyCngq8n@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Fri, Apr 07, 2017 at 01:32:54PM +0300, Laurent Pinchart wrote:
> Hi Sakari,
> 
> Thank you for the patch.
> 
> On Thursday 06 Apr 2017 16:12:07 Sakari Ailus wrote:
> > Switch users of the v4l2_of_ APIs to the more generic v4l2_fwnode_ APIs.
> > 
> > Existing OF matching continues to be supported. omap3isp and smiapp
> > drivers are converted to fwnode matching as well.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > Acked-by: Benoit Parrot <bparrot@ti.com> # i2c/ov2569.c,
> > am437x/am437x-vpfe.c and ti-vpe/cal.c ---
> >  drivers/media/i2c/Kconfig                      |  9 ++++
> >  drivers/media/i2c/adv7604.c                    |  7 +--
> >  drivers/media/i2c/mt9v032.c                    |  7 +--
> >  drivers/media/i2c/ov2659.c                     |  8 +--
> >  drivers/media/i2c/s5c73m3/s5c73m3-core.c       |  7 +--
> >  drivers/media/i2c/s5k5baf.c                    |  6 +--
> >  drivers/media/i2c/smiapp/Kconfig               |  1 +
> >  drivers/media/i2c/smiapp/smiapp-core.c         | 29 ++++++-----
> >  drivers/media/i2c/tc358743.c                   | 11 ++--
> >  drivers/media/i2c/tvp514x.c                    |  6 +--
> >  drivers/media/i2c/tvp5150.c                    |  7 +--
> >  drivers/media/i2c/tvp7002.c                    |  6 +--
> >  drivers/media/platform/Kconfig                 |  3 ++
> >  drivers/media/platform/am437x/Kconfig          |  1 +
> >  drivers/media/platform/am437x/am437x-vpfe.c    |  8 +--
> >  drivers/media/platform/atmel/Kconfig           |  1 +
> >  drivers/media/platform/atmel/atmel-isc.c       |  8 +--
> >  drivers/media/platform/exynos4-is/Kconfig      |  2 +
> >  drivers/media/platform/exynos4-is/media-dev.c  |  6 +--
> >  drivers/media/platform/exynos4-is/mipi-csis.c  |  6 +--
> >  drivers/media/platform/omap3isp/isp.c          | 71 +++++++++++-----------
> >  drivers/media/platform/pxa_camera.c            |  7 +--
> >  drivers/media/platform/rcar-vin/Kconfig        |  1 +
> >  drivers/media/platform/rcar-vin/rcar-core.c    |  6 +--
> >  drivers/media/platform/soc_camera/Kconfig      |  1 +
> >  drivers/media/platform/soc_camera/atmel-isi.c  |  7 +--
> >  drivers/media/platform/soc_camera/soc_camera.c |  3 +-
> >  drivers/media/platform/ti-vpe/cal.c            | 11 ++--
> >  drivers/media/platform/xilinx/Kconfig          |  1 +
> >  drivers/media/platform/xilinx/xilinx-vipp.c    | 59 +++++++++++----------
> >  include/media/v4l2-fwnode.h                    |  4 +-
> >  31 files changed, 176 insertions(+), 134 deletions(-)
> > 
> > diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
> > index cee1dae..6b2423a 100644
> > --- a/drivers/media/i2c/Kconfig
> > +++ b/drivers/media/i2c/Kconfig
> > @@ -210,6 +210,7 @@ config VIDEO_ADV7604
> >  	depends on GPIOLIB || COMPILE_TEST
> >  	select HDMI
> >  	select MEDIA_CEC_EDID
> > +	select V4L2_FWNODE
> 
> What happens when building the driver on a platform that includes neither OF 
> nor ACPI support ?

You need either in practice, also for the V4L2 fwnode to be meaningful.

Do you have something in particular in mind?

> 
> >  	---help---
> >  	  Support for the Analog Devices ADV7604 video decoder.
> > 
> 
> [snip]
> 
> How have you checked that you haven't missed any entry in the Kconfig files ?

I made one Kconfig change per driver. :-)

> 
> [snip]
> 
> > diff --git a/drivers/media/platform/omap3isp/isp.c
> > b/drivers/media/platform/omap3isp/isp.c index 084ecf4a..95850b9 100644
> > --- a/drivers/media/platform/omap3isp/isp.c
> > +++ b/drivers/media/platform/omap3isp/isp.c
> 
> [snip]
> 
> > @@ -2024,43 +2025,42 @@ enum isp_of_phy {
> >  	ISP_OF_PHY_CSIPHY2,
> >  };
> > 
> > -static int isp_of_parse_node(struct device *dev, struct device_node *node,
> > -			     struct isp_async_subdev *isd)
> > +static int isp_fwnode_parse(struct device *dev, struct fwnode_handle *fwn,
> > +			    struct isp_async_subdev *isd)
> >  {
> >  	struct isp_bus_cfg *buscfg = &isd->bus;
> > -	struct v4l2_of_endpoint vep;
> > +	struct v4l2_fwnode_endpoint vfwn;
> 
> vfwn is confusing to me, I think the variable name should show that it refers 
> to an endpoint.

How about adding ep to tell it's an endpoint?

> 
> >  	unsigned int i;
> >  	int ret;
> > 
> > -	ret = v4l2_of_parse_endpoint(node, &vep);
> > +	ret = v4l2_fwnode_endpoint_parse(fwn, &vfwn);
> >  	if (ret)
> >  		return ret;
> > 
> > -	dev_dbg(dev, "parsing endpoint %s, interface %u\n", node->full_name,
> > -		vep.base.port);
> > +	dev_dbg(dev, "interface %u\n", vfwn.base.port);
> 
> Is there no way to keep the node name in the error message ?

There's no generic fwnode means to do something similar currently, possibly
because I understand ACPI doesn't do that. One could check whether the node
is an OF node and then use the full_name field but I wonder if it's worth
it.

> 
> 
> [snip]
> 
> > @@ -2094,18 +2094,17 @@ static int isp_of_parse_node(struct device *dev,
> > struct device_node *node, break;
> > 
> >  	default:
> > -		dev_warn(dev, "%s: invalid interface %u\n", node->full_name,
> > -			 vep.base.port);
> > +		dev_warn(dev, "invalid interface %u\n", vfwn.base.port);
> 
> Ditto.
> 
> >  		break;
> >  	}
> > 
> >  	return 0;
> >  }
> > 
> > -static int isp_of_parse_nodes(struct device *dev,
> > -			      struct v4l2_async_notifier *notifier)
> > +static int isp_fwnodes_parse(struct device *dev,
> > +			     struct v4l2_async_notifier *notifier)
> >  {
> > -	struct device_node *node = NULL;
> > +	struct fwnode_handle *fwn = NULL;
> 
> As explained in the review of another patch from the same series, I wouldn't 
> rename the variable.

Most pointers to struct fwnode_handle are actually called fwnode and some
fw_node. fwn is just shorter. :-)

There are also cases pointers to struct device_node and struct fwnode_handle
are needed in the same function.

> 
> >  	notifier->subdevs = devm_kcalloc(
> >  		dev, ISP_MAX_SUBDEVS, sizeof(*notifier->subdevs), GFP_KERNEL);
> 
> [snip]
> 
> > @@ -2219,12 +2220,12 @@ static int isp_probe(struct platform_device *pdev)
> >  	if (IS_ERR(isp->syscon))
> >  		return PTR_ERR(isp->syscon);
> > 
> > -	ret = of_property_read_u32_index(pdev->dev.of_node, "syscon", 1,
> > -					 &isp->syscon_offset);
> > +	ret = of_property_read_u32_index(pdev->dev.of_node,
> > +					 "syscon", 1, &isp->syscon_offset);
> 
> This change doesn't seem to be needed.

Oh, indeed. Will fix.

> 
> >  	if (ret)
> >  		return ret;
> > 
> > -	ret = isp_of_parse_nodes(&pdev->dev, &isp->notifier);
> > +	ret = isp_fwnodes_parse(&pdev->dev, &isp->notifier);
> >  	if (ret < 0)
> >  		return ret;
> > 
> 
> [snip]
> 
> > diff --git a/drivers/media/platform/xilinx/xilinx-vipp.c
> > b/drivers/media/platform/xilinx/xilinx-vipp.c index feb3b2f..6a2721b 100644
> > --- a/drivers/media/platform/xilinx/xilinx-vipp.c
> > +++ b/drivers/media/platform/xilinx/xilinx-vipp.c
> 
> [snip]
> 
> > @@ -103,9 +103,10 @@ static int xvip_graph_build_one(struct
> > xvip_composite_device *xdev, * the link.
> >  		 */
> >  		if (link.local_port >= local->num_pads) {
> > -			dev_err(xdev->dev, "invalid port number %u on %s\n",
> > -				link.local_port, link.local_node->full_name);
> > -			v4l2_of_put_link(&link);
> > +			dev_err(xdev->dev, "invalid port number %u for %s\n",
> > +				link.local_port,
> > +				to_of_node(link.local_node)->full_name);
> 
> This makes me believe that we're missing a fwnode_full_name() function.

It'd be nice to have that, I agree. What should it do on non-OF nodes?
Return a pointers to an empty string?

> 
> > +			v4l2_fwnode_put_link(&link);
> >  			ret = -EINVAL;
> >  			break;
> >  		}
> 
> [snip]
> 
> > diff --git a/include/media/v4l2-fwnode.h b/include/media/v4l2-fwnode.h
> > index a675d8a..bc9cf51 100644
> > --- a/include/media/v4l2-fwnode.h
> > +++ b/include/media/v4l2-fwnode.h
> > @@ -17,10 +17,10 @@
> >  #ifndef _V4L2_FWNODE_H
> >  #define _V4L2_FWNODE_H
> > 
> > +#include <linux/errno.h>
> > +#include <linux/fwnode.h>
> >  #include <linux/list.h>
> >  #include <linux/types.h>
> > -#include <linux/errno.h>
> > -#include <linux/of_graph.h>
> > 
> >  #include <media/v4l2-mediabus.h>
> 
> This probably belongs to another patch (at least the alphabetical sorting 
> does).

Yes, I'll change it.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
