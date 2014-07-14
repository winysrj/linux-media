Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:63896 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518AbaGNRT3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jul 2014 13:19:29 -0400
Received: by mail-pd0-f178.google.com with SMTP id r10so5557995pdi.37
        for <linux-media@vger.kernel.org>; Mon, 14 Jul 2014 10:19:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1405357739-3570-14-git-send-email-crope@iki.fi>
References: <1405357739-3570-1-git-send-email-crope@iki.fi>
	<1405357739-3570-14-git-send-email-crope@iki.fi>
Date: Mon, 14 Jul 2014 13:19:29 -0400
Message-ID: <CAOcJUbzOig5D16kNTJ_5xaBwd210CfPPQzivEhnV-GZYAj-LTw@mail.gmail.com>
Subject: Re: [PATCH 14/18] cxusb: TechnoTrend CT2-4400 USB DVB-T2/C tuner support
From: Michael Ira Krufky <mkrufky@linuxtv.org>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media <linux-media@vger.kernel.org>,
	Olli Salonen <olli.salonen@iki.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reviewed-by: Michael Ira Krufky <mkrufky@linuxtv.org>

I assume you'll merge this via your own branch?

...I've been traveling on & off for the past few months, but I am back
now - I'll be getting thru my pending patch queue right away

Cheers,

Mike

