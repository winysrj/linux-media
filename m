Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39448 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752154AbdHJItT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Aug 2017 04:49:19 -0400
Subject: Re: [PATCH 4/4] drm: adv7511/33: add HDMI CEC support
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>,
        Hans Verkuil <hans.verkuil@cisco.com>
References: <20170730130743.19681-1-hverkuil@xs4all.nl>
 <20170730130743.19681-5-hverkuil@xs4all.nl>
From: Archit Taneja <architt@codeaurora.org>
Message-ID: <811a3e0c-d938-744e-2d1d-46be76b708aa@codeaurora.org>
Date: Thu, 10 Aug 2017 14:19:10 +0530
MIME-Version: 1.0
In-Reply-To: <20170730130743.19681-5-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 07/30/2017 06:37 PM, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Add support for HDMI CEC to the drm adv7511/adv7533 drivers.
> 
> The CEC registers that we need to use are identical for both drivers,
> but they appear at different offsets in the register map.

Thanks for the patch. Some minor comments below.

> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>   drivers/gpu/drm/bridge/adv7511/Kconfig       |   8 +
>   drivers/gpu/drm/bridge/adv7511/Makefile      |   1 +
>   drivers/gpu/drm/bridge/adv7511/adv7511.h     |  45 +++-
>   drivers/gpu/drm/bridge/adv7511/adv7511_cec.c | 314 +++++++++++++++++++++++++++
>   drivers/gpu/drm/bridge/adv7511/adv7511_drv.c | 152 +++++++++++--
>   drivers/gpu/drm/bridge/adv7511/adv7533.c     |  30 +--
>   6 files changed, 500 insertions(+), 50 deletions(-)
>   create mode 100644 drivers/gpu/drm/bridge/adv7511/adv7511_cec.c
> 
> diff --git a/drivers/gpu/drm/bridge/adv7511/Kconfig b/drivers/gpu/drm/bridge/adv7511/Kconfig
> index 2fed567f9943..592b9d2ec034 100644
> --- a/drivers/gpu/drm/bridge/adv7511/Kconfig
> +++ b/drivers/gpu/drm/bridge/adv7511/Kconfig
> @@ -21,3 +21,11 @@ config DRM_I2C_ADV7533
>   	default y
>   	help
>   	  Support for the Analog Devices ADV7533 DSI to HDMI encoder.
> +
> +config DRM_I2C_ADV7511_CEC
> +	bool "ADV7511/33 HDMI CEC driver"
> +	depends on DRM_I2C_ADV7511
> +	select CEC_CORE
> +	default y
> +	help
> +	  When selected the HDMI transmitter will support the CEC feature.
> diff --git a/drivers/gpu/drm/bridge/adv7511/Makefile b/drivers/gpu/drm/bridge/adv7511/Makefile
> index 5ba675534f6e..5bb384938a71 100644
> --- a/drivers/gpu/drm/bridge/adv7511/Makefile
> +++ b/drivers/gpu/drm/bridge/adv7511/Makefile
> @@ -1,4 +1,5 @@
>   adv7511-y := adv7511_drv.o
>   adv7511-$(CONFIG_DRM_I2C_ADV7511_AUDIO) += adv7511_audio.o
> +adv7511-$(CONFIG_DRM_I2C_ADV7511_CEC) += adv7511_cec.o
>   adv7511-$(CONFIG_DRM_I2C_ADV7533) += adv7533.o
>   obj-$(CONFIG_DRM_I2C_ADV7511) += adv7511.o
> diff --git a/drivers/gpu/drm/bridge/adv7511/adv7511.h b/drivers/gpu/drm/bridge/adv7511/adv7511.h
> index fe18a5d2d84b..4fd7b14f619b 100644
> --- a/drivers/gpu/drm/bridge/adv7511/adv7511.h
> +++ b/drivers/gpu/drm/bridge/adv7511/adv7511.h
> @@ -195,6 +195,25 @@
>   #define ADV7511_PACKET_GM(x)	    ADV7511_PACKET(5, x)
>   #define ADV7511_PACKET_SPARE(x)	    ADV7511_PACKET(6, x)
>   
> +#define ADV7511_REG_CEC_TX_FRAME_HDR	0x00
> +#define ADV7511_REG_CEC_TX_FRAME_DATA0	0x01
> +#define ADV7511_REG_CEC_TX_FRAME_LEN	0x10
> +#define ADV7511_REG_CEC_TX_ENABLE	0x11
> +#define ADV7511_REG_CEC_TX_RETRY	0x12
> +#define ADV7511_REG_CEC_TX_LOW_DRV_CNT	0x14
> +#define ADV7511_REG_CEC_RX_FRAME_HDR	0x15
> +#define ADV7511_REG_CEC_RX_FRAME_DATA0	0x16
> +#define ADV7511_REG_CEC_RX_FRAME_LEN	0x25
> +#define ADV7511_REG_CEC_RX_ENABLE	0x26
> +#define ADV7511_REG_CEC_RX_BUFFERS	0x4a
> +#define ADV7511_REG_CEC_LOG_ADDR_MASK	0x4b
> +#define ADV7511_REG_CEC_LOG_ADDR_0_1	0x4c
> +#define ADV7511_REG_CEC_LOG_ADDR_2	0x4d
> +#define ADV7511_REG_CEC_CLK_DIV		0x4e
> +#define ADV7511_REG_CEC_SOFT_RESET	0x50
> +
> +#define ADV7533_REG_CEC_OFFSET		0x70
> +
>   enum adv7511_input_clock {
>   	ADV7511_INPUT_CLOCK_1X,
>   	ADV7511_INPUT_CLOCK_2X,
> @@ -297,6 +316,8 @@ enum adv7511_type {
>   	ADV7533,
>   };
>   
> +#define ADV7511_MAX_ADDRS 3
> +
>   struct adv7511 {
>   	struct i2c_client *i2c_main;
>   	struct i2c_client *i2c_edid;
> @@ -343,15 +364,29 @@ struct adv7511 {
>   
>   	enum adv7511_type type;
>   	struct platform_device *audio_pdev;
> +
> +	struct cec_adapter *cec_adap;
> +	u8   cec_addr[ADV7511_MAX_ADDRS];
> +	u8   cec_valid_addrs;
> +	bool cec_enabled_adap;
> +	struct clk *cec_clk;
> +	u32 cec_clk_freq;
>   };
>   
> +#ifdef CONFIG_DRM_I2C_ADV7511_CEC
> +extern const struct cec_adap_ops adv7511_cec_adap_ops;
> +
> +void adv7511_cec_init(struct adv7511 *adv7511, unsigned int offset);
> +int adv7511_cec_parse_dt(struct device *dev, struct adv7511 *adv7511);
> +void adv7511_cec_irq_process(struct adv7511 *adv7511, unsigned int irq1);
> +#endif
> +
>   #ifdef CONFIG_DRM_I2C_ADV7533
>   void adv7533_dsi_power_on(struct adv7511 *adv);
>   void adv7533_dsi_power_off(struct adv7511 *adv);
>   void adv7533_mode_set(struct adv7511 *adv, struct drm_display_mode *mode);
>   int adv7533_patch_registers(struct adv7511 *adv);
> -void adv7533_uninit_cec(struct adv7511 *adv);
> -int adv7533_init_cec(struct adv7511 *adv);
> +int adv7533_patch_cec_registers(struct adv7511 *adv);
>   int adv7533_attach_dsi(struct adv7511 *adv);
>   void adv7533_detach_dsi(struct adv7511 *adv);
>   int adv7533_parse_dt(struct device_node *np, struct adv7511 *adv);
> @@ -374,11 +409,7 @@ static inline int adv7533_patch_registers(struct adv7511 *adv)
>   	return -ENODEV;
>   }
>   
> -static inline void adv7533_uninit_cec(struct adv7511 *adv)
> -{
> -}
> -
> -static inline int adv7533_init_cec(struct adv7511 *adv)
> +static inline int adv7533_patch_cec_registers(struct adv7511 *adv)
>   {
>   	return -ENODEV;
>   }
> diff --git a/drivers/gpu/drm/bridge/adv7511/adv7511_cec.c b/drivers/gpu/drm/bridge/adv7511/adv7511_cec.c
> new file mode 100644
> index 000000000000..74081cbfb5db
> --- /dev/null
> +++ b/drivers/gpu/drm/bridge/adv7511/adv7511_cec.c
> @@ -0,0 +1,314 @@
> +/*
> + * adv7511_cec.c - Analog Devices ADV7511/33 cec driver
> + *
> + * Copyright 2017 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
> + *
> + * This program is free software; you may redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; version 2 of the License.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> + * SOFTWARE.
> + *
> + */
> +
> +#include <linux/device.h>
> +#include <linux/module.h>
> +#include <linux/of_device.h>
> +#include <linux/slab.h>
> +#include <linux/clk.h>
> +
> +#include <media/cec.h>
> +
> +#include "adv7511.h"
> +
> +#define ADV7511_INT1_CEC_MASK \
> +	(ADV7511_INT1_CEC_TX_READY | ADV7511_INT1_CEC_TX_ARBIT_LOST | \
> +	 ADV7511_INT1_CEC_TX_RETRY_TIMEOUT | ADV7511_INT1_CEC_RX_READY1)
> +
> +static void adv_cec_tx_raw_status(struct adv7511 *adv7511, u8 tx_raw_status)
> +{
> +	unsigned int offset = adv7511->type == ADV7533 ?
> +					ADV7533_REG_CEC_OFFSET : 0;
> +	unsigned int val;
> +
> +	if (regmap_read(adv7511->regmap_cec,
> +			ADV7511_REG_CEC_TX_ENABLE + offset, &val))
> +		return;
> +
> +	if ((val & 0x01) == 0)
> +		return;
> +
> +	if (tx_raw_status & 0x10) {

Should we try to use IRQ1 masks (ADV7511_INT1_CEC_TX_ARBIT_LOST here) to make the
code more legible?

Same comments for the rest of this func and adv7511_cec_irq_process below.

> +		cec_transmit_attempt_done(adv7511->cec_adap,
> +					  CEC_TX_STATUS_ARB_LOST);
> +		return;
> +	}
> +	if (tx_raw_status & 0x08) {
> +		u8 status;
> +		u8 err_cnt = 0;
> +		u8 nack_cnt = 0;
> +		u8 low_drive_cnt = 0;
> +		unsigned int cnt;
> +
> +		/*
> +		 * We set this status bit since this hardware performs
> +		 * retransmissions.
> +		 */
> +		status = CEC_TX_STATUS_MAX_RETRIES;
> +		if (regmap_read(adv7511->regmap_cec,
> +			    ADV7511_REG_CEC_TX_LOW_DRV_CNT + offset, &cnt)) {
> +			err_cnt = 1;
> +			status |= CEC_TX_STATUS_ERROR;
> +		} else {
> +			nack_cnt = cnt & 0xf;
> +			if (nack_cnt)
> +				status |= CEC_TX_STATUS_NACK;
> +			low_drive_cnt = cnt >> 4;
> +			if (low_drive_cnt)
> +				status |= CEC_TX_STATUS_LOW_DRIVE;
> +		}
> +		cec_transmit_done(adv7511->cec_adap, status,
> +				  0, nack_cnt, low_drive_cnt, err_cnt);
> +		return;
> +	}
> +	if (tx_raw_status & 0x20) {
> +		cec_transmit_attempt_done(adv7511->cec_adap, CEC_TX_STATUS_OK);
> +		return;
> +	}
> +}
> +
> +void adv7511_cec_irq_process(struct adv7511 *adv7511, unsigned int irq1)
> +{
> +	unsigned int offset = adv7511->type == ADV7533 ?
> +					ADV7533_REG_CEC_OFFSET : 0;
> +	struct cec_msg msg = {};
> +	unsigned int len;
> +	unsigned int val;
> +	u8 i;
> +
> +	if (irq1 & 0x38) > +		adv_cec_tx_raw_status(adv7511, irq1);
> +
> +	if (!(irq1 & 1))
> +		return;
> +
> +	if (regmap_read(adv7511->regmap_cec,
> +			ADV7511_REG_CEC_RX_FRAME_LEN + offset, &len))
> +		return;
> +
> +	msg.len = len & 0x1f;
> +
> +	if (msg.len > 16)
> +		msg.len = 16;
> +
> +	if (!msg.len)
> +		return;
> +
> +	for (i = 0; i < msg.len; i++) {
> +		regmap_read(adv7511->regmap_cec,
> +			    i + ADV7511_REG_CEC_RX_FRAME_HDR + offset, &val);
> +		msg.msg[i] = val;
> +	}
> +
> +	/* toggle to re-enable rx 1 */
> +	regmap_write(adv7511->regmap_cec,
> +		     ADV7511_REG_CEC_RX_BUFFERS + offset, 1);
> +	regmap_write(adv7511->regmap_cec,
> +		     ADV7511_REG_CEC_RX_BUFFERS + offset, 0);
> +	cec_received_msg(adv7511->cec_adap, &msg);
> +}
> +
> +static int adv7511_cec_adap_enable(struct cec_adapter *adap, bool enable)
> +{
> +	struct adv7511 *adv7511 = cec_get_drvdata(adap);
> +	unsigned int offset = adv7511->type == ADV7533 ?
> +					ADV7533_REG_CEC_OFFSET : 0;
> +
> +	if (adv7511->i2c_cec == NULL)
> +		return -EIO;
> +
> +	if (!adv7511->cec_enabled_adap && enable) {
> +		/* power up cec section */
> +		regmap_update_bits(adv7511->regmap_cec,
> +				   ADV7511_REG_CEC_CLK_DIV + offset,
> +				   0x03, 0x01);
> +		/* legacy mode and clear all rx buffers */
> +		regmap_write(adv7511->regmap_cec,
> +			     ADV7511_REG_CEC_RX_BUFFERS + offset, 0x07);
> +		regmap_write(adv7511->regmap_cec,
> +			     ADV7511_REG_CEC_RX_BUFFERS + offset, 0);
> +		/* initially disable tx */
> +		regmap_update_bits(adv7511->regmap_cec,
> +				   ADV7511_REG_CEC_TX_ENABLE + offset, 1, 0);
> +		/* enabled irqs: */
> +		/* tx: ready */
> +		/* tx: arbitration lost */
> +		/* tx: retry timeout */
> +		/* rx: ready 1 */
> +		regmap_update_bits(adv7511->regmap,
> +				   ADV7511_REG_INT_ENABLE(1), 0x3f,
> +				   ADV7511_INT1_CEC_MASK);
> +	} else if (adv7511->cec_enabled_adap && !enable) {
> +		regmap_update_bits(adv7511->regmap,
> +				   ADV7511_REG_INT_ENABLE(1), 0x3f, 0);
> +		/* disable address mask 1-3 */
> +		regmap_update_bits(adv7511->regmap_cec,
> +				   ADV7511_REG_CEC_LOG_ADDR_MASK + offset,
> +				   0x70, 0x00);
> +		/* power down cec section */
> +		regmap_update_bits(adv7511->regmap_cec,
> +				   ADV7511_REG_CEC_CLK_DIV + offset,
> +				   0x03, 0x00);
> +		adv7511->cec_valid_addrs = 0;
> +	}
> +	adv7511->cec_enabled_adap = enable;
> +	return 0;
> +}
> +
> +static int adv7511_cec_adap_log_addr(struct cec_adapter *adap, u8 addr)
> +{
> +	struct adv7511 *adv7511 = cec_get_drvdata(adap);
> +	unsigned int offset = adv7511->type == ADV7533 ?
> +					ADV7533_REG_CEC_OFFSET : 0;
> +	unsigned int i, free_idx = ADV7511_MAX_ADDRS;
> +
> +	if (!adv7511->cec_enabled_adap)
> +		return addr == CEC_LOG_ADDR_INVALID ? 0 : -EIO;
> +
> +	if (addr == CEC_LOG_ADDR_INVALID) {
> +		regmap_update_bits(adv7511->regmap_cec,
> +				   ADV7511_REG_CEC_LOG_ADDR_MASK + offset,
> +				   0x70, 0);
> +		adv7511->cec_valid_addrs = 0;
> +		return 0;
> +	}
> +
> +	for (i = 0; i < ADV7511_MAX_ADDRS; i++) {
> +		bool is_valid = adv7511->cec_valid_addrs & (1 << i);
> +
> +		if (free_idx == ADV7511_MAX_ADDRS && !is_valid)
> +			free_idx = i;
> +		if (is_valid && adv7511->cec_addr[i] == addr)
> +			return 0;
> +	}
> +	if (i == ADV7511_MAX_ADDRS) {
> +		i = free_idx;
> +		if (i == ADV7511_MAX_ADDRS)
> +			return -ENXIO;
> +	}
> +	adv7511->cec_addr[i] = addr;
> +	adv7511->cec_valid_addrs |= 1 << i;
> +
> +	switch (i) {
> +	case 0:
> +		/* enable address mask 0 */
> +		regmap_update_bits(adv7511->regmap_cec,
> +				   ADV7511_REG_CEC_LOG_ADDR_MASK + offset,
> +				   0x10, 0x10);
> +		/* set address for mask 0 */
> +		regmap_update_bits(adv7511->regmap_cec,
> +				   ADV7511_REG_CEC_LOG_ADDR_0_1 + offset,
> +				   0x0f, addr);
> +		break;
> +	case 1:
> +		/* enable address mask 1 */
> +		regmap_update_bits(adv7511->regmap_cec,
> +				   ADV7511_REG_CEC_LOG_ADDR_MASK + offset,
> +				   0x20, 0x20);
> +		/* set address for mask 1 */
> +		regmap_update_bits(adv7511->regmap_cec,
> +				   ADV7511_REG_CEC_LOG_ADDR_0_1 + offset,
> +				   0xf0, addr << 4);
> +		break;
> +	case 2:
> +		/* enable address mask 2 */
> +		regmap_update_bits(adv7511->regmap_cec,
> +				   ADV7511_REG_CEC_LOG_ADDR_MASK + offset,
> +				   0x40, 0x40);
> +		/* set address for mask 1 */
> +		regmap_update_bits(adv7511->regmap_cec,
> +				   ADV7511_REG_CEC_LOG_ADDR_2 + offset,
> +				   0x0f, addr);
> +		break;
> +	}
> +	return 0;
> +}
> +
> +static int adv7511_cec_adap_transmit(struct cec_adapter *adap, u8 attempts,
> +				     u32 signal_free_time, struct cec_msg *msg)
> +{
> +	struct adv7511 *adv7511 = cec_get_drvdata(adap);
> +	unsigned int offset = adv7511->type == ADV7533 ?
> +					ADV7533_REG_CEC_OFFSET : 0;
> +	u8 len = msg->len;
> +	unsigned int i;
> +
> +	/*
> +	 * The number of retries is the number of attempts - 1, but retry
> +	 * at least once. It's not clear if a value of 0 is allowed, so
> +	 * let's do at least one retry.
> +	 */
> +	regmap_update_bits(adv7511->regmap_cec,
> +			   ADV7511_REG_CEC_TX_RETRY + offset,
> +			   0x70, max(1, attempts - 1) << 4);
> +
> +	/* blocking, clear cec tx irq status */
> +	regmap_update_bits(adv7511->regmap, ADV7511_REG_INT(1), 0x38, 0x38);
> +
> +	/* write data */ > +	for (i = 0; i < len; i++)
> +		regmap_write(adv7511->regmap_cec, i + offset, msg->msg[i]);

Maybe "i + ADV7511_REG_CEC_TX_FRAME_HDR + offset" here for more clarity?

> +
> +	/* set length (data + header) */
> +	regmap_write(adv7511->regmap_cec,
> +		     ADV7511_REG_CEC_TX_FRAME_LEN + offset, len);
> +	/* start transmit, enable tx */
> +	regmap_write(adv7511->regmap_cec,
> +		     ADV7511_REG_CEC_TX_ENABLE + offset, 0x01);
> +	return 0;
> +}
> +
> +const struct cec_adap_ops adv7511_cec_adap_ops = {
> +	.adap_enable = adv7511_cec_adap_enable,
> +	.adap_log_addr = adv7511_cec_adap_log_addr,
> +	.adap_transmit = adv7511_cec_adap_transmit,
> +};
> +
> +void adv7511_cec_init(struct adv7511 *adv7511, unsigned int offset)
> +{
> +	regmap_write(adv7511->regmap, ADV7511_REG_CEC_CTRL + offset, 0);
> +	/* cec soft reset */
> +	regmap_write(adv7511->regmap_cec,
> +		     ADV7511_REG_CEC_SOFT_RESET + offset, 0x01);
> +	regmap_write(adv7511->regmap_cec,
> +		     ADV7511_REG_CEC_SOFT_RESET + offset, 0x00);
> +
> +	/* legacy mode */
> +	regmap_write(adv7511->regmap_cec,
> +		     ADV7511_REG_CEC_RX_BUFFERS + offset, 0x00);
> +
> +	regmap_write(adv7511->regmap_cec,
> +		     ADV7511_REG_CEC_CLK_DIV + offset,
> +		     ((adv7511->cec_clk_freq / 750000) - 1) << 2);
> +}
> +
> +int adv7511_cec_parse_dt(struct device *dev, struct adv7511 *adv7511)
> +{
> +	adv7511->cec_clk = devm_clk_get(dev, "cec");
> +	if (IS_ERR(adv7511->cec_clk)) {
> +		int ret = PTR_ERR(adv7511->cec_clk);
> +
> +		adv7511->cec_clk = NULL;
> +		return ret;
> +	}
> +	clk_prepare_enable(adv7511->cec_clk);
> +	adv7511->cec_clk_freq = clk_get_rate(adv7511->cec_clk);
> +	return 0;
> +}
> diff --git a/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c b/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c
> index f75ab6278113..1bef33e99358 100644
> --- a/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c
> +++ b/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c
> @@ -11,12 +11,15 @@
>   #include <linux/module.h>
>   #include <linux/of_device.h>
>   #include <linux/slab.h>
> +#include <linux/clk.h>
>   
>   #include <drm/drmP.h>
>   #include <drm/drm_atomic.h>
>   #include <drm/drm_atomic_helper.h>
>   #include <drm/drm_edid.h>
>   
> +#include <media/cec.h>
> +
>   #include "adv7511.h"
>   
>   /* ADI recommended values for proper operation. */
> @@ -339,8 +342,10 @@ static void __adv7511_power_on(struct adv7511 *adv7511)
>   		 */
>   		regmap_write(adv7511->regmap, ADV7511_REG_INT_ENABLE(0),
>   			     ADV7511_INT0_EDID_READY | ADV7511_INT0_HPD);
> -		regmap_write(adv7511->regmap, ADV7511_REG_INT_ENABLE(1),
> -			     ADV7511_INT1_DDC_ERROR);
> +		regmap_update_bits(adv7511->regmap,
> +				   ADV7511_REG_INT_ENABLE(1),
> +				   ADV7511_INT1_DDC_ERROR,
> +				   ADV7511_INT1_DDC_ERROR);
>   	}
>   
>   	/*
> @@ -376,6 +381,9 @@ static void __adv7511_power_off(struct adv7511 *adv7511)
>   	regmap_update_bits(adv7511->regmap, ADV7511_REG_POWER,
>   			   ADV7511_POWER_POWER_DOWN,
>   			   ADV7511_POWER_POWER_DOWN);
> +	regmap_update_bits(adv7511->regmap,
> +			   ADV7511_REG_INT_ENABLE(1),
> +			   ADV7511_INT1_DDC_ERROR, 0);
>   	regcache_mark_dirty(adv7511->regmap);
>   }
>   
> @@ -426,6 +434,8 @@ static void adv7511_hpd_work(struct work_struct *work)
>   
>   	if (adv7511->connector.status != status) {
>   		adv7511->connector.status = status;
> +		if (status == connector_status_disconnected)
> +			cec_phys_addr_invalidate(adv7511->cec_adap);
>   		drm_kms_helper_hotplug_event(adv7511->connector.dev);
>   	}
>   }
> @@ -456,6 +466,10 @@ static int adv7511_irq_process(struct adv7511 *adv7511, bool process_hpd)
>   			wake_up_all(&adv7511->wq);
>   	}
>   
> +#ifdef CONFIG_DRM_I2C_ADV7511_CEC
> +	adv7511_cec_irq_process(adv7511, irq1);
> +#endif
> +
>   	return 0;
>   }
>   
> @@ -599,6 +613,8 @@ static int adv7511_get_modes(struct adv7511 *adv7511,
>   
>   	adv7511_set_config_csc(adv7511, connector, adv7511->rgb);
>   
> +	cec_s_phys_addr_from_edid(adv7511->cec_adap, edid);
> +
>   	return count;
>   }
>   
> @@ -920,6 +936,84 @@ static void adv7511_uninit_regulators(struct adv7511 *adv)
>   	regulator_bulk_disable(adv->num_supplies, adv->supplies);
>   }
>   
> +static bool adv7533_cec_register_volatile(struct device *dev, unsigned int reg)
> +{
> +	switch (reg) {
> +	case ADV7511_REG_CEC_RX_FRAME_HDR + ADV7533_REG_CEC_OFFSET:
> +	case ADV7511_REG_CEC_RX_FRAME_DATA0 + ADV7533_REG_CEC_OFFSET...
> +		ADV7511_REG_CEC_RX_FRAME_DATA0 + ADV7533_REG_CEC_OFFSET + 14:
> +	case ADV7511_REG_CEC_RX_FRAME_LEN + ADV7533_REG_CEC_OFFSET:
> +	case ADV7511_REG_CEC_RX_BUFFERS + ADV7533_REG_CEC_OFFSET:
> +	case ADV7511_REG_CEC_TX_LOW_DRV_CNT + ADV7533_REG_CEC_OFFSET:
> +		return true;
> +	}
> +
> +	return false;
> +}
> +
> +static const struct regmap_config adv7533_cec_regmap_config = {
> +	.reg_bits = 8,
> +	.val_bits = 8,
> +
> +	.max_register = 0xff,
> +	.cache_type = REGCACHE_RBTREE,
> +	.volatile_reg = adv7533_cec_register_volatile,
> +};
> +
> +static bool adv7511_cec_register_volatile(struct device *dev, unsigned int reg)
> +{

Maybe we could combine the two register_volatile() funcs and the remap_config structs
for adv7511 and adv7533 by passing (reg + offset) to switch?

> +	switch (reg) {
> +	case ADV7511_REG_CEC_RX_FRAME_HDR:
> +	case ADV7511_REG_CEC_RX_FRAME_DATA0...
> +		ADV7511_REG_CEC_RX_FRAME_DATA0 + 14:
> +	case ADV7511_REG_CEC_RX_FRAME_LEN:
> +	case ADV7511_REG_CEC_RX_BUFFERS:
> +	case ADV7511_REG_CEC_TX_LOW_DRV_CNT:
> +		return true;
> +	}
> +
> +	return false;
> +}
> +
> +static const struct regmap_config adv7511_cec_regmap_config = {
> +	.reg_bits = 8,
> +	.val_bits = 8,
> +
> +	.max_register = 0xff,
> +	.cache_type = REGCACHE_RBTREE,
> +	.volatile_reg = adv7511_cec_register_volatile,
> +};
> +
> +static int adv7511_init_cec_regmap(struct adv7511 *adv)
> +{
> +	int ret;
> +
> +	adv->i2c_cec = i2c_new_dummy(adv->i2c_main->adapter,
> +				     adv->i2c_main->addr - 1);
> +	if (!adv->i2c_cec)
> +		return -ENOMEM;
> +
> +	adv->regmap_cec = devm_regmap_init_i2c(adv->i2c_cec,
> +					       adv->type == ADV7533 ?
> +					       &adv7533_cec_regmap_config :
> +					&adv7511_cec_regmap_config);
> +	if (IS_ERR(adv->regmap_cec)) {
> +		ret = PTR_ERR(adv->regmap_cec);
> +		goto err;
> +	}
> +
> +	if (adv->type == ADV7533) {
> +		ret = adv7533_patch_cec_registers(adv);
> +		if (ret)
> +			goto err;
> +	}
> +
> +	return 0;
> +err:
> +	i2c_unregister_device(adv->i2c_cec);
> +	return ret;
> +}
> +
>   static int adv7511_parse_dt(struct device_node *np,
>   			    struct adv7511_link_config *config)
>   {
> @@ -1010,6 +1104,7 @@ static int adv7511_probe(struct i2c_client *i2c, const struct i2c_device_id *id)
>   	struct device *dev = &i2c->dev;
>   	unsigned int main_i2c_addr = i2c->addr << 1;
>   	unsigned int edid_i2c_addr = main_i2c_addr + 4;
> +	unsigned int offset;
>   	unsigned int val;
>   	int ret;
>   
> @@ -1035,6 +1130,7 @@ static int adv7511_probe(struct i2c_client *i2c, const struct i2c_device_id *id)
>   		ret = adv7511_parse_dt(dev->of_node, &link_config);
>   	else
>   		ret = adv7533_parse_dt(dev->of_node, adv7511);
> +

This line seems unnecessary.

>   	if (ret)
>   		return ret;
>   
> @@ -1093,11 +1189,9 @@ static int adv7511_probe(struct i2c_client *i2c, const struct i2c_device_id *id)
>   		goto uninit_regulators;
>   	}
>   
> -	if (adv7511->type == ADV7533) {
> -		ret = adv7533_init_cec(adv7511);
> -		if (ret)
> -			goto err_i2c_unregister_edid;
> -	}
> +	ret = adv7511_init_cec_regmap(adv7511);
> +	if (ret)
> +		goto err_i2c_unregister_edid;
>   
>   	INIT_WORK(&adv7511->hpd_work, adv7511_hpd_work);
>   
> @@ -1112,10 +1206,6 @@ static int adv7511_probe(struct i2c_client *i2c, const struct i2c_device_id *id)
>   			goto err_unregister_cec;
>   	}
>   
> -	/* CEC is unused for now */
> -	regmap_write(adv7511->regmap, ADV7511_REG_CEC_CTRL,
> -		     ADV7511_CEC_CTRL_POWER_DOWN);
> -
>   	adv7511_power_off(adv7511);
>   
>   	i2c_set_clientdata(i2c, adv7511);
> @@ -1134,10 +1224,39 @@ static int adv7511_probe(struct i2c_client *i2c, const struct i2c_device_id *id)
>   
>   	adv7511_audio_init(dev, adv7511);
>   
> +	offset = adv7511->type == ADV7533 ? ADV7533_REG_CEC_OFFSET : 0;
> +
> +#ifdef CONFIG_DRM_I2C_ADV7511_CEC
> +	ret = adv7511_cec_parse_dt(dev, adv7511);
> +	if (ret)
> +		goto err_unregister_cec;
> +
> +	adv7511->cec_adap = cec_allocate_adapter(&adv7511_cec_adap_ops,
> +		adv7511, dev_name(&i2c->dev), CEC_CAP_TRANSMIT |
> +		CEC_CAP_LOG_ADDRS | CEC_CAP_PASSTHROUGH | CEC_CAP_RC,
> +		ADV7511_MAX_ADDRS);
> +	ret = PTR_ERR_OR_ZERO(adv7511->cec_adap);
> +	if (ret)
> +		goto err_unregister_cec;
> +
> +	adv7511_cec_init(adv7511, offset);
> +
> +	ret = cec_register_adapter(adv7511->cec_adap, &i2c->dev);
> +	if (ret) {
> +		cec_delete_adapter(adv7511->cec_adap);
> +		goto err_unregister_cec;
> +	}

