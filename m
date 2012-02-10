Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:46349 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932440Ab2BJUcq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Feb 2012 15:32:46 -0500
Message-ID: <4F357EDD.2010804@iki.fi>
Date: Fri, 10 Feb 2012 22:32:29 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: "Aguirre, Sergio" <saaguirre@ti.com>
CC: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@samsung.com, riverful@gmail.com,
	hverkuil@xs4all.nl, teturtia@gmail.com
Subject: Re: [PATCH v2 27/31] omap3isp: Configure CSI-2 phy based on platform
 data
References: <20120202235231.GC841@valkosipuli.localdomain> <1328226891-8968-27-git-send-email-sakari.ailus@iki.fi> <CAKnK67RzAZ1Lq+xFe3dOhtwF7qg_mYJYC-maiORsKeZ5FZOx0w@mail.gmail.com>
In-Reply-To: <CAKnK67RzAZ1Lq+xFe3dOhtwF7qg_mYJYC-maiORsKeZ5FZOx0w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sergio,

Thanks for the review!

Aguirre, Sergio wrote:
> On Thu, Feb 2, 2012 at 5:54 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
>> Configure CSI-2 phy based on platform data in the ISP driver. For that, the
>> new V4L2_CID_IMAGE_SOURCE_PIXEL_RATE control is used. Previously the same
>> was configured from the board code.
>>
>> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
>> ---
>>  drivers/media/video/omap3isp/ispcsi2.c   |   10 +++-
>>  drivers/media/video/omap3isp/ispcsiphy.c |   78 ++++++++++++++++++++++++++----
>>  drivers/media/video/omap3isp/ispcsiphy.h |    2 +
>>  3 files changed, 78 insertions(+), 12 deletions(-)
>>
>> diff --git a/drivers/media/video/omap3isp/ispcsi2.c b/drivers/media/video/omap3isp/ispcsi2.c
>> index 9313f7c..e2e3d63 100644
>> --- a/drivers/media/video/omap3isp/ispcsi2.c
>> +++ b/drivers/media/video/omap3isp/ispcsi2.c
>> @@ -1068,7 +1068,13 @@ static int csi2_set_stream(struct v4l2_subdev *sd, int enable)
>>        struct isp_video *video_out = &csi2->video_out;
>>
>>        switch (enable) {
>> -       case ISP_PIPELINE_STREAM_CONTINUOUS:
>> +       case ISP_PIPELINE_STREAM_CONTINUOUS: {
>> +               int ret;
>> +
>> +               ret = omap3isp_csiphy_config(isp, sd);
>> +               if (ret < 0)
>> +                       return ret;
>> +
>>                if (omap3isp_csiphy_acquire(csi2->phy) < 0)
>>                        return -ENODEV;
>>                csi2->use_fs_irq = pipe->do_propagation;
>> @@ -1092,7 +1098,7 @@ static int csi2_set_stream(struct v4l2_subdev *sd, int enable)
>>                csi2_if_enable(isp, csi2, 1);
>>                isp_video_dmaqueue_flags_clr(video_out);
>>                break;
>> -
>> +       }
>>        case ISP_PIPELINE_STREAM_STOPPED:
>>                if (csi2->state == ISP_PIPELINE_STREAM_STOPPED)
>>                        return 0;
>> diff --git a/drivers/media/video/omap3isp/ispcsiphy.c b/drivers/media/video/omap3isp/ispcsiphy.c
>> index 5be37ce..5d7a6ab 100644
>> --- a/drivers/media/video/omap3isp/ispcsiphy.c
>> +++ b/drivers/media/video/omap3isp/ispcsiphy.c
>> @@ -28,6 +28,8 @@
>>  #include <linux/device.h>
>>  #include <linux/regulator/consumer.h>
>>
>> +#include "../../../../arch/arm/mach-omap2/control.h"
>> +
>>  #include "isp.h"
>>  #include "ispreg.h"
>>  #include "ispcsiphy.h"
>> @@ -138,15 +140,73 @@ static void csiphy_dphy_config(struct isp_csiphy *phy)
>>        isp_reg_writel(phy->isp, reg, phy->phy_regs, ISPCSIPHY_REG1);
>>  }
>>
>> -static int csiphy_config(struct isp_csiphy *phy,
>> -                        struct isp_csiphy_dphy_cfg *dphy,
>> -                        struct isp_csiphy_lanes_cfg *lanes)
>> +/*
>> + * TCLK values are OK at their reset values
>> + */
>> +#define TCLK_TERM      0
>> +#define TCLK_MISS      1
>> +#define TCLK_SETTLE    14
>> +
>> +int omap3isp_csiphy_config(struct isp_device *isp,
>> +                          struct v4l2_subdev *csi2_subdev)
>>  {
>> +       struct isp_csi2_device *csi2 = v4l2_get_subdevdata(csi2_subdev);
>> +       struct isp_pipeline *pipe = to_isp_pipeline(&csi2_subdev->entity);
>> +       struct isp_v4l2_subdevs_group *subdevs = pipe->external->host_priv;
>> +       struct isp_csiphy_dphy_cfg csi2phy;
>> +       int csi2_ddrclk_khz;
>> +       struct isp_csiphy_lanes_cfg *lanes;
>>        unsigned int used_lanes = 0;
>>        unsigned int i;
>>
>> +       if (subdevs->interface == ISP_INTERFACE_CCP2B_PHY1
>> +           || subdevs->interface == ISP_INTERFACE_CCP2B_PHY2)
>> +               lanes = &subdevs->bus.ccp2.lanecfg;
>> +       else
>> +               lanes = &subdevs->bus.csi2.lanecfg;
>> +
>> +       /* FIXME: Do 34xx / 35xx require something here? */
>> +       if (cpu_is_omap3630()) {
>> +               u32 cam_phy_ctrl = omap_readl(
>> +                       OMAP343X_CTRL_BASE + OMAP3630_CONTROL_CAMERA_PHY_CTRL);
> 
> How about:
> 		u32 cam_phy_ctrl = omap_ctrl_readl(OMAP3630_CONTROL_CAMERA_PHY_CTRL);
> ?

Fine for me.

>> +
>> +               /*
>> +                * SCM.CONTROL_CAMERA_PHY_CTRL
>> +                * - bit[4]    : CSIPHY1 data sent to CSIB
>> +                * - bit [3:2] : CSIPHY1 config: 00 d-phy, 01/10 ccp2
>> +                * - bit [1:0] : CSIPHY2 config: 00 d-phy, 01/10 ccp2
>> +                */
>> +               if (subdevs->interface == ISP_INTERFACE_CCP2B_PHY1)
>> +                       cam_phy_ctrl |= 1 << 2;
>> +               else if (subdevs->interface == ISP_INTERFACE_CSI2C_PHY1)
>> +                       cam_phy_ctrl &= 1 << 2;
> 
> Shouldn't this be:
>                        cam_phy_ctrl &= ~(1 << 2);
> ?

Probably yes. This has come directly as it was in the original board
code and might not be entirely correct. It works on the N9 at least.

>> +
>> +               if (subdevs->interface == ISP_INTERFACE_CCP2B_PHY2)
>> +                       cam_phy_ctrl |= 1;
>> +               else if (subdevs->interface == ISP_INTERFACE_CSI2A_PHY2)
>> +                       cam_phy_ctrl &= 1;
> 
> ... and:
>                        cam_phy_ctrl &= ~1;
> 
>> +
>> +               omap_writel(cam_phy_ctrl,
>> +                           OMAP343X_CTRL_BASE
>> +                           + OMAP3630_CONTROL_CAMERA_PHY_CTRL);
> 
> Again:
> 		omap_ctrl_writel(cam_phy_ctrl, OMAP3630_CONTROL_CAMERA_PHY_CTRL);

Will fix.

>> +       }
>> +
>> +       csi2_ddrclk_khz = pipe->external_rate / 1000
>> +               / (2 * csi2->phy->num_data_lanes)
>> +               * pipe->external_bpp;
> 
> Can you please explain how did you came up with this formula?
> 
> For example, if I keep the pixel_rate, yet I change the number of
> lanes my sensor is using,
> this result is unaltered, as phy->num_data_lanes is always equal to
> the maximum number
> of lanes available in the interface. (for OMAP4, that's 4 datalanes for CSI2-A).

The number of lanes is specified in the board code (in the future, DT)
and is thus specific to the board. The clock rate is per-lane whereas
the pipe->external_rate is the total pixel rate on all lanes.

> Meanwhile, in theory, if I keep the same pixels per second, and use
> less datalanes, the
> DDR frequency should at least double.
> 
> Now, this brings me to another question, How can the sensor tell how many lanes
> is using from the total?

We might consider making the number of lanes used dynamic but that's
currently static. I can't think of any major benefits right now in
making this dynamically configurable.

Does this answer to your questions? :-)

Kind regards,

-- 
Sakari Ailus
sakari.ailus@iki.fi
