Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:19893 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751328Ab2AGWvf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Jan 2012 17:51:35 -0500
Message-ID: <4F08CC6C.8080209@maxwell.research.nokia.com>
Date: Sun, 08 Jan 2012 00:51:24 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, dacohen@gmail.com, snjw23@gmail.com
Subject: Re: [RFC 13/17] omap3isp: Configure CSI-2 phy based on platform data
References: <4EF0EFC9.6080501@maxwell.research.nokia.com> <1324412889-17961-13-git-send-email-sakari.ailus@maxwell.research.nokia.com> <201201061101.02843.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201201061101.02843.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for the review!!!

Laurent Pinchart wrote:
> On Tuesday 20 December 2011 21:28:05 Sakari Ailus wrote:
>> From: Sakari Ailus <sakari.ailus@iki.fi>
>>
>> Configure CSI-2 phy based on platform data in the ISP driver rather than in
>> platform code.
>>
>> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
>> ---
>>  drivers/media/video/omap3isp/isp.c       |   38 ++++++++++++--
>>  drivers/media/video/omap3isp/isp.h       |    3 -
>>  drivers/media/video/omap3isp/ispcsiphy.c |   83 +++++++++++++++++++++++----
>>  drivers/media/video/omap3isp/ispcsiphy.h |    4 ++
>>  4 files changed, 111 insertions(+), 17 deletions(-)
>>
>> diff --git a/drivers/media/video/omap3isp/isp.c
>> b/drivers/media/video/omap3isp/isp.c index b818cac..6020fd7 100644
>> --- a/drivers/media/video/omap3isp/isp.c
>> +++ b/drivers/media/video/omap3isp/isp.c
>> @@ -737,7 +737,7 @@ static int isp_pipeline_enable(struct isp_pipeline
>> *pipe, struct isp_device *isp = pipe->output->isp;
>>  	struct media_entity *entity;
>>  	struct media_pad *pad;
>> -	struct v4l2_subdev *subdev;
>> +	struct v4l2_subdev *subdev = NULL, *prev_subdev;
>>  	unsigned long flags;
>>  	int ret;
>>
>> @@ -759,11 +759,41 @@ static int isp_pipeline_enable(struct isp_pipeline
>> *pipe, break;
>>
>>  		entity = pad->entity;
>> +		prev_subdev = subdev;
>>  		subdev = media_entity_to_v4l2_subdev(entity);
>>
>> -		ret = v4l2_subdev_call(subdev, video, s_stream, mode);
>> -		if (ret < 0 && ret != -ENOIOCTLCMD)
>> -			return ret;
>> +		/* Configure CSI-2 receiver based on sensor format. */
>> +		if (prev_subdev == &isp->isp_csi2a.subdev
>> +		    || prev_subdev == &isp->isp_csi2c.subdev) {
>> +			struct v4l2_subdev_format fmt;
>> +
>> +			fmt.pad = pad->index;
>> +			fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
>> +			ret = v4l2_subdev_call(subdev, pad, get_fmt,
>> +					       NULL, &fmt);
>> +			if (ret < 0)
>> +				return -EPIPE;
>> +
>> +			ret = omap3isp_csiphy_config(
>> +				isp, prev_subdev, subdev,
>> +				&fmt.format);
>> +			if (ret < 0)
>> +				return -EPIPE;
>> +
>> +			/* Start CSI-2 after configuration. */
>> +			ret = v4l2_subdev_call(prev_subdev, video,
>> +					       s_stream, mode);
>> +			if (ret < 0 && ret != -ENOIOCTLCMD)
>> +				return ret;
>> +		}
>> +
>> +		/* Start any other subdev except the CSI-2 receivers. */
>> +		if (subdev != &isp->isp_csi2a.subdev
>> +		    && subdev != &isp->isp_csi2c.subdev) {
>> +			ret = v4l2_subdev_call(subdev, video, s_stream, mode);
>> +			if (ret < 0 && ret != -ENOIOCTLCMD)
>> +				return ret;
>> +		}
> 
> What about moving this to the CSI2 s_stream subdev operation ?

Done.

>>
>>  		if (subdev == &isp->isp_ccdc.subdev) {
>>  			v4l2_subdev_call(&isp->isp_aewb.subdev, video,
>> diff --git a/drivers/media/video/omap3isp/isp.h
>> b/drivers/media/video/omap3isp/isp.h index 705946e..c5935ae 100644
>> --- a/drivers/media/video/omap3isp/isp.h
>> +++ b/drivers/media/video/omap3isp/isp.h
>> @@ -126,9 +126,6 @@ struct isp_reg {
>>
>>  struct isp_platform_callback {
>>  	u32 (*set_xclk)(struct isp_device *isp, u32 xclk, u8 xclksel);
>> -	int (*csiphy_config)(struct isp_csiphy *phy,
>> -			     struct isp_csiphy_dphy_cfg *dphy,
>> -			     struct isp_csiphy_lanes_cfg *lanes);
>>  	void (*set_pixel_clock)(struct isp_device *isp, unsigned int pixelclk);
>>  };
>>
>> diff --git a/drivers/media/video/omap3isp/ispcsiphy.c
>> b/drivers/media/video/omap3isp/ispcsiphy.c index 5be37ce..f027ece 100644
>> --- a/drivers/media/video/omap3isp/ispcsiphy.c
>> +++ b/drivers/media/video/omap3isp/ispcsiphy.c
>> @@ -28,6 +28,8 @@
>>  #include <linux/device.h>
>>  #include <linux/regulator/consumer.h>
>>
>> +#include "../../../../arch/arm/mach-omap2/control.h"
>> +
> 
> #include <mach/control.h>
> 
> (untested) ?

I'm afraid it won't work. The above directory isn't in any include path
and likely shouldn't be. That file is included locally elsewhere, I believe.

I wonder what would be the right way to access that register definition
I need from the file:

	OMAP343X_CTRL_BASE
	OMAP3630_CONTROL_CAMERA_PHY_CTRL

>>  #include "isp.h"
>>  #include "ispreg.h"
>>  #include "ispcsiphy.h"
>> @@ -138,15 +140,78 @@ static void csiphy_dphy_config(struct isp_csiphy
>> *phy) isp_reg_writel(phy->isp, reg, phy->phy_regs, ISPCSIPHY_REG1);
>>  }
>>
>> -static int csiphy_config(struct isp_csiphy *phy,
>> -			 struct isp_csiphy_dphy_cfg *dphy,
>> -			 struct isp_csiphy_lanes_cfg *lanes)
>> +/*
>> + * TCLK values are OK at their reset values
>> + */
>> +#define TCLK_TERM	0
>> +#define TCLK_MISS	1
>> +#define TCLK_SETTLE	14
>> +
>> +int omap3isp_csiphy_config(struct isp_device *isp,
>> +			   struct v4l2_subdev *csi2_subdev,
>> +			   struct v4l2_subdev *sensor,
>> +			   struct v4l2_mbus_framefmt *sensor_fmt)
>>  {
>> +	struct isp_v4l2_subdevs_group *subdevs = sensor->host_priv;
>> +	struct isp_csi2_device *csi2 = v4l2_get_subdevdata(csi2_subdev);
>> +	struct isp_csiphy_dphy_cfg csi2phy;
>> +	int csi2_ddrclk_khz;
>> +	struct isp_csiphy_lanes_cfg *lanes;
>>  	unsigned int used_lanes = 0;
>>  	unsigned int i;
>> +	u32 cam_phy_ctrl;
>> +
>> +	if (subdevs->interface == ISP_INTERFACE_CCP2B_PHY1
>> +	    || subdevs->interface == ISP_INTERFACE_CCP2B_PHY2)
>> +		lanes = subdevs->bus.ccp2.lanecfg;
>> +	else
>> +		lanes = subdevs->bus.csi2.lanecfg;
> 
> Shouldn't lane configuration be retrieved from the sensor instead ? Sensors 
> could use different lane configuration depending on the mode. This could also 
> be implemented later when needed, but I don't think it would be too difficult 
> to get it right now.

I think we'd first need to standardise the CSI-2 bus configuration. I
don't see a practical need to make the lane configuration dynamic. You
could just use a lower frequency to achieve the same if you really need to.

Ideally it might be nice to do but there's really nothing I know that
required or even benefited from it --- at least for now.

>> +
>> +	if (!lanes) {
>> +		dev_err(isp->dev, "no lane configuration\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	cam_phy_ctrl = omap_readl(
>> +		OMAP343X_CTRL_BASE + OMAP3630_CONTROL_CAMERA_PHY_CTRL);
>> +	/*
>> +	 * SCM.CONTROL_CAMERA_PHY_CTRL
>> +	 * - bit[4]    : CSIPHY1 data sent to CSIB
>> +	 * - bit [3:2] : CSIPHY1 config: 00 d-phy, 01/10 ccp2
>> +	 * - bit [1:0] : CSIPHY2 config: 00 d-phy, 01/10 ccp2
>> +	 */
>> +	if (subdevs->interface == ISP_INTERFACE_CCP2B_PHY1)
>> +		cam_phy_ctrl |= 1 << 2;
>> +	else if (subdevs->interface == ISP_INTERFACE_CSI2C_PHY1)
>> +		cam_phy_ctrl &= 1 << 2;
>> +
>> +	if (subdevs->interface == ISP_INTERFACE_CCP2B_PHY2)
>> +		cam_phy_ctrl |= 1;
>> +	else if (subdevs->interface == ISP_INTERFACE_CSI2A_PHY2)
>> +		cam_phy_ctrl &= 1;
>> +
>> +	/* FIXME: Do 34xx / 35xx require something here? */
>> +	if (cpu_is_omap3630())
>> +		omap_writel(cam_phy_ctrl,
>> +			    OMAP343X_CTRL_BASE
>> +			    + OMAP3630_CONTROL_CAMERA_PHY_CTRL);
> 
> You use cam_phy_ctrl inside the if statement only, you can move its 
> computation there.

Will fix.

>> +
>> +	csi2_ddrclk_khz = sensor_fmt->pixelrate
>> +		/ (2 * csi2->phy->num_data_lanes)
>> +		* omap3isp_video_format_info(sensor_fmt->code)->bpp;
>> +
>> +	/*
>> +	 * THS_TERM: Programmed value = ceil(12.5 ns/DDRClk period) - 1.
>> +	 * THS_SETTLE: Programmed value = ceil(90 ns/DDRClk period) + 3.
>> +	 */
>> +	csi2phy.ths_term = DIV_ROUND_UP(25 * csi2_ddrclk_khz, 2000000) - 1;
>> +	csi2phy.ths_settle = DIV_ROUND_UP(90 * csi2_ddrclk_khz, 1000000) + 3;
>> +	csi2phy.tclk_term = TCLK_TERM;
>> +	csi2phy.tclk_miss = TCLK_MISS;
>> +	csi2phy.tclk_settle = TCLK_SETTLE;
>>
>>  	/* Clock and data lanes verification */
>> -	for (i = 0; i < phy->num_data_lanes; i++) {
>> +	for (i = 0; i < csi2->phy->num_data_lanes; i++) {
>>  		if (lanes->data[i].pol > 1 || lanes->data[i].pos > 3)
>>  			return -EINVAL;
>>
>> @@ -162,10 +227,10 @@ static int csiphy_config(struct isp_csiphy *phy,
>>  	if (lanes->clk.pos == 0 || used_lanes & (1 << lanes->clk.pos))
>>  		return -EINVAL;
>>
>> -	mutex_lock(&phy->mutex);
>> -	phy->dphy = *dphy;
>> -	phy->lanes = *lanes;
>> -	mutex_unlock(&phy->mutex);
>> +	mutex_lock(&csi2->phy->mutex);
>> +	csi2->phy->dphy = csi2phy;
>> +	csi2->phy->lanes = *lanes;
>> +	mutex_unlock(&csi2->phy->mutex);
>>
>>  	return 0;
>>  }
>> @@ -225,8 +290,6 @@ int omap3isp_csiphy_init(struct isp_device *isp)
>>  	struct isp_csiphy *phy1 = &isp->isp_csiphy1;
>>  	struct isp_csiphy *phy2 = &isp->isp_csiphy2;
>>
>> -	isp->platform_cb.csiphy_config = csiphy_config;
>> -
>>  	phy2->isp = isp;
>>  	phy2->csi2 = &isp->isp_csi2a;
>>  	phy2->num_data_lanes = ISP_CSIPHY2_NUM_DATA_LANES;
>> diff --git a/drivers/media/video/omap3isp/ispcsiphy.h
>> b/drivers/media/video/omap3isp/ispcsiphy.h index e93a661..9f93222 100644
>> --- a/drivers/media/video/omap3isp/ispcsiphy.h
>> +++ b/drivers/media/video/omap3isp/ispcsiphy.h
>> @@ -56,6 +56,10 @@ struct isp_csiphy {
>>  	struct isp_csiphy_dphy_cfg dphy;
>>  };
>>
>> +int omap3isp_csiphy_config(struct isp_device *isp,
>> +			   struct v4l2_subdev *csi2_subdev,
>> +			   struct v4l2_subdev *sensor,
>> +			   struct v4l2_mbus_framefmt *fmt);
>>  int omap3isp_csiphy_acquire(struct isp_csiphy *phy);
>>  void omap3isp_csiphy_release(struct isp_csiphy *phy);
>>  int omap3isp_csiphy_init(struct isp_device *isp);
> 


-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
