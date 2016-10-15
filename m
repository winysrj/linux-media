Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:33912 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752447AbcJOMmU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 15 Oct 2016 08:42:20 -0400
MIME-Version: 1.0
In-Reply-To: <1476281429-27603-2-git-send-email-ramesh.shanmugasundaram@bp.renesas.com>
References: <1476281429-27603-1-git-send-email-ramesh.shanmugasundaram@bp.renesas.com>
 <1476281429-27603-2-git-send-email-ramesh.shanmugasundaram@bp.renesas.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Sat, 15 Oct 2016 14:42:18 +0200
Message-ID: <CAMuHMdUYQoJL4h8prEpontF4YH8Ha+SWDdeZHYEV3_uMZ-SBXw@mail.gmail.com>
Subject: Re: [RFC 1/5] media: i2c: max2175: Add MAX2175 support
To: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
Cc: Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Antti Palosaari <crope@iki.fi>,
        Chris Paterson <chris.paterson2@renesas.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ramesh,

On Wed, Oct 12, 2016 at 4:10 PM, Ramesh Shanmugasundaram
<ramesh.shanmugasundaram@bp.renesas.com> wrote:
> This patch adds driver support for MAX2175 chip. This is Maxim
> Integrated's RF to Bits tuner front end chip designed for software-define=
d
> radio solutions. This driver exposes the tuner as a sub-device instance
> with standard and custom controls to configure the device.
>
> Signed-off-by: Ramesh Shanmugasundaram < for your patch!amesh.shanmugasun=
daram@bp.renesas.com>

Thanks for your patch!

> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/i2c/max2175.txt
> @@ -0,0 +1,60 @@
> +Maxim Integrated MAX2175 RF to Bits tuner
> +-----------------------------------------
> +
> +The MAX2175 IC is an advanced analog/digital hybrid-radio receiver with
> +RF to Bits=C2=AE front-end designed for software-defined radio solutions=
.
> +
> +Required properties:
> +--------------------
> +- compatible: "maxim,max2175" for MAX2175 RF-to-bits tuner.
> +- clocks: phandle to the fixed xtal clock.
> +- clock-names: name of the fixed xtal clock.
> +- port: video interface child port node of a tuner that defines the loca=
l
> +  and remote endpoints. The remote endpoint is assumed to be an SDR devi=
ce
> +  that is capable of receiving the digital samples from the tuner.
> +
> +Optional properties:
> +--------------------
> +- maxim,slave     : empty property indicates this is a slave of another
> +                    master tuner. This is used to define two tuners in
> +                    diversity mode (1 master, 1 slave). By default each
> +                    tuner is an individual master.
> +- maxim,refout-load: load capacitance value (in pF) on reference output
> +                    drive level. The mapping of these load values to
> +                    respective bit values are given below.
> +                    0 - Reference output disabled
> +                    1 - 10pF load
> +                    2 - 20pF load
> +                    3 - 30pF load
> +                    4 - 40pF load
> +                    5 - 60pF load
> +                    6 - 70pF load

For properties involving units, usually the unit is made part of the
property name, e.g. maxim,refout-load-pF =3D 40.
This avoids confusion, and allows for extension later.

