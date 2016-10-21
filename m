Return-path: <linux-media-owner@vger.kernel.org>
Received: from relmlor2.renesas.com ([210.160.252.172]:28256 "EHLO
        relmlie1.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932814AbcJUOti (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Oct 2016 10:49:38 -0400
From: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "mchehab@kernel.org" <mchehab@kernel.org>,
        "hverkuil@xs4all.nl" <hverkuil@xs4all.nl>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
        "crope@iki.fi" <crope@iki.fi>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        "geert@linux-m68k.org" <geert@linux-m68k.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org"
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [RFC 1/5] media: i2c: max2175: Add MAX2175 support
Date: Fri, 21 Oct 2016 14:49:30 +0000
Message-ID: <SG2PR06MB1038BC62A3011C8EAB20B61FC3D40@SG2PR06MB1038.apcprd06.prod.outlook.com>
References: <1476281429-27603-1-git-send-email-ramesh.shanmugasundaram@bp.renesas.com>
 <1476281429-27603-2-git-send-email-ramesh.shanmugasundaram@bp.renesas.com>
 <2034831.3otZHvJ6bZ@avalon>
In-Reply-To: <2034831.3otZHvJ6bZ@avalon>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thank you for the review comments.

> On Wednesday 12 Oct 2016 15:10:25 Ramesh Shanmugasundaram wrote:
> > This patch adds driver support for MAX2175 chip. This is Maxim
> > Integrated's RF to Bits tuner front end chip designed for
> > software-defined radio solutions. This driver exposes the tuner as a
> > sub-device instance with standard and custom controls to configure the
> device.
> >
> > Signed-off-by: Ramesh Shanmugasundaram
> > <ramesh.shanmugasundaram@bp.renesas.com> ---
> >  .../devicetree/bindings/media/i2c/max2175.txt      |   60 +
> >  drivers/media/i2c/Kconfig                          |    4 +
> >  drivers/media/i2c/Makefile                         |    2 +
> >  drivers/media/i2c/max2175/Kconfig                  |    8 +
> >  drivers/media/i2c/max2175/Makefile                 |    4 +
> >  drivers/media/i2c/max2175/max2175.c                | 1624
> +++++++++++++++++
> >  drivers/media/i2c/max2175/max2175.h                |  124 ++
> >  7 files changed, 1826 insertions(+)
> >  create mode 100644
> > Documentation/devicetree/bindings/media/i2c/max2175.txt
> >  create mode 100644 drivers/media/i2c/max2175/Kconfig  create mode
> > 100644 drivers/media/i2c/max2175/Makefile
> >  create mode 100644 drivers/media/i2c/max2175/max2175.c
> >  create mode 100644 drivers/media/i2c/max2175/max2175.h
> >
> > diff --git a/Documentation/devicetree/bindings/media/i2c/max2175.txt
> > b/Documentation/devicetree/bindings/media/i2c/max2175.txt new file
> > mode
> > 100644
> > index 0000000..2250d5f
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/media/i2c/max2175.txt
> > @@ -0,0 +1,60 @@
> > +Maxim Integrated MAX2175 RF to Bits tuner
> > +-----------------------------------------
> > +
> > +The MAX2175 IC is an advanced analog/digital hybrid-radio receiver
> > +with RF to Bits(r) front-end designed for software-defined radio
> solutions.
> > +
> > +Required properties:
> > +--------------------
> > +- compatible: "maxim,max2175" for MAX2175 RF-to-bits tuner.
> > +- clocks: phandle to the fixed xtal clock.
> > +- clock-names: name of the fixed xtal clock.
> > +- port: video interface child port node of a tuner that defines the
> > +local
>=20
> As Rob pointed out in his review of patch 3/5, this isn't video.

Agreed & corrected.

>=20
> > +  and remote endpoints. The remote endpoint is assumed to be an SDR
> > + device  that is capable of receiving the digital samples from the
> tuner.
> > +
> > +Optional properties:
> > +--------------------
> > +- maxim,slave	   : empty property indicates this is a slave of
> another
> > +		     master tuner. This is used to define two tuners in
> > +		     diversity mode (1 master, 1 slave). By default each
> > +		     tuner is an individual master.
>=20
> Would it be useful to make that property a phandle to the master tuner, t=
o
> give drivers a way to access the master ? I haven't checked whether there
> could be use cases for that.

As of now, I cannot find any use case for it from the datasheet. In future,=
 we could add if such need arise.

>=20
> > +- maxim,refout-load: load capacitance value (in pF) on reference outpu=
t
> > +		     drive level. The mapping of these load values to
> > +		     respective bit values are given below.
> > +		     0 - Reference output disabled
> > +		     1 - 10pF load
> > +		     2 - 20pF load
> > +		     3 - 30pF load
> > +		     4 - 40pF load
> > +		     5 - 60pF load
> > +		     6 - 70pF load
>=20
> As Geert pointed out, you can simply specify the value in pF.

Agreed & corrected.

>=20
> > +
> > +Example:
> > +--------
> > +
> > +Board specific DTS file
> > +
> > +/* Fixed XTAL clock node */
> > +maxim_xtal: maximextal {
> > +	compatible =3D "fixed-clock";
> > +	#clock-cells =3D <0>;
> > +	clock-frequency =3D <36864000>;
> > +};
> > +
> > +/* A tuner device instance under i2c bus */
> > +max2175_0: tuner@60 {
> > +	#clock-cells =3D <0>;
>=20
> Is the tuner a clock provider ? If it isn't you don't need this property.

Thanks. It's a copy/paste mistake :-(. Corrected.

>=20
> > +	compatible =3D "maxim,max2175";
> > +	reg =3D <0x60>;
> > +	clocks =3D <&maxim_xtal>;
> > +	clock-names =3D "xtal";
> > +	maxim,refout-load =3D <10>;
> > +
> > +	port {
> > +		max2175_0_ep: endpoint {
> > +			remote-endpoint =3D <&slave_rx_v4l2_sdr_device>;
> > +		};
> > +	};
> > +
> > +};
>=20
> [snip]
>=20
> > diff --git a/drivers/media/i2c/max2175/Makefile
> > b/drivers/media/i2c/max2175/Makefile new file mode 100644 index
> > 0000000..9bb46ac
> > --- /dev/null
> > +++ b/drivers/media/i2c/max2175/Makefile
> > @@ -0,0 +1,4 @@
> > +#
> > +# Makefile for Maxim RF to Bits tuner device #
> > +obj-$(CONFIG_SDR_MAX2175) +=3D max2175.o
>=20
> If there's a single source file you might want to move it to
> drivers/media/i2c/.

MAX2175 is huge with lot more modes and functionality. When more modes are =
added (it's pre-set hex values), we may have to introduce the new file cont=
aining that the hex values alone. Hence, I thought of a folder. However, I =
cannot tell when the next set of modes will be added. So I'll remove the fo=
lder in the next patch.

>=20
> > diff --git a/drivers/media/i2c/max2175/max2175.c
> > b/drivers/media/i2c/max2175/max2175.c new file mode 100644 index
> > 0000000..71b60c2
> > --- /dev/null
> > +++ b/drivers/media/i2c/max2175/max2175.c
> > @@ -0,0 +1,1624 @@
> > +/*
> > + * Maxim Integrated MAX2175 RF to Bits tuner driver
> > + *
> > + * This driver & most of the hard coded values are based on the
> > +reference
> > + * application delivered by Maxim for this chip.
> > + *
> > + * Copyright (C) 2016 Maxim Integrated Products
> > + * Copyright (C) 2016 Renesas Electronics Corporation
> > + *
> > + * This program is free software; you can redistribute it and/or
> > +modify
> > + * it under the terms of the GNU General Public License version 2
> > + * as published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> > + * GNU General Public License for more details.
> > + */
> > +
> > +#include <linux/clk.h>
> > +#include <linux/errno.h>
> > +#include <linux/i2c.h>
> > +#include <linux/init.h>
> > +#include <linux/interrupt.h>
> > +#include <linux/kernel.h>
> > +#include <linux/module.h>
> > +#include <linux/slab.h>
> > +#include <linux/delay.h>
>=20
> You can move delay.h right below clk.h and everything will be in
> alphabetical order :-)

Agreed.

>=20
> > +#include <media/v4l2-ctrls.h>
> > +#include <media/v4l2-device.h>
> > +#include <media/v4l2-of.h>
> > +
> > +#include "max2175.h"
> > +
> > +#define DRIVER_NAME "max2175"
> > +
> > +static unsigned int max2175_debug;
> > +module_param(max2175_debug, uint, 0644);
> > +MODULE_PARM_DESC(max2175_debug, "activate debug info");
>=20
> You can name the parameter "debug".

Agreed

>=20
> > +#define mxm_dbg(ctx, fmt, arg...) \
> > +	v4l2_dbg(1, max2175_debug, &ctx->sd, fmt, ## arg)
>=20
> [snip]
>=20
> > +/* Preset values:
> > + * Based on Maxim MAX2175 Register Table revision: 130p10  */
>=20
> The preferred multi-line comment style is
>=20
> /*
>  * foo
>  * bar
>  */
>=20
Agreed. I used it because checkpatch moaned but then I see Linus's comment =
:-).

> [snip]
>=20
> > +struct max2175_ctx {
>=20
> Nitpicking, such a structure would usually be named max2175 or
> max2175_device.
> Context seems to imply that you can have multiple of them per device.

Thanks for the explanation. I have changed it to max2175.

>=20
> > +	struct v4l2_subdev sd;
> > +	struct i2c_client *client;
> > +	struct device *dev;
> > +
> > +	/* Cached configuration */
> > +	u8 regs[256];
>=20
> If you want to cache register values you should use regmap.

Thanks. I did not know about regmap. I'll try this.

>=20
> > +	enum max2175_modetag mode;	/* Receive mode tag */
> > +	u32 freq;			/* In Hz */
> > +	struct max2175_rxmode *rx_modes;
> > +
> > +	/* Device settings */
> > +	bool master;
> > +	u32 decim_ratio;
> > +	u64 xtal_freq;
> > +
> > +	/* ROM values */
> > +	u8 rom_bbf_bw_am;
> > +	u8 rom_bbf_bw_fm;
> > +	u8 rom_bbf_bw_dab;
> > +
> > +	/* Local copy of old settings */
> > +	u8 i2s_test;
> > +
> > +	u8 nbd_gain;
> > +	u8 nbd_threshold;
> > +	u8 wbd_gain;
> > +	u8 wbd_threshold;
> > +	u8 bbd_threshold;
> > +	u8 bbdclip_threshold;
> > +	u8 lt_wbd_threshold;
> > +	u8 lt_wbd_gain;
> > +
> > +	/* Controls */
> > +	struct v4l2_ctrl_handler ctrl_hdl;
> > +	struct v4l2_ctrl *lna_gain;	/* LNA gain value */
> > +	struct v4l2_ctrl *if_gain;	/* I/F gain value */
> > +	struct v4l2_ctrl *pll_lock;	/* PLL lock */
> > +	struct v4l2_ctrl *i2s_en;	/* I2S output enable */
> > +	struct v4l2_ctrl *i2s_mode;	/* I2S mode value */
> > +	struct v4l2_ctrl *am_hiz;	/* AM High impledance input */
> > +	struct v4l2_ctrl *hsls;		/* High-side/Low-side polarity */
> > +	struct v4l2_ctrl *rx_mode;	/* Receive mode */
> > +
> > +	/* Driver private variables */
> > +	bool mode_resolved;		/* Flag to sanity check settings */
> > +};
>=20
> [snip]
>=20
> > +/* Local store bitops helpers */
> > +static u8 max2175_get_bits(struct max2175_ctx *ctx, u8 idx, u8 msb,
> > +u8 lsb) {
> > +	if (max2175_debug >=3D 2)
> > +		mxm_dbg(ctx, "get_bits: idx:%u msb:%u lsb:%u\n",
> > +			idx, msb, lsb);
>=20
> Do we really need such detailed debugging ?

Unfortunately yes. I'll try to remove this after some more testing or may b=
e later as a separate patch.
I have converted a Windows GUI app code to this driver. Most of the registe=
r details & configuration sequence are not available in the datasheet. I us=
ed similar pattern of log message as in GUI logs because it helps in testin=
g :-(

>=20
> > +	return __max2175_get_bits(ctx->regs[idx], msb, lsb); }
> > +
> > +static bool max2175_get_bit(struct max2175_ctx *ctx, u8 idx, u8 bit)
> > +{
> > +	return !!max2175_get_bits(ctx, idx, bit, bit); }
> > +
> > +static void max2175_set_bits(struct max2175_ctx *ctx, u8 idx,
> > +		      u8 msb, u8 lsb, u8 newval)
> > +{
> > +	if (max2175_debug >=3D 2)
> > +		mxm_dbg(ctx, "set_bits: idx:%u msb:%u lsb:%u newval:%u\n",
> > +			idx, msb, lsb, newval);
> > +	ctx->regs[idx] =3D __max2175_set_bits(ctx->regs[idx], msb, lsb,
> > +					      newval);
> > +}
> > +
> > +static void max2175_set_bit(struct max2175_ctx *ctx, u8 idx, u8 bit,
> > +u8
> > newval)
> > +{
> > +	max2175_set_bits(ctx, idx, bit, bit, newval); }
> > +
> > +/* Device register bitops helpers */
> > +static u8 max2175_read_bits(struct max2175_ctx *ctx, u8 idx, u8 msb,
> > +u8
> > lsb)
> > +{
> > +	return __max2175_get_bits(max2175_reg_read(ctx, idx), msb, lsb); }
> > +
> > +static void max2175_write_bits(struct max2175_ctx *ctx, u8 idx, u8 msb=
,
> > +			u8 lsb, u8 newval)
> > +{
> > +	/* Update local copy & write to device */
> > +	max2175_set_bits(ctx, idx, msb, lsb, newval);
> > +	max2175_reg_write(ctx, idx, ctx->regs[idx]); }
> > +
> > +static void max2175_write_bit(struct max2175_ctx *ctx, u8 idx, u8 bit,
> > +			      u8 newval)
> > +{
> > +	if (max2175_debug >=3D 2)
> > +		mxm_dbg(ctx, "idx %u, bit %u, newval %u\n", idx, bit, newval);
> > +	max2175_write_bits(ctx, idx, bit, bit, newval); }
>=20
> Really, please use regmap :-)

Agreed.

>=20
> > +static int max2175_poll_timeout(struct max2175_ctx *ctx, u8 idx, u8
> > +msb, u8
> > lsb,
> > +				u8 exp_val, u32 timeout)
> > +{
> > +	unsigned long end =3D jiffies + msecs_to_jiffies(timeout);
> > +	int ret;
> > +
> > +	do {
> > +		ret =3D max2175_read_bits(ctx, idx, msb, lsb);
> > +		if (ret < 0)
> > +			return ret;
> > +		if (ret =3D=3D exp_val)
> > +			return 0;
> > +
> > +		usleep_range(1000, 1500);
> > +	} while (time_is_after_jiffies(end));
> > +
> > +	return -EBUSY;
> > +}
> > +
> > +static int max2175_poll_csm_ready(struct max2175_ctx *ctx) {
> > +	return max2175_poll_timeout(ctx, 69, 1, 1, 0, 50);
>=20
> Please define macros for register addresses and values, this is just
> unreadable.

The Tuner provider is unwilling to disclose all register details. I agree o=
n the readability issue with this restriction but this is somewhat true for=
 some sensitive IPs in the media subsystem.

>=20
> > +}
>=20
> [snip]
>=20
> > +
> > +#define MAX2175_IS_BAND_AM(ctx)		\
> > +	(max2175_get_bits(ctx, 5, 1, 0) =3D=3D MAX2175_BAND_AM)
> > +
> > +#define MAX2175_IS_FM_MODE(ctx)		\
> > +	(max2175_get_bits(ctx, 12, 5, 4) =3D=3D 0)
> > +
> > +#define MAX2175_IS_FMHD_MODE(ctx)	\
> > +	(max2175_get_bits(ctx, 12, 5, 4) =3D=3D 1)
> > +
> > +#define MAX2175_IS_DAB_MODE(ctx)	\
> > +	(max2175_get_bits(ctx, 12, 5, 4) =3D=3D 2)
> > +
> > +static int max2175_band_from_freq(u64 freq) {
> > +	if (freq >=3D 144000 && freq <=3D 26100000)
> > +		return MAX2175_BAND_AM;
> > +	else if (freq >=3D 65000000 && freq <=3D 108000000)
> > +		return MAX2175_BAND_FM;
> > +	else if (freq >=3D 160000000 && freq <=3D 240000000)
> > +		return MAX2175_BAND_VHF;
> > +
> > +	/* Add other bands on need basis */
> > +	return -ENOTSUPP;
> > +}
> > +
> > +static int max2175_update_i2s_mode(struct max2175_ctx *ctx, u32
> > +i2s_mode) {
> > +	/* Only change if it's new */
> > +	if (max2175_read_bits(ctx, 29, 2, 0) =3D=3D i2s_mode)
> > +		return 0;
> > +
> > +	max2175_write_bits(ctx, 29, 2, 0, i2s_mode);
> > +
> > +	/* Based on I2S mode value I2S_WORD_CNT values change */
> > +	if (i2s_mode =3D=3D MAX2175_I2S_MODE3) {
> > +		max2175_write_bits(ctx, 30, 6, 0, 1);
> > +	} else if (i2s_mode =3D=3D MAX2175_I2S_MODE2 ||
> > +		   i2s_mode =3D=3D MAX2175_I2S_MODE4) {
> > +		max2175_write_bits(ctx, 30, 6, 0, 0);
> > +	} else if (i2s_mode =3D=3D MAX2175_I2S_MODE0) {
> > +		max2175_write_bits(ctx, 30, 6, 0,
> > +				   ctx->rx_modes[ctx->mode].i2s_word_size);
> > +	} else {
> > +		v4l2_err(ctx->client,
> > +			 "failed: i2s_mode %u unsupported\n", i2s_mode);
>=20
> This should never happen as the control framework will validate control
> values.

Agreed.

>=20
> > +		return 1;
>=20
> Error codes should be negative.

Agreed.

>=20
> > +	}
> > +	mxm_dbg(ctx, "updated i2s_mode %u\n", i2s_mode);
> > +	return 0;
> > +}
>=20
> [snip]
>=20
> > +static void max2175_load_dab_1p2(struct max2175_ctx *ctx) {
> > +	u32 i;
>=20
> unsigned int will do, no need for an explicitly sized type.

Agreed.

>=20
> > +
> > +	/* Master is already set on init */
> > +	for (i =3D 0; i < ARRAY_SIZE(dab12_map); i++)
> > +		max2175_reg_write(ctx, dab12_map[i].idx, dab12_map[i].val);
> > +
> > +	/* The default settings assume master */
> > +	if (!ctx->master)
> > +		max2175_write_bit(ctx, 30, 7, 1);
> > +
> > +	/* Cache i2s_test value at this point */
> > +	ctx->i2s_test =3D max2175_get_bits(ctx, 104, 3, 0);
> > +	ctx->decim_ratio =3D 1;
> > +
> > +	/* Load the Channel Filter Coefficients into channel filter bank #2
> */
> > +	max2175_set_filter_coeffs(ctx, MAX2175_CH_MSEL, 2, ch_coeff_dab1); }
>=20
> [snip]
>=20
> > +static bool max2175_set_csm_mode(struct max2175_ctx *ctx,
> > +			  enum max2175_csm_mode new_mode)
> > +{
> > +	int ret =3D max2175_poll_csm_ready(ctx);
> > +
> > +	if (ret) {
> > +		v4l2_err(ctx->client, "csm not ready: new mode %d\n",
> new_mode);
> > +		return ret;
> > +	}
> > +
> > +	mxm_dbg(ctx, "set csm mode: new mode %d\n", new_mode);
> > +
> > +	max2175_write_bits(ctx, 0, 2, 0, new_mode);
> > +
> > +	/* Wait for a fixed settle down time depending on new mode and band
> */
> > +	switch (new_mode) {
> > +	case MAX2175_CSM_MODE_JUMP_FAST_TUNE:
> > +		if (MAX2175_IS_BAND_AM(ctx)) {
> > +			usleep_range(1250, 1500);	/* 1.25ms */
> > +		} else {
> > +			if (MAX2175_IS_DAB_MODE(ctx))
> > +				usleep_range(3000, 3500);	/* 3ms */
> > +			else
> > +				usleep_range(1250, 1500);	/* 1.25ms */
> > +		}
>=20
> You can write this as
>=20
> 		if (MAX2175_IS_BAND_AM(ctx))
> 			usleep_range(1250, 1500);	/* 1.25ms */
> 		else if (MAX2175_IS_DAB_MODE(ctx))
> 			usleep_range(3000, 3500);	/* 3ms */
> 		else
> 			usleep_range(1250, 1500);	/* 1.25ms */

Agreed.

>=20
>=20
> > +		break;
> > +
> > +	/* Other mode switches can be added in the future if needed */
> > +	default:
> > +		break;
> > +	}
> > +
> > +	ret =3D max2175_poll_csm_ready(ctx);
> > +	if (ret) {
> > +		v4l2_err(ctx->client, "csm did not settle: new mode %d\n",
> > +			 new_mode);
> > +		return ret;
> > +	}
> > +	return ret;
> > +}
>=20
> [snip]
>=20
> > +
> > +static int max2175_csm_action(struct max2175_ctx *ctx,
> > +			      enum max2175_csm_mode action) {
> > +	int ret;
> > +	int load_buffer =3D MAX2175_CSM_MODE_LOAD_TO_BUFFER;
> > +
> > +	mxm_dbg(ctx, "csm action: %d\n", action);
> > +
> > +	/* Perform one or two CSM mode commands. */
> > +	switch (action)	{
> > +	case MAX2175_CSM_MODE_NO_ACTION:
> > +		/* Take no FSM Action. */
> > +		return 0;
> > +	case MAX2175_CSM_MODE_LOAD_TO_BUFFER:
> > +	case MAX2175_CSM_MODE_PRESET_TUNE:
> > +	case MAX2175_CSM_MODE_SEARCH:
> > +	case MAX2175_CSM_MODE_AF_UPDATE:
> > +	case MAX2175_CSM_MODE_JUMP_FAST_TUNE:
> > +	case MAX2175_CSM_MODE_CHECK:
> > +	case MAX2175_CSM_MODE_LOAD_AND_SWAP:
> > +	case MAX2175_CSM_MODE_END:
> > +		ret =3D max2175_set_csm_mode(ctx, action);
> > +		break;
> > +	case MAX2175_CSM_MODE_BUFFER_PLUS_PRESET_TUNE:
> > +		ret =3D max2175_set_csm_mode(ctx, load_buffer);
> > +		if (ret) {
> > +			v4l2_err(ctx->client, "csm action %d load buf
> failed\n",
> > +				 action);
> > +			break;
> > +		}
> > +		ret =3D max2175_set_csm_mode(ctx, MAX2175_CSM_MODE_PRESET_TUNE);
> > +		break;
> > +	case MAX2175_CSM_MODE_BUFFER_PLUS_SEARCH:
> > +		ret =3D max2175_set_csm_mode(ctx, load_buffer);
> > +		if (ret) {
> > +			v4l2_err(ctx->client, "csm action %d load buf
> failed\n",
> > +				 action);
> > +			break;
> > +		}
>=20
> Don't duplicate the error messages, move them after the switch statement.

Agreed. The error messages are not needed as the csm_mode function logs the=
 mode argument in error log. Cleaned up.

>=20
> > +		ret =3D max2175_set_csm_mode(ctx, MAX2175_CSM_MODE_SEARCH);
> > +		break;
> > +	case MAX2175_CSM_MODE_BUFFER_PLUS_AF_UPDATE:
> > +		ret =3D max2175_set_csm_mode(ctx, load_buffer);
> > +		if (ret) {
> > +			v4l2_err(ctx->client, "csm action %d load buf
> failed\n",
> > +				 action);
> > +			break;
> > +		}
> > +		ret =3D max2175_set_csm_mode(ctx, MAX2175_CSM_MODE_AF_UPDATE);
> > +		break;
> > +	case MAX2175_CSM_MODE_BUFFER_PLUS_JUMP_FAST_TUNE:
>=20
> This function is only called with action set to
> MAX2175_CSM_MODE_BUFFER_PLUS_JUMP_FAST_TUNE. I'd remove the rest of the
> code for now, unless you have a plan to use it soon.

I'll remove. As mentioned earlier, I cannot tell how soon the other modes w=
ill be added. There are few other places with placeholders for other modes.=
 I'll try to clean.

>=20
> > +		ret =3D max2175_set_csm_mode(ctx, load_buffer);
> > +		if (ret) {
> > +			v4l2_err(ctx->client, "csm action %d load buf
> failed\n",
> > +				 action);
> > +			break;
> > +		}
> > +		ret =3D max2175_set_csm_mode(ctx,
> > +					   MAX2175_CSM_MODE_JUMP_FAST_TUNE);
> > +		break;
> > +	case MAX2175_CSM_MODE_BUFFER_PLUS_CHECK:
> > +		ret =3D max2175_set_csm_mode(ctx, load_buffer);
> > +		if (ret) {
> > +			v4l2_err(ctx->client, "csm action %d load buf
> failed\n",
> > +				 action);
> > +			break;
> > +		}
> > +		ret =3D max2175_set_csm_mode(ctx, MAX2175_CSM_MODE_CHECK);
> > +		break;
> > +	case MAX2175_CSM_MODE_BUFFER_PLUS_LOAD_AND_SWAP:
> > +		ret =3D max2175_set_csm_mode(ctx, load_buffer);
> > +		if (ret) {
> > +			v4l2_err(ctx->client, "csm action %d load buf
> failed\n",
> > +				 action);
> > +			break;
> > +		}
> > +		ret =3D max2175_set_csm_mode(ctx,
> MAX2175_CSM_MODE_LOAD_AND_SWAP);
> > +		break;
> > +	default:
> > +		ret =3D max2175_set_csm_mode(ctx, MAX2175_CSM_MODE_NO_ACTION);
> > +		break;
> > +	}
> > +	return ret;
> > +}
> > +
> > +static int max2175_set_lo_freq(struct max2175_ctx *ctx, u64 lo_freq)
> > +{
> > +	int ret;
> > +	u32 lo_mult;
> > +	u64 scaled_lo_freq;
> > +	const u64 scale_factor =3D 1000000ULL;
> > +	u64 scaled_npf, scaled_integer, scaled_fraction;
> > +	u32 frac_desired, int_desired;
> > +	u8 loband_bits, vcodiv_bits;
>=20
> Do you really support frequencies above 4GHz ?=20

Nope.=20

If not most of the 64-bit
> values could be stored in 32 bits.

The 64bit variables are needed to extract the fractional part (upto 6 digit=
 precision) out of floating point divisions (original user space code).

>=20
> > +
> > +	scaled_lo_freq =3D lo_freq;
> > +	/* Scale to larger number for precision */
> > +	scaled_lo_freq =3D scaled_lo_freq * scale_factor * 100;
> > +
> > +	mxm_dbg(ctx, "scaled lo_freq %llu lo_freq %llu\n",
> > +		scaled_lo_freq, lo_freq);
> > +
> > +	if (MAX2175_IS_BAND_AM(ctx)) {
> > +		if (max2175_get_bit(ctx, 5, 7) =3D=3D 0)
> > +			loband_bits =3D 0;
> > +			vcodiv_bits =3D 0;
> > +			lo_mult =3D 16;
> > +	} else if (max2175_get_bits(ctx, 5, 1, 0) =3D=3D MAX2175_BAND_FM) {
> > +		if (lo_freq <=3D 74700000) {
> > +			loband_bits =3D 0;
> > +			vcodiv_bits =3D 0;
> > +			lo_mult =3D 16;
> > +		} else if ((lo_freq > 74700000) && (lo_freq <=3D 110000000)) {
>=20
> No need for the inner parentheses.

Agreed.

>=20
> > +			loband_bits =3D 1;
> > +			vcodiv_bits =3D 0;
> > +		} else {
> > +			loband_bits =3D 1;
> > +			vcodiv_bits =3D 3;
> > +		}
> > +		lo_mult =3D 8;
> > +	} else if (max2175_get_bits(ctx, 5, 1, 0) =3D=3D MAX2175_BAND_VHF) {
> > +		if (lo_freq <=3D 210000000) {
> > +			loband_bits =3D 2;
> > +			vcodiv_bits =3D 2;
> > +		} else {
> > +			loband_bits =3D 2;
> > +			vcodiv_bits =3D 1;
> > +		}
> > +		lo_mult =3D 4;
> > +	} else {
> > +		loband_bits =3D 3;
> > +		vcodiv_bits =3D 2;
> > +		lo_mult =3D 2;
> > +	}
> > +
> > +	if (max2175_get_bits(ctx, 5, 1, 0) =3D=3D MAX2175_BAND_L)
> > +		scaled_npf =3D (scaled_lo_freq / ctx->xtal_freq / lo_mult) /
> 100;
> > +	else
> > +		scaled_npf =3D (scaled_lo_freq / ctx->xtal_freq * lo_mult) /
> 100;
> > +
> > +	scaled_integer =3D scaled_npf / scale_factor * scale_factor;
> > +	int_desired =3D (u32)(scaled_npf / scale_factor);
> > +	scaled_fraction =3D scaled_npf - scaled_integer;
> > +	frac_desired =3D (u32)(scaled_fraction * 1048576 / scale_factor);
> > +
> > +	/* Check CSM is not busy */
> > +	ret =3D max2175_poll_csm_ready(ctx);
> > +	if (ret) {
> > +		v4l2_err(ctx->client, "lo_freq: csm busy. freq %llu\n",
> > +			 lo_freq);
> > +		return ret;
> > +	}
> > +
> > +	mxm_dbg(ctx, "loband %u vcodiv %u lo_mult %u scaled_npf %llu\n",
> > +		loband_bits, vcodiv_bits, lo_mult, scaled_npf);
> > +	mxm_dbg(ctx, "scaled int %llu frac %llu desired int %u frac %u\n",
> > +		scaled_integer, scaled_fraction, int_desired, frac_desired);
> > +
> > +	/* Write the calculated values to the appropriate registers */
> > +	max2175_set_bits(ctx, 5, 3, 2, loband_bits);
> > +	max2175_set_bits(ctx, 6, 7, 6, vcodiv_bits);
> > +	max2175_set_bits(ctx, 1, 7, 0, (u8)(int_desired & 0xff));
> > +	max2175_set_bits(ctx, 2, 3, 0, (u8)((frac_desired >> 16) & 0x1f));
> > +	max2175_set_bits(ctx, 3, 7, 0, (u8)((frac_desired >> 8) & 0xff));
> > +	max2175_set_bits(ctx, 4, 7, 0, (u8)(frac_desired & 0xff));
> > +	/* Flush the above registers to device */
> > +	max2175_flush_regstore(ctx, 1, 6);
> > +	return ret;
> > +}
>=20
> [snip]
>=20
> > +static int max2175_set_rf_freq_non_am_bands(struct max2175_ctx *ctx,
> > +u64
> > freq,
> > +					    u32 lo_pos)
> > +{
> > +	int ret;
> > +	s64 adj_freq;
> > +	u64 low_if_freq;
> > +
> > +	mxm_dbg(ctx, "rf_freq: non AM bands\n");
> > +
> > +	if (MAX2175_IS_FM_MODE(ctx))
> > +		low_if_freq =3D 128000;
> > +	else if (MAX2175_IS_FMHD_MODE(ctx))
> > +		low_if_freq =3D 228000;
> > +	else
> > +		return max2175_set_lo_freq(ctx, freq);
> > +
> > +	if (max2175_get_bits(ctx, 5, 1, 0) =3D=3D MAX2175_BAND_VHF) {
>=20
> You perform this check in multiple places, you could create a helper
> function.

Agreed.

>=20
> > +		if (lo_pos =3D=3D MAX2175_LO_ABOVE_DESIRED)
> > +			adj_freq =3D freq + low_if_freq;
> > +		else
> > +			adj_freq =3D freq - low_if_freq;
> > +	} else {
> > +		if (lo_pos =3D=3D MAX2175_LO_ABOVE_DESIRED)
> > +			adj_freq =3D freq - low_if_freq;
> > +		else
> > +			adj_freq =3D freq + low_if_freq;
> > +	}
>=20
> This could be written
>=20
> 	if ((max2175_get_bits(ctx, 5, 1, 0) =3D=3D MAX2175_BAND_VHF) =3D=3D
> 	    (lo_pos =3D=3D MAX2175_LO_ABOVE_DESIRED))
> 		adj_freq =3D freq + low_if_freq;
> 	else
> 		adj_freq =3D freq - low_if_freq;
>=20
> Same for the other similar constructs in the driver. Up to you.

Agreed. Nice :-)

>=20
> > +
> > +	ret =3D max2175_set_lo_freq(ctx, adj_freq);
> > +	if (ret)
> > +		return ret;
> > +
> > +	return max2175_set_nco_freq(ctx, low_if_freq); }
>=20
> [snip]
>=20
> > +#define max2175_ctx_from_sd(x)	\
> > +	container_of(x, struct max2175_ctx, sd)
> > +#define max2175_ctx_from_ctrl(x)	\
> > +	container_of(x, struct max2175_ctx, ctrl_hdl)
>=20
> I'd move it right after the structure definition, and turn them into
> static inline functions.

Agreed.

>=20
> > +static int max2175_s_ctrl(struct v4l2_ctrl *ctrl) {
> > +	struct max2175_ctx *ctx =3D max2175_ctx_from_ctrl(ctrl->handler);
> > +	int ret =3D 0;
> > +
> > +	mxm_dbg(ctx, "s_ctrl: id 0x%x, val %u\n", ctrl->id, ctrl->val);
> > +	switch (ctrl->id) {
> > +	case V4L2_CID_MAX2175_I2S_EN:
> > +		max2175_i2s_enable(ctx, ctrl->val =3D=3D 1);
> > +		break;
> > +	case V4L2_CID_MAX2175_I2S_MODE:
> > +		max2175_s_ctrl_i2s_mode(ctx, ctrl->val);
> > +		break;
> > +	case V4L2_CID_MAX2175_AM_HIZ:
> > +		v4l2_ctrl_activate(ctx->am_hiz, false);
> > +		break;
> > +	case V4L2_CID_MAX2175_HSLS:
> > +		v4l2_ctrl_activate(ctx->hsls, false);
> > +		break;
> > +	case V4L2_CID_MAX2175_RX_MODE:
> > +		mxm_dbg(ctx, "rx mode %u\n", ctrl->val);
> > +		max2175_s_ctrl_rx_mode(ctx, ctrl->val);
> > +		break;
> > +	default:
> > +		v4l2_err(ctx->client, "s:invalid ctrl id 0x%x\n", ctrl->id);
> > +		ret =3D -EINVAL;
>=20
> This should never happen. The driver has too many error and debug message=
s
> overall.

Agreed :-). Will clean up.
=20
> > +	}
> > +
> > +	return ret;
> > +}
> > +
> > +static int max2175_get_lna_gain(struct max2175_ctx *ctx) {
> > +	int gain =3D 0;
> > +	enum max2175_band band =3D max2175_get_bits(ctx, 5, 1, 0);
> > +
> > +	switch (band) {
> > +	case MAX2175_BAND_AM:
> > +		gain =3D max2175_read_bits(ctx, 51, 3, 1);
> > +		break;
> > +	case MAX2175_BAND_FM:
> > +		gain =3D max2175_read_bits(ctx, 50, 3, 1);
> > +		break;
> > +	case MAX2175_BAND_VHF:
> > +		gain =3D max2175_read_bits(ctx, 52, 3, 0);
> > +		break;
> > +	default:
> > +		v4l2_err(ctx->client, "invalid band %d to get rf gain\n",
> band);
>=20
> Can this happen ?

Yes, there is "L-band". It is a paranoia check as I am testing by comparing=
 logs sometimes :-(

>=20
> > +		break;
> > +	}
> > +	return gain;
> > +}
> > +
> > +static int max2175_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
> > +{
> > +	struct max2175_ctx *ctx =3D max2175_ctx_from_ctrl(ctrl->handler);
> > +
> > +	/* Only the dynamically changing values need to be in
> g_volatile_ctrl
> */
> > +	mxm_dbg(ctx, "g_volatile_ctrl: id 0x%x\n", ctrl->id);
> > +	switch (ctrl->id) {
> > +	case V4L2_CID_RF_TUNER_LNA_GAIN:
> > +		ctrl->val =3D max2175_get_lna_gain(ctx);
> > +		break;
> > +	case V4L2_CID_RF_TUNER_IF_GAIN:
> > +		ctrl->val =3D max2175_read_bits(ctx, 49, 4, 0);
> > +		break;
> > +	case V4L2_CID_RF_TUNER_PLL_LOCK:
> > +		ctrl->val =3D (max2175_read_bits(ctx, 60, 7, 6) =3D=3D 3);
> > +		break;
> > +	default:
> > +		v4l2_err(ctx->client, "g:invalid ctrl id 0x%x\n", ctrl->id);
>=20
> This should never happen either.

I agree.

>=20
> > +		return -EINVAL;
> > +	}
> > +	mxm_dbg(ctx, "g_volatile_ctrl: id 0x%x val %d\n", ctrl->id, ctrl-
> >val);
> > +	return 0;
> > +};
>=20
> [snip]
>=20
> > +static const struct v4l2_ctrl_config max2175_i2s_en =3D {
> > +	.ops =3D &max2175_ctrl_ops,
> > +	.id =3D V4L2_CID_MAX2175_I2S_EN,
>=20
> V4L2_CID_MAX2175_I2S_ENABLE ?

Agreed.

>=20
> > +	.name =3D "I2S Enable",
> > +	.type =3D V4L2_CTRL_TYPE_BOOLEAN,
> > +	.min =3D 0,
> > +	.max =3D 1,
> > +	.step =3D 1,
> > +	.def =3D 1,
> > +};
> > +
> > +static const struct v4l2_ctrl_config max2175_i2s_mode =3D {
> > +	.ops =3D &max2175_ctrl_ops,
> > +	.id =3D V4L2_CID_MAX2175_I2S_MODE,
> > +	.name =3D "I2S_MODE value",
> > +	.type =3D V4L2_CTRL_TYPE_INTEGER,
>=20
> Should this be a menu control ?

Hmm... the strings would be named "i2s mode x"? Will that be OK?=20

>=20
> > +	.min =3D 0,
> > +	.max =3D 4,
> > +	.step =3D 1,
> > +	.def =3D 0,
> > +};
> > +
> > +static const struct v4l2_ctrl_config max2175_am_hiz =3D {
> > +	.ops =3D &max2175_ctrl_ops,
> > +	.id =3D V4L2_CID_MAX2175_AM_HIZ,
> > +	.name =3D "AM High impedance input",
> > +	.type =3D V4L2_CTRL_TYPE_BOOLEAN,
> > +	.min =3D 0,
> > +	.max =3D 1,
> > +	.step =3D 1,
> > +	.def =3D 0,
> > +};
> > +
> > +static const struct v4l2_ctrl_config max2175_hsls =3D {
> > +	.ops =3D &max2175_ctrl_ops,
> > +	.id =3D V4L2_CID_MAX2175_HSLS,
> > +	.name =3D "HSLS above/below desired",
> > +	.type =3D V4L2_CTRL_TYPE_INTEGER,
> > +	.min =3D 0,
> > +	.max =3D 1,
> > +	.step =3D 1,
> > +	.def =3D 1,
> > +};
> > +
> > +
> > +/* NOTE: Any addition/deletion in the below list should be reflected i=
n
> > + * max2175_modetag enum
> > + */
> > +static const char * const max2175_ctrl_eu_rx_mode_strings[] =3D {
> > +	"DAB 1.2",
> > +	"NULL",
>=20
> Do you really mean "NULL", not NULL ?

Sorry, That's cut/paste from vivid-ctrl. I have cleaned it up with designat=
ed initializers as Geert pointed out.

>=20
> > +};
> > +
> > +static const char * const max2175_ctrl_na_rx_mode_strings[] =3D {
> > +	"NA FM 1.0",
> > +	"NULL",
> > +};
> > +
> > +static const struct v4l2_ctrl_config max2175_eu_rx_mode =3D {
> > +	.ops =3D &max2175_ctrl_ops,
> > +	.id =3D V4L2_CID_MAX2175_RX_MODE,
> > +	.name =3D "RX MODE",
> > +	.type =3D V4L2_CTRL_TYPE_MENU,
> > +	.max =3D ARRAY_SIZE(max2175_ctrl_eu_rx_mode_strings) - 2,
>=20
> If there's a single mode supported I'd skip adding those controls for now=
.

I'll try to add one more mode support if time permits. The menu looks much =
readable with v4l2-ctl & comparing the same with datasheet.

>=20
> > +	.def =3D 0,
> > +	.qmenu =3D max2175_ctrl_eu_rx_mode_strings,
> > +};
> > +
> > +static const struct v4l2_ctrl_config max2175_na_rx_mode =3D {
> > +	.ops =3D &max2175_ctrl_ops,
> > +	.id =3D V4L2_CID_MAX2175_RX_MODE,
> > +	.name =3D "RX MODE",
> > +	.type =3D V4L2_CTRL_TYPE_MENU,
> > +	.max =3D ARRAY_SIZE(max2175_ctrl_na_rx_mode_strings) - 2,
> > +	.def =3D 0,
> > +	.qmenu =3D max2175_ctrl_na_rx_mode_strings,
> > +};
> > +
> > +static u32 max2175_refout_load_to_bits(struct i2c_client *client, u32
> load)
> > +{
> > +	u32 bits =3D 0;	/* REFOUT disabled */
> > +
> > +	if (load >=3D 0 && load <=3D 40)
> > +		bits =3D load / 10;
> > +	else if (load >=3D 60 && load <=3D 70)
> > +		bits =3D load / 10 - 1;
> > +	else
> > +		dev_warn(&client->dev, "invalid refout_load %u\n", load);
>=20
> Your DT bindings specify 0 as a valid value.

Agreed. The DT values are changed to 10-70 range.

>=20
> An invalid value specified in DT should be a fatal error.

OK. Will correct this.

>=20
> > +
> > +	return bits;
> > +}
> > +
> > +static int max2175_probe(struct i2c_client *client,
> > +			const struct i2c_device_id *id)
> > +{
> > +	struct max2175_ctx *ctx;
> > +	struct device *dev =3D &client->dev;
> > +	struct v4l2_subdev *sd;
> > +	struct v4l2_ctrl_handler *hdl;
> > +	struct clk *clk;
> > +	bool master =3D true;
> > +	u32 refout_load, refout_bits =3D 0;	/* REFOUT disabled */
> > +	int ret;
> > +
> > +	/* Check if the adapter supports the needed features */
> > +	if (!i2c_check_functionality(client->adapter,
> > +				     I2C_FUNC_SMBUS_BYTE_DATA)) {
> > +		dev_err(&client->dev, "i2c check failed\n");
> > +		return -EIO;
> > +	}
> > +
> > +	if (of_find_property(client->dev.of_node, "maxim,slave", NULL))
> > +		master =3D false;
> > +
> > +	if (!of_property_read_u32(client->dev.of_node, "maxim,refout-load",
> > +				 &refout_load))
> > +		refout_bits =3D max2175_refout_load_to_bits(client,
> refout_load);
> > +
> > +	clk =3D devm_clk_get(&client->dev, "xtal");
> > +	if (IS_ERR(clk)) {
> > +		ret =3D PTR_ERR(clk);
> > +		dev_err(&client->dev, "cannot get xtal clock %d\n", ret);
> > +		return -ENODEV;
> > +	}
> > +
> > +	ctx =3D kzalloc(sizeof(struct max2175_ctx),
>=20
> sizeof(*ctx)
>=20
> > +			     GFP_KERNEL);
>=20
> This fits on one line.

Yes, corrected in last cleanup.

>=20
> > +	if (ctx =3D=3D NULL)
> > +		return -ENOMEM;
> > +
> > +	sd =3D &ctx->sd;
> > +	ctx->master =3D master;
> > +	ctx->mode_resolved =3D false;
> > +
> > +	/* Set the defaults */
> > +	ctx->freq =3D bands_rf.rangelow;
> > +
> > +	ctx->xtal_freq =3D clk_get_rate(clk);
> > +	dev_info(&client->dev, "xtal freq %lluHz\n", ctx->xtal_freq);
> > +
> > +	v4l2_i2c_subdev_init(sd, client, &max2175_ops);
> > +	ctx->client =3D client;
> > +
> > +	sd->flags =3D V4L2_SUBDEV_FL_HAS_DEVNODE;
> > +	ctx->dev =3D dev;
> > +
> > +	/* Controls */
> > +	hdl =3D &ctx->ctrl_hdl;
> > +	ret =3D v4l2_ctrl_handler_init(hdl, 8);
> > +	if (ret) {
> > +		dev_err(&client->dev, "ctrl handler init failed\n");
> > +		goto err;
> > +	}
> > +
> > +	ctx->lna_gain =3D v4l2_ctrl_new_std(hdl, &max2175_ctrl_ops,
> > +					  V4L2_CID_RF_TUNER_LNA_GAIN,
> > +					  0, 15, 1, 2);
> > +	ctx->lna_gain->flags |=3D (V4L2_CTRL_FLAG_VOLATILE |
> > +				 V4L2_CTRL_FLAG_READ_ONLY);
> > +	ctx->if_gain =3D v4l2_ctrl_new_std(hdl, &max2175_ctrl_ops,
> > +					 V4L2_CID_RF_TUNER_IF_GAIN,
> > +					 0, 31, 1, 0);
> > +	ctx->if_gain->flags |=3D (V4L2_CTRL_FLAG_VOLATILE |
> > +				V4L2_CTRL_FLAG_READ_ONLY);
> > +	ctx->pll_lock =3D v4l2_ctrl_new_std(hdl, &max2175_ctrl_ops,
> > +					  V4L2_CID_RF_TUNER_PLL_LOCK,
> > +					  0, 1, 1, 0);
> > +	ctx->pll_lock->flags |=3D (V4L2_CTRL_FLAG_VOLATILE |
> > +				 V4L2_CTRL_FLAG_READ_ONLY);
> > +	ctx->i2s_en =3D v4l2_ctrl_new_custom(hdl, &max2175_i2s_en, NULL);
> > +	ctx->i2s_mode =3D v4l2_ctrl_new_custom(hdl, &max2175_i2s_mode, NULL);
> > +	ctx->am_hiz =3D v4l2_ctrl_new_custom(hdl, &max2175_am_hiz, NULL);
> > +	ctx->hsls =3D v4l2_ctrl_new_custom(hdl, &max2175_hsls, NULL);
> > +
> > +	if (ctx->xtal_freq =3D=3D MAX2175_EU_XTAL_FREQ) {
> > +		ctx->rx_mode =3D v4l2_ctrl_new_custom(hdl,
> > +						    &max2175_eu_rx_mode,
> NULL);
> > +		ctx->rx_modes =3D (struct max2175_rxmode *)eu_rx_modes;
> > +	} else {
> > +		ctx->rx_mode =3D v4l2_ctrl_new_custom(hdl,
> > +						    &max2175_na_rx_mode,
> NULL);
> > +		ctx->rx_modes =3D (struct max2175_rxmode *)na_rx_modes;
> > +	}
> > +	ctx->sd.ctrl_handler =3D &ctx->ctrl_hdl;
> > +
> > +	ret =3D v4l2_async_register_subdev(sd);
> > +	if (ret) {
> > +		dev_err(&client->dev, "register subdev failed\n");
> > +		goto err_reg;
> > +	}
> > +	dev_info(&client->dev, "subdev registered\n");
> > +
> > +	/* Initialize device */
> > +	ret =3D max2175_core_init(ctx, refout_bits);
> > +	if (ret)
> > +		goto err_init;
> > +
> > +	mxm_dbg(ctx, "probed\n");
> > +	return 0;
> > +
> > +err_init:
> > +	v4l2_async_unregister_subdev(sd);
> > +err_reg:
> > +	v4l2_ctrl_handler_free(&ctx->ctrl_hdl);
> > +err:
> > +	kfree(ctx);
> > +	return ret;
> > +}
> > +
> > +static int max2175_remove(struct i2c_client *client)
> > +{
> > +	struct v4l2_subdev *sd =3D i2c_get_clientdata(client);
> > +	struct max2175_ctx *ctx =3D max2175_ctx_from_sd(sd);
> > +
> > +	v4l2_ctrl_handler_free(&ctx->ctrl_hdl);
> > +	v4l2_async_unregister_subdev(sd);
> > +	mxm_dbg(ctx, "removed\n");
> > +	kfree(ctx);
> > +	return 0;
> > +}
> > +
> > +static const struct i2c_device_id max2175_id[] =3D {
> > +	{ DRIVER_NAME, 0},
> > +	{},
> > +};
> > +
>=20
> No need for a blank line here.

Agreed.

>=20
> > +MODULE_DEVICE_TABLE(i2c, max2175_id);
> > +
> > +static const struct of_device_id max2175_of_ids[] =3D {
> > +	{ .compatible =3D "maxim, max2175", },
> > +	{ }
> > +};
> > +MODULE_DEVICE_TABLE(of, max2175_of_ids);
> > +
> > +static struct i2c_driver max2175_driver =3D {
> > +	.driver =3D {
> > +		.name	=3D DRIVER_NAME,
> > +		.of_match_table =3D max2175_of_ids,
> > +	},
> > +	.probe		=3D max2175_probe,
> > +	.remove		=3D max2175_remove,
> > +	.id_table	=3D max2175_id,
> > +};
> > +
> > +module_i2c_driver(max2175_driver);
> > +
> > +MODULE_DESCRIPTION("Maxim MAX2175 RF to Bits tuner driver");
> > +MODULE_LICENSE("GPL v2");
> > +MODULE_AUTHOR("Ramesh Shanmugasundaram
> > <ramesh.shanmugasundaram@bp.renesas.com>"); diff --git
> > a/drivers/media/i2c/max2175/max2175.h
> b/drivers/media/i2c/max2175/max2175.h
> > new file mode 100644
> > index 0000000..61a508b
> > --- /dev/null
> > +++ b/drivers/media/i2c/max2175/max2175.h
> > @@ -0,0 +1,124 @@
> > +/*
> > + * Maxim Integrated MAX2175 RF to Bits tuner driver
> > + *
> > + * This driver & most of the hard coded values are based on the
> reference
> > + * application delivered by Maxim for this chip.
> > + *
> > + * Copyright (C) 2016 Maxim Integrated Products
> > + * Copyright (C) 2016 Renesas Electronics Corporation
> > + *
> > + * This program is free software; you can redistribute it and/or modif=
y
> > + * it under the terms of the GNU General Public License version 2
> > + * as published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> > + * GNU General Public License for more details.
> > + */
> > +
> > +#ifndef __MAX2175_H__
> > +#define __MAX2175_H__
> > +
> > +#include <linux/types.h>
> > +
> > +enum max2175_region {
> > +	MAX2175_REGION_EU =3D 0,	/* Europe */
> > +	MAX2175_REGION_NA,	/* North America */
> > +};
> > +
> > +#define MAX2175_EU_XTAL_FREQ	(36864000)	/* In Hz */
> > +#define MAX2175_NA_XTAL_FREQ	(40186125)	/* In Hz */
> > +
> > +enum max2175_band {
> > +	MAX2175_BAND_AM =3D 0,
> > +	MAX2175_BAND_FM,
> > +	MAX2175_BAND_VHF,
> > +	MAX2175_BAND_L,
> > +};
> > +
> > +/* NOTE: Any addition/deletion in the below enum should be reflected i=
n
> > + * V4L2_CID_MAX2175_RX_MODE ctrl strings
> > + */
> > +enum max2175_modetag {
> > +	/* EU modes */
> > +	MAX2175_DAB_1_2 =3D 0,
> > +
> > +	/* Other possible modes to add in future
> > +	 * MAX2175_DAB_1_0,
> > +	 * MAX2175_DAB_1_3,
> > +	 * MAX2175_EU_FM_2_2,
> > +	 * MAX2175_EU_FM_1_0,
> > +	 * MAX2175_EU_FMHD_4_0,
> > +	 * MAX2175_EU_AM_1_0,
> > +	 * MAX2175_EU_AM_2_2,
> > +	 */
> > +
> > +	/* NA modes */
> > +	MAX2175_NA_FM_1_0 =3D 0,
> > +
> > +	/* Other possible modes to add in future
> > +	 * MAX2175_NA_FM_1_2,
> > +	 * MAX2175_NA_FMHD_1_0,
> > +	 * MAX2175_NA_FMHD_1_2,
> > +	 * MAX2175_NA_AM_1_0,
> > +	 * MAX2175_NA_AM_1_2,
> > +	 */
> > +};
> > +
> > +/* Supported I2S modes */
> > +enum {
> > +	MAX2175_I2S_MODE0 =3D 0,
> > +	MAX2175_I2S_MODE1,
> > +	MAX2175_I2S_MODE2,
> > +	MAX2175_I2S_MODE3,
> > +	MAX2175_I2S_MODE4,
> > +};
> > +
> > +/* Coefficient table groups */
> > +enum {
> > +	MAX2175_CH_MSEL =3D 0,
> > +	MAX2175_EQ_MSEL,
> > +	MAX2175_AA_MSEL,
> > +};
> > +
> > +/* HSLS LO injection polarity */
> > +enum {
> > +	MAX2175_LO_BELOW_DESIRED =3D 0,
> > +	MAX2175_LO_ABOVE_DESIRED,
> > +};
> > +
> > +/* Channel FSM modes */
> > +enum max2175_csm_mode {
> > +	MAX2175_CSM_MODE_LOAD_TO_BUFFER =3D 0,
> > +	MAX2175_CSM_MODE_PRESET_TUNE,
> > +	MAX2175_CSM_MODE_SEARCH,
> > +	MAX2175_CSM_MODE_AF_UPDATE,
> > +	MAX2175_CSM_MODE_JUMP_FAST_TUNE,
> > +	MAX2175_CSM_MODE_CHECK,
> > +	MAX2175_CSM_MODE_LOAD_AND_SWAP,
> > +	MAX2175_CSM_MODE_END,
> > +	MAX2175_CSM_MODE_BUFFER_PLUS_PRESET_TUNE,
> > +	MAX2175_CSM_MODE_BUFFER_PLUS_SEARCH,
> > +	MAX2175_CSM_MODE_BUFFER_PLUS_AF_UPDATE,
> > +	MAX2175_CSM_MODE_BUFFER_PLUS_JUMP_FAST_TUNE,
> > +	MAX2175_CSM_MODE_BUFFER_PLUS_CHECK,
> > +	MAX2175_CSM_MODE_BUFFER_PLUS_LOAD_AND_SWAP,
> > +	MAX2175_CSM_MODE_NO_ACTION
> > +};
> > +
> > +/* Rx mode */
> > +struct max2175_rxmode {
> > +	enum max2175_band band;		/* Associated band */
> > +	u32 freq;			/* Default freq in Hz */
> > +	u8 i2s_word_size;		/* Bit value */
> > +	u8 i2s_modes[4];		/* Supported modes */
> > +};
> > +
> > +/* Register map */
> > +struct max2175_regmap {
> > +	u8 idx;				/* Register index */
> > +	u8 val;				/* Register value */
> > +};
>=20
> As no other file than max2175.c includes this, I would move at least the
> structure definitions to the .c file.

Agreed.

Thanks a lot for all the comments and suggestions. I'll post the next versi=
on soon.

Thanks,
Ramesh
