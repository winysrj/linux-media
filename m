Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:60496 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755606AbcJRTZu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Oct 2016 15:25:50 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
Cc: robh+dt@kernel.org, mark.rutland@arm.com, mchehab@kernel.org,
        hverkuil@xs4all.nl, sakari.ailus@linux.intel.com, crope@iki.fi,
        chris.paterson2@renesas.com, geert@linux-m68k.org,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [RFC 1/5] media: i2c: max2175: Add MAX2175 support
Date: Tue, 18 Oct 2016 22:25:45 +0300
Message-ID: <2034831.3otZHvJ6bZ@avalon>
In-Reply-To: <1476281429-27603-2-git-send-email-ramesh.shanmugasundaram@bp.renesas.com>
References: <1476281429-27603-1-git-send-email-ramesh.shanmugasundaram@bp.renesas.com> <1476281429-27603-2-git-send-email-ramesh.shanmugasundaram@bp.renesas.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ramesh,

Thank you for the patch.

On Wednesday 12 Oct 2016 15:10:25 Ramesh Shanmugasundaram wrote:
> This patch adds driver support for MAX2175 chip. This is Maxim
> Integrated's RF to Bits tuner front end chip designed for software-de=
fined
> radio solutions. This driver exposes the tuner as a sub-device instan=
ce
> with standard and custom controls to configure the device.
>=20
> Signed-off-by: Ramesh Shanmugasundaram
> <ramesh.shanmugasundaram@bp.renesas.com> ---
>  .../devicetree/bindings/media/i2c/max2175.txt      |   60 +
>  drivers/media/i2c/Kconfig                          |    4 +
>  drivers/media/i2c/Makefile                         |    2 +
>  drivers/media/i2c/max2175/Kconfig                  |    8 +
>  drivers/media/i2c/max2175/Makefile                 |    4 +
>  drivers/media/i2c/max2175/max2175.c                | 1624 ++++++++++=
+++++++
>  drivers/media/i2c/max2175/max2175.h                |  124 ++
>  7 files changed, 1826 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/max21=
75.txt
>  create mode 100644 drivers/media/i2c/max2175/Kconfig
>  create mode 100644 drivers/media/i2c/max2175/Makefile
>  create mode 100644 drivers/media/i2c/max2175/max2175.c
>  create mode 100644 drivers/media/i2c/max2175/max2175.h
>=20
> diff --git a/Documentation/devicetree/bindings/media/i2c/max2175.txt
> b/Documentation/devicetree/bindings/media/i2c/max2175.txt new file mo=
de
> 100644
> index 0000000..2250d5f
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/i2c/max2175.txt
> @@ -0,0 +1,60 @@
> +Maxim Integrated MAX2175 RF to Bits tuner
> +-----------------------------------------
> +
> +The MAX2175 IC is an advanced analog/digital hybrid-radio receiver w=
ith
> +RF to Bits=AE front-end designed for software-defined radio solution=
s.
> +
> +Required properties:
> +--------------------
> +- compatible: "maxim,max2175" for MAX2175 RF-to-bits tuner.
> +- clocks: phandle to the fixed xtal clock.
> +- clock-names: name of the fixed xtal clock.
> +- port: video interface child port node of a tuner that defines the =
local

As Rob pointed out in his review of patch 3/5, this isn't video.

> +  and remote endpoints. The remote endpoint is assumed to be an SDR =
device
> +  that is capable of receiving the digital samples from the tuner.
> +
> +Optional properties:
> +--------------------
> +- maxim,slave=09   : empty property indicates this is a slave of=20
another
> +=09=09     master tuner. This is used to define two tuners in
> +=09=09     diversity mode (1 master, 1 slave). By default each
> +=09=09     tuner is an individual master.

Would it be useful to make that property a phandle to the master tuner,=
 to=20
give drivers a way to access the master ? I haven't checked whether the=
re=20
could be use cases for that.

> +- maxim,refout-load: load capacitance value (in pF) on reference out=
put
> +=09=09     drive level. The mapping of these load values to
> +=09=09     respective bit values are given below.
> +=09=09     0 - Reference output disabled
> +=09=09     1 - 10pF load
> +=09=09     2 - 20pF load
> +=09=09     3 - 30pF load
> +=09=09     4 - 40pF load
> +=09=09     5 - 60pF load
> +=09=09     6 - 70pF load

As Geert pointed out, you can simply specify the value in pF.

> +
> +Example:
> +--------
> +
> +Board specific DTS file
> +
> +/* Fixed XTAL clock node */
> +maxim_xtal: maximextal {
> +=09compatible =3D "fixed-clock";
> +=09#clock-cells =3D <0>;
> +=09clock-frequency =3D <36864000>;
> +};
> +
> +/* A tuner device instance under i2c bus */
> +max2175_0: tuner@60 {
> +=09#clock-cells =3D <0>;

Is the tuner a clock provider ? If it isn't you don't need this propert=
y.

> +=09compatible =3D "maxim,max2175";
> +=09reg =3D <0x60>;
> +=09clocks =3D <&maxim_xtal>;
> +=09clock-names =3D "xtal";
> +=09maxim,refout-load =3D <10>;
> +
> +=09port {
> +=09=09max2175_0_ep: endpoint {
> +=09=09=09remote-endpoint =3D <&slave_rx_v4l2_sdr_device>;
> +=09=09};
> +=09};
> +
> +};

[snip]

> diff --git a/drivers/media/i2c/max2175/Makefile
> b/drivers/media/i2c/max2175/Makefile new file mode 100644
> index 0000000..9bb46ac
> --- /dev/null
> +++ b/drivers/media/i2c/max2175/Makefile
> @@ -0,0 +1,4 @@
> +#
> +# Makefile for Maxim RF to Bits tuner device
> +#
> +obj-$(CONFIG_SDR_MAX2175) +=3D max2175.o

If there's a single source file you might want to move it to=20
drivers/media/i2c/.

> diff --git a/drivers/media/i2c/max2175/max2175.c
> b/drivers/media/i2c/max2175/max2175.c new file mode 100644
> index 0000000..71b60c2
> --- /dev/null
> +++ b/drivers/media/i2c/max2175/max2175.c
> @@ -0,0 +1,1624 @@
> +/*
> + * Maxim Integrated MAX2175 RF to Bits tuner driver
> + *
> + * This driver & most of the hard coded values are based on the refe=
rence
> + * application delivered by Maxim for this chip.
> + *
> + * Copyright (C) 2016 Maxim Integrated Products
> + * Copyright (C) 2016 Renesas Electronics Corporation
> + *
> + * This program is free software; you can redistribute it and/or mod=
ify
> + * it under the terms of the GNU General Public License version 2
> + * as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/errno.h>
> +#include <linux/i2c.h>
> +#include <linux/init.h>
> +#include <linux/interrupt.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include <linux/delay.h>

You can move delay.h right below clk.h and everything will be in alphab=
etical=20
order :-)

> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-of.h>
> +
> +#include "max2175.h"
> +
> +#define DRIVER_NAME "max2175"
> +
> +static unsigned int max2175_debug;
> +module_param(max2175_debug, uint, 0644);
> +MODULE_PARM_DESC(max2175_debug, "activate debug info");

You can name the parameter "debug".

> +#define mxm_dbg(ctx, fmt, arg...) \
> +=09v4l2_dbg(1, max2175_debug, &ctx->sd, fmt, ## arg)

[snip]

> +/* Preset values:
> + * Based on Maxim MAX2175 Register Table revision: 130p10
> + */

