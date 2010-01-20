Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:4772 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059Ab0ATVos convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jan 2010 16:44:48 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Richard =?iso-8859-1?q?R=F6jfors?=
	<richard.rojfors@pelagicore.com>
Subject: Re: [PATCH 2/3] radio: Add support for SAA7706H Car Radio DSP
Date: Wed, 20 Jan 2010 22:46:00 +0100
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Douglas Schilling Landgraf <dougsland@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
References: <4B570A57.8040204@pelagicore.com>
In-Reply-To: <4B570A57.8040204@pelagicore.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201001202246.00147.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Richard,

Here is a quick review of this driver:

On Wednesday 20 January 2010 14:51:19 Richard Röjfors wrote:
> This patch contains initial support for the SAA7706H Car Radio DSP.
> 
> It is a I2C device and currently the mute control is supported.
> 
> When the device is unmuted it is brought out of reset and initiated
> using the proposed intialisation sequence.
> 
> When muted the DSP is brought into reset state.
> 
> Signed-off-by: Richard Röjfors <richard.rojfors@pelagicore.com>
> ---
> diff --git a/drivers/media/radio/saa7706h.c b/drivers/media/radio/saa7706h.c
> new file mode 100644
> index 0000000..278de06
> --- /dev/null
> +++ b/drivers/media/radio/saa7706h.c
> @@ -0,0 +1,491 @@
> +/*
> + * saa7706.c Philips SAA7706H Car Radio DSP driver
> + * Copyright (c) 2009 Intel Corporation
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/errno.h>
> +#include <linux/kernel.h>
> +#include <linux/interrupt.h>
> +#include <linux/i2c.h>
> +#include <linux/i2c-id.h>

Header i2c-id.h shouldn't be needed.

> +#include <media/v4l2-ioctl.h>

Ditto for this header.

> +#include <media/v4l2-device.h>
> +#include <media/v4l2-chip-ident.h>
> +
> +#define DRIVER_NAME "saa7706h"
> +
> +/* the I2C memory map looks like this
> +
> +	$1C00 - $FFFF Not Used
> +	$2200 - $3FFF Reserved YRAM (DSP2) space
> +	$2000 - $21FF YRAM (DSP2)
> +	$1FF0 - $1FFF Hardware Registers
> +	$1280 - $1FEF Reserved XRAM (DSP2) space
> +	$1000 - $127F XRAM (DSP2)
> +	$0FFF        DSP CONTROL
> +	$0A00 - $0FFE Reserved
> +	$0980 - $09FF Reserved YRAM (DSP1) space
> +	$0800 - $097F YRAM (DSP1)
> +	$0200 - $07FF Not Used
> +	$0180 - $01FF Reserved XRAM (DSP1) space
> +	$0000 - $017F XRAM (DSP1)
> +*/
> +
> +#define SAA7706H_REG_CTRL		0x0fff
> +#define SAA7706H_CTRL_BYP_PLL		0x0001
> +#define SAA7706H_CTRL_PLL_DIV_MASK	0x003e
> +#define SAA7706H_CTRL_PLL3_62975MHZ	0x003e
> +#define SAA7706H_CTRL_DSP_TURBO		0x0040
> +#define SAA7706H_CTRL_PC_RESET_DSP1	0x0080
> +#define SAA7706H_CTRL_PC_RESET_DSP2	0x0100
> +#define SAA7706H_CTRL_DSP1_ROM_EN_MASK	0x0600
> +#define SAA7706H_CTRL_DSP1_FUNC_PROM	0x0000
> +#define SAA7706H_CTRL_DSP2_ROM_EN_MASK	0x1800
> +#define SAA7706H_CTRL_DSP2_FUNC_PROM	0x0000
> +#define SAA7706H_CTRL_DIG_SIL_INTERPOL	0x8000
> +
> +#define SAA7706H_REG_EVALUATION			0x1ff0
> +#define SAA7706H_EVAL_DISABLE_CHARGE_PUMP	0x000001
> +#define SAA7706H_EVAL_DCS_CLOCK			0x000002
> +#define SAA7706H_EVAL_GNDRC1_ENABLE		0x000004
> +#define SAA7706H_EVAL_GNDRC2_ENABLE		0x000008
> +
> +#define SAA7706H_REG_CL_GEN1			0x1ff3
> +#define SAA7706H_CL_GEN1_MIN_LOOPGAIN_MASK	0x00000f
> +#define SAA7706H_CL_GEN1_LOOPGAIN_MASK		0x0000f0
> +#define SAA7706H_CL_GEN1_COARSE_RATION		0xffff00
> +
> +#define SAA7706H_REG_CL_GEN2			0x1ff4
> +#define SAA7706H_CL_GEN2_WSEDGE_FALLING		0x000001
> +#define SAA7706H_CL_GEN2_STOP_VCO		0x000002
> +#define SAA7706H_CL_GEN2_FRERUN			0x000004
> +#define SAA7706H_CL_GEN2_ADAPTIVE		0x000008
> +#define SAA7706H_CL_GEN2_FINE_RATIO_MASK	0x0ffff0
> +
> +#define SAA7706H_REG_CL_GEN4		0x1ff6
> +#define SAA7706H_CL_GEN4_BYPASS_PLL1	0x001000
> +#define SAA7706H_CL_GEN4_PLL1_DIV_MASK	0x03e000
> +#define SAA7706H_CL_GEN4_DSP1_TURBO	0x040000
> +
> +#define SAA7706H_REG_SEL	0x1ff7
> +#define SAA7706H_SEL_DSP2_SRCA_MASK	0x000007
> +#define SAA7706H_SEL_DSP2_FMTA_MASK	0x000031
> +#define SAA7706H_SEL_DSP2_SRCB_MASK	0x0001c0
> +#define SAA7706H_SEL_DSP2_FMTB_MASK	0x000e00
> +#define SAA7706H_SEL_DSP1_SRC_MASK	0x003000
> +#define SAA7706H_SEL_DSP1_FMT_MASK	0x01c003
> +#define SAA7706H_SEL_SPDIF2		0x020000
> +#define SAA7706H_SEL_HOST_IO_FMT_MASK	0x1c0000
> +#define SAA7706H_SEL_EN_HOST_IO		0x200000
> +
> +#define SAA7706H_REG_IAC		0x1ff8
> +#define SAA7706H_REG_CLK_SET		0x1ff9
> +#define SAA7706H_REG_CLK_COEFF		0x1ffa
> +#define SAA7706H_REG_INPUT_SENS		0x1ffb
> +#define SAA7706H_INPUT_SENS_RDS_VOL_MASK	0x0003f
> +#define SAA7706H_INPUT_SENS_FM_VOL_MASK		0x00fc0
> +#define SAA7706H_INPUT_SENS_FM_MPX		0x01000
> +#define SAA7706H_INPUT_SENS_OFF_FILTER_A_EN	0x02000
> +#define SAA7706H_INPUT_SENS_OFF_FILTER_B_EN	0x04000
> +#define SAA7706H_REG_PHONE_NAV_AUDIO	0x1ffc
> +#define SAA7706H_REG_IO_CONF_DSP2	0x1ffd
> +#define SAA7706H_REG_STATUS_DSP2	0x1ffe
> +#define SAA7706H_REG_PC_DSP2		0x1fff
> +
> +#define SAA7706H_DSP1_MOD0	0x0800
> +#define SAA7706H_DSP1_ROM_VER	0x097f
> +#define SAA7706H_DSP2_MPTR0	0x1000
> +
> +#define SAA7706H_DSP1_MODPNTR	0x0000
> +
> +#define SAA7706H_DSP2_XMEM_CONTLLCW	0x113e
> +#define SAA7706H_DSP2_XMEM_BUSAMP	0x114a
> +#define SAA7706H_DSP2_XMEM_FDACPNTR	0x11f9
> +#define SAA7706H_DSP2_XMEM_IIS1PNTR	0x11fb
> +
> +#define SAA7706H_DSP2_YMEM_PVGA		0x212a
> +#define SAA7706H_DSP2_YMEM_PVAT1	0x212b
> +#define SAA7706H_DSP2_YMEM_PVAT		0x212c
> +#define SAA7706H_DSP2_YMEM_ROM_VER	0x21ff
> +
> +#define SUPPORTED_DSP1_ROM_VER		0x667
> +
> +struct saa7706h_state {
> +	struct v4l2_subdev sd;
> +	unsigned muted;
> +};
> +
> +static inline struct saa7706h_state *to_state(struct v4l2_subdev *sd)
> +{
> +	return container_of(sd, struct saa7706h_state, sd);
> +}
> +
> +static int saa7706h_i2c_send(struct i2c_client *client, const u8 *data, int len)
> +{
> +	int err = i2c_master_send(client, data, len);
> +	if (err == len)
> +		return 0;
> +	else if (err > 0)
> +		return -EIO;
> +	return err;

The last three lines can be simplified to:

	return err > 0 ? -EIO : err;

> +}
> +
> +static int saa7706h_i2c_transfer(struct i2c_client *client,
> +	struct i2c_msg *msgs, int num)
> +{
> +	int err = i2c_transfer(client->adapter, msgs, num);
> +	if (err == num)
> +		return 0;
> +	else if (err > 0)
> +		return -EIO;
> +	else
> +		return err;

Ditto.

> +}
> +
> +static int saa7706h_set_reg24(struct i2c_client *client, u16 reg, u32 val)
> +{
> +	u8 buf[5];
> +	int pos = 0;
> +
> +	buf[pos++] = reg >> 8;
> +	buf[pos++] = reg;
> +	buf[pos++] = val >> 16;
> +	buf[pos++] = val >> 8;
> +	buf[pos++] = val;
> +
> +	return saa7706h_i2c_send(client, buf, pos);
> +}
> +
> +static int saa7706h_set_reg16(struct i2c_client *client, u16 reg, u16 val)
> +{
> +	u8 buf[4];
> +	int pos = 0;
> +
> +	buf[pos++] = reg >> 8;
> +	buf[pos++] = reg;
> +	buf[pos++] = val >> 8;
> +	buf[pos++] = val;
> +
> +	return saa7706h_i2c_send(client, buf, pos);
> +}
> +
> +static int saa7706h_get_reg16(struct i2c_client *client, u16 reg)
> +{
> +	u8 buf[2];
> +	int err;
> +	u8 regaddr[] = {reg >> 8, reg};
> +	struct i2c_msg msg[] = { {client->addr, 0, sizeof(regaddr), regaddr},
> +				{client->addr, I2C_M_RD, sizeof(buf), buf} };
> +
> +	err = saa7706h_i2c_transfer(client, msg, ARRAY_SIZE(msg));
> +	if (err)
> +		return err;
> +
> +	return buf[0] << 8 | buf[1];
> +}
> +
> +static int saa7706h_unmute(struct v4l2_subdev *sd)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);

