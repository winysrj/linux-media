Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:45246 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752103AbdLMKA7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Dec 2017 05:00:59 -0500
Subject: Re: [PATCH v10 4/4] [media] platform: Add Synopsys DesignWare HDMI RX
 Controller Driver
To: Jose Abreu <Jose.Abreu@synopsys.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1513013948.git.joabreu@synopsys.com>
 <5f9eedfd6f91ed73ef0bb6d3977588d01478909f.1513013948.git.joabreu@synopsys.com>
 <108e2c3c-243f-cd67-2df7-57541b28ca39@xs4all.nl>
 <635e7d70-0edb-7506-c268-9ebbae1eb39e@synopsys.com>
Cc: Joao Pinto <Joao.Pinto@synopsys.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sylwester Nawrocki <snawrocki@kernel.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Philippe Ombredanne <pombredanne@nexb.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <ca5b3cf7-c7d0-36d4-08ac-32a7a00afd7d@xs4all.nl>
Date: Wed, 13 Dec 2017 11:00:56 +0100
MIME-Version: 1.0
In-Reply-To: <635e7d70-0edb-7506-c268-9ebbae1eb39e@synopsys.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/12/17 17:02, Jose Abreu wrote:
> Hi Hans,
> 
> On 12-12-2017 15:47, Hans Verkuil wrote:
>> Hi Jose,
>>
>> Some more comments:
> 
> Thanks for the review!
> 
>>
>> On 11/12/17 18:41, Jose Abreu wrote:
>>> This is an initial submission for the Synopsys DesignWare HDMI RX
>>> Controller Driver. This driver interacts with a phy driver so that
>>> a communication between them is created and a video pipeline is
>>> configured.
>>>
>>> The controller + phy pipeline can then be integrated into a fully
>>> featured system that can be able to receive video up to 4k@60Hz
>>> with deep color 48bit RGB, depending on the platform. Although,
>>> this initial version does not yet handle deep color modes.
>>>
>>> This driver was implemented as a standard V4L2 subdevice and its
>>> main features are:
>>> 	- Internal state machine that reconfigures phy until the
>>> 	video is not stable
>>> 	- JTAG communication with phy
>>> 	- Inter-module communication with phy driver
>>> 	- Debug write/read ioctls
>>>
>>> Some notes:
>>> 	- RX sense controller (cable connection/disconnection) must
>>> 	be handled by the platform wrapper as this is not integrated
>>> 	into the controller RTL
>>> 	- The same goes for EDID ROM's
>>> 	- ZCAL calibration is needed only in FPGA platforms, in ASIC
>>> 	this is not needed
>>> 	- The state machine is not an ideal solution as it creates a
>>> 	kthread but it is needed because some sources might not be
>>> 	very stable at sending the video (i.e. we must react
>>> 	accordingly).
>>>
>>> Signed-off-by: Jose Abreu <joabreu@synopsys.com>
>>> Cc: Joao Pinto <jpinto@synopsys.com>
>>> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
>>> Cc: Hans Verkuil <hans.verkuil@cisco.com>
>>> Cc: Sylwester Nawrocki <snawrocki@kernel.org>
>>> Cc: Sakari Ailus <sakari.ailus@iki.fi>
>>> Cc: Philippe Ombredanne <pombredanne@nexb.com>
>>> ---
>>> Changes from v9:
>>> 	- Use SPDX License ID (Philippe)
>>> 	- Use LOW_DRIVE CEC error (Hans)
>>> 	- Fill bt->il_* fields (Hans)
>>> 	- Fix format->field to NONE (Hans)
>>> 	- Drop a left-over comment (Hans)
>>> 	- Use CEC_CAP_DEFAULTS (Hans)
>>> Changes from v8:
>>> 	- Incorporate Sakari's work on ASYNC subdevs
>>> Changes from v6:
>>> 	- edid-phandle now also looks for parent node (Sylwester)
>>> 	- Fix kbuild build warnings
>>> Changes from v5:
>>> 	- Removed HDCP 1.4 support (Hans)
>>> 	- Removed some CEC debug messages (Hans)
>>> 	- Add s_dv_timings callback (Hans)
>>> 	- Add V4L2_CID_DV_RX_POWER_PRESENT ctrl (Hans)
>>> Changes from v4:
>>> 	- Add flag V4L2_SUBDEV_FL_HAS_DEVNODE (Sylwester)
>>> 	- Remove some comments and change some messages to dev_dbg (Sylwester)
>>> 	- Use v4l2_async_subnotifier_register() (Sylwester)
>>> Changes from v3:
>>> 	- Use v4l2 async API (Sylwester)
>>> 	- Do not block waiting for phy
>>> 	- Do not use busy waiting delays (Sylwester)
>>> 	- Simplify dw_hdmi_power_on (Sylwester)
>>> 	- Use clock API (Sylwester)
>>> 	- Use compatible string (Sylwester)
>>> 	- Minor fixes (Sylwester)
>>> Changes from v2:
>>> 	- Address review comments from Hans regarding CEC
>>> 	- Use CEC notifier
>>> 	- Enable SCDC
>>> Changes from v1:
>>> 	- Add support for CEC
>>> 	- Correct typo errors
>>> 	- Correctly detect interlaced video modes
>>> 	- Correct VIC parsing
>>> Changes from RFC:
>>> 	- Add support for HDCP 1.4
>>> 	- Fixup HDMI_VIC not being parsed (Hans)
>>> 	- Send source change signal when powering off (Hans)
>>> 	- Add a "wait stable delay"
>>> 	- Detect interlaced video modes (Hans)
>>> 	- Restrain g/s_register from reading/writing to HDCP regs (Hans)
>>> ---
>>>  drivers/media/platform/dwc/Kconfig      |   15 +
>>>  drivers/media/platform/dwc/Makefile     |    1 +
>>>  drivers/media/platform/dwc/dw-hdmi-rx.c | 1840 +++++++++++++++++++++++++++++++
>>>  drivers/media/platform/dwc/dw-hdmi-rx.h |  419 +++++++
>>>  include/media/dwc/dw-hdmi-rx-pdata.h    |   48 +
>>>  5 files changed, 2323 insertions(+)
>>>  create mode 100644 drivers/media/platform/dwc/dw-hdmi-rx.c
>>>  create mode 100644 drivers/media/platform/dwc/dw-hdmi-rx.h
>>>  create mode 100644 include/media/dwc/dw-hdmi-rx-pdata.h
>>>
>>> diff --git a/drivers/media/platform/dwc/Kconfig b/drivers/media/platform/dwc/Kconfig
>>> index 361d38d..3ddccde 100644
>>> --- a/drivers/media/platform/dwc/Kconfig
>>> +++ b/drivers/media/platform/dwc/Kconfig
>>> @@ -6,3 +6,18 @@ config VIDEO_DWC_HDMI_PHY_E405
>>>  
>>>  	  To compile this driver as a module, choose M here. The module
>>>  	  will be called dw-hdmi-phy-e405.
>>> +
>>> +config VIDEO_DWC_HDMI_RX
>>> +	tristate "Synopsys Designware HDMI Receiver driver"
>>> +	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
>>> +	help
>>> +	  Support for Synopsys Designware HDMI RX controller.
>>> +
>>> +	  To compile this driver as a module, choose M here. The module
>>> +	  will be called dw-hdmi-rx.
>>> +
>>> +config VIDEO_DWC_HDMI_RX_CEC
>>> +	bool
>>> +	depends on VIDEO_DWC_HDMI_RX
>>> +	select CEC_CORE
>>> +	select CEC_NOTIFIER
>>> diff --git a/drivers/media/platform/dwc/Makefile b/drivers/media/platform/dwc/Makefile
>>> index fc3b62c..cd04ca9 100644
>>> --- a/drivers/media/platform/dwc/Makefile
>>> +++ b/drivers/media/platform/dwc/Makefile
>>> @@ -1 +1,2 @@
>>>  obj-$(CONFIG_VIDEO_DWC_HDMI_PHY_E405) += dw-hdmi-phy-e405.o
>>> +obj-$(CONFIG_VIDEO_DWC_HDMI_RX) += dw-hdmi-rx.o
>>> diff --git a/drivers/media/platform/dwc/dw-hdmi-rx.c b/drivers/media/platform/dwc/dw-hdmi-rx.c
>>> new file mode 100644
>>> index 0000000..437351e
>>> --- /dev/null
>>> +++ b/drivers/media/platform/dwc/dw-hdmi-rx.c
>> <snip>
>>
>>> +static int dw_hdmi_s_routing(struct v4l2_subdev *sd, u32 input, u32 output,
>>> +		u32 config)
>>> +{
>>> +	struct dw_hdmi_dev *dw_dev = to_dw_dev(sd);
>>> +
>>> +	if (!has_signal(dw_dev, input))
>>> +		return -EINVAL;
>> Why would this be a reason to reject this? There may be no signal now, but a signal
>> might appear later.
> 
> I would expect s_routing to only be called if there is an input
> connected, otherwise we are just wasting resources by trying to
> equalize an input that is not present ... I can remove the "if"
> as there are other safe guards for this though (for example g_fmt
> will return an error) ...

No, s_routing is typically called as a result of a VIDIOC_S_INPUT
call, and that can come whether or not there is a signal on an
input. In fact, initially the first input is always selected anyway,
whether or not there is a signal.

g_fmt will just return the current configured format, this is unrelated
to whether or not there is a signal.

The only times the driver checks whether or not there is a signal (and
what that is) are:

1) g_input_status
2) query_dv_timings
3) when the irq detects a signal change and sends V4L2_EVENT_SOURCE_CHANGE