On Mon, Jul 14, 2014 at 1:08 PM, Antti Palosaari <crope@iki.fi> wrote:
> From: Olli Salonen <olli.salonen@iki.fi>
>
> USB ID 0b48:3014.
>
> USB interface: Cypress CY7C68013A-56LTXC
> Demodulator: Silicon Labs Si2168-30
> Tuner: Silicon Labs Si2158-20
>
> Cc: Michael Krufky <mkrufky@linuxtv.org>
> Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
> Reviewed-by: Antti Palosaari <crope@iki.fi>
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> ---
>  drivers/media/dvb-core/dvb-usb-ids.h |   1 +
>  drivers/media/usb/dvb-usb/Kconfig    |   3 +
>  drivers/media/usb/dvb-usb/cxusb.c    | 191 ++++++++++++++++++++++++++++++++++-
>  drivers/media/usb/dvb-usb/cxusb.h    |   2 +
>  4 files changed, 196 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/media/dvb-core/dvb-usb-ids.h b/drivers/media/dvb-core/dvb-usb-ids.h
> index 11d2bea..f8e3150 100644
> --- a/drivers/media/dvb-core/dvb-usb-ids.h
> +++ b/drivers/media/dvb-core/dvb-usb-ids.h
> @@ -244,6 +244,7 @@
>  #define USB_PID_TECHNOTREND_CONNECT_S2400               0x3006
>  #define USB_PID_TECHNOTREND_CONNECT_S2400_8KEEPROM     0x3009
>  #define USB_PID_TECHNOTREND_CONNECT_CT3650             0x300d
> +#define USB_PID_TECHNOTREND_TVSTICK_CT2_4400           0x3014
>  #define USB_PID_TERRATEC_CINERGY_DT_XS_DIVERSITY       0x005a
>  #define USB_PID_TERRATEC_CINERGY_DT_XS_DIVERSITY_2     0x0081
>  #define USB_PID_TERRATEC_CINERGY_HT_USB_XE             0x0058
> diff --git a/drivers/media/usb/dvb-usb/Kconfig b/drivers/media/usb/dvb-usb/Kconfig
> index c5d9566..10aef21 100644
> --- a/drivers/media/usb/dvb-usb/Kconfig
> +++ b/drivers/media/usb/dvb-usb/Kconfig
> @@ -117,10 +117,12 @@ config DVB_USB_CXUSB
>         select DVB_TUNER_DIB0070 if MEDIA_SUBDRV_AUTOSELECT
>         select DVB_ATBM8830 if MEDIA_SUBDRV_AUTOSELECT
>         select DVB_LGS8GXX if MEDIA_SUBDRV_AUTOSELECT
> +       select DVB_SI2168 if MEDIA_SUBDRV_AUTOSELECT
>         select MEDIA_TUNER_SIMPLE if MEDIA_SUBDRV_AUTOSELECT
>         select MEDIA_TUNER_XC2028 if MEDIA_SUBDRV_AUTOSELECT
>         select MEDIA_TUNER_MXL5005S if MEDIA_SUBDRV_AUTOSELECT
>         select MEDIA_TUNER_MAX2165 if MEDIA_SUBDRV_AUTOSELECT
> +       select MEDIA_TUNER_SI2157 if MEDIA_SUBDRV_AUTOSELECT
>         help
>           Say Y here to support the Conexant USB2.0 hybrid reference design.
>           Currently, only DVB and ATSC modes are supported, analog mode
> @@ -128,6 +130,7 @@ config DVB_USB_CXUSB
>
>           Medion MD95700 hybrid USB2.0 device.
>           DViCO FusionHDTV (Bluebird) USB2.0 devices
> +         TechnoTrend TVStick CT2-4400
>
>  config DVB_USB_M920X
>         tristate "Uli m920x DVB-T USB2.0 support"
> diff --git a/drivers/media/usb/dvb-usb/cxusb.c b/drivers/media/usb/dvb-usb/cxusb.c
> index a1c641e..ad20c39 100644
> --- a/drivers/media/usb/dvb-usb/cxusb.c
> +++ b/drivers/media/usb/dvb-usb/cxusb.c
> @@ -42,6 +42,8 @@
>  #include "dib0070.h"
>  #include "lgs8gxx.h"
>  #include "atbm8830.h"
> +#include "si2168.h"
> +#include "si2157.h"
>
>  /* Max transfer size done by I2C transfer functions */
>  #define MAX_XFER_SIZE  64
> @@ -144,6 +146,22 @@ static int cxusb_d680_dmb_gpio_tuner(struct dvb_usb_device *d,
>         }
>  }
>
> +static int cxusb_tt_ct2_4400_gpio_tuner(struct dvb_usb_device *d, int onoff)
> +{
> +       u8 o[2], i;
> +       int rc;
> +
> +       o[0] = 0x83;
> +       o[1] = onoff;
> +       rc = cxusb_ctrl_msg(d, CMD_GPIO_WRITE, o, 2, &i, 1);
> +
> +       if (rc) {
> +               deb_info("gpio_write failed.\n");
> +               return -EIO;
> +       }
> +       return 0;
> +}
> +
>  /* I2C */
>  static int cxusb_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[],
>                           int num)
> @@ -505,6 +523,30 @@ static int cxusb_d680_dmb_rc_query(struct dvb_usb_device *d, u32 *event,
>         return 0;
>  }
>
> +static int cxusb_tt_ct2_4400_rc_query(struct dvb_usb_device *d)
> +{
> +       u8 i[2];
> +       int ret;
> +       u32 cmd, keycode;
> +       u8 rc5_cmd, rc5_addr, rc5_toggle;
> +
> +       ret = cxusb_ctrl_msg(d, 0x10, NULL, 0, i, 2);
> +       if (ret)
> +               return ret;
> +
> +       cmd = (i[0] << 8) | i[1];
> +
> +       if (cmd != 0xffff) {
> +               rc5_cmd = cmd & 0x3F; /* bits 1-6 for command */
> +               rc5_addr = (cmd & 0x07C0) >> 6; /* bits 7-11 for address */
> +               rc5_toggle = (cmd & 0x0800) >> 11; /* bit 12 for toggle */
> +               keycode = (rc5_addr << 8) | rc5_cmd;
> +               rc_keydown(d->rc_dev, keycode, rc5_toggle);
> +       }
> +
> +       return 0;
> +}
> +
>  static struct rc_map_table rc_map_dvico_mce_table[] = {
>         { 0xfe02, KEY_TV },
>         { 0xfe0e, KEY_MP3 },
> @@ -1286,6 +1328,73 @@ static int cxusb_mygica_d689_frontend_attach(struct dvb_usb_adapter *adap)
>         return 0;
>  }
>
> +static int cxusb_tt_ct2_4400_attach(struct dvb_usb_adapter *adap)
> +{
> +       struct dvb_usb_device *d = adap->dev;
> +       struct cxusb_state *st = d->priv;
> +       struct i2c_adapter *adapter;
> +       struct i2c_client *client_demod;
> +       struct i2c_client *client_tuner;
> +       struct i2c_board_info info;
> +       struct si2168_config si2168_config;
> +       struct si2157_config si2157_config;
> +
> +       /* reset the tuner */
> +       if (cxusb_tt_ct2_4400_gpio_tuner(d, 0) < 0) {
> +               err("clear tuner gpio failed");
> +               return -EIO;
> +       }
> +       msleep(100);
> +       if (cxusb_tt_ct2_4400_gpio_tuner(d, 1) < 0) {
> +               err("set tuner gpio failed");
> +               return -EIO;
> +       }
> +       msleep(100);
> +
> +       /* attach frontend */
> +       si2168_config.i2c_adapter = &adapter;
> +       si2168_config.fe = &adap->fe_adap[0].fe;
> +       memset(&info, 0, sizeof(struct i2c_board_info));
> +       strlcpy(info.type, "si2168", I2C_NAME_SIZE);
> +       info.addr = 0x64;
> +       info.platform_data = &si2168_config;
> +       request_module(info.type);
> +       client_demod = i2c_new_device(&d->i2c_adap, &info);
> +       if (client_demod == NULL || client_demod->dev.driver == NULL)
> +               return -ENODEV;
> +
> +       if (!try_module_get(client_demod->dev.driver->owner)) {
> +               i2c_unregister_device(client_demod);
> +               return -ENODEV;
> +       }
> +
> +       st->i2c_client_demod = client_demod;
> +
> +       /* attach tuner */
> +       si2157_config.fe = adap->fe_adap[0].fe;
> +       memset(&info, 0, sizeof(struct i2c_board_info));
> +       strlcpy(info.type, "si2157", I2C_NAME_SIZE);
> +       info.addr = 0x60;
> +       info.platform_data = &si2157_config;
> +       request_module(info.type);
> +       client_tuner = i2c_new_device(adapter, &info);
> +       if (client_tuner == NULL || client_tuner->dev.driver == NULL) {
> +               module_put(client_demod->dev.driver->owner);
> +               i2c_unregister_device(client_demod);
> +               return -ENODEV;
> +       }
> +       if (!try_module_get(client_tuner->dev.driver->owner)) {
> +               i2c_unregister_device(client_tuner);
> +               module_put(client_demod->dev.driver->owner);
> +               i2c_unregister_device(client_demod);
> +               return -ENODEV;
> +       }
> +
> +       st->i2c_client_tuner = client_tuner;
> +
> +       return 0;
> +}
> +
>  /*
>   * DViCO has shipped two devices with the same USB ID, but only one of them
>   * needs a firmware download.  Check the device class details to see if they
> @@ -1367,6 +1476,7 @@ static struct dvb_usb_device_properties cxusb_bluebird_nano2_needsfirmware_prope
>  static struct dvb_usb_device_properties cxusb_aver_a868r_properties;
>  static struct dvb_usb_device_properties cxusb_d680_dmb_properties;
>  static struct dvb_usb_device_properties cxusb_mygica_d689_properties;
> +static struct dvb_usb_device_properties cxusb_tt_ct2_4400_properties;
>
>  static int cxusb_probe(struct usb_interface *intf,
>                        const struct usb_device_id *id)
> @@ -1397,12 +1507,37 @@ static int cxusb_probe(struct usb_interface *intf,
>                                      THIS_MODULE, NULL, adapter_nr) ||
>             0 == dvb_usb_device_init(intf, &cxusb_mygica_d689_properties,
>                                      THIS_MODULE, NULL, adapter_nr) ||
> +           0 == dvb_usb_device_init(intf, &cxusb_tt_ct2_4400_properties,
> +                                    THIS_MODULE, NULL, adapter_nr) ||
>             0)
>                 return 0;
>
>         return -EINVAL;
>  }
>
> +static void cxusb_disconnect(struct usb_interface *intf)
> +{
> +       struct dvb_usb_device *d = usb_get_intfdata(intf);
> +       struct cxusb_state *st = d->priv;
> +       struct i2c_client *client;
> +
> +       /* remove I2C client for tuner */
> +       client = st->i2c_client_tuner;
> +       if (client) {
> +               module_put(client->dev.driver->owner);
> +               i2c_unregister_device(client);
> +       }
> +
> +       /* remove I2C client for demodulator */
> +       client = st->i2c_client_demod;
> +       if (client) {
> +               module_put(client->dev.driver->owner);
> +               i2c_unregister_device(client);
> +       }
> +
> +       dvb_usb_device_exit(intf);
> +}
> +
>  static struct usb_device_id cxusb_table [] = {
>         { USB_DEVICE(USB_VID_MEDION, USB_PID_MEDION_MD95700) },
>         { USB_DEVICE(USB_VID_DVICO, USB_PID_DVICO_BLUEBIRD_LG064F_COLD) },
> @@ -1424,6 +1559,7 @@ static struct usb_device_id cxusb_table [] = {
>         { USB_DEVICE(USB_VID_DVICO, USB_PID_DVICO_BLUEBIRD_DUAL_4_REV_2) },
>         { USB_DEVICE(USB_VID_CONEXANT, USB_PID_CONEXANT_D680_DMB) },
>         { USB_DEVICE(USB_VID_CONEXANT, USB_PID_MYGICA_D689) },
> +       { USB_DEVICE(USB_VID_TECHNOTREND, USB_PID_TECHNOTREND_TVSTICK_CT2_4400) },
>         {}              /* Terminating entry */
>  };
>  MODULE_DEVICE_TABLE (usb, cxusb_table);
> @@ -2070,10 +2206,63 @@ static struct dvb_usb_device_properties cxusb_mygica_d689_properties = {
>         }
>  };
>
> +static struct dvb_usb_device_properties cxusb_tt_ct2_4400_properties = {
> +       .caps = DVB_USB_IS_AN_I2C_ADAPTER,
> +
> +       .usb_ctrl         = CYPRESS_FX2,
> +
> +       .size_of_priv     = sizeof(struct cxusb_state),
> +
> +       .num_adapters = 1,
> +       .adapter = {
> +               {
> +               .num_frontends = 1,
> +               .fe = {{
> +                       .streaming_ctrl   = cxusb_streaming_ctrl,
> +                       /* both frontend and tuner attached in the
> +                          same function */
> +                       .frontend_attach  = cxusb_tt_ct2_4400_attach,
> +
> +                       /* parameter for the MPEG2-data transfer */
> +                       .stream = {
> +                               .type = USB_BULK,
> +                               .count = 8,
> +                               .endpoint = 0x82,
> +                               .u = {
> +                                       .bulk = {
> +                                               .buffersize = 4096,
> +                                       }
> +                               }
> +                       },
> +               } },
> +               },
> +       },
> +
> +       .i2c_algo = &cxusb_i2c_algo,
> +       .generic_bulk_ctrl_endpoint = 0x01,
> +       .generic_bulk_ctrl_endpoint_response = 0x81,
> +
> +       .rc.core = {
> +               .rc_codes       = RC_MAP_TT_1500,
> +               .allowed_protos = RC_BIT_RC5,
> +               .rc_query       = cxusb_tt_ct2_4400_rc_query,
> +               .rc_interval    = 150,
> +       },
> +
> +       .num_device_descs = 1,
> +       .devices = {
> +               {
> +                       "TechnoTrend TVStick CT2-4400",
> +                       { NULL },
> +                       { &cxusb_table[20], NULL },
> +               },
> +       }
> +};
> +
>  static struct usb_driver cxusb_driver = {
>         .name           = "dvb_usb_cxusb",
>         .probe          = cxusb_probe,
> -       .disconnect     = dvb_usb_device_exit,
> +       .disconnect     = cxusb_disconnect,
>         .id_table       = cxusb_table,
>  };
>
> diff --git a/drivers/media/usb/dvb-usb/cxusb.h b/drivers/media/usb/dvb-usb/cxusb.h
> index 1a51eaf..527ff79 100644
> --- a/drivers/media/usb/dvb-usb/cxusb.h
> +++ b/drivers/media/usb/dvb-usb/cxusb.h
> @@ -30,6 +30,8 @@
>
>  struct cxusb_state {
>         u8 gpio_write_state[3];
> +       struct i2c_client *i2c_client_demod;
> +       struct i2c_client *i2c_client_tuner;
>  };
>
>  #endif
> --
> 1.9.3
>