The preferred multi-line comment style is

/*
 * foo
 * bar
 */

[snip]

> +struct max2175_ctx {

Nitpicking, such a structure would usually be named max2175 or max2175_=
device.=20
Context seems to imply that you can have multiple of them per device.

> +=09struct v4l2_subdev sd;
> +=09struct i2c_client *client;
> +=09struct device *dev;
> +
> +=09/* Cached configuration */
> +=09u8 regs[256];

If you want to cache register values you should use regmap.

> +=09enum max2175_modetag mode;=09/* Receive mode tag */
> +=09u32 freq;=09=09=09/* In Hz */
> +=09struct max2175_rxmode *rx_modes;
> +
> +=09/* Device settings */
> +=09bool master;
> +=09u32 decim_ratio;
> +=09u64 xtal_freq;
> +
> +=09/* ROM values */
> +=09u8 rom_bbf_bw_am;
> +=09u8 rom_bbf_bw_fm;
> +=09u8 rom_bbf_bw_dab;
> +
> +=09/* Local copy of old settings */
> +=09u8 i2s_test;
> +
> +=09u8 nbd_gain;
> +=09u8 nbd_threshold;
> +=09u8 wbd_gain;
> +=09u8 wbd_threshold;
> +=09u8 bbd_threshold;
> +=09u8 bbdclip_threshold;
> +=09u8 lt_wbd_threshold;
> +=09u8 lt_wbd_gain;
> +
> +=09/* Controls */
> +=09struct v4l2_ctrl_handler ctrl_hdl;
> +=09struct v4l2_ctrl *lna_gain;=09/* LNA gain value */
> +=09struct v4l2_ctrl *if_gain;=09/* I/F gain value */
> +=09struct v4l2_ctrl *pll_lock;=09/* PLL lock */
> +=09struct v4l2_ctrl *i2s_en;=09/* I2S output enable */
> +=09struct v4l2_ctrl *i2s_mode;=09/* I2S mode value */
> +=09struct v4l2_ctrl *am_hiz;=09/* AM High impledance input */
> +=09struct v4l2_ctrl *hsls;=09=09/* High-side/Low-side polarity */
> +=09struct v4l2_ctrl *rx_mode;=09/* Receive mode */
> +
> +=09/* Driver private variables */
> +=09bool mode_resolved;=09=09/* Flag to sanity check settings */
> +};

[snip]

> +/* Local store bitops helpers */
> +static u8 max2175_get_bits(struct max2175_ctx *ctx, u8 idx, u8 msb, =
u8 lsb)
> +{
> +=09if (max2175_debug >=3D 2)
> +=09=09mxm_dbg(ctx, "get_bits: idx:%u msb:%u lsb:%u\n",
> +=09=09=09idx, msb, lsb);

Do we really need such detailed debugging ?

> +=09return __max2175_get_bits(ctx->regs[idx], msb, lsb);
> +}
> +
> +static bool max2175_get_bit(struct max2175_ctx *ctx, u8 idx, u8 bit)=

> +{
> +=09return !!max2175_get_bits(ctx, idx, bit, bit);
> +}
> +
> +static void max2175_set_bits(struct max2175_ctx *ctx, u8 idx,
> +=09=09      u8 msb, u8 lsb, u8 newval)
> +{
> +=09if (max2175_debug >=3D 2)
> +=09=09mxm_dbg(ctx, "set_bits: idx:%u msb:%u lsb:%u newval:%u\n",
> +=09=09=09idx, msb, lsb, newval);
> +=09ctx->regs[idx] =3D __max2175_set_bits(ctx->regs[idx], msb, lsb,
> +=09=09=09=09=09      newval);
> +}
> +
> +static void max2175_set_bit(struct max2175_ctx *ctx, u8 idx, u8 bit,=
 u8
> newval)
> +{
> +=09max2175_set_bits(ctx, idx, bit, bit, newval);
> +}
> +
> +/* Device register bitops helpers */
> +static u8 max2175_read_bits(struct max2175_ctx *ctx, u8 idx, u8 msb,=
 u8
> lsb)
> +{
> +=09return __max2175_get_bits(max2175_reg_read(ctx, idx), msb, lsb);
> +}
> +
> +static void max2175_write_bits(struct max2175_ctx *ctx, u8 idx, u8 m=
sb,
> +=09=09=09u8 lsb, u8 newval)
> +{
> +=09/* Update local copy & write to device */
> +=09max2175_set_bits(ctx, idx, msb, lsb, newval);
> +=09max2175_reg_write(ctx, idx, ctx->regs[idx]);
> +}
> +
> +static void max2175_write_bit(struct max2175_ctx *ctx, u8 idx, u8 bi=
t,
> +=09=09=09      u8 newval)
> +{
> +=09if (max2175_debug >=3D 2)
> +=09=09mxm_dbg(ctx, "idx %u, bit %u, newval %u\n", idx, bit, newval);=

> +=09max2175_write_bits(ctx, idx, bit, bit, newval);
> +}

Really, please use regmap :-)

> +static int max2175_poll_timeout(struct max2175_ctx *ctx, u8 idx, u8 =
msb, u8
> lsb,
> +=09=09=09=09u8 exp_val, u32 timeout)
> +{
> +=09unsigned long end =3D jiffies + msecs_to_jiffies(timeout);
> +=09int ret;
> +
> +=09do {
> +=09=09ret =3D max2175_read_bits(ctx, idx, msb, lsb);
> +=09=09if (ret < 0)
> +=09=09=09return ret;
> +=09=09if (ret =3D=3D exp_val)
> +=09=09=09return 0;
> +
> +=09=09usleep_range(1000, 1500);
> +=09} while (time_is_after_jiffies(end));
> +
> +=09return -EBUSY;
> +}
> +
> +static int max2175_poll_csm_ready(struct max2175_ctx *ctx)
> +{
> +=09return max2175_poll_timeout(ctx, 69, 1, 1, 0, 50);

Please define macros for register addresses and values, this is just=20=

unreadable.

> +}

[snip]

