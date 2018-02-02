Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:50208 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752580AbeBBSus (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Feb 2018 13:50:48 -0500
Date: Fri, 2 Feb 2018 19:50:45 +0100
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Fabrizio Castro <fabrizio.castro@bp.renesas.com>
Cc: Hugues Fruchet <hugues.fruchet@st.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH v5 4/5] media: ov5640: add support of DVP parallel
 interface
Message-ID: <20180202185045.vvhmj5wtagalkucf@flea.lan>
References: <1514973452-10464-1-git-send-email-hugues.fruchet@st.com>
 <1514973452-10464-5-git-send-email-hugues.fruchet@st.com>
 <TY1PR06MB089512437228BAFF910B133FC0FA0@TY1PR06MB0895.apcprd06.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="xddzjzvatmjib73a"
Content-Disposition: inline
In-Reply-To: <TY1PR06MB089512437228BAFF910B133FC0FA0@TY1PR06MB0895.apcprd06.prod.outlook.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--xddzjzvatmjib73a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Fabrizio,

On Thu, Feb 01, 2018 at 05:53:18PM +0000, Fabrizio Castro wrote:
> > Subject: [PATCH v5 4/5] media: ov5640: add support of DVP parallel inte=
rface
> >
> > Add support of DVP parallel mode in addition of
> > existing MIPI CSI mode. The choice between two modes
> > and configuration is made through device tree.
> >
> > Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
> > ---
> >  drivers/media/i2c/ov5640.c | 148 +++++++++++++++++++++++++++++++++++++=
++------
> >  1 file changed, 130 insertions(+), 18 deletions(-)
> >
> > diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
> > index 9f031f3..a44b680 100644
> > --- a/drivers/media/i2c/ov5640.c
> > +++ b/drivers/media/i2c/ov5640.c
> > @@ -34,13 +34,19 @@
> >
> >  #define OV5640_DEFAULT_SLAVE_ID 0x3c
> >
> > +#define OV5640_REG_SYS_CTRL00x3008
> >  #define OV5640_REG_CHIP_ID0x300a
> > +#define OV5640_REG_IO_MIPI_CTRL000x300e
> > +#define OV5640_REG_PAD_OUTPUT_ENABLE010x3017
> > +#define OV5640_REG_PAD_OUTPUT_ENABLE020x3018
> >  #define OV5640_REG_PAD_OUTPUT000x3019
> > +#define OV5640_REG_SYSTEM_CONTROL10x302e
> >  #define OV5640_REG_SC_PLL_CTRL00x3034
> >  #define OV5640_REG_SC_PLL_CTRL10x3035
> >  #define OV5640_REG_SC_PLL_CTRL20x3036
> >  #define OV5640_REG_SC_PLL_CTRL30x3037
> >  #define OV5640_REG_SLAVE_ID0x3100
> > +#define OV5640_REG_SCCB_SYS_CTRL10x3103
> >  #define OV5640_REG_SYS_ROOT_DIVIDER0x3108
> >  #define OV5640_REG_AWB_R_GAIN0x3400
> >  #define OV5640_REG_AWB_G_GAIN0x3402
> > @@ -70,6 +76,7 @@
> >  #define OV5640_REG_HZ5060_CTRL010x3c01
> >  #define OV5640_REG_SIGMADELTA_CTRL0C0x3c0c
> >  #define OV5640_REG_FRAME_CTRL010x4202
> > +#define OV5640_REG_POLARITY_CTRL000x4740
> >  #define OV5640_REG_MIPI_CTRL000x4800
> >  #define OV5640_REG_DEBUG_MODE0x4814
> >  #define OV5640_REG_PRE_ISP_TEST_SET10x503d
> > @@ -982,7 +989,111 @@ static int ov5640_get_gain(struct ov5640_dev *sen=
sor)
> >  return gain & 0x3ff;
> >  }
> >
> > -static int ov5640_set_stream(struct ov5640_dev *sensor, bool on)
> > +static int ov5640_set_stream_dvp(struct ov5640_dev *sensor, bool on)
> > +{
> > +int ret;
> > +unsigned int flags =3D sensor->ep.bus.parallel.flags;
> > +u8 pclk_pol =3D 0;
> > +u8 hsync_pol =3D 0;
> > +u8 vsync_pol =3D 0;
> > +
> > +/*
> > + * Note about parallel port configuration.
> > + *
> > + * When configured in parallel mode, the OV5640 will
> > + * output 10 bits data on DVP data lines [9:0].
> > + * If only 8 bits data are wanted, the 8 bits data lines
> > + * of the camera interface must be physically connected
> > + * on the DVP data lines [9:2].
> > + *
> > + * Control lines polarity can be configured through
> > + * devicetree endpoint control lines properties.
> > + * If no endpoint control lines properties are set,
> > + * polarity will be as below:
> > + * - VSYNC:active high
> > + * - HREF:active low
> > + * - PCLK:active low
> > + */
> > +
> > +if (on) {
> > +/*
> > + * reset MIPI PCLK/SERCLK divider
> > + *
> > + * SC PLL CONTRL1 0
> > + * - [3..0]:MIPI PCLK/SERCLK divider
> > + */
> > +ret =3D ov5640_mod_reg(sensor, OV5640_REG_SC_PLL_CTRL1, 0x0f, 0);
> > +if (ret)
> > +return ret;
> > +
> > +/*
> > + * configure parallel port control lines polarity
> > + *
> > + * POLARITY CTRL0
> > + * - [5]:PCLK polarity (0: active low, 1: active high)
> > + * - [1]:HREF polarity (0: active low, 1: active high)
> > + * - [0]:VSYNC polarity (mismatch here between
> > + *datasheet and hardware, 0 is active high
> > + *and 1 is active low...)
>=20
> I know that yourself and Maxime have both confirmed that VSYNC
> polarity is inverted, but I am looking at HSYNC and VSYNC with a
> logic analyser and I am dumping the values written to
> OV5640_REG_POLARITY_CTRL00 and to me it looks like that HSYNC is
> active HIGH when hsync_pol =3D=3D 0, and VSYNC is active HIGH when
> vsync_pol =3D=3D 1.

Which mode are you testing this on?

The non-active periods are insanely high in most modes (1896 for an
active horizontal length of 640 in 640x480 for example), especially
hsync, and it's really easy to invert the two.

Maxime

--=20
Maxime Ripard, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
http://bootlin.com

--xddzjzvatmjib73a
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlp0svgACgkQ0rTAlCFN
r3RQvw//XReoY+kJhjbjWxAq3T3+s+AWXNUobt0LTHaWlYOYa6dYA9jaoihZXVVv
BFtA9iI1/k4+A1Q55rDXobsCqeKzKf4zkHbMhO7LUlKW9twtsWl8Kh8G3ZyRyEsE
SMneEY3qyRJLOn7tn94CXfJeffZpYF25H4SY1Y1MVlS+Jdyc8QrzK2bJzLnTd9i+
Yxikrq4cEecQBIkoRhKFPrDMOyq9lZeE4Xfk9T4IzwhHZGgAUwXYtifnyzTfrd29
wx1ZAo3COgMs0UND9nevY4Fm+HFNTDxdk8WHE/F07L1dTG/njNC+OCsHS+ocUkPl
G5QfIIAJleOMxwj4OfWhGRVgxxiE7jYFXjHbBIw2jc4MTHkzsGDx42d1ZQLsz27E
5hwEiXYaU6Rv2z/b+kkTaty1JNDpX//ArGzUCKD/kUDl94vv/c0UxkdIcSO/5AEp
weu6gavWMdOJX+Pk4KUCE5Xmpbk3FA7icDhrgTGEkU55n/Kd9TRUxCZzwPntcmEM
FXrO83mAvx00fu4XjmNtPFs8hx8BqkLZbemHu7T19HR9MmeYdN3KSmwAolIOkkDH
ZTq6eTHTi3D2q7hsDseehaB84IMb4Dti38eMYQVgJ72BOVnvPhHW9AnwyiakPalM
CyiJme2NKGLcXbw/5pkWDo8nT0v1RXixofcZxNZ+idr38AJmNvA=
=o2eR
-----END PGP SIGNATURE-----

--xddzjzvatmjib73a--
