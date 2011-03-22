Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:27502 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757Ab1CVSxJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Mar 2011 14:53:09 -0400
Message-ID: <4D88F00D.5090308@redhat.com>
Date: Tue, 22 Mar 2011 15:53:01 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Wojciech Myrda <vojcek@tlen.pl>
CC: linux-media@vger.kernel.org
Subject: Re: Prof_Revolution_DVB-S2_8000_PCI-E & Linux Kernel 2.6.38-rc8-next-20110314
References: <4D86566B.9090803@tlen.pl>
In-Reply-To: <4D86566B.9090803@tlen.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 20-03-2011 16:32, Wojciech Myrda escreveu:

> It turns ot that revised patch not only applies cleanly but compiles as
> well agaist Linux Kernel 2.6.38-rc8-next-20110321. Looking at dmesg
> everything is recognized properly as well. Do you guys think if it is
> possible to include it into the tree?

Please post the patch again, with a few fixes (see bellow), and add your
Signed-off-by: (please read how to submit patches section at linuxtv.org wiki
for more details). 


> diff -r 1da5fed5c8b2 linux/drivers/media/video/cx23885/cx23885-cards.c
> --- a/linux/drivers/media/video/cx23885/cx23885-cards.c	Sun Sep 19 02:23:09 2010 -0300
> +++ b/linux/drivers/media/video/cx23885/cx23885-cards.c	Sat Oct 02 11:19:50 2010 +0300

/linux? Are you using the old -hg tree? Please don't do that. The mercurial
tree is not touched for the last 8 months! Please use, instead the media_tree.git
(media_build.git allows you to compile/test a driver against the media_tree.git tree). 

