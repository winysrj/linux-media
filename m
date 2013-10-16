Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:60949 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089Ab3JPPy6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Oct 2013 11:54:58 -0400
Received: by mail-pd0-f178.google.com with SMTP id w10so1118880pde.37
        for <linux-media@vger.kernel.org>; Wed, 16 Oct 2013 08:54:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20131015203305.7dd5e55a.m.chehab@samsung.com>
References: <1381876264-20342-1-git-send-email-crope@iki.fi>
	<20131015203305.7dd5e55a.m.chehab@samsung.com>
Date: Wed, 16 Oct 2013 11:54:57 -0400
Message-ID: <CAOcJUby9LnEUVFm1HFxOE6mJaSPi-2DAyH16zNDvRHACqbOkPw@mail.gmail.com>
Subject: Re: [PATCH REVIEW] e4000: convert DVB tuner to I2C driver model
From: Michael Krufky <mkrufky@linuxtv.org>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Antti Palosaari <crope@iki.fi>,
	linux-media <linux-media@vger.kernel.org>,
	Jean Delvare <khali@linux-fr.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This kinda makes me a bit nervous.  The patch itself looks OK but the
cascading effects that it will have across the DVB subsystem need to
be discussed.

Is there a discussion about this kind of conversion on the mailing
list somewhere that I've missed?

-Mike