In general I prefer to do keep using struct v4l2_subdev for as long as possible,
so calling v4l2_get_subdevdata() to get to the i2c_client pointer is something
that I would only do in the get/set reg functions that actually need it.

It's cleaner that way IMHO.

> +	struct saa7706h_state *state = to_state(sd);
> +	int err;
> +
> +	err = saa7706h_set_reg16(client, SAA7706H_REG_CTRL,
> +		SAA7706H_CTRL_PLL3_62975MHZ | SAA7706H_CTRL_PC_RESET_DSP1 |
> +		SAA7706H_CTRL_PC_RESET_DSP2);
> +	if (err)
> +		goto out;

No need for the goto, you can just do 'return err' here.

But I would actually recommend introducing something like:

int err = 0;

err = saa7706h_set_reg16_err(..., &err);

where saa7706h_set_reg16_err() is defined as:

static inline int saa7706h_set_reg16_err(..., int *err)
{
	return err ? err : saa7706h_set_reg16(...);
}

That way you can just call a whole series of set_reg16_err and set_reg16_err
functions and only do the final error check at the end. The code looks
much cleaner that way.

> +
> +	/* newer versions of the chip requires a small sleep after reset */
> +	msleep(1);
> +
> +	err = saa7706h_set_reg16(client, SAA7706H_REG_CTRL,
> +		SAA7706H_CTRL_PLL3_62975MHZ);
> +	if (err)
> +		goto out;
> +
> +	err = saa7706h_set_reg24(client, SAA7706H_REG_EVALUATION, 0);
> +	if (err)
> +		goto out;
> +
> +	err = saa7706h_set_reg24(client, SAA7706H_REG_CL_GEN1, 0x040022);
> +	if (err)
> +		goto out;
> +
> +	err = saa7706h_set_reg24(client, SAA7706H_REG_CL_GEN2,
> +		SAA7706H_CL_GEN2_WSEDGE_FALLING);
> +	if (err)
> +		goto out;
> +
> +	err = saa7706h_set_reg24(client, SAA7706H_REG_CL_GEN4, 0x024080);
> +	if (err)
> +		goto out;
> +
> +	err = saa7706h_set_reg24(client, SAA7706H_REG_SEL, 0x200080);
> +	if (err)
> +		goto out;
> +
> +	err = saa7706h_set_reg24(client, SAA7706H_REG_IAC, 0xf4caed);
> +	if (err)
> +		goto out;
> +
> +	err = saa7706h_set_reg24(client, SAA7706H_REG_CLK_SET, 0x124334);
> +	if (err)
> +		goto out;
> +
> +	err = saa7706h_set_reg24(client, SAA7706H_REG_CLK_COEFF, 0x004a1a);
> +	if (err)
> +		goto out;
> +
> +	err = saa7706h_set_reg24(client, SAA7706H_REG_INPUT_SENS, 0x0071c7);
> +	if (err)
> +		goto out;
> +
> +	err = saa7706h_set_reg24(client, SAA7706H_REG_PHONE_NAV_AUDIO,
> +		0x0e22ff);
> +	if (err)
> +		goto out;
> +
> +	err = saa7706h_set_reg24(client, SAA7706H_REG_IO_CONF_DSP2, 0x001ff8);
> +	if (err)
> +		goto out;
> +
> +	err = saa7706h_set_reg24(client, SAA7706H_REG_STATUS_DSP2, 0x080003);
> +	if (err)
> +		goto out;
> +
> +	err = saa7706h_set_reg24(client, SAA7706H_REG_PC_DSP2, 0x000004);
> +	if (err)
> +		goto out;
> +
> +	err = saa7706h_set_reg16(client, SAA7706H_DSP1_MOD0, 0x0c6c);
> +	if (err)
> +		goto out;
> +
> +	err = saa7706h_set_reg24(client, SAA7706H_DSP2_MPTR0, 0x000b4b);
> +	if (err)
> +		goto out;
> +
> +	err = saa7706h_set_reg24(client, SAA7706H_DSP1_MODPNTR, 0x000600);
> +	if (err)
> +		goto out;
> +
> +	err = saa7706h_set_reg24(client, SAA7706H_DSP1_MODPNTR, 0x0000c0);
> +	if (err)
> +		goto out;
> +
> +	err = saa7706h_set_reg24(client, SAA7706H_DSP2_XMEM_CONTLLCW, 0x000819);
> +	if (err)
> +		goto out;
> +
> +	err = saa7706h_set_reg24(client, SAA7706H_DSP2_XMEM_CONTLLCW, 0x00085a);
> +	if (err)
> +		goto out;
> +
> +	err = saa7706h_set_reg24(client, SAA7706H_DSP2_XMEM_BUSAMP, 0x7fffff);
> +	if (err)
> +		goto out;
> +
> +	err = saa7706h_set_reg24(client, SAA7706H_DSP2_XMEM_FDACPNTR, 0x2000cb);
> +	if (err)
> +		goto out;
> +
> +	err = saa7706h_set_reg24(client, SAA7706H_DSP2_XMEM_IIS1PNTR, 0x2000cb);
> +	if (err)
> +		goto out;
> +
> +	err = saa7706h_set_reg16(client, SAA7706H_DSP2_YMEM_PVGA, 0x0f80);
> +	if (err)
> +		goto out;
> +
> +	err = saa7706h_set_reg16(client, SAA7706H_DSP2_YMEM_PVAT1, 0x0800);
> +	if (err)
> +		goto out;
> +
> +	err = saa7706h_set_reg16(client, SAA7706H_DSP2_YMEM_PVAT, 0x0800);
> +	if (err)
> +		goto out;
> +
> +	err = saa7706h_set_reg24(client, SAA7706H_DSP2_XMEM_CONTLLCW, 0x000905);
> +	if (err)
> +		goto out;
> +
> +	state->muted = 0;
> +out:
> +	return err;
> +}
> +
> +static int saa7706h_mute(struct v4l2_subdev *sd)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	struct saa7706h_state *state = to_state(sd);
> +	int err;
> +
> +	err = saa7706h_set_reg16(client, SAA7706H_REG_CTRL,
> +		SAA7706H_CTRL_PLL3_62975MHZ | SAA7706H_CTRL_PC_RESET_DSP1 |
> +		SAA7706H_CTRL_PC_RESET_DSP2);
> +	if (err)
> +		goto out;
> +
> +	state->muted = 1;
> +out:
> +	return err;
> +}
> +
> +static int saa7706h_queryctrl(struct v4l2_subdev *sd, struct v4l2_queryctrl *qc)
> +{
> +	switch (qc->id) {
> +	case V4L2_CID_AUDIO_MUTE:
> +		return v4l2_ctrl_query_fill(qc, 0, 1, 1, 1);
> +	}
> +	return -EINVAL;
> +}
> +
> +static int saa7706h_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
> +{
> +	struct saa7706h_state *state = to_state(sd);
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_AUDIO_MUTE:
> +		ctrl->value = state->muted;
> +		return 0;
> +	}
> +	return -EINVAL;
> +}
> +
> +static int saa7706h_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
> +{
> +	switch (ctrl->id) {
> +	case V4L2_CID_AUDIO_MUTE:
> +		if (ctrl->value)
> +			return saa7706h_mute(sd);
> +		else

'else' is not needed here.

> +			return saa7706h_unmute(sd);
> +	}
> +	return -EINVAL;
> +}
> +
> +static int saa7706h_g_chip_ident(struct v4l2_subdev *sd,
> +	struct v4l2_dbg_chip_ident *chip)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +
> +	return v4l2_chip_ident_i2c_client(client, chip, V4L2_IDENT_SAA7706H, 0);
> +}
> +
> +static const struct v4l2_subdev_core_ops saa7706h_core_ops = {
> +	.g_chip_ident = saa7706h_g_chip_ident,
> +	.queryctrl = saa7706h_queryctrl,
> +	.g_ctrl = saa7706h_g_ctrl,
> +	.s_ctrl = saa7706h_s_ctrl,
> +};
> +
> +static const struct v4l2_subdev_ops saa7706h_ops = {
> +	.core = &saa7706h_core_ops,
> +};
> +
> +
> +static int __devinit saa7706h_probe(struct i2c_client *client,
> +			const struct i2c_device_id *id)
> +{
> +	struct saa7706h_state *state;
> +	struct v4l2_subdev *sd;
> +	int err;
> +
> +	/* Check if the adapter supports the needed features */
> +	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DATA))
> +		return -EIO;
> +
> +	v4l_info(client, "chip found @ 0x%02x (%s)\n",
> +			client->addr << 1, client->adapter->name);
> +
> +	state = kmalloc(sizeof(struct saa7706h_state), GFP_KERNEL);
> +	if (state == NULL)
> +		return -ENOMEM;
> +	sd = &state->sd;
> +	v4l2_i2c_subdev_init(sd, client, &saa7706h_ops);
> +
> +	/* check the rom versions */
> +	err = saa7706h_get_reg16(client, SAA7706H_DSP1_ROM_VER);
> +	if (err < 0)
> +		goto err;
> +	if (err != SUPPORTED_DSP1_ROM_VER)
> +		printk(KERN_WARNING DRIVER_NAME
> +			": Unknown DSP1 ROM code version: 0x%x\n", err);

