Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39429 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199Ab1LOMyg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Dec 2011 07:54:36 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [RFC 3/4] omap3isp: Configure CSI-2 phy based on platform data
Date: Thu, 15 Dec 2011 13:54:52 +0100
Cc: linux-media@vger.kernel.org
References: <20111215095015.GC3677@valkosipuli.localdomain> <201112151128.07311.laurent.pinchart@ideasonboard.com> <20111215115303.GD3677@valkosipuli.localdomain>
In-Reply-To: <20111215115303.GD3677@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201112151354.53360.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Thursday 15 December 2011 12:53:03 Sakari Ailus wrote:
> On Thu, Dec 15, 2011 at 11:28:06AM +0100, Laurent Pinchart wrote:
> > On Thursday 15 December 2011 10:50:34 Sakari Ailus wrote:
> > > Configure CSI-2 phy based on platform data in the ISP driver rather
> > > than in platform code.
> > > 
> > > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>

[snip]

> > > diff --git a/drivers/media/video/omap3isp/ispcsiphy.c
> > > b/drivers/media/video/omap3isp/ispcsiphy.c index 5be37ce..52af308
> > > 100644 --- a/drivers/media/video/omap3isp/ispcsiphy.c
> > > +++ b/drivers/media/video/omap3isp/ispcsiphy.c
> > > @@ -28,6 +28,8 @@

[snip]

> > > +int omap3isp_csiphy_config(struct isp_device *isp,
> > > +			   struct v4l2_subdev *csi2_subdev,
> > > +			   struct v4l2_subdev *sensor,
> > > +			   struct v4l2_mbus_framefmt *sensor_fmt)
> > 
> > The number of lanes can depend on the format. Wouldn't it be better to
> > add a subdev operation to query the sensor for its bus configuration
> > instead of relying on ISP platform data ?
> 
> In principle, yes. That's an interesting point; how this kind of information
> would best be delivered?

There are two separate information that need to be delivered:

- how the lanes are connected on the board
- which lanes are used by the sensor, and for what purpose

The first information must be supplied through platform data, either to the 
sensor driver or the OMAP3 ISP driver (or both). As the second information 
comes from the sensor, my idea was to provide the first to the sensor, and to 
query the sensor in the OMAP3 ISP driver for the full configuration.

> On the other hand I don't see any pressing reason to use less lanes than
> the maximum, so this could wait IMHO.
> 
> Perhaps around the time we standardise how the CSI-2 configuration is being
> done? It's not quite as simple as the mbus_config seems to assume. For
> example, the lane mapping and then which lanes do you use if you're using
> less than the maximum has to be handled in a way or another.

I agree. That's why I don't really like mbus_config, its auto-negotiation 
support approach makes it too limited in my opinion.

> The number of lanes might be something the user would want to touch, but
> I'm not entirely sure. You achieve more functionality by providing that
> flexibility to the user but I don't see need for configuring that ---
> still getting the number of lanes could be interesting.

If we want to expose such configuration I think we should do it on the sensor, 
not the ISP.