> +
> +#define MAX2175_IS_BAND_AM(ctx)=09=09\
> +=09(max2175_get_bits(ctx, 5, 1, 0) =3D=3D MAX2175_BAND_AM)
> +
> +#define MAX2175_IS_FM_MODE(ctx)=09=09\
> +=09(max2175_get_bits(ctx, 12, 5, 4) =3D=3D 0)
> +
> +#define MAX2175_IS_FMHD_MODE(ctx)=09\
> +=09(max2175_get_bits(ctx, 12, 5, 4) =3D=3D 1)
> +
> +#define MAX2175_IS_DAB_MODE(ctx)=09\
> +=09(max2175_get_bits(ctx, 12, 5, 4) =3D=3D 2)
> +
> +static int max2175_band_from_freq(u64 freq)
> +{
> +=09if (freq >=3D 144000 && freq <=3D 26100000)
> +=09=09return MAX2175_BAND_AM;
> +=09else if (freq >=3D 65000000 && freq <=3D 108000000)
> +=09=09return MAX2175_BAND_FM;
> +=09else if (freq >=3D 160000000 && freq <=3D 240000000)
> +=09=09return MAX2175_BAND_VHF;
> +
> +=09/* Add other bands on need basis */
> +=09return -ENOTSUPP;
> +}
> +
> +static int max2175_update_i2s_mode(struct max2175_ctx *ctx, u32 i2s_=
mode)
> +{
> +=09/* Only change if it's new */
> +=09if (max2175_read_bits(ctx, 29, 2, 0) =3D=3D i2s_mode)
> +=09=09return 0;
> +
> +=09max2175_write_bits(ctx, 29, 2, 0, i2s_mode);
> +
> +=09/* Based on I2S mode value I2S_WORD_CNT values change */
> +=09if (i2s_mode =3D=3D MAX2175_I2S_MODE3) {
> +=09=09max2175_write_bits(ctx, 30, 6, 0, 1);
> +=09} else if (i2s_mode =3D=3D MAX2175_I2S_MODE2 ||
> +=09=09   i2s_mode =3D=3D MAX2175_I2S_MODE4) {
> +=09=09max2175_write_bits(ctx, 30, 6, 0, 0);
> +=09} else if (i2s_mode =3D=3D MAX2175_I2S_MODE0) {
> +=09=09max2175_write_bits(ctx, 30, 6, 0,
> +=09=09=09=09   ctx->rx_modes[ctx->mode].i2s_word_size);
> +=09} else {
> +=09=09v4l2_err(ctx->client,
> +=09=09=09 "failed: i2s_mode %u unsupported\n", i2s_mode);

This should never happen as the control framework will validate control=
=20
values.

> +=09=09return 1;

Error codes should be negative.

> +=09}
> +=09mxm_dbg(ctx, "updated i2s_mode %u\n", i2s_mode);
> +=09return 0;
> +}

[snip]

> +static void max2175_load_dab_1p2(struct max2175_ctx *ctx)
> +{
> +=09u32 i;

unsigned int will do, no need for an explicitly sized type.

> +
> +=09/* Master is already set on init */
> +=09for (i =3D 0; i < ARRAY_SIZE(dab12_map); i++)
> +=09=09max2175_reg_write(ctx, dab12_map[i].idx, dab12_map[i].val);
> +
> +=09/* The default settings assume master */
> +=09if (!ctx->master)
> +=09=09max2175_write_bit(ctx, 30, 7, 1);
> +
> +=09/* Cache i2s_test value at this point */
> +=09ctx->i2s_test =3D max2175_get_bits(ctx, 104, 3, 0);
> +=09ctx->decim_ratio =3D 1;
> +
> +=09/* Load the Channel Filter Coefficients into channel filter bank =
#2 */
> +=09max2175_set_filter_coeffs(ctx, MAX2175_CH_MSEL, 2, ch_coeff_dab1)=
;
> +}

[snip]

> +static bool max2175_set_csm_mode(struct max2175_ctx *ctx,
> +=09=09=09  enum max2175_csm_mode new_mode)
> +{
> +=09int ret =3D max2175_poll_csm_ready(ctx);
> +
> +=09if (ret) {
> +=09=09v4l2_err(ctx->client, "csm not ready: new mode %d\n",=20
new_mode);
> +=09=09return ret;
> +=09}
> +
> +=09mxm_dbg(ctx, "set csm mode: new mode %d\n", new_mode);
> +
> +=09max2175_write_bits(ctx, 0, 2, 0, new_mode);
> +
> +=09/* Wait for a fixed settle down time depending on new mode and ba=
nd */
> +=09switch (new_mode) {
> +=09case MAX2175_CSM_MODE_JUMP_FAST_TUNE:
> +=09=09if (MAX2175_IS_BAND_AM(ctx)) {
> +=09=09=09usleep_range(1250, 1500);=09/* 1.25ms */
> +=09=09} else {
> +=09=09=09if (MAX2175_IS_DAB_MODE(ctx))
> +=09=09=09=09usleep_range(3000, 3500);=09/* 3ms */
> +=09=09=09else
> +=09=09=09=09usleep_range(1250, 1500);=09/* 1.25ms */
> +=09=09}

You can write this as

=09=09if (MAX2175_IS_BAND_AM(ctx))
=09=09=09usleep_range(1250, 1500);=09/* 1.25ms */
=09=09else if (MAX2175_IS_DAB_MODE(ctx))
=09=09=09usleep_range(3000, 3500);=09/* 3ms */
=09=09else
=09=09=09usleep_range(1250, 1500);=09/* 1.25ms */


> +=09=09break;
> +
> +=09/* Other mode switches can be added in the future if needed */
> +=09default:
> +=09=09break;
> +=09}
> +
> +=09ret =3D max2175_poll_csm_ready(ctx);
> +=09if (ret) {
> +=09=09v4l2_err(ctx->client, "csm did not settle: new mode %d\n",
> +=09=09=09 new_mode);
> +=09=09return ret;
> +=09}
> +=09return ret;
> +}

[snip]

