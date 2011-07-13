Return-path: <mchehab@localhost>
Received: from mx1.redhat.com ([209.132.183.28]:45163 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751635Ab1GMMlj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jul 2011 08:41:39 -0400
Message-ID: <4E1D927A.5090006@redhat.com>
Date: Wed, 13 Jul 2011 09:41:30 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jose Alberto Reguero <jareguero@telefonica.net>
CC: linux-media@vger.kernel.org,
	Michael Krufky <mkrufky@kernellabs.com>
Subject: Re: [PATCH] add support for the dvb-t part of CT-3650 v2
References: <201106070205.08118.jareguero@telefonica.net> <201107070057.06317.jareguero@telefonica.net>
In-Reply-To: <201107070057.06317.jareguero@telefonica.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

Em 06-07-2011 19:57, Jose Alberto Reguero escreveu:
> This patch add suport for the dvb-t part of CT-3650.
> 
> Jose Alberto
> 
> Signed-off-by: Jose Alberto Reguero <jareguero@telefonica.net>

> patches/lmml_951522_add_support_for_the_dvb_t_part_of_ct_3650_v2.patch
> Content-Type: text/plain; charset="utf-8"
> MIME-Version: 1.0
> Content-Transfer-Encoding: 7bit
> Subject: add support for the dvb-t part of CT-3650 v2
> Date: Wed, 06 Jul 2011 22:57:04 -0000
> From: Jose Alberto Reguero <jareguero@telefonica.net>
> X-Patchwork-Id: 951522
> Message-Id: <201107070057.06317.jareguero@telefonica.net>
> To: linux-media@vger.kernel.org
> 
> This patch add suport for the dvb-t part of CT-3650.
> 
> Jose Alberto
> 
> Signed-off-by: Jose Alberto Reguero <jareguero@telefonica.net>
> 
> 
> diff -ur linux/drivers/media/common/tuners/tda827x.c linux.new/drivers/media/common/tuners/tda827x.c
> --- linux/drivers/media/common/tuners/tda827x.c	2010-07-03 23:22:08.000000000 +0200
> +++ linux.new/drivers/media/common/tuners/tda827x.c	2011-07-04 12:00:29.931561053 +0200
> @@ -135,14 +135,29 @@
>  
>  static int tuner_transfer(struct dvb_frontend *fe,
>  			  struct i2c_msg *msg,
> -			  const int size)
> +			  int size)
>  {
>  	int rc;
>  	struct tda827x_priv *priv = fe->tuner_priv;
> +	struct i2c_msg msgr[2];
>  
>  	if (fe->ops.i2c_gate_ctrl)
>  		fe->ops.i2c_gate_ctrl(fe, 1);
> -	rc = i2c_transfer(priv->i2c_adap, msg, size);
> +	if (priv->cfg->i2cr && (msg->flags == I2C_M_RD)) {
> +		msgr[0].addr = msg->addr;
> +		msgr[0].flags = 0;
> +		msgr[0].len = msg->len - 1;
> +		msgr[0].buf = msg->buf;
> +		msgr[1].addr = msg->addr;
> +		msgr[1].flags = I2C_M_RD;
> +		msgr[1].len = 1;
> +		msgr[1].buf = msg->buf;
> +		size = 2;
> +		rc = i2c_transfer(priv->i2c_adap, msgr, size);
> +		msg->buf[msg->len - 1] = msgr[1].buf[0];
> +	} else {
> +		rc = i2c_transfer(priv->i2c_adap, msg, size);
> +	}
>  	if (fe->ops.i2c_gate_ctrl)
>  		fe->ops.i2c_gate_ctrl(fe, 0);

No. You should be applying such fix at the I2C adapter instead. This is the
code at the ttusb2 driver:

static int ttusb2_i2c_xfer(struct i2c_adapter *adap,struct i2c_msg msg[],int num)
{
	struct dvb_usb_device *d = i2c_get_adapdata(adap);
	static u8 obuf[60], ibuf[60];
	int i,read;

	if (mutex_lock_interruptible(&d->i2c_mutex) < 0)
		return -EAGAIN;

	if (num > 2)
		warn("more than 2 i2c messages at a time is not handled yet. TODO.");

	for (i = 0; i < num; i++) {
		read = i+1 < num && (msg[i+1].flags & I2C_M_RD);

		obuf[0] = (msg[i].addr << 1) | read;
		obuf[1] = msg[i].len;

		/* read request */
		if (read)
			obuf[2] = msg[i+1].len;
		else
			obuf[2] = 0;

		memcpy(&obuf[3],msg[i].buf,msg[i].len);

		if (ttusb2_msg(d, CMD_I2C_XFER, obuf, msg[i].len+3, ibuf, obuf[2] + 3) < 0) {
			err("i2c transfer failed.");
			break;
		}

		if (read) {
			memcpy(msg[i+1].buf,&ibuf[3],msg[i+1].len);
			i++;
		}
	}

	mutex_unlock(&d->i2c_mutex);
	return i;
}

Clearly, this routine has issues, as it assumes that all transfers with reads will 
be broken into just two msgs, where the first one is a write, and a second one is a
read, and that no transfers will be bigger than 2 messages.

It shouldn't be hard to adapt it to handle transfers on either way, and to remove
the limit of 2 transfers.


>  
> @@ -540,7 +555,7 @@
>  		if_freq = 5000000;
>  		break;
>  	}
> -	tuner_freq = params->frequency + if_freq;
> +	tuner_freq = params->frequency;
>  
>  	if (fe->ops.info.type == FE_QAM) {
>  		dprintk("%s select tda827xa_dvbc\n", __func__);
> @@ -554,6 +569,8 @@
>  		i++;
>  	}
>  
> +	tuner_freq += if_freq;
> +
>  	N = ((tuner_freq + 31250) / 62500) << frequency_map[i].spd;
>  	buf[0] = 0;            // subaddress
>  	buf[1] = N >> 8;

