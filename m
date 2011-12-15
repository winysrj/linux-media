Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:38721 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758718Ab1LOLxJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Dec 2011 06:53:09 -0500
Date: Thu, 15 Dec 2011 13:53:03 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [RFC 3/4] omap3isp: Configure CSI-2 phy based on platform data
Message-ID: <20111215115303.GD3677@valkosipuli.localdomain>
References: <20111215095015.GC3677@valkosipuli.localdomain>
 <1323942635-13058-3-git-send-email-sakari.ailus@iki.fi>
 <201112151128.07311.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201112151128.07311.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for the review!

On Thu, Dec 15, 2011 at 11:28:06AM +0100, Laurent Pinchart wrote:
> Hi Sakari,
> 
> Thanks for the patch.
> 
> On Thursday 15 December 2011 10:50:34 Sakari Ailus wrote:
> > Configure CSI-2 phy based on platform data in the ISP driver rather than in
> > platform code.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> > ---
> >  drivers/media/video/omap3isp/isp.h       |    3 -
> >  drivers/media/video/omap3isp/ispcsiphy.c |   95
> > ++++++++++++++++++++++++++--- drivers/media/video/omap3isp/ispcsiphy.h |  
> >  4 +
> >  drivers/media/video/omap3isp/ispvideo.c  |   19 ++++++
> >  4 files changed, 108 insertions(+), 13 deletions(-)
> > 
> > diff --git a/drivers/media/video/omap3isp/isp.h
> > b/drivers/media/video/omap3isp/isp.h index 705946e..c5935ae 100644
> > --- a/drivers/media/video/omap3isp/isp.h
> > +++ b/drivers/media/video/omap3isp/isp.h
> > @@ -126,9 +126,6 @@ struct isp_reg {
> > 
> >  struct isp_platform_callback {
> >  	u32 (*set_xclk)(struct isp_device *isp, u32 xclk, u8 xclksel);
> > -	int (*csiphy_config)(struct isp_csiphy *phy,
> > -			     struct isp_csiphy_dphy_cfg *dphy,
> > -			     struct isp_csiphy_lanes_cfg *lanes);
> >  	void (*set_pixel_clock)(struct isp_device *isp, unsigned int pixelclk);
> >  };
> > 
> > diff --git a/drivers/media/video/omap3isp/ispcsiphy.c
> > b/drivers/media/video/omap3isp/ispcsiphy.c index 5be37ce..52af308 100644
> > --- a/drivers/media/video/omap3isp/ispcsiphy.c
> > +++ b/drivers/media/video/omap3isp/ispcsiphy.c
> > @@ -28,6 +28,8 @@
> >  #include <linux/device.h>
> >  #include <linux/regulator/consumer.h>
> > 
> > +#include "../../../../arch/arm/mach-omap2/control.h"
> > +
> >  #include "isp.h"
> >  #include "ispreg.h"
> >  #include "ispcsiphy.h"
> > @@ -138,15 +140,90 @@ static void csiphy_dphy_config(struct isp_csiphy
> > *phy) isp_reg_writel(phy->isp, reg, phy->phy_regs, ISPCSIPHY_REG1);
> >  }
> > 
> > -static int csiphy_config(struct isp_csiphy *phy,
> > -			 struct isp_csiphy_dphy_cfg *dphy,
> > -			 struct isp_csiphy_lanes_cfg *lanes)
> > +/*
> > + * THS_TERM: Programmed value = ceil(12.5 ns/DDRClk period) - 1.
> > + * THS_SETTLE: Programmed value = ceil(90 ns/DDRClk period) + 3.
> > + */
> > +#define THS_TERM_D 2000000
> > +#define THS_TERM(ddrclk_khz)					\
> > +(								\
> > +	((25 * (ddrclk_khz)) % THS_TERM_D) ?			\
> > +		((25 * (ddrclk_khz)) / THS_TERM_D) :		\
> > +		((25 * (ddrclk_khz)) / THS_TERM_D) - 1		\
> > +)
> > +
> > +#define THS_SETTLE_D 1000000
> > +#define THS_SETTLE(ddrclk_khz)					\
> > +(								\
> > +	((90 * (ddrclk_khz)) % THS_SETTLE_D) ?			\
> > +		((90 * (ddrclk_khz)) / THS_SETTLE_D) + 4 :	\
> > +		((90 * (ddrclk_khz)) / THS_SETTLE_D) + 3	\
> > +)
> 
> The THS_TERM and THS_SETTLE macros are only used once. I would just put that 
> code explictly where it gets used. The macros hinder readability.

I'll do that.