> +
> +static int max2175_csm_action(struct max2175_ctx *ctx,
> +=09=09=09      enum max2175_csm_mode action)
> +{
> +=09int ret;
> +=09int load_buffer =3D MAX2175_CSM_MODE_LOAD_TO_BUFFER;
> +
> +=09mxm_dbg(ctx, "csm action: %d\n", action);
> +
> +=09/* Perform one or two CSM mode commands. */
> +=09switch (action)=09{
> +=09case MAX2175_CSM_MODE_NO_ACTION:
> +=09=09/* Take no FSM Action. */
> +=09=09return 0;
> +=09case MAX2175_CSM_MODE_LOAD_TO_BUFFER:
> +=09case MAX2175_CSM_MODE_PRESET_TUNE:
> +=09case MAX2175_CSM_MODE_SEARCH:
> +=09case MAX2175_CSM_MODE_AF_UPDATE:
> +=09case MAX2175_CSM_MODE_JUMP_FAST_TUNE:
> +=09case MAX2175_CSM_MODE_CHECK:
> +=09case MAX2175_CSM_MODE_LOAD_AND_SWAP:
> +=09case MAX2175_CSM_MODE_END:
> +=09=09ret =3D max2175_set_csm_mode(ctx, action);
> +=09=09break;
> +=09case MAX2175_CSM_MODE_BUFFER_PLUS_PRESET_TUNE:
> +=09=09ret =3D max2175_set_csm_mode(ctx, load_buffer);
> +=09=09if (ret) {
> +=09=09=09v4l2_err(ctx->client, "csm action %d load buf=20
failed\n",
> +=09=09=09=09 action);
> +=09=09=09break;
> +=09=09}
> +=09=09ret =3D max2175_set_csm_mode(ctx, MAX2175_CSM_MODE_PRESET_TUNE=
);
> +=09=09break;
> +=09case MAX2175_CSM_MODE_BUFFER_PLUS_SEARCH:
> +=09=09ret =3D max2175_set_csm_mode(ctx, load_buffer);
> +=09=09if (ret) {
> +=09=09=09v4l2_err(ctx->client, "csm action %d load buf=20
failed\n",
> +=09=09=09=09 action);
> +=09=09=09break;
> +=09=09}

Don't duplicate the error messages, move them after the switch statemen=
t.

> +=09=09ret =3D max2175_set_csm_mode(ctx, MAX2175_CSM_MODE_SEARCH);
> +=09=09break;
> +=09case MAX2175_CSM_MODE_BUFFER_PLUS_AF_UPDATE:
> +=09=09ret =3D max2175_set_csm_mode(ctx, load_buffer);
> +=09=09if (ret) {
> +=09=09=09v4l2_err(ctx->client, "csm action %d load buf=20
failed\n",
> +=09=09=09=09 action);
> +=09=09=09break;
> +=09=09}
> +=09=09ret =3D max2175_set_csm_mode(ctx, MAX2175_CSM_MODE_AF_UPDATE);=

> +=09=09break;
> +=09case MAX2175_CSM_MODE_BUFFER_PLUS_JUMP_FAST_TUNE:

This function is only called with action set to=20
MAX2175_CSM_MODE_BUFFER_PLUS_JUMP_FAST_TUNE. I'd remove the rest of the=
 code=20
for now, unless you have a plan to use it soon.

> +=09=09ret =3D max2175_set_csm_mode(ctx, load_buffer);
> +=09=09if (ret) {
> +=09=09=09v4l2_err(ctx->client, "csm action %d load buf=20
failed\n",
> +=09=09=09=09 action);
> +=09=09=09break;
> +=09=09}
> +=09=09ret =3D max2175_set_csm_mode(ctx,
> +=09=09=09=09=09   MAX2175_CSM_MODE_JUMP_FAST_TUNE);
> +=09=09break;
> +=09case MAX2175_CSM_MODE_BUFFER_PLUS_CHECK:
> +=09=09ret =3D max2175_set_csm_mode(ctx, load_buffer);
> +=09=09if (ret) {
> +=09=09=09v4l2_err(ctx->client, "csm action %d load buf=20
failed\n",
> +=09=09=09=09 action);
> +=09=09=09break;
> +=09=09}
> +=09=09ret =3D max2175_set_csm_mode(ctx, MAX2175_CSM_MODE_CHECK);
> +=09=09break;
> +=09case MAX2175_CSM_MODE_BUFFER_PLUS_LOAD_AND_SWAP:
> +=09=09ret =3D max2175_set_csm_mode(ctx, load_buffer);
> +=09=09if (ret) {
> +=09=09=09v4l2_err(ctx->client, "csm action %d load buf=20
failed\n",
> +=09=09=09=09 action);
> +=09=09=09break;
> +=09=09}
> +=09=09ret =3D max2175_set_csm_mode(ctx,=20
MAX2175_CSM_MODE_LOAD_AND_SWAP);
> +=09=09break;
> +=09default:
> +=09=09ret =3D max2175_set_csm_mode(ctx, MAX2175_CSM_MODE_NO_ACTION);=

> +=09=09break;
> +=09}
> +=09return ret;
> +}
> +
> +static int max2175_set_lo_freq(struct max2175_ctx *ctx, u64 lo_freq)=

