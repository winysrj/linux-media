Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:52255 "EHLO
        lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752649AbdFPMiw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Jun 2017 08:38:52 -0400
Subject: Re: [PATCH v2 2/4] [media] platform: Add Synopsys Designware HDMI RX
 Controller Driver
To: Jose Abreu <Jose.Abreu@synopsys.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
References: <cover.1497607315.git.joabreu@synopsys.com>
 <b4e209f41cc25285eb547cbd65f8fc6bf2a039cb.1497607315.git.joabreu@synopsys.com>
Cc: Carlos Palminha <CARLOS.PALMINHA@synopsys.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <25d20060-f6b7-3a37-0509-39a734e6660a@xs4all.nl>
Date: Fri, 16 Jun 2017 14:38:41 +0200
MIME-Version: 1.0
In-Reply-To: <b4e209f41cc25285eb547cbd65f8fc6bf2a039cb.1497607315.git.joabreu@synopsys.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jose,

Just a quick review of the new CEC code:

On 06/16/17 12:07, Jose Abreu wrote:
> This is an initial submission for the Synopsys Designware HDMI RX
> Controller Driver. This driver interacts with a phy driver so that
> a communication between them is created and a video pipeline is
> configured.
> 
> The controller + phy pipeline can then be integrated into a fully
> featured system that can be able to receive video up to 4k@60Hz
> with deep color 48bit RGB, depending on the platform. Although,
> this initial version does not yet handle deep color modes.
> 
> This driver was implemented as a standard V4L2 subdevice and its
> main features are:
> 	- Internal state machine that reconfigures phy until the
> 	video is not stable
> 	- JTAG communication with phy
> 	- Inter-module communication with phy driver
> 	- Debug write/read ioctls
> 
> Some notes:
> 	- RX sense controller (cable connection/disconnection) must
> 	be handled by the platform wrapper as this is not integrated
> 	into the controller RTL
> 	- The same goes for EDID ROM's
> 	- ZCAL calibration is needed only in FPGA platforms, in ASIC
> 	this is not needed
> 	- The state machine is not an ideal solution as it creates a
> 	kthread but it is needed because some sources might not be
> 	very stable at sending the video (i.e. we must react
> 	accordingly).
> 
> Signed-off-by: Jose Abreu <joabreu@synopsys.com>
> Cc: Carlos Palminha <palminha@synopsys.com>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Changes from v1:
> 	- Added support for CEC
> 	- Correct typo errors
> 	- Correctly detect interlaced video modes
> 	- Correct VIC parsing
> Changes from RFC:
> 	- Added support for HDCP 1.4
> 	- Fixup HDMI_VIC not being parsed (Hans)
> 	- Send source change signal when powering off (Hans)
> 	- Added a "wait stable delay"
> 	- Detect interlaced video modes (Hans)
> 	- Restrain g/s_register from reading/writing to HDCP regs (Hans)
> 
> Signed-off-by: Jose Abreu <joabreu@synopsys.com>
> ---
>  drivers/media/platform/dwc/Kconfig      |   10 +
>  drivers/media/platform/dwc/Makefile     |    1 +
>  drivers/media/platform/dwc/dw-hdmi-rx.c | 1764 +++++++++++++++++++++++++++++++
>  drivers/media/platform/dwc/dw-hdmi-rx.h |  435 ++++++++
>  include/media/dwc/dw-hdmi-rx-pdata.h    |   63 ++
>  5 files changed, 2273 insertions(+)
>  create mode 100644 drivers/media/platform/dwc/dw-hdmi-rx.c
>  create mode 100644 drivers/media/platform/dwc/dw-hdmi-rx.h
>  create mode 100644 include/media/dwc/dw-hdmi-rx-pdata.h
> diff --git a/drivers/media/platform/dwc/Kconfig b/drivers/media/platform/dwc/Kconfig
> index 361d38d..aba18af 100644
> --- a/drivers/media/platform/dwc/Kconfig
> +++ b/drivers/media/platform/dwc/Kconfig
> @@ -6,3 +6,13 @@ config VIDEO_DWC_HDMI_PHY_E405
>  
>  	  To compile this driver as a module, choose M here. The module
>  	  will be called dw-hdmi-phy-e405.
> +
> +config VIDEO_DWC_HDMI_RX
> +	tristate "Synopsys Designware HDMI Receiver driver"
> +	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
> +	select CEC_CORE
> +	help
> +	  Support for Synopsys Designware HDMI RX controller.
> +
> +	  To compile this driver as a module, choose M here. The module
> +	  will be called dw-hdmi-rx.

Add a separate config VIDEO_DWC_HDMI_RX_CEC to explicitly enable
CEC. CEC is an optional component of HDMI and supporting CEC should
be something you select in the kernel config.

