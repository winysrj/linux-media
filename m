Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60504 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932105AbdDGWzX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Apr 2017 18:55:23 -0400
Date: Sat, 8 Apr 2017 01:55:15 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-acpi@vger.kernel.org,
        devicetree@vger.kernel.org, mika.westerberg@intel.com
Subject: Re: [PATCH v2 5/8] v4l: Switch from V4L2 OF not V4L2 fwnode API
Message-ID: <20170407225515.GM4192@valkosipuli.retiisi.org.uk>
References: <1491484330-12040-1-git-send-email-sakari.ailus@linux.intel.com>
 <14918382.izlyCngq8n@avalon>
 <20170407105805.GG4192@valkosipuli.retiisi.org.uk>
 <1895617.xparv3opoe@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1895617.xparv3opoe@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Fri, Apr 07, 2017 at 02:09:16PM +0300, Laurent Pinchart wrote:
> Hi Sakari,
> 
> On Friday 07 Apr 2017 13:58:06 Sakari Ailus wrote:
> > On Fri, Apr 07, 2017 at 01:32:54PM +0300, Laurent Pinchart wrote:
> > > On Thursday 06 Apr 2017 16:12:07 Sakari Ailus wrote:
> > > > Switch users of the v4l2_of_ APIs to the more generic v4l2_fwnode_ APIs.
> > > > 
> > > > Existing OF matching continues to be supported. omap3isp and smiapp
> > > > drivers are converted to fwnode matching as well.
> > > > 
> > > > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > > > Acked-by: Benoit Parrot <bparrot@ti.com> # i2c/ov2569.c,
> > > > am437x/am437x-vpfe.c and ti-vpe/cal.c ---
> > > > 
> > > >  drivers/media/i2c/Kconfig                      |  9 ++++
> > > >  drivers/media/i2c/adv7604.c                    |  7 +--
> > > >  drivers/media/i2c/mt9v032.c                    |  7 +--
> > > >  drivers/media/i2c/ov2659.c                     |  8 +--
> > > >  drivers/media/i2c/s5c73m3/s5c73m3-core.c       |  7 +--
> > > >  drivers/media/i2c/s5k5baf.c                    |  6 +--
> > > >  drivers/media/i2c/smiapp/Kconfig               |  1 +
> > > >  drivers/media/i2c/smiapp/smiapp-core.c         | 29 ++++++-----
> > > >  drivers/media/i2c/tc358743.c                   | 11 ++--
> > > >  drivers/media/i2c/tvp514x.c                    |  6 +--
> > > >  drivers/media/i2c/tvp5150.c                    |  7 +--
> > > >  drivers/media/i2c/tvp7002.c                    |  6 +--
> > > >  drivers/media/platform/Kconfig                 |  3 ++
> > > >  drivers/media/platform/am437x/Kconfig          |  1 +
> > > >  drivers/media/platform/am437x/am437x-vpfe.c    |  8 +--
> > > >  drivers/media/platform/atmel/Kconfig           |  1 +
> > > >  drivers/media/platform/atmel/atmel-isc.c       |  8 +--
> > > >  drivers/media/platform/exynos4-is/Kconfig      |  2 +
> > > >  drivers/media/platform/exynos4-is/media-dev.c  |  6 +--
> > > >  drivers/media/platform/exynos4-is/mipi-csis.c  |  6 +--
> > > >  drivers/media/platform/omap3isp/isp.c          | 71  +++++++++---------
> > > >  drivers/media/platform/pxa_camera.c            |  7 +--
> > > >  drivers/media/platform/rcar-vin/Kconfig        |  1 +
> > > >  drivers/media/platform/rcar-vin/rcar-core.c    |  6 +--
> > > >  drivers/media/platform/soc_camera/Kconfig      |  1 +
> > > >  drivers/media/platform/soc_camera/atmel-isi.c  |  7 +--
> > > >  drivers/media/platform/soc_camera/soc_camera.c |  3 +-
> > > >  drivers/media/platform/ti-vpe/cal.c            | 11 ++--
> > > >  drivers/media/platform/xilinx/Kconfig          |  1 +
> > > >  drivers/media/platform/xilinx/xilinx-vipp.c    | 59  +++++++++---------
> > > >  include/media/v4l2-fwnode.h                    |  4 +-
> > > >  31 files changed, 176 insertions(+), 134 deletions(-)
> > > > 
> > > > diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
> > > > index cee1dae..6b2423a 100644
> > > > --- a/drivers/media/i2c/Kconfig
> > > > +++ b/drivers/media/i2c/Kconfig
> > > > @@ -210,6 +210,7 @@ config VIDEO_ADV7604
> > > > 
> > > >  	depends on GPIOLIB || COMPILE_TEST
> > > >  	select HDMI
> > > >  	select MEDIA_CEC_EDID
> > > > 
> > > > +	select V4L2_FWNODE
> > > 
> > > What happens when building the driver on a platform that includes neither
> > > OF nor ACPI support ?
> > 
> > You need either in practice, also for the V4L2 fwnode to be meaningful.
> > 
> > Do you have something in particular in mind?
> 
> I will obviously need either OF or ACPI to use the fwnode API, but some 
> drivers still support platform data (either on non-OF embedded systems, or 
> when the I2C device is part of a PCI card for instance). Compile-testing is 
> also a use case I'm concerned about.

