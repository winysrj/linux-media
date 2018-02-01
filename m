Return-path: <linux-media-owner@vger.kernel.org>
Received: from relmlor2.renesas.com ([210.160.252.172]:19369 "EHLO
        relmlie1.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752695AbeBARxY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 1 Feb 2018 12:53:24 -0500
From: Fabrizio Castro <fabrizio.castro@bp.renesas.com>
To: Hugues Fruchet <hugues.fruchet@st.com>
CC: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "Benjamin Gaignard" <benjamin.gaignard@linaro.org>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        "Sakari Ailus" <sakari.ailus@iki.fi>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        "Mauro Carvalho Chehab" <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: RE: [PATCH v5 4/5] media: ov5640: add support of DVP parallel
 interface
Date: Thu, 1 Feb 2018 17:53:18 +0000
Message-ID: <TY1PR06MB089512437228BAFF910B133FC0FA0@TY1PR06MB0895.apcprd06.prod.outlook.com>
References: <1514973452-10464-1-git-send-email-hugues.fruchet@st.com>
 <1514973452-10464-5-git-send-email-hugues.fruchet@st.com>
In-Reply-To: <1514973452-10464-5-git-send-email-hugues.fruchet@st.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hugues,

> Subject: [PATCH v5 4/5] media: ov5640: add support of DVP parallel interf=
ace
>
> Add support of DVP parallel mode in addition of
> existing MIPI CSI mode. The choice between two modes
> and configuration is made through device tree.
>
> Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
> ---
>  drivers/media/i2c/ov5640.c | 148 +++++++++++++++++++++++++++++++++++++++=
------
>  1 file changed, 130 insertions(+), 18 deletions(-)
>
> diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
> index 9f031f3..a44b680 100644
> --- a/drivers/media/i2c/ov5640.c
> +++ b/drivers/media/i2c/ov5640.c
> @@ -34,13 +34,19 @@
>
>  #define OV5640_DEFAULT_SLAVE_ID 0x3c
>
> +#define OV5640_REG_SYS_CTRL00x3008
>  #define OV5640_REG_CHIP_ID0x300a
> +#define OV5640_REG_IO_MIPI_CTRL000x300e
> +#define OV5640_REG_PAD_OUTPUT_ENABLE010x3017
> +#define OV5640_REG_PAD_OUTPUT_ENABLE020x3018
>  #define OV5640_REG_PAD_OUTPUT000x3019
> +#define OV5640_REG_SYSTEM_CONTROL10x302e
>  #define OV5640_REG_SC_PLL_CTRL00x3034
>  #define OV5640_REG_SC_PLL_CTRL10x3035
>  #define OV5640_REG_SC_PLL_CTRL20x3036
>  #define OV5640_REG_SC_PLL_CTRL30x3037
>  #define OV5640_REG_SLAVE_ID0x3100
> +#define OV5640_REG_SCCB_SYS_CTRL10x3103
>  #define OV5640_REG_SYS_ROOT_DIVIDER0x3108
>  #define OV5640_REG_AWB_R_GAIN0x3400
>  #define OV5640_REG_AWB_G_GAIN0x3402
> @@ -70,6 +76,7 @@
>  #define OV5640_REG_HZ5060_CTRL010x3c01
>  #define OV5640_REG_SIGMADELTA_CTRL0C0x3c0c
>  #define OV5640_REG_FRAME_CTRL010x4202
> +#define OV5640_REG_POLARITY_CTRL000x4740
>  #define OV5640_REG_MIPI_CTRL000x4800
>  #define OV5640_REG_DEBUG_MODE0x4814
>  #define OV5640_REG_PRE_ISP_TEST_SET10x503d
> @@ -982,7 +989,111 @@ static int ov5640_get_gain(struct ov5640_dev *senso=
r)
>  return gain & 0x3ff;
>  }
>
> -static int ov5640_set_stream(struct ov5640_dev *sensor, bool on)
> +static int ov5640_set_stream_dvp(struct ov5640_dev *sensor, bool on)
> +{
> +int ret;
> +unsigned int flags =3D sensor->ep.bus.parallel.flags;
> +u8 pclk_pol =3D 0;
> +u8 hsync_pol =3D 0;
> +u8 vsync_pol =3D 0;
> +
> +/*
> + * Note about parallel port configuration.
> + *
> + * When configured in parallel mode, the OV5640 will
> + * output 10 bits data on DVP data lines [9:0].
> + * If only 8 bits data are wanted, the 8 bits data lines
> + * of the camera interface must be physically connected
> + * on the DVP data lines [9:2].
> + *
> + * Control lines polarity can be configured through
> + * devicetree endpoint control lines properties.
> + * If no endpoint control lines properties are set,
> + * polarity will be as below:
> + * - VSYNC:active high
> + * - HREF:active low
> + * - PCLK:active low
> + */
> +
> +if (on) {
> +/*
> + * reset MIPI PCLK/SERCLK divider
> + *
> + * SC PLL CONTRL1 0
> + * - [3..0]:MIPI PCLK/SERCLK divider
> + */
> +ret =3D ov5640_mod_reg(sensor, OV5640_REG_SC_PLL_CTRL1, 0x0f, 0);
> +if (ret)
> +return ret;
> +
> +/*
> + * configure parallel port control lines polarity
> + *
> + * POLARITY CTRL0
> + * - [5]:PCLK polarity (0: active low, 1: active high)
> + * - [1]:HREF polarity (0: active low, 1: active high)
> + * - [0]:VSYNC polarity (mismatch here between
> + *datasheet and hardware, 0 is active high
> + *and 1 is active low...)

I know that yourself and Maxime have both confirmed that VSYNC polarity is =
inverted, but I am looking at HSYNC and VSYNC with a logic analyser and I a=
m dumping the values written to OV5640_REG_POLARITY_CTRL00 and to me it loo=
ks like that HSYNC is active HIGH when hsync_pol =3D=3D 0, and VSYNC is act=
ive HIGH when vsync_pol =3D=3D 1.
Between the SoC and the sensor I have a voltage translator, 2.8V input -> 3=
.3V output, I am measuring the signals at the translator outputs.
Register 0x302A (chip revision register) on my sensor contains 0xb0.

Could you please double check this? How is it possible that this works diff=
erently on my sensor?

Thanks,
Fabrizio

> + */
> +if (flags & V4L2_MBUS_PCLK_SAMPLE_RISING)
> +pclk_pol =3D 1;
> +if (flags & V4L2_MBUS_HSYNC_ACTIVE_HIGH)
> +hsync_pol =3D 1;
> +if (flags & V4L2_MBUS_VSYNC_ACTIVE_LOW)
> +vsync_pol =3D 1;
> +
> +ret =3D ov5640_write_reg(sensor,
> +       OV5640_REG_POLARITY_CTRL00,
> +       (pclk_pol << 5) |
> +       (hsync_pol << 1) |
> +       vsync_pol);
> +
> +if (ret)
> +return ret;
> +}
> +
> +/*
> + * powerdown MIPI TX/RX PHY & disable MIPI
> + *
> + * MIPI CONTROL 00
> + * 4: PWDN PHY TX
> + * 3: PWDN PHY RX
> + * 2: MIPI enable
> + */
> +ret =3D ov5640_write_reg(sensor,
> +       OV5640_REG_IO_MIPI_CTRL00, on ? 0x18 : 0);
> +if (ret)
> +return ret;
> +
> +/*
> + * enable VSYNC/HREF/PCLK DVP control lines
> + * & D[9:6] DVP data lines
> + *
> + * PAD OUTPUT ENABLE 01
> + * - 6:VSYNC output enable
> + * - 5:HREF output enable
> + * - 4:PCLK output enable
> + * - [3:0]:D[9:6] output enable
> + */
> +ret =3D ov5640_write_reg(sensor,
> +       OV5640_REG_PAD_OUTPUT_ENABLE01,
> +       on ? 0x7f : 0);
> +if (ret)
> +return ret;
> +
> +/*
> + * enable D[5:0] DVP data lines
> + *
> + * PAD OUTPUT ENABLE 02
> + * - [7:2]:D[5:0] output enable
> + */
> +return ov5640_write_reg(sensor,
> +OV5640_REG_PAD_OUTPUT_ENABLE02,
> +on ? 0xfc : 0);
> +}
> +
> +static int ov5640_set_stream_mipi(struct ov5640_dev *sensor, bool on)
>  {
>  int ret;
>
> @@ -1604,17 +1715,19 @@ static int ov5640_set_power(struct ov5640_dev *se=
nsor, bool on)
>  if (ret)
>  goto power_off;
>
> -/*
> - * start streaming briefly followed by stream off in
> - * order to coax the clock lane into LP-11 state.
> - */
> -ret =3D ov5640_set_stream(sensor, true);
> -if (ret)
> -goto power_off;
> -usleep_range(1000, 2000);
> -ret =3D ov5640_set_stream(sensor, false);
> -if (ret)
> -goto power_off;
> +if (sensor->ep.bus_type =3D=3D V4L2_MBUS_CSI2) {
> +/*
> + * start streaming briefly followed by stream off in
> + * order to coax the clock lane into LP-11 state.
> + */
> +ret =3D ov5640_set_stream_mipi(sensor, true);
> +if (ret)
> +goto power_off;
> +usleep_range(1000, 2000);
> +ret =3D ov5640_set_stream_mipi(sensor, false);
> +if (ret)
> +goto power_off;
> +}
>
>  return 0;
>  }
> @@ -2188,7 +2301,11 @@ static int ov5640_s_stream(struct v4l2_subdev *sd,=
 int enable)
>  goto out;
>  }
>
> -ret =3D ov5640_set_stream(sensor, enable);
> +if (sensor->ep.bus_type =3D=3D V4L2_MBUS_CSI2)
> +ret =3D ov5640_set_stream_mipi(sensor, enable);
> +else
> +ret =3D ov5640_set_stream_dvp(sensor, enable);
> +
>  if (!ret)
>  sensor->streaming =3D enable;
>  }
> @@ -2301,11 +2418,6 @@ static int ov5640_probe(struct i2c_client *client,
>  return ret;
>  }
>
> -if (sensor->ep.bus_type !=3D V4L2_MBUS_CSI2) {
> -dev_err(dev, "invalid bus type, must be MIPI CSI2\n");
> -return -EINVAL;
> -}
> -
>  /* get system clock (xclk) */
>  sensor->xclk =3D devm_clk_get(dev, "xclk");
>  if (IS_ERR(sensor->xclk)) {
> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



Renesas Electronics Europe Ltd, Dukes Meadow, Millboard Road, Bourne End, B=
uckinghamshire, SL8 5FH, UK. Registered in England & Wales under Registered=
 No. 04586709.
