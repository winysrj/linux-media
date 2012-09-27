Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35128 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751645Ab2I0KfU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Sep 2012 06:35:20 -0400
Date: Thu, 27 Sep 2012 07:35:09 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 4/7] rtl28xxu: move tuner probing to .read_config()
Message-ID: <20120927073509.6879dd57@redhat.com>
In-Reply-To: <1347915492-24924-4-git-send-email-crope@iki.fi>
References: <1347915492-24924-1-git-send-email-crope@iki.fi>
	<1347915492-24924-4-git-send-email-crope@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 17 Sep 2012 23:58:09 +0300
Antti Palosaari <crope@iki.fi> escreveu:

> Move rtl2831u tuner probing correct place.


Huh? Patch 1/7 has exactly the same subject and description...

what's the difference between them?

> 
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> ---
>  drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 175 ++++++++++++++++++--------------
>  1 file changed, 99 insertions(+), 76 deletions(-)
> 
> diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> index 1f18244..6bd7a07 100644
> --- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> +++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> @@ -274,6 +274,87 @@ static struct i2c_algorithm rtl28xxu_i2c_algo = {
>  	.functionality = rtl28xxu_i2c_func,
>  };
>  
> +static int rtl2831u_read_config(struct dvb_usb_device *d)
> +{
> +	struct rtl28xxu_priv *priv = d_to_priv(d);
> +	int ret;
> +	u8 buf[1];
> +	/* open RTL2831U/RTL2830 I2C gate */
> +	struct rtl28xxu_req req_gate_open = {0x0120, 0x0011, 0x0001, "\x08"};
> +	/* tuner probes */
> +	struct rtl28xxu_req req_mt2060 = {0x00c0, CMD_I2C_RD, 1, buf};
> +	struct rtl28xxu_req req_qt1010 = {0x0fc4, CMD_I2C_RD, 1, buf};
> +
> +	dev_dbg(&d->udev->dev, "%s:\n", __func__);
> +
> +	/*
> +	 * RTL2831U GPIOs
> +	 * =========================================================
> +	 * GPIO0 | tuner#0 | 0 off | 1 on  | MXL5005S (?)
> +	 * GPIO2 | LED     | 0 off | 1 on  |
> +	 * GPIO4 | tuner#1 | 0 on  | 1 off | MT2060
> +	 */
> +
> +	/* GPIO direction */
> +	ret = rtl28xx_wr_reg(d, SYS_GPIO_DIR, 0x0a);
> +	if (ret)
> +		goto err;
> +
> +	/* enable as output GPIO0, GPIO2, GPIO4 */
> +	ret = rtl28xx_wr_reg(d, SYS_GPIO_OUT_EN, 0x15);
> +	if (ret)
> +		goto err;
> +
> +	/*
> +	 * Probe used tuner. We need to know used tuner before demod attach
> +	 * since there is some demod params needed to set according to tuner.
> +	 */
> +
> +	/* demod needs some time to wake up */
> +	msleep(20);
> +
> +	priv->tuner_name = "NONE";
> +
> +	/* open demod I2C gate */
> +	ret = rtl28xxu_ctrl_msg(d, &req_gate_open);
> +	if (ret)
> +		goto err;
> +
> +	/* check QT1010 ID(?) register; reg=0f val=2c */
> +	ret = rtl28xxu_ctrl_msg(d, &req_qt1010);
> +	if (ret == 0 && buf[0] == 0x2c) {
> +		priv->tuner = TUNER_RTL2830_QT1010;
> +		priv->tuner_name = "QT1010";
> +		goto found;
> +	}
> +
> +	/* open demod I2C gate */
> +	ret = rtl28xxu_ctrl_msg(d, &req_gate_open);
> +	if (ret)
> +		goto err;
> +
> +	/* check MT2060 ID register; reg=00 val=63 */
> +	ret = rtl28xxu_ctrl_msg(d, &req_mt2060);
> +	if (ret == 0 && buf[0] == 0x63) {
> +		priv->tuner = TUNER_RTL2830_MT2060;
> +		priv->tuner_name = "MT2060";
> +		goto found;
> +	}
> +
> +	/* assume MXL5005S */
> +	priv->tuner = TUNER_RTL2830_MXL5005S;
> +	priv->tuner_name = "MXL5005S";
> +	goto found;
> +
> +found:
> +	dev_dbg(&d->udev->dev, "%s: tuner=%s\n", __func__, priv->tuner_name);
> +
> +	return 0;
> +err:
> +	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
> +	return ret;
> +}
> +
>  static int rtl2832u_read_config(struct dvb_usb_device *d)
>  {
>  	struct rtl28xxu_priv *priv = d_to_priv(d);
> @@ -445,97 +526,38 @@ static struct rtl2830_config rtl28xxu_rtl2830_mxl5005s_config = {
>  
>  static int rtl2831u_frontend_attach(struct dvb_usb_adapter *adap)
>  {
> -	int ret;
>  	struct dvb_usb_device *d = adap_to_d(adap);
>  	struct rtl28xxu_priv *priv = d_to_priv(d);
> -	u8 buf[1];
>  	struct rtl2830_config *rtl2830_config;
> -	/* open RTL2831U/RTL2830 I2C gate */
> -	struct rtl28xxu_req req_gate = { 0x0120, 0x0011, 0x0001, "\x08" };
> -	/* for MT2060 tuner probe */
> -	struct rtl28xxu_req req_mt2060 = { 0x00c0, CMD_I2C_RD, 1, buf };
> -	/* for QT1010 tuner probe */
> -	struct rtl28xxu_req req_qt1010 = { 0x0fc4, CMD_I2C_RD, 1, buf };
> +	int ret;
>  
>  	dev_dbg(&d->udev->dev, "%s:\n", __func__);
>  
> -	/*
> -	 * RTL2831U GPIOs
> -	 * =========================================================
> -	 * GPIO0 | tuner#0 | 0 off | 1 on  | MXL5005S (?)
> -	 * GPIO2 | LED     | 0 off | 1 on  |
> -	 * GPIO4 | tuner#1 | 0 on  | 1 off | MT2060
> -	 */
> -
> -	/* GPIO direction */
> -	ret = rtl28xx_wr_reg(d, SYS_GPIO_DIR, 0x0a);
> -	if (ret)
> -		goto err;
> -
> -	/* enable as output GPIO0, GPIO2, GPIO4 */
> -	ret = rtl28xx_wr_reg(d, SYS_GPIO_OUT_EN, 0x15);
> -	if (ret)
> -		goto err;
> -
> -	/*
> -	 * Probe used tuner. We need to know used tuner before demod attach
> -	 * since there is some demod params needed to set according to tuner.
> -	 */
> -
> -	/* demod needs some time to wake up */
> -	msleep(20);
> -
> -	/* open demod I2C gate */
> -	ret = rtl28xxu_ctrl_msg(d, &req_gate);
> -	if (ret)
> -		goto err;
> -
> -	/* check QT1010 ID(?) register; reg=0f val=2c */
> -	ret = rtl28xxu_ctrl_msg(d, &req_qt1010);
> -	if (ret == 0 && buf[0] == 0x2c) {
> -		priv->tuner = TUNER_RTL2830_QT1010;
> +	switch (priv->tuner) {
> +	case TUNER_RTL2830_QT1010:
>  		rtl2830_config = &rtl28xxu_rtl2830_qt1010_config;
> -		dev_dbg(&d->udev->dev, "%s: QT1010\n", __func__);
> -		goto found;
> -	} else {
> -		dev_dbg(&d->udev->dev, "%s: QT1010 probe failed=%d - %02x\n",
> -				__func__, ret, buf[0]);
> -	}
> -
> -	/* open demod I2C gate */
> -	ret = rtl28xxu_ctrl_msg(d, &req_gate);
> -	if (ret)
> -		goto err;
> -
> -	/* check MT2060 ID register; reg=00 val=63 */
> -	ret = rtl28xxu_ctrl_msg(d, &req_mt2060);
> -	if (ret == 0 && buf[0] == 0x63) {
> -		priv->tuner = TUNER_RTL2830_MT2060;
> +		break;
> +	case TUNER_RTL2830_MT2060:
>  		rtl2830_config = &rtl28xxu_rtl2830_mt2060_config;
> -		dev_dbg(&d->udev->dev, "%s: MT2060\n", __func__);
> -		goto found;
> -	} else {
> -		dev_dbg(&d->udev->dev, "%s: MT2060 probe failed=%d - %02x\n",
> -				__func__, ret, buf[0]);
> +		break;
> +	case TUNER_RTL2830_MXL5005S:
> +		rtl2830_config = &rtl28xxu_rtl2830_mxl5005s_config;
> +		break;
> +	default:
> +		dev_err(&d->udev->dev, "%s: unknown tuner=%s\n",
> +				KBUILD_MODNAME, priv->tuner_name);
> +		ret = -ENODEV;
> +		goto err;
>  	}
>  
> -	/* assume MXL5005S */
> -	ret = 0;
> -	priv->tuner = TUNER_RTL2830_MXL5005S;
> -	rtl2830_config = &rtl28xxu_rtl2830_mxl5005s_config;
> -	dev_dbg(&d->udev->dev, "%s: MXL5005S\n", __func__);
> -	goto found;
> -
> -found:
>  	/* attach demodulator */
> -	adap->fe[0] = dvb_attach(rtl2830_attach, rtl2830_config,
> -		&d->i2c_adap);
> -	if (adap->fe[0] == NULL) {
> +	adap->fe[0] = dvb_attach(rtl2830_attach, rtl2830_config, &d->i2c_adap);
> +	if (!adap->fe[0]) {
>  		ret = -ENODEV;
>  		goto err;
>  	}
>  
> -	return ret;
> +	return 0;
>  err:
>  	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
>  	return ret;
> @@ -1264,6 +1286,7 @@ static const struct dvb_usb_device_properties rtl2831u_props = {
>  
>  	.power_ctrl = rtl2831u_power_ctrl,
>  	.i2c_algo = &rtl28xxu_i2c_algo,
> +	.read_config = rtl2831u_read_config,
>  	.frontend_attach = rtl2831u_frontend_attach,
>  	.tuner_attach = rtl2831u_tuner_attach,
>  	.init = rtl28xxu_init,


-- 
Regards,
Mauro
