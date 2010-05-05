Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f198.google.com ([209.85.211.198]:48227 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757174Ab0EECQ2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 May 2010 22:16:28 -0400
Received: by ywh36 with SMTP id 36so1997846ywh.4
        for <linux-media@vger.kernel.org>; Tue, 04 May 2010 19:16:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100505085350.1b4f023f@glory.loctelecom.ru>
References: <20100505085350.1b4f023f@glory.loctelecom.ru>
Date: Wed, 5 May 2010 10:16:27 +0800
Message-ID: <y2t6e8e83e21005041916w8bca885fo44b27f858c9dea5b@mail.gmail.com>
Subject: Re: [PATCH] Rework for support xc5000
From: Bee Hock Goh <beehock@gmail.com>
To: Dmitri Belimov <d.belimov@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Stefan Ringel <stefan.ringel@arcor.de>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There does not seem to be any radio support in the tm6000 codes.

tun_setup.mode_mask |= (T_ANALOG_TV | T_RADIO);

Is the T_RADIO mode still required since this is a cleanup?

On Wed, May 5, 2010 at 6:53 AM, Dmitri Belimov <d.belimov@gmail.com> wrote:
> Hi
>
> Set correct GPIO number for BEHOLD_WANDER/VOYAGER
> Add xc5000 callback function
> Small rework tm6000_cards_setup function
> Small rework tm6000_config_tuner, build mode_mask by config information
> Rework for support xc5000 silicon tuner
> Add some information messages for more better understand an errors.
>
> diff --git a/drivers/staging/tm6000/tm6000-cards.c b/drivers/staging/tm6000/tm6000-cards.c
> index f795a3e..17e3d4c 100644
> --- a/drivers/staging/tm6000/tm6000-cards.c
> +++ b/drivers/staging/tm6000/tm6000-cards.c
> @@ -231,7 +231,9 @@ struct tm6000_board tm6000_boards[] = {
>                        .has_remote   = 1,
>                },
>                .gpio = {
> -                       .tuner_reset    = TM6000_GPIO_2,
> +                       .tuner_reset    = TM6010_GPIO_0,
> +                       .demod_reset    = TM6010_GPIO_1,
> +                       .power_led      = TM6010_GPIO_6,
>                },
>        },
>        [TM6010_BOARD_BEHOLD_VOYAGER] = {
> @@ -247,7 +249,8 @@ struct tm6000_board tm6000_boards[] = {
>                        .has_remote   = 1,
>                },
>                .gpio = {
> -                       .tuner_reset    = TM6000_GPIO_2,
> +                       .tuner_reset    = TM6010_GPIO_0,
> +                       .power_led      = TM6010_GPIO_6,
>                },
>        },
>        [TM6010_BOARD_TERRATEC_CINERGY_HYBRID_XE] = {
> @@ -320,6 +323,31 @@ struct usb_device_id tm6000_id_table [] = {
>        { },
>  };
>
> +/* Tuner callback to provide the proper gpio changes needed for xc5000 */
> +int tm6000_xc5000_callback(void *ptr, int component, int command, int arg)
> +{
> +       int rc = 0;
> +       struct tm6000_core *dev = ptr;
> +
> +       if (dev->tuner_type != TUNER_XC5000)
> +               return 0;
> +
> +       switch (command) {
> +       case XC5000_TUNER_RESET:
> +               tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
> +                              dev->gpio.tuner_reset, 0x01);
> +               msleep(15);
> +               tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
> +                              dev->gpio.tuner_reset, 0x00);
> +               msleep(15);
> +               tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
> +                              dev->gpio.tuner_reset, 0x01);
> +               break;
> +       }
> +       return (rc);
> +}
> +
> +
>  /* Tuner callback to provide the proper gpio changes needed for xc2028 */
>
>  int tm6000_tuner_callback(void *ptr, int component, int command, int arg)
> @@ -438,6 +466,21 @@ int tm6000_cards_setup(struct tm6000_core *dev)
>                tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN, dev->gpio.demod_on, 0x00);
>                msleep(15);
>                break;
> +       case TM6010_BOARD_BEHOLD_WANDER:
> +               /* Power led on (blue) */
> +               tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN, dev->gpio.power_led, 0x01);
> +               msleep(15);
> +               /* Reset zarlink zl10353 */
> +               tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN, dev->gpio.demod_reset, 0x00);
> +               msleep(50);
> +               tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN, dev->gpio.demod_reset, 0x01);
> +               msleep(15);
> +               break;
> +       case TM6010_BOARD_BEHOLD_VOYAGER:
> +               /* Power led on (blue) */
> +               tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN, dev->gpio.power_led, 0x01);
> +               msleep(15);
> +               break;
>        default:
>                break;
>        }
> @@ -449,42 +492,38 @@ int tm6000_cards_setup(struct tm6000_core *dev)
>         * If a device uses a different sequence or different GPIO pins for
>         * reset, just add the code at the board-specific part
>         */
> -       for (i = 0; i < 2; i++) {
> -               rc = tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
> -                                       dev->gpio.tuner_reset, 0x00);
> -               if (rc < 0) {
> -                       printk(KERN_ERR "Error %i doing GPIO1 reset\n", rc);
> -                       return rc;
> -               }
> -
> -               msleep(10); /* Just to be conservative */
> -               rc = tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
> -                                       dev->gpio.tuner_reset, 0x01);
> -               if (rc < 0) {
> -                       printk(KERN_ERR "Error %i doing GPIO1 reset\n", rc);
> -                       return rc;
> -               }
>
> -               msleep(10);
> -               rc = tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN, TM6000_GPIO_4, 0);
> -               if (rc < 0) {
> -                       printk(KERN_ERR "Error %i doing GPIO4 reset\n", rc);
> -                       return rc;
> -               }
> +       if (dev->gpio.tuner_reset)
> +       {
> +               for (i = 0; i < 2; i++) {
> +                       rc = tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
> +                                               dev->gpio.tuner_reset, 0x00);
> +                       if (rc < 0) {
> +                               printk(KERN_ERR "Error %i doing tuner reset\n", rc);
> +                               return rc;
> +                       }
>
> -               msleep(10);
> -               rc = tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN, TM6000_GPIO_4, 1);
> -               if (rc < 0) {
> -                       printk(KERN_ERR "Error %i doing GPIO4 reset\n", rc);
> -                       return rc;
> -               }
> +                       msleep(10); /* Just to be conservative */
> +                       rc = tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
> +                                               dev->gpio.tuner_reset, 0x01);
> +                       if (rc < 0) {
> +                               printk(KERN_ERR "Error %i doing tuner reset\n", rc);
> +                               return rc;
> +                       }
> +                       msleep(10);
>
> -               if (!i) {
> -                       rc = tm6000_get_reg32(dev, REQ_40_GET_VERSION, 0, 0);
> -                       if (rc >= 0)
> -                               printk(KERN_DEBUG "board=0x%08x\n", rc);
> +                       if (!i) {
> +                               rc = tm6000_get_reg32(dev, REQ_40_GET_VERSION, 0, 0);
> +                               if (rc >= 0)
> +                                       printk(KERN_DEBUG "board=0x%08x\n", rc);
> +                       }
>                }
>        }
> +       else
> +       {
> +               printk(KERN_ERR "Tuner reset is not configured\n");
> +               return -1;
> +       }
>
>        msleep(50);
>
> @@ -502,12 +541,30 @@ static void tm6000_config_tuner (struct tm6000_core *dev)
>        memset(&tun_setup, 0, sizeof(tun_setup));
>        tun_setup.type   = dev->tuner_type;
>        tun_setup.addr   = dev->tuner_addr;
> -       tun_setup.mode_mask = T_ANALOG_TV | T_RADIO | T_DIGITAL_TV;
> -       tun_setup.tuner_callback = tm6000_tuner_callback;
> +
> +       tun_setup.mode_mask = 0;
> +       if (dev->caps.has_tuner)
> +               tun_setup.mode_mask |= (T_ANALOG_TV | T_RADIO);
> +       if (dev->caps.has_dvb)
> +               tun_setup.mode_mask |= T_DIGITAL_TV;
> +
> +       switch (dev->tuner_type)
> +       {
> +       case TUNER_XC2028:
> +               tun_setup.tuner_callback = tm6000_tuner_callback;;
> +               break;
> +       case TUNER_XC5000:
> +               tun_setup.tuner_callback = tm6000_xc5000_callback;
> +               break;
> +       }
> +
>
>        v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_type_addr, &tun_setup);
>
> -       if (dev->tuner_type == TUNER_XC2028) {
> +       switch (dev->tuner_type)
> +       {
> +       case TUNER_XC2028:
> +               {
>                struct v4l2_priv_tun_config  xc2028_cfg;
>                struct xc2028_ctrl           ctl;
>
> @@ -537,9 +594,31 @@ static void tm6000_config_tuner (struct tm6000_core *dev)
>                }
>
>                printk(KERN_INFO "Setting firmware parameters for xc2028\n");
> -
>                v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_config,
>                                     &xc2028_cfg);
> +
> +               }
> +               break;
> +       case TUNER_XC5000:
> +               {
> +               struct v4l2_priv_tun_config  xc5000_cfg;
> +               struct xc5000_config ctl = {
> +                       .i2c_address = dev->tuner_addr,
> +                       .if_khz      = 4570,
> +                       .radio_input = XC5000_RADIO_FM1,
> +                       };
> +
> +               xc5000_cfg.tuner = TUNER_XC5000;
> +               xc5000_cfg.priv  = &ctl;
> +
> +
> +               v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, s_config,
> +                                    &xc5000_cfg);
> +               }
> +               break;
> +       default:
> +               printk(KERN_INFO "Unknown tuner type. Tuner is not configured.\n");
> +               break;
>        }
>  }
>
> diff --git a/drivers/staging/tm6000/tm6000.h b/drivers/staging/tm6000/tm6000.h
> index 7aeded8..325a2b1 100644
> --- a/drivers/staging/tm6000/tm6000.h
> +++ b/drivers/staging/tm6000/tm6000.h
> @@ -216,6 +216,7 @@ struct tm6000_fh {
>  /* In tm6000-cards.c */
>
>  int tm6000_tuner_callback (void *ptr, int component, int command, int arg);
> +int tm6000_xc5000_callback (void *ptr, int component, int command, int arg);
>  int tm6000_cards_setup(struct tm6000_core *dev);
>
>  /* In tm6000-core.c */
>
> Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>
>
>
> With my best regards, Dmitry.