<snip>

General question: is this CEC IP the same IP as is used in the HDMI
transmitter? If so, then it is not a good idea to duplicate the
code.

If they are different, then that should be noted in the source.

> 
> +static void dw_hdmi_cec_enable_ints(struct dw_hdmi_dev *dw_dev)
> +{
> +	u32 mask = HDMI_AUD_CEC_ISTS_DONE | HDMI_AUD_CEC_ISTS_EOM |
> +		HDMI_AUD_CEC_ISTS_NACK | HDMI_AUD_CEC_ISTS_ARBLST |
> +		HDMI_AUD_CEC_ISTS_ERROR_INIT | HDMI_AUD_CEC_ISTS_ERROR_FOLL;
> +
> +	hdmi_writel(dw_dev, mask, HDMI_AUD_CEC_IEN_SET);
> +	hdmi_writel(dw_dev, 0x0, HDMI_CEC_MASK);
> +}
> +
> +static void dw_hdmi_cec_disable_ints(struct dw_hdmi_dev *dw_dev)
> +{
> +	hdmi_writel(dw_dev, ~0x0, HDMI_AUD_CEC_IEN_CLR);
> +	hdmi_writel(dw_dev, ~0x0, HDMI_CEC_MASK);
> +}
> +
> +static void dw_hdmi_cec_clear_ints(struct dw_hdmi_dev *dw_dev)
> +{
> +	hdmi_writel(dw_dev, ~0x0, HDMI_AUD_CEC_ICLR);
> +}
> +
> +static void dw_hdmi_cec_tx_raw_status(struct dw_hdmi_dev *dw_dev, u32 stat)
> +{
> +	u32 error_mask = HDMI_AUD_CEC_ISTS_NACK |
> +		HDMI_AUD_CEC_ISTS_ERROR_INIT;
> +
> +	if (hdmi_readl(dw_dev, HDMI_CEC_CTRL) & HDMI_CEC_CTRL_SEND_MASK) {
> +		dev_dbg(dw_dev->dev, "%s: tx is busy\n", __func__);
> +		return;
> +	}
> +
> +	if (stat & HDMI_AUD_CEC_ISTS_ARBLST) {
> +		dev_dbg(dw_dev->dev, "%s: arbitration lost\n", __func__);
> +		cec_transmit_done(dw_dev->cec_adap, CEC_TX_STATUS_ARB_LOST,
> +				1, 0, 0, 0);
> +		return;
> +	}
> +
> +	if (stat & HDMI_AUD_CEC_ISTS_DONE) {
> +		dev_dbg(dw_dev->dev, "%s: transmission done\n", __func__);
> +		cec_transmit_done(dw_dev->cec_adap, CEC_TX_STATUS_OK, 0, 0, 0, 0);
> +		return;
> +	}
> +
> +	if (stat & error_mask) {
> +		/* If we reached here we have an error */
> +		u8 status = 0, nack_cnt = 0, error_cnt = 0;
> +
> +		dev_dbg(dw_dev->dev, "%s: error found (stat=0x%x)\n", __func__,
> +				stat);
> +
> +		if (stat & HDMI_AUD_CEC_ISTS_NACK) {
> +			status |= CEC_TX_STATUS_NACK;
> +			nack_cnt++;
> +		}
> +
> +		if (stat & HDMI_AUD_CEC_ISTS_ERROR_INIT) {
> +			status |= CEC_TX_STATUS_ERROR;
> +			error_cnt++;
> +		}

What does it mean if you have both NACK and ERROR_INIT flags set? Is that
an error or a NACK? You have to chose here which one you pick when calling
cec_transmit_done.

> +
> +		cec_transmit_done(dw_dev->cec_adap, status, 0, nack_cnt, 0,
> +				error_cnt);
> +		return;
> +	}
> +}
> +
> +static void dw_hdmi_cec_received_msg(struct dw_hdmi_dev *dw_dev)
> +{
> +	struct cec_msg msg;
> +	u8 i;
> +
> +	msg.len = hdmi_readl(dw_dev, HDMI_CEC_RX_CNT);
> +	if (!msg.len || msg.len > HDMI_CEC_RX_DATA_MAX)
> +		return; /* its an invalid/non-existent message */

it's

> +
> +	for (i = 0; i < msg.len; i++)
> +		msg.msg[i] = hdmi_readl(dw_dev, HDMI_CEC_RX_DATA(i));
> +
> +	hdmi_writel(dw_dev, 0x0, HDMI_CEC_LOCK);
> +	cec_received_msg(dw_dev->cec_adap, &msg);
> +}
> +
> +static int dw_hdmi_cec_adap_enable(struct cec_adapter *adap, bool enable)
> +{
> +	struct dw_hdmi_dev *dw_dev = cec_get_drvdata(adap);
> +
> +	if (!dw_dev->cec_enabled_adap && enable) {
> +		hdmi_writel(dw_dev, 0x0, HDMI_CEC_LOCK);
> +		dw_hdmi_cec_enable_ints(dw_dev);
> +	} else if (dw_dev->cec_enabled_adap && !enable) {
> +		dw_hdmi_cec_disable_ints(dw_dev);
> +		dw_dev->cec_valid_addrs = 0;
> +	}
> +
> +	dw_dev->cec_enabled_adap = enable;
> +	return 0;
> +}
> +
> +static int dw_hdmi_cec_adap_log_addr(struct cec_adapter *adap, u8 addr)
> +{
> +	struct dw_hdmi_dev *dw_dev = cec_get_drvdata(adap);
> +	int i, free_idx = HDMI_CEC_MAX_LOG_ADDRS;
> +	u32 tmp;
> +
> +	if (!dw_dev->cec_enabled_adap)
> +		return addr == CEC_LOG_ADDR_INVALID ? 0 : -EIO;

This can't be called unless the adapter is enabled. So this check
can be removed.

> +
> +	if (addr == CEC_LOG_ADDR_INVALID) {
> +		hdmi_writel(dw_dev, 0x0, HDMI_CEC_ADDR_L);
> +		hdmi_writel(dw_dev, 0x0, HDMI_CEC_ADDR_H);
> +		dw_dev->cec_valid_addrs = 0;
> +		return 0;
> +	}
> +
> +	for (i = 0; i < HDMI_CEC_MAX_LOG_ADDRS; i++) {
> +		bool is_valid = dw_dev->cec_valid_addrs & (1 << i);
> +
> +		if (free_idx == HDMI_CEC_MAX_LOG_ADDRS && !is_valid)
> +			free_idx = i;
> +		if (is_valid && dw_dev->cec_addr[i] == addr)
> +			return 0;
> +	}
> +
> +	if (i == HDMI_CEC_MAX_LOG_ADDRS) {
> +		i = free_idx;
> +		if (i == HDMI_CEC_MAX_LOG_ADDRS)
> +			return -ENXIO;
> +	}
> +
> +	dw_dev->cec_addr[i] = addr;
> +	dw_dev->cec_valid_addrs |= 1 << i;
> +
> +	if (i >= 8) {
> +		tmp = hdmi_readl(dw_dev, HDMI_CEC_ADDR_H);
> +		tmp |= BIT(i - 8);
> +		hdmi_writel(dw_dev, tmp, HDMI_CEC_ADDR_H);
> +	} else {
> +		tmp = hdmi_readl(dw_dev, HDMI_CEC_ADDR_L);
> +		tmp |= BIT(i);
> +		hdmi_writel(dw_dev, tmp, HDMI_CEC_ADDR_L);
> +	}

This seems overengineered. HDMI_CEC_ADDR_H/L is just a bitmask, so just set the
bit corresponding to addr. I'm not sure what the point of cec_addr[] and cec_valid_addrs
is.

> +
> +	return 0;
> +}
> +
> +static int dw_hdmi_cec_adap_transmit(struct cec_adapter *adap, u8 attempts,
> +		u32 signal_free_time, struct cec_msg *msg)
> +{
> +	struct dw_hdmi_dev *dw_dev = cec_get_drvdata(adap);
> +	u8 len = msg->len;
> +	u32 reg;
> +	int i;
> +
> +	if (len > HDMI_CEC_TX_DATA_MAX) {
> +		dev_err(dw_dev->dev, "%s: invalid len (%d)\n", __func__, len);
> +		return -EINVAL;
> +	}

Can't happen.

> +
> +	if (hdmi_readl(dw_dev, HDMI_CEC_CTRL) & HDMI_CEC_CTRL_SEND_MASK) {
> +		dev_err(dw_dev->dev, "%s: tx is busy\n", __func__);
> +		return -EBUSY;

This should never happen, but it doesn't hurt to check.

> +	}
> +
> +	for (i = 0; i < HDMI_CEC_TX_DATA_MAX; i++)
> +		hdmi_writel(dw_dev, 0x0, HDMI_CEC_TX_DATA(i));

Why clear this? Is it necessary?

> +	for (i = 0; i < len; i++)
> +		hdmi_writel(dw_dev, msg->msg[i], HDMI_CEC_TX_DATA(i));
> +
> +	switch (signal_free_time) {
> +	case 3:
> +		reg = 0x0;
> +		break;
> +	case 7:
> +		reg = 0x2;
> +		break;
> +	case 5:

Use the defines in media/cec.h instead of hardcoding these values.

> +	default:
> +		reg = 0x1;
> +		break;
> +	}
> +
> +	hdmi_writel(dw_dev, len, HDMI_CEC_TX_CNT);
> +	hdmi_mask_writel(dw_dev, reg, HDMI_CEC_CTRL,
> +			HDMI_CEC_CTRL_FRAME_TYP_OFFSET,
> +			HDMI_CEC_CTRL_FRAME_TYP_MASK);
> +	hdmi_mask_writel(dw_dev, 0x1, HDMI_CEC_CTRL,
> +			HDMI_CEC_CTRL_SEND_OFFSET,
> +			HDMI_CEC_CTRL_SEND_MASK);
> +	return 0;
> +}
> +
> +static const struct cec_adap_ops dw_hdmi_cec_adap_ops = {
> +	.adap_enable = dw_hdmi_cec_adap_enable,
> +	.adap_log_addr = dw_hdmi_cec_adap_log_addr,
> +	.adap_transmit = dw_hdmi_cec_adap_transmit,
> +};

