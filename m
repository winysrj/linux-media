Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38829 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932521Ab2ASQQv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Jan 2012 11:16:51 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH 14/23] omap3isp: Configure CSI-2 phy based on platform data
Date: Thu, 19 Jan 2012 17:16:50 +0100
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	teturtia@gmail.com, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@gmail.com, riverful@gmail.com
References: <4F0DFE92.80102@iki.fi> <201201161522.43328.laurent.pinchart@ideasonboard.com> <20120117194517.GD13236@valkosipuli.localdomain>
In-Reply-To: <20120117194517.GD13236@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201191716.50660.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Tuesday 17 January 2012 20:45:18 Sakari Ailus wrote:
> On Mon, Jan 16, 2012 at 03:22:42PM +0100, Laurent Pinchart wrote:
> > On Wednesday 11 January 2012 22:26:51 Sakari Ailus wrote:
> > > Configure CSI-2 phy based on platform data in the ISP driver. For that,
> > > the new V4L2_CID_IMAGE_SOURCE_PIXEL_RATE control is used. Previously
> > > the same was configured from the board code.
> > > 
> > > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> > > ---
> > > 
> > >  drivers/media/video/omap3isp/isp.c       |   29 ++++++++++-
> > >  drivers/media/video/omap3isp/isp.h       |    4 --
> > >  drivers/media/video/omap3isp/ispcsi2.c   |   42 ++++++++++++++-
> > >  drivers/media/video/omap3isp/ispcsiphy.c |   84
> > > 
> > > ++++++++++++++++++++++++++---- drivers/media/video/omap3isp/ispcsiphy.h
> > > |
> > > 
> > >   5 ++
> > >  
> > >  5 files changed, 148 insertions(+), 16 deletions(-)
> > > 
> > > diff --git a/drivers/media/video/omap3isp/isp.c
> > > b/drivers/media/video/omap3isp/isp.c index b818cac..d268d55 100644
> > > --- a/drivers/media/video/omap3isp/isp.c
> > > +++ b/drivers/media/video/omap3isp/isp.c
> > > @@ -765,6 +765,34 @@ static int isp_pipeline_enable(struct isp_pipeline
> > > *pipe, if (ret < 0 && ret != -ENOIOCTLCMD)
> > > 
> > >  			return ret;
> > > 
> > > +		/*
> > > +		 * Configure CCDC pixel clock. host_priv != NULL so
> > > +		 * this one is a sensor.
> > > +		 */
> > > +		if (subdev->host_priv) {
> > > +			struct v4l2_ext_controls ctrls;
> > > +			struct v4l2_ext_control ctrl;
> > > +
> > > +			memset(&ctrls, 0, sizeof(ctrls));
> > > +			memset(&ctrl, 0, sizeof(ctrl));
> > > +
> > > +			ctrl.id = V4L2_CID_IMAGE_SOURCE_PIXEL_RATE;
> > > +
> > > +			ctrls.ctrl_class = V4L2_CTRL_ID2CLASS(ctrl.id);
> > > +			ctrls.count = 1;
> > > +			ctrls.controls = &ctrl;
> > > +
> > > +			ret = v4l2_g_ext_ctrls(subdev->ctrl_handler, &ctrls);
> > > +			if (ret < 0) {
> > > +				dev_warn(isp->dev,
> > > +					 "no pixel rate control in subdev %s\n",
> > > +					 subdev->name);
> > > +				return -EPIPE;
> > > +			}
> > > +
> > > +			isp_set_pixel_clock(isp, ctrl.value64);
> > 
> > Isn't this too late ? The CCDC has already been started. What about
> > moving this code to ccdc_config_vp() ?
> 
> I think you're right. I've mostly rewritten this part of the patchset and I
> think it's much cleaner now.
> 
> I have validate_link() functions where I'm validating the link and also
> gathering information alongside that process into a few fields in
> isp_pipeline struct.
> 
> Then those fields can be used in streamon time. Some additional checks for
> those parameters are also done there and they may result into an error
> which is then handled.
> 
> > > +		}
> > > +
> > > 
> > >  		if (subdev == &isp->isp_ccdc.subdev) {
> > >  		
> > >  			v4l2_subdev_call(&isp->isp_aewb.subdev, video,
> > >  			
> > >  					s_stream, mode);
> > > 
> > > @@ -2072,7 +2100,6 @@ static int isp_probe(struct platform_device
> > > *pdev)
> > > 
> > >  	isp->autoidle = autoidle;
> > >  	isp->platform_cb.set_xclk = isp_set_xclk;
> > > 
> > > -	isp->platform_cb.set_pixel_clock = isp_set_pixel_clock;
> > > 
> > >  	mutex_init(&isp->isp_mutex);
> > >  	spin_lock_init(&isp->stat_lock);
> > > 
> > > diff --git a/drivers/media/video/omap3isp/isp.h
> > > b/drivers/media/video/omap3isp/isp.h index ff1c422..dd1b61e 100644
> > > --- a/drivers/media/video/omap3isp/isp.h
> > > +++ b/drivers/media/video/omap3isp/isp.h
> > > @@ -126,10 +126,6 @@ struct isp_reg {
> > > 
> > >  struct isp_platform_callback {
> > >  
> > >  	u32 (*set_xclk)(struct isp_device *isp, u32 xclk, u8 xclksel);
> > > 
> > > -	int (*csiphy_config)(struct isp_csiphy *phy,
> > > -			     struct isp_csiphy_dphy_cfg *dphy,
> > > -			     struct isp_csiphy_lanes_cfg *lanes);
> > > -	void (*set_pixel_clock)(struct isp_device *isp, unsigned int
> > > pixelclk);
> > > 
> > >  };
> > >  
> > >  /*
> > > 
> > > diff --git a/drivers/media/video/omap3isp/ispcsi2.c
> > > b/drivers/media/video/omap3isp/ispcsi2.c index 0c5f1cb..0b3e705 100644
> > > --- a/drivers/media/video/omap3isp/ispcsi2.c
> > > +++ b/drivers/media/video/omap3isp/ispcsi2.c
> > > @@ -1055,7 +1055,45 @@ static int csi2_set_stream(struct v4l2_subdev
> > > *sd, int enable) struct isp_video *video_out = &csi2->video_out;
> > > 
> > >  	switch (enable) {
> > > 
> > > -	case ISP_PIPELINE_STREAM_CONTINUOUS:
> > > +	case ISP_PIPELINE_STREAM_CONTINUOUS: {
> > > +		struct media_pad *remote_pad =
> > > +			media_entity_remote_source(&sd->entity.pads[0]);
> > 
> > As you will need to locate the sensor in ccdc_config_vp() as well, you
> > should store a pointer to the sensor in the pipeline structure in
> > isp_video_streamon(). I think I've sent you code that does just that,
> > originally written by Stan if my memory is correct.
> 
> Stan's patch assumed all external subdevs will be sensors. That may not be
> true in all possible cases. That's not the fault of the patch, things have
> changed after it has been written.
> 
> I'd be suspicious calling the SMIA++ sensor's scaler subdev a sensor.
> Definitely an external ISP will not be a sensor.

Then just rename the field to something else than sensor :-) We need to access 
the external subdev in various places in the driver, instead of trying to 
locate it every time, it would be better to locate it once in 
isp_video_streamon (or one of the helper functions it calls) and store the 
pointer in the isp_pipeline structure.

> The check I'm doing is that if something's connected to either ccp2 or csi2
> (and they're subdevs!) it's the external subdev we're interested in. Same
> for ccdc if the entity is neither of the csi2 receivers or the ccp2
> receiver.
> 
> > > +		struct v4l2_subdev *remote_subdev =
> > > +			media_entity_to_v4l2_subdev(remote_pad->entity);
> > > +		struct v4l2_subdev_format fmt;
> > > +		struct v4l2_ext_controls ctrls;
> > > +		struct v4l2_ext_control ctrl;
> > > +		int ret;
> > > +
> > > +		fmt.pad = remote_pad->index;
> > > +		fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
> > > +		ret = v4l2_subdev_call(
> > > +			remote_subdev, pad, get_fmt, NULL, &fmt);
> > > +		if (ret < 0)
> > > +			return -EPIPE;
> > > +
> > > +		memset(&ctrls, 0, sizeof(ctrls));
> > > +		memset(&ctrl, 0, sizeof(ctrl));
> > > +
> > > +		ctrl.id = V4L2_CID_IMAGE_SOURCE_PIXEL_RATE;
> > > +
> > > +		ctrls.ctrl_class = V4L2_CTRL_ID2CLASS(ctrl.id);
> > > +		ctrls.count = 1;
> > > +		ctrls.controls = &ctrl;
> > > +
> > > +		ret = v4l2_g_ext_ctrls(remote_subdev->ctrl_handler, &ctrls);
> > 
> > Wouldn't v4l2_g_ctrl be easier ?
> 
> Yes, but it's a 64-bit control so I must use extended controls.

Right.

> > An option to avoid duplicating this code in ccdc_config_vp() would be to
> > move pixel rate retrieval to isp_video_streamon().
> 
> It's gathered during link validation now.
> 
> > > +		if (ret < 0) {
> > > +			dev_warn(isp->dev,
> > > +				 "no pixel rate control in subdev %s\n",
> > > +				 remote_subdev->name);
> > > +			return -EPIPE;
> > > +		}
> > > +
> > > +		ret = omap3isp_csiphy_config(
> > > +			isp, sd, remote_subdev, &fmt.format, ctrl.value64);
> > > +		if (ret < 0)
> > > +			return -EPIPE;
> > > +
> > > 
> > >  		if (omap3isp_csiphy_acquire(csi2->phy) < 0)
> > >  		
> > >  			return -ENODEV;
> > >  		
> > >  		csi2->use_fs_irq = pipe->do_propagation;
> > > 
> > > @@ -1080,6 +1118,8 @@ static int csi2_set_stream(struct v4l2_subdev
> > > *sd, int enable) isp_video_dmaqueue_flags_clr(video_out);
> > > 
> > >  		break;
> > > 
> > > +	}
> > > +
> > > 
> > >  	case ISP_PIPELINE_STREAM_STOPPED:
> > >  		if (csi2->state == ISP_PIPELINE_STREAM_STOPPED)
> > >  		
> > >  			return 0;
> > > 
> > > diff --git a/drivers/media/video/omap3isp/ispcsiphy.c
> > > b/drivers/media/video/omap3isp/ispcsiphy.c index 5be37ce..f286a01
> > > 100644 --- a/drivers/media/video/omap3isp/ispcsiphy.c
> > > +++ b/drivers/media/video/omap3isp/ispcsiphy.c
> > > @@ -28,6 +28,8 @@
> > > 
> > >  #include <linux/device.h>
> > >  #include <linux/regulator/consumer.h>
> > > 
> > > +#include "../../../../arch/arm/mach-omap2/control.h"
> > > +
> > 
> > Still no solution for this ?
> 
> Not yet. I'll have to see the discussion again to say more on that. I think
> we can find _something_ but it might not be more compatible with the device
> tree than this.

I proposed adding an exported function to arch/arm/mach-omap2/control.c to 
access the field, but there was no reply.

> > >  #include "isp.h"
> > >  #include "ispreg.h"
> > >  #include "ispcsiphy.h"
> > > 
> > > @@ -138,15 +140,79 @@ static void csiphy_dphy_config(struct isp_csiphy
> > > *phy) isp_reg_writel(phy->isp, reg, phy->phy_regs, ISPCSIPHY_REG1);
> > > 
> > >  }
> > > 
> > > -static int csiphy_config(struct isp_csiphy *phy,
> > > -			 struct isp_csiphy_dphy_cfg *dphy,
> > > -			 struct isp_csiphy_lanes_cfg *lanes)
> > > +/*
> > > + * TCLK values are OK at their reset values
> > > + */
> > > +#define TCLK_TERM	0
> > > +#define TCLK_MISS	1
> > > +#define TCLK_SETTLE	14
> > > +
> > > +int omap3isp_csiphy_config(struct isp_device *isp,
> > > +			   struct v4l2_subdev *csi2_subdev,
> > > +			   struct v4l2_subdev *sensor,
> > > +			   struct v4l2_mbus_framefmt *sensor_fmt,
> > > +			   uint32_t pixel_rate)
> > > 
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
> > > +	if (subdevs->interface == ISP_INTERFACE_CCP2B_PHY1
> > > +	    || subdevs->interface == ISP_INTERFACE_CCP2B_PHY2)
> > > +		lanes = &subdevs->bus.ccp2.lanecfg;
> > > +	else
> > > +		lanes = &subdevs->bus.csi2.lanecfg;
> > > +
> > > +	if (!lanes) {
> > 
> > This can't happen.
> 
> Fixed.

-- 
Regards,

Laurent Pinchart