> +{
> +=09int ret;
> +=09u32 lo_mult;
> +=09u64 scaled_lo_freq;
> +=09const u64 scale_factor =3D 1000000ULL;
> +=09u64 scaled_npf, scaled_integer, scaled_fraction;
> +=09u32 frac_desired, int_desired;
> +=09u8 loband_bits, vcodiv_bits;

Do you really support frequencies above 4GHz ? If not most of the 64-bi=
t=20
values could be stored in 32 bits.

> +
> +=09scaled_lo_freq =3D lo_freq;
> +=09/* Scale to larger number for precision */
> +=09scaled_lo_freq =3D scaled_lo_freq * scale_factor * 100;
> +
> +=09mxm_dbg(ctx, "scaled lo_freq %llu lo_freq %llu\n",
> +=09=09scaled_lo_freq, lo_freq);
> +
> +=09if (MAX2175_IS_BAND_AM(ctx)) {
> +=09=09if (max2175_get_bit(ctx, 5, 7) =3D=3D 0)
> +=09=09=09loband_bits =3D 0;
> +=09=09=09vcodiv_bits =3D 0;
> +=09=09=09lo_mult =3D 16;
> +=09} else if (max2175_get_bits(ctx, 5, 1, 0) =3D=3D MAX2175_BAND_FM)=
 {
> +=09=09if (lo_freq <=3D 74700000) {
> +=09=09=09loband_bits =3D 0;
> +=09=09=09vcodiv_bits =3D 0;
> +=09=09=09lo_mult =3D 16;
> +=09=09} else if ((lo_freq > 74700000) && (lo_freq <=3D 110000000)) {=


No need for the inner parentheses.

> +=09=09=09loband_bits =3D 1;
> +=09=09=09vcodiv_bits =3D 0;
> +=09=09} else {
> +=09=09=09loband_bits =3D 1;
> +=09=09=09vcodiv_bits =3D 3;
> +=09=09}
> +=09=09lo_mult =3D 8;
> +=09} else if (max2175_get_bits(ctx, 5, 1, 0) =3D=3D MAX2175_BAND_VHF=
) {
> +=09=09if (lo_freq <=3D 210000000) {
> +=09=09=09loband_bits =3D 2;
> +=09=09=09vcodiv_bits =3D 2;
> +=09=09} else {
> +=09=09=09loband_bits =3D 2;
> +=09=09=09vcodiv_bits =3D 1;
> +=09=09}
> +=09=09lo_mult =3D 4;
> +=09} else {
> +=09=09loband_bits =3D 3;
> +=09=09vcodiv_bits =3D 2;
> +=09=09lo_mult =3D 2;
> +=09}
> +
> +=09if (max2175_get_bits(ctx, 5, 1, 0) =3D=3D MAX2175_BAND_L)
> +=09=09scaled_npf =3D (scaled_lo_freq / ctx->xtal_freq / lo_mult) /=20=

100;
> +=09else
> +=09=09scaled_npf =3D (scaled_lo_freq / ctx->xtal_freq * lo_mult) /=20=

100;
> +
> +=09scaled_integer =3D scaled_npf / scale_factor * scale_factor;
> +=09int_desired =3D (u32)(scaled_npf / scale_factor);
> +=09scaled_fraction =3D scaled_npf - scaled_integer;
> +=09frac_desired =3D (u32)(scaled_fraction * 1048576 / scale_factor);=

> +
> +=09/* Check CSM is not busy */
> +=09ret =3D max2175_poll_csm_ready(ctx);
> +=09if (ret) {
> +=09=09v4l2_err(ctx->client, "lo_freq: csm busy. freq %llu\n",
> +=09=09=09 lo_freq);
> +=09=09return ret;
> +=09}
> +
> +=09mxm_dbg(ctx, "loband %u vcodiv %u lo_mult %u scaled_npf %llu\n",
> +=09=09loband_bits, vcodiv_bits, lo_mult, scaled_npf);
> +=09mxm_dbg(ctx, "scaled int %llu frac %llu desired int %u frac %u\n"=
,
> +=09=09scaled_integer, scaled_fraction, int_desired, frac_desired);
> +
> +=09/* Write the calculated values to the appropriate registers */
> +=09max2175_set_bits(ctx, 5, 3, 2, loband_bits);
> +=09max2175_set_bits(ctx, 6, 7, 6, vcodiv_bits);
> +=09max2175_set_bits(ctx, 1, 7, 0, (u8)(int_desired & 0xff));
> +=09max2175_set_bits(ctx, 2, 3, 0, (u8)((frac_desired >> 16) & 0x1f))=
;
> +=09max2175_set_bits(ctx, 3, 7, 0, (u8)((frac_desired >> 8) & 0xff));=

> +=09max2175_set_bits(ctx, 4, 7, 0, (u8)(frac_desired & 0xff));
> +=09/* Flush the above registers to device */
> +=09max2175_flush_regstore(ctx, 1, 6);
> +=09return ret;
> +}

[snip]

> +static int max2175_set_rf_freq_non_am_bands(struct max2175_ctx *ctx,=
 u64
> freq,
> +=09=09=09=09=09    u32 lo_pos)
> +{
> +=09int ret;
> +=09s64 adj_freq;
> +=09u64 low_if_freq;
> +
> +=09mxm_dbg(ctx, "rf_freq: non AM bands\n");
> +
> +=09if (MAX2175_IS_FM_MODE(ctx))
> +=09=09low_if_freq =3D 128000;
> +=09else if (MAX2175_IS_FMHD_MODE(ctx))
> +=09=09low_if_freq =3D 228000;
> +=09else
> +=09=09return max2175_set_lo_freq(ctx, freq);
> +
> +=09if (max2175_get_bits(ctx, 5, 1, 0) =3D=3D MAX2175_BAND_VHF) {

You perform this check in multiple places, you could create a helper fu=
nction.

> +=09=09if (lo_pos =3D=3D MAX2175_LO_ABOVE_DESIRED)
> +=09=09=09adj_freq =3D freq + low_if_freq;
> +=09=09else
> +=09=09=09adj_freq =3D freq - low_if_freq;
> +=09} else {
> +=09=09if (lo_pos =3D=3D MAX2175_LO_ABOVE_DESIRED)
> +=09=09=09adj_freq =3D freq - low_if_freq;
> +=09=09else
> +=09=09=09adj_freq =3D freq + low_if_freq;
> +=09}

This could be written

=09if ((max2175_get_bits(ctx, 5, 1, 0) =3D=3D MAX2175_BAND_VHF) =3D=3D
=09    (lo_pos =3D=3D MAX2175_LO_ABOVE_DESIRED))
=09=09adj_freq =3D freq + low_if_freq;
=09else
=09=09adj_freq =3D freq - low_if_freq;

Same for the other similar constructs in the driver. Up to you.

> +
> +=09ret =3D max2175_set_lo_freq(ctx, adj_freq);
> +=09if (ret)
> +=09=09return ret;
> +
> +=09return max2175_set_nco_freq(ctx, low_if_freq);
> +}

[snip]

> +#define max2175_ctx_from_sd(x)=09\
> +=09container_of(x, struct max2175_ctx, sd)
> +#define max2175_ctx_from_ctrl(x)=09\
> +=09container_of(x, struct max2175_ctx, ctrl_hdl)

I'd move it right after the structure definition, and turn them into st=
atic=20
inline functions.

> +static int max2175_s_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +=09struct max2175_ctx *ctx =3D max2175_ctx_from_ctrl(ctrl->handler);=

> +=09int ret =3D 0;
> +
> +=09mxm_dbg(ctx, "s_ctrl: id 0x%x, val %u\n", ctrl->id, ctrl->val);
> +=09switch (ctrl->id) {
> +=09case V4L2_CID_MAX2175_I2S_EN:
> +=09=09max2175_i2s_enable(ctx, ctrl->val =3D=3D 1);
> +=09=09break;
> +=09case V4L2_CID_MAX2175_I2S_MODE:
> +=09=09max2175_s_ctrl_i2s_mode(ctx, ctrl->val);
> +=09=09break;
> +=09case V4L2_CID_MAX2175_AM_HIZ:
> +=09=09v4l2_ctrl_activate(ctx->am_hiz, false);
> +=09=09break;
> +=09case V4L2_CID_MAX2175_HSLS:
> +=09=09v4l2_ctrl_activate(ctx->hsls, false);
> +=09=09break;
> +=09case V4L2_CID_MAX2175_RX_MODE:
> +=09=09mxm_dbg(ctx, "rx mode %u\n", ctrl->val);
> +=09=09max2175_s_ctrl_rx_mode(ctx, ctrl->val);
> +=09=09break;
> +=09default:
> +=09=09v4l2_err(ctx->client, "s:invalid ctrl id 0x%x\n", ctrl->id);
> +=09=09ret =3D -EINVAL;

This should never happen. The driver has too many error and debug messa=
ges=20
overall.

> +=09}
> +
> +=09return ret;
> +}
> +
> +static int max2175_get_lna_gain(struct max2175_ctx *ctx)
> +{
> +=09int gain =3D 0;
> +=09enum max2175_band band =3D max2175_get_bits(ctx, 5, 1, 0);
> +
> +=09switch (band) {
> +=09case MAX2175_BAND_AM:
> +=09=09gain =3D max2175_read_bits(ctx, 51, 3, 1);
> +=09=09break;
> +=09case MAX2175_BAND_FM:
> +=09=09gain =3D max2175_read_bits(ctx, 50, 3, 1);
> +=09=09break;
> +=09case MAX2175_BAND_VHF:
> +=09=09gain =3D max2175_read_bits(ctx, 52, 3, 0);
> +=09=09break;
> +=09default:
> +=09=09v4l2_err(ctx->client, "invalid band %d to get rf gain\n",=20
band);

Can this happen ?

> +=09=09break;
> +=09}
> +=09return gain;
> +}
> +
> +static int max2175_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +=09struct max2175_ctx *ctx =3D max2175_ctx_from_ctrl(ctrl->handler);=

