Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:45127 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754280AbaKOBH4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Nov 2014 20:07:56 -0500
Date: Fri, 14 Nov 2014 23:07:50 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 4/8] rtl28xxu: add support for Panasonic MN88472 slave
 demod
Message-ID: <20141114230750.05afedf1@recife.lan>
In-Reply-To: <54669373.2060103@iki.fi>
References: <1415766190-24482-1-git-send-email-crope@iki.fi>
	<1415766190-24482-5-git-send-email-crope@iki.fi>
	<20141114173903.7f71c0e1@recife.lan>
	<54669373.2060103@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 15 Nov 2014 01:42:43 +0200
Antti Palosaari <crope@iki.fi> escreveu:

> 
> 
> On 11/14/2014 09:39 PM, Mauro Carvalho Chehab wrote:
> > Em Wed, 12 Nov 2014 06:23:06 +0200
> > Antti Palosaari <crope@iki.fi> escreveu:
> >
> >> There is RTL2832P devices having extra MN88472 demodulator. This
> >> patch add support for such configuration. Logically MN88472 slave
> >> demodulator is connected to RTL2832 master demodulator, both I2C
> >> bus and TS input. RTL2832 is integrated to RTL2832U and RTL2832P
> >> chips. Chip version RTL2832P has extra TS interface for connecting
> >> slave demodulator.
> >>
> >> Signed-off-by: Antti Palosaari <crope@iki.fi>
> >> ---
> >>   drivers/media/usb/dvb-usb-v2/Kconfig    |   1 +
> >>   drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 143 +++++++++++++++++++++++++-------
> >>   drivers/media/usb/dvb-usb-v2/rtl28xxu.h |   5 ++
> >>   3 files changed, 118 insertions(+), 31 deletions(-)
> >>
> >> diff --git a/drivers/media/usb/dvb-usb-v2/Kconfig b/drivers/media/usb/dvb-usb-v2/Kconfig
> >> index 7423033..9050933 100644
> >> --- a/drivers/media/usb/dvb-usb-v2/Kconfig
> >> +++ b/drivers/media/usb/dvb-usb-v2/Kconfig
> >> @@ -130,6 +130,7 @@ config DVB_USB_RTL28XXU
> >>   	select DVB_RTL2830
> >>   	select DVB_RTL2832
> >>   	select DVB_RTL2832_SDR if (MEDIA_SUBDRV_AUTOSELECT && MEDIA_SDR_SUPPORT)
> >> +	select DVB_MN88472 if MEDIA_SUBDRV_AUTOSELECT
> >>   	select MEDIA_TUNER_QT1010 if MEDIA_SUBDRV_AUTOSELECT
> >>   	select MEDIA_TUNER_MT2060 if MEDIA_SUBDRV_AUTOSELECT
> >>   	select MEDIA_TUNER_MXL5005S if MEDIA_SUBDRV_AUTOSELECT
> >
> > This is not a good idea, as the MN88472 is in staging.
> >
> > Select is not recursive, and won't select STAGING. Also, we don't want
> > to enable a staging driver by default on distros.
> 
> I think it should work just fine. It is I2C driver. If distributions 
> disables stating nothing will happen but MN88472 driver is not compiled. 
> When there is no driver load, it will continue with reduced mode using 
> single demod. I tested that scenario where driver was missing. Anyhow, I 
> didn't test case where CONFIG_STAGING Kconfig option was disable, but I 
> will do.

select will just ignore config_staging, enabling this driver even if
staging is disabled.

Perhaps one way to solve would be to do:

select DVB_MN88472 if MEDIA_SUBDRV_AUTOSELECT && STAGING

Still, I the best would be to just remove that line, and add a 
documentation on our wiki (and/or via printk) warning the user to
manually enable the driver on staging, if the user has a device that
needs it.

Regards,
Mauro