We could ideally put this code in a single func and make adv7511_cec_init,
adv7511_cec_parse_dt and adv7511_cec_adap_ops within the scope of adv7511_cec.c.
It's not necessary to do, though.

> +#else
> +	regmap_write(adv7511->regmap, ADV7511_REG_CEC_CTRL + offset,
> +		     ADV7511_CEC_CTRL_POWER_DOWN);
> +#endif
> +
>   	return 0;
>   
>   err_unregister_cec:
> -	adv7533_uninit_cec(adv7511);
> +	i2c_unregister_device(adv7511->i2c_cec);
> +	if (adv7511->cec_clk)
> +		clk_disable_unprepare(adv7511->cec_clk);
>   err_i2c_unregister_edid:
>   	i2c_unregister_device(adv7511->i2c_edid);
>   uninit_regulators:
> @@ -1150,10 +1269,11 @@ static int adv7511_remove(struct i2c_client *i2c)
>   {
>   	struct adv7511 *adv7511 = i2c_get_clientdata(i2c);
>   
> -	if (adv7511->type == ADV7533) {
> +	if (adv7511->type == ADV7533)
>   		adv7533_detach_dsi(adv7511);
> -		adv7533_uninit_cec(adv7511);
> -	}
> +	i2c_unregister_device(adv7511->i2c_cec);
> +	if (adv7511->cec_clk)
> +		clk_disable_unprepare(adv7511->cec_clk);
>   
>   	adv7511_uninit_regulators(adv7511);
>   
> @@ -1161,6 +1281,8 @@ static int adv7511_remove(struct i2c_client *i2c)
>   
>   	adv7511_audio_exit(adv7511);
>   
> +	cec_unregister_adapter(adv7511->cec_adap);
> +
>   	i2c_unregister_device(adv7511->i2c_edid);
>   
>   	kfree(adv7511->edid);
> diff --git a/drivers/gpu/drm/bridge/adv7511/adv7533.c b/drivers/gpu/drm/bridge/adv7511/adv7533.c
> index ac804f81e2f6..0e173abb913c 100644
> --- a/drivers/gpu/drm/bridge/adv7511/adv7533.c
> +++ b/drivers/gpu/drm/bridge/adv7511/adv7533.c
> @@ -145,37 +145,11 @@ int adv7533_patch_registers(struct adv7511 *adv)
>   				     ARRAY_SIZE(adv7533_fixed_registers));
>   }
>   
> -void adv7533_uninit_cec(struct adv7511 *adv)
> +int adv7533_patch_cec_registers(struct adv7511 *adv)
>   {
> -	i2c_unregister_device(adv->i2c_cec);
> -}
> -
> -int adv7533_init_cec(struct adv7511 *adv)
> -{
> -	int ret;
> -
> -	adv->i2c_cec = i2c_new_dummy(adv->i2c_main->adapter,
> -				     adv->i2c_main->addr - 1);
> -	if (!adv->i2c_cec)
> -		return -ENOMEM;
> -
> -	adv->regmap_cec = devm_regmap_init_i2c(adv->i2c_cec,
> -					&adv7533_cec_regmap_config);

adv7533_cec_regmap_config struct isn't needed in the file anymore, that too
can be deleted.

Looks good to me otherwise.

Thanks,
Archit

> -	if (IS_ERR(adv->regmap_cec)) {
> -		ret = PTR_ERR(adv->regmap_cec);
> -		goto err;
> -	}
> -
> -	ret = regmap_register_patch(adv->regmap_cec,
> +	return regmap_register_patch(adv->regmap_cec,
>   				    adv7533_cec_fixed_registers,
>   				    ARRAY_SIZE(adv7533_cec_fixed_registers));
> -	if (ret)
> -		goto err;
> -
> -	return 0;
> -err:
> -	adv7533_uninit_cec(adv);
> -	return ret;
>   }
>   
>   int adv7533_attach_dsi(struct adv7511 *adv)
> 

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
