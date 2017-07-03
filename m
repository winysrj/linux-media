Return-path: <linux-media-owner@vger.kernel.org>
Received: from us01smtprelay-2.synopsys.com ([198.182.47.9]:48893 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753317AbdGCJyS (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Jul 2017 05:54:18 -0400
Subject: Re: [PATCH v5 2/4] [media] platform: Add Synopsys Designware HDMI RX
 Controller Driver
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <cover.1498732993.git.joabreu@synopsys.com>
 <52933416f17b8a3408ab94784fa8db56453ff196.1498732993.git.joabreu@synopsys.com>
 <30787ca1-f488-ef29-8997-0a74c70d552f@xs4all.nl>
CC: Carlos Palminha <CARLOS.PALMINHA@synopsys.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "Sylwester Nawrocki" <snawrocki@kernel.org>
From: Jose Abreu <Jose.Abreu@synopsys.com>
Message-ID: <57902dce-e665-8027-1d88-7c447753a5b2@synopsys.com>
Date: Mon, 3 Jul 2017 10:53:57 +0100
MIME-Version: 1.0
In-Reply-To: <30787ca1-f488-ef29-8997-0a74c70d552f@xs4all.nl>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,


On 03-07-2017 10:27, Hans Verkuil wrote:
> On 06/29/2017 12:46 PM, Jose Abreu wrote:
>> This is an initial submission for the Synopsys Designware HDMI RX
>> Controller Driver. This driver interacts with a phy driver so
>> that
>> a communication between them is created and a video pipeline is
>> configured.
>>
>> The controller + phy pipeline can then be integrated into a fully
>> featured system that can be able to receive video up to 4k@60Hz
>> with deep color 48bit RGB, depending on the platform. Although,
>> this initial version does not yet handle deep color modes.
>>
>> This driver was implemented as a standard V4L2 subdevice and its
>> main features are:
>>     - Internal state machine that reconfigures phy until the
>>     video is not stable
>>     - JTAG communication with phy
>>     - Inter-module communication with phy driver
>>     - Debug write/read ioctls
>>
>> Some notes:
>>     - RX sense controller (cable connection/disconnection) must
>>     be handled by the platform wrapper as this is not integrated
>>     into the controller RTL
>>     - The same goes for EDID ROM's
>>     - ZCAL calibration is needed only in FPGA platforms, in ASIC
>>     this is not needed
>>     - The state machine is not an ideal solution as it creates a
>>     kthread but it is needed because some sources might not be
>>     very stable at sending the video (i.e. we must react
>>     accordingly).
>>
>> Signed-off-by: Jose Abreu <joabreu@synopsys.com>
>> Cc: Carlos Palminha <palminha@synopsys.com>
>> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
>> Cc: Hans Verkuil <hans.verkuil@cisco.com>
>> Cc: Sylwester Nawrocki <snawrocki@kernel.org>
>>
>> Changes from v4:
>>     - Add flag V4L2_SUBDEV_FL_HAS_DEVNODE (Sylwester)
>>     - Remove some comments and change some messages to dev_dbg
>> (Sylwester)
>>     - Use v4l2_async_subnotifier_register() (Sylwester)
>> Changes from v3:
>>     - Use v4l2 async API (Sylwester)
>>     - Do not block waiting for phy
>>     - Do not use busy waiting delays (Sylwester)
>>     - Simplify dw_hdmi_power_on (Sylwester)
>>     - Use clock API (Sylwester)
>>     - Use compatible string (Sylwester)
>>     - Minor fixes (Sylwester)
>> Changes from v2:
>>     - Address review comments from Hans regarding CEC
>>     - Use CEC notifier
>>     - Enable SCDC
>> Changes from v1:
>>     - Add support for CEC
>>     - Correct typo errors
>>     - Correctly detect interlaced video modes
>>     - Correct VIC parsing
>> Changes from RFC:
>>     - Add support for HDCP 1.4
>>     - Fixup HDMI_VIC not being parsed (Hans)
>>     - Send source change signal when powering off (Hans)
>>     - Add a "wait stable delay"
>>     - Detect interlaced video modes (Hans)
>>     - Restrain g/s_register from reading/writing to HDCP regs
>> (Hans)
>> ---
>>   drivers/media/platform/dwc/Kconfig      |   15 +
>>   drivers/media/platform/dwc/Makefile     |    1 +
>>   drivers/media/platform/dwc/dw-hdmi-rx.c | 1824
>> +++++++++++++++++++++++++++++++
>>   drivers/media/platform/dwc/dw-hdmi-rx.h |  441 ++++++++
>>   include/media/dwc/dw-hdmi-rx-pdata.h    |   97 ++
>>   5 files changed, 2378 insertions(+)
>>   create mode 100644 drivers/media/platform/dwc/dw-hdmi-rx.c
>>   create mode 100644 drivers/media/platform/dwc/dw-hdmi-rx.h
>>   create mode 100644 include/media/dwc/dw-hdmi-rx-pdata.h
>>
>> diff --git a/drivers/media/platform/dwc/Kconfig
>> b/drivers/media/platform/dwc/Kconfig
>> index 361d38d..3ddccde 100644
>> --- a/drivers/media/platform/dwc/Kconfig
>> +++ b/drivers/media/platform/dwc/Kconfig
>> @@ -6,3 +6,18 @@ config VIDEO_DWC_HDMI_PHY_E405
>>           To compile this driver as a module, choose M here.
>> The module
>>         will be called dw-hdmi-phy-e405.
>> +
>> +config VIDEO_DWC_HDMI_RX
>> +    tristate "Synopsys Designware HDMI Receiver driver"
>> +    depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
>> +    help
>> +      Support for Synopsys Designware HDMI RX controller.
>> +
>> +      To compile this driver as a module, choose M here. The
>> module
>> +      will be called dw-hdmi-rx.
>> +
>> +config VIDEO_DWC_HDMI_RX_CEC
>> +    bool
>> +    depends on VIDEO_DWC_HDMI_RX
>> +    select CEC_CORE
>> +    select CEC_NOTIFIER
>> diff --git a/drivers/media/platform/dwc/Makefile
>> b/drivers/media/platform/dwc/Makefile
>> index fc3b62c..cd04ca9 100644
>> --- a/drivers/media/platform/dwc/Makefile
>> +++ b/drivers/media/platform/dwc/Makefile
>> @@ -1 +1,2 @@
>>   obj-$(CONFIG_VIDEO_DWC_HDMI_PHY_E405) += dw-hdmi-phy-e405.o
>> +obj-$(CONFIG_VIDEO_DWC_HDMI_RX) += dw-hdmi-rx.o
>> diff --git a/drivers/media/platform/dwc/dw-hdmi-rx.c
>> b/drivers/media/platform/dwc/dw-hdmi-rx.c
>> new file mode 100644
>> index 0000000..4a7b8fc
>> --- /dev/null
>> +++ b/drivers/media/platform/dwc/dw-hdmi-rx.c
>
> <snip>
>
>> +static void dw_hdmi_cec_tx_raw_status(struct dw_hdmi_dev
>> *dw_dev, u32 stat)
>> +{
>> +    if (hdmi_readl(dw_dev, HDMI_CEC_CTRL) &
>> HDMI_CEC_CTRL_SEND_MASK) {
>> +        dev_dbg(dw_dev->dev, "%s: tx is busy\n", __func__);
>> +        return;
>> +    }
>> +
>> +    if (stat & HDMI_AUD_CEC_ISTS_ARBLST) {
>> +        dev_dbg(dw_dev->dev, "%s: arbitration lost\n",
>> __func__);
>> +        cec_transmit_done(dw_dev->cec_adap,
>> CEC_TX_STATUS_ARB_LOST,
>> +                1, 0, 0, 0);
>> +        return;
>> +    }
>> +
>> +    if (stat & HDMI_AUD_CEC_ISTS_DONE) {
>> +        dev_dbg(dw_dev->dev, "%s: transmission done\n",
>> __func__);
>> +        cec_transmit_done(dw_dev->cec_adap, CEC_TX_STATUS_OK,
>> 0, 0, 0, 0);
>> +        return;
>> +    }
>> +
>> +    if (stat & HDMI_AUD_CEC_ISTS_NACK) {
>> +        dev_dbg(dw_dev->dev, "%s: got NACK\n", __func__);
>> +        cec_transmit_done(dw_dev->cec_adap, CEC_TX_STATUS_NACK,
>> +                0, 1, 0, 0);
>> +        return;
>> +    }
>> +
>> +    if (stat & HDMI_AUD_CEC_ISTS_ERROR_INIT) {
>> +        dev_dbg(dw_dev->dev, "%s: got initiator error\n",
>> __func__);
>> +        cec_transmit_done(dw_dev->cec_adap, CEC_TX_STATUS_ERROR,
>> +                0, 0, 0, 1);
>> +        return;
>> +    }
>
> A few remarks/questions about this:
>
> 1) You can drop the dev_dbg for status ARB_LOST, NACK and OK
> since the cec
> core can log that as well.

Ok.

>
> 2) Shouldn't the ISTS_DONE test be done either at the beginning
> or at the
> end? If that bit is set, then can any of the other
> ARBLST/NACK/ERROR_INIT bits
> be set as well?

Never happened to me. But I will move it to the end, just to be
sure. BTW, I guess it can happen if the IRQ status is not cleared
when the IRQ fires.

>
> 3) Use the new cec_transmit_attempt_done() function instead of
> cec_transmit_done.
> It simplifies the code a little bit.

