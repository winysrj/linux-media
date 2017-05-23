Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay4.synopsys.com ([198.182.47.9]:58399 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752564AbdEWQi4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 23 May 2017 12:38:56 -0400
Subject: Re: [RFC 2/2] [media] platform: Add Synopsys Designware HDMI RX
 Controller Driver
To: Hans Verkuil <hverkuil@xs4all.nl>
References: <cover.1492767176.git.joabreu@synopsys.com>
 <a0c0a46aa86abf87da4f6b1742114fbfc40a3963.1492767176.git.joabreu@synopsys.com>
 <d6bfa439-a0e5-d08f-a94f-5b75e17bf9db@xs4all.nl>
CC: Jose Abreu <Jose.Abreu@synopsys.com>,
        <linux-media@vger.kernel.org>,
        Carlos Palminha <CARLOS.PALMINHA@synopsys.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        <linux-kernel@vger.kernel.org>
From: Jose Abreu <Jose.Abreu@synopsys.com>
Message-ID: <05c536fe-4a0b-b78d-7f88-c3c51383863e@synopsys.com>
Date: Tue, 23 May 2017 17:38:42 +0100
MIME-Version: 1.0
In-Reply-To: <d6bfa439-a0e5-d08f-a94f-5b75e17bf9db@xs4all.nl>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,


Thanks for the review!

On 22-05-2017 11:36, Hans Verkuil wrote:
> On 04/21/2017 11:53 AM, Jose Abreu wrote:
>> This is an initial submission for the Synopsys Designware HDMI RX
>> Controller Driver. This driver interacts with a phy driver so that
>> a communication between them is created and a video pipeline is
>> configured.
>>
>> The controller + phy pipeline can then be integrated into a fully
>> featured system that can be able to receive video up to 4k@60Hz
>> with deep color 48bit RGB, depending on the platform. Althoug,
> Typo: Although
>
>> this initial version does not yet handle deep color modes.
>>
>> This driver was implemented as a standard V4L2 subdevice and its
>> main features are:
>> 	- Internal state machine that reconfigures phy until the
>> 	video is not stable
>> 	- JTAG communication with phy
>> 	- Inter-module communication with phy driver
>> 	- Debug write/read ioctls
>>
>> Some notes:
>> 	- RX sense controller (cable connection/disconnection) must
>> 	be handled by the platform wrapper as this is not integrated
>> 	into the controller RTL
>> 	- The same goes for EDID ROM's
>> 	- ZCAL calibration is needed only in FPGA platforms, in ASIC
>> 	this is not needed
> What is ZCAL?

ZCAL is impedance calibration. Its is needed in our test boards.
 
>
>> 	- The state machine is not an ideal solution as it creates a
>> 	kthread but it is needed because some sources might not be
>> 	very stable at sending the video (i.e. we must react
>> 	accordingly).
> I can guarantee that sources can be unstable, based on years of painful experience
> with HDMI receivers :-)
>
>> Signed-off-by: Jose Abreu <joabreu@synopsys.com>
>> Cc: Carlos Palminha <palminha@synopsys.com>
>> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
>> Cc: Hans Verkuil <hans.verkuil@cisco.com>
>> Cc: linux-kernel@vger.kernel.org
>> Cc: linux-media@vger.kernel.org
>> ---
>>  drivers/media/platform/dwc/Kconfig      |    9 +
>>  drivers/media/platform/dwc/Makefile     |    1 +
>>  drivers/media/platform/dwc/dw-hdmi-rx.c | 1396 +++++++++++++++++++++++++++++++
>>  drivers/media/platform/dwc/dw-hdmi-rx.h |  313 +++++++
>>  include/media/dwc/dw-hdmi-rx-pdata.h    |   50 ++
>>  5 files changed, 1769 insertions(+)
>>  create mode 100644 drivers/media/platform/dwc/dw-hdmi-rx.c
>>  create mode 100644 drivers/media/platform/dwc/dw-hdmi-rx.h
>>  create mode 100644 include/media/dwc/dw-hdmi-rx-pdata.h
>>
>> diff --git a/drivers/media/platform/dwc/Kconfig b/drivers/media/platform/dwc/Kconfig
>> index 361d38d..11efa23 100644
>> --- a/drivers/media/platform/dwc/Kconfig
>> +++ b/drivers/media/platform/dwc/Kconfig
>> @@ -6,3 +6,12 @@ config VIDEO_DWC_HDMI_PHY_E405
>>  
>>  	  To compile this driver as a module, choose M here. The module
>>  	  will be called dw-hdmi-phy-e405.
>> +
>> +config VIDEO_DWC_HDMI_RX
>> +	tristate "Synopsys Designware HDMI Receiver driver"
>> +	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
>> +	help
>> +	  Support for Synopsys Designware HDMI RX controller.
>> +
>> +	  To compile this driver as a module, choose M here. The module
>> +	  will be called dw-hdmi-rx.
>> diff --git a/drivers/media/platform/dwc/Makefile b/drivers/media/platform/dwc/Makefile
>> index fc3b62c..cd04ca9 100644
>> --- a/drivers/media/platform/dwc/Makefile
>> +++ b/drivers/media/platform/dwc/Makefile
>> @@ -1 +1,2 @@
>>  obj-$(CONFIG_VIDEO_DWC_HDMI_PHY_E405) += dw-hdmi-phy-e405.o
>> +obj-$(CONFIG_VIDEO_DWC_HDMI_RX) += dw-hdmi-rx.o
>> diff --git a/drivers/media/platform/dwc/dw-hdmi-rx.c b/drivers/media/platform/dwc/dw-hdmi-rx.c
>> new file mode 100644
>> index 0000000..6bfbc86
>> --- /dev/null
>> +++ b/drivers/media/platform/dwc/dw-hdmi-rx.c
>> @@ -0,0 +1,1396 @@
>> +/*
>> + * Synopsys Designware HDMI Receiver controller driver
>> + *
>> + * This Synopsys dw-hdmi-rx software and associated documentation
>> + * (hereinafter the "Software") is an unsupported proprietary work of
>> + * Synopsys, Inc. unless otherwise expressly agreed to in writing between
>> + * Synopsys and you. The Software IS NOT an item of Licensed Software or a
>> + * Licensed Product under any End User Software License Agreement or
>> + * Agreement for Licensed Products with Synopsys or any supplement thereto.
>> + * Synopsys is a registered trademark of Synopsys, Inc. Other names included
>> + * in the SOFTWARE may be the trademarks of their respective owners.
>> + *
>> + * The contents of this file are dual-licensed; you may select either version 2
>> + * of the GNU General Public License (“GPL”) or the MIT license (“MIT”).
>> + *
>> + * Copyright (c) 2017 Synopsys, Inc. and/or its affiliates.
>> + *
>> + * THIS SOFTWARE IS PROVIDED "AS IS"  WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
>> + * IMPLIED, INCLUDING, BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
>> + * FITNESS FOR A PARTICULAR PURPOSE, AND NONINFRINGEMENT. IN NO EVENT SHALL THE
>> + * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
>> + * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT, OR OTHERWISE
>> + * ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE THE USE OR
>> + * OTHER DEALINGS IN THE SOFTWARE.
>> + */
>> +
>> +#include <linux/delay.h>
>> +#include <linux/dma-mapping.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/module.h>
>> +#include <linux/of.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/v4l2-dv-timings.h>
>> +#include <linux/workqueue.h>
>> +#include <media/v4l2-device.h>
>> +#include <media/v4l2-dv-timings.h>
>> +#include <media/v4l2-event.h>
>> +#include <media/v4l2-subdev.h>
>> +#include <media/dwc/dw-hdmi-phy-pdata.h>
>> +#include <media/dwc/dw-hdmi-rx-pdata.h>
>> +#include "dw-hdmi-rx.h"
>> +
>> +#define HDMI_DEFAULT_TIMING		V4L2_DV_BT_CEA_640X480P59_94
>> +
>> +MODULE_AUTHOR("Carlos Palminha <palminha@synopsys.com>");
>> +MODULE_AUTHOR("Jose Abreu <joabreu@synopsys.com>");
>> +MODULE_DESCRIPTION("Designware HDMI Receiver driver");
>> +MODULE_LICENSE("Dual MIT/GPL");
>> +MODULE_ALIAS("platform:" DW_HDMI_RX_DRVNAME);
>> +
>> +static const struct v4l2_dv_timings_cap dw_hdmi_timings_cap = {
>> +	.type = V4L2_DV_BT_656_1120,
>> +	.reserved = { 0 },
>> +	V4L2_INIT_BT_TIMINGS(
>> +			640, 4096,		/* min/max width */
>> +			480, 4455,		/* min/max height */
>> +			20000000, 594000000,	/* min/max pixelclock */
>> +			V4L2_DV_BT_STD_CEA861,	/* standards */
>> +			/* capabilities */
>> +			V4L2_DV_BT_CAP_PROGRESSIVE
>> +	)
>> +};
>> +
>> +static const struct v4l2_event dw_hdmi_event_fmt = {
>> +	.type = V4L2_EVENT_SOURCE_CHANGE,
>> +	.u.src_change.changes = V4L2_EVENT_SRC_CH_RESOLUTION,
>> +};
>> +
>> +enum dw_hdmi_state {
>> +	HDMI_STATE_NO_INIT = 0,
>> +	HDMI_STATE_POWER_OFF,
>> +	HDMI_STATE_PHY_CONFIG,
>> +	HDMI_STATE_CONTROLLER_CONFIG,
>> +	HDMI_STATE_EQUALIZER,
>> +	HDMI_STATE_VIDEO_UNSTABLE,
>> +	HDMI_STATE_POWER_ON,
>> +};
>> +
>> +struct dw_hdmi_dev {
>> +	struct dw_hdmi_rx_pdata *config;
>> +	struct workqueue_struct *wq;
>> +	enum dw_hdmi_state state;
>> +	bool pending_config;
>> +	bool force_off;
>> +	spinlock_t lock;
>> +	void __iomem *regs;
>> +	struct device_node *of_node;
>> +	struct v4l2_subdev sd;
>> +	struct v4l2_dv_timings timings;
>> +	struct v4l2_device v4l2_dev;
>> +	struct dw_phy_pdata phy_config;
>> +	struct platform_device *phy_pdev;
>> +	struct v4l2_subdev *phy_sd;
>> +	bool phy_eq_force;
>> +	u8 phy_jtag_addr;
>> +	const char *phy_drv;
>> +	struct device *dev;
>> +	u32 mbus_code;
>> +	unsigned int selected_input;
>> +	unsigned int configured_input;
>> +	u32 cfg_clk;
>> +};
>> +
>> +static const char *get_state_name(enum dw_hdmi_state state)
>> +{
>> +	switch (state) {
>> +	case HDMI_STATE_NO_INIT:
>> +		return "NO_INIT";
>> +	case HDMI_STATE_POWER_OFF:
>> +		return "POWER_OFF";
>> +	case HDMI_STATE_PHY_CONFIG:
>> +		return "PHY_CONFIG";
>> +	case HDMI_STATE_CONTROLLER_CONFIG:
>> +		return "CONTROLLER_CONFIG";
>> +	case HDMI_STATE_EQUALIZER:
>> +		return "EQUALIZER";
>> +	case HDMI_STATE_VIDEO_UNSTABLE:
>> +		return "VIDEO_UNSTABLE";
>> +	case HDMI_STATE_POWER_ON:
>> +		return "POWER_ON";
>> +	default:
>> +		return "UNKNOWN";
>> +	}
>> +}
>> +
>> +static inline void dw_hdmi_set_state(struct dw_hdmi_dev *dw_dev,
>> +		enum dw_hdmi_state new_state)
>> +{
>> +	unsigned long flags;
>> +
>> +	spin_lock_irqsave(&dw_dev->lock, flags);
>> +	dev_dbg(dw_dev->dev, "old_state=%s, new_state=%s\n",
>> +			get_state_name(dw_dev->state),
>> +			get_state_name(new_state));
>> +	dw_dev->state = new_state;
>> +	spin_unlock_irqrestore(&dw_dev->lock, flags);
>> +}
>> +
>> +static inline struct dw_hdmi_dev *to_dw_dev(struct v4l2_subdev *sd)
>> +{
>> +	return container_of(sd, struct dw_hdmi_dev, sd);
>> +}
>> +
>> +static inline void hdmi_writel(struct dw_hdmi_dev *dw_dev, u32 val, int reg)
>> +{
>> +	writel(val, dw_dev->regs + reg);
>> +}
>> +
>> +static inline u32 hdmi_readl(struct dw_hdmi_dev *dw_dev, int reg)
>> +{
>> +	return readl(dw_dev->regs + reg);
>> +}
>> +
>> +static void hdmi_modl(struct dw_hdmi_dev *dw_dev, u32 data, u32 mask, int reg)
>> +{
>> +	u32 val = hdmi_readl(dw_dev, reg) & ~mask;
>> +
>> +	val |= data & mask;
>> +	hdmi_writel(dw_dev, val, reg);
>> +}
>> +
>> +static void hdmi_mask_writel(struct dw_hdmi_dev *dw_dev, u32 data, int reg,
>> +		u32 shift, u32 mask)
>> +{
>> +	hdmi_modl(dw_dev, data << shift, mask, reg);
>> +}
>> +
>> +static u32 hdmi_mask_readl(struct dw_hdmi_dev *dw_dev, int reg, u32 shift,
>> +		u32 mask)
>> +{
>> +	return (hdmi_readl(dw_dev, reg) & mask) >> shift;
>> +}
>> +
>> +static bool dw_hdmi_5v_status(struct dw_hdmi_dev *dw_dev, int input)
>> +{
>> +	void __iomem *arg = dw_dev->config->dw_5v_arg;
>> +
>> +	if (dw_dev->config->dw_5v_status)
>> +		return dw_dev->config->dw_5v_status(arg, input);
>> +	return false;
>> +}
>> +
>> +static void dw_hdmi_5v_clear(struct dw_hdmi_dev *dw_dev)
>> +{
>> +	void __iomem *arg = dw_dev->config->dw_5v_arg;
>> +
>> +	if (dw_dev->config->dw_5v_clear)
>> +		dw_dev->config->dw_5v_clear(arg);
>> +}
>> +
>> +static inline bool is_off(struct dw_hdmi_dev *dw_dev)
>> +{
>> +	return dw_dev->state <= HDMI_STATE_POWER_OFF;
>> +}
>> +
>> +static bool has_signal(struct dw_hdmi_dev *dw_dev, unsigned int input)
>> +{
>> +	return dw_hdmi_5v_status(dw_dev, input);
>> +}
>> +
>> +#define HDMI_JTAG_TAP_ADDR_CMD		0
>> +#define HDMI_JTAG_TAP_WRITE_CMD		1
>> +#define HDMI_JTAG_TAP_READ_CMD		3
>> +
>> +static void hdmi_phy_jtag_send_pulse(struct dw_hdmi_dev *dw_dev, u8 tms, u8 tdi)
>> +{
>> +	u8 val;
>> +
>> +	val = tms ? HDMI_PHY_JTAG_TAP_IN_TMS : 0;
>> +	val |= tdi ? HDMI_PHY_JTAG_TAP_IN_TDI : 0;
>> +
>> +	hdmi_writel(dw_dev, 0, HDMI_PHY_JTAG_TAP_TCLK);
>> +	hdmi_writel(dw_dev, val, HDMI_PHY_JTAG_TAP_IN);
>> +	hdmi_writel(dw_dev, 1, HDMI_PHY_JTAG_TAP_TCLK);
>> +}
>> +
>> +static void hdmi_phy_jtag_shift_dr(struct dw_hdmi_dev *dw_dev)
>> +{
>> +	hdmi_phy_jtag_send_pulse(dw_dev, 1, 0);
>> +	hdmi_phy_jtag_send_pulse(dw_dev, 0, 0);
>> +	hdmi_phy_jtag_send_pulse(dw_dev, 0, 0);
>> +}
>> +
>> +static void hdmi_phy_jtag_shift_ir(struct dw_hdmi_dev *dw_dev)
>> +{
>> +	hdmi_phy_jtag_send_pulse(dw_dev, 1, 0);
>> +	hdmi_phy_jtag_send_pulse(dw_dev, 1, 0);
>> +	hdmi_phy_jtag_send_pulse(dw_dev, 0, 0);
>> +	hdmi_phy_jtag_send_pulse(dw_dev, 0, 0);
>> +}
>> +
>> +static u16 hdmi_phy_jtag_send(struct dw_hdmi_dev *dw_dev, u8 cmd, u16 val)
>> +{
>> +	u32 in = (cmd << 16) | val;
>> +	u16 out = 0;
>> +	int i;
>> +
>> +	for (i = 0; i < 16; i++) {
>> +		hdmi_phy_jtag_send_pulse(dw_dev, 0, in & 0x1);
>> +		out |= (hdmi_readl(dw_dev, HDMI_PHY_JTAG_TAP_OUT) & 0x1) << i;
>> +		in >>= 1;
>> +	}
>> +
>> +	hdmi_phy_jtag_send_pulse(dw_dev, 0, in & 0x1);
>> +	in >>= 1;
>> +	hdmi_phy_jtag_send_pulse(dw_dev, 1, in & 0x1);
>> +
>> +	out |= (hdmi_readl(dw_dev, HDMI_PHY_JTAG_TAP_OUT) & 0x1) << ++i;
>> +	return out;
>> +}
>> +
>> +static void hdmi_phy_jtag_idle(struct dw_hdmi_dev *dw_dev)
>> +{
>> +	hdmi_phy_jtag_send_pulse(dw_dev, 1, 0);
>> +	hdmi_phy_jtag_send_pulse(dw_dev, 0, 0);
>> +}
>> +
>> +static void hdmi_phy_jtag_init(struct dw_hdmi_dev *dw_dev, u8 addr)
>> +{
>> +	int i;
>> +
>> +	hdmi_writel(dw_dev, addr, HDMI_PHY_JTAG_ADDR);
>> +	/* reset */
>> +	hdmi_writel(dw_dev, 0x10, HDMI_PHY_JTAG_TAP_IN);
>> +	hdmi_writel(dw_dev, 0x0, HDMI_PHY_JTAG_CONF);
>> +	hdmi_writel(dw_dev, 0x1, HDMI_PHY_JTAG_CONF);
>> +	hdmi_phy_jtag_send_pulse(dw_dev, 0, 0);
>> +	/* soft reset */
>> +	for (i = 0; i < 5; i++)
>> +		hdmi_phy_jtag_send_pulse(dw_dev, 1, 0);
>> +	hdmi_phy_jtag_send_pulse(dw_dev, 0, 0);
>> +	/* set slave address */
>> +	hdmi_phy_jtag_shift_ir(dw_dev);
>> +	for (i = 0; i < 7; i++) {
>> +		hdmi_phy_jtag_send_pulse(dw_dev, 0, addr & 0x1);
>> +		addr >>= 1;
>> +	}
>> +	hdmi_phy_jtag_send_pulse(dw_dev, 1, addr & 0x1);
>> +	hdmi_phy_jtag_idle(dw_dev);
>> +}
>> +
>> +static void hdmi_phy_jtag_write(struct dw_hdmi_dev *dw_dev, u16 val, u16 addr)
>> +{
>> +	hdmi_phy_jtag_shift_dr(dw_dev);
>> +	hdmi_phy_jtag_send(dw_dev, HDMI_JTAG_TAP_ADDR_CMD, addr << 8);
>> +	hdmi_phy_jtag_idle(dw_dev);
>> +	hdmi_phy_jtag_shift_dr(dw_dev);
>> +	hdmi_phy_jtag_send(dw_dev, HDMI_JTAG_TAP_WRITE_CMD, val);
>> +	hdmi_phy_jtag_idle(dw_dev);
>> +}
>> +
>> +static u16 hdmi_phy_jtag_read(struct dw_hdmi_dev *dw_dev, u16 addr)
>> +{
>> +	u16 val;
>> +
>> +	hdmi_phy_jtag_shift_dr(dw_dev);
>> +	hdmi_phy_jtag_send(dw_dev, HDMI_JTAG_TAP_ADDR_CMD, addr << 8);
>> +	hdmi_phy_jtag_idle(dw_dev);
>> +	hdmi_phy_jtag_shift_dr(dw_dev);
>> +	val = hdmi_phy_jtag_send(dw_dev, HDMI_JTAG_TAP_READ_CMD, 0xFFFF);
>> +	hdmi_phy_jtag_idle(dw_dev);
>> +	
>> +	return val;
>> +}
>> +
>> +static void dw_hdmi_phy_write(void *arg, u16 val, u16 addr)
>> +{
>> +	struct dw_hdmi_dev *dw_dev = arg;
>> +	u16 rval;
>> +
>> +	hdmi_phy_jtag_init(dw_dev, dw_dev->phy_jtag_addr);
>> +	hdmi_phy_jtag_write(dw_dev, val, addr);
>> +	rval = hdmi_phy_jtag_read(dw_dev, addr);
>> +
>> +	if (rval != val) {
>> +		dev_err(dw_dev->dev,
>> +			"JTAG read-back failed: expected=0x%x, got=0x%x\n",
>> +			val, rval);
>> +	}
>> +}
>> +
>> +static u16 dw_hdmi_phy_read(void *arg, u16 addr)
>> +{
>> +	struct dw_hdmi_dev *dw_dev = arg;
>> +
>> +	hdmi_phy_jtag_init(dw_dev, dw_dev->phy_jtag_addr);
>> +	return hdmi_phy_jtag_read(dw_dev, addr);
>> +}
>> +
>> +static void dw_hdmi_phy_reset(void *arg, int enable)
>> +{
>> +	struct dw_hdmi_dev *dw_dev = arg;
>> +
>> +	hdmi_mask_writel(dw_dev, enable, HDMI_PHY_CTRL,
>> +			HDMI_PHY_CTRL_RESET_OFFSET,
>> +			HDMI_PHY_CTRL_RESET_MASK);
>> +}
>> +
>> +static void dw_hdmi_phy_pddq(void *arg, int enable)
>> +{
>> +	struct dw_hdmi_dev *dw_dev = arg;
>> +
>> +	hdmi_mask_writel(dw_dev, enable, HDMI_PHY_CTRL,
>> +			HDMI_PHY_CTRL_PDDQ_OFFSET,
>> +			HDMI_PHY_CTRL_PDDQ_MASK);
>> +}
>> +
>> +static void dw_hdmi_phy_svsmode(void *arg, int enable)
>> +{
>> +	struct dw_hdmi_dev *dw_dev = arg;
>> +
>> +	hdmi_mask_writel(dw_dev, enable, HDMI_PHY_CTRL,
>> +			HDMI_PHY_CTRL_SVSRETMODEZ_OFFSET,
>> +			HDMI_PHY_CTRL_SVSRETMODEZ_MASK);
>> +}
>> +
>> +static void dw_hdmi_zcal_reset(void *arg)
>> +{
>> +	struct dw_hdmi_dev *dw_dev = arg;
>> +
>> +	if (dw_dev->config->dw_zcal_reset)
>> +		dw_dev->config->dw_zcal_reset(dw_dev->config->dw_zcal_arg);
>> +}
>> +
>> +static bool dw_hdmi_zcal_done(void *arg)
>> +{
>> +	struct dw_hdmi_dev *dw_dev = arg;
>> +
>> +	if (dw_dev->config->dw_zcal_done)
>> +		return dw_dev->config->dw_zcal_done(dw_dev->config->dw_zcal_arg);
>> +	return true;
>> +}
>> +
>> +static bool dw_hdmi_tmds_valid(void *arg)
>> +{
>> +	struct dw_hdmi_dev *dw_dev = arg;
>> +
>> +	return hdmi_readl(dw_dev, HDMI_PLL_LCK_STS) & HDMI_PLL_LCK_STS_PLL_LOCKED;
>> +}
>> +
>> +static const struct dw_phy_funcs dw_hdmi_phy_funcs = {
>> +	.write = dw_hdmi_phy_write,
>> +	.read = dw_hdmi_phy_read,
>> +	.reset = dw_hdmi_phy_reset,
>> +	.pddq = dw_hdmi_phy_pddq,
>> +	.svsmode = dw_hdmi_phy_svsmode,
>> +	.zcal_reset = dw_hdmi_zcal_reset,
>> +	.zcal_done = dw_hdmi_zcal_done,
>> +	.tmds_valid = dw_hdmi_tmds_valid,
>> +};
>> +
>> +static int dw_hdmi_phy_init(struct dw_hdmi_dev *dw_dev)
>> +{
>> +	struct dw_phy_pdata *phy = &dw_dev->phy_config;
>> +	struct platform_device_info pdevinfo;
>> +
>> +	memset(&pdevinfo, 0, sizeof(pdevinfo));
>> +
>> +	phy->funcs = &dw_hdmi_phy_funcs;
>> +	phy->funcs_arg = dw_dev;
>> +
>> +	pdevinfo.parent = dw_dev->dev;
>> +	pdevinfo.id = PLATFORM_DEVID_NONE;
>> +	pdevinfo.name = dw_dev->phy_drv;
>> +	pdevinfo.data = phy;
>> +	pdevinfo.size_data = sizeof(*phy);
>> +	pdevinfo.dma_mask = DMA_BIT_MASK(32);
>> +
>> +	request_module(pdevinfo.name);
>> +
>> +	dw_dev->phy_pdev = platform_device_register_full(&pdevinfo);
>> +	if (IS_ERR(dw_dev->phy_pdev)) {
>> +		dev_err(dw_dev->dev, "failed to register phy device\n");
>> +		return PTR_ERR(dw_dev->phy_pdev);
>> +	}
>> +
>> +	if (!dw_dev->phy_pdev->dev.driver) {
>> +		dev_err(dw_dev->dev, "failed to initialize phy driver\n");
>> +		goto err;
>> +	}
>> +
>> +	if (!try_module_get(dw_dev->phy_pdev->dev.driver->owner)) {
>> +		dev_err(dw_dev->dev, "failed to get phy module\n");
>> +		goto err;
>> +	}
>> +
>> +	dw_dev->phy_sd = dev_get_drvdata(&dw_dev->phy_pdev->dev);
>> +	if (!dw_dev->phy_sd) {
>> +		dev_err(dw_dev->dev, "failed to get phy subdev\n");
>> +		goto err_put;
>> +	}
>> +
>> +	if (v4l2_device_register_subdev(&dw_dev->v4l2_dev, dw_dev->phy_sd)) {
>> +		dev_err(dw_dev->dev, "failed to register phy subdev\n");
>> +		goto err_put;
>> +	}
>> +
>> +	module_put(dw_dev->phy_pdev->dev.driver->owner);
>> +	return 0;
>> +
>> +err_put:
>> +	module_put(dw_dev->phy_pdev->dev.driver->owner);
>> +err:
>> +	platform_device_unregister(dw_dev->phy_pdev);
>> +	return -EINVAL;
>> +}
>> +
>> +static void dw_hdmi_phy_exit(struct dw_hdmi_dev *dw_dev)
>> +{
>> +	if (!IS_ERR(dw_dev->phy_pdev))
>> +		platform_device_unregister(dw_dev->phy_pdev);
>> +}
>> +
>> +static int dw_hdmi_phy_eq_init(struct dw_hdmi_dev *dw_dev, u16 acq, bool force)
>> +{
>> +	struct dw_phy_command cmd = {
>> +		.result = 0,
>> +		.nacq = acq,
>> +		.force = force,
>> +	};
>> +	int ret;
>> +
>> +	ret = v4l2_subdev_call(dw_dev->phy_sd, core, ioctl,
>> +			DW_PHY_IOCTL_EQ_INIT, &cmd);
>> +	if (ret)
>> +		return ret;
>> +	return cmd.result;
>> +}
>> +
>> +static int dw_hdmi_phy_config(struct dw_hdmi_dev *dw_dev, unsigned char res,
>> +		bool hdmi2, bool scrambling)
>> +{
>> +	struct dw_phy_command cmd = {
>> +		.result = 0,
>> +		.res = res,
>> +		.hdmi2 = hdmi2,
>> +		.scrambling = scrambling,
>> +	};
>> +	int ret;
>> +
>> +	if (dw_dev->phy_config.version >= 401) {
>> +		hdmi_mask_writel(dw_dev, 0x1, HDMI_CBUSIOCTRL,
>> +				HDMI_CBUSIOCTRL_DATAPATH_CBUSZ_OFFSET,
>> +				HDMI_CBUSIOCTRL_DATAPATH_CBUSZ_MASK);
>> +		hdmi_mask_writel(dw_dev, 0x1, HDMI_CBUSIOCTRL,
>> +				HDMI_CBUSIOCTRL_SVSRETMODEZ_OFFSET,
>> +				HDMI_CBUSIOCTRL_SVSRETMODEZ_MASK);
>> +		hdmi_mask_writel(dw_dev, 0x1, HDMI_CBUSIOCTRL,
>> +				HDMI_CBUSIOCTRL_PDDQ_OFFSET,
>> +				HDMI_CBUSIOCTRL_PDDQ_MASK);
>> +		hdmi_mask_writel(dw_dev, 0x1, HDMI_CBUSIOCTRL,
>> +				HDMI_CBUSIOCTRL_RESET_OFFSET,
>> +				HDMI_CBUSIOCTRL_RESET_MASK);
>> +	}
>> +
>> +	ret = v4l2_subdev_call(dw_dev->phy_sd, core, ioctl,
>> +			DW_PHY_IOCTL_CONFIG, &cmd);
>> +	if (ret)
>> +		return ret;
>> +	return cmd.result;
>> +}
>> +
>> +static void dw_hdmi_phy_s_power(struct dw_hdmi_dev *dw_dev, bool on)
>> +{
>> +	v4l2_subdev_call(dw_dev->phy_sd, core, s_power, on);
>> +}
>> +
>> +static int dw_hdmi_wait_phy_lock_poll(struct dw_hdmi_dev *dw_dev)
>> +{
>> +	int timeout = 10;
>> +
>> +	while (!dw_hdmi_tmds_valid(dw_dev) && timeout-- && !dw_dev->force_off)
>> +		usleep_range(5000, 10000);
>> +
>> +	if (!dw_hdmi_tmds_valid(dw_dev))
>> +		return -ETIMEDOUT;
>> +	return 0;
>> +}
>> +
>> +static void dw_hdmi_reset_datapath(struct dw_hdmi_dev *dw_dev)
>> +{
>> +	u32 val = HDMI_DMI_SW_RST_TMDS |
>> +		HDMI_DMI_SW_RST_HDCP |
>> +		HDMI_DMI_SW_RST_VID |
>> +		HDMI_DMI_SW_RST_PIXEL |
>> +		HDMI_DMI_SW_RST_CEC |
>> +		HDMI_DMI_SW_RST_AUD |
>> +		HDMI_DMI_SW_RST_BUS |
>> +		HDMI_DMI_SW_RST_HDMI |
>> +		HDMI_DMI_SW_RST_MODET;
>> +
>> +	hdmi_writel(dw_dev, val, HDMI_DMI_SW_RST);
>> +}
>> +
>> +static void dw_hdmi_enable_ints(struct dw_hdmi_dev *dw_dev)
>> +{
>> +	hdmi_writel(dw_dev, HDMI_ISTS_CLK_CHANGE | HDMI_ISTS_PLL_LCK_CHG,
>> +			HDMI_IEN_SET);
>> +	hdmi_writel(dw_dev, ~0x0, HDMI_MD_IEN_SET);
>> +}
>> +
>> +static void dw_hdmi_disable_ints(struct dw_hdmi_dev *dw_dev)
>> +{
>> +	hdmi_writel(dw_dev, ~0x0, HDMI_IEN_CLR);
>> +	hdmi_writel(dw_dev, ~0x0, HDMI_MD_IEN_CLR);
>> +}
>> +
>> +static void dw_hdmi_clear_ints(struct dw_hdmi_dev *dw_dev)
>> +{
>> +	hdmi_writel(dw_dev, ~0x0, HDMI_ICLR);
>> +	hdmi_writel(dw_dev, ~0x0, HDMI_MD_ICLR);
>> +}
>> +
>> +static u8 dw_hdmi_get_curr_vic(struct dw_hdmi_dev *dw_dev)
>> +{
>> +	return hdmi_mask_readl(dw_dev, HDMI_PDEC_AVI_PB,
>> +			HDMI_PDEC_AVI_PB_VID_IDENT_CODE_OFFSET,
>> +			HDMI_PDEC_AVI_PB_VID_IDENT_CODE_MASK) & 0xff;
>> +}
>> +
>> +static u64 dw_hdmi_get_pixelclk(struct dw_hdmi_dev *dw_dev)
>> +{
>> +	u32 rate = hdmi_mask_readl(dw_dev, HDMI_CKM_RESULT,
>> +			HDMI_CKM_RESULT_CLKRATE_OFFSET,
>> +			HDMI_CKM_RESULT_CLKRATE_MASK);
>> +	u32 evaltime = hdmi_mask_readl(dw_dev, HDMI_CKM_EVLTM,
>> +			HDMI_CKM_EVLTM_EVAL_TIME_OFFSET,
>> +			HDMI_CKM_EVLTM_EVAL_TIME_MASK);
>> +	u64 tmp = (u64)rate * (u64)dw_dev->cfg_clk * 1000000;
>> +
>> +	do_div(tmp, evaltime);
>> +	return tmp;
>> +}
>> +
>> +static u32 dw_hdmi_get_colordepth(struct dw_hdmi_dev *dw_dev)
>> +{
>> +	u32 dcm = hdmi_mask_readl(dw_dev, HDMI_STS,
>> +			HDMI_STS_DCM_CURRENT_MODE_OFFSET,
>> +			HDMI_STS_DCM_CURRENT_MODE_MASK);
>> +
>> +	switch (dcm) {
>> +	case 0x4:
>> +		return 24;
>> +	case 0x5:
>> +		return 30;
>> +	case 0x6:
>> +		return 36;
>> +	case 0x7:
>> +		return 48;
>> +	default:
>> +		return 0;
>> +	}
>> +}
>> +
>> +static void dw_hdmi_set_input(struct dw_hdmi_dev *dw_dev, u32 input)
>> +{
>> +	hdmi_mask_writel(dw_dev, input, HDMI_PHY_CTRL,
>> +			HDMI_PHY_CTRL_PORTSELECT_OFFSET,
>> +			HDMI_PHY_CTRL_PORTSELECT_MASK);
>> +}
>> +
>> +static void dw_hdmi_enable_hpd(struct dw_hdmi_dev *dw_dev, u32 input)
>> +{
>> +	switch (input) {
>> +	case 0:
>> +	case 1:
>> +	case 2:
>> +	case 3:
>> +		break;
>> +	default:
>> +		return;
>> +	}
>> +
>> +	hdmi_mask_writel(dw_dev, BIT(input), HDMI_SETUP_CTRL,
>> +			HDMI_SETUP_CTRL_HOT_PLUG_DETECT_INPUT_X_OFFSET,
>> +			HDMI_SETUP_CTRL_HOT_PLUG_DETECT_INPUT_X_MASK);
>> +	hdmi_mask_writel(dw_dev, 0x1, HDMI_SETUP_CTRL,
>> +			HDMI_SETUP_CTRL_HOT_PLUG_DETECT_OFFSET,
>> +			HDMI_SETUP_CTRL_HOT_PLUG_DETECT_MASK);
>> +}
>> +
>> +static void dw_hdmi_disable_hpd(struct dw_hdmi_dev *dw_dev)
>> +{
>> +	hdmi_mask_writel(dw_dev, 0x0, HDMI_SETUP_CTRL,
>> +			HDMI_SETUP_CTRL_HOT_PLUG_DETECT_INPUT_X_OFFSET,
>> +			HDMI_SETUP_CTRL_HOT_PLUG_DETECT_INPUT_X_MASK);
>> +	hdmi_mask_writel(dw_dev, 0x0, HDMI_SETUP_CTRL,
>> +			HDMI_SETUP_CTRL_HOT_PLUG_DETECT_OFFSET,
>> +			HDMI_SETUP_CTRL_HOT_PLUG_DETECT_MASK);
>> +}
>> +
>> +static int dw_hdmi_config(struct dw_hdmi_dev *dw_dev, u32 input)
>> +{
>> +	int eqret, ret = 0;
>> +
>> +	while (1) {
>> +		/* Give up silently if we are forcing off */
>> +		if (dw_dev->force_off) {
>> +			ret = 0;
>> +			goto out;
>> +		}
>> +		/* Give up silently if input has disconnected */
>> +		if (!has_signal(dw_dev, input)) {
>> +			ret = 0;
>> +			goto out;
>> +		}
>> +
>> +		switch (dw_dev->state) {
>> +		case HDMI_STATE_POWER_OFF:
>> +			dw_hdmi_disable_ints(dw_dev);
>> +			dw_hdmi_set_state(dw_dev, HDMI_STATE_PHY_CONFIG);
>> +			break;
>> +		case HDMI_STATE_PHY_CONFIG:
>> +			dw_hdmi_phy_s_power(dw_dev, true);
>> +			dw_hdmi_phy_config(dw_dev, 8, false, false);
>> +			dw_hdmi_set_state(dw_dev, HDMI_STATE_CONTROLLER_CONFIG);
>> +			break;
>> +		case HDMI_STATE_CONTROLLER_CONFIG:
>> +			dw_hdmi_set_input(dw_dev, input);
>> +			dw_hdmi_enable_hpd(dw_dev, input);
>> +			dw_hdmi_set_state(dw_dev, HDMI_STATE_EQUALIZER);
>> +			break;
>> +		case HDMI_STATE_EQUALIZER:
>> +			eqret = dw_hdmi_phy_eq_init(dw_dev, 5,
>> +					dw_dev->phy_eq_force);
>> +			ret = dw_hdmi_wait_phy_lock_poll(dw_dev);
>> +
>> +			/* Do not force equalizer */
>> +			dw_dev->phy_eq_force = false;
>> +
>> +			if (ret || eqret) {
>> +				if (ret || eqret == -ETIMEDOUT) {
>> +					/* No TMDSVALID signal:
>> +					 * 	- force equalizer */
>> +					dw_dev->phy_eq_force = true;
>> +				}
>> +				break;
>> +			}
>> +
>> +			dw_hdmi_set_state(dw_dev, HDMI_STATE_VIDEO_UNSTABLE);
>> +			break;
>> +		case HDMI_STATE_VIDEO_UNSTABLE:
>> +			dw_hdmi_reset_datapath(dw_dev);
>> +			dw_hdmi_enable_ints(dw_dev);
>> +			dw_hdmi_set_state(dw_dev, HDMI_STATE_POWER_ON);
>> +			break;
>> +		case HDMI_STATE_POWER_ON:
>> +			break;
>> +		default:
>> +			dev_err(dw_dev->dev, "%s called with state (%d)\n",
>> +					__func__, dw_dev->state);
>> +			ret = -EINVAL;
>> +			goto out;
>> +		}
>> +
>> +		if (dw_dev->state == HDMI_STATE_POWER_ON) {
>> +			dev_info(dw_dev->dev, "HDMI-RX configured\n");
>> +			v4l2_subdev_notify_event(&dw_dev->sd,
>> +					&dw_hdmi_event_fmt);
> Whenever you lose the signal, you also have to send this event. It informs userspace
> when there is a stable signal, or when that stable signal disappears.

Ok.

>
>> +			return 0;
>> +		}
>> +	}
>> +
>> +out:
>> +	dw_hdmi_set_state(dw_dev, HDMI_STATE_POWER_OFF);
>> +	return ret;
>> +}
>> +
>> +static int dw_hdmi_config_hdcp(struct dw_hdmi_dev *dw_dev)
>> +{
>> +	hdmi_mask_writel(dw_dev, 0x0, HDMI_HDCP22_CONTROL,
>> +			HDMI_HDCP22_CONTROL_OVR_VAL_OFFSET,
>> +			HDMI_HDCP22_CONTROL_OVR_VAL_MASK);
>> +	hdmi_mask_writel(dw_dev, 0x1, HDMI_HDCP22_CONTROL,
>> +			HDMI_HDCP22_CONTROL_OVR_EN_OFFSET,
>> +			HDMI_HDCP22_CONTROL_OVR_EN_MASK);
>> +	return 0;
>> +}
>> +
>> +static int __dw_hdmi_power_on(struct dw_hdmi_dev *dw_dev, u32 input)
>> +{
>> +	unsigned long flags;
>> +	int ret;
>> +
>> +	ret = dw_hdmi_config(dw_dev, input);
>> +
>> +	spin_lock_irqsave(&dw_dev->lock, flags);
>> +	dw_dev->pending_config = false;
>> +	spin_unlock_irqrestore(&dw_dev->lock, flags);
>> +
>> +	return ret;
>> +}
>> +
>> +struct dw_hdmi_work_data {
>> +	struct dw_hdmi_dev *dw_dev;
>> +	struct work_struct work;
>> +	u32 input;
>> +};
>> +
>> +static void dw_hdmi_work_handler(struct work_struct *work)
>> +{
>> +	struct dw_hdmi_work_data *data = container_of(work,
>> +			struct dw_hdmi_work_data, work);
>> +
>> +	__dw_hdmi_power_on(data->dw_dev, data->input);
>> +	devm_kfree(data->dw_dev->dev, data);
>> +}
>> +
>> +static int dw_hdmi_power_on(struct dw_hdmi_dev *dw_dev, u32 input)
>> +{
>> +	struct dw_hdmi_work_data *data;
>> +	unsigned long flags;
>> +
>> +	data = devm_kzalloc(dw_dev->dev, sizeof(*data), GFP_KERNEL);
>> +	if (!data)
>> +		return -ENOMEM;
>> +
>> +	INIT_WORK(&data->work, dw_hdmi_work_handler);
>> +	data->dw_dev = dw_dev;
>> +	data->input = input;
>> +
>> +	spin_lock_irqsave(&dw_dev->lock, flags);
>> +	if (dw_dev->pending_config) {
>> +		devm_kfree(dw_dev->dev, data);
>> +		spin_unlock_irqrestore(&dw_dev->lock, flags);
>> +		return 0;
>> +	}
>> +
>> +	queue_work(dw_dev->wq, &data->work);
>> +	dw_dev->pending_config = true;
>> +	spin_unlock_irqrestore(&dw_dev->lock, flags);
>> +	return 0;
>> +}
>> +
>> +static void dw_hdmi_power_off(struct dw_hdmi_dev *dw_dev)
>> +{
>> +	unsigned long flags;
>> +
>> +	dw_dev->force_off = true;
>> +	flush_workqueue(dw_dev->wq);
>> +	dw_dev->force_off = false;
>> +
>> +	spin_lock_irqsave(&dw_dev->lock, flags);
>> +	dw_dev->pending_config = false;
>> +	dw_dev->state = HDMI_STATE_POWER_OFF;
>> +	spin_unlock_irqrestore(&dw_dev->lock, flags);
>> +
>> +	/* Reset variables */
>> +	dw_dev->phy_eq_force = true;
>> +}
>> +
>> +static u32 dw_hdmi_get_int_val(struct dw_hdmi_dev *dw_dev, u32 ists, u32 ien)
>> +{
>> +	return hdmi_readl(dw_dev, ists) & hdmi_readl(dw_dev, ien);
>> +}
>> +
>> +static irqreturn_t dw_hdmi_irq_handler(int irq, void *dev_data)
>> +{
>> +	struct dw_hdmi_dev *dw_dev = dev_data;
>> +	u32 hdmi_ists = dw_hdmi_get_int_val(dw_dev, HDMI_ISTS, HDMI_IEN);
>> +	u32 md_ists = dw_hdmi_get_int_val(dw_dev, HDMI_MD_ISTS, HDMI_MD_IEN);
>> +
>> +	dw_hdmi_clear_ints(dw_dev);
>> +
>> +	if ((hdmi_ists & HDMI_ISTS_CLK_CHANGE) ||
>> +	    (hdmi_ists & HDMI_ISTS_PLL_LCK_CHG) || md_ists) {
>> +		dw_hdmi_power_off(dw_dev);
>> +		if (has_signal(dw_dev, dw_dev->configured_input))
>> +			dw_hdmi_power_on(dw_dev, dw_dev->configured_input);
>> +	}
>> +
>> +	return IRQ_HANDLED;
>> +}
>> +
>> +static void dw_hdmi_detect_tx_5v(struct dw_hdmi_dev *dw_dev)
>> +{
>> +	unsigned int input_count = 4; /* TODO: Get from DT node this value */
>> +	unsigned int old_input = dw_dev->configured_input;
>> +	unsigned int new_input = old_input;
>> +	bool pending_config = false, current_on = true;
>> +	int i;
>> +
>> +	if (!has_signal(dw_dev, old_input)) {
>> +		dw_hdmi_disable_ints(dw_dev);
>> +		dw_hdmi_disable_hpd(dw_dev);
>> +		dw_hdmi_power_off(dw_dev);
>> +		current_on = false;
>> +	}
>> +
>> +	for (i = 0; i < input_count; i++) {
>> +		bool on = has_signal(dw_dev, i);
>> +
>> +		if (is_off(dw_dev) && on && !pending_config) {
>> +			dw_hdmi_power_on(dw_dev, i);
>> +			new_input = i;
>> +			pending_config = true;
>> +		}
>> +	}
>> +
>> +	if ((new_input == old_input) && !pending_config && !current_on)
>> +		dw_hdmi_phy_s_power(dw_dev, false);
>> +
>> +	dev_dbg(dw_dev->dev, "%s: %d%d%d%d\n", __func__,
>> +			dw_hdmi_5v_status(dw_dev, 0),
>> +			dw_hdmi_5v_status(dw_dev, 1),
>> +			dw_hdmi_5v_status(dw_dev, 2),
>> +			dw_hdmi_5v_status(dw_dev, 3));
>> +}
>> +
>> +static irqreturn_t dw_hdmi_5v_irq_handler(int irq, void *dev_data)
>> +{
>> +	struct dw_hdmi_dev *dw_dev = dev_data;
>> +
>> +	dw_hdmi_detect_tx_5v(dw_dev);
>> +	return IRQ_HANDLED;
>> +}
>> +
>> +static irqreturn_t dw_hdmi_5v_hard_irq_handler(int irq, void *dev_data)
>> +{
>> +	struct dw_hdmi_dev *dw_dev = dev_data;
>> +
>> +	dev_dbg(dw_dev->dev, "%s\n", __func__);
>> +	dw_hdmi_5v_clear(dw_dev);
>> +	return IRQ_WAKE_THREAD;
>> +}
>> +
>> +static int dw_hdmi_s_routing(struct v4l2_subdev *sd, u32 input, u32 output,
>> +		u32 config)
>> +{
>> +	struct dw_hdmi_dev *dw_dev = to_dw_dev(sd);
>> +
>> +	if (!has_signal(dw_dev, input))
>> +		return -EINVAL;
>> +
>> +	dw_dev->selected_input = input;
>> +	if (input == dw_dev->configured_input)
>> +		return 0;
>> +
>> +	dw_hdmi_power_off(dw_dev);
>> +	return dw_hdmi_power_on(dw_dev, input);
>> +}
>> +
>> +static int dw_hdmi_g_input_status(struct v4l2_subdev *sd, u32 *status)
>> +{
>> +	struct dw_hdmi_dev *dw_dev = to_dw_dev(sd);
>> +
>> +	*status = 0;
>> +	if (!has_signal(dw_dev, dw_dev->selected_input))
>> +		*status |= V4L2_IN_ST_NO_POWER;
>> +	if (is_off(dw_dev))
>> +		*status |= V4L2_IN_ST_NO_SIGNAL;
>> +
>> +	dev_dbg(dw_dev->dev, "%s: status=0x%x\n", __func__, *status);
>> +	return 0;
>> +}
>> +
>> +static int dw_hdmi_g_parm(struct v4l2_subdev *sd, struct v4l2_streamparm *parm)
>> +{
>> +	struct dw_hdmi_dev *dw_dev = to_dw_dev(sd);
>> +
>> +	dev_dbg(dw_dev->dev, "%s\n", __func__);
>> +
>> +	/* TODO: Use helper to compute timeperframe */
>> +	parm->parm.capture.timeperframe.numerator = 1;
>> +	parm->parm.capture.timeperframe.denominator = 60;
>> +	return 0;
>> +}
>> +
>> +static int dw_hdmi_g_dv_timings(struct v4l2_subdev *sd,
>> +		struct v4l2_dv_timings *timings)
>> +{
>> +	struct dw_hdmi_dev *dw_dev = to_dw_dev(sd);
>> +
>> +	dev_dbg(dw_dev->dev, "%s\n", __func__);
>> +
>> +	memset(timings, 0, sizeof(*timings));
> This is pointless since *timings is overwritten by the next assignment.
>
>> +	*timings = dw_dev->timings;
>> +	return 0;
>> +}
>> +
>> +static int dw_hdmi_query_dv_timings(struct v4l2_subdev *sd,
>> +		struct v4l2_dv_timings *timings)
>> +{
>> +	struct dw_hdmi_dev *dw_dev = to_dw_dev(sd);
>> +	struct v4l2_bt_timings *bt = &timings->bt;
>> +	u32 htot, hofs;
>> +	u32 vtot;
>> +	u8 vic;
>> +
>> +	dev_dbg(dw_dev->dev, "%s\n", __func__);
>> +
>> +	memset(timings, 0, sizeof(*timings));
>> +
>> +	timings->type = V4L2_DV_BT_656_1120;
>> +	bt->width = hdmi_readl(dw_dev, HDMI_MD_HACT_PX);
>> +	bt->height = hdmi_readl(dw_dev, HDMI_MD_VAL);
>> +	bt->interlaced = 0;
> There is no interlaced support? Most receivers can at least detect it.

The controller supports interlaced, unfortunately there is no way
I can test it, so we chose not to add it in the driver.

>
>> +
>> +	if (hdmi_readl(dw_dev, HDMI_ISTS) & HDMI_ISTS_VS_POL_ADJ)
>> +		bt->polarities |= V4L2_DV_VSYNC_POS_POL;
>> +	if (hdmi_readl(dw_dev, HDMI_ISTS) & HDMI_ISTS_HS_POL_ADJ)
>> +		bt->polarities |= V4L2_DV_HSYNC_POS_POL;
>> +
>> +	bt->pixelclock = dw_hdmi_get_pixelclk(dw_dev);
> Can this be rounded up to a value above 594 MHz? In the timings cap that
> is the max frequency, but you probably need to allow for a bit of margin there
> in case you measure e.g. 594050000 Hz.

Hmm, yeah, probably it can. Actually the timings cap may not be
correct because we support deep color in 4k, so freq will be >
594MHz.

>
>> +
>> +	/* HTOT = HACT + HFRONT + HSYNC + HBACK */
>> +	htot = hdmi_mask_readl(dw_dev, HDMI_MD_HT1,
>> +			HDMI_MD_HT1_HTOT_PIX_OFFSET,
>> +			HDMI_MD_HT1_HTOT_PIX_MASK);
>> +	/* HOFS = HSYNC + HBACK */
>> +	hofs = hdmi_mask_readl(dw_dev, HDMI_MD_HT1,
>> +			HDMI_MD_HT1_HOFS_PIX_OFFSET,
>> +			HDMI_MD_HT1_HOFS_PIX_MASK);
>> +
>> +	bt->hfrontporch = htot - hofs - bt->width;
>> +	bt->hsync = hdmi_mask_readl(dw_dev, HDMI_MD_HT0,
>> +			HDMI_MD_HT0_HS_CLK_OFFSET,
>> +			HDMI_MD_HT0_HS_CLK_MASK);
>> +	bt->hbackporch = hofs - bt->hsync;
>> +
>> +	/* VTOT = VACT + VFRONT + VSYNC + VBACK */
>> +	vtot = hdmi_readl(dw_dev, HDMI_MD_VTL);
>> +
>> +	hdmi_mask_writel(dw_dev, 0x1, HDMI_MD_VCTRL,
>> +			HDMI_MD_VCTRL_V_OFFS_LIN_MODE_OFFSET,
>> +			HDMI_MD_VCTRL_V_OFFS_LIN_MODE_MASK);
>> +	mdelay(50);
>> +	bt->vsync = hdmi_readl(dw_dev, HDMI_MD_VOL);
>> +
>> +	hdmi_mask_writel(dw_dev, 0x0, HDMI_MD_VCTRL,
>> +			HDMI_MD_VCTRL_V_OFFS_LIN_MODE_OFFSET,
>> +			HDMI_MD_VCTRL_V_OFFS_LIN_MODE_MASK);
>> +	mdelay(50);
>> +	bt->vbackporch = hdmi_readl(dw_dev, HDMI_MD_VOL);
>> +	bt->vfrontporch = vtot - bt->height - bt->vsync - bt->vbackporch;
>> +	bt->standards = V4L2_DV_BT_STD_CEA861;
>> +
>> +	vic = dw_hdmi_get_curr_vic(dw_dev);
>> +	if (vic) {
>> +		bt->flags |= V4L2_DV_FL_HAS_CEA861_VIC;
>> +		bt->cea861_vic = vic;
> You also need to handle the HDMI VIC case for 4kp30 among others.

Ok.

>
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int dw_hdmi_enum_mbus_code(struct v4l2_subdev *sd,
>> +		struct v4l2_subdev_pad_config *cfg,
>> +		struct v4l2_subdev_mbus_code_enum *code)
>> +{
>> +	struct dw_hdmi_dev *dw_dev = to_dw_dev(sd);
>> +
>> +	dev_dbg(dw_dev->dev, "%s\n", __func__);
>> +	if (code->index != 0)
>> +		return -EINVAL;
>> +
>> +	code->code = dw_dev->mbus_code;
>> +	return 0;
>> +}
>> +
>> +static int dw_hdmi_fill_format(struct dw_hdmi_dev *dw_dev,
>> +		struct v4l2_mbus_framefmt *format)
>> +{
>> +	memset(format, 0, sizeof(*format));
>> +
>> +	format->width = dw_dev->timings.bt.width;
>> +	format->height = dw_dev->timings.bt.height;
>> +	format->colorspace = V4L2_COLORSPACE_SRGB;
>> +	format->code = dw_dev->mbus_code;
>> +	if (dw_dev->timings.bt.interlaced)
>> +		format->field = V4L2_FIELD_ALTERNATE;
>> +	else
>> +		format->field = V4L2_FIELD_NONE;
>> +
>> +	return 0;
>> +}
>> +
>> +static int dw_hdmi_get_fmt(struct v4l2_subdev *sd,
>> +		struct v4l2_subdev_pad_config *cfg,
>> +		struct v4l2_subdev_format *format)
>> +{
>> +	struct dw_hdmi_dev *dw_dev = to_dw_dev(sd);
>> +
>> +	dev_dbg(dw_dev->dev, "%s\n", __func__);
>> +	return dw_hdmi_fill_format(dw_dev, &format->format);
>> +}
>> +
>> +static int dw_hdmi_set_fmt(struct v4l2_subdev *sd,
>> +		struct v4l2_subdev_pad_config *cfg,
>> +		struct v4l2_subdev_format *format)
>> +{
>> +	struct dw_hdmi_dev *dw_dev = to_dw_dev(sd);
>> +
>> +	dev_dbg(dw_dev->dev, "%s\n", __func__);
>> +
>> +	if (format->format.code != dw_dev->mbus_code) {
>> +		dev_dbg(dw_dev->dev, "invalid format\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	return dw_hdmi_get_fmt(sd, cfg, format);
>> +}
>> +
>> +static int dw_hdmi_dv_timings_cap(struct v4l2_subdev *sd,
>> +		struct v4l2_dv_timings_cap *cap)
>> +{
>> +	struct dw_hdmi_dev *dw_dev = to_dw_dev(sd);
>> +	unsigned int pad = cap->pad;
>> +
>> +	dev_dbg(dw_dev->dev, "%s\n", __func__);
>> +
>> +	*cap = dw_hdmi_timings_cap;
>> +	cap->pad = pad;
>> +	return 0;
>> +}
>> +
>> +static bool dw_hdmi_check_dv_timings(const struct v4l2_dv_timings *t, void *hdl)
>> +{
>> +	return true;
>> +}
>> +
>> +static int dw_hdmi_enum_dv_timings(struct v4l2_subdev *sd,
>> +		struct v4l2_enum_dv_timings *timings)
>> +{
>> +	struct dw_hdmi_dev *dw_dev = to_dw_dev(sd);
>> +
>> +	dev_dbg(dw_dev->dev, "%s\n", __func__);
>> +	return v4l2_enum_dv_timings_cap(timings, &dw_hdmi_timings_cap,
>> +			dw_hdmi_check_dv_timings, NULL);
> dw_hdmi_check_dv_timings can just be NULL here. No need to provide it if
> it always returns true.

Ok.

>
>> +}
>> +
>> +static int dw_hdmi_log_status(struct v4l2_subdev *sd)
>> +{
>> +	struct dw_hdmi_dev *dw_dev = to_dw_dev(sd);
>> +	struct v4l2_dv_timings timings;
>> +
>> +	v4l2_info(sd, "--- Chip configuration ---\n");
>> +	v4l2_info(sd, "cfg_clk=%dMHz\n", dw_dev->cfg_clk);
>> +	v4l2_info(sd, "phy_drv=%s, phy_jtag_addr=0x%x\n", dw_dev->phy_drv,
>> +			dw_dev->phy_jtag_addr);
>> +	v4l2_info(sd, "--- Chip status ---\n");
>> +	v4l2_info(sd, "selected_input=%d: signal=%d\n", dw_dev->selected_input,
>> +			has_signal(dw_dev, dw_dev->selected_input));
>> +	v4l2_info(sd, "configured_input=%d: signal=%d\n",
>> +			dw_dev->configured_input,
>> +			has_signal(dw_dev, dw_dev->configured_input));
>> +	v4l2_info(sd, "--- Video status ---\n");
>> +	v4l2_info(sd, "type=%s\n, color_depth=%dbits",
>> +			hdmi_readl(dw_dev, HDMI_PDEC_STS) &
>> +			HDMI_PDEC_STS_DVIDET ? "dvi" : "hdmi",
>> +			dw_hdmi_get_colordepth(dw_dev));
>> +	v4l2_info(sd, "--- Video timings ---\n");
>> +	if (dw_hdmi_query_dv_timings(sd, &timings))
>> +		v4l2_info(sd, "No video detected\n");
>> +	else
>> +		v4l2_print_dv_timings(sd->name, "Detected format: ",
>> +				&timings, true);
>> +	v4l2_print_dv_timings(sd->name, "Configured format: ",
>> +			&dw_dev->timings, true);
>> +	return 0;
>> +}
>> +
>> +#ifdef CONFIG_VIDEO_ADV_DEBUG
>> +static void dw_hdmi_invalid_register(struct dw_hdmi_dev *dw_dev, u64 reg)
>> +{
>> +	dev_err(dw_dev->dev, "register 0x%llx not supported\n", reg);
>> +	dev_err(dw_dev->dev, "0x0000-0x7fff: Main controller map\n");
>> +	dev_err(dw_dev->dev, "0x8000-0x80ff: PHY map\n");
>> +}
>> +
>> +static int dw_hdmi_g_register(struct v4l2_subdev *sd,
>> +		struct v4l2_dbg_register *reg)
>> +{
>> +	struct dw_hdmi_dev *dw_dev = to_dw_dev(sd);
>> +
>> +	switch (reg->reg >> 15) {
>> +	case 0: /* Controller core read */
>> +		reg->size = 4;
>> +		reg->val = hdmi_readl(dw_dev, reg->reg & 0x7fff);
>> +		return 0;
>> +	case 1: /* PHY read */
>> +		if ((reg->reg & ~0xff) != BIT(15))
>> +			break;
>> +
>> +		reg->size = 2;
>> +		reg->val = dw_hdmi_phy_read(dw_dev, reg->reg & 0xff);
>> +		return 0;
>> +	default:
>> +		break;
>> +	}
>> +
>> +	dw_hdmi_invalid_register(dw_dev, reg->reg);
>> +	return 0;
>> +}
>> +
>> +static int dw_hdmi_s_register(struct v4l2_subdev *sd,
>> +		const struct v4l2_dbg_register *reg)
>> +{
>> +	struct dw_hdmi_dev *dw_dev = to_dw_dev(sd);
>> +
>> +	switch (reg->reg >> 15) {
>> +	case 0: /* Controller core write */
>> +		hdmi_writel(dw_dev, reg->val & GENMASK(31,0), reg->reg & 0x7fff);
>> +		return 0;
>> +	case 1: /* PHY write */
>> +		if ((reg->reg & ~0xff) != BIT(15))
>> +			break;
>> +		dw_hdmi_phy_write(dw_dev, reg->val & 0xffff, reg->reg & 0xff);
>> +		return 0;
>> +	default:
>> +		break;
>> +	}
> Be careful here: if you support HDCP, then you typically don't want to allow
> userspace to touch any HDCP-related registers through this API.

Yeah, HDCP is supported but still not implemented. Still, the
only thing the user will be able to change will be bksv because
keys can not be read, they are write only. I will add a check though.

Best regards,
Jose Miguel Abreu

>
>> +
>> +	dw_hdmi_invalid_register(dw_dev, reg->reg);
>> +	return 0;
>> +}
>> +#endif
>> +
>> +static int dw_hdmi_subscribe_event(struct v4l2_subdev *sd, struct v4l2_fh *fh,
>> +		struct v4l2_event_subscription *sub)
>> +{
>> +	switch (sub->type) {
>> +	case V4L2_EVENT_SOURCE_CHANGE:
>> +		return v4l2_src_change_event_subdev_subscribe(sd, fh, sub);
>> +	default:
>> +		return -EINVAL;
>> +	}
>> +}
>> +
>> +static const struct v4l2_subdev_core_ops dw_hdmi_sd_core_ops = {
>> +	.log_status = dw_hdmi_log_status,
>> +#ifdef CONFIG_VIDEO_ADV_DEBUG
>> +	.g_register = dw_hdmi_g_register,
>> +	.s_register = dw_hdmi_s_register,
>> +#endif
>> +	.subscribe_event = dw_hdmi_subscribe_event,
>> +};
>> +
>> +static const struct v4l2_subdev_video_ops dw_hdmi_sd_video_ops = {
>> +	.s_routing = dw_hdmi_s_routing,
>> +	.g_input_status = dw_hdmi_g_input_status,
>> +	.g_parm = dw_hdmi_g_parm,
>> +	.g_dv_timings = dw_hdmi_g_dv_timings,
>> +	.query_dv_timings = dw_hdmi_query_dv_timings,
>> +};
>> +
>> +static const struct v4l2_subdev_pad_ops dw_hdmi_sd_pad_ops = {
>> +	.enum_mbus_code = dw_hdmi_enum_mbus_code,
>> +	.get_fmt = dw_hdmi_get_fmt,
>> +	.set_fmt = dw_hdmi_set_fmt,
>> +	.dv_timings_cap = dw_hdmi_dv_timings_cap,
>> +	.enum_dv_timings = dw_hdmi_enum_dv_timings,
>> +};
>> +
>> +static const struct v4l2_subdev_ops dw_hdmi_sd_ops = {
>> +	.core = &dw_hdmi_sd_core_ops,
>> +	.video = &dw_hdmi_sd_video_ops,
>> +	.pad = &dw_hdmi_sd_pad_ops,
>> +};
>> +
>> +static int dw_hdmi_parse_dt(struct dw_hdmi_dev *dw_dev)
>> +{
>> +	struct dw_phy_pdata *phy = &dw_dev->phy_config;
>> +	struct device_node *np = dw_dev->of_node;
>> +
>> +	if (!np) {
>> +		dev_err(dw_dev->dev, "missing DT node\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	/* PHY properties parsing */
>> +	of_property_read_u8(np, "snps,hdmi-phy-jtag-addr",
>> +			&dw_dev->phy_jtag_addr);
>> +	if (!dw_dev->phy_jtag_addr) {
>> +		dev_err(dw_dev->dev, "missing hdmi-phy-jtag-addr in DT\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	of_property_read_u32(np, "snps,hdmi-phy-version", &phy->version);
>> +	if (!phy->version) {
>> +		dev_err(dw_dev->dev, "missing hdmi-phy-version in DT\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	of_property_read_u32(np, "snps,hdmi-phy-cfg-clk", &phy->cfg_clk);
>> +	if (!phy->cfg_clk) {
>> +		dev_err(dw_dev->dev, "missing hdmi-phy-cfg-clk in DT\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	if (of_property_read_string_index(np, "snps,hdmi-phy-driver", 0,
>> +				&dw_dev->phy_drv) < 0) {
>> +		dev_err(dw_dev->dev, "missing hdmi-phy-driver in DT\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	/* Controller properties parsing */
>> +	of_property_read_u32(np, "snps,hdmi-ctl-cfg-clk", &dw_dev->cfg_clk);
>> +	if (!dw_dev->cfg_clk) {
>> +		dev_err(dw_dev->dev, "missing hdmi-ctl-cfg-clk in DT\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int dw_hdmi_rx_probe(struct platform_device *pdev)
>> +{
>> +	const struct v4l2_dv_timings timings_def = HDMI_DEFAULT_TIMING;
>> +	struct dw_hdmi_rx_pdata *pdata = pdev->dev.platform_data;
>> +	struct device *dev = &pdev->dev;
>> +	struct dw_hdmi_dev *dw_dev;
>> +	struct v4l2_subdev *sd;
>> +	struct resource *res;
>> +	int ret, irq;
>> +
>> +	dev_dbg(dev, "%s\n", __func__);
>> +
>> +	/* Resource allocation */
>> +	dw_dev = devm_kzalloc(dev, sizeof(*dw_dev), GFP_KERNEL);
>> +	if (!dw_dev)
>> +		return -ENOMEM;
>> +
>> +	/* Resource initialization */
>> +	if (!pdata) {
>> +		dev_err(dev, "missing platform data\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	dw_dev->dev = dev;
>> +	dw_dev->config = pdata;
>> +	dw_dev->state = HDMI_STATE_NO_INIT;
>> +	dw_dev->of_node = dev->of_node ? dev->of_node : dev->parent->of_node;
>> +	spin_lock_init(&dw_dev->lock);
>> +
>> +	/* Device Tree parsing */
>> +	ret = dw_hdmi_parse_dt(dw_dev);
>> +	if (ret)
>> +		return ret;
>> +
>> +	/* Deferred work */
>> +	dw_dev->wq = create_workqueue(DW_HDMI_RX_DRVNAME);
>> +	if (!dw_dev->wq)
>> +		return -ENOMEM;
>> +
>> +	/* Registers mapping */
>> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +	if (!res) {
>> +		ret = -ENXIO;
>> +		goto err_wq;
>> +	}
>> +
>> +	dw_dev->regs = devm_ioremap_resource(dev, res);
>> +	if (IS_ERR(dw_dev->regs)) {
>> +		ret = PTR_ERR(dw_dev->regs);
>> +		goto err_wq;
>> +	}
>> +
>> +	/* Disable HPD as soon as posssible */
>> +	dw_hdmi_disable_hpd(dw_dev);
>> +
>> +	/* Configure HDCP */
>> +	ret = dw_hdmi_config_hdcp(dw_dev);
>> +	if (ret)
>> +		goto err_wq;
>> +
>> +	/* Interrupts mapping */
>> +	irq = platform_get_irq(pdev, 0);
>> +	if (irq < 0) {
>> +		ret = irq;
>> +		goto err_wq;
>> +	}
>> +
>> +	ret = devm_request_threaded_irq(dev, irq, NULL, dw_hdmi_irq_handler,
>> +			IRQF_ONESHOT, DW_HDMI_RX_DRVNAME, dw_dev);
>> +	if (ret)
>> +		goto err_wq;
>> +
>> +	irq = platform_get_irq(pdev, 1);
>> +	if (irq < 0) {
>> +		ret = irq;
>> +		goto err_wq;
>> +	}
>> +
>> +	ret = devm_request_threaded_irq(dev, irq, dw_hdmi_5v_hard_irq_handler,
>> +			dw_hdmi_5v_irq_handler, IRQF_ONESHOT,
>> +			DW_HDMI_RX_DRVNAME "-5v-handler", dw_dev);
>> +	if (ret)
>> +		goto err_wq;
>> +
>> +	/* V4L2 initialization */
>> +	sd = &dw_dev->sd;
>> +	v4l2_subdev_init(sd, &dw_hdmi_sd_ops);
>> +	strlcpy(sd->name, DW_HDMI_RX_DRVNAME, sizeof(sd->name));
>> +	sd->flags |= V4L2_SUBDEV_FL_HAS_EVENTS;
>> +
>> +	/* V4L2 device for phy subdev */
>> +	strlcpy(dw_dev->v4l2_dev.name, DW_HDMI_RX_DRVNAME,
>> +			sizeof(dw_dev->v4l2_dev.name));
>> +	ret = v4l2_device_register(NULL, &dw_dev->v4l2_dev);
>> +	if (ret) {
>> +		dev_err(dev, "failed to register v4l2 device\n");
>> +		goto err_wq;
>> +	}
>> +
>> +	/* Phy loading */
>> +	ret = dw_hdmi_phy_init(dw_dev);
>> +	if (ret)
>> +		goto err_v4l2_dev;
>> +
>> +	/* Fill initial format settings */
>> +	dw_dev->timings = timings_def;
>> +	dw_dev->mbus_code = MEDIA_BUS_FMT_BGR888_1X24;
>> +
>> +	/* All done */
>> +	dev_set_drvdata(dev, sd);
>> +	dw_dev->state = HDMI_STATE_POWER_OFF;
>> +	dw_hdmi_detect_tx_5v(dw_dev);
>> +	dev_info(dev, "driver probed\n");
>> +	return 0;
>> +
>> +err_v4l2_dev:
>> +	v4l2_device_unregister(&dw_dev->v4l2_dev);
>> +err_wq:
>> +	destroy_workqueue(dw_dev->wq);
>> +	return ret;
>> +}
>> +
>> +static int dw_hdmi_rx_remove(struct platform_device *pdev)
>> +{
>> +	struct device *dev = &pdev->dev;
>> +	struct v4l2_subdev *sd = dev_get_drvdata(dev);
>> +	struct dw_hdmi_dev *dw_dev = to_dw_dev(sd);
>> +
>> +	dev_dbg(dev, "%s\n", __func__);
>> +
>> +	dw_hdmi_disable_ints(dw_dev);
>> +	dw_hdmi_disable_hpd(dw_dev);
>> +	dw_hdmi_power_off(dw_dev);
>> +	dw_hdmi_phy_s_power(dw_dev, false);
>> +	flush_workqueue(dw_dev->wq);
>> +	destroy_workqueue(dw_dev->wq);
>> +	v4l2_device_unregister(&dw_dev->v4l2_dev);
>> +	dw_hdmi_phy_exit(dw_dev);
>> +	dev_info(dev, "driver removed\n");
>> +	return 0;
>> +}
>> +
>> +static struct platform_driver dw_hdmi_rx_driver = {
>> +	.probe = dw_hdmi_rx_probe,
>> +	.remove = dw_hdmi_rx_remove,
>> +	.driver = {
>> +		.name = DW_HDMI_RX_DRVNAME,
>> +	}
>> +};
>> +module_platform_driver(dw_hdmi_rx_driver);
> <snip>
>
> Regards,
>
> 	Hans