PS.: I'll do a deeper look on your comments about patch 2/8 likely
tomorrow or next week.
> 
> regards
> Antti
> 
> 
> >
> >> diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> >> index 5ea52c7..e3c20f4 100644
> >> --- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> >> +++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> >> @@ -24,6 +24,7 @@
> >>
> >>   #include "rtl2830.h"
> >>   #include "rtl2832.h"
> >> +#include "mn88472.h"
> >>
> >>   #include "qt1010.h"
> >>   #include "mt2060.h"
> >> @@ -420,6 +421,7 @@ static int rtl2832u_read_config(struct dvb_usb_device *d)
> >>   	struct rtl28xxu_req req_tda18272 = {0x00c0, CMD_I2C_RD, 2, buf};
> >>   	struct rtl28xxu_req req_r820t = {0x0034, CMD_I2C_RD, 1, buf};
> >>   	struct rtl28xxu_req req_r828d = {0x0074, CMD_I2C_RD, 1, buf};
> >> +	struct rtl28xxu_req req_mn88472 = {0xff38, CMD_I2C_RD, 1, buf};
> >>
> >>   	dev_dbg(&d->udev->dev, "%s:\n", __func__);
> >>
> >> @@ -449,7 +451,7 @@ static int rtl2832u_read_config(struct dvb_usb_device *d)
> >>   	if (ret == 0 && buf[0] == 0xa1) {
> >>   		priv->tuner = TUNER_RTL2832_FC0012;
> >>   		priv->tuner_name = "FC0012";
> >> -		goto found;
> >> +		goto tuner_found;
> >>   	}
> >>
> >>   	/* check FC0013 ID register; reg=00 val=a3 */
> >> @@ -457,7 +459,7 @@ static int rtl2832u_read_config(struct dvb_usb_device *d)
> >>   	if (ret == 0 && buf[0] == 0xa3) {
> >>   		priv->tuner = TUNER_RTL2832_FC0013;
> >>   		priv->tuner_name = "FC0013";
> >> -		goto found;
> >> +		goto tuner_found;
> >>   	}
> >>
> >>   	/* check MT2266 ID register; reg=00 val=85 */
> >> @@ -465,7 +467,7 @@ static int rtl2832u_read_config(struct dvb_usb_device *d)
> >>   	if (ret == 0 && buf[0] == 0x85) {
> >>   		priv->tuner = TUNER_RTL2832_MT2266;
> >>   		priv->tuner_name = "MT2266";
> >> -		goto found;
> >> +		goto tuner_found;
> >>   	}
> >>
> >>   	/* check FC2580 ID register; reg=01 val=56 */
> >> @@ -473,7 +475,7 @@ static int rtl2832u_read_config(struct dvb_usb_device *d)
> >>   	if (ret == 0 && buf[0] == 0x56) {
> >>   		priv->tuner = TUNER_RTL2832_FC2580;
> >>   		priv->tuner_name = "FC2580";
> >> -		goto found;
> >> +		goto tuner_found;
> >>   	}
> >>
> >>   	/* check MT2063 ID register; reg=00 val=9e || 9c */
> >> @@ -481,7 +483,7 @@ static int rtl2832u_read_config(struct dvb_usb_device *d)
> >>   	if (ret == 0 && (buf[0] == 0x9e || buf[0] == 0x9c)) {
> >>   		priv->tuner = TUNER_RTL2832_MT2063;
> >>   		priv->tuner_name = "MT2063";
> >> -		goto found;
> >> +		goto tuner_found;
> >>   	}
> >>
> >>   	/* check MAX3543 ID register; reg=00 val=38 */
> >> @@ -489,7 +491,7 @@ static int rtl2832u_read_config(struct dvb_usb_device *d)
> >>   	if (ret == 0 && buf[0] == 0x38) {
> >>   		priv->tuner = TUNER_RTL2832_MAX3543;
> >>   		priv->tuner_name = "MAX3543";
> >> -		goto found;
> >> +		goto tuner_found;
> >>   	}
> >>
> >>   	/* check TUA9001 ID register; reg=7e val=2328 */
> >> @@ -497,7 +499,7 @@ static int rtl2832u_read_config(struct dvb_usb_device *d)
> >>   	if (ret == 0 && buf[0] == 0x23 && buf[1] == 0x28) {
> >>   		priv->tuner = TUNER_RTL2832_TUA9001;
> >>   		priv->tuner_name = "TUA9001";
> >> -		goto found;
> >> +		goto tuner_found;
> >>   	}
> >>
> >>   	/* check MXL5007R ID register; reg=d9 val=14 */
> >> @@ -505,7 +507,7 @@ static int rtl2832u_read_config(struct dvb_usb_device *d)
> >>   	if (ret == 0 && buf[0] == 0x14) {
> >>   		priv->tuner = TUNER_RTL2832_MXL5007T;
> >>   		priv->tuner_name = "MXL5007T";
> >> -		goto found;
> >> +		goto tuner_found;
> >>   	}
> >>
> >>   	/* check E4000 ID register; reg=02 val=40 */
> >> @@ -513,7 +515,7 @@ static int rtl2832u_read_config(struct dvb_usb_device *d)
> >>   	if (ret == 0 && buf[0] == 0x40) {
> >>   		priv->tuner = TUNER_RTL2832_E4000;
> >>   		priv->tuner_name = "E4000";
> >> -		goto found;
> >> +		goto tuner_found;
> >>   	}
> >>
> >>   	/* check TDA18272 ID register; reg=00 val=c760  */
> >> @@ -521,7 +523,7 @@ static int rtl2832u_read_config(struct dvb_usb_device *d)
> >>   	if (ret == 0 && (buf[0] == 0xc7 || buf[1] == 0x60)) {
> >>   		priv->tuner = TUNER_RTL2832_TDA18272;
> >>   		priv->tuner_name = "TDA18272";
> >> -		goto found;
> >> +		goto tuner_found;
> >>   	}
> >>
> >>   	/* check R820T ID register; reg=00 val=69 */
> >> @@ -529,7 +531,7 @@ static int rtl2832u_read_config(struct dvb_usb_device *d)
> >>   	if (ret == 0 && buf[0] == 0x69) {
> >>   		priv->tuner = TUNER_RTL2832_R820T;
> >>   		priv->tuner_name = "R820T";
> >> -		goto found;
> >> +		goto tuner_found;
> >>   	}
> >>
> >>   	/* check R828D ID register; reg=00 val=69 */
> >> @@ -537,13 +539,37 @@ static int rtl2832u_read_config(struct dvb_usb_device *d)
> >>   	if (ret == 0 && buf[0] == 0x69) {
> >>   		priv->tuner = TUNER_RTL2832_R828D;
> >>   		priv->tuner_name = "R828D";
> >> -		goto found;
> >> +		goto tuner_found;
> >>   	}
> >>
> >> -
> >> -found:
> >> +tuner_found:
> >>   	dev_dbg(&d->udev->dev, "%s: tuner=%s\n", __func__, priv->tuner_name);
> >>
> >> +	/* probe slave demod */
> >> +	if (priv->tuner == TUNER_RTL2832_R828D) {
> >> +		/* power on MN88472 demod on GPIO0 */
> >> +		ret = rtl28xx_wr_reg_mask(d, SYS_GPIO_OUT_VAL, 0x01, 0x01);
> >> +		if (ret)
> >> +			goto err;
> >> +
> >> +		ret = rtl28xx_wr_reg_mask(d, SYS_GPIO_DIR, 0x00, 0x01);
> >> +		if (ret)
> >> +			goto err;
> >> +
> >> +		ret = rtl28xx_wr_reg_mask(d, SYS_GPIO_OUT_EN, 0x01, 0x01);
> >> +		if (ret)
> >> +			goto err;
> >> +
> >> +		/* check MN88472 answers */
> >> +		ret = rtl28xxu_ctrl_msg(d, &req_mn88472);
> >> +		if (ret == 0 && buf[0] == 0x02) {
> >> +			dev_dbg(&d->udev->dev, "%s: MN88472 found\n", __func__);
> >> +			priv->slave_demod = SLAVE_DEMOD_MN88472;
> >> +			goto demod_found;
> >> +		}
> >> +	}
> >> +
> >> +demod_found:
> >>   	/* close demod I2C gate */
> >>   	ret = rtl28xxu_ctrl_msg(d, &req_gate_close);
> >>   	if (ret < 0)
> >> @@ -768,6 +794,18 @@ static int rtl2832u_frontend_callback(void *adapter_priv, int component,
> >>   	return 0;
> >>   }
> >>
> >> +/* FIXME: this is a bit hackish solution */
> >> +/* slave demod TS output is connected to master demod TS input */
> >> +static int rtl28xxu_mn88472_init(struct dvb_frontend *fe)
> >> +{
> >> +	struct dvb_usb_adapter *adap = fe_to_adap(fe);
> >> +	struct rtl28xxu_priv *priv = fe_to_priv(fe);
> >> +	/* enable RTL2832 PIP mode */
> >> +	adap->fe[0]->dtv_property_cache.frequency = 0;
> >> +	adap->fe[0]->ops.set_frontend(adap->fe[0]);
> >> +	return priv->init(fe);
> >> +}
> >> +
> >>   static int rtl2832u_frontend_attach(struct dvb_usb_adapter *adap)
> >>   {
> >>   	int ret;
> >> @@ -818,7 +856,48 @@ static int rtl2832u_frontend_attach(struct dvb_usb_adapter *adap)
> >>   	/* set fe callback */
> >>   	adap->fe[0]->callback = rtl2832u_frontend_callback;
> >>
> >> +	if (priv->slave_demod) {
> >> +		struct i2c_board_info info = {};
> >> +		struct i2c_client *client;
> >> +
> >> +		/*
> >> +		 * We continue on reduced mode, without DVB-T2/C, using master
> >> +		 * demod, when slave demod fails.
> >> +		 */
> >> +		ret = 0;
> >> +
> >> +		/* attach slave demodulator */
> >> +		if (priv->slave_demod == SLAVE_DEMOD_MN88472) {
> >> +			struct mn88472_config mn88472_config = {};
> >> +
> >> +			mn88472_config.fe = &adap->fe[1];
> >> +			mn88472_config.i2c_wr_max = 22,
> >> +			strlcpy(info.type, "mn88472", I2C_NAME_SIZE);
> >> +			info.addr = 0x18;
> >> +			info.platform_data = &mn88472_config;
> >> +			request_module(info.type);
> >> +			client = i2c_new_device(priv->demod_i2c_adapter, &info);
> >> +			if (client == NULL || client->dev.driver == NULL) {
> >> +				priv->slave_demod = SLAVE_DEMOD_NONE;
> >> +				goto err_slave_demod_failed;
> >> +			}
> >> +
> >> +			if (!try_module_get(client->dev.driver->owner)) {
> >> +				i2c_unregister_device(client);
> >> +				priv->slave_demod = SLAVE_DEMOD_NONE;
> >> +				goto err_slave_demod_failed;
> >> +			}
> >> +
> >> +			priv->i2c_client_slave_demod = client;
> >> +		}
> >> +
> >> +		/* override init as we want configure RTL2832 as TS input */
> >> +		priv->init = adap->fe[1]->ops.init;
> >> +		adap->fe[1]->ops.init = rtl28xxu_mn88472_init;
> >> +	}
> >> +
> >>   	return 0;
> >> +err_slave_demod_failed:
> >>   err:
> >>   	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
> >>   	return ret;
> >> @@ -1024,25 +1103,19 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
> >>   				&rtl28xxu_rtl2832_r820t_config, NULL);
> >>   		break;
> >>   	case TUNER_RTL2832_R828D:
> >> -		/* power off mn88472 demod on GPIO0 */
> >> -		ret = rtl28xx_wr_reg_mask(d, SYS_GPIO_OUT_VAL, 0x00, 0x01);
> >> -		if (ret)
> >> -			goto err;
> >> -
> >> -		ret = rtl28xx_wr_reg_mask(d, SYS_GPIO_DIR, 0x00, 0x01);
> >> -		if (ret)
> >> -			goto err;
> >> -
> >> -		ret = rtl28xx_wr_reg_mask(d, SYS_GPIO_OUT_EN, 0x01, 0x01);
> >> -		if (ret)
> >> -			goto err;
> >> -
> >> -		fe = dvb_attach(r820t_attach, adap->fe[0], &d->i2c_adap,
> >> +		fe = dvb_attach(r820t_attach, adap->fe[0],
> >> +				priv->demod_i2c_adapter,
> >>   				&rtl2832u_r828d_config);
> >> -
> >> -		/* Use tuner to get the signal strength */
> >>   		adap->fe[0]->ops.read_signal_strength =
> >>   				adap->fe[0]->ops.tuner_ops.get_rf_strength;
> >> +
> >> +		if (adap->fe[1]) {
> >> +			fe = dvb_attach(r820t_attach, adap->fe[1],
> >> +					priv->demod_i2c_adapter,
> >> +					&rtl2832u_r828d_config);
> >> +			adap->fe[1]->ops.read_signal_strength =
> >> +					adap->fe[1]->ops.tuner_ops.get_rf_strength;
> >> +		}
> >>   		break;
> >>   	default:
> >>   		dev_err(&d->udev->dev, "%s: unknown tuner=%d\n", KBUILD_MODNAME,
> >> @@ -1097,11 +1170,19 @@ err:
> >>   static void rtl28xxu_exit(struct dvb_usb_device *d)
> >>   {
> >>   	struct rtl28xxu_priv *priv = d->priv;
> >> -	struct i2c_client *client = priv->client;
> >> +	struct i2c_client *client;
> >>
> >>   	dev_dbg(&d->udev->dev, "%s:\n", __func__);
> >>
> >>   	/* remove I2C tuner */
> >> +	client = priv->client;
> >> +	if (client) {
> >> +		module_put(client->dev.driver->owner);
> >> +		i2c_unregister_device(client);
> >> +	}
> >> +
> >> +	/* remove I2C slave demod */
> >> +	client = priv->i2c_client_slave_demod;
> >>   	if (client) {
> >>   		module_put(client->dev.driver->owner);
> >>   		i2c_unregister_device(client);
> >> diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.h b/drivers/media/usb/dvb-usb-v2/rtl28xxu.h
> >> index a26cab1..58f2730 100644
> >> --- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.h
> >> +++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.h
> >> @@ -58,6 +58,11 @@ struct rtl28xxu_priv {
> >>   	struct i2c_adapter *demod_i2c_adapter;
> >>   	bool rc_active;
> >>   	struct i2c_client *client;
> >> +	struct i2c_client *i2c_client_slave_demod;
> >> +	int (*init)(struct dvb_frontend *fe);
> >> +	#define SLAVE_DEMOD_NONE           0
> >> +	#define SLAVE_DEMOD_MN88472        1
> >> +	unsigned int slave_demod:1;
> >>   };
> >>
> >>   enum rtl28xxu_chip_id {
> 
