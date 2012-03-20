Return-path: <linux-media-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:50323 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758901Ab2CTWdW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Mar 2012 18:33:22 -0400
Date: Tue, 20 Mar 2012 23:33:12 +0100
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: "Hans-Frieder Vogt" <hfvogt@gmx.net>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH] v0.3 Support for tuner FC0012
Message-ID: <20120320233312.2a204746@milhouse>
In-Reply-To: <201203202314.35920.hfvogt@gmx.net>
References: <201202222321.35533.hfvogt@gmx.net>
	<4F67CED1.407@redhat.com>
	<201203202314.35920.hfvogt@gmx.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Tdml79S6mWkC+PzTVR.61YM"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/Tdml79S6mWkC+PzTVR.61YM
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 20 Mar 2012 23:14:35 +0100
"Hans-Frieder Vogt" <hfvogt@gmx.net> wrote:

> +/*
> +   buf[0] is the first register address
> + */

Just for me to understand this:
How does this work? Does the hardware auto-increment the register address
automatically after each received byte? If so, we could probably document
that here in the comment.

> +static int fc0012_writeregs(struct fc0012_priv *priv, u8 *buf, int len)
> +{
> +	struct i2c_msg msg =3D {
> +		.addr =3D priv->addr, .flags =3D 0, .buf =3D buf, .len =3D len
> +	};
> +
> +	if (i2c_transfer(priv->i2c, &msg, 1) !=3D 1) {
> +		err("I2C write regs failed, reg: %02x, val[0]: %02x",
> +			buf[0], len > 1 ? buf[1] : 0);
> +		return -EREMOTEIO;
> +	}
> +	return 0;
> +}

> +static int fc0012_set_params(struct dvb_frontend *fe)
> +{

> +
> +	priv->frequency =3D freq;

I think this either needs a freq*1000, or priv->frequency=3Dp->frequency.

> +	priv->bandwidth =3D p->bandwidth_hz;
> +
> +error_out:
> +	return ret;
> +}


> +static const struct dvb_tuner_ops fc0012_tuner_ops =3D {
> +        .info =3D {
> +                .name           =3D "Fitipower FC0012",
> +
> +                .frequency_min  =3D 170000000,
> +                .frequency_max  =3D 860000000,
> +                .frequency_step =3D 0,
> +        },
> +
> +        .release       =3D fc0012_release,
> +
> +        .init          =3D fc0012_init,
> +	.sleep         =3D fc0012_sleep,
> +
> +        .set_params    =3D fc0012_set_params,
> +
> +        .get_frequency =3D fc0012_get_frequency,
> +	.get_if_frequency =3D fc0012_get_if_frequency,
> +	.get_bandwidth =3D fc0012_get_bandwidth,
> +};
> +
> +struct dvb_frontend * fc0012_attach(struct dvb_frontend *fe,
> +        struct i2c_adapter *i2c, u8 i2c_address,
> +	enum fc0012_xtal_freq xtal_freq)
> +{
> +        struct fc0012_priv *priv =3D NULL;

Should use tab indention here and in the tuner_ops struct above.

> +
> +#ifndef _FC0012_H_
> +#define _FC0012_H_
> +
> +#include "dvb_frontend.h"
> +
> +enum fc0012_xtal_freq {
> +        FC_XTAL_27_MHZ,      /* 27000000 */
> +        FC_XTAL_28_8_MHZ,    /* 28800000 */
> +        FC_XTAL_36_MHZ,      /* 36000000 */
> +};
> +
> +#if defined(CONFIG_MEDIA_TUNER_FC0012) || \
> +        (defined(CONFIG_MEDIA_TUNER_FC0012_MODULE) && defined(MODULE))

Why check for defined(MODULE) here?

> +extern struct dvb_frontend *fc0012_attach(struct dvb_frontend *fe,
> +					struct i2c_adapter *i2c,
> +					u8 i2c_address,
> +					enum fc0012_xtal_freq xtal_freq);
> +#else


> +#define LOG_PREFIX "fc0012"
> +
> +#define dprintk(var, level, args...) \
> +	do { \
> +		if ((var & level)) \
> +			printk(args); \
> +	} while (0)
> +
> +#define deb_info(args...) dprintk(fc0012_debug, 0x01, args)
> +
> +#undef err
> +#define err(f, arg...)  printk(KERN_ERR     LOG_PREFIX": " f "\n" , ## a=
rg)
> +#undef info
> +#define info(f, arg...) printk(KERN_INFO    LOG_PREFIX": " f "\n" , ## a=
rg)
> +#undef warn
> +#define warn(f, arg...) printk(KERN_WARNING LOG_PREFIX": " f "\n" , ## a=
rg)


I think you should get rid of all these custom print helpers and use dev_er=
r,
dev_info and friends. Those are more ideomatic.

> +struct fc0012_priv {
> +        struct i2c_adapter *i2c;
> +	u8 addr;
> +	u8 xtal_freq;
> +
> +        u32 frequency;
> +	u32 bandwidth;
> +};

Here seems to be some whitespace mixing. tab indention vs. space indention.

--=20
Greetings, Michael.

PGP encryption is encouraged / 908D8B0E

--Sig_/Tdml79S6mWkC+PzTVR.61YM
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPaQWoAAoJEPUyvh2QjYsOljAQAN7bM1CTEE8rG4bJb9sCCVDJ
zcLy2SeU0gE983cxqn3CZyrbCpfnOeeB/qNJ2fTQ3y0WX7CrpsMxYBQNuCNBpFJ/
6wfntoB7I5g5/lX0Vzbar1sQzDXvPXMnXB1RVgnV3x5i9ZE+Yc9MbypIGUshl4OX
+1Idzd0AfukJiYkEENoUYVTl4qwQGdi2s8Fwm3CcuJ5+TroSrft6+F9g8xC3ObGf
paHQ6BZx9aAEdpJ5W7j+aRMrH2p2xwRJlQAnzAEL1t08ma2WNOuYUnl/LZJnT+Xp
E6p7at3cyFAlzljqY6dJW2b5HYnRWHwK71oqFS9Hh3nZTHAFmtA4srLjKU+IM2/o
nnShqDIZAf0xS4tDr4IQ0BIDjVwIlCBVPMs+3cbKxKKB87GTIGNkoK1V4vUkTj1F
ze6JnNOzyscc1K2F/4WtvV+bWB9WRQ97yI2wbw+H2ttwgV0KTk0wEuXMv4X/i79a
rAXQ8d1eFkT32woKgidqIAp2X41IPnWks2W1AyHja0L2Hmf1Sh1cj2srwDUNUWid
+Z0Fn4WV9NFCGni+PE+eX/nlQN+mSl84Oau9E1a7v3CvO++6mr0JpBer6JimX4hX
+Oae5XUSE7JZ5Cb1aXvV0tUSePc/sKGl0wL3Ih2QLy9xGg+x9yxp8nMkbaVRvENJ
c6iWCU096t5p4tDvXu15
=NLpU
-----END PGP SIGNATURE-----

--Sig_/Tdml79S6mWkC+PzTVR.61YM--
