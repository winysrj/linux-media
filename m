Return-path: <linux-media-owner@vger.kernel.org>
Received: from impaqm4.telefonica.net ([213.4.138.20]:52530 "EHLO
	telefonica.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753767Ab1GPLi1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Jul 2011 07:38:27 -0400
From: Jose Alberto Reguero <jareguero@telefonica.net>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH] improve recection with limits frecuenies and tda827x
Date: Sat, 16 Jul 2011 13:38:13 +0200
Cc: linux-media@vger.kernel.org,
	Michael Krufky <mkrufky@kernellabs.com>
References: <201106070205.08118.jareguero@telefonica.net> <201107070057.06317.jareguero@telefonica.net> <4E1D927A.5090006@redhat.com>
In-Reply-To: <4E1D927A.5090006@redhat.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_ngXIOSTtHdJZlCr"
Message-Id: <201107161338.15263.jareguero@telefonica.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Boundary-00=_ngXIOSTtHdJZlCr
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mi=C3=A9rcoles, 13 de Julio de 2011 14:41:30 Mauro Carvalho Chehab escri=
bi=C3=B3:
> Em 06-07-2011 19:57, Jose Alberto Reguero escreveu:
> > This patch add suport for the dvb-t part of CT-3650.
> >=20
> > Jose Alberto
> >=20
> > Signed-off-by: Jose Alberto Reguero <jareguero@telefonica.net>
> >=20
> > patches/lmml_951522_add_support_for_the_dvb_t_part_of_ct_3650_v2.patch
> > Content-Type: text/plain; charset=3D"utf-8"
> > MIME-Version: 1.0
> > Content-Transfer-Encoding: 7bit
> > Subject: add support for the dvb-t part of CT-3650 v2
> > Date: Wed, 06 Jul 2011 22:57:04 -0000
> > From: Jose Alberto Reguero <jareguero@telefonica.net>
> > X-Patchwork-Id: 951522
> > Message-Id: <201107070057.06317.jareguero@telefonica.net>
> > To: linux-media@vger.kernel.org
> >=20
> > This patch add suport for the dvb-t part of CT-3650.
> >=20
> > Jose Alberto
> >=20
> > Signed-off-by: Jose Alberto Reguero <jareguero@telefonica.net>
> >=20
> >=20
> > diff -ur linux/drivers/media/common/tuners/tda827x.c
> > linux.new/drivers/media/common/tuners/tda827x.c ---
> > linux/drivers/media/common/tuners/tda827x.c	2010-07-03
> > 23:22:08.000000000 +0200 +++
> > linux.new/drivers/media/common/tuners/tda827x.c	2011-07-04
> > 12:00:29.931561053 +0200 @@ -135,14 +135,29 @@
> >=20
> >  static int tuner_transfer(struct dvb_frontend *fe,
> > =20
> >  			  struct i2c_msg *msg,
> >=20
> > -			  const int size)
> > +			  int size)
> >=20
> >  {
> > =20
> >  	int rc;
> >  	struct tda827x_priv *priv =3D fe->tuner_priv;
> >=20
> > +	struct i2c_msg msgr[2];
> >=20
> >  	if (fe->ops.i2c_gate_ctrl)
> >  =09
> >  		fe->ops.i2c_gate_ctrl(fe, 1);
> >=20
> > -	rc =3D i2c_transfer(priv->i2c_adap, msg, size);
> > +	if (priv->cfg->i2cr && (msg->flags =3D=3D I2C_M_RD)) {
> > +		msgr[0].addr =3D msg->addr;
> > +		msgr[0].flags =3D 0;
> > +		msgr[0].len =3D msg->len - 1;
> > +		msgr[0].buf =3D msg->buf;
> > +		msgr[1].addr =3D msg->addr;
> > +		msgr[1].flags =3D I2C_M_RD;
> > +		msgr[1].len =3D 1;
> > +		msgr[1].buf =3D msg->buf;
> > +		size =3D 2;
> > +		rc =3D i2c_transfer(priv->i2c_adap, msgr, size);
> > +		msg->buf[msg->len - 1] =3D msgr[1].buf[0];
> > +	} else {
> > +		rc =3D i2c_transfer(priv->i2c_adap, msg, size);
> > +	}
> >=20
> >  	if (fe->ops.i2c_gate_ctrl)
> >  =09
> >  		fe->ops.i2c_gate_ctrl(fe, 0);
>=20
> No. You should be applying such fix at the I2C adapter instead. This is t=
he
> code at the ttusb2 driver:
>=20
> static int ttusb2_i2c_xfer(struct i2c_adapter *adap,struct i2c_msg
> msg[],int num) {
> 	struct dvb_usb_device *d =3D i2c_get_adapdata(adap);
> 	static u8 obuf[60], ibuf[60];
> 	int i,read;
>=20
> 	if (mutex_lock_interruptible(&d->i2c_mutex) < 0)
> 		return -EAGAIN;
>=20
> 	if (num > 2)
> 		warn("more than 2 i2c messages at a time is not handled yet.=20
TODO.");
>=20
> 	for (i =3D 0; i < num; i++) {
> 		read =3D i+1 < num && (msg[i+1].flags & I2C_M_RD);
>=20
> 		obuf[0] =3D (msg[i].addr << 1) | read;
> 		obuf[1] =3D msg[i].len;
>=20
> 		/* read request */
> 		if (read)
> 			obuf[2] =3D msg[i+1].len;
> 		else
> 			obuf[2] =3D 0;
>=20
> 		memcpy(&obuf[3],msg[i].buf,msg[i].len);
>=20
> 		if (ttusb2_msg(d, CMD_I2C_XFER, obuf, msg[i].len+3, ibuf, obuf[2] +=20
3) <
> 0) { err("i2c transfer failed.");
> 			break;
> 		}
>=20
> 		if (read) {
> 			memcpy(msg[i+1].buf,&ibuf[3],msg[i+1].len);
> 			i++;
> 		}
> 	}
>=20
> 	mutex_unlock(&d->i2c_mutex);
> 	return i;
> }
>=20
> Clearly, this routine has issues, as it assumes that all transfers with
> reads will be broken into just two msgs, where the first one is a write,
> and a second one is a read, and that no transfers will be bigger than 2
> messages.
>=20
> It shouldn't be hard to adapt it to handle transfers on either way, and to
> remove the limit of 2 transfers.
>=20
> > @@ -540,7 +555,7 @@
> >=20
> >  		if_freq =3D 5000000;
> >  		break;
> >  =09
> >  	}
> >=20
> > -	tuner_freq =3D params->frequency + if_freq;
> > +	tuner_freq =3D params->frequency;
> >=20
> >  	if (fe->ops.info.type =3D=3D FE_QAM) {
> >  =09
> >  		dprintk("%s select tda827xa_dvbc\n", __func__);
> >=20
> > @@ -554,6 +569,8 @@
> >=20
> >  		i++;
> >  =09
> >  	}
> >=20
> > +	tuner_freq +=3D if_freq;
> > +
> >=20
> >  	N =3D ((tuner_freq + 31250) / 62500) << frequency_map[i].spd;
> >  	buf[0] =3D 0;            // subaddress
> >  	buf[1] =3D N >> 8;
>=20
> This seems to be a bug fix, but you're touching only at the DVB-C. If the
> table lookup should not consider if_freq, the same fix is needed on the
> other similar logics at the driver.
>=20
> Also, please send such patch in separate.
>

Only tested with tda827xa and DVB-T and two limit frecuencies.=20

 Signed-off-by: Jose Alberto Reguero <jareguero@telefonica.net>

Jose Alberto

> > diff -ur linux/drivers/media/common/tuners/tda827x.h
> > linux.new/drivers/media/common/tuners/tda827x.h ---
> > linux/drivers/media/common/tuners/tda827x.h	2010-07-03
> > 23:22:08.000000000 +0200 +++
> > linux.new/drivers/media/common/tuners/tda827x.h	2011-05-21
> > 22:48:31.484340005 +0200 @@ -38,6 +38,8 @@
> >=20
> >  	int 	     switch_addr;
> >  =09
> >  	void (*agcf)(struct dvb_frontend *fe);
> >=20
> > +
> > +	u8 i2cr;
> >=20
> >  };
>=20
> Nack. Fix the transfer routine at the ttusb2 side.
>=20
> > diff -ur linux/drivers/media/dvb/dvb-usb/ttusb2.c
> > linux.new/drivers/media/dvb/dvb-usb/ttusb2.c ---
> > linux/drivers/media/dvb/dvb-usb/ttusb2.c	2011-01-10 16:24:45.000000000
> > +0100 +++ linux.new/drivers/media/dvb/dvb-usb/ttusb2.c	2011-07-05
> > 12:35:51.842182196 +0200 @@ -30,6 +30,7 @@
> >=20
> >  #include "tda826x.h"
> >  #include "tda10086.h"
> >  #include "tda1002x.h"
> >=20
> > +#include "tda10048.h"
> >=20
> >  #include "tda827x.h"
> >  #include "lnbp21.h"
> >=20
> > @@ -44,6 +45,7 @@
> >=20
> >  struct ttusb2_state {
> > =20
> >  	u8 id;
> >  	u16 last_rc_key;
> >=20
> > +	struct dvb_frontend *fe;
> >=20
> >  };
> > =20
> >  static int ttusb2_msg(struct dvb_usb_device *d, u8 cmd,
> >=20
> > @@ -190,6 +190,22 @@
> >=20
> >  	.deltaf =3D 0xa511,
> > =20
> >  };
> >=20
> > +static struct tda10048_config tda10048_config =3D {
> > +	.demod_address    =3D 0x10 >> 1,
> > +	.output_mode      =3D TDA10048_PARALLEL_OUTPUT,
> > +	.inversion        =3D TDA10048_INVERSION_ON,
> > +	.dtv6_if_freq_khz =3D TDA10048_IF_4000,
> > +	.dtv7_if_freq_khz =3D TDA10048_IF_4500,
> > +	.dtv8_if_freq_khz =3D TDA10048_IF_5000,
> > +	.clk_freq_khz     =3D TDA10048_CLK_16000,
> > +	.no_firmware      =3D 1,
> > +};
> > +
> > +static struct tda827x_config tda827x_config =3D {
> > +	.i2cr =3D 1,
> > +	.config =3D 0,
> > +};
> > +
> >=20
> >  static int ttusb2_frontend_tda10086_attach(struct dvb_usb_adapter *ada=
p)
> >  {
> > =20
> >  	if (usb_set_interface(adap->dev->udev,0,3) < 0)
> >=20
> > @@ -205,18 +221,32 @@
> >=20
> >  static int ttusb2_frontend_tda10023_attach(struct dvb_usb_adapter *ada=
p)
> >  {
> >=20
> > +
> > +	struct ttusb2_state *state;
> >=20
> >  	if (usb_set_interface(adap->dev->udev, 0, 3) < 0)
> >  =09
> >  		err("set interface to alts=3D3 failed");
> >=20
> > +	state =3D (struct ttusb2_state *)adap->dev->priv;
> >=20
> >  	if ((adap->fe =3D dvb_attach(tda10023_attach, &tda10023_config,
> >  	&adap->dev->i2c_adap, 0x48)) =3D=3D NULL) {
> >  =09
> >  		deb_info("TDA10023 attach failed\n");
> >  		return -ENODEV;
> >  =09
> >  	}
> >=20
> > +	adap->fe->id =3D 1;
> > +	tda10048_config.fe =3D adap->fe;
> > +	if ((state->fe =3D dvb_attach(tda10048_attach, &tda10048_config,
> > &adap->dev->i2c_adap)) =3D=3D NULL) { +		deb_info("TDA10048 attach
> > failed\n");
> > +		return -ENODEV;
> > +	}
> > +	dvb_register_frontend(&adap->dvb_adap, state->fe);
> > +	if (dvb_attach(tda827x_attach, state->fe, 0x61, &adap->dev->i2c_adap,
> > &tda827x_config) =3D=3D NULL) { +		printk(KERN_ERR "%s: No tda827x
> > found!\n", __func__);
> > +		return -ENODEV;
> > +	}
> >=20
> >  	return 0;
> > =20
> >  }
> > =20
> >  static int ttusb2_tuner_tda827x_attach(struct dvb_usb_adapter *adap)
> >  {
> >=20
> > -	if (dvb_attach(tda827x_attach, adap->fe, 0x61, &adap->dev->i2c_adap,
> > NULL) =3D=3D NULL) { +	if (dvb_attach(tda827x_attach, adap->fe, 0x61,
> > &adap->dev->i2c_adap, &tda827x_config) =3D=3D NULL) {
> >=20
> >  		printk(KERN_ERR "%s: No tda827x found!\n", __func__);
> >  		return -ENODEV;
> >  =09
> >  	}
> >=20
> > @@ -242,6 +272,19 @@
> >=20
> >  static struct dvb_usb_device_properties ttusb2_properties_s2400;
> >  static struct dvb_usb_device_properties ttusb2_properties_ct3650;
> >=20
> > +static void ttusb2_usb_disconnect (struct usb_interface *intf)
> > +{
> > +	struct dvb_usb_device *d =3D usb_get_intfdata (intf);
> > +	struct ttusb2_state * state;
> > +
> > +	state =3D (struct ttusb2_state *)d->priv;
> > +	if (state->fe) {
> > +		dvb_unregister_frontend(state->fe);
> > +		dvb_frontend_detach(state->fe);
> > +	}
> > +	dvb_usb_device_exit (intf);
>=20
> CodingStyle: don't put a space on the above. Please, always check your
> patches with ./script/checkpatch.pl
>=20
> > +}
> > +
> >=20
> >  static int ttusb2_probe(struct usb_interface *intf,
> > =20
> >  		const struct usb_device_id *id)
> > =20
> >  {
> >=20
> > @@ -422,7 +465,7 @@
> >=20
> >  static struct usb_driver ttusb2_driver =3D {
> > =20
> >  	.name		=3D "dvb_usb_ttusb2",
> >  	.probe		=3D ttusb2_probe,
> >=20
> > -	.disconnect =3D dvb_usb_device_exit,
> > +	.disconnect =3D ttusb2_usb_disconnect,
> >=20
> >  	.id_table	=3D ttusb2_table,
> > =20
> >  };
> >=20
> > diff -ur linux/drivers/media/dvb/frontends/Makefile
> > linux.new/drivers/media/dvb/frontends/Makefile ---
> > linux/drivers/media/dvb/frontends/Makefile	2011-05-06 05:45:29.000000000
> > +0200 +++ linux.new/drivers/media/dvb/frontends/Makefile	2011-07-05
> > 01:36:24.621564185 +0200 @@ -4,6 +4,7 @@
> >=20
> >  EXTRA_CFLAGS +=3D -Idrivers/media/dvb/dvb-core/
> >  EXTRA_CFLAGS +=3D -Idrivers/media/common/tuners/
> >=20
> > +EXTRA_CFLAGS +=3D -Idrivers/media/dvb/dvb-usb/
> >=20
> >  stb0899-objs =3D stb0899_drv.o stb0899_algo.o
> >  stv0900-objs =3D stv0900_core.o stv0900_sw.o
> >=20
> > diff -ur linux/drivers/media/dvb/frontends/tda10048.c
> > linux.new/drivers/media/dvb/frontends/tda10048.c ---
> > linux/drivers/media/dvb/frontends/tda10048.c	2010-10-25
> > 01:34:58.000000000 +0200 +++
> > linux.new/drivers/media/dvb/frontends/tda10048.c	2011-07-05
> > 01:57:47.758466025 +0200 @@ -30,6 +30,7 @@
> >=20
> >  #include "dvb_frontend.h"
> >  #include "dvb_math.h"
> >  #include "tda10048.h"
> >=20
> > +#include "dvb-usb.h"
> >=20
> >  #define TDA10048_DEFAULT_FIRMWARE "dvb-fe-tda10048-1.0.fw"
> >  #define TDA10048_DEFAULT_FIRMWARE_SIZE 24878
> >=20
> > @@ -214,6 +215,8 @@
> >=20
> >  	{ TDA10048_CLK_16000, TDA10048_IF_3800,  10, 3, 0 },
> >  	{ TDA10048_CLK_16000, TDA10048_IF_4000,  10, 3, 0 },
> >  	{ TDA10048_CLK_16000, TDA10048_IF_4300,  10, 3, 0 },
> >=20
> > +	{ TDA10048_CLK_16000, TDA10048_IF_4500,   5, 3, 0 },
> > +	{ TDA10048_CLK_16000, TDA10048_IF_5000,   5, 3, 0 },
> >=20
> >  	{ TDA10048_CLK_16000, TDA10048_IF_36130, 10, 3, 0 },
> > =20
> >  };
> >=20
> > @@ -429,6 +432,19 @@
> >=20
> >  	return 0;
> > =20
> >  }
> >=20
> > +static int tda10048_set_pll(struct dvb_frontend *fe)
> > +{
> > +	struct tda10048_state *state =3D fe->demodulator_priv;
> > +
> > +	dprintk(1, "%s()\n", __func__);
> > +
> > +	tda10048_writereg(state, TDA10048_CONF_PLL1, 0x0f);
> > +	tda10048_writereg(state, TDA10048_CONF_PLL2, (u8)(state-
>pll_mfactor));
> > +	tda10048_writereg(state, TDA10048_CONF_PLL3, tda10048_readreg(state,
> > TDA10048_CONF_PLL3) | ((u8)(state->pll_nfactor) | 0x40)); +
> > +	return 0;
> > +}
> > +
> >=20
> >  static int tda10048_set_if(struct dvb_frontend *fe, enum fe_bandwidth
> >  bw) {
> > =20
> >  	struct tda10048_state *state =3D fe->demodulator_priv;
> >=20
> > @@ -478,6 +494,9 @@
> >=20
> >  	dprintk(1, "- pll_nfactor =3D %d\n", state->pll_nfactor);
> >  	dprintk(1, "- pll_pfactor =3D %d\n", state->pll_pfactor);
> >=20
> > +	/* Set the  pll registers */
> > +	tda10048_set_pll(fe);
> > +
> >=20
> >  	/* Calculate the sample frequency */
> >  	state->sample_freq =3D state->xtal_hz * (state->pll_mfactor + 45);
> >  	state->sample_freq /=3D (state->pll_nfactor + 1);
> >=20
> > @@ -710,12 +729,16 @@
> >=20
> >  	if (config->disable_gate_access)
> >  =09
> >  		return 0;
> >=20
> > -	if (enable)
> > -		return tda10048_writereg(state, TDA10048_CONF_C4_1,
> > -			tda10048_readreg(state, TDA10048_CONF_C4_1) | 0x02);
> > -	else
> > -		return tda10048_writereg(state, TDA10048_CONF_C4_1,
> > -			tda10048_readreg(state, TDA10048_CONF_C4_1) & 0xfd);
> > +	if (config->fe && config->fe->ops.i2c_gate_ctrl) {
> > +		return config->fe->ops.i2c_gate_ctrl(config->fe, enable);
> > +	} else {
> > +		if (enable)
> > +			return tda10048_writereg(state, TDA10048_CONF_C4_1,
> > +				tda10048_readreg(state, TDA10048_CONF_C4_1) | 0x02);
> > +		else
> > +			return tda10048_writereg(state, TDA10048_CONF_C4_1,
> > +				tda10048_readreg(state, TDA10048_CONF_C4_1) & 0xfd);
> > +	}
> >=20
> >  }
> > =20
> >  static int tda10048_output_mode(struct dvb_frontend *fe, int serial)
> >=20
> > @@ -772,20 +795,45 @@
> >=20
> >  	return 0;
> > =20
> >  }
> >=20
> > +static int tda10048_sleep(struct dvb_frontend *fe)
> > +{
> > +	struct tda10048_state *state =3D fe->demodulator_priv;
> > +	struct tda10048_config *config =3D &state->config;
> > +	struct dvb_usb_adapter *adap;
> > +
> > +	dprintk(1, "%s()\n", __func__);
> > +
> > +	if (config->fe) {
> > +		adap =3D fe->dvb->priv;
> > +		if (adap->dev->props.power_ctrl)
> > +			adap->dev->props.power_ctrl(adap->dev, 0);
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> >=20
> >  /* Establish sane defaults and load firmware. */
> >  static int tda10048_init(struct dvb_frontend *fe)
> >  {
> > =20
> >  	struct tda10048_state *state =3D fe->demodulator_priv;
> >  	struct tda10048_config *config =3D &state->config;
> >=20
> > +	struct dvb_usb_adapter *adap;
> >=20
> >  	int ret =3D 0, i;
> >  =09
> >  	dprintk(1, "%s()\n", __func__);
> >=20
> > +	if (config->fe) {
> > +		adap =3D fe->dvb->priv;
> > +		if (adap->dev->props.power_ctrl)
> > +			adap->dev->props.power_ctrl(adap->dev, 1);
> > +	}
> > +
> > +
> >=20
> >  	/* Apply register defaults */
> >  	for (i =3D 0; i < ARRAY_SIZE(init_tab); i++)
> >  =09
> >  		tda10048_writereg(state, init_tab[i].reg, init_tab[i].data);
> >=20
> > -	if (state->fwloaded =3D=3D 0)
> > +	if ((state->fwloaded =3D=3D 0) && (!config->no_firmware))
> >=20
> >  		ret =3D tda10048_firmware_upload(fe);
> >  =09
> >  	/* Set either serial or parallel */
> >=20
> > @@ -1174,6 +1222,7 @@
> >=20
> >  	.release =3D tda10048_release,
> >  	.init =3D tda10048_init,
> >=20
> > +	.sleep =3D tda10048_sleep,
> >=20
> >  	.i2c_gate_ctrl =3D tda10048_i2c_gate_ctrl,
> >  	.set_frontend =3D tda10048_set_frontend,
> >  	.get_frontend =3D tda10048_get_frontend,
> >=20
> > diff -ur linux/drivers/media/dvb/frontends/tda10048.h
> > linux.new/drivers/media/dvb/frontends/tda10048.h ---
> > linux/drivers/media/dvb/frontends/tda10048.h	2010-07-03
> > 23:22:08.000000000 +0200 +++
> > linux.new/drivers/media/dvb/frontends/tda10048.h	2011-07-05
> > 02:02:42.775466043 +0200 @@ -51,6 +51,7 @@
> >=20
> >  #define TDA10048_IF_4300  4300
> >  #define TDA10048_IF_4500  4500
> >  #define TDA10048_IF_4750  4750
> >=20
> > +#define TDA10048_IF_5000  5000
> >=20
> >  #define TDA10048_IF_36130 36130
> > =20
> >  	u16 dtv6_if_freq_khz;
> >  	u16 dtv7_if_freq_khz;
> >=20
> > @@ -62,6 +63,10 @@
> >=20
> >  	/* Disable I2C gate access */
> >  	u8 disable_gate_access;
> >=20
> > +
> > +	u8 no_firmware;
> > +
> > +	struct dvb_frontend *fe;
> >=20
> >  };
> > =20
> >  #if defined(CONFIG_DVB_TDA10048) || \
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--Boundary-00=_ngXIOSTtHdJZlCr
Content-Type: text/x-patch;
  charset="UTF-8";
  name="tda727x.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="tda727x.diff"

diff -ur linux/drivers/media/common/tuners/tda827x.c linux.new/drivers/media/common/tuners/tda827x.c
--- linux/drivers/media/common/tuners/tda827x.c	2010-07-03 23:22:08.000000000 +0200
+++ linux.new/drivers/media/common/tuners/tda827x.c	2011-07-16 13:20:40.426284643 +0200
@@ -176,7 +176,7 @@
 		if_freq = 5000000;
 		break;
 	}
-	tuner_freq = params->frequency + if_freq;
+	tuner_freq = params->frequency;
 
 	i = 0;
 	while (tda827x_table[i].lomax < tuner_freq) {
@@ -185,6 +185,8 @@
 		i++;
 	}
 
+	tuner_freq += if_freq;
+
 	N = ((tuner_freq + 125000) / 250000) << (tda827x_table[i].spd + 2);
 	buf[0] = 0;
 	buf[1] = (N>>8) | 0x40;
@@ -540,7 +542,7 @@
 		if_freq = 5000000;
 		break;
 	}
-	tuner_freq = params->frequency + if_freq;
+	tuner_freq = params->frequency;
 
 	if (fe->ops.info.type == FE_QAM) {
 		dprintk("%s select tda827xa_dvbc\n", __func__);
@@ -554,6 +556,8 @@
 		i++;
 	}
 
+	tuner_freq += if_freq;
+
 	N = ((tuner_freq + 31250) / 62500) << frequency_map[i].spd;
 	buf[0] = 0;            // subaddress
 	buf[1] = N >> 8;

--Boundary-00=_ngXIOSTtHdJZlCr--