> +
> +=09/* Only the dynamically changing values need to be in g_volatile_=
ctrl=20
*/
> +=09mxm_dbg(ctx, "g_volatile_ctrl: id 0x%x\n", ctrl->id);
> +=09switch (ctrl->id) {
> +=09case V4L2_CID_RF_TUNER_LNA_GAIN:
> +=09=09ctrl->val =3D max2175_get_lna_gain(ctx);
> +=09=09break;
> +=09case V4L2_CID_RF_TUNER_IF_GAIN:
> +=09=09ctrl->val =3D max2175_read_bits(ctx, 49, 4, 0);
> +=09=09break;
> +=09case V4L2_CID_RF_TUNER_PLL_LOCK:
> +=09=09ctrl->val =3D (max2175_read_bits(ctx, 60, 7, 6) =3D=3D 3);
> +=09=09break;
> +=09default:
> +=09=09v4l2_err(ctx->client, "g:invalid ctrl id 0x%x\n", ctrl->id);

This should never happen either.

> +=09=09return -EINVAL;
> +=09}
> +=09mxm_dbg(ctx, "g_volatile_ctrl: id 0x%x val %d\n", ctrl->id, ctrl-=

>val);
> +=09return 0;
> +};

[snip]

> +static const struct v4l2_ctrl_config max2175_i2s_en =3D {
> +=09.ops =3D &max2175_ctrl_ops,
> +=09.id =3D V4L2_CID_MAX2175_I2S_EN,

V4L2_CID_MAX2175_I2S_ENABLE ?

> +=09.name =3D "I2S Enable",
> +=09.type =3D V4L2_CTRL_TYPE_BOOLEAN,
> +=09.min =3D 0,
> +=09.max =3D 1,
> +=09.step =3D 1,
> +=09.def =3D 1,
> +};
> +
> +static const struct v4l2_ctrl_config max2175_i2s_mode =3D {
> +=09.ops =3D &max2175_ctrl_ops,
> +=09.id =3D V4L2_CID_MAX2175_I2S_MODE,
> +=09.name =3D "I2S_MODE value",
> +=09.type =3D V4L2_CTRL_TYPE_INTEGER,

Should this be a menu control ?

> +=09.min =3D 0,
> +=09.max =3D 4,
> +=09.step =3D 1,
> +=09.def =3D 0,
> +};
> +
> +static const struct v4l2_ctrl_config max2175_am_hiz =3D {
> +=09.ops =3D &max2175_ctrl_ops,
> +=09.id =3D V4L2_CID_MAX2175_AM_HIZ,
> +=09.name =3D "AM High impedance input",
> +=09.type =3D V4L2_CTRL_TYPE_BOOLEAN,
> +=09.min =3D 0,
> +=09.max =3D 1,
> +=09.step =3D 1,
> +=09.def =3D 0,
> +};
> +
> +static const struct v4l2_ctrl_config max2175_hsls =3D {
> +=09.ops =3D &max2175_ctrl_ops,
> +=09.id =3D V4L2_CID_MAX2175_HSLS,
> +=09.name =3D "HSLS above/below desired",
> +=09.type =3D V4L2_CTRL_TYPE_INTEGER,
> +=09.min =3D 0,
> +=09.max =3D 1,
> +=09.step =3D 1,
> +=09.def =3D 1,
> +};
> +
> +
> +/* NOTE: Any addition/deletion in the below list should be reflected=
 in
> + * max2175_modetag enum
> + */
> +static const char * const max2175_ctrl_eu_rx_mode_strings[] =3D {
> +=09"DAB 1.2",
> +=09"NULL",

Do you really mean "NULL", not NULL ?

> +};
> +
> +static const char * const max2175_ctrl_na_rx_mode_strings[] =3D {
> +=09"NA FM 1.0",
> +=09"NULL",
> +};
> +
> +static const struct v4l2_ctrl_config max2175_eu_rx_mode =3D {
> +=09.ops =3D &max2175_ctrl_ops,
> +=09.id =3D V4L2_CID_MAX2175_RX_MODE,
> +=09.name =3D "RX MODE",
> +=09.type =3D V4L2_CTRL_TYPE_MENU,
> +=09.max =3D ARRAY_SIZE(max2175_ctrl_eu_rx_mode_strings) - 2,

If there's a single mode supported I'd skip adding those controls for n=
ow.

> +=09.def =3D 0,
> +=09.qmenu =3D max2175_ctrl_eu_rx_mode_strings,
> +};
> +
> +static const struct v4l2_ctrl_config max2175_na_rx_mode =3D {
> +=09.ops =3D &max2175_ctrl_ops,
> +=09.id =3D V4L2_CID_MAX2175_RX_MODE,
> +=09.name =3D "RX MODE",
> +=09.type =3D V4L2_CTRL_TYPE_MENU,
> +=09.max =3D ARRAY_SIZE(max2175_ctrl_na_rx_mode_strings) - 2,
> +=09.def =3D 0,
> +=09.qmenu =3D max2175_ctrl_na_rx_mode_strings,
> +};
> +
> +static u32 max2175_refout_load_to_bits(struct i2c_client *client, u3=
2 load)
> +{
> +=09u32 bits =3D 0;=09/* REFOUT disabled */
> +
> +=09if (load >=3D 0 && load <=3D 40)
> +=09=09bits =3D load / 10;
> +=09else if (load >=3D 60 && load <=3D 70)
> +=09=09bits =3D load / 10 - 1;
> +=09else
> +=09=09dev_warn(&client->dev, "invalid refout_load %u\n", load);

Your DT bindings specify 0 as a valid value.

An invalid value specified in DT should be a fatal error.

> +
> +=09return bits;
> +}
> +
> +static int max2175_probe(struct i2c_client *client,
> +=09=09=09const struct i2c_device_id *id)
> +{
> +=09struct max2175_ctx *ctx;
> +=09struct device *dev =3D &client->dev;
> +=09struct v4l2_subdev *sd;
> +=09struct v4l2_ctrl_handler *hdl;
> +=09struct clk *clk;
> +=09bool master =3D true;
> +=09u32 refout_load, refout_bits =3D 0;=09/* REFOUT disabled */
> +=09int ret;
> +
> +=09/* Check if the adapter supports the needed features */
> +=09if (!i2c_check_functionality(client->adapter,
> +=09=09=09=09     I2C_FUNC_SMBUS_BYTE_DATA)) {
> +=09=09dev_err(&client->dev, "i2c check failed\n");
> +=09=09return -EIO;
> +=09}
> +
> +=09if (of_find_property(client->dev.of_node, "maxim,slave", NULL))
> +=09=09master =3D false;
> +
> +=09if (!of_property_read_u32(client->dev.of_node, "maxim,refout-load=
",
> +=09=09=09=09 &refout_load))
> +=09=09refout_bits =3D max2175_refout_load_to_bits(client,=20
refout_load);
> +
> +=09clk =3D devm_clk_get(&client->dev, "xtal");
> +=09if (IS_ERR(clk)) {
> +=09=09ret =3D PTR_ERR(clk);
> +=09=09dev_err(&client->dev, "cannot get xtal clock %d\n", ret);
> +=09=09return -ENODEV;
> +=09}
> +
> +=09ctx =3D kzalloc(sizeof(struct max2175_ctx),

sizeof(*ctx)

> +=09=09=09     GFP_KERNEL);

This fits on one line.

> +=09if (ctx =3D=3D NULL)
> +=09=09return -ENOMEM;
> +
> +=09sd =3D &ctx->sd;
> +=09ctx->master =3D master;
> +=09ctx->mode_resolved =3D false;
> +
> +=09/* Set the defaults */
> +=09ctx->freq =3D bands_rf.rangelow;
> +
> +=09ctx->xtal_freq =3D clk_get_rate(clk);
> +=09dev_info(&client->dev, "xtal freq %lluHz\n", ctx->xtal_freq);
> +
> +=09v4l2_i2c_subdev_init(sd, client, &max2175_ops);
> +=09ctx->client =3D client;
> +
> +=09sd->flags =3D V4L2_SUBDEV_FL_HAS_DEVNODE;
> +=09ctx->dev =3D dev;
> +
> +=09/* Controls */
> +=09hdl =3D &ctx->ctrl_hdl;
> +=09ret =3D v4l2_ctrl_handler_init(hdl, 8);
> +=09if (ret) {
> +=09=09dev_err(&client->dev, "ctrl handler init failed\n");
> +=09=09goto err;
> +=09}
> +
> +=09ctx->lna_gain =3D v4l2_ctrl_new_std(hdl, &max2175_ctrl_ops,
> +=09=09=09=09=09  V4L2_CID_RF_TUNER_LNA_GAIN,
> +=09=09=09=09=09  0, 15, 1, 2);
> +=09ctx->lna_gain->flags |=3D (V4L2_CTRL_FLAG_VOLATILE |
> +=09=09=09=09 V4L2_CTRL_FLAG_READ_ONLY);
> +=09ctx->if_gain =3D v4l2_ctrl_new_std(hdl, &max2175_ctrl_ops,
> +=09=09=09=09=09 V4L2_CID_RF_TUNER_IF_GAIN,
> +=09=09=09=09=09 0, 31, 1, 0);
> +=09ctx->if_gain->flags |=3D (V4L2_CTRL_FLAG_VOLATILE |
> +=09=09=09=09V4L2_CTRL_FLAG_READ_ONLY);
> +=09ctx->pll_lock =3D v4l2_ctrl_new_std(hdl, &max2175_ctrl_ops,
> +=09=09=09=09=09  V4L2_CID_RF_TUNER_PLL_LOCK,
> +=09=09=09=09=09  0, 1, 1, 0);
> +=09ctx->pll_lock->flags |=3D (V4L2_CTRL_FLAG_VOLATILE |
> +=09=09=09=09 V4L2_CTRL_FLAG_READ_ONLY);
> +=09ctx->i2s_en =3D v4l2_ctrl_new_custom(hdl, &max2175_i2s_en, NULL);=

> +=09ctx->i2s_mode =3D v4l2_ctrl_new_custom(hdl, &max2175_i2s_mode, NU=
LL);
> +=09ctx->am_hiz =3D v4l2_ctrl_new_custom(hdl, &max2175_am_hiz, NULL);=

> +=09ctx->hsls =3D v4l2_ctrl_new_custom(hdl, &max2175_hsls, NULL);
> +
> +=09if (ctx->xtal_freq =3D=3D MAX2175_EU_XTAL_FREQ) {
> +=09=09ctx->rx_mode =3D v4l2_ctrl_new_custom(hdl,
> +=09=09=09=09=09=09    &max2175_eu_rx_mode,=20
NULL);
> +=09=09ctx->rx_modes =3D (struct max2175_rxmode *)eu_rx_modes;
> +=09} else {
> +=09=09ctx->rx_mode =3D v4l2_ctrl_new_custom(hdl,
> +=09=09=09=09=09=09    &max2175_na_rx_mode,=20
NULL);
> +=09=09ctx->rx_modes =3D (struct max2175_rxmode *)na_rx_modes;
> +=09}
> +=09ctx->sd.ctrl_handler =3D &ctx->ctrl_hdl;
> +
> +=09ret =3D v4l2_async_register_subdev(sd);
> +=09if (ret) {
> +=09=09dev_err(&client->dev, "register subdev failed\n");
> +=09=09goto err_reg;
> +=09}
> +=09dev_info(&client->dev, "subdev registered\n");
> +
> +=09/* Initialize device */
> +=09ret =3D max2175_core_init(ctx, refout_bits);
> +=09if (ret)
> +=09=09goto err_init;
> +
> +=09mxm_dbg(ctx, "probed\n");
> +=09return 0;
> +
> +err_init:
> +=09v4l2_async_unregister_subdev(sd);
> +err_reg:
> +=09v4l2_ctrl_handler_free(&ctx->ctrl_hdl);
> +err:
> +=09kfree(ctx);
> +=09return ret;
> +}
> +
> +static int max2175_remove(struct i2c_client *client)
> +{
> +=09struct v4l2_subdev *sd =3D i2c_get_clientdata(client);
> +=09struct max2175_ctx *ctx =3D max2175_ctx_from_sd(sd);
> +
> +=09v4l2_ctrl_handler_free(&ctx->ctrl_hdl);
> +=09v4l2_async_unregister_subdev(sd);
> +=09mxm_dbg(ctx, "removed\n");
> +=09kfree(ctx);
> +=09return 0;
> +}
> +
> +static const struct i2c_device_id max2175_id[] =3D {
> +=09{ DRIVER_NAME, 0},
> +=09{},
> +};
> +