On Tue, Oct 15, 2013 at 7:33 PM, Mauro Carvalho Chehab
<m.chehab@samsung.com> wrote:
> Em Wed, 16 Oct 2013 01:31:04 +0300
> Antti Palosaari <crope@iki.fi> escreveu:
>
>> Initial driver conversion from proprietary DVB tuner model to more
>> general I2C driver model.
>>
>> That commit has just basic binding stuff and driver itself still
>> needs to be converted more complete later.
>>
>> Cc: Jean Delvare <khali@linux-fr.org>
>> Signed-off-by: Antti Palosaari <crope@iki.fi>
>> ---
>>  drivers/media/tuners/e4000.c            | 73 ++++++++++++++++++++++-----------
>>  drivers/media/tuners/e4000.h            |  9 +++-
>>  drivers/media/tuners/e4000_priv.h       |  4 +-
>>  drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 31 +++++++++-----
>>  4 files changed, 78 insertions(+), 39 deletions(-)
>>
>> diff --git a/drivers/media/tuners/e4000.c b/drivers/media/tuners/e4000.c
>> index 54e2d8a..f6a5dbd 100644
>> --- a/drivers/media/tuners/e4000.c
>> +++ b/drivers/media/tuners/e4000.c
>> @@ -27,7 +27,7 @@ static int e4000_wr_regs(struct e4000_priv *priv, u8 reg, u8 *val, int len)
>>       u8 buf[1 + len];
>>       struct i2c_msg msg[1] = {
>>               {
>> -                     .addr = priv->cfg->i2c_addr,
>> +                     .addr = priv->i2c_addr,
>>                       .flags = 0,
>>                       .len = sizeof(buf),
>>                       .buf = buf,
>> @@ -56,12 +56,12 @@ static int e4000_rd_regs(struct e4000_priv *priv, u8 reg, u8 *val, int len)
>>       u8 buf[len];
>>       struct i2c_msg msg[2] = {
>>               {
>> -                     .addr = priv->cfg->i2c_addr,
>> +                     .addr = priv->i2c_addr,
>>                       .flags = 0,
>>                       .len = 1,
>>                       .buf = &reg,
>>               }, {
>> -                     .addr = priv->cfg->i2c_addr,
>> +                     .addr = priv->i2c_addr,
>>                       .flags = I2C_M_RD,
>>                       .len = sizeof(buf),
>>                       .buf = buf,
>> @@ -233,8 +233,8 @@ static int e4000_set_params(struct dvb_frontend *fe)
>>        * or more.
>>        */
>>       f_vco = c->frequency * e4000_pll_lut[i].mul;
>> -     sigma_delta = div_u64(0x10000ULL * (f_vco % priv->cfg->clock), priv->cfg->clock);
>> -     buf[0] = f_vco / priv->cfg->clock;
>> +     sigma_delta = div_u64(0x10000ULL * (f_vco % priv->clock), priv->clock);
>> +     buf[0] = f_vco / priv->clock;
>>       buf[1] = (sigma_delta >> 0) & 0xff;
>>       buf[2] = (sigma_delta >> 8) & 0xff;
>>       buf[3] = 0x00;
>> @@ -358,17 +358,6 @@ static int e4000_get_if_frequency(struct dvb_frontend *fe, u32 *frequency)
>>       return 0;
>>  }
>>
>> -static int e4000_release(struct dvb_frontend *fe)
>> -{
>> -     struct e4000_priv *priv = fe->tuner_priv;
>> -
>> -     dev_dbg(&priv->i2c->dev, "%s:\n", __func__);
>> -
>> -     kfree(fe->tuner_priv);
>> -
>> -     return 0;
>> -}
>> -
>>  static const struct dvb_tuner_ops e4000_tuner_ops = {
>>       .info = {
>>               .name           = "Elonics E4000",
>> @@ -376,8 +365,6 @@ static const struct dvb_tuner_ops e4000_tuner_ops = {
>>               .frequency_max  = 862000000,
>>       },
>>
>> -     .release = e4000_release,
>> -
>>       .init = e4000_init,
>>       .sleep = e4000_sleep,
>>       .set_params = e4000_set_params,
>> @@ -385,9 +372,12 @@ static const struct dvb_tuner_ops e4000_tuner_ops = {
>>       .get_if_frequency = e4000_get_if_frequency,
>>  };
>>
>> -struct dvb_frontend *e4000_attach(struct dvb_frontend *fe,
>> -             struct i2c_adapter *i2c, const struct e4000_config *cfg)
>> +static int e4000_probe(struct i2c_client *client,
>> +             const struct i2c_device_id *id)
>>  {
>> +     struct e4000_config *cfg = client->dev.platform_data;
>> +     struct dvb_frontend *fe = cfg->fe;
>> +     struct i2c_adapter *i2c = client->adapter;
>>       struct e4000_priv *priv;
>>       int ret;
>>       u8 chip_id;
>> @@ -402,7 +392,9 @@ struct dvb_frontend *e4000_attach(struct dvb_frontend *fe,
>>               goto err;
>>       }
>>
>> -     priv->cfg = cfg;
>> +     priv->i2c_addr = cfg->i2c_addr;
>> +     priv->clock = cfg->clock;
>> +     priv->i2c_client = client;
>>       priv->i2c = i2c;
>>
>>       /* check if the tuner is there */
>> @@ -412,8 +404,10 @@ struct dvb_frontend *e4000_attach(struct dvb_frontend *fe,
>>
>>       dev_dbg(&priv->i2c->dev, "%s: chip_id=%02x\n", __func__, chip_id);
>>
>> -     if (chip_id != 0x40)
>> +     if (chip_id != 0x40) {
>> +             ret = -ENODEV;
>>               goto err;
>> +     }
>>
>>       /* put sleep as chip seems to be in normal mode by default */
>>       ret = e4000_wr_reg(priv, 0x00, 0x00);
>> @@ -431,16 +425,45 @@ struct dvb_frontend *e4000_attach(struct dvb_frontend *fe,
>>       if (fe->ops.i2c_gate_ctrl)
>>               fe->ops.i2c_gate_ctrl(fe, 0);
>>
>> -     return fe;
>> +     i2c_set_clientdata(client, priv);
>> +
>> +     return 0;
>>  err:
>>       if (fe->ops.i2c_gate_ctrl)
>>               fe->ops.i2c_gate_ctrl(fe, 0);
>>
>>       dev_dbg(&i2c->dev, "%s: failed=%d\n", __func__, ret);
>>       kfree(priv);
>> -     return NULL;
>> +     return ret;
>>  }
>> -EXPORT_SYMBOL(e4000_attach);
>> +
>> +static int e4000_remove(struct i2c_client *client)
>> +{
>> +     struct e4000_priv *priv = i2c_get_clientdata(client);
>> +
>> +     dev_dbg(&client->dev, "%s:\n", __func__);
>> +
>> +     kfree(priv);
>> +     return 0;
>> +}
>> +
>> +static const struct i2c_device_id e4000_id[] = {
>> +     {"e4000", 0},
>> +     {}
>> +};
>> +MODULE_DEVICE_TABLE(i2c, e4000_id);
>> +
>> +static struct i2c_driver e4000_driver = {
>> +     .driver = {
>> +             .owner  = THIS_MODULE,
>> +             .name   = "e4000",
>> +     },
>> +     .probe          = e4000_probe,
>> +     .remove         = e4000_remove,
>> +     .id_table       = e4000_id,
>> +};
>> +
>> +module_i2c_driver(e4000_driver);
>>
>>  MODULE_DESCRIPTION("Elonics E4000 silicon tuner driver");
>>  MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
>> diff --git a/drivers/media/tuners/e4000.h b/drivers/media/tuners/e4000.h
>> index 25ee7c0..760b206 100644
>> --- a/drivers/media/tuners/e4000.h
>> +++ b/drivers/media/tuners/e4000.h
>> @@ -26,6 +26,11 @@
>>
>>  struct e4000_config {
>>       /*
>> +      * frontend
>> +      */
>> +     struct dvb_frontend *fe;
>> +
>> +     /*
>>        * I2C address
>>        * 0x64, 0x65, 0x66, 0x67
>>        */
>> @@ -39,10 +44,10 @@ struct e4000_config {
>>
>>  #if IS_ENABLED(CONFIG_MEDIA_TUNER_E4000)
>
> You can get rid of #if IS_ENABLED, by replacing it by a generic attach
> function, using the subdev model. In other words, this is how a tuner
> subdev is defined:
>
>         struct v4l2_subdev_tuner_ops {
>                 int (*s_radio)(struct v4l2_subdev *sd);
>                 int (*s_frequency)(struct v4l2_subdev *sd, const struct v4l2_frequency *freq);
>                 int (*g_frequency)(struct v4l2_subdev *sd, struct v4l2_frequency *freq);
>                 int (*g_tuner)(struct v4l2_subdev *sd, struct v4l2_tuner *vt);
>                 int (*s_tuner)(struct v4l2_subdev *sd, const struct v4l2_tuner *vt);
>                 int (*g_modulator)(struct v4l2_subdev *sd, struct v4l2_modulator *vm);
>                 int (*s_modulator)(struct v4l2_subdev *sd, const struct v4l2_modulator *vm);
>                 int (*s_type_addr)(struct v4l2_subdev *sd, struct tuner_setup *type);
>                 int (*s_config)(struct v4l2_subdev *sd, const struct v4l2_priv_tun_config *config);
>         };
>
> As the presence of the device is known, there's no need to actually attach
> anything, but you need to pass the configuration for the subdevice. This is
> done by calling the subdev s_config ops to setup them:
>
>         v4l2_subdev_call(sd, tuner, s_config, vfh, arg);
>
> A new callback will be needed there, in order to put the device into DVB mode,
> e. g. passing the DVB specific parameters.
>
> As the subdev callbacks are defined on a generic .h header and they always
> exist, if the driver is not compiled, i2c_new_device() won't find the driver,
> and the bridge driver won't call s_config() for this I2C client.
>
> That's IMHO, one of the biggest advantages of this conversion: as a bonus,
> we get rid of several Kconfig issues. Also, with this change, lsmod will
> properly show that the tuner is bound to the bridge driver.
>
>>  extern struct dvb_frontend *e4000_attach(struct dvb_frontend *fe,
>> -             struct i2c_adapter *i2c, const struct e4000_config *cfg);
>> +             struct i2c_adapter *i2c, struct e4000_config *cfg);
>>  #else
>>  static inline struct dvb_frontend *e4000_attach(struct dvb_frontend *fe,
>> -             struct i2c_adapter *i2c, const struct e4000_config *cfg)
>> +             struct i2c_adapter *i2c, struct e4000_config *cfg)
>>  {
>>       dev_warn(&i2c->dev, "%s: driver disabled by Kconfig\n", __func__);
>>       return NULL;
>> diff --git a/drivers/media/tuners/e4000_priv.h b/drivers/media/tuners/e4000_priv.h
>> index a385505..7f47068 100644
>> --- a/drivers/media/tuners/e4000_priv.h
>> +++ b/drivers/media/tuners/e4000_priv.h
>> @@ -24,8 +24,10 @@
>>  #include "e4000.h"
>>
>>  struct e4000_priv {
>> -     const struct e4000_config *cfg;
>>       struct i2c_adapter *i2c;
>> +     struct i2c_client *i2c_client;
>> +     u8 i2c_addr;
>> +     u32 clock;
>>  };
>>
>>  struct e4000_pll {
>> diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
>> index defc491..573805a 100644
>> --- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
>> +++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
>> @@ -843,11 +843,6 @@ err:
>>       return ret;
>>  }
>>
>> -static const struct e4000_config rtl2832u_e4000_config = {
>> -     .i2c_addr = 0x64,
>> -     .clock = 28800000,
>> -};
>> -
>>  static const struct fc2580_config rtl2832u_fc2580_config = {
>>       .i2c_addr = 0x56,
>>       .clock = 16384000,
>> @@ -874,10 +869,14 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
>>       int ret;
>>       struct dvb_usb_device *d = adap_to_d(adap);
>>       struct rtl28xxu_priv *priv = d_to_priv(d);
>> -     struct dvb_frontend *fe;
>> +     struct dvb_frontend *fe = NULL;
>> +     struct i2c_client *client = NULL;
>> +     struct i2c_board_info info;
>>
>>       dev_dbg(&d->udev->dev, "%s:\n", __func__);
>>
>> +     memset(&info, 0, sizeof(struct i2c_board_info));
>> +
>>       switch (priv->tuner) {
>>       case TUNER_RTL2832_FC0012:
>>               fe = dvb_attach(fc0012_attach, adap->fe[0],
>> @@ -897,9 +896,20 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
>>               adap->fe[0]->ops.read_signal_strength =
>>                               adap->fe[0]->ops.tuner_ops.get_rf_strength;
>>               return 0;
>> -     case TUNER_RTL2832_E4000:
>> -             fe = dvb_attach(e4000_attach, adap->fe[0], &d->i2c_adap,
>> -                             &rtl2832u_e4000_config);
>> +     case TUNER_RTL2832_E4000: {
>> +                     struct e4000_config e4000_config = {
>> +                             .fe = adap->fe[0],
>> +                             .i2c_addr = 0x64,
>> +                             .clock = 28800000,
>> +                     };
>> +
>> +                     strlcpy(info.type, "e4000", I2C_NAME_SIZE);
>> +                     info.addr = 0x64;
>> +                     info.platform_data = &e4000_config;
>> +
>> +                     request_module("e4000");
>> +                     client = i2c_new_device(&d->i2c_adap, &info);
>> +             }
>>               break;
>>       case TUNER_RTL2832_FC2580:
>>               fe = dvb_attach(fc2580_attach, adap->fe[0], &d->i2c_adap,
>> @@ -927,12 +937,11 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
>>                               adap->fe[0]->ops.tuner_ops.get_rf_strength;
>>               break;
>>       default:
>> -             fe = NULL;
>>               dev_err(&d->udev->dev, "%s: unknown tuner=%d\n", KBUILD_MODNAME,
>>                               priv->tuner);
>>       }
>>
>> -     if (fe == NULL) {
>> +     if (fe == NULL && (client == NULL || client->driver == NULL)) {
>>               ret = -ENODEV;
>>               goto err;
>>       }
>
>
> --
>
> Cheers,
> Mauro
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