> +/* A tuner device instance under i2c bus */
> +max2175_0: tuner@60 {
> +       #clock-cells =3D <0>;
> +       compatible =3D "maxim,max2175";
> +       reg =3D <0x60>;
> +       clocks =3D <&maxim_xtal>;
> +       clock-names =3D "xtal";
> +       maxim,refout-load =3D <10>;

10 is not listed above. Perhaps you meant 10 pF?

> --- /dev/null
> +++ b/drivers/media/i2c/max2175/max2175.c
> @@ -0,0 +1,1624 @@

> +/* NOTE: Any addition/deletion in the below list should be reflected in
> + * max2175_modetag enum
> + */

You can drop the above comment if you make this explicit using C99
designated initializers, cfr. below.

> +static const struct max2175_rxmode eu_rx_modes[] =3D { /* Indexed by EU =
modetag */
> +       /* EU modes */
> +       { MAX2175_BAND_VHF, 182640000, 0, { 0, 0, 0, 0 } },

[MAX2175_DAB_1_2] =3D { MAX2175_BAND_VHF, 182640000, 0, { 0, 0, 0, 0 } },

> +};
> +
> +static const struct max2175_rxmode na_rx_modes[] =3D { /* Indexed by NA =
modetag */
> +       /* NA modes */
> +       { MAX2175_BAND_FM, 98255520, 1, { 0, 0, 0, 0 } },

[MAX2175_NA_FM_1_0] =3D { MAX2175_BAND_FM, 98255520, 1, { 0, 0, 0, 0 } },

> +struct max2175_ctx {
> +       struct v4l2_subdev sd;
> +       struct i2c_client *client;
> +       struct device *dev;
> +
> +       /* Cached configuration */
> +       u8 regs[256];
> +       enum max2175_modetag mode;      /* Receive mode tag */
> +       u32 freq;                       /* In Hz */
> +       struct max2175_rxmode *rx_modes;
> +
> +       /* Device settings */
> +       bool master;
> +       u32 decim_ratio;
> +       u64 xtal_freq;
> +
> +       /* ROM values */
> +       u8 rom_bbf_bw_am;
> +       u8 rom_bbf_bw_fm;
> +       u8 rom_bbf_bw_dab;
> +
> +       /* Local copy of old settings */
> +       u8 i2s_test;
> +
> +       u8 nbd_gain;
> +       u8 nbd_threshold;
> +       u8 wbd_gain;
> +       u8 wbd_threshold;
> +       u8 bbd_threshold;
> +       u8 bbdclip_threshold;
> +       u8 lt_wbd_threshold;
> +       u8 lt_wbd_gain;
> +
> +       /* Controls */
> +       struct v4l2_ctrl_handler ctrl_hdl;
> +       struct v4l2_ctrl *lna_gain;     /* LNA gain value */
> +       struct v4l2_ctrl *if_gain;      /* I/F gain value */
> +       struct v4l2_ctrl *pll_lock;     /* PLL lock */
> +       struct v4l2_ctrl *i2s_en;       /* I2S output enable */
> +       struct v4l2_ctrl *i2s_mode;     /* I2S mode value */
> +       struct v4l2_ctrl *am_hiz;       /* AM High impledance input */
> +       struct v4l2_ctrl *hsls;         /* High-side/Low-side polarity */
> +       struct v4l2_ctrl *rx_mode;      /* Receive mode */
> +
> +       /* Driver private variables */
> +       bool mode_resolved;             /* Flag to sanity check settings =
*/
> +};

Sorting the struct members by decreasing size helps to avoid gaps due to
alignment restrictions, and may reduce memory consumption.

> +/* Flush local copy to device from idx to idx+len (inclusive) */
> +static void max2175_flush_regstore(struct max2175_ctx *ctx, u8 idx, u8 l=
en)
> +{
> +       u8 i;

I'd just use unsigned int for loop counters.

> +
> +       for (i =3D idx; i <=3D len; i++)
> +               max2175_reg_write(ctx, i, ctx->regs[i]);
> +}

> +static int max2175_update_i2s_mode(struct max2175_ctx *ctx, u32 i2s_mode=
)
> +{
> +       /* Only change if it's new */
> +       if (max2175_read_bits(ctx, 29, 2, 0) =3D=3D i2s_mode)

Many magic numbers, not only here (29, 2), but everywhere.
Can you please add #defines for these?

> +               return 0;
> +
> +       max2175_write_bits(ctx, 29, 2, 0, i2s_mode);
> +
> +       /* Based on I2S mode value I2S_WORD_CNT values change */
> +       if (i2s_mode =3D=3D MAX2175_I2S_MODE3) {
> +               max2175_write_bits(ctx, 30, 6, 0, 1);
> +       } else if (i2s_mode =3D=3D MAX2175_I2S_MODE2 ||
> +                  i2s_mode =3D=3D MAX2175_I2S_MODE4) {
> +               max2175_write_bits(ctx, 30, 6, 0, 0);
> +       } else if (i2s_mode =3D=3D MAX2175_I2S_MODE0) {
> +               max2175_write_bits(ctx, 30, 6, 0,
> +                                  ctx->rx_modes[ctx->mode].i2s_word_size=
);
> +       } else {
> +               v4l2_err(ctx->client,
> +                        "failed: i2s_mode %u unsupported\n", i2s_mode);
> +               return 1;
> +       }

switch (i2s_mode) { ... }

> +       mxm_dbg(ctx, "updated i2s_mode %u\n", i2s_mode);
> +       return 0;
> +}

> +static void max2175_set_filter_coeffs(struct max2175_ctx *ctx, u8 m_sel,
> +                                     u8 bank, const u16 *coeffs)
> +{
> +       u8 i, coeff_addr, upper_address;

I'd just use unsigned int for these.

> +
> +       mxm_dbg(ctx, "start: m_sel %d bank %d\n", m_sel, bank);
> +       max2175_write_bits(ctx, 114, 5, 4, m_sel);
> +
> +       if (m_sel =3D=3D 2)
> +               upper_address =3D 12;
> +       else
> +               upper_address =3D 24;
> +
> +       max2175_set_bit(ctx, 117, 7, 1);
> +       for (i =3D 0; i < upper_address; i++) {
> +               coeff_addr =3D i + (bank * 24);
> +               max2175_set_bits(ctx, 115, 7, 0,
> +                                (u8)((coeffs[i] >> 8) & 0xff));
> +               max2175_set_bits(ctx, 116, 7, 0, (u8)(coeffs[i] & 0xff));

I don't think you need the casts to u8, or the masking with 0xff.

> +               max2175_set_bits(ctx, 117, 6, 0, coeff_addr);
> +               max2175_flush_regstore(ctx, 115, 3);
> +       }
> +       max2175_write_bit(ctx, 117, 7, 0);
> +}
> +
> +static void max2175_load_dab_1p2(struct max2175_ctx *ctx)
> +{
> +       u32 i;

unsigned int?

> +static int max2175_set_lo_freq(struct max2175_ctx *ctx, u64 lo_freq)
> +{
> +       int ret;
> +       u32 lo_mult;
> +       u64 scaled_lo_freq;
> +       const u64 scale_factor =3D 1000000ULL;
> +       u64 scaled_npf, scaled_integer, scaled_fraction;
> +       u32 frac_desired, int_desired;
> +       u8 loband_bits, vcodiv_bits;
> +
> +       scaled_lo_freq =3D lo_freq;
> +       /* Scale to larger number for precision */
> +       scaled_lo_freq =3D scaled_lo_freq * scale_factor * 100;
> +
> +       mxm_dbg(ctx, "scaled lo_freq %llu lo_freq %llu\n",
> +               scaled_lo_freq, lo_freq);
> +
> +       if (MAX2175_IS_BAND_AM(ctx)) {
> +               if (max2175_get_bit(ctx, 5, 7) =3D=3D 0)
> +                       loband_bits =3D 0;
> +                       vcodiv_bits =3D 0;
> +                       lo_mult =3D 16;
> +       } else if (max2175_get_bits(ctx, 5, 1, 0) =3D=3D MAX2175_BAND_FM)=
 {
> +               if (lo_freq <=3D 74700000) {
> +                       loband_bits =3D 0;
> +                       vcodiv_bits =3D 0;
> +                       lo_mult =3D 16;
> +               } else if ((lo_freq > 74700000) && (lo_freq <=3D 11000000=
0)) {
> +                       loband_bits =3D 1;
> +                       vcodiv_bits =3D 0;
> +               } else {
> +                       loband_bits =3D 1;
> +                       vcodiv_bits =3D 3;
> +               }
> +               lo_mult =3D 8;
> +       } else if (max2175_get_bits(ctx, 5, 1, 0) =3D=3D MAX2175_BAND_VHF=
) {
> +               if (lo_freq <=3D 210000000) {
> +                       loband_bits =3D 2;
> +                       vcodiv_bits =3D 2;
> +               } else {
> +                       loband_bits =3D 2;
> +                       vcodiv_bits =3D 1;
> +               }
> +               lo_mult =3D 4;
> +       } else {
> +               loband_bits =3D 3;
> +               vcodiv_bits =3D 2;
> +               lo_mult =3D 2;
> +       }
> +
> +       if (max2175_get_bits(ctx, 5, 1, 0) =3D=3D MAX2175_BAND_L)
> +               scaled_npf =3D (scaled_lo_freq / ctx->xtal_freq / lo_mult=
) / 100;
> +       else
> +               scaled_npf =3D (scaled_lo_freq / ctx->xtal_freq * lo_mult=
) / 100;

Please use one of the div64*() functions for divisions involving 64-bit
quantities (try to build for 32-bit and see). More of these below...

> +       scaled_integer =3D scaled_npf / scale_factor * scale_factor;
> +       int_desired =3D (u32)(scaled_npf / scale_factor);
> +       scaled_fraction =3D scaled_npf - scaled_integer;
> +       frac_desired =3D (u32)(scaled_fraction * 1048576 / scale_factor);

> +       /* Write the calculated values to the appropriate registers */
> +       max2175_set_bits(ctx, 5, 3, 2, loband_bits);
> +       max2175_set_bits(ctx, 6, 7, 6, vcodiv_bits);
> +       max2175_set_bits(ctx, 1, 7, 0, (u8)(int_desired & 0xff));
> +       max2175_set_bits(ctx, 2, 3, 0, (u8)((frac_desired >> 16) & 0x1f))=
;
> +       max2175_set_bits(ctx, 3, 7, 0, (u8)((frac_desired >> 8) & 0xff));
> +       max2175_set_bits(ctx, 4, 7, 0, (u8)(frac_desired & 0xff));

No need for casts etc.

> +       /* Flush the above registers to device */
> +       max2175_flush_regstore(ctx, 1, 6);
> +       return ret;
> +}
> +
> +static int max2175_set_nco_freq(struct max2175_ctx *ctx, s64 nco_freq_de=
sired)
> +{
> +       int ret;
> +       u64 clock_rate, abs_nco_freq;
> +       s64  nco_freq, nco_val_desired;
> +       u32 nco_reg;
> +       const u64 scale_factor =3D 1000000ULL;
> +
> +       mxm_dbg(ctx, "nco_freq: freq =3D %lld\n", nco_freq_desired);
> +       clock_rate =3D ctx->xtal_freq / ctx->decim_ratio;
> +       nco_freq =3D -nco_freq_desired;
> +
> +       if (nco_freq < 0)
> +               abs_nco_freq =3D -nco_freq;
> +       else
> +               abs_nco_freq =3D nco_freq;
> +
> +       /* Scale up the values for precision */
> +       if (abs_nco_freq < (clock_rate / 2)) {
> +               nco_val_desired =3D (2 * nco_freq * scale_factor) / clock=
_rate;
> +       } else {
> +               if (nco_freq < 0)
> +                       nco_val_desired =3D (-2 * (clock_rate - abs_nco_f=
req) *
> +                               scale_factor) / clock_rate;
> +               else
> +                       nco_val_desired =3D (2 * (clock_rate - abs_nco_fr=
eq) *
> +                               scale_factor) / clock_rate;
> +       }
> +
> +       /* Scale down to get the fraction */
> +       if (nco_freq < 0)
> +               nco_reg =3D 0x200000 + ((nco_val_desired * 1048576) /
> +                                     scale_factor);
> +       else
> +               nco_reg =3D (nco_val_desired * 1048576) / scale_factor;

More 64-bit divisions. In addition, the dividers are 64-bit too.
Can't they be 32-bit?

> +static int max2175_probe(struct i2c_client *client,
> +                       const struct i2c_device_id *id)
> +{
> +       struct max2175_ctx *ctx;
> +       struct device *dev =3D &client->dev;
> +       struct v4l2_subdev *sd;
> +       struct v4l2_ctrl_handler *hdl;
> +       struct clk *clk;
> +       bool master =3D true;
> +       u32 refout_load, refout_bits =3D 0;       /* REFOUT disabled */
> +       int ret;
> +
> +       /* Check if the adapter supports the needed features */
> +       if (!i2c_check_functionality(client->adapter,
> +                                    I2C_FUNC_SMBUS_BYTE_DATA)) {
> +               dev_err(&client->dev, "i2c check failed\n");
> +               return -EIO;
> +       }
> +
> +       if (of_find_property(client->dev.of_node, "maxim,slave", NULL))
> +               master =3D false;
> +
> +       if (!of_property_read_u32(client->dev.of_node, "maxim,refout-load=
",
> +                                &refout_load))
> +               refout_bits =3D max2175_refout_load_to_bits(client, refou=
t_load);
> +
> +       clk =3D devm_clk_get(&client->dev, "xtal");
> +       if (IS_ERR(clk)) {
> +               ret =3D PTR_ERR(clk);
> +               dev_err(&client->dev, "cannot get xtal clock %d\n", ret);
> +               return -ENODEV;
> +       }
> +
> +       ctx =3D kzalloc(sizeof(struct max2175_ctx),
> +                            GFP_KERNEL);

devm_kzalloc()?

> +       if (ctx =3D=3D NULL)
> +               return -ENOMEM;
> +
> +       sd =3D &ctx->sd;
> +       ctx->master =3D master;
> +       ctx->mode_resolved =3D false;
> +
> +       /* Set the defaults */
> +       ctx->freq =3D bands_rf.rangelow;
> +
> +       ctx->xtal_freq =3D clk_get_rate(clk);
> +       dev_info(&client->dev, "xtal freq %lluHz\n", ctx->xtal_freq);
> +
> +       v4l2_i2c_subdev_init(sd, client, &max2175_ops);
> +       ctx->client =3D client;
> +
> +       sd->flags =3D V4L2_SUBDEV_FL_HAS_DEVNODE;
> +       ctx->dev =3D dev;
> +
> +       /* Controls */
> +       hdl =3D &ctx->ctrl_hdl;
> +       ret =3D v4l2_ctrl_handler_init(hdl, 8);
> +       if (ret) {
> +               dev_err(&client->dev, "ctrl handler init failed\n");
> +               goto err;
> +       }
> +
> +       ctx->lna_gain =3D v4l2_ctrl_new_std(hdl, &max2175_ctrl_ops,
> +                                         V4L2_CID_RF_TUNER_LNA_GAIN,
> +                                         0, 15, 1, 2);
> +       ctx->lna_gain->flags |=3D (V4L2_CTRL_FLAG_VOLATILE |
> +                                V4L2_CTRL_FLAG_READ_ONLY);
> +       ctx->if_gain =3D v4l2_ctrl_new_std(hdl, &max2175_ctrl_ops,
> +                                        V4L2_CID_RF_TUNER_IF_GAIN,
> +                                        0, 31, 1, 0);
> +       ctx->if_gain->flags |=3D (V4L2_CTRL_FLAG_VOLATILE |
> +                               V4L2_CTRL_FLAG_READ_ONLY);
> +       ctx->pll_lock =3D v4l2_ctrl_new_std(hdl, &max2175_ctrl_ops,
> +                                         V4L2_CID_RF_TUNER_PLL_LOCK,
> +                                         0, 1, 1, 0);
> +       ctx->pll_lock->flags |=3D (V4L2_CTRL_FLAG_VOLATILE |
> +                                V4L2_CTRL_FLAG_READ_ONLY);
> +       ctx->i2s_en =3D v4l2_ctrl_new_custom(hdl, &max2175_i2s_en, NULL);
> +       ctx->i2s_mode =3D v4l2_ctrl_new_custom(hdl, &max2175_i2s_mode, NU=
LL);
> +       ctx->am_hiz =3D v4l2_ctrl_new_custom(hdl, &max2175_am_hiz, NULL);
> +       ctx->hsls =3D v4l2_ctrl_new_custom(hdl, &max2175_hsls, NULL);
> +
> +       if (ctx->xtal_freq =3D=3D MAX2175_EU_XTAL_FREQ) {
> +               ctx->rx_mode =3D v4l2_ctrl_new_custom(hdl,
> +                                                   &max2175_eu_rx_mode, =
NULL);
> +               ctx->rx_modes =3D (struct max2175_rxmode *)eu_rx_modes;
> +       } else {
> +               ctx->rx_mode =3D v4l2_ctrl_new_custom(hdl,
> +                                                   &max2175_na_rx_mode, =
NULL);
> +               ctx->rx_modes =3D (struct max2175_rxmode *)na_rx_modes;
> +       }

The casts are meant to cast away constness. Can that be avoided?

> --- /dev/null
> +++ b/drivers/media/i2c/max2175/max2175.h

> +/* NOTE: Any addition/deletion in the below enum should be reflected in
> + * V4L2_CID_MAX2175_RX_MODE ctrl strings

Which strings exactly?

> + */
> +enum max2175_modetag {
> +       /* EU modes */
> +       MAX2175_DAB_1_2 =3D 0,
> +
> +       /* Other possible modes to add in future
> +        * MAX2175_DAB_1_0,
> +        * MAX2175_DAB_1_3,
> +        * MAX2175_EU_FM_2_2,
> +        * MAX2175_EU_FM_1_0,
> +        * MAX2175_EU_FMHD_4_0,
> +        * MAX2175_EU_AM_1_0,
> +        * MAX2175_EU_AM_2_2,
> +        */
> +
> +       /* NA modes */
> +       MAX2175_NA_FM_1_0 =3D 0,
> +
> +       /* Other possible modes to add in future
> +        * MAX2175_NA_FM_1_2,
> +        * MAX2175_NA_FMHD_1_0,
> +        * MAX2175_NA_FMHD_1_2,
> +        * MAX2175_NA_AM_1_0,
> +        * MAX2175_NA_AM_1_2,
> +        */

The MAX2175_NA_* definitions share their values with the MAX2175_DAB_* and
future MAX2175_EU_* values. Do you have to use a single enum for both?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k=
.org

In personal conversations with technical people, I call myself a hacker. Bu=
t
when I'm talking to journalists I just say "programmer" or something like t=
hat.
                                -- Linus Torvalds