No need for a blank line here.

> +MODULE_DEVICE_TABLE(i2c, max2175_id);
> +
> +static const struct of_device_id max2175_of_ids[] =3D {
> +=09{ .compatible =3D "maxim, max2175", },
> +=09{ }
> +};
> +MODULE_DEVICE_TABLE(of, max2175_of_ids);
> +
> +static struct i2c_driver max2175_driver =3D {
> +=09.driver =3D {
> +=09=09.name=09=3D DRIVER_NAME,
> +=09=09.of_match_table =3D max2175_of_ids,
> +=09},
> +=09.probe=09=09=3D max2175_probe,
> +=09.remove=09=09=3D max2175_remove,
> +=09.id_table=09=3D max2175_id,
> +};
> +
> +module_i2c_driver(max2175_driver);
> +
> +MODULE_DESCRIPTION("Maxim MAX2175 RF to Bits tuner driver");
> +MODULE_LICENSE("GPL v2");
> +MODULE_AUTHOR("Ramesh Shanmugasundaram
> <ramesh.shanmugasundaram@bp.renesas.com>"); diff --git
> a/drivers/media/i2c/max2175/max2175.h b/drivers/media/i2c/max2175/max=
2175.h
> new file mode 100644
> index 0000000..61a508b
> --- /dev/null
> +++ b/drivers/media/i2c/max2175/max2175.h
> @@ -0,0 +1,124 @@
> +/*
> + * Maxim Integrated MAX2175 RF to Bits tuner driver
> + *
> + * This driver & most of the hard coded values are based on the refe=
rence
> + * application delivered by Maxim for this chip.
> + *
> + * Copyright (C) 2016 Maxim Integrated Products
> + * Copyright (C) 2016 Renesas Electronics Corporation
> + *
> + * This program is free software; you can redistribute it and/or mod=
ify
> + * it under the terms of the GNU General Public License version 2
> + * as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> + * GNU General Public License for more details.
> + */
> +
> +#ifndef __MAX2175_H__
> +#define __MAX2175_H__
> +
> +#include <linux/types.h>
> +
> +enum max2175_region {
> +=09MAX2175_REGION_EU =3D 0,=09/* Europe */
> +=09MAX2175_REGION_NA,=09/* North America */
> +};
> +
> +#define MAX2175_EU_XTAL_FREQ=09(36864000)=09/* In Hz */
> +#define MAX2175_NA_XTAL_FREQ=09(40186125)=09/* In Hz */
> +
> +enum max2175_band {
> +=09MAX2175_BAND_AM =3D 0,
> +=09MAX2175_BAND_FM,
> +=09MAX2175_BAND_VHF,
> +=09MAX2175_BAND_L,
> +};
> +
> +/* NOTE: Any addition/deletion in the below enum should be reflected=
 in
> + * V4L2_CID_MAX2175_RX_MODE ctrl strings
> + */
> +enum max2175_modetag {
> +=09/* EU modes */
> +=09MAX2175_DAB_1_2 =3D 0,
> +
> +=09/* Other possible modes to add in future
> +=09 * MAX2175_DAB_1_0,
> +=09 * MAX2175_DAB_1_3,
> +=09 * MAX2175_EU_FM_2_2,
> +=09 * MAX2175_EU_FM_1_0,
> +=09 * MAX2175_EU_FMHD_4_0,
> +=09 * MAX2175_EU_AM_1_0,
> +=09 * MAX2175_EU_AM_2_2,
> +=09 */
> +
> +=09/* NA modes */
> +=09MAX2175_NA_FM_1_0 =3D 0,
> +
> +=09/* Other possible modes to add in future
> +=09 * MAX2175_NA_FM_1_2,
> +=09 * MAX2175_NA_FMHD_1_0,
> +=09 * MAX2175_NA_FMHD_1_2,
> +=09 * MAX2175_NA_AM_1_0,
> +=09 * MAX2175_NA_AM_1_2,
> +=09 */
> +};
> +
> +/* Supported I2S modes */
> +enum {
> +=09MAX2175_I2S_MODE0 =3D 0,
> +=09MAX2175_I2S_MODE1,
> +=09MAX2175_I2S_MODE2,
> +=09MAX2175_I2S_MODE3,
> +=09MAX2175_I2S_MODE4,
> +};
> +
> +/* Coefficient table groups */
> +enum {
> +=09MAX2175_CH_MSEL =3D 0,
> +=09MAX2175_EQ_MSEL,
> +=09MAX2175_AA_MSEL,
> +};
> +
> +/* HSLS LO injection polarity */
> +enum {
> +=09MAX2175_LO_BELOW_DESIRED =3D 0,
> +=09MAX2175_LO_ABOVE_DESIRED,
> +};
> +
> +/* Channel FSM modes */
> +enum max2175_csm_mode {
> +=09MAX2175_CSM_MODE_LOAD_TO_BUFFER =3D 0,
> +=09MAX2175_CSM_MODE_PRESET_TUNE,
> +=09MAX2175_CSM_MODE_SEARCH,
> +=09MAX2175_CSM_MODE_AF_UPDATE,
> +=09MAX2175_CSM_MODE_JUMP_FAST_TUNE,
> +=09MAX2175_CSM_MODE_CHECK,
> +=09MAX2175_CSM_MODE_LOAD_AND_SWAP,
> +=09MAX2175_CSM_MODE_END,
> +=09MAX2175_CSM_MODE_BUFFER_PLUS_PRESET_TUNE,
> +=09MAX2175_CSM_MODE_BUFFER_PLUS_SEARCH,
> +=09MAX2175_CSM_MODE_BUFFER_PLUS_AF_UPDATE,
> +=09MAX2175_CSM_MODE_BUFFER_PLUS_JUMP_FAST_TUNE,
> +=09MAX2175_CSM_MODE_BUFFER_PLUS_CHECK,
> +=09MAX2175_CSM_MODE_BUFFER_PLUS_LOAD_AND_SWAP,
> +=09MAX2175_CSM_MODE_NO_ACTION
> +};
> +
> +/* Rx mode */
> +struct max2175_rxmode {
> +=09enum max2175_band band;=09=09/* Associated band */
> +=09u32 freq;=09=09=09/* Default freq in Hz */
> +=09u8 i2s_word_size;=09=09/* Bit value */
> +=09u8 i2s_modes[4];=09=09/* Supported modes */
> +};
> +
> +/* Register map */
> +struct max2175_regmap {
> +=09u8 idx;=09=09=09=09/* Register index */
> +=09u8 val;=09=09=09=09/* Register value */
> +};

As no other file than max2175.c includes this, I would move at least th=
e=20
structure definitions to the .c file.

> +#endif /* __MAX2175_H__ */

--=20
Regards,

Laurent Pinchart

