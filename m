Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nschwmtas02p.mx.bigpond.com ([61.9.189.140])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jhhummel@bigpond.com>) id 1KQLY0-0003te-Ic
	for linux-dvb@linuxtv.org; Tue, 05 Aug 2008 14:21:54 +0200
From: Jonathan Hummel <jhhummel@bigpond.com>
To: Mark Carbonaro <mark@carbonaro.org>
In-Reply-To: <4895080.81217937323843.JavaMail.mark@trogdor.carbonaro.org>
References: <4895080.81217937323843.JavaMail.mark@trogdor.carbonaro.org>
Date: Tue, 05 Aug 2008 22:21:11 +1000
Message-Id: <1217938871.7801.2.camel@mistress>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org, stev391@email.com
Subject: Re: [linux-dvb] [PATCH-TESTERS-REQUIRED] Leadtek Winfast PxDVR 3200
	H - DVB	Only support
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi Mark,

Forgive my ignorance/ newbie-ness, but what do I do with that patch code
below? is there a tutorial or howto or something somewhere that will
introduce me to this. I have done some programming, but nothing of this
level.

cheers

Jon


On Tue, 2008-08-05 at 21:34 +1000, Mark Carbonaro wrote:
> Fantastic, I will start testing it tonight and I will let you know how
> I get on.
> 
> ----- Original Message -----
> From: stev391@email.com
> To: "Mark Carbonaro" <mark@carbonaro.org>, "Jonathan Hummel"
> <jhhummel@bigpond.com>
> Cc: linux-dvb@linuxtv.org
> Sent: Monday, 4 August, 2008 9:34:06 PM (GMT+1000) Auto-Detected
> Subject: [PATCH-TESTERS-REQUIRED] Leadtek Winfast PxDVR 3200 H - DVB
> Only support
> 
> Mark, Jon,
> 
> Inline (and attached) below is a patch against Steven Toths
> cx2388s-sram branch, that enables DVB support on the Leadtek Winfast
> PxDVR 3200 H.
> 
> The code is not exactly elegant at the moment, I'm waiting for Steven
> to refactor his callback code before I tidy this up, but at least you
> can take the dust off the card and use part of it.
> 
> Let me know what issues you run into. (For example occasional on boot
> up, the card gets a subvendor id of 0000 and subproduct of 0000, this
> I have no idea why, but a soft restart makes it work).
> 
> If anyone knows where to start with the Analog support please let me
> know...
> 
> Regards,
> 
> Stephen.
> 
> ----------Patch-----------
> 
> diff -Naur
> cx23885-sram/linux/Documentation/video4linux/CARDLIST.cx23885
> cx23885-sram_dev/linux/Documentation/video4linux/CARDLIST.cx23885
> --- cx23885-sram/linux/Documentation/video4linux/CARDLIST.cx23885
> 2008-08-04 20:29:16.000000000 +1000
> +++ cx23885-sram_dev/linux/Documentation/video4linux/CARDLIST.cx23885
> 2008-08-04 20:50:15.000000000 +1000
> @@ -9,3 +9,4 @@
>    8 -> Hauppauge WinTV-HVR1700   & nbsp;
> [0070:8101]
>    9 -> Hauppauge WinTV-HVR1400
> [0070:8010]
>   10 -> DViCO FusionHDTV7 Dual Express
> [18ac:d618]
> + 11 -> Leadtek Winfast PxDVR3200 H               [107d:6681]
> diff -Naur
> cx23885-sram/linux/drivers/media/video/cx23885/cx23885-cards.c
> cx23885-sram_dev/linux/drivers/media/video/cx23885/cx23885-cards.c
> --- cx23885-sram/linux/drivers/media/video/cx23885/cx23885-cards.c
> 2008-08-04 20:29:17.000000000 +1000
> +++ cx23885-sram_dev/linux/drivers/media/video/cx23885/cx23885-cards.c
> 2008-08-04 21:14:55.000000000 +1000
> @@ -149,6 +149,11 @@
>          .portb        = CX23885_MPEG_DVB,
>          .portc        = CX23885_MPEG_DVB,
>      },
> +    [CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H] = {
> +        .name        = "Leadtek Winfast PxDVR3200 H",
> +//        .portb        = CX23885_MPEG_ENCODER,
> +        .portc        = CX23885_MPEG_DVB,
> +    },
>  };
>  const unsigned int cx23885_bcount = ARRAY_SIZE(cx23885_boards);
>  
> @@ -220,6 +225,10 @@
>          .subvendor = 0x18ac,
>          .subdevice = 0xd618,
>          .card      = CX23885_BOARD_DVICO_FUSIONHDTV_7_DUAL_EXP,
> +    },{
> +        .subvendor = 0x107d,
> +        .subdevice = 0x6681,
> +        .card      = CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H,
>      },
>  };
>  const unsigned int cx23885_idcount = ARRAY_SIZE(cx23885_subids);
> @@ -466,6 +475,17 @@
>          mdelay(20);
>          cx_set(GP0_IO, 0x000f000f);
>          break;
> +    case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:
> +        /* GPIO-2  xc3028 tuner reset */
> +        /* Put the parts into reset and back */
> +        cx_set(GP0_IO, 0x00040000);
> +        mdelay(20);
> +        cx_clear(GP0_IO, 0x00000004);
> +        mdelay(20);
> +        cx_set(GP0_IO, 0x00040004);
> +//        mdelay(20);
> +//        cx_write(GP0_IO, 0x00070404);
> +        break;
>      }
>  }
>  
> @@ -549,6 +569,7 @@
>      case CX23885_BOARD_HAUPPAUGE_HVR1200:
>      case CX23885_BOARD_HAUPPAUGE_HVR1700:
>      case CX23885_BOARD_HAUPPAUGE_HVR1400:
> +    case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:
>      default:
>          ts2->gen_ctrl_val  = 0xc; /* Serial bus + punctured clock */
>          ts2->ts_clk_en_val = 0x1; /* Enable TS_CLK */
> @@ -562,6 +583,7 @@
>      case CX23885_BOARD_HAUPPAUGE_HVR1800:
>      case CX23885_BOARD_HAUPPAUGE_HVR1800lp:
>      case CX23885_BOARD_HAUPPAUGE_HVR1700:
> +    case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:
>          request_module("cx25840");
>          break;
>      }
> diff -Naur
> cx23885-sram/linux/drivers/media/video/cx23885/cx23885-dvb.c
> cx23885-sram_dev/linux/drivers/media/video/cx23885/cx23885-dvb.c
> --- cx23885-sram/linux/drivers/media/video/cx23885/cx23885-dvb.c
> 2008-08-04 20:29:17.000000000 +1000
> +++ cx23885-sram_dev/linux/drivers/media/video/cx23885/cx23885-dvb.c
> 2008-08-04 20:48:07.000000000 +1000
> @@ -36,6 +36,7 @@
>  #include "tda8290.h"
>  #include "tda18271.h"
>  #include "lgdt330x.h"
> +#include "zl10353.h"
>  #include "xc5000.h"
>  #include "tda10048.h"
>  #include "tuner-xc2028.h"
> @@ -155,6 +156,40 @@
>      .serial_mpeg = 0x40,
>  };
>  
> +static int cx23885_leadtek_xc2028_callback(void *ptr, int command,
> int arg)
> +{
> +    struct cx23885_tsport *port = ptr;
> +    struct cx23885_dev *dev = port->dev;
> +    u32 reset_mask = 0;
> +
> +    switch (command) {
> +    case XC2028_TUNER_RESET:
> +        dprintk(1, "%s: XC2028_TUNER_RESET %d\n", __func__,
> +            arg);
> +        reset_mask = 0x00070404;
> +
> +        cx_clear(GP0_IO, reset_mask);
> +        mdelay(5);
> +        cx_set(GP0_IO, reset_mask);
> +        break;
> +    case XC2028_RESET_CLK:
> +        dprintk(1, "%s: XC2028_RESET_CLK %d\n", __func__, arg);
> +        break;
> +    default:
> +        dprintk(1, "%s: unknown command %d, arg %d\n", __func__,
> +               command, arg);
> +        return -EINVAL;
> +    }
> +
> +    return 0;
> +}
> +
> +static struct zl10353_config dvico_fusionhdtv_xc3028 = {
> +    .demod_address = 0x0f,
> +    .if2           = 45600,
> +    .no_tuner      = 1,
> +};
> +
>  static struct s5h1409_config hauppauge_hvr1500q_config = {
>      .demod_address = 0x32 >> 1,
>      .output_mode   = S5H1409_SERIAL_OUTPUT,
> @@ -481,6 +516,32 @@
>                  &i2c_bus->i2c_adap,
>                  &dvico_xc5000_tunerconfig, i2c_bus);
>          break;
> +    case CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H:
> +        i2c_bus = &dev->i2c_bus[0];
> +
> +        port->dvb.frontend = dvb_attach(zl10353_attach,
> +                           &dvico_fusionhdtv_xc3028,
> +                           &i2c_bus->i2c_adap);
> +        if (port->dvb.frontend != NULL) {
> +            struct dvb_frontend      *fe;
> +            struct xc2028_config      cfg = {
> +                .i2c_adap  = &dev->i2c_bus[1].i2c_adap,
> +                .i2c_addr  = 0x61,
> +                .video_dev = port,
> +                .callback  = cx23885_leadtek_xc2028_callback,
> +            };
> +            static struct xc2028_ctrl ctl = {
> +                .fname       = "xc3028-v27.fw",
> +                .max_len     = 64,
> +                .demod       = XC3028_FE_ZARLINK456,
> +            };
> +
> +            fe = dvb_attach(xc2028_attach, port->dvb.frontend,
> +                    &cfg);
> +            if (fe != NULL && fe->ops.tuner_ops.set_config != NULL)
> +                fe->ops.tuner_ops.set_config(fe, &ctl);
> +        }
> +        break;
>      default:
>          printk("%s: The frontend of your DVB/ATSC card isn't
> supported yet\n",
>                 dev->name);
> diff -Naur cx23885-sram/linux/drivers/media/video/cx23885/cx23885.h
> cx23885-sram_dev/linux/drivers/media/video/cx23885/cx23885.h
> --- cx23885-sram/linux/drivers/media/video/cx23885/cx23885.h
> 2008-08-04 20:29:17.000000000 +1000
> +++ cx23885-sram_dev/linux/drivers/media/video/cx23885/cx23885.h
> 2008-08-04 20:48:39.000000000 +1000
> @@ -67,6 +67,7 @@
>  #define CX23885_BOARD_HAUPPAUGE_HVR1700        8
>  #define CX23885_BOARD_HAUPPAUGE_HVR1400        9
>  #define CX23885_BOARD_DVICO_FUSIONHDTV_7_DUAL_EXP 10
> +#define CX23885_BOARD_LEADTEK_WINFAST_PXDVR3200_H 11
>  
>  /* Currently unsupported by the driver: PAL/H, NTSC/Kr, SECAM
> B/G/H/LC */
>  #define CX23885_NORMS (\
> diff -Naur cx23885-sram/linux/drivers/media/video/cx23885/Kconfig
> cx23885-sram_dev/linux/drivers/media/video/cx23885/Kconfig
> --- cx23885-sram/linux/drivers/media/video/cx23885/Kconfig
> 2008-08-04 20:29:17.000000000 +1000
> +++ cx23885-sram_dev/linux/drivers/media/video/cx23885/Kconfig
> 2008-08-04 20:49:05.000000000 +1000
> @@ -15,6 +15,7 @@
>      select MEDIA_TUNER_MT2131 if !DVB_FE_CUSTOMISE
>      select DVB_S5H1409 if !DVB_FE_CUSTOMISE
>      select DVB_LGDT330X if !DVB_FE_CUSTOMISE
> +     select DVB_ZL10353 if !DVB_FE_CUSTOMISE
>      select MEDIA_TUNER_XC2028 if !DVB_FE_CUSTOMIZE
>      select MEDIA_TUNER_TDA8290 if !DVB_FE_CUSTOMIZE
>      select MEDIA_TUNER_TDA18271 if !DVB_FE_CUSTOMIZE
> 
> 
> -- 
> Be Yourself @ mail.com!
> Choose From 200+ Email Addresses
> Get a Free Account at www.mail.com!


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