> 
>>
>>> +
>>> +	dw_dev->selected_input = input;
>>> +	if (input == dw_dev->configured_input)
>>> +		return 0;
>>> +
>>> +	dw_hdmi_power_off(dw_dev);
>>> +	return dw_hdmi_power_on(dw_dev, input);
>>> +}
>>> +
>>> +static int dw_hdmi_g_input_status(struct v4l2_subdev *sd, u32 *status)
>>> +{
>>> +	struct dw_hdmi_dev *dw_dev = to_dw_dev(sd);
>>> +
>>> +	*status = 0;
>>> +	if (!has_signal(dw_dev, dw_dev->selected_input))
>>> +		*status |= V4L2_IN_ST_NO_POWER;
>>> +	if (is_off(dw_dev))
>>> +		*status |= V4L2_IN_ST_NO_SIGNAL;
>>> +
>>> +	dev_dbg(dw_dev->dev, "%s: status=0x%x\n", __func__, *status);
>>> +	return 0;
>>> +}
>>> +
>>> +static int dw_hdmi_g_parm(struct v4l2_subdev *sd, struct v4l2_streamparm *parm)
>>> +{
>>> +	struct dw_hdmi_dev *dw_dev = to_dw_dev(sd);
>>> +
>>> +	dev_dbg(dw_dev->dev, "%s\n", __func__);
>>> +
>>> +	/* TODO: Use helper to compute timeperframe */
>>> +	parm->parm.capture.timeperframe.numerator = 1;
>>> +	parm->parm.capture.timeperframe.denominator = 60;
>>> +	return 0;
>>> +}
>>> +
>>> +static int dw_hdmi_s_dv_timings(struct v4l2_subdev *sd,
>>> +		struct v4l2_dv_timings *timings)
>>> +{
>>> +	struct dw_hdmi_dev *dw_dev = to_dw_dev(sd);
>>> +
>>> +	dev_dbg(dw_dev->dev, "%s\n", __func__);
>>> +	if (!v4l2_valid_dv_timings(timings, &dw_hdmi_timings_cap, NULL, NULL))
>>> +		return -EINVAL;
>>> +	if (v4l2_match_dv_timings(timings, &dw_dev->timings, 0, false))
>>> +		return 0;
>>> +
>>> +	dw_dev->timings = *timings;
>>> +	return 0;
>>> +}
>>> +
>>> +static int dw_hdmi_g_dv_timings(struct v4l2_subdev *sd,
>>> +		struct v4l2_dv_timings *timings)
>>> +{
>>> +	struct dw_hdmi_dev *dw_dev = to_dw_dev(sd);
>>> +
>>> +	dev_dbg(dw_dev->dev, "%s\n", __func__);
>>> +
>>> +	*timings = dw_dev->timings;
>>> +	return 0;
>>> +}
>>> +
>>> +static int dw_hdmi_query_dv_timings(struct v4l2_subdev *sd,
>>> +		struct v4l2_dv_timings *timings)
>>> +{
>>> +	struct dw_hdmi_dev *dw_dev = to_dw_dev(sd);
>>> +	struct v4l2_bt_timings *bt = &timings->bt;
>>> +	bool is_hdmi_vic;
>>> +	u32 htot, hofs;
>>> +	u32 vtot;
>>> +	u8 vic;
>>> +
>>> +	dev_dbg(dw_dev->dev, "%s\n", __func__);
>>> +
>>> +	memset(timings, 0, sizeof(*timings));
>>> +
>>> +	timings->type = V4L2_DV_BT_656_1120;
>>> +	bt->width = hdmi_readl(dw_dev, HDMI_MD_HACT_PX);
>>> +	bt->height = hdmi_readl(dw_dev, HDMI_MD_VAL);
>>> +	bt->interlaced = hdmi_readl(dw_dev, HDMI_MD_STS) & HDMI_MD_STS_ILACE ?
>>> +		V4L2_DV_INTERLACED : V4L2_DV_PROGRESSIVE;
>>> +
>>> +	if (hdmi_readl(dw_dev, HDMI_ISTS) & HDMI_ISTS_VS_POL_ADJ)
>>> +		bt->polarities |= V4L2_DV_VSYNC_POS_POL;
>>> +	if (hdmi_readl(dw_dev, HDMI_ISTS) & HDMI_ISTS_HS_POL_ADJ)
>>> +		bt->polarities |= V4L2_DV_HSYNC_POS_POL;
>>> +
>>> +	bt->pixelclock = dw_hdmi_get_pixelclk(dw_dev);
>>> +
>>> +	/* HTOT = HACT + HFRONT + HSYNC + HBACK */
>>> +	htot = hdmi_mask_readl(dw_dev, HDMI_MD_HT1,
>>> +			HDMI_MD_HT1_HTOT_PIX_OFFSET,
>>> +			HDMI_MD_HT1_HTOT_PIX_MASK);
>>> +	/* HOFS = HSYNC + HBACK */
>>> +	hofs = hdmi_mask_readl(dw_dev, HDMI_MD_HT1,
>>> +			HDMI_MD_HT1_HOFS_PIX_OFFSET,
>>> +			HDMI_MD_HT1_HOFS_PIX_MASK);
>>> +
>>> +	bt->hfrontporch = htot - hofs - bt->width;
>>> +	bt->hsync = hdmi_mask_readl(dw_dev, HDMI_MD_HT0,
>>> +			HDMI_MD_HT0_HS_CLK_OFFSET,
>>> +			HDMI_MD_HT0_HS_CLK_MASK);
>>> +	bt->hbackporch = hofs - bt->hsync;
>>> +
>>> +	/* VTOT = VACT + VFRONT + VSYNC + VBACK */
>>> +	vtot = hdmi_readl(dw_dev, HDMI_MD_VTL);
>>> +
>>> +	hdmi_mask_writel(dw_dev, 0x1, HDMI_MD_VCTRL,
>>> +			HDMI_MD_VCTRL_V_OFFS_LIN_MODE_OFFSET,
>>> +			HDMI_MD_VCTRL_V_OFFS_LIN_MODE_MASK);
>>> +	msleep(50); /* Wait for 1 field */
>> How do you know this waits for 1 field? Or is this: "Wait for at least 1 field"?
> 
> Its wait at least for 1 field. This is over-generous because its
> assuming the frame rate is 20fps (which in HDMI does not happen).

With custom timings it can happen (i.e. a 15 fps stream). Admittedly, it's not
common, but people sometimes use it.

> 
>> I don't know exactly how the IP does this, but it looks fishy to me. If it is
>> correct, then it could use a few comments about what is going on here as it is
>> not obvious.
> 
> The IP updates the values at each field but I need to change this
> register to populate all values in the bt struct.

How do you know which field (top or bottom) you've captured? How do you know you
didn't miss e.g. the bottom field and instead end up with two top field measurements?

The top and bottom field are almost, but not quite the same. Typically the vertical
backporch of the fields differs by 1 where the second field's backporch is larger by 1 line.

> 
>>
>> And what happens if the framerate is even slower? You know the pixelclock and
>> total width+height, so you can calculate the framerate from that.
> 
> Hmm, but then I have to consider pixelclk error, msleep error, ...

But you have that now as well.

An alternative is to measure a single field and deduce the backporch values from that.

At least for all the common HDMI interlaced formats il_vbackporch is an even value and
vbackporch is il_vbackporch - 1.

So if you get an even backporch, then you found il_vbackporch, and if it is odd, then
you found vbackporch.

> 
>>
>>> +	bt->vsync = hdmi_readl(dw_dev, HDMI_MD_VOL);
>>> +
>>> +	hdmi_mask_writel(dw_dev, 0x0, HDMI_MD_VCTRL,
>>> +			HDMI_MD_VCTRL_V_OFFS_LIN_MODE_OFFSET,
>>> +			HDMI_MD_VCTRL_V_OFFS_LIN_MODE_MASK);
>>> +	msleep(50); /* Wait for 1 field */
>>> +	bt->vbackporch = hdmi_readl(dw_dev, HDMI_MD_VOL);
>>> +	bt->vfrontporch = vtot - bt->height - bt->vsync - bt->vbackporch;
>>> +
>>> +	if (bt->interlaced == V4L2_DV_INTERLACED) {
>>> +		hdmi_mask_writel(dw_dev, 0x1, HDMI_MD_VCTRL,
>>> +				HDMI_MD_VCTRL_V_MODE_OFFSET,
>>> +				HDMI_MD_VCTRL_V_MODE_MASK);
>>> +		msleep(100); /* Wait for 2 fields */
>>> +
>>> +		vtot = hdmi_readl(dw_dev, HDMI_MD_VTL);
>>> +		hdmi_mask_writel(dw_dev, 0x1, HDMI_MD_VCTRL,
>>> +				HDMI_MD_VCTRL_V_OFFS_LIN_MODE_OFFSET,
>>> +				HDMI_MD_VCTRL_V_OFFS_LIN_MODE_MASK);
>>> +		msleep(50); /* Wait for 1 field */
>>> +		bt->il_vsync = hdmi_readl(dw_dev, HDMI_MD_VOL);
>>> +
>>> +		hdmi_mask_writel(dw_dev, 0x0, HDMI_MD_VCTRL,
>>> +				HDMI_MD_VCTRL_V_OFFS_LIN_MODE_OFFSET,
>>> +				HDMI_MD_VCTRL_V_OFFS_LIN_MODE_MASK);
>>> +		msleep(50);
>>> +		bt->il_vbackporch = hdmi_readl(dw_dev, HDMI_MD_VOL);
>>> +		bt->il_vfrontporch = vtot - bt->height - bt->il_vsync -
>>> +			bt->il_vbackporch;
>>> +
>>> +		hdmi_mask_writel(dw_dev, 0x0, HDMI_MD_VCTRL,
>>> +				HDMI_MD_VCTRL_V_MODE_OFFSET,
>>> +				HDMI_MD_VCTRL_V_MODE_MASK);
>> Same here, I'm not sure this is correct. What is the output of
>> 'v4l2-ctl --query-dv-timings' when you feed it a standard interlaced format?
> 
> I used v4l2-ctl --log-status with interlaced format and
> everything seemed correct ...

Can you show a few examples? Is vbackport odd? And is il_vbackporch equal to vbackporch + 1?

Interlaced is tricky :-)

Regards,

	Hans

> 
> Thanks and Best Regards,
> Jose Miguel Abreu
> 
>>
>>> +	}
>>> +
>>> +	bt->standards = V4L2_DV_BT_STD_CEA861;
>>> +
>>> +	vic = dw_hdmi_get_curr_vic(dw_dev, &is_hdmi_vic);
>>> +	if (vic) {
>>> +		if (is_hdmi_vic) {
>>> +			bt->flags |= V4L2_DV_FL_HAS_HDMI_VIC;
>>> +			bt->hdmi_vic = vic;
>>> +			bt->cea861_vic = 0;
>>> +		} else {
>>> +			bt->flags |= V4L2_DV_FL_HAS_CEA861_VIC;
>>> +			bt->hdmi_vic = 0;
>>> +			bt->cea861_vic = vic;
>>> +		}
>>> +	}
>>> +
>>> +	return 0;
>>> +}
>> Regards,
>>
>> 	Hans
>>
> 