Replace this with v4l2_warning(sd, "Unknown DSP1 ROM code version: 0x%x\n", err);

> +
> +	state->muted = 1;
> +
> +	/* startup in a muted state */
> +	err = saa7706h_mute(sd);
> +	if (err)
> +		goto err;
> +
> +	return 0;
> +
> +err:
> +	v4l2_device_unregister_subdev(sd);
> +	kfree(to_state(sd));
> +
> +	printk(KERN_ERR DRIVER_NAME ": Failed to probe: %d\n", err);
> +
> +	return err;
> +}
> +
> +static int __devexit saa7706h_remove(struct i2c_client *client)
> +{
> +	struct v4l2_subdev *sd = i2c_get_clientdata(client);
> +
> +	saa7706h_mute(sd);
> +	v4l2_device_unregister_subdev(sd);
> +	kfree(to_state(sd));
> +	return 0;
> +}
> +
> +static const struct i2c_device_id saa7706h_id[] = {
> +	{DRIVER_NAME, 0},
> +	{},
> +};
> +
> +MODULE_DEVICE_TABLE(i2c, saa7706h_id);
> +
> +static struct i2c_driver saa7706h_driver = {
> +	.driver = {
> +		.owner	= THIS_MODULE,
> +		.name	= DRIVER_NAME,
> +	},
> +	.probe		= saa7706h_probe,
> +	.remove		= saa7706h_remove,
> +	.id_table	= saa7706h_id,
> +};
> +
> +static __init int saa7706h_init(void)
> +{
> +	return i2c_add_driver(&saa7706h_driver);
> +}
> +
> +static __exit void saa7706h_exit(void)
> +{
> +	i2c_del_driver(&saa7706h_driver);
> +}
> +
> +module_init(saa7706h_init);
> +module_exit(saa7706h_exit);
> +
> +MODULE_DESCRIPTION("SAA7706H Car Radio DSP driver");
> +MODULE_AUTHOR("Mocean Laboratories");
> +MODULE_LICENSE("GPL v2");
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
