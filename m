Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:36098 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753701Ab2BKRRZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Feb 2012 12:17:25 -0500
Received: by qcsd16 with SMTP id d16so2146890qcs.28
        for <linux-media@vger.kernel.org>; Sat, 11 Feb 2012 09:17:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F357EDD.2010804@iki.fi>
References: <20120202235231.GC841@valkosipuli.localdomain> <1328226891-8968-27-git-send-email-sakari.ailus@iki.fi>
 <CAKnK67RzAZ1Lq+xFe3dOhtwF7qg_mYJYC-maiORsKeZ5FZOx0w@mail.gmail.com> <4F357EDD.2010804@iki.fi>
From: "Aguirre, Sergio" <saaguirre@ti.com>
Date: Sat, 11 Feb 2012 11:17:02 -0600
Message-ID: <CAKnK67Srr3LFF6d12nmvqn=at-Pa+PMD=60r8jv06uDRERQAzA@mail.gmail.com>
Subject: Re: [PATCH v2 27/31] omap3isp: Configure CSI-2 phy based on platform data
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@samsung.com, riverful@gmail.com,
	hverkuil@xs4all.nl, teturtia@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Fri, Feb 10, 2012 at 2:32 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> Hi Sergio,
>
> Thanks for the review!
>
> Aguirre, Sergio wrote:
>> On Thu, Feb 2, 2012 at 5:54 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
>>> Configure CSI-2 phy based on platform data in the ISP driver. For that, the
>>> new V4L2_CID_IMAGE_SOURCE_PIXEL_RATE control is used. Previously the same
>>> was configured from the board code.
>>>
>>> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
>>> ---
>>>  drivers/media/video/omap3isp/ispcsi2.c   |   10 +++-
>>>  drivers/media/video/omap3isp/ispcsiphy.c |   78 ++++++++++++++++++++++++++----
>>>  drivers/media/video/omap3isp/ispcsiphy.h |    2 +
>>>  3 files changed, 78 insertions(+), 12 deletions(-)
>>>
>>> diff --git a/drivers/media/video/omap3isp/ispcsi2.c b/drivers/media/video/omap3isp/ispcsi2.c
>>> index 9313f7c..e2e3d63 100644
>>> --- a/drivers/media/video/omap3isp/ispcsi2.c
>>> +++ b/drivers/media/video/omap3isp/ispcsi2.c
>>> @@ -1068,7 +1068,13 @@ static int csi2_set_stream(struct v4l2_subdev *sd, int enable)
>>>        struct isp_video *video_out = &csi2->video_out;
>>>
>>>        switch (enable) {
>>> -       case ISP_PIPELINE_STREAM_CONTINUOUS:
>>> +       case ISP_PIPELINE_STREAM_CONTINUOUS: {
>>> +               int ret;
>>> +
>>> +               ret = omap3isp_csiphy_config(isp, sd);
>>> +               if (ret < 0)
>>> +                       return ret;
>>> +
>>>                if (omap3isp_csiphy_acquire(csi2->phy) < 0)
>>>                        return -ENODEV;
>>>                csi2->use_fs_irq = pipe->do_propagation;
>>> @@ -1092,7 +1098,7 @@ static int csi2_set_stream(struct v4l2_subdev *sd, int enable)
>>>                csi2_if_enable(isp, csi2, 1);
>>>                isp_video_dmaqueue_flags_clr(video_out);
>>>                break;
>>> -
>>> +       }
>>>        case ISP_PIPELINE_STREAM_STOPPED:
>>>                if (csi2->state == ISP_PIPELINE_STREAM_STOPPED)
>>>                        return 0;
>>> diff --git a/drivers/media/video/omap3isp/ispcsiphy.c b/drivers/media/video/omap3isp/ispcsiphy.c
>>> index 5be37ce..5d7a6ab 100644
>>> --- a/drivers/media/video/omap3isp/ispcsiphy.c
>>> +++ b/drivers/media/video/omap3isp/ispcsiphy.c
>>> @@ -28,6 +28,8 @@
>>>  #include <linux/device.h>
>>>  #include <linux/regulator/consumer.h>
>>>
>>> +#include "../../../../arch/arm/mach-omap2/control.h"
>>> +
>>>  #include "isp.h"
>>>  #include "ispreg.h"
>>>  #include "ispcsiphy.h"
>>> @@ -138,15 +140,73 @@ static void csiphy_dphy_config(struct isp_csiphy *phy)
>>>        isp_reg_writel(phy->isp, reg, phy->phy_regs, ISPCSIPHY_REG1);
>>>  }
>>>
>>> -static int csiphy_config(struct isp_csiphy *phy,
>>> -                        struct isp_csiphy_dphy_cfg *dphy,
>>> -                        struct isp_csiphy_lanes_cfg *lanes)
>>> +/*
>>> + * TCLK values are OK at their reset values
>>> + */
>>> +#define TCLK_TERM      0
>>> +#define TCLK_MISS      1
>>> +#define TCLK_SETTLE    14
>>> +
>>> +int omap3isp_csiphy_config(struct isp_device *isp,
>>> +                          struct v4l2_subdev *csi2_subdev)
>>>  {
>>> +       struct isp_csi2_device *csi2 = v4l2_get_subdevdata(csi2_subdev);
>>> +       struct isp_pipeline *pipe = to_isp_pipeline(&csi2_subdev->entity);
>>> +       struct isp_v4l2_subdevs_group *subdevs = pipe->external->host_priv;
>>> +       struct isp_csiphy_dphy_cfg csi2phy;
>>> +       int csi2_ddrclk_khz;
>>> +       struct isp_csiphy_lanes_cfg *lanes;
>>>        unsigned int used_lanes = 0;
>>>        unsigned int i;
>>>
>>> +       if (subdevs->interface == ISP_INTERFACE_CCP2B_PHY1
>>> +           || subdevs->interface == ISP_INTERFACE_CCP2B_PHY2)
>>> +               lanes = &subdevs->bus.ccp2.lanecfg;
>>> +       else
>>> +               lanes = &subdevs->bus.csi2.lanecfg;
>>> +
>>> +       /* FIXME: Do 34xx / 35xx require something here? */
>>> +       if (cpu_is_omap3630()) {
>>> +               u32 cam_phy_ctrl = omap_readl(
>>> +                       OMAP343X_CTRL_BASE + OMAP3630_CONTROL_CAMERA_PHY_CTRL);
>>
>> How about:
>>               u32 cam_phy_ctrl = omap_ctrl_readl(OMAP3630_CONTROL_CAMERA_PHY_CTRL);
>> ?
>
> Fine for me.
>
>>> +
>>> +               /*
>>> +                * SCM.CONTROL_CAMERA_PHY_CTRL
>>> +                * - bit[4]    : CSIPHY1 data sent to CSIB
>>> +                * - bit [3:2] : CSIPHY1 config: 00 d-phy, 01/10 ccp2
>>> +                * - bit [1:0] : CSIPHY2 config: 00 d-phy, 01/10 ccp2
>>> +                */
>>> +               if (subdevs->interface == ISP_INTERFACE_CCP2B_PHY1)
>>> +                       cam_phy_ctrl |= 1 << 2;
>>> +               else if (subdevs->interface == ISP_INTERFACE_CSI2C_PHY1)
>>> +                       cam_phy_ctrl &= 1 << 2;
>>
>> Shouldn't this be:
>>                        cam_phy_ctrl &= ~(1 << 2);
>> ?
>
> Probably yes. This has come directly as it was in the original board
> code and might not be entirely correct. It works on the N9 at least.
>
>>> +
>>> +               if (subdevs->interface == ISP_INTERFACE_CCP2B_PHY2)
>>> +                       cam_phy_ctrl |= 1;
>>> +               else if (subdevs->interface == ISP_INTERFACE_CSI2A_PHY2)
>>> +                       cam_phy_ctrl &= 1;
>>
>> ... and:
>>                        cam_phy_ctrl &= ~1;
>>
>>> +
>>> +               omap_writel(cam_phy_ctrl,
>>> +                           OMAP343X_CTRL_BASE
>>> +                           + OMAP3630_CONTROL_CAMERA_PHY_CTRL);
>>
>> Again:
>>               omap_ctrl_writel(cam_phy_ctrl, OMAP3630_CONTROL_CAMERA_PHY_CTRL);
>
> Will fix.
>
>>> +       }
>>> +
>>> +       csi2_ddrclk_khz = pipe->external_rate / 1000
>>> +               / (2 * csi2->phy->num_data_lanes)
>>> +               * pipe->external_bpp;
>>
>> Can you please explain how did you came up with this formula?
>>
>> For example, if I keep the pixel_rate, yet I change the number of
>> lanes my sensor is using,
>> this result is unaltered, as phy->num_data_lanes is always equal to
>> the maximum number
>> of lanes available in the interface. (for OMAP4, that's 4 datalanes for CSI2-A).
>
> The number of lanes is specified in the board code (in the future, DT)
> and is thus specific to the board. The clock rate is per-lane whereas
> the pipe->external_rate is the total pixel rate on all lanes.
>
>> Meanwhile, in theory, if I keep the same pixels per second, and use
>> less datalanes, the
>> DDR frequency should at least double.
>>
>> Now, this brings me to another question, How can the sensor tell how many lanes
>> is using from the total?
>
> We might consider making the number of lanes used dynamic but that's
> currently static. I can't think of any major benefits right now in
> making this dynamically configurable.
>
> Does this answer to your questions? :-)


Sorry, I think I didn't made my point clear properly, so I'm proposing
a patch to
expose and fix this wrong calculation i'm telling you about:

<<<<<<<< PATCH START
From: Sergio Aguirre <saaguirre@ti.com>
Date: Sat, 11 Feb 2012 10:53:01 -0600
Subject: [PATCH] omap3isp: phy: get ddrclk based on sensor lanecount

This will allow csi2_ddrclk_khz be calculated correctly, by
observing the sensor lane count, and not the interface lane count.

An example of erratic calculation is, if you have a sensor
which only has 1 data lane for output, yet the interface has 2
lanes available, the rate still is split in half:

pixel_rate = 96000000
bpp = 10
sensor_data_lanes = 1
phy_data_lanes = 2

Current formula pretty much says:

csi2_ddrclk_khz = pixel_rate / 1000
		/ (2 * phy_data_lanes)
		* bpp;

Explained is:

bits/second(bps) = pixels/second(pixel_rate) * bits/pixel(bpp)
cycles/second(Hz) = bits/second / 2 bits/cycle
cycles/datalane = cycles/second / num

Which is you use 2 in last line, would be wrong for a single
datalane sensor, so this patch attemote to collect the sensor
lane count, and use that instead in the formula.

NOTE: This is tested on omap4iss driver, which is in development.

Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
---
 drivers/media/video/omap3isp/ispcsiphy.c |   41 ++++++++++++++++--------------
 drivers/media/video/omap3isp/ispcsiphy.h |    3 +-
 2 files changed, 24 insertions(+), 20 deletions(-)

diff --git a/drivers/media/video/omap3isp/ispcsiphy.c
b/drivers/media/video/omap3isp/ispcsiphy.c
index 5d7a6ab..03c5749 100644
--- a/drivers/media/video/omap3isp/ispcsiphy.c
+++ b/drivers/media/video/omap3isp/ispcsiphy.c
@@ -47,7 +47,7 @@ static void csiphy_lanes_config(struct isp_csiphy *phy)

 	reg = isp_reg_readl(phy->isp, phy->cfg_regs, ISPCSI2_PHY_CFG);

-	for (i = 0; i < phy->num_data_lanes; i++) {
+	for (i = 0; i < phy->max_data_lanes; i++) {
 		reg &= ~(ISPCSI2_PHY_CFG_DATA_POL_MASK(i + 1) |
 			 ISPCSI2_PHY_CFG_DATA_POSITION_MASK(i + 1));
 		reg |= (phy->lanes.data[i].pol <<
@@ -191,22 +191,8 @@ int omap3isp_csiphy_config(struct isp_device *isp,
 			    + OMAP3630_CONTROL_CAMERA_PHY_CTRL);
 	}

-	csi2_ddrclk_khz = pipe->external_rate / 1000
-		/ (2 * csi2->phy->num_data_lanes)
-		* pipe->external_bpp;
-
-	/*
-	 * THS_TERM: Programmed value = ceil(12.5 ns/DDRClk period) - 1.
-	 * THS_SETTLE: Programmed value = ceil(90 ns/DDRClk period) + 3.
-	 */
-	csi2phy.ths_term = DIV_ROUND_UP(25 * csi2_ddrclk_khz, 2000000) - 1;
-	csi2phy.ths_settle = DIV_ROUND_UP(90 * csi2_ddrclk_khz, 1000000) + 3;
-	csi2phy.tclk_term = TCLK_TERM;
-	csi2phy.tclk_miss = TCLK_MISS;
-	csi2phy.tclk_settle = TCLK_SETTLE;
-
 	/* Clock and data lanes verification */
-	for (i = 0; i < csi2->phy->num_data_lanes; i++) {
+	for (i = 0; i < csi2->phy->max_data_lanes; i++) {
 		if (lanes->data[i].pol > 1 || lanes->data[i].pos > 3)
 			return -EINVAL;

@@ -214,14 +200,29 @@ int omap3isp_csiphy_config(struct isp_device *isp,
 			return -EINVAL;

 		used_lanes |= 1 << lanes->data[i].pos;
+		csi2->phy->used_data_lanes++;
 	}

-	if (lanes->clk.pol > 1 || lanes->clk.pos > 3)
+	if (lanes->clk.pol > 1 || lanes->clk.pos > csi2->phy->max_data_lanes)
 		return -EINVAL;

 	if (lanes->clk.pos == 0 || used_lanes & (1 << lanes->clk.pos))
 		return -EINVAL;

+	csi2_ddrclk_khz = pipe->external_rate / 1000
+		/ (2 * csi2->phy->used_data_lanes)
+		* pipe->external_bpp;
+
+	/*
+	 * THS_TERM: Programmed value = ceil(12.5 ns/DDRClk period) - 1.
+	 * THS_SETTLE: Programmed value = ceil(90 ns/DDRClk period) + 3.
+	 */
+	csi2phy.ths_term = DIV_ROUND_UP(25 * csi2_ddrclk_khz, 2000000) - 1;
+	csi2phy.ths_settle = DIV_ROUND_UP(90 * csi2_ddrclk_khz, 1000000) + 3;
+	csi2phy.tclk_term = TCLK_TERM;
+	csi2phy.tclk_miss = TCLK_MISS;
+	csi2phy.tclk_settle = TCLK_SETTLE;
+
 	mutex_lock(&csi2->phy->mutex);
 	csi2->phy->dphy = csi2phy;
 	csi2->phy->lanes = *lanes;
@@ -287,7 +288,8 @@ int omap3isp_csiphy_init(struct isp_device *isp)

 	phy2->isp = isp;
 	phy2->csi2 = &isp->isp_csi2a;
-	phy2->num_data_lanes = ISP_CSIPHY2_NUM_DATA_LANES;
+	phy2->max_data_lanes = ISP_CSIPHY2_NUM_DATA_LANES;
+	phy2->used_data_lanes = 0;
 	phy2->cfg_regs = OMAP3_ISP_IOMEM_CSI2A_REGS1;
 	phy2->phy_regs = OMAP3_ISP_IOMEM_CSIPHY2;
 	mutex_init(&phy2->mutex);
@@ -295,7 +297,8 @@ int omap3isp_csiphy_init(struct isp_device *isp)
 	if (isp->revision == ISP_REVISION_15_0) {
 		phy1->isp = isp;
 		phy1->csi2 = &isp->isp_csi2c;
-		phy1->num_data_lanes = ISP_CSIPHY1_NUM_DATA_LANES;
+		phy1->max_data_lanes = ISP_CSIPHY1_NUM_DATA_LANES;
+		phy1->used_data_lanes = 0;
 		phy1->cfg_regs = OMAP3_ISP_IOMEM_CSI2C_REGS1;
 		phy1->phy_regs = OMAP3_ISP_IOMEM_CSIPHY1;
 		mutex_init(&phy1->mutex);
diff --git a/drivers/media/video/omap3isp/ispcsiphy.h
b/drivers/media/video/omap3isp/ispcsiphy.h
index a404b10..3401bbd 100644
--- a/drivers/media/video/omap3isp/ispcsiphy.h
+++ b/drivers/media/video/omap3isp/ispcsiphy.h
@@ -51,7 +51,8 @@ struct isp_csiphy {
 	unsigned int cfg_regs;
 	unsigned int phy_regs;

-	u8 num_data_lanes;	/* number of CSI2 Data Lanes supported */
+	u8 max_data_lanes;	/* number of CSI2 Data Lanes supported */
+	u8 used_data_lanes;	/* number of CSI2 Data Lanes used */
 	struct isp_csiphy_lanes_cfg lanes;
 	struct isp_csiphy_dphy_cfg dphy;
 };
-- 
1.7.7.4
>>>>>>>> PATCH END

I hope this clarifies my point.

Regards,
Sergio

>
> Kind regards,
>
> --
> Sakari Ailus
> sakari.ailus@iki.fi