Ok.

>
>
>> +}
>> +
>> +static void dw_hdmi_cec_received_msg(struct dw_hdmi_dev *dw_dev)
>> +{
>> +    struct cec_msg msg;
>> +    u8 i;
>> +
>> +    msg.len = hdmi_readl(dw_dev, HDMI_CEC_RX_CNT);
>> +    if (!msg.len || msg.len > HDMI_CEC_RX_DATA_MAX)
>> +        return; /* it's an invalid/non-existent message */
>> +
>> +    for (i = 0; i < msg.len; i++)
>> +        msg.msg[i] = hdmi_readl(dw_dev, HDMI_CEC_RX_DATA(i));
>> +
>> +    hdmi_writel(dw_dev, 0x0, HDMI_CEC_LOCK);
>> +    cec_received_msg(dw_dev->cec_adap, &msg);
>> +}
>> +
>> +static int dw_hdmi_cec_adap_enable(struct cec_adapter *adap,
>> bool enable)
>> +{
>> +    struct dw_hdmi_dev *dw_dev = cec_get_drvdata(adap);
>> +
>> +    if (!dw_dev->cec_enabled_adap && enable) {
>> +        hdmi_writel(dw_dev, 0x0, HDMI_CEC_ADDR_L);
>> +        hdmi_writel(dw_dev, 0x0, HDMI_CEC_ADDR_H);
>> +        hdmi_writel(dw_dev, 0x0, HDMI_CEC_LOCK);
>> +        dw_hdmi_cec_clear_ints(dw_dev);
>> +        dw_hdmi_cec_enable_ints(dw_dev);
>> +    } else if (dw_dev->cec_enabled_adap && !enable) {
>> +        hdmi_writel(dw_dev, 0x0, HDMI_CEC_ADDR_L);
>> +        hdmi_writel(dw_dev, 0x0, HDMI_CEC_ADDR_H);
>> +        dw_hdmi_cec_disable_ints(dw_dev);
>> +        dw_hdmi_cec_clear_ints(dw_dev);
>> +    }
>> +
>> +    dw_dev->cec_enabled_adap = enable;
>
> No need for this: this callback will only be called when the
> enable state
> really changes.

Ok.

<snip>

>> +static int dw_hdmi_log_status(struct v4l2_subdev *sd)
>> +{
>> +    struct dw_hdmi_dev *dw_dev = to_dw_dev(sd);
>> +    struct v4l2_dv_timings timings;
>> +
>> +    v4l2_info(sd, "--- Chip configuration ---\n");
>> +    v4l2_info(sd, "cfg_clk=%dMHz\n", dw_dev->cfg_clk);
>> +    v4l2_info(sd, "phy_drv=%s, phy_jtag_addr=0x%x\n",
>> dw_dev->phy_drv,
>> +            dw_dev->phy_jtag_addr);
>> +
>> +    v4l2_info(sd, "--- Chip status ---\n");
>> +    v4l2_info(sd, "selected_input=%d: signal=%d\n",
>> dw_dev->selected_input,
>> +            has_signal(dw_dev, dw_dev->selected_input));
>> +    v4l2_info(sd, "configured_input=%d: signal=%d\n",
>> +            dw_dev->configured_input,
>> +            has_signal(dw_dev, dw_dev->configured_input));
>> +
>> +    v4l2_info(sd, "--- CEC status ---\n");
>> +    v4l2_info(sd, "enabled=%s\n", dw_dev->cec_enabled_adap ?
>> "yes" : "no");
>> +
>> +    v4l2_info(sd, "--- Video status ---\n");
>> +    v4l2_info(sd, "type=%s, color_depth=%dbits",
>> +            hdmi_readl(dw_dev, HDMI_PDEC_STS) &
>> +            HDMI_PDEC_STS_DVIDET ? "dvi" : "hdmi",
>> +            dw_hdmi_get_colordepth(dw_dev));
>> +
>> +    v4l2_info(sd, "--- Video timings ---\n");
>> +    if (dw_hdmi_query_dv_timings(sd, &timings))
>> +        v4l2_info(sd, "No video detected\n");
>> +    else
>> +        v4l2_print_dv_timings(sd->name, "Detected format: ",
>> +                &timings, true);
>> +    v4l2_print_dv_timings(sd->name, "Configured format: ",
>> +            &dw_dev->timings, true);
>
> Call v4l2_ctrl_subdev_log_status at the end.

Ok.

>
>> +    return 0;
>> +}
>> +
>> +#ifdef CONFIG_VIDEO_ADV_DEBUG
>> +static void dw_hdmi_invalid_register(struct dw_hdmi_dev
>> *dw_dev, u64 reg)
>> +{
>> +    dev_err(dw_dev->dev, "register 0x%llx not supported\n",
>> reg);
>> +    dev_err(dw_dev->dev, "0x0000-0x7fff: Main controller
>> map\n");
>> +    dev_err(dw_dev->dev, "0x8000-0x80ff: PHY map\n");
>> +}
>> +
>> +static bool dw_hdmi_is_reserved_register(struct dw_hdmi_dev
>> *dw_dev, u32 reg)
>> +{
>> +    if (reg >= HDMI_HDCP_CTRL && reg <= HDMI_HDCP_STS)
>> +        return true;
>> +    if (reg == HDMI_HDCP22_CONTROL)
>> +        return true;
>> +    if (reg == HDMI_HDCP22_STATUS)
>> +        return true;
>> +    return false;
>> +}
>> +
>> +static int dw_hdmi_g_register(struct v4l2_subdev *sd,
>> +        struct v4l2_dbg_register *reg)
>> +{
>> +    struct dw_hdmi_dev *dw_dev = to_dw_dev(sd);
>> +
>> +    switch (reg->reg >> 15) {
>> +    case 0: /* Controller core read */
>> +        if (dw_hdmi_is_reserved_register(dw_dev, reg->reg &
>> 0x7fff))
>> +            return -EINVAL;
>
> Is this necessary? Obviously you shouldn't be able to set it,
> but I think it
> should be fine to read it. Up to you, though.

Actually some of the HDCP 1.4 registers are write only and if
someone tries to read the controller will not respond and will
block the bus. This is no problem for x86, but for some archs it
can block the system entirely.

>
>> +
>> +        reg->size = 4;
>> +        reg->val = hdmi_readl(dw_dev, reg->reg & 0x7fff);
>> +        return 0;
>> +    case 1: /* PHY read */
>> +        if ((reg->reg & ~0xff) != BIT(15))
>> +            break;
>> +
>> +        reg->size = 2;
>> +        reg->val = dw_hdmi_phy_read(dw_dev, reg->reg & 0xff);
>> +        return 0;
>> +    default:
>> +        break;
>> +    }
>> +
>> +    dw_hdmi_invalid_register(dw_dev, reg->reg);
>> +    return 0;
>> +}
>> +
>> +static int dw_hdmi_s_register(struct v4l2_subdev *sd,
>> +        const struct v4l2_dbg_register *reg)
>> +{
>> +    struct dw_hdmi_dev *dw_dev = to_dw_dev(sd);
>> +
>> +    switch (reg->reg >> 15) {
>> +    case 0: /* Controller core write */
>> +        if (dw_hdmi_is_reserved_register(dw_dev, reg->reg &
>> 0x7fff))
>> +            return -EINVAL;
>> +
>> +        hdmi_writel(dw_dev, reg->val & GENMASK(31,0),
>> reg->reg & 0x7fff);
>> +        return 0;
>> +    case 1: /* PHY write */
>> +        if ((reg->reg & ~0xff) != BIT(15))
>> +            break;
>> +        dw_hdmi_phy_write(dw_dev, reg->val & 0xffff, reg->reg
>> & 0xff);
>> +        return 0;
>> +    default:
>> +        break;
>> +    }
>> +
>> +    dw_hdmi_invalid_register(dw_dev, reg->reg);
>> +    return 0;
>> +}
>> +#endif
>> +
>> +static int dw_hdmi_subscribe_event(struct v4l2_subdev *sd,
>> struct v4l2_fh *fh,
>> +        struct v4l2_event_subscription *sub)
>> +{
>> +    switch (sub->type) {
>> +    case V4L2_EVENT_SOURCE_CHANGE:
>> +        return v4l2_src_change_event_subdev_subscribe(sd, fh,
>> sub);
>> +    default:
>> +        return -EINVAL;
>
> Fall back to v4l2_ctrl_subdev_subscribe_event. See below for
> more info.
>
>> +    }
>> +}
>> +
>> +static int dw_hdmi_registered(struct v4l2_subdev *sd)
>> +{
>> +    struct dw_hdmi_dev *dw_dev = to_dw_dev(sd);
>> +    int ret;
>> +
>> +    ret = cec_register_adapter(dw_dev->cec_adap, dw_dev->dev);
>> +    if (ret) {
>> +        dev_err(dw_dev->dev, "failed to register CEC
>> adapter\n");
>> +        cec_delete_adapter(dw_dev->cec_adap);
>> +        return ret;
>> +    }
>> +
>> +    cec_register_cec_notifier(dw_dev->cec_adap,
>> dw_dev->cec_notifier);
>> +    dw_dev->registered = true;
>> +
>> +    return v4l2_async_subnotifier_register(&dw_dev->sd,
>> +            &dw_dev->v4l2_notifier);
>> +}
>> +
>> +static void dw_hdmi_unregistered(struct v4l2_subdev *sd)
>> +{
>> +    struct dw_hdmi_dev *dw_dev = to_dw_dev(sd);
>> +
>> +    cec_unregister_adapter(dw_dev->cec_adap);
>> +    cec_notifier_put(dw_dev->cec_notifier);
>> +    v4l2_async_subnotifier_unregister(&dw_dev->v4l2_notifier);
>> +}
>> +
>> +static const struct v4l2_subdev_core_ops dw_hdmi_sd_core_ops = {
>> +    .log_status = dw_hdmi_log_status,
>> +#ifdef CONFIG_VIDEO_ADV_DEBUG
>> +    .g_register = dw_hdmi_g_register,
>> +    .s_register = dw_hdmi_s_register,
>> +#endif
>> +    .subscribe_event = dw_hdmi_subscribe_event,
>> +};
>> +
>> +static const struct v4l2_subdev_video_ops
>> dw_hdmi_sd_video_ops = {
>> +    .s_routing = dw_hdmi_s_routing,
>> +    .g_input_status = dw_hdmi_g_input_status,
>> +    .g_parm = dw_hdmi_g_parm,
>> +    .g_dv_timings = dw_hdmi_g_dv_timings,
>> +    .query_dv_timings = dw_hdmi_query_dv_timings,
>
> No s_dv_timings???

Hmm, yeah, I didn't implement it because the callchain and the
player I use just use {get/set}_fmt. s_dv_timings can just
populate the fields and replace them with the detected dv_timings
? Just like set_fmt does? Because the controller has no scaler.

>
>> +};
>> +
>> +static const struct v4l2_subdev_pad_ops dw_hdmi_sd_pad_ops = {
>> +    .enum_mbus_code = dw_hdmi_enum_mbus_code,
>> +    .get_fmt = dw_hdmi_get_fmt,
>> +    .set_fmt = dw_hdmi_set_fmt,
>> +    .dv_timings_cap = dw_hdmi_dv_timings_cap,
>> +    .enum_dv_timings = dw_hdmi_enum_dv_timings,
>> +};
>> +
>> +static const struct v4l2_subdev_ops dw_hdmi_sd_ops = {
>> +    .core = &dw_hdmi_sd_core_ops,
>> +    .video = &dw_hdmi_sd_video_ops,
>> +    .pad = &dw_hdmi_sd_pad_ops,
>> +};
>> +
>> +static const struct v4l2_subdev_internal_ops
>> dw_hdmi_internal_ops = {
>> +    .registered = dw_hdmi_registered,
>> +    .unregistered = dw_hdmi_unregistered,
>> +};
>> +
>> +static int dw_hdmi_v4l2_notify_bound(struct
>> v4l2_async_notifier *notifier,
>> +        struct v4l2_subdev *subdev, struct v4l2_async_subdev
>> *asd)
>> +{
>> +    struct dw_hdmi_dev *dw_dev = notifier_to_dw_dev(notifier);
>> +
>> +    if (dw_dev->phy_async_sd.match.fwnode.fwnode ==
>> +            of_fwnode_handle(subdev->dev->of_node)) {
>> +        dev_dbg(dw_dev->dev, "found new subdev '%s'\n",
>> subdev->name);
>> +        dw_dev->phy_sd = subdev;
>> +        return 0;
>> +    }
>> +
>> +    return -EINVAL;
>> +}
>> +
>> +static void dw_hdmi_v4l2_notify_unbind(struct
>> v4l2_async_notifier *notifier,
>> +        struct v4l2_subdev *subdev, struct v4l2_async_subdev
>> *asd)
>> +{
>> +    struct dw_hdmi_dev *dw_dev = notifier_to_dw_dev(notifier);
>> +
>> +    if (dw_dev->phy_sd == subdev) {
>> +        dev_dbg(dw_dev->dev, "unbinding '%s'\n", subdev->name);
>> +        dw_dev->phy_sd = NULL;
>> +    }
>> +}
>> +
>> +static int dw_hdmi_v4l2_init_notifier(struct dw_hdmi_dev
>> *dw_dev)
>> +{
>> +    struct v4l2_async_subdev **subdevs = NULL;
>> +    struct device_node *child = NULL;
>> +
>> +    subdevs = devm_kzalloc(dw_dev->dev, sizeof(*subdevs),
>> GFP_KERNEL);
>> +    if (!subdevs)
>> +        return -ENOMEM;
>> +
>> +    child = dw_hdmi_get_phy_of_node(dw_dev, NULL);
>> +    if (!child)
>> +        return -EINVAL;
>> +
>> +    dw_dev->phy_async_sd.match.fwnode.fwnode =
>> of_fwnode_handle(child);
>> +    dw_dev->phy_async_sd.match_type = V4L2_ASYNC_MATCH_FWNODE;
>> +
>> +    subdevs[0] = &dw_dev->phy_async_sd;
>> +    dw_dev->v4l2_notifier.num_subdevs = 1;
>> +    dw_dev->v4l2_notifier.subdevs = subdevs;
>> +    dw_dev->v4l2_notifier.bound = dw_hdmi_v4l2_notify_bound;
>> +    dw_dev->v4l2_notifier.unbind = dw_hdmi_v4l2_notify_unbind;
>> +
>> +    return 0;
>> +}
>> +
>> +static int dw_hdmi_parse_dt(struct dw_hdmi_dev *dw_dev)
>> +{
>> +    struct device_node *notifier, *phy_node, *np =
>> dw_dev->of_node;
>> +    u32 tmp;
>> +    int ret;
>> +
>> +    if (!np) {
>> +        dev_err(dw_dev->dev, "missing DT node\n");
>> +        return -EINVAL;
>> +    }
>> +
>> +    /* PHY properties parsing */
>> +    phy_node = dw_hdmi_get_phy_of_node(dw_dev, NULL);
>> +    of_property_read_u32(phy_node, "reg", &tmp);
>> +
>> +    dw_dev->phy_jtag_addr = tmp & 0xff;
>> +    if (!dw_dev->phy_jtag_addr) {
>> +        dev_err(dw_dev->dev, "missing phy jtag address in
>> DT\n");
>> +        return -EINVAL;
>> +    }
>> +
>> +    /* Get config clock value */
>> +    dw_dev->clk = devm_clk_get(dw_dev->dev, "cfg");
>> +    if (IS_ERR(dw_dev->clk)) {
>> +        dev_err(dw_dev->dev, "failed to get cfg clock\n");
>> +        return PTR_ERR(dw_dev->clk);
>> +    }
>> +
>> +    ret = clk_prepare_enable(dw_dev->clk);
>> +    if (ret) {
>> +        dev_err(dw_dev->dev, "failed to enable cfg clock\n");
>> +        return ret;
>> +    }
>> +
>> +    dw_dev->cfg_clk = clk_get_rate(dw_dev->clk) / 1000000U;
>> +    if (!dw_dev->cfg_clk) {
>> +        dev_err(dw_dev->dev, "invalid cfg clock frequency\n");
>> +        ret = -EINVAL;
>> +        goto err_clk;
>> +    }
>> +
>> +#if IS_ENABLED(CONFIG_VIDEO_DWC_HDMI_RX_CEC)
>> +    /* Notifier device parsing */
>> +    notifier = of_parse_phandle(np, "edid-phandle", 0);
>> +    if (!notifier) {
>> +        dev_err(dw_dev->dev, "missing edid-phandle in DT\n");
>> +        ret = -EINVAL;
>> +        goto err_clk;
>> +    }
>> +
>> +    dw_dev->notifier_pdev = of_find_device_by_node(notifier);
>> +    if (!dw_dev->notifier_pdev)
>> +        return -EPROBE_DEFER;
>> +#endif
>> +
>> +    return 0;
>> +
>> +err_clk:
>> +    clk_disable_unprepare(dw_dev->clk);
>> +    return ret;
>> +}
>> +
>> +static int dw_hdmi_rx_probe(struct platform_device *pdev)
>> +{
>> +    const struct v4l2_dv_timings timings_def =
>> HDMI_DEFAULT_TIMING;
>> +    struct dw_hdmi_rx_pdata *pdata = pdev->dev.platform_data;
>> +    struct device *dev = &pdev->dev;
>> +    struct dw_hdmi_dev *dw_dev;
>> +    struct v4l2_subdev *sd;
>> +    struct resource *res;
>> +    int ret, irq;
>> +
>> +    dev_dbg(dev, "%s\n", __func__);
>> +
>> +    dw_dev = devm_kzalloc(dev, sizeof(*dw_dev), GFP_KERNEL);
>> +    if (!dw_dev)
>> +        return -ENOMEM;
>> +
>> +    if (!pdata) {
>> +        dev_err(dev, "missing platform data\n");
>> +        return -EINVAL;
>> +    }
>> +
>> +    dw_dev->dev = dev;
>> +    dw_dev->config = pdata;
>> +    dw_dev->state = HDMI_STATE_NO_INIT;
>> +    dw_dev->of_node = dev->of_node;
>> +    spin_lock_init(&dw_dev->lock);
>> +
>> +    ret = dw_hdmi_parse_dt(dw_dev);
>> +    if (ret)
>> +        return ret;
>> +
>> +    /* Deferred work */
>> +    dw_dev->wq =
>> create_singlethread_workqueue(DW_HDMI_RX_DRVNAME);
>> +    if (!dw_dev->wq) {
>> +        dev_err(dev, "failed to create workqueue\n");
>> +        return -ENOMEM;
>> +    }
>> +
>> +    res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +    dw_dev->regs = devm_ioremap_resource(dev, res);
>> +    if (IS_ERR(dw_dev->regs)) {
>> +        dev_err(dev, "failed to remap resource\n");
>> +        ret = PTR_ERR(dw_dev->regs);
>> +        goto err_wq;
>> +    }
>> +
>> +    /* Disable HPD as soon as posssible */
>> +    dw_hdmi_disable_hpd(dw_dev);
>> +
>> +    ret = dw_hdmi_config_hdcp(dw_dev);
>> +    if (ret)
>> +        goto err_wq;
>> +
>> +    irq = platform_get_irq(pdev, 0);
>> +    if (irq < 0) {
>> +        ret = irq;
>> +        goto err_wq;
>> +    }
>> +
>> +    ret = devm_request_threaded_irq(dev, irq, NULL,
>> dw_hdmi_irq_handler,
>> +            IRQF_ONESHOT, DW_HDMI_RX_DRVNAME, dw_dev);
>> +    if (ret)
>> +        goto err_wq;
>> +
>> +    irq = platform_get_irq(pdev, 1);
>> +    if (irq < 0) {
>> +        ret = irq;
>> +        goto err_wq;
>> +    }
>> +
>> +    ret = devm_request_threaded_irq(dev, irq,
>> dw_hdmi_5v_hard_irq_handler,
>> +            dw_hdmi_5v_irq_handler, IRQF_ONESHOT,
>> +            DW_HDMI_RX_DRVNAME "-5v-handler", dw_dev);
>> +    if (ret)
>> +        goto err_wq;
>> +
>> +    /* V4L2 initialization */
>> +    sd = &dw_dev->sd;
>> +    v4l2_subdev_init(sd, &dw_hdmi_sd_ops);
>> +    strlcpy(sd->name, dev_name(dev), sizeof(sd->name));
>> +    sd->dev = dev;
>> +    sd->internal_ops = &dw_hdmi_internal_ops;
>> +    sd->flags |= V4L2_SUBDEV_FL_HAS_EVENTS |
>> V4L2_SUBDEV_FL_HAS_DEVNODE;
>
> You need to add at this control: V4L2_CID_DV_RX_POWER_PRESENT.
> This is a
> read-only control that reports the 5V status. Important for
> applications to have.

Ok.

>
> I gather that this IP doesn't handle InfoFrames? If it does,
> then let me know.

Yes, it handles but I didn't implement the parsing yet (I just
parse the VIC for now).

>
>> +
>> +    /* Notifier for subdev binding */
>> +    ret = dw_hdmi_v4l2_init_notifier(dw_dev);
>> +    if (ret) {
>> +        dev_err(dev, "failed to init v4l2 notifier\n");
>> +        goto err_wq;
>> +    }
>> +
>> +    /* PHY loading */
>> +    ret = dw_hdmi_phy_init(dw_dev);
>> +    if (ret)
>> +        goto err_wq;
>> +
>> +    /* CEC */
>> +#if IS_ENABLED(CONFIG_VIDEO_DWC_HDMI_RX_CEC)
>> +    dw_dev->cec_adap =
>> cec_allocate_adapter(&dw_hdmi_cec_adap_ops,
>> +            dw_dev, dev_name(dev), CEC_CAP_TRANSMIT |
>> +            CEC_CAP_LOG_ADDRS | CEC_CAP_RC |
>> CEC_CAP_PASSTHROUGH,
>> +            HDMI_CEC_MAX_LOG_ADDRS);
>> +    ret = PTR_ERR_OR_ZERO(dw_dev->cec_adap);
>> +    if (ret) {
>> +        dev_err(dev, "failed to allocate CEC adapter\n");
>> +        goto err_phy;
>> +    }
>> +
>> +    dw_dev->cec_notifier =
>> cec_notifier_get(&dw_dev->notifier_pdev->dev);
>> +    if (!dw_dev->cec_notifier) {
>> +        dev_err(dev, "failed to allocate CEC notifier\n");
>> +        ret = -ENOMEM;
>> +        goto err_cec;
>> +    }
>> +
>> +    dev_info(dev, "CEC is enabled\n");
>> +#else
>> +    dev_info(dev, "CEC is disabled\n");
>> +#endif
>> +
>> +    ret = v4l2_async_register_subdev(sd);
>> +    if (ret) {
>> +        dev_err(dev, "failed to register subdev\n");
>> +        goto err_cec;
>> +    }
>> +
>> +    /* Fill initial format settings */
>> +    dw_dev->timings = timings_def;
>
> Unless I missed something it appears dw_dev->timings never
> changes value since this
> appears to be the only assignment. I'm fairly certain you need
> a s_dv_timings op as
> well.
>
>> +    dw_dev->mbus_code = MEDIA_BUS_FMT_BGR888_1X24;
>> +
>> +    dev_set_drvdata(dev, sd);
>> +    dw_dev->state = HDMI_STATE_POWER_OFF;
>> +    dw_hdmi_detect_tx_5v(dw_dev);
>> +    dev_dbg(dev, "driver probed\n");
>> +    return 0;
>> +
>> +err_cec:
>> +    cec_delete_adapter(dw_dev->cec_adap);
>> +err_phy:
>> +    dw_hdmi_phy_exit(dw_dev);
>> +err_wq:
>> +    destroy_workqueue(dw_dev->wq);
>> +    return ret;
>> +}
>> +
>> +static int dw_hdmi_rx_remove(struct platform_device *pdev)
>> +{
>> +    struct device *dev = &pdev->dev;
>> +    struct v4l2_subdev *sd = dev_get_drvdata(dev);
>> +    struct dw_hdmi_dev *dw_dev = to_dw_dev(sd);
>> +
>> +    dw_hdmi_disable_ints(dw_dev);
>> +    dw_hdmi_disable_hpd(dw_dev);
>> +    dw_hdmi_disable_scdc(dw_dev);
>> +    dw_hdmi_power_off(dw_dev);
>> +    dw_hdmi_phy_s_power(dw_dev, false);
>> +    flush_workqueue(dw_dev->wq);
>> +    destroy_workqueue(dw_dev->wq);
>> +    dw_hdmi_phy_exit(dw_dev);
>> +    v4l2_async_unregister_subdev(sd);
>> +    clk_disable_unprepare(dw_dev->clk);
>> +    dev_dbg(dev, "driver removed\n");
>> +    return 0;
>> +}
>> +
>> +static const struct of_device_id dw_hdmi_rx_id[] = {
>> +    { .compatible = "snps,dw-hdmi-rx" },
>> +    { },
>> +};
>> +MODULE_DEVICE_TABLE(of, dw_hdmi_rx_id);
>> +
>> +static struct platform_driver dw_hdmi_rx_driver = {
>> +    .probe = dw_hdmi_rx_probe,
>> +    .remove = dw_hdmi_rx_remove,
>> +    .driver = {
>> +        .name = DW_HDMI_RX_DRVNAME,
>> +        .of_match_table = dw_hdmi_rx_id,
>> +    }
>> +};
>> +module_platform_driver(dw_hdmi_rx_driver);
>>

<snip>

>> diff --git a/include/media/dwc/dw-hdmi-rx-pdata.h
>> b/include/media/dwc/dw-hdmi-rx-pdata.h
>> new file mode 100644
>> index 0000000..38c6d91
>> --- /dev/null
>> +++ b/include/media/dwc/dw-hdmi-rx-pdata.h
>> @@ -0,0 +1,97 @@
>> +/*
>> + * Synopsys Designware HDMI Receiver controller platform data
>> + *
>> + * This Synopsys dw-hdmi-rx software and associated
>> documentation
>> + * (hereinafter the "Software") is an unsupported proprietary
>> work of
>> + * Synopsys, Inc. unless otherwise expressly agreed to in
>> writing between
>> + * Synopsys and you. The Software IS NOT an item of Licensed
>> Software or a
>> + * Licensed Product under any End User Software License
>> Agreement or
>> + * Agreement for Licensed Products with Synopsys or any
>> supplement thereto.
>> + * Synopsys is a registered trademark of Synopsys, Inc. Other
>> names included
>> + * in the SOFTWARE may be the trademarks of their respective
>> owners.
>> + *
>> + * The contents of this file are dual-licensed; you may
>> select either version 2
>> + * of the GNU General Public License (“GPL”) or the MIT
>> license (“MIT”).
>> + *
>> + * Copyright (c) 2017 Synopsys, Inc. and/or its affiliates.
>> + *
>> + * THIS SOFTWARE IS PROVIDED "AS IS"  WITHOUT WARRANTY OF ANY
>> KIND, EXPRESS OR
>> + * IMPLIED, INCLUDING, BUT NOT LIMITED TO THE WARRANTIES OF
>> MERCHANTABILITY,
>> + * FITNESS FOR A PARTICULAR PURPOSE, AND NONINFRINGEMENT. IN
>> NO EVENT SHALL THE
>> + * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
>> DAMAGES OR
>> + * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT,
>> OR OTHERWISE
>> + * ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE
>> THE USE OR
>> + * OTHER DEALINGS IN THE SOFTWARE.
>> + */
>> +
>> +#ifndef __DW_HDMI_RX_PDATA_H__
>> +#define __DW_HDMI_RX_PDATA_H__
>> +
>> +#define DW_HDMI_RX_DRVNAME            "dw-hdmi-rx"
>> +
>> +/* Notify events */
>> +#define DW_HDMI_NOTIFY_IS_OFF        1
>> +#define DW_HDMI_NOTIFY_INPUT_CHANGED    2
>> +#define DW_HDMI_NOTIFY_AUDIO_CHANGED    3
>> +#define DW_HDMI_NOTIFY_IS_STABLE    4
>> +
>> +/* HDCP 1.4 */
>> +#define DW_HDMI_HDCP14_BKSV_SIZE    2
>> +#define DW_HDMI_HDCP14_KEYS_SIZE    (2 * 40)
>> +
>> +/**
>> + * struct dw_hdmi_hdcp14_key - HDCP 1.4 keys structure.
>> + *
>> + * @seed: Seeed value for HDCP 1.4 engine (16 bits).
>
> Typo: Seeed -> Seed
>
>> + *
>> + * @bksv: BKSV value for HDCP 1.4 engine (40 bits).
>> + *
>> + * @keys: Keys value for HDCP 1.4 engine (80 * 56 bits).
>> + *
>> + * @keys_valid: Must be set to true if the keys in this
>> structure are valid
>> + * and can be used by the HDMI receiver controller.
>> + */
>> +struct dw_hdmi_hdcp14_key {
>> +    u32 seed;
>> +    u32 bksv[DW_HDMI_HDCP14_BKSV_SIZE];
>> +    u32 keys[DW_HDMI_HDCP14_KEYS_SIZE];
>> +    bool keys_valid;
>> +};
>> +
>> +/**
>> + * struct dw_hdmi_rx_pdata - Platform Data configuration for
>> HDMI receiver.
>> + *
>> + * @hdcp14_keys: Keys for HDCP 1.4 engine. See
>> @dw_hdmi_hdcp14_key.
>
> Was this for debugging only? These are the Device Private Keys
> you're talking about?
>
> If this is indeed the case, then this doesn't belong here. You
> should never rely on
> software to set these keys. It should be fused in the hardware,
> or read from an
> encrypted eeprom or something like that. None of this
> (including the bksv) should
> be settable from the driver. You can read the bksv since that's
> public.
>
> This can't be in a kernel driver, nor can it be set or read
> through the s_register API.
>
> Instead there should be a big fat disclaimer that how you
> program these keys is up to
> the hardware designer and that it should be in accordance to
> the HDCP requirements.
>
> I would drop this completely from the pdata. My recommendation
> would be to not include
> HDCP support at all for this first version. Add it in follow-up
> patches which include
> a new V4L2 API for handling HDCP. This needs to be handled
> carefully.

Yes, in real HW these keys will not be handled this way. I'm
using a prototyping system so its easier to debug. I will remove
this entirely and drop HDCP 1.4 support for now.

Hmm, I'm seeing the configuration flow for keys written in HW and
it actually just needs a seed (for encrypted keys, for decrypted
ones it just doesn't need anything). Shall I drop the support or
change the code? I've no way to test this right now though...

Best regards,
Jose Miguel Abreu

>
>> + *
>> + * @dw_5v_status: 5v status callback. Shall return the status
>> of the given
>> + * input, i.e. shall be true if a cable is connected to the
>> specified input.
>> + *
>> + * @dw_5v_clear: 5v clear callback. Shall clear the interrupt
>> associated with
>> + * the 5v sense controller.
>> + *
>> + * @dw_5v_arg: Argument to be used with the 5v sense callbacks.
>> + *
>> + * @dw_zcal_reset: Impedance calibration reset callback.
>> Shall be called when
>> + * the impedance calibration needs to be restarted. This is
>> used by phy driver
>> + * only.
>> + *
>> + * @dw_zcal_done: Impendace calibration status callback.
>> Shall return true if
>
> Typo: Impendace -> Impedance
>
>> + * the impedance calibration procedure has ended. This is
>> used by phy driver
>> + * only.
>> + *
>> + * @dw_zcal_arg: Argument to be used with the ZCAL
>> calibration callbacks.
>> + */
>> +struct dw_hdmi_rx_pdata {
>> +    /* Controller configuration */
>> +    struct dw_hdmi_hdcp14_key hdcp14_keys;
>> +    /* 5V sense interface */
>> +    bool (*dw_5v_status)(void __iomem *regs, int input);
>> +    void (*dw_5v_clear)(void __iomem *regs);
>> +    void __iomem *dw_5v_arg;
>> +    /* Zcal interface */
>> +    void (*dw_zcal_reset)(void __iomem *regs);
>> +    bool (*dw_zcal_done)(void __iomem *regs);
>> +    void __iomem *dw_zcal_arg;
>> +};
>> +
>> +#endif /* __DW_HDMI_RX_PDATA_H__ */
>>
>
> Regards,
>
>     Hans