This seems to be a bug fix, but you're touching only at the DVB-C. If the table lookup
should not consider if_freq, the same fix is needed on the other similar logics at the
driver.

Also, please send such patch in separate.


> diff -ur linux/drivers/media/common/tuners/tda827x.h linux.new/drivers/media/common/tuners/tda827x.h
> --- linux/drivers/media/common/tuners/tda827x.h	2010-07-03 23:22:08.000000000 +0200
> +++ linux.new/drivers/media/common/tuners/tda827x.h	2011-05-21 22:48:31.484340005 +0200
> @@ -38,6 +38,8 @@
>  	int 	     switch_addr;
>  
>  	void (*agcf)(struct dvb_frontend *fe);
> +
> +	u8 i2cr;
>  };

Nack. Fix the transfer routine at the ttusb2 side.

 
> diff -ur linux/drivers/media/dvb/dvb-usb/ttusb2.c linux.new/drivers/media/dvb/dvb-usb/ttusb2.c
> --- linux/drivers/media/dvb/dvb-usb/ttusb2.c	2011-01-10 16:24:45.000000000 +0100
> +++ linux.new/drivers/media/dvb/dvb-usb/ttusb2.c	2011-07-05 12:35:51.842182196 +0200
> @@ -30,6 +30,7 @@
>  #include "tda826x.h"
>  #include "tda10086.h"
>  #include "tda1002x.h"
> +#include "tda10048.h"
>  #include "tda827x.h"
>  #include "lnbp21.h"
>  
> @@ -44,6 +45,7 @@
>  struct ttusb2_state {
>  	u8 id;
>  	u16 last_rc_key;
> +	struct dvb_frontend *fe;
>  };
>  
>  static int ttusb2_msg(struct dvb_usb_device *d, u8 cmd,
> @@ -190,6 +190,22 @@
>  	.deltaf = 0xa511,
>  };
>  
> +static struct tda10048_config tda10048_config = {
> +	.demod_address    = 0x10 >> 1,
> +	.output_mode      = TDA10048_PARALLEL_OUTPUT,
> +	.inversion        = TDA10048_INVERSION_ON,
> +	.dtv6_if_freq_khz = TDA10048_IF_4000,
> +	.dtv7_if_freq_khz = TDA10048_IF_4500,
> +	.dtv8_if_freq_khz = TDA10048_IF_5000,
> +	.clk_freq_khz     = TDA10048_CLK_16000,
> +	.no_firmware      = 1,
> +};
> +
> +static struct tda827x_config tda827x_config = {
> +	.i2cr = 1,
> +	.config = 0,
> +};
> +
>  static int ttusb2_frontend_tda10086_attach(struct dvb_usb_adapter *adap)
>  {
>  	if (usb_set_interface(adap->dev->udev,0,3) < 0)
> @@ -205,18 +221,32 @@
>  
>  static int ttusb2_frontend_tda10023_attach(struct dvb_usb_adapter *adap)
>  {
> +
> +	struct ttusb2_state *state;
>  	if (usb_set_interface(adap->dev->udev, 0, 3) < 0)
>  		err("set interface to alts=3 failed");
> +	state = (struct ttusb2_state *)adap->dev->priv;
>  	if ((adap->fe = dvb_attach(tda10023_attach, &tda10023_config, &adap->dev->i2c_adap, 0x48)) == NULL) {
>  		deb_info("TDA10023 attach failed\n");
>  		return -ENODEV;
>  	}
> +	adap->fe->id = 1;
> +	tda10048_config.fe = adap->fe;
> +	if ((state->fe = dvb_attach(tda10048_attach, &tda10048_config, &adap->dev->i2c_adap)) == NULL) {
> +		deb_info("TDA10048 attach failed\n");
> +		return -ENODEV;
> +	}
> +	dvb_register_frontend(&adap->dvb_adap, state->fe);
> +	if (dvb_attach(tda827x_attach, state->fe, 0x61, &adap->dev->i2c_adap, &tda827x_config) == NULL) {
> +		printk(KERN_ERR "%s: No tda827x found!\n", __func__);
> +		return -ENODEV;
> +	}
>  	return 0;
>  }
>  
>  static int ttusb2_tuner_tda827x_attach(struct dvb_usb_adapter *adap)
>  {
> -	if (dvb_attach(tda827x_attach, adap->fe, 0x61, &adap->dev->i2c_adap, NULL) == NULL) {
> +	if (dvb_attach(tda827x_attach, adap->fe, 0x61, &adap->dev->i2c_adap, &tda827x_config) == NULL) {
>  		printk(KERN_ERR "%s: No tda827x found!\n", __func__);
>  		return -ENODEV;
>  	}
> @@ -242,6 +272,19 @@
>  static struct dvb_usb_device_properties ttusb2_properties_s2400;
>  static struct dvb_usb_device_properties ttusb2_properties_ct3650;
>  
> +static void ttusb2_usb_disconnect (struct usb_interface *intf)
> +{
> +	struct dvb_usb_device *d = usb_get_intfdata (intf);
> +	struct ttusb2_state * state;
> +
> +	state = (struct ttusb2_state *)d->priv;
> +	if (state->fe) {
> +		dvb_unregister_frontend(state->fe);
> +		dvb_frontend_detach(state->fe);
> +	}
> +	dvb_usb_device_exit (intf);

CodingStyle: don't put a space on the above. Please, always check your patches
with ./script/checkpatch.pl

> +}
> +
>  static int ttusb2_probe(struct usb_interface *intf,
>  		const struct usb_device_id *id)
>  {
> @@ -422,7 +465,7 @@
>  static struct usb_driver ttusb2_driver = {
>  	.name		= "dvb_usb_ttusb2",
>  	.probe		= ttusb2_probe,
> -	.disconnect = dvb_usb_device_exit,
> +	.disconnect = ttusb2_usb_disconnect,
>  	.id_table	= ttusb2_table,
>  };
>  
> diff -ur linux/drivers/media/dvb/frontends/Makefile linux.new/drivers/media/dvb/frontends/Makefile
> --- linux/drivers/media/dvb/frontends/Makefile	2011-05-06 05:45:29.000000000 +0200
> +++ linux.new/drivers/media/dvb/frontends/Makefile	2011-07-05 01:36:24.621564185 +0200
> @@ -4,6 +4,7 @@
>  
>  EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core/
>  EXTRA_CFLAGS += -Idrivers/media/common/tuners/
> +EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-usb/
>  
>  stb0899-objs = stb0899_drv.o stb0899_algo.o
>  stv0900-objs = stv0900_core.o stv0900_sw.o
> diff -ur linux/drivers/media/dvb/frontends/tda10048.c linux.new/drivers/media/dvb/frontends/tda10048.c
> --- linux/drivers/media/dvb/frontends/tda10048.c	2010-10-25 01:34:58.000000000 +0200
> +++ linux.new/drivers/media/dvb/frontends/tda10048.c	2011-07-05 01:57:47.758466025 +0200
> @@ -30,6 +30,7 @@
>  #include "dvb_frontend.h"
>  #include "dvb_math.h"
>  #include "tda10048.h"
> +#include "dvb-usb.h"
>  
>  #define TDA10048_DEFAULT_FIRMWARE "dvb-fe-tda10048-1.0.fw"
>  #define TDA10048_DEFAULT_FIRMWARE_SIZE 24878
> @@ -214,6 +215,8 @@
>  	{ TDA10048_CLK_16000, TDA10048_IF_3800,  10, 3, 0 },
>  	{ TDA10048_CLK_16000, TDA10048_IF_4000,  10, 3, 0 },
>  	{ TDA10048_CLK_16000, TDA10048_IF_4300,  10, 3, 0 },
> +	{ TDA10048_CLK_16000, TDA10048_IF_4500,   5, 3, 0 },
> +	{ TDA10048_CLK_16000, TDA10048_IF_5000,   5, 3, 0 },
>  	{ TDA10048_CLK_16000, TDA10048_IF_36130, 10, 3, 0 },
>  };
>  
> @@ -429,6 +432,19 @@
>  	return 0;
>  }
>  
> +static int tda10048_set_pll(struct dvb_frontend *fe)
> +{
> +	struct tda10048_state *state = fe->demodulator_priv;
> +
> +	dprintk(1, "%s()\n", __func__);
> +
> +	tda10048_writereg(state, TDA10048_CONF_PLL1, 0x0f);
> +	tda10048_writereg(state, TDA10048_CONF_PLL2, (u8)(state->pll_mfactor));
> +	tda10048_writereg(state, TDA10048_CONF_PLL3, tda10048_readreg(state, TDA10048_CONF_PLL3) | ((u8)(state->pll_nfactor) | 0x40));
> +
> +	return 0;
> +}
> +
>  static int tda10048_set_if(struct dvb_frontend *fe, enum fe_bandwidth bw)
>  {
>  	struct tda10048_state *state = fe->demodulator_priv;
> @@ -478,6 +494,9 @@
>  	dprintk(1, "- pll_nfactor = %d\n", state->pll_nfactor);
>  	dprintk(1, "- pll_pfactor = %d\n", state->pll_pfactor);
>  
> +	/* Set the  pll registers */
> +	tda10048_set_pll(fe);
> +
>  	/* Calculate the sample frequency */
>  	state->sample_freq = state->xtal_hz * (state->pll_mfactor + 45);
>  	state->sample_freq /= (state->pll_nfactor + 1);
> @@ -710,12 +729,16 @@
>  	if (config->disable_gate_access)
>  		return 0;
>  
> -	if (enable)
> -		return tda10048_writereg(state, TDA10048_CONF_C4_1,
> -			tda10048_readreg(state, TDA10048_CONF_C4_1) | 0x02);
> -	else
> -		return tda10048_writereg(state, TDA10048_CONF_C4_1,
> -			tda10048_readreg(state, TDA10048_CONF_C4_1) & 0xfd);
> +	if (config->fe && config->fe->ops.i2c_gate_ctrl) {
> +		return config->fe->ops.i2c_gate_ctrl(config->fe, enable);
> +	} else {
> +		if (enable)
> +			return tda10048_writereg(state, TDA10048_CONF_C4_1,
> +				tda10048_readreg(state, TDA10048_CONF_C4_1) | 0x02);
> +		else
> +			return tda10048_writereg(state, TDA10048_CONF_C4_1,
> +				tda10048_readreg(state, TDA10048_CONF_C4_1) & 0xfd);
> +	}
>  }
>  
>  static int tda10048_output_mode(struct dvb_frontend *fe, int serial)
> @@ -772,20 +795,45 @@
>  	return 0;
>  }
>  
> +static int tda10048_sleep(struct dvb_frontend *fe)
> +{
> +	struct tda10048_state *state = fe->demodulator_priv;
> +	struct tda10048_config *config = &state->config;
> +	struct dvb_usb_adapter *adap;
> +
> +	dprintk(1, "%s()\n", __func__);
> +
> +	if (config->fe) {
> +		adap = fe->dvb->priv;
> +		if (adap->dev->props.power_ctrl)
> +			adap->dev->props.power_ctrl(adap->dev, 0);
> +	}
> +
> +	return 0;
> +}
> +
>  /* Establish sane defaults and load firmware. */
>  static int tda10048_init(struct dvb_frontend *fe)
>  {
>  	struct tda10048_state *state = fe->demodulator_priv;
>  	struct tda10048_config *config = &state->config;
> +	struct dvb_usb_adapter *adap;
>  	int ret = 0, i;
>  
>  	dprintk(1, "%s()\n", __func__);
>  
> +	if (config->fe) {
> +		adap = fe->dvb->priv;
> +		if (adap->dev->props.power_ctrl)
> +			adap->dev->props.power_ctrl(adap->dev, 1);
> +	}
> +
> +
>  	/* Apply register defaults */
>  	for (i = 0; i < ARRAY_SIZE(init_tab); i++)
>  		tda10048_writereg(state, init_tab[i].reg, init_tab[i].data);
>  
> -	if (state->fwloaded == 0)
> +	if ((state->fwloaded == 0) && (!config->no_firmware))
>  		ret = tda10048_firmware_upload(fe);
>  
>  	/* Set either serial or parallel */
> @@ -1174,6 +1222,7 @@
>  
>  	.release = tda10048_release,
>  	.init = tda10048_init,
> +	.sleep = tda10048_sleep,
>  	.i2c_gate_ctrl = tda10048_i2c_gate_ctrl,
>  	.set_frontend = tda10048_set_frontend,
>  	.get_frontend = tda10048_get_frontend,
> diff -ur linux/drivers/media/dvb/frontends/tda10048.h linux.new/drivers/media/dvb/frontends/tda10048.h
> --- linux/drivers/media/dvb/frontends/tda10048.h	2010-07-03 23:22:08.000000000 +0200
> +++ linux.new/drivers/media/dvb/frontends/tda10048.h	2011-07-05 02:02:42.775466043 +0200
> @@ -51,6 +51,7 @@
>  #define TDA10048_IF_4300  4300
>  #define TDA10048_IF_4500  4500
>  #define TDA10048_IF_4750  4750
> +#define TDA10048_IF_5000  5000
>  #define TDA10048_IF_36130 36130
>  	u16 dtv6_if_freq_khz;
>  	u16 dtv7_if_freq_khz;
> @@ -62,6 +63,10 @@
>  
>  	/* Disable I2C gate access */
>  	u8 disable_gate_access;
> +
> +	u8 no_firmware;
> +
> +	struct dvb_frontend *fe;
>  };
>  
>  #if defined(CONFIG_DVB_TDA10048) || \
> 