<snip>

> +static int dw_hdmi_log_status(struct v4l2_subdev *sd)
> +{
> +	struct dw_hdmi_dev *dw_dev = to_dw_dev(sd);
> +	struct v4l2_dv_timings timings;
> +
> +	v4l2_info(sd, "--- Chip configuration ---\n");
> +	v4l2_info(sd, "cfg_clk=%dMHz\n", dw_dev->cfg_clk);
> +	v4l2_info(sd, "phy_drv=%s, phy_jtag_addr=0x%x\n", dw_dev->phy_drv,
> +			dw_dev->phy_jtag_addr);
> +
> +	v4l2_info(sd, "--- Chip status ---\n");
> +	v4l2_info(sd, "selected_input=%d: signal=%d\n", dw_dev->selected_input,
> +			has_signal(dw_dev, dw_dev->selected_input));
> +	v4l2_info(sd, "configured_input=%d: signal=%d\n",
> +			dw_dev->configured_input,
> +			has_signal(dw_dev, dw_dev->configured_input));
> +
> +	v4l2_info(sd, "--- CEC status ---\n");
> +	if (dw_dev->cec_enabled_adap) {
> +		int i;
> +
> +		for (i = 0; i < HDMI_CEC_MAX_LOG_ADDRS; i++) {
> +			bool is_valid = dw_dev->cec_valid_addrs & (1 << i);
> +
> +			if (is_valid)
> +				v4l2_info(sd, "cec_logical_address=0x%x\n",
> +						dw_dev->cec_addr[i]);
> +		}
> +	}

I'm not sure how useful this is. The same information is available through
/sys/kernel/debug/cec/cecX/status.

And just running cec-ctl gives it as well.

Up to you, though.

> +
> +	v4l2_info(sd, "--- Video status ---\n");
> +	v4l2_info(sd, "type=%s, color_depth=%dbits",
> +			hdmi_readl(dw_dev, HDMI_PDEC_STS) &
> +			HDMI_PDEC_STS_DVIDET ? "dvi" : "hdmi",
> +			dw_hdmi_get_colordepth(dw_dev));
> +
> +	v4l2_info(sd, "--- Video timings ---\n");
> +	if (dw_hdmi_query_dv_timings(sd, &timings))
> +		v4l2_info(sd, "No video detected\n");
> +	else
> +		v4l2_print_dv_timings(sd->name, "Detected format: ",
> +				&timings, true);
> +	v4l2_print_dv_timings(sd->name, "Configured format: ",
> +			&dw_dev->timings, true);
> +	return 0;
> +}
> +

<snip>

> +	/* CEC */
> +	dw_dev->cec_adap = cec_allocate_adapter(&dw_hdmi_cec_adap_ops,
> +			dw_dev, dev_name(dev), CEC_CAP_TRANSMIT |
> +			CEC_CAP_PHYS_ADDR | CEC_CAP_LOG_ADDRS,

Add CEC_CAP_RC and CEC_CAP_PASSTHROUGH.

I'm not sure about CEC_CAP_PHYS_ADDR. The problem here is that this driver
doesn't handle the EDID, but without that it doesn't know what physical
address to use.

I wonder if the cec-notifier can be used for this, possibly with adaptations.
Relying on users to set the physical address is a last resort since it is very
painful to do so. cec-notifier was specifically designed to solve this.

> +			HDMI_CEC_MAX_LOG_ADDRS);
> +	ret = PTR_ERR_OR_ZERO(dw_dev->cec_adap);
> +	if (ret) {
> +		dev_err(dev, "failed to allocate CEC adapter\n");
> +		goto err_phy;
> +	}

Regards,

	Hans
