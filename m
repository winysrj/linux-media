Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:29187 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228AbaCMVY6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Mar 2014 17:24:58 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N2E008II8TL5H40@usmailout3.samsung.com> for
 linux-media@vger.kernel.org; Thu, 13 Mar 2014 17:24:57 -0400 (EDT)
Date: Thu, 13 Mar 2014 18:24:51 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH] e4000/rtl2832u_sdr: use V4L2 subdev to pass V4L2 control
 handler
Message-id: <20140313182451.4aa2f7a4@samsung.com>
In-reply-to: <1394743454-18124-2-git-send-email-crope@iki.fi>
References: <1394743454-18124-1-git-send-email-crope@iki.fi>
 <1394743454-18124-2-git-send-email-crope@iki.fi>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 13 Mar 2014 22:44:14 +0200
Antti Palosaari <crope@iki.fi> escreveu:

> Exporting resources using EXPORT_SYMBOL from plain I2C driver is bad
> idea. Use V4L2 subdev instead. Functionality is now quite likely as
> is done in V4L2 API.

Much better!

Thanks!
Mauro

> 
> Reported-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> Cc: Hans Verkuil <hverkuil@xs4all.nl>
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> ---
>  drivers/media/tuners/Kconfig                     |  2 +-
>  drivers/media/tuners/e4000.c                     | 21 ++++++++++++---------
>  drivers/media/tuners/e4000.h                     | 14 --------------
>  drivers/media/tuners/e4000_priv.h                |  2 ++
>  drivers/media/usb/dvb-usb-v2/rtl28xxu.c          | 11 +++++++----
>  drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c |  9 ++++-----
>  drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.h |  7 +++++--
>  7 files changed, 31 insertions(+), 35 deletions(-)
> 
> diff --git a/drivers/media/tuners/Kconfig b/drivers/media/tuners/Kconfig
> index a128488..85c0d96 100644
> --- a/drivers/media/tuners/Kconfig
> +++ b/drivers/media/tuners/Kconfig
> @@ -203,7 +203,7 @@ config MEDIA_TUNER_TDA18212
>  
>  config MEDIA_TUNER_E4000
>  	tristate "Elonics E4000 silicon tuner"
> -	depends on MEDIA_SUPPORT && I2C
> +	depends on MEDIA_SUPPORT && I2C && VIDEO_V4L2
>  	select REGMAP_I2C
>  	default m if !MEDIA_SUBDRV_AUTOSELECT
>  	help
> diff --git a/drivers/media/tuners/e4000.c b/drivers/media/tuners/e4000.c
> index ceed604..650cba0 100644
> --- a/drivers/media/tuners/e4000.c
> +++ b/drivers/media/tuners/e4000.c
> @@ -469,13 +469,10 @@ static const struct dvb_tuner_ops e4000_tuner_ops = {
>  	.get_if_frequency = e4000_get_if_frequency,
>  };
>  
> -struct v4l2_ctrl_handler *e4000_get_ctrl_handler(struct dvb_frontend *fe)
> -{
> -	struct e4000 *s = fe->tuner_priv;
> -	return &s->hdl;
> -}
> -EXPORT_SYMBOL(e4000_get_ctrl_handler);
> -
> +/*
> + * Use V4L2 subdev to carry V4L2 control handler, even we don't implement
> + * subdev itself, just to avoid reinventing the wheel.
> + */
>  static int e4000_probe(struct i2c_client *client,
>  		const struct i2c_device_id *id)
>  {
> @@ -554,6 +551,8 @@ static int e4000_probe(struct i2c_client *client,
>  		goto err;
>  	}
>  
> +	s->sd.ctrl_handler = &s->hdl;
> +
>  	dev_info(&s->client->dev,
>  			"%s: Elonics E4000 successfully identified\n",
>  			KBUILD_MODNAME);
> @@ -561,7 +560,10 @@ static int e4000_probe(struct i2c_client *client,
>  	fe->tuner_priv = s;
>  	memcpy(&fe->ops.tuner_ops, &e4000_tuner_ops,
>  			sizeof(struct dvb_tuner_ops));
> -	i2c_set_clientdata(client, s);
> +
> +	v4l2_set_subdevdata(&s->sd, client);
> +	i2c_set_clientdata(client, &s->sd);
> +
>  err:
>  	if (ret) {
>  		dev_dbg(&client->dev, "%s: failed=%d\n", __func__, ret);
> @@ -573,7 +575,8 @@ err:
>  
>  static int e4000_remove(struct i2c_client *client)
>  {
> -	struct e4000 *s = i2c_get_clientdata(client);
> +	struct v4l2_subdev *sd = i2c_get_clientdata(client);
> +	struct e4000 *s = container_of(sd, struct e4000, sd);
>  	struct dvb_frontend *fe = s->fe;
>  
>  	dev_dbg(&client->dev, "%s:\n", __func__);
> diff --git a/drivers/media/tuners/e4000.h b/drivers/media/tuners/e4000.h
> index 989f2ea..e74b8b2 100644
> --- a/drivers/media/tuners/e4000.h
> +++ b/drivers/media/tuners/e4000.h
> @@ -40,18 +40,4 @@ struct e4000_config {
>  	u32 clock;
>  };
>  
> -#if IS_ENABLED(CONFIG_MEDIA_TUNER_E4000)
> -extern struct v4l2_ctrl_handler *e4000_get_ctrl_handler(
> -		struct dvb_frontend *fe
> -);
> -#else
> -static inline struct v4l2_ctrl_handler *e4000_get_ctrl_handler(
> -		struct dvb_frontend *fe
> -)
> -{
> -	pr_warn("%s: driver disabled by Kconfig\n", __func__);
> -	return NULL;
> -}
> -#endif
> -
>  #endif
> diff --git a/drivers/media/tuners/e4000_priv.h b/drivers/media/tuners/e4000_priv.h
> index ee36de1..cb00704 100644
> --- a/drivers/media/tuners/e4000_priv.h
> +++ b/drivers/media/tuners/e4000_priv.h
> @@ -23,6 +23,7 @@
>  
>  #include "e4000.h"
>  #include <media/v4l2-ctrls.h>
> +#include <media/v4l2-subdev.h>
>  #include <linux/regmap.h>
>  
>  struct e4000 {
> @@ -30,6 +31,7 @@ struct e4000 {
>  	struct regmap *regmap;
>  	u32 clock;
>  	struct dvb_frontend *fe;
> +	struct v4l2_subdev sd;
>  	bool active;
>  
>  	/* Controls */
> diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> index 3474aba..3821fbb 100644
> --- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> +++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
> @@ -908,7 +908,7 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
>  
>  		/* attach SDR */
>  		dvb_attach(rtl2832_sdr_attach, adap->fe[0], &d->i2c_adap,
> -				&rtl28xxu_rtl2832_fc0012_config);
> +				&rtl28xxu_rtl2832_fc0012_config, NULL);
>  		break;
>  	case TUNER_RTL2832_FC0013:
>  		fe = dvb_attach(fc0013_attach, adap->fe[0],
> @@ -920,9 +920,10 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
>  
>  		/* attach SDR */
>  		dvb_attach(rtl2832_sdr_attach, adap->fe[0], &d->i2c_adap,
> -				&rtl28xxu_rtl2832_fc0013_config);
> +				&rtl28xxu_rtl2832_fc0013_config, NULL);
>  		break;
>  	case TUNER_RTL2832_E4000: {
> +			struct v4l2_subdev *sd;
>  			struct i2c_adapter *i2c_adap_internal =
>  					rtl2832_get_private_i2c_adapter(adap->fe[0]);
>  			struct e4000_config e4000_config = {
> @@ -938,12 +939,14 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
>  			priv->client = i2c_new_device(priv->demod_i2c_adapter,
>  					&info);
>  
> +			sd = i2c_get_clientdata(priv->client);
> +
>  			i2c_set_adapdata(i2c_adap_internal, d);
>  
>  			/* attach SDR */
>  			dvb_attach(rtl2832_sdr_attach, adap->fe[0],
>  					i2c_adap_internal,
> -					&rtl28xxu_rtl2832_e4000_config);
> +					&rtl28xxu_rtl2832_e4000_config, sd);
>  		}
>  		break;
>  	case TUNER_RTL2832_FC2580:
> @@ -973,7 +976,7 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
>  
>  		/* attach SDR */
>  		dvb_attach(rtl2832_sdr_attach, adap->fe[0], &d->i2c_adap,
> -				&rtl28xxu_rtl2832_r820t_config);
> +				&rtl28xxu_rtl2832_r820t_config, NULL);
>  		break;
>  	case TUNER_RTL2832_R828D:
>  		/* power off mn88472 demod on GPIO0 */
> diff --git a/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c b/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
> index c2c3c3d..b34a148 100644
> --- a/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
> +++ b/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
> @@ -25,7 +25,6 @@
>  #include "dvb_frontend.h"
>  #include "rtl2832_sdr.h"
>  #include "dvb_usb.h"
> -#include "e4000.h"
>  #include "r820t.h"
>  
>  #include <media/v4l2-device.h>
> @@ -1367,7 +1366,8 @@ static void rtl2832_sdr_video_release(struct v4l2_device *v)
>  }
>  
>  struct dvb_frontend *rtl2832_sdr_attach(struct dvb_frontend *fe,
> -		struct i2c_adapter *i2c, const struct rtl2832_config *cfg)
> +		struct i2c_adapter *i2c, const struct rtl2832_config *cfg,
> +		struct v4l2_subdev *sd)
>  {
>  	int ret;
>  	struct rtl2832_sdr_state *s;
> @@ -1414,10 +1414,9 @@ struct dvb_frontend *rtl2832_sdr_attach(struct dvb_frontend *fe,
>  	/* Register controls */
>  	switch (s->cfg->tuner) {
>  	case RTL2832_TUNER_E4000:
> -		hdl = e4000_get_ctrl_handler(fe);
>  		v4l2_ctrl_handler_init(&s->hdl, 9);
> -		if (hdl)
> -			v4l2_ctrl_add_handler(&s->hdl, hdl, NULL);
> +		if (sd)
> +			v4l2_ctrl_add_handler(&s->hdl, sd->ctrl_handler, NULL);
>  		break;
>  	case RTL2832_TUNER_R820T:
>  		v4l2_ctrl_handler_init(&s->hdl, 8);
> diff --git a/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.h b/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.h
> index 0803e45..b865fad 100644
> --- a/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.h
> +++ b/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.h
> @@ -32,16 +32,19 @@
>  #define RTL2832_SDR_H
>  
>  #include <linux/kconfig.h>
> +#include <media/v4l2-subdev.h>
>  
>  /* for config struct */
>  #include "rtl2832.h"
>  
>  #if IS_ENABLED(CONFIG_DVB_RTL2832_SDR)
>  extern struct dvb_frontend *rtl2832_sdr_attach(struct dvb_frontend *fe,
> -	struct i2c_adapter *i2c, const struct rtl2832_config *cfg);
> +	struct i2c_adapter *i2c, const struct rtl2832_config *cfg,
> +	struct v4l2_subdev *sd);
>  #else
>  static inline struct dvb_frontend *rtl2832_sdr_attach(struct dvb_frontend *fe,
> -	struct i2c_adapter *i2c, const struct rtl2832_config *cfg)
> +	struct i2c_adapter *i2c, const struct rtl2832_config *cfg,
> +	struct v4l2_subdev *sd)
>  {
>  	dev_warn(&i2c->dev, "%s: driver disabled by Kconfig\n", __func__);
>  	return NULL;


-- 

Regards,
Mauro
