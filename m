Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-3.cisco.com ([173.38.203.53]:64641 "EHLO
        aer-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754837AbdLGNWh (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Dec 2017 08:22:37 -0500
Subject: Re: [PATCH v9 4/4] [media] platform: Add Synopsys DesignWare HDMI RX
 Controller Driver
To: Jose Abreu <Jose.Abreu@synopsys.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Joao Pinto <Joao.Pinto@synopsys.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sylwester Nawrocki <snawrocki@kernel.org>,
        Sakari Ailus <sakari.ailus@iki.fi>
References: <cover.1512582979.git.joabreu@synopsys.com>
 <fd906727f9f507bcc748125972cae447cf1e5644.1512582979.git.joabreu@synopsys.com>
 <d39690b8-ca6d-c7b4-3ddc-ba049d830b0f@cisco.com>
 <63dac51b-a4da-57ae-6963-7322cef23435@synopsys.com>
From: Hans Verkuil <hansverk@cisco.com>
Message-ID: <d6ea2147-8218-34da-c7a3-229e9a87f02d@cisco.com>
Date: Thu, 7 Dec 2017 14:22:34 +0100
MIME-Version: 1.0
In-Reply-To: <63dac51b-a4da-57ae-6963-7322cef23435@synopsys.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/07/17 14:00, Jose Abreu wrote:
> Hi Hans,
> 
> On 07-12-2017 12:33, Hans Verkuil wrote:
>> Hi Jose,
>>
>> Some (small) comments below:
> 
> Thanks for the review!
> 
>>
>> On 12/07/17 10:47, Jose Abreu wrote:
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
>>> ---
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
>>>  drivers/media/platform/dwc/dw-hdmi-rx.c | 1834 +++++++++++++++++++++++++++++++
>>>  drivers/media/platform/dwc/dw-hdmi-rx.h |  441 ++++++++
>>>  include/media/dwc/dw-hdmi-rx-pdata.h    |   70 ++
>>>  5 files changed, 2361 insertions(+)
>>>  create mode 100644 drivers/media/platform/dwc/dw-hdmi-rx.c
>>>  create mode 100644 drivers/media/platform/dwc/dw-hdmi-rx.h
>>>  create mode 100644 include/media/dwc/dw-hdmi-rx-pdata.h
>>>
>> <snip>
>>
>>> +static void dw_hdmi_cec_tx_raw_status(struct dw_hdmi_dev *dw_dev, u32 stat)
>>> +{
>>> +	if (hdmi_readl(dw_dev, HDMI_CEC_CTRL) & HDMI_CEC_CTRL_SEND_MASK) {
>>> +		dev_dbg(dw_dev->dev, "%s: tx is busy\n", __func__);
>>> +		return;
>>> +	}
>>> +
>>> +	if (stat & HDMI_AUD_CEC_ISTS_ARBLST) {
>>> +		cec_transmit_attempt_done(dw_dev->cec_adap,
>>> +				CEC_TX_STATUS_ARB_LOST);
>>> +		return;
>>> +	}
>>> +
>>> +	if (stat & HDMI_AUD_CEC_ISTS_NACK) {
>>> +		cec_transmit_attempt_done(dw_dev->cec_adap, CEC_TX_STATUS_NACK);
>>> +		return;
>>> +	}
>>> +
>>> +	if (stat & HDMI_AUD_CEC_ISTS_ERROR_INIT) {
>>> +		dev_dbg(dw_dev->dev, "%s: got initiator error\n", __func__);
>>> +		cec_transmit_attempt_done(dw_dev->cec_adap, CEC_TX_STATUS_ERROR);
>> There is no separate 'low drive' interrupt? Do you know what happens if a low drive
>> is received during a transmit?
> 
> I think it launches this interrupt, i.e. Initiator Error.

That would make sense. Can you replace STATUS_ERROR with LOW_DRIVE?

> 
>>
>> FYI: I've been working on error injection support for my cec-gpio driver, allowing
>> me to test all these nasty little corner cases. And that includes Arbitration Lost.
>> It's available here:
>>
>> https://urldefense.proofpoint.com/v2/url?u=https-3A__git.linuxtv.org_hverkuil_media-5Ftree.git_log_-3Fh-3Dcec-2Derror-2Dinj&d=DwIDaQ&c=DPL6_X_6JkXFx7AXWqB0tg&r=WHDsc6kcWAl4i96Vm5hJ_19IJiuxx_p_Rzo2g-uHDKw&m=lM9aIhXqx9F8VZg9CADcx_qJbK_B2NTyHn8ZNIEpAEo&s=x0PASA3DhAHKXPrpj2G31D5xOFu0ERI3ewWb-yyTLMg&e=
>>
>> It works like a charm with my Rpi3.
> 
> Nice! But for this I would need to have access to the physical
> pin for cec, right? I don't have that ...

I've set up my Rpi3 like described in the "Making a CEC debugger" section
here: https://hverkuil.home.xs4all.nl/cec-status.txt

For around $80 you have a really nice CEC debugger. It doesn't have to be a
Raspberry Pi, any SBC which can give you a pull-up GPIO pin works. Just hook
it up in the dts.

My plan is to eventually have scripts that can test all these weird conditions
automatically. Especially hard-to-reproduce corner cases like low-drive conditions,
lost arbitration, spurious pulses, pulses that are too long or too short, or
messages longer than 16 bytes.

> 
>>
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
>>> +	bt->interlaced = hdmi_readl(dw_dev, HDMI_MD_STS) & HDMI_MD_STS_ILACE;
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
>>> +	msleep(50);
>>> +	bt->vsync = hdmi_readl(dw_dev, HDMI_MD_VOL);
>>> +
>>> +	hdmi_mask_writel(dw_dev, 0x0, HDMI_MD_VCTRL,
>>> +			HDMI_MD_VCTRL_V_OFFS_LIN_MODE_OFFSET,
>>> +			HDMI_MD_VCTRL_V_OFFS_LIN_MODE_MASK);
>>> +	msleep(50);
>>> +	bt->vbackporch = hdmi_readl(dw_dev, HDMI_MD_VOL);
>>> +	bt->vfrontporch = vtot - bt->height - bt->vsync - bt->vbackporch;
>> For interlaced formats the bt->il_* fields should also be filled in.
> 
> See [1].
> 
>>
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
>> You can simplify this. We have this function in v4l2-dv-timings.c:
>> v4l2_find_dv_timings_cea861_vic(). If you read a CEA861 vic code,
>> then you can call it to find the corresponding timings and just return
>> that.
>>
>> I thought I made a v4l2_find_dv_timings_hdmi_vic as well, but apparently
>> I didn't. It's trivial to add it, though.
> 
> Ok, but how will then we handle 59.94 vs 60Hz video modes?
> Because the vic remains the same in these modes.

Ah, yes. Ignore this for now, once this driver is merged we need to take
another look at this. We discussed 59.94 vs 60 in the past, and we should
revisit that. But let's get this in first.

> 
>>
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static int dw_hdmi_enum_mbus_code(struct v4l2_subdev *sd,
>>> +		struct v4l2_subdev_pad_config *cfg,
>>> +		struct v4l2_subdev_mbus_code_enum *code)
>>> +{
>>> +	struct dw_hdmi_dev *dw_dev = to_dw_dev(sd);
>>> +
>>> +	dev_dbg(dw_dev->dev, "%s\n", __func__);
>>> +	if (code->index != 0)
>>> +		return -EINVAL;
>>> +
>>> +	code->code = dw_dev->mbus_code;
>>> +	return 0;
>>> +}
>>> +
>>> +static int dw_hdmi_fill_format(struct dw_hdmi_dev *dw_dev,
>>> +		struct v4l2_mbus_framefmt *format)
>>> +{
>>> +	memset(format, 0, sizeof(*format));
>>> +
>>> +	format->width = dw_dev->timings.bt.width;
>>> +	format->height = dw_dev->timings.bt.height;
>>> +	format->colorspace = V4L2_COLORSPACE_SRGB;
>>> +	format->code = dw_dev->mbus_code;
>>> +	if (dw_dev->timings.bt.interlaced)
>>> +		format->field = V4L2_FIELD_ALTERNATE;
>> Were interlaced formats tested? (Apologies if I have asked this before)
>>
>> Interlaced is tricky and my recommendation is to only add support for it
>> to a driver if you have been able to test it.
>>
>> I see that dw_hdmi_timings_cap only supports progressive, so I conclude
>> that this hasn't been tested. It's better to just fix field to NONE in
>> that case.
> 
> [1] Ok, but then I will still need to fill bt->il_* fields ?

If you have that information, then you should do that, yes. It's still
a good idea to return precise information here.

> 
>>> +
>>> +static int dw_hdmi_registered(struct v4l2_subdev *sd)
>>> +{
>>> +	struct dw_hdmi_dev *dw_dev = to_dw_dev(sd);
>>> +	int ret;
>>> +
>>> +	ret = cec_register_adapter(dw_dev->cec_adap, dw_dev->dev);
>>> +	if (ret) {
>>> +		dev_err(dw_dev->dev, "failed to register CEC adapter\n");
>>> +		cec_delete_adapter(dw_dev->cec_adap);
>>> +		return ret;
>>> +	}
>>> +
>>> +	cec_register_cec_notifier(dw_dev->cec_adap, dw_dev->cec_notifier);
>>> +	dw_dev->registered = true;
>>> +
>>> +	return 0;
>>> +	/*return v4l2_async_subdev_notifier_register(&dw_dev->sd,
>>> +			&dw_dev->v4l2_notifier);*/
>> Comment can be dropped, I guess.
> 
> Yeah, leftovers from the previous version...
> 
>>
>>> +
>>> +static int dw_hdmi_rx_probe(struct platform_device *pdev)
>>> +{
>>> +	const struct v4l2_dv_timings timings_def = HDMI_DEFAULT_TIMING;
>>> +	struct dw_hdmi_rx_pdata *pdata = pdev->dev.platform_data;
>>> +	struct device *dev = &pdev->dev;
>>> +	struct v4l2_ctrl_handler *hdl;
>>> +	struct dw_hdmi_dev *dw_dev;
>>> +	struct v4l2_subdev *sd;
>>> +	struct resource *res;
>>> +	int ret, irq;
>>> +
>>> +	dev_dbg(dev, "%s\n", __func__);
>>> +
>>> +	dw_dev = devm_kzalloc(dev, sizeof(*dw_dev), GFP_KERNEL);
>>> +	if (!dw_dev)
>>> +		return -ENOMEM;
>>> +
>>> +	if (!pdata) {
>>> +		dev_err(dev, "missing platform data\n");
>>> +		return -EINVAL;
>>> +	}
>>> +
>>> +	dw_dev->dev = dev;
>>> +	dw_dev->config = pdata;
>>> +	dw_dev->state = HDMI_STATE_NO_INIT;
>>> +	dw_dev->of_node = dev->of_node;
>>> +	spin_lock_init(&dw_dev->lock);
>>> +
>>> +	ret = dw_hdmi_parse_dt(dw_dev);
>>> +	if (ret)
>>> +		return ret;
>>> +
>>> +	/* Deferred work */
>>> +	dw_dev->wq = create_singlethread_workqueue(DW_HDMI_RX_DRVNAME);
>>> +	if (!dw_dev->wq) {
>>> +		dev_err(dev, "failed to create workqueue\n");
>>> +		return -ENOMEM;
>>> +	}
>>> +
>>> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>>> +	dw_dev->regs = devm_ioremap_resource(dev, res);
>>> +	if (IS_ERR(dw_dev->regs)) {
>>> +		dev_err(dev, "failed to remap resource\n");
>>> +		ret = PTR_ERR(dw_dev->regs);
>>> +		goto err_wq;
>>> +	}
>>> +
>>> +	/* Disable HPD as soon as posssible */
>>> +	dw_hdmi_disable_hpd(dw_dev);
>>> +	/* Prevent HDCP from tampering video */
>>> +	dw_hdmi_config_hdcp(dw_dev);
>>> +
>>> +	irq = platform_get_irq(pdev, 0);
>>> +	if (irq < 0) {
>>> +		ret = irq;
>>> +		goto err_wq;
>>> +	}
>>> +
>>> +	ret = devm_request_threaded_irq(dev, irq, NULL, dw_hdmi_irq_handler,
>>> +			IRQF_ONESHOT, DW_HDMI_RX_DRVNAME, dw_dev);
>>> +	if (ret)
>>> +		goto err_wq;
>>> +
>>> +	/* V4L2 initialization */
>>> +	sd = &dw_dev->sd;
>>> +	v4l2_subdev_init(sd, &dw_hdmi_sd_ops);
>>> +	strlcpy(sd->name, dev_name(dev), sizeof(sd->name));
>>> +	sd->dev = dev;
>>> +	sd->internal_ops = &dw_hdmi_internal_ops;
>>> +	sd->flags |= V4L2_SUBDEV_FL_HAS_EVENTS | V4L2_SUBDEV_FL_HAS_DEVNODE;
>>> +
>>> +	/* Control handlers */
>>> +	hdl = &dw_dev->hdl;
>>> +	v4l2_ctrl_handler_init(hdl, 1);
>>> +	dw_dev->detect_tx_5v_ctrl = v4l2_ctrl_new_std(hdl, NULL,
>>> +			V4L2_CID_DV_RX_POWER_PRESENT, 0, BIT(4) - 1, 0, 0);
>>> +
>>> +	sd->ctrl_handler = hdl;
>>> +	if (hdl->error) {
>>> +		ret = hdl->error;
>>> +		goto err_hdl;
>>> +	}
>>> +
>>> +	/* Wait for ctrl handler register before requesting 5v interrupt */
>>> +	irq = platform_get_irq(pdev, 1);
>>> +	if (irq < 0) {
>>> +		ret = irq;
>>> +		goto err_hdl;
>>> +	}
>>> +
>>> +	ret = devm_request_threaded_irq(dev, irq, dw_hdmi_5v_hard_irq_handler,
>>> +			dw_hdmi_5v_irq_handler, IRQF_ONESHOT,
>>> +			DW_HDMI_RX_DRVNAME "-5v-handler", dw_dev);
>>> +	if (ret)
>>> +		goto err_hdl;
>>> +
>>> +	/* Notifier for subdev binding */
>>> +	ret = dw_hdmi_v4l2_init_notifier(dw_dev);
>>> +	if (ret) {
>>> +		dev_err(dev, "failed to init v4l2 notifier\n");
>>> +		goto err_hdl;
>>> +	}
>>> +
>>> +	/* PHY loading */
>>> +	ret = dw_hdmi_phy_init(dw_dev);
>>> +	if (ret)
>>> +		goto err_hdl;
>>> +
>>> +	/* CEC */
>>> +#if IS_ENABLED(CONFIG_VIDEO_DWC_HDMI_RX_CEC)
>>> +	dw_dev->cec_adap = cec_allocate_adapter(&dw_hdmi_cec_adap_ops,
>>> +			dw_dev, dev_name(dev), CEC_CAP_TRANSMIT |
>>> +			CEC_CAP_LOG_ADDRS | CEC_CAP_RC | CEC_CAP_PASSTHROUGH,
>> Use CEC_CAP_DEFAULTS instead of specifying these caps separately.
> 
> Ok.
> 
> Thanks and Best Regards,
> Jose Miguel Abreu

Regards,

	Hans