> > +
> > +/*
> > + * TCLK values are OK at their reset values
> > + */
> > +#define TCLK_TERM	0
> > +#define TCLK_MISS	1
> > +#define TCLK_SETTLE	14
> > +
> > +int omap3isp_csiphy_config(struct isp_device *isp,
> > +			   struct v4l2_subdev *csi2_subdev,
> > +			   struct v4l2_subdev *sensor,
> > +			   struct v4l2_mbus_framefmt *sensor_fmt)
> 
> The number of lanes can depend on the format. Wouldn't it be better to add a 
> subdev operation to query the sensor for its bus configuration instead of 
> relying on ISP platform data ?

In principle, yes. That's an interesting point; how this kind of information
would best be delivered?

On the other hand I don't see any pressing reason to use less lanes than the
maximum, so this could wait IMHO.

Perhaps around the time we standardise how the CSI-2 configuration is being
done? It's not quite as simple as the mbus_config seems to assume. For
example, the lane mapping and then which lanes do you use if you're using
less than the maximum has to be handled in a way or another.

The number of lanes might be something the user would want to touch, but I'm
not entirely sure. You achieve more functionality by providing that
flexibility to the user but I don't see need for configuring that --- still
getting the number of lanes could be interesting.

> >  {
> > +	struct isp_v4l2_subdevs_group *subdevs = sensor->host_priv;
> > +	struct isp_csi2_device *csi2 = v4l2_get_subdevdata(csi2_subdev);
> > +	struct isp_csiphy_dphy_cfg csi2phy;
> > +	int csi2_ddrclk_khz;
> > +	struct isp_csiphy_lanes_cfg *lanes;
> >  	unsigned int used_lanes = 0;
> >  	unsigned int i;
> > +	u32 cam_phy_ctrl;
> > +
> > +	if (subdevs->interface == ISP_INTERFACE_CCP2B_PHY1
> > +	    || subdevs->interface == ISP_INTERFACE_CCP2B_PHY2)
> > +		lanes = subdevs->bus.ccp2.lanecfg;
> > +	else
> > +		lanes = subdevs->bus.csi2.lanecfg;
> > +
> > +	if (!lanes) {
> > +		dev_err(isp->dev, "no lane configuration\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	cam_phy_ctrl = omap_readl(
> > +		OMAP343X_CTRL_BASE + OMAP3630_CONTROL_CAMERA_PHY_CTRL);
> > +	/*
> > +	 * SCM.CONTROL_CAMERA_PHY_CTRL
> > +	 * - bit[4]    : CSIPHY1 data sent to CSIB
> > +	 * - bit [3:2] : CSIPHY1 config: 00 d-phy, 01/10 ccp2
> > +	 * - bit [1:0] : CSIPHY2 config: 00 d-phy, 01/10 ccp2
> > +	 */
> > +	if (subdevs->interface == ISP_INTERFACE_CCP2B_PHY1)
> > +		cam_phy_ctrl |= 1 << 2;
> > +	else if (subdevs->interface == ISP_INTERFACE_CSI2C_PHY1)
> > +		cam_phy_ctrl &= 1 << 2;
> > +
> > +	if (subdevs->interface == ISP_INTERFACE_CCP2B_PHY2)
> > +		cam_phy_ctrl |= 1;
> > +	else if (subdevs->interface == ISP_INTERFACE_CSI2A_PHY2)
> > +		cam_phy_ctrl &= 1;
> > +
> > +	omap_writel(cam_phy_ctrl,
> > +		    OMAP343X_CTRL_BASE + OMAP3630_CONTROL_CAMERA_PHY_CTRL);
> > +
> > +	csi2_ddrclk_khz = sensor_fmt->pixel_clock
> > +		/ (2 * csi2->phy->num_data_lanes)
> > +		* omap3isp_video_format_info(sensor_fmt->code)->bpp;
> > +	csi2phy.ths_term = THS_TERM(csi2_ddrclk_khz);
> > +	csi2phy.ths_settle = THS_SETTLE(csi2_ddrclk_khz);
> > +	csi2phy.tclk_term = TCLK_TERM;
> > +	csi2phy.tclk_miss = TCLK_MISS;
> > +	csi2phy.tclk_settle = TCLK_SETTLE;
> > 
> >  	/* Clock and data lanes verification */
> > -	for (i = 0; i < phy->num_data_lanes; i++) {
> > +	for (i = 0; i < csi2->phy->num_data_lanes; i++) {
> >  		if (lanes->data[i].pol > 1 || lanes->data[i].pos > 3)
> >  			return -EINVAL;
> > 
> > @@ -162,10 +239,10 @@ static int csiphy_config(struct isp_csiphy *phy,
> >  	if (lanes->clk.pos == 0 || used_lanes & (1 << lanes->clk.pos))
> >  		return -EINVAL;
> > 
> > -	mutex_lock(&phy->mutex);
> > -	phy->dphy = *dphy;
> > -	phy->lanes = *lanes;
> > -	mutex_unlock(&phy->mutex);
> > +	mutex_lock(&csi2->phy->mutex);
> > +	csi2->phy->dphy = csi2phy;
> > +	csi2->phy->lanes = *lanes;
> > +	mutex_unlock(&csi2->phy->mutex);
> > 
> >  	return 0;
> >  }
> > @@ -225,8 +302,6 @@ int omap3isp_csiphy_init(struct isp_device *isp)
> >  	struct isp_csiphy *phy1 = &isp->isp_csiphy1;
> >  	struct isp_csiphy *phy2 = &isp->isp_csiphy2;
> > 
> > -	isp->platform_cb.csiphy_config = csiphy_config;
> > -
> >  	phy2->isp = isp;
> >  	phy2->csi2 = &isp->isp_csi2a;
> >  	phy2->num_data_lanes = ISP_CSIPHY2_NUM_DATA_LANES;
> > diff --git a/drivers/media/video/omap3isp/ispcsiphy.h
> > b/drivers/media/video/omap3isp/ispcsiphy.h index e93a661..9f93222 100644
> > --- a/drivers/media/video/omap3isp/ispcsiphy.h
> > +++ b/drivers/media/video/omap3isp/ispcsiphy.h
> > @@ -56,6 +56,10 @@ struct isp_csiphy {
> >  	struct isp_csiphy_dphy_cfg dphy;
> >  };
> > 
> > +int omap3isp_csiphy_config(struct isp_device *isp,
> > +			   struct v4l2_subdev *csi2_subdev,
> > +			   struct v4l2_subdev *sensor,
> > +			   struct v4l2_mbus_framefmt *fmt);
> >  int omap3isp_csiphy_acquire(struct isp_csiphy *phy);
> >  void omap3isp_csiphy_release(struct isp_csiphy *phy);
> >  int omap3isp_csiphy_init(struct isp_device *isp);
> > diff --git a/drivers/media/video/omap3isp/ispvideo.c
> > b/drivers/media/video/omap3isp/ispvideo.c index 17bc03c..cdcf1d0 100644
> > --- a/drivers/media/video/omap3isp/ispvideo.c
> > +++ b/drivers/media/video/omap3isp/ispvideo.c
> > @@ -299,6 +299,8 @@ static int isp_video_validate_pipeline(struct
> > isp_pipeline *pipe)
> > 
> >  	while (1) {
> >  		unsigned int shifter_link;
> > +		struct v4l2_subdev *_subdev;
> 
> What about a more descriptive name ?

Ack.

> > +
> >  		/* Retrieve the sink format */
> >  		pad = &subdev->entity.pads[0];
> >  		if (!(pad->flags & MEDIA_PAD_FL_SINK))
> > @@ -342,6 +344,7 @@ static int isp_video_validate_pipeline(struct
> > isp_pipeline *pipe) if (media_entity_type(pad->entity) !=
> > MEDIA_ENT_T_V4L2_SUBDEV)
> >  			break;
> > 
> > +		_subdev = subdev;
> >  		subdev = media_entity_to_v4l2_subdev(pad->entity);
> > 
> >  		fmt_source.pad = pad->index;
> > @@ -355,6 +358,22 @@ static int isp_video_validate_pipeline(struct
> > isp_pipeline *pipe) fmt_source.format.height != fmt_sink.format.height)
> >  			return -EPIPE;
> > 
> > +		/* Configure CSI-2 receiver based on sensor format. */
> > +		if (_subdev == &isp->isp_csi2a.subdev
> > +		    || _subdev == &isp->isp_csi2c.subdev) {
> > +			if (cpu_is_omap3630()) {
> > +				/*
> > +				 * FIXME: CSI-2 is supported only on
> > +				 * the 3630!
> > +				 */
> 
> Is it ? Or do you mean by the driver ? What would it take to support it on 
> OMAP34xx and OMAP35xx ?

I have no way to test it on the OMAP 3430 since I have no CSI-2 sensor
connected to it. As a matter of fact I've never had one, so I don't really
know.

> > +				ret = omap3isp_csiphy_config(
> > +					isp, _subdev, subdev,
> > +					&fmt_source.format);
> > +				if (IS_ERR_VALUE(ret))
> > +					return -EPIPE;
> > +			}
> > +		}
> 
> This isn't really pipeline validation, is it ? Should this be performed in 
> isp_pipeline_enable() instead ?

I'll move it there.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