Ah, so essentially compiling a driver using V4L2 fwnode with both ACPI and
OF disabled? I don't know if there are such drivers right now but that's a
good point in general.

> 
> [snip]
> 
> > > > diff --git a/drivers/media/platform/omap3isp/isp.c
> > > > b/drivers/media/platform/omap3isp/isp.c index 084ecf4a..95850b9 100644
> > > > --- a/drivers/media/platform/omap3isp/isp.c
> > > > +++ b/drivers/media/platform/omap3isp/isp.c
> > > 
> > > [snip]
> > > 
> > > > @@ -2024,43 +2025,42 @@ enum isp_of_phy {
> > > >  	ISP_OF_PHY_CSIPHY2,
> > > >  };
> > > > 
> > > > -static int isp_of_parse_node(struct device *dev, struct device_node
> > > > *node,
> > > > -			     struct isp_async_subdev *isd)
> > > > +static int isp_fwnode_parse(struct device *dev, struct fwnode_handle
> > > > *fwn,
> > > > +			    struct isp_async_subdev *isd)
> > > >  {
> > > >  	struct isp_bus_cfg *buscfg = &isd->bus;
> > > > -	struct v4l2_of_endpoint vep;
> > > > +	struct v4l2_fwnode_endpoint vfwn;
> > > 
> > > vfwn is confusing to me, I think the variable name should show that it
> > > refers to an endpoint.
> > 
> > How about adding ep to tell it's an endpoint?
> 
> I'd name is vep or endpoint.

I'll use "vep". "fwnode" for struct fwnode_handle pointers, it is an
established practice elsewhere.

> 
> > > >  	unsigned int i;
> > > >  	int ret;
> > > > 
> > > > -	ret = v4l2_of_parse_endpoint(node, &vep);
> > > > +	ret = v4l2_fwnode_endpoint_parse(fwn, &vfwn);
> > > >  	if (ret)
> > > >  		return ret;
> > > > 
> > > > -	dev_dbg(dev, "parsing endpoint %s, interface %u\n", node->full_name,
> > > > -		vep.base.port);
> > > > +	dev_dbg(dev, "interface %u\n", vfwn.base.port);
> > > 
> > > Is there no way to keep the node name in the error message ?
> > 
> > There's no generic fwnode means to do something similar currently, possibly
> > because I understand ACPI doesn't do that. One could check whether the node
> > is an OF node and then use the full_name field but I wonder if it's worth
> > it.
> 
> My ACPI knowledge is limited, but don't ACPI nodes have 4 character names that 
> can be combined in a string to create a full path ?

There is something, yes, but the ACPI framework currently has no such
functionality. I believe it could be implemented though. Cc Mika.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