> > >  {
> > > 
> > > +	struct isp_v4l2_subdevs_group *subdevs = sensor->host_priv;
> > > +	struct isp_csi2_device *csi2 = v4l2_get_subdevdata(csi2_subdev);
> > > +	struct isp_csiphy_dphy_cfg csi2phy;
> > > +	int csi2_ddrclk_khz;
> > > +	struct isp_csiphy_lanes_cfg *lanes;
> > > 
> > >  	unsigned int used_lanes = 0;
> > >  	unsigned int i;
> > > 
> > > +	u32 cam_phy_ctrl;
> > > +
> > > +	if (subdevs->interface == ISP_INTERFACE_CCP2B_PHY1
> > > +	    || subdevs->interface == ISP_INTERFACE_CCP2B_PHY2)
> > > +		lanes = subdevs->bus.ccp2.lanecfg;
> > > +	else
> > > +		lanes = subdevs->bus.csi2.lanecfg;
> > > +
> > > +	if (!lanes) {
> > > +		dev_err(isp->dev, "no lane configuration\n");
> > > +		return -EINVAL;
> > > +	}
> > > +
> > > +	cam_phy_ctrl = omap_readl(
> > > +		OMAP343X_CTRL_BASE + OMAP3630_CONTROL_CAMERA_PHY_CTRL);
> > > +	/*
> > > +	 * SCM.CONTROL_CAMERA_PHY_CTRL
> > > +	 * - bit[4]    : CSIPHY1 data sent to CSIB
> > > +	 * - bit [3:2] : CSIPHY1 config: 00 d-phy, 01/10 ccp2
> > > +	 * - bit [1:0] : CSIPHY2 config: 00 d-phy, 01/10 ccp2
> > > +	 */
> > > +	if (subdevs->interface == ISP_INTERFACE_CCP2B_PHY1)
> > > +		cam_phy_ctrl |= 1 << 2;
> > > +	else if (subdevs->interface == ISP_INTERFACE_CSI2C_PHY1)
> > > +		cam_phy_ctrl &= 1 << 2;
> > > +
> > > +	if (subdevs->interface == ISP_INTERFACE_CCP2B_PHY2)
> > > +		cam_phy_ctrl |= 1;
> > > +	else if (subdevs->interface == ISP_INTERFACE_CSI2A_PHY2)
> > > +		cam_phy_ctrl &= 1;
> > > +
> > > +	omap_writel(cam_phy_ctrl,
> > > +		    OMAP343X_CTRL_BASE + OMAP3630_CONTROL_CAMERA_PHY_CTRL);
> > > +
> > > +	csi2_ddrclk_khz = sensor_fmt->pixel_clock
> > > +		/ (2 * csi2->phy->num_data_lanes)
> > > +		* omap3isp_video_format_info(sensor_fmt->code)->bpp;
> > > +	csi2phy.ths_term = THS_TERM(csi2_ddrclk_khz);
> > > +	csi2phy.ths_settle = THS_SETTLE(csi2_ddrclk_khz);
> > > +	csi2phy.tclk_term = TCLK_TERM;
> > > +	csi2phy.tclk_miss = TCLK_MISS;
> > > +	csi2phy.tclk_settle = TCLK_SETTLE;
> > > 
> > >  	/* Clock and data lanes verification */
> > > 
> > > -	for (i = 0; i < phy->num_data_lanes; i++) {
> > > +	for (i = 0; i < csi2->phy->num_data_lanes; i++) {
> > > 
> > >  		if (lanes->data[i].pol > 1 || lanes->data[i].pos > 3)
> > >  		
> > >  			return -EINVAL;
> > > 
> > > @@ -162,10 +239,10 @@ static int csiphy_config(struct isp_csiphy *phy,
> > > 
> > >  	if (lanes->clk.pos == 0 || used_lanes & (1 << lanes->clk.pos))
> > >  	
> > >  		return -EINVAL;
> > > 
> > > -	mutex_lock(&phy->mutex);
> > > -	phy->dphy = *dphy;
> > > -	phy->lanes = *lanes;
> > > -	mutex_unlock(&phy->mutex);
> > > +	mutex_lock(&csi2->phy->mutex);
> > > +	csi2->phy->dphy = csi2phy;
> > > +	csi2->phy->lanes = *lanes;
> > > +	mutex_unlock(&csi2->phy->mutex);
> > > 
> > >  	return 0;
> > >  
> > >  }
> > > 
> > > @@ -225,8 +302,6 @@ int omap3isp_csiphy_init(struct isp_device *isp)
> > > 
> > >  	struct isp_csiphy *phy1 = &isp->isp_csiphy1;
> > >  	struct isp_csiphy *phy2 = &isp->isp_csiphy2;
> > > 
> > > -	isp->platform_cb.csiphy_config = csiphy_config;
> > > -
> > > 
> > >  	phy2->isp = isp;
> > >  	phy2->csi2 = &isp->isp_csi2a;
> > >  	phy2->num_data_lanes = ISP_CSIPHY2_NUM_DATA_LANES;
> > > 
> > > diff --git a/drivers/media/video/omap3isp/ispcsiphy.h
> > > b/drivers/media/video/omap3isp/ispcsiphy.h index e93a661..9f93222
> > > 100644 --- a/drivers/media/video/omap3isp/ispcsiphy.h
> > > +++ b/drivers/media/video/omap3isp/ispcsiphy.h
> > > @@ -56,6 +56,10 @@ struct isp_csiphy {
> > > 
> > >  	struct isp_csiphy_dphy_cfg dphy;
> > >  
> > >  };
> > > 
> > > +int omap3isp_csiphy_config(struct isp_device *isp,
> > > +			   struct v4l2_subdev *csi2_subdev,
> > > +			   struct v4l2_subdev *sensor,
> > > +			   struct v4l2_mbus_framefmt *fmt);
> > > 
> > >  int omap3isp_csiphy_acquire(struct isp_csiphy *phy);
> > >  void omap3isp_csiphy_release(struct isp_csiphy *phy);
> > >  int omap3isp_csiphy_init(struct isp_device *isp);
> > > 
> > > diff --git a/drivers/media/video/omap3isp/ispvideo.c
> > > b/drivers/media/video/omap3isp/ispvideo.c index 17bc03c..cdcf1d0 100644
> > > --- a/drivers/media/video/omap3isp/ispvideo.c
> > > +++ b/drivers/media/video/omap3isp/ispvideo.c
> > > @@ -299,6 +299,8 @@ static int isp_video_validate_pipeline(struct
> > > isp_pipeline *pipe)
> > > 
> > >  	while (1) {
> > >  	
> > >  		unsigned int shifter_link;
> > > 
> > > +		struct v4l2_subdev *_subdev;
> > 
> > What about a more descriptive name ?
> 
> Ack.
> 
> > > +
> > > 
> > >  		/* Retrieve the sink format */
> > >  		pad = &subdev->entity.pads[0];
> > >  		if (!(pad->flags & MEDIA_PAD_FL_SINK))
> > > 
> > > @@ -342,6 +344,7 @@ static int isp_video_validate_pipeline(struct
> > > isp_pipeline *pipe) if (media_entity_type(pad->entity) !=
> > > MEDIA_ENT_T_V4L2_SUBDEV)
> > > 
> > >  			break;
> > > 
> > > +		_subdev = subdev;
> > > 
> > >  		subdev = media_entity_to_v4l2_subdev(pad->entity);
> > >  		
> > >  		fmt_source.pad = pad->index;
> > > 
> > > @@ -355,6 +358,22 @@ static int isp_video_validate_pipeline(struct
> > > isp_pipeline *pipe) fmt_source.format.height != fmt_sink.format.height)
> > > 
> > >  			return -EPIPE;
> > > 
> > > +		/* Configure CSI-2 receiver based on sensor format. */
> > > +		if (_subdev == &isp->isp_csi2a.subdev
> > > +		    || _subdev == &isp->isp_csi2c.subdev) {
> > > +			if (cpu_is_omap3630()) {
> > > +				/*
> > > +				 * FIXME: CSI-2 is supported only on
> > > +				 * the 3630!
> > > +				 */
> > 
> > Is it ? Or do you mean by the driver ? What would it take to support it
> > on OMAP34xx and OMAP35xx ?
> 
> I have no way to test it on the OMAP 3430 since I have no CSI-2 sensor
> connected to it. As a matter of fact I've never had one, so I don't really
> know.

What about assuming it works on the 34xx and 35xx as well ?

> > > +				ret = omap3isp_csiphy_config(
> > > +					isp, _subdev, subdev,
> > > +					&fmt_source.format);
> > > +				if (IS_ERR_VALUE(ret))
> > > +					return -EPIPE;
> > > +			}
> > > +		}
> > 
> > This isn't really pipeline validation, is it ? Should this be performed
> > in isp_pipeline_enable() instead ?
> 
> I'll move it there.

-- 
Regards,

Laurent Pinchart
