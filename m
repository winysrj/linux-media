Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52597 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814Ab2AHLPS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Jan 2012 06:15:18 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: [RFC 13/17] omap3isp: Configure CSI-2 phy based on platform data
Date: Sun, 8 Jan 2012 12:15:36 +0100
Cc: linux-media@vger.kernel.org, dacohen@gmail.com, snjw23@gmail.com
References: <4EF0EFC9.6080501@maxwell.research.nokia.com> <201201080202.11719.laurent.pinchart@ideasonboard.com> <4F096F3A.7020902@maxwell.research.nokia.com>
In-Reply-To: <4F096F3A.7020902@maxwell.research.nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201081215.37801.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Sunday 08 January 2012 11:26:02 Sakari Ailus wrote:
> Laurent Pinchart wrote:
> > On Saturday 07 January 2012 23:51:24 Sakari Ailus wrote:
> >> Laurent Pinchart wrote:
> >>> On Tuesday 20 December 2011 21:28:05 Sakari Ailus wrote:
> >>>> From: Sakari Ailus <sakari.ailus@iki.fi>
> >>>> 
> >>>> Configure CSI-2 phy based on platform data in the ISP driver rather
> >>>> than in platform code.
> >>>> 
> >>>> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> > 
> > [snip]
> > 
> >>>> diff --git a/drivers/media/video/omap3isp/ispcsiphy.c
> >>>> b/drivers/media/video/omap3isp/ispcsiphy.c index 5be37ce..f027ece
> >>>> 100644 --- a/drivers/media/video/omap3isp/ispcsiphy.c
> >>>> +++ b/drivers/media/video/omap3isp/ispcsiphy.c
> >>>> @@ -28,6 +28,8 @@
> >>>> 
> >>>>  #include <linux/device.h>
> >>>>  #include <linux/regulator/consumer.h>
> >>>> 
> >>>> +#include "../../../../arch/arm/mach-omap2/control.h"
> >>>> +
> >>> 
> >>> #include <mach/control.h>
> >>> 
> >>> (untested) ?
> >> 
> >> I'm afraid it won't work. The above directory isn't in any include path
> >> and likely shouldn't be. That file is included locally elsewhere, I
> >> believe.
> > 
> > You're right, I spoke too fast.
> > 
> >> I wonder what would be the right way to access that register definition
> >> 
> >> I need from the file:
> >> 	OMAP343X_CTRL_BASE
> >> 	OMAP3630_CONTROL_CAMERA_PHY_CTRL
> > 
> > Maybe the file (or part of it) should be moved to an include directory ?
> 
> Yes, but which one?

Good question. The content of control.h doesn't seem to have been meant to be 
exported. Maybe you should ask on linux-omap@vger.kernel.org ?

> >>>>  #include "isp.h"
> >>>>  #include "ispreg.h"
> >>>>  #include "ispcsiphy.h"
> >>>> 
> >>>> @@ -138,15 +140,78 @@ static void csiphy_dphy_config(struct isp_csiphy
> >>>> *phy) isp_reg_writel(phy->isp, reg, phy->phy_regs, ISPCSIPHY_REG1);
> >>>> 
> >>>>  }
> >>>> 
> >>>> -static int csiphy_config(struct isp_csiphy *phy,
> >>>> -			 struct isp_csiphy_dphy_cfg *dphy,
> >>>> -			 struct isp_csiphy_lanes_cfg *lanes)
> >>>> +/*
> >>>> + * TCLK values are OK at their reset values
> >>>> + */
> >>>> +#define TCLK_TERM	0
> >>>> +#define TCLK_MISS	1
> >>>> +#define TCLK_SETTLE	14
> >>>> +
> >>>> +int omap3isp_csiphy_config(struct isp_device *isp,
> >>>> +			   struct v4l2_subdev *csi2_subdev,
> >>>> +			   struct v4l2_subdev *sensor,
> >>>> +			   struct v4l2_mbus_framefmt *sensor_fmt)
> >>>> 
> >>>>  {
> >>>> 
> >>>> +	struct isp_v4l2_subdevs_group *subdevs = sensor->host_priv;
> >>>> +	struct isp_csi2_device *csi2 = v4l2_get_subdevdata(csi2_subdev);
> >>>> +	struct isp_csiphy_dphy_cfg csi2phy;
> >>>> +	int csi2_ddrclk_khz;
> >>>> +	struct isp_csiphy_lanes_cfg *lanes;
> >>>> 
> >>>>  	unsigned int used_lanes = 0;
> >>>>  	unsigned int i;
> >>>> 
> >>>> +	u32 cam_phy_ctrl;
> >>>> +
> >>>> +	if (subdevs->interface == ISP_INTERFACE_CCP2B_PHY1
> >>>> +	    || subdevs->interface == ISP_INTERFACE_CCP2B_PHY2)
> >>>> +		lanes = subdevs->bus.ccp2.lanecfg;
> >>>> +	else
> >>>> +		lanes = subdevs->bus.csi2.lanecfg;
> >>> 
> >>> Shouldn't lane configuration be retrieved from the sensor instead ?
> >>> Sensors could use different lane configuration depending on the mode.
> >>> This could also be implemented later when needed, but I don't think it
> >>> would be too difficult to get it right now.
> >> 
> >> I think we'd first need to standardise the CSI-2 bus configuration. I
> >> don't see a practical need to make the lane configuration dynamic. You
> >> could just use a lower frequency to achieve the same if you really need
> >> to.
> >> 
> >> Ideally it might be nice to do but there's really nothing I know that
> >> required or even benefited from it --- at least for now.
> > 
> > Does this mean that lane configuration needs to be duplicated in board
> > code, on for the SMIA++ platform data and one of the OMAP3 ISP platform
> > data ?
> 
> It's mostly the number of lanes, and the polarity --- in theory it is
> possible to invert the signals on the bus, albeit I'm not sure if anyone
> does that; I can't see a reason for that, but hey, I don't know why it's
> possible to specify polarity either. :-)
> 
> If both sides support mapping of the lanes, a mapping that matches on
> both sides has to be provided.
> 
> I agree we should standardise the configuration of CSI-2 as well as the
> configuration of other busses. However, I would prefer to do that later
> on since I'm already depending on a number of other patches on the
> SMIA++ driver.

OK.

-- 
Regards,

Laurent Pinchart