> @@ -169,6 +169,10 @@
>  		.name		= "TurboSight TBS 6920",
>  		.portb		= CX23885_MPEG_DVB,
>  	},
> +	[CX23885_BOARD_PROF_8000] = {
> +		.name		= "Prof Revolution DVB-S2 8000",
> +		.portb		= CX23885_MPEG_DVB,
> +	},
>  	[CX23885_BOARD_TEVII_S470] = {
>  		.name		= "TeVii S470",
>  		.portb		= CX23885_MPEG_DVB,
> @@ -388,6 +392,10 @@
>  		.subdevice = 0x8888,
>  		.card      = CX23885_BOARD_TBS_6920,
>  	}, {
> +		.subvendor = 0x8000,
> +		.subdevice = 0x3034,
> +		.card      = CX23885_BOARD_PROF_8000,
> +	}, {
>  		.subvendor = 0xd470,
>  		.subdevice = 0x9022,
>  		.card      = CX23885_BOARD_TEVII_S470,
> @@ -813,6 +821,7 @@
>  		mdelay(20);
>  		cx_set(GP0_IO, 0x00040004);
>  		break;
> +	case CX23885_BOARD_PROF_8000:
>  	case CX23885_BOARD_TBS_6920:
>  		cx_write(MC417_CTL, 0x00000036);
>  		cx_write(MC417_OEN, 0x00001000);
> @@ -1043,6 +1052,7 @@
>  		ts1->ts_clk_en_val = 0x1; /* Enable TS_CLK */
>  		ts1->src_sel_val   = CX23885_SRC_SEL_PARALLEL_MPEG_VIDEO;
>  		break;
> +	case CX23885_BOARD_PROF_8000:
>  	case CX23885_BOARD_TEVII_S470:
>  	case CX23885_BOARD_DVBWORLD_2005:
>  		ts1->gen_ctrl_val  = 0x5; /* Parallel */
> --- a/linux/drivers/media/video/cx23885/cx23885-dvb.c.old	2011-03-20 08:20:37.384001338 +0100
> +++ b/linux/drivers/media/video/cx23885/cx23885-dvb.c	2011-03-20 08:29:56.757001476 +0100
> @@ -47,6 +47,9 @@
>  #include "dibx000_common.h"
>  #include "zl10353.h"
>  #include "stv0900.h"
> +#include "stb6100.h"
> +#include "stb6100_proc.h"
> +#include "stv0900.h"

If you're adding more dependencies here, you'll need to touch also drivers/media/video/cx23885/Kconfig
in order to select the right frontends.

>  #include "stv0900_reg.h"
>  #include "stv6110.h"
>  #include "lnbh24.h"
> @@ -478,6 +478,35 @@
>  	.if_khz = 5380,
>  };
>  
> +static int p8000_set_voltage(struct dvb_frontend *fe, fe_sec_voltage_t voltage)
> +{
> +	struct cx23885_tsport *port = fe->dvb->priv;
> +	struct cx23885_dev *dev = port->dev;
> +
> +	if (voltage == SEC_VOLTAGE_18)
> +		cx_write(MC417_RWD, 0x00001e00);
> +	else if (voltage == SEC_VOLTAGE_13)
> +		cx_write(MC417_RWD, 0x00001a00);
> +	else
> +		cx_write(MC417_RWD, 0x00001800);
> +	return 0;
> +}
> +
> +static struct stv0900_config prof_8000_stv0900_config = {
> +	.demod_address = 0x6a,
> +	.xtal = 27000000,
> +	.clkmode = 3,
> +	.diseqc_mode = 2,
> +	.tun1_maddress = 0,
> +	.tun1_adc = 0,
> +	.path1_mode = 3,
> +};
> +
> +static struct stb6100_config prof_8000_stb6100_config = {
> +	.tuner_address = 0x60,
> +	.refclock = 27000000,
> +};
> +
>  static int cx23885_dvb_set_frontend(struct dvb_frontend *fe,
>  				    struct dvb_frontend_parameters *param)
>  {
> @@ -1094,6 +1123,29 @@
>  				goto frontend_detach;
>  		}
>  		break;
> +	case CX23885_BOARD_PROF_8000: {
> +		struct dvb_tuner_ops *tuner_ops = NULL;
> +
> +		i2c_bus = &dev->i2c_bus[0];
> +		fe0->dvb.frontend = dvb_attach(stv0900_attach,
> +						&prof_8000_stv0900_config,
> +						&i2c_bus->i2c_adap, 0);
> +		if (fe0->dvb.frontend != NULL) {
> +			if (dvb_attach(stb6100_attach, fe0->dvb.frontend,
> +					&prof_8000_stb6100_config,
> +					&i2c_bus->i2c_adap)) {
> +				tuner_ops = &fe0->dvb.frontend->ops.tuner_ops;
> +				tuner_ops->set_frequency = stb6100_set_freq;
> +				tuner_ops->get_frequency = stb6100_get_freq;
> +				tuner_ops->set_bandwidth = stb6100_set_bandw;
> +				tuner_ops->get_bandwidth = stb6100_get_bandw;
> +
> +				fe0->dvb.frontend->ops.set_voltage =
> +							p8000_set_voltage;
> +			}
> +		}
> +		break;
> +		}
>  	default:
>  		printk(KERN_INFO "%s: The frontend of your DVB/ATSC card "
>  			" isn't supported yet\n",
> --- a/linux/drivers/media/video/cx23885/cx23885.h.old	2011-03-20 08:33:15.159001527 +0100
> +++ b/linux/drivers/media/video/cx23885/cx23885.h	2011-03-20 08:34:32.244001547 +0100
> @@ -86,6 +86,7 @@
>  #define CX23885_BOARD_LEADTEK_WINFAST_PXTV1200 28
>  #define CX23885_BOARD_GOTVIEW_X5_3D_HYBRID     29
>  #define CX23885_BOARD_NETUP_DUAL_DVB_T_C_CI_RF 30
> +#define CX23885_BOARD_PROF_8000                31
>  
>  #define GPIO_0 0x00000001
>  #define GPIO_1 0x00000002

