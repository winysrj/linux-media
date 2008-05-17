Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from outbound.icp-qv1-irony-out2.iinet.net.au ([203.59.1.107])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <sonofzev@iinet.net.au>) id 1JxKZa-0003H8-9y
	for linux-dvb@linuxtv.org; Sat, 17 May 2008 13:27:40 +0200
From: allan k <sonofzev@iinet.net.au>
To: stev391@email.com
In-Reply-To: <20080514055431.D014A104F0@ws1-3.us4.outblaze.com>
References: <20080514055431.D014A104F0@ws1-3.us4.outblaze.com>
Date: Sat, 17 May 2008 21:27:19 +1000
Message-Id: <1211023639.8225.2.camel@media1>
Mime-Version: 1.0
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] DViCO Fusion HDTV DVB-T Dual Express [PATCH]
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

Hi Steve 

I'm getting a large amount of noise again, although after previous
restarts this didn't happen. 

I'm wondering if your patch is already merged into the v4l sources or if
I need to use this one you sent. 

cheers

Allan 
On Wed, 2008-05-14 at 15:54 +1000, stev391@email.com wrote:
> 
> I have updated my patch (from a week ago) and is included inline below
> as well as an attachment. The issue that was noticed and mentioned in
> previous posts regarding to tuners not resetting was possibly due to
> several "__FUNCTION_" in the tuner reset code, these should be
> "__func__", which is fixed in the attached patch.
> 
> This patch is against the v4l-dvb head (7897, 2e9a2e4c8435) and is
> intended to merge Chris Pascoe's work into the current head to enable
> support for the DViCO Fusion HDTV DVB-T Dual Express (PCIe).  This
> enables systems with different tuners to take advantage of other
> experimental drivers, (for example my TV Walker Twin USB tuner).
> 
> Regards,
> 
> Stephen
> 
> diff -Naur v4l-dvb/linux/Documentation/video4linux/CARDLIST.cx23885
> v4l-dvb_dev/linux/Documentation/video4linux/CARDLIST.cx23885
> --- v4l-dvb/linux/Documentation/video4linux/CARDLIST.cx23885
> 2008-05-14 09:48:21.000000000 +1000
> +++ v4l-dvb_dev/linux/Documentation/video4linux/CARDLIST.cx23885
> 2008-05-14 13:39:30.000000000 +1000
> @@ -8,3 +8,4 @@
>    7 -> Hauppauge WinTV-HVR1200
> [0070:71d1,0070:71d3]
>   ;  8 -> Hauppauge WinTV-HVR1700
> [0070:8101]
>    9 -> Hauppauge WinTV-HVR1400
> [0070:8010]
> + 10 -> DViCO FusionHDTV DVB-T Dual Express
> [18ac:db78]
> diff -Naur v4l-dvb/linux/drivers/media/video/cx23885/cx23885-cards.c
> v4l-dvb_dev/linux/drivers/media/video/cx23885/cx23885-cards.c
> --- v4l-dvb/linux/drivers/media/video/cx23885/cx23885-cards.c
> 2008-05-14 09:48:22.000000000 +1000
> +++ v4l-dvb_dev/linux/drivers/media/video/cx23885/cx23885-cards.c
> 2008-05-14 13:39:30.000000000 +1000
> @@ -144,6 +144,11 @@
>          .name        = "Hauppauge WinTV-HVR1400",
>          .portc        = CX23885_MPEG_DVB,
>      },
> +    [CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP] = {
> +        .name        = "DViCO FusionHDTV DVB-T Dual Express",
> +        .portb        = CX23885_MPEG_DVB,
> +        .portc        = CX23885_MPEG_DVB,
> +    },
>  };
>  const unsigned int cx23885_bcount = ARRAY_SIZE(cx23885_boards);
>  
> @@ -211,6 +216,10 @@
>          .subvendor = 0x0070,
>          .subdevice = 0x8010,
>          .card      = CX23885_BOARD_HAUPPAUGE_HVR1400,
> +    },{
> +        .subvendor = 0x18ac,
> +        .subdevice = 0xdb78,
> +        .card      = CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP,
>      },
>  };
>  const unsigned int cx23885_idcount = ARRAY_SIZE(cx23885_subids);
> @@ -428,6 +437,13 @@
>          mdelay(20);
>          cx_set(GP0_IO, 0x00050005);
>          break;
> +    case CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP:
> +        /* GPIO-0 portb xc3028 reset */
> +        /* GPIO-1 portb zl10353 reset */
> +        /* GPIO-2 portc xc3028 reset */
> +        /* GPIO-3 portc zl10353 reset */
> +        cx_write(GP0_IO, 0x002f1000);
> +        break;
>      }
>  }
>  
> @@ -442,6 +458,9 @@
>      case CX23885_BOARD_HAUPPAUGE_HVR1400:
>          /* FIXME: Implement me */
>          break;
> +    case CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP:
> +        request_module("ir-kbd-i2c");
> +        break;
>      }
>  
>      return 0;
> @@ -478,6 +497,11 @@
>      }
>  
>      switch (dev->board) {
> +    case CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP:
> +        ts2->gen_ctrl_val  = 0xc; /* Serial bus + punctured clock */
> +        ts2->ts_clk_en_val = 0x1; /* Enable TS_CLK */
> +        ts2->src_sel_val   = CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO;
> +        /* FALLTHROUGH */
>      case CX23885_BOARD_DVICO_FUSIONHDTV_5_EXP:
>          ts1->gen_ctrl_val  = 0xc; /* Serial bus + punctured clock */
>          ts1->ts_clk_en_val = 0x1; /* Enable TS_CLK */
> diff -Naur v4l-dvb/linux/drivers/media/video/cx23885/cx23885-dvb.c
> v4l-dvb_dev/linux/drivers/media/video/cx23885/cx23885-dvb.c
> --- v4l-dvb/linux/drivers/media/video/cx23885/cx23885-dvb.c
> 2008-05-14 09:48:22.000000000 +1000
> +++ v4l-dvb_dev/linux/drivers/media/video/cx23885/cx23885-dvb.c
> 2008-05-14 13:39:30.000000000 +1000
> @@ -42,6 +42,9 @@
>  #include "tuner-simple.h"
>  #include "dib7000p.h"
>  #include "dibx000_common.h"
> +#include "zl10353.h"
> +#include "tuner-xc2028.h"
> +#include "tuner-xc2028-types.h"
>  
>  static unsigned int debug;
>  
> @@ -155,6 +158,44 @@
>      .serial_mpeg = 0x40,
>  };
>  
> +static int cx23885_dvico_xc2028_callback(void *ptr, int command, int
> arg)
> +{
> +    struct cx23885_tsport *port = ptr;
> +    struct cx23885_dev *dev = port->dev;
> +    u32 reset_mask = 0;
> +
> +    switch (command) {
> +    case XC2028_TUNER_RESET:
> +        dprintk(1, "%s: XC2028_TUNER_RESET %d, port %d\n", __func__,
> +            arg, port->nr);
> +
> +        if (port->nr == 1)
> +            reset_mask = 0x0101;
> +        else if (port->nr == 2)
> +            reset_mask = 0x0404;
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
> @@ -454,6 +495,39 @@
>                  fe->ops.tuner_ops.set_config(fe, &ctl);
>          }
>          break;
> +    case CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP: {
> +        i2c_bus = &dev->i2c_bus[port->nr - 1];
> +
> +        /* Take demod and tuner out of reset */
> +        if (port->nr == 1)
> +            cx_set(GP0_IO, 0x0303);
> +        else if (port->nr == 2)
> +            cx_set(GP0_IO, 0x0c0c);
> +        mdelay(5);
> +        port->dvb.frontend = dvb_attach(zl10353_attach,
> +                           &dvico_fusionhdtv_xc3028,
> +                           &i2c_bus->i2c_adap);
> +        if (port->dvb.frontend != NULL) {
> +            struct dvb_frontend      *fe;
> +            struct xc2028_config      cfg = {
> +                .i2c_adap  = &i2c_bus->i2c_adap,
> +                .i2c_addr  = 0x61,
> +                .video_dev = port,
> +                .callback  = cx23885_dvico_xc2028_callback,
> +            };
> +            static struct xc2028_ctrl ctl = {
> +                .fname       = "xc3028-dvico-au-01.fw",
> +                .max_len     = 64,
> +                .scode_table = ZARLINK456,
> +            };
> +
> +            fe = dvb_attach(xc2028_attach, port->dvb.frontend,
> +                    &cfg);
> +            if (fe != NULL && fe->ops.tuner_ops.set_config != NULL)
> +                fe->ops.tuner_ops.set_config(fe, &ctl);
> +        }
> +        break;
> +        }
>      default:
>          printk("%s: The frontend of your DVB/ATSC card isn't
> supported yet\n",
>                 dev->name);
> diff -Naur v4l-dvb/linux/drivers/media/video/cx23885/cx23885.h
> v4l-dvb_dev/linux/drivers/media/video/cx23885/cx23885.h
> --- v4l-dvb/linux/drivers/media/video/cx23885/cx23885.h    2008-05-14
> 09:48:22.000000000 +1000
> +++ v4l-dvb_dev/linux/drivers/media/video/cx23885/cx23885.h
> 2008-05-14 13:39:30.000000000 +1000
> @@ -66,6 +66,7 @@
>  #define CX23885_BOARD_HAUPPAUGE_HVR1200        7
>  #define CX23885_BOARD_HAUPPAUGE_HVR1700        8
>  #define CX23885_BOARD_HAUPPAUGE_HVR1400        9
> +#define CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP 10
>  
>  /* Currently unsupported by the driver: PAL/H, NTSC/Kr, SECAM
> B/G/H/LC */
>  #define CX23885_NORMS (\
> diff -Naur v4l-dvb/linux/drivers/media/video/cx23885/Kconfig
> v4l-dvb_dev/linux/drivers/media/video/cx23885/Kconfig
> --- v4l-dvb/linux/drivers/media/video/cx23885/Kconfig    2008-05-14
> 09:48:22.000000000 +1000
> +++ v4l-dvb_dev/linux/drivers/media/video/cx23885/Kconfig
> 2008-05-14 13:39:30.000000000 +1000
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
> 
> -- 
> See Exclusive Video: 10th Annual Young Hollywood Awards
> 

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
