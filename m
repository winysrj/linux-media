Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9295 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754433Ab3C2Kig (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Mar 2013 06:38:36 -0400
Date: Fri, 29 Mar 2013 07:38:30 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: dani <dgcbueu@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] [cx88] fix Geniatech X8000-MT dvb card support
Message-ID: <20130329073830.17af0e05@redhat.com>
In-Reply-To: <CABwr4_s7W=cBUYROR7niggJhdL2X5dkc80yjj1nVGEfLYUT_dw@mail.gmail.com>
References: <CABwr4_s7W=cBUYROR7niggJhdL2X5dkc80yjj1nVGEfLYUT_dw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 25 Mar 2013 18:52:37 +0100
dani <dgcbueu@gmail.com> escreveu:

> Spite the Geniatech X8000-MT dvb card is added long time ago to the
> kernel, it never worked. I have one of this cards branded as notOnlyTV
> LV3H http://www.linuxtv.org/wiki/index.php/NotOnlyTV_LV3H and it seems
> the gpios are wrong among other things. As I wrote in the linuxtv wiki
> entry this card works passing the options to work as a Leadtek WinFast
> DTV1800 Hybrid. Not fully tested but the important part (DVB) works
> fine with minor issues like dmesg floods with the message "Calling
> XC2028/3028 callback", but I don't know if this problem exists with
> other cards.
> 
> This is the board
> http://www.linuxtv.org/wiki/images/4/4a/X8000T-DVBT-PCI.jpg exactly
> the same as mine, and other boards like X3M HPC2000, or Jactek JH-600.
> I insist with the current code none of this boards work, all forums I
> visited people reported the card doesn't work. I tested the patch
> against 3.2.0-39 (my card is installed in a machine with Ubuntu
> 12.04.2 LTS), but I made the patch for what's currently in linux-tv
> git.

It seems very likely that there are two versions of the same card out
there, perhaps with a different wiring. This is not uncommon: some
vendors just change the board revision for whatever reason, and that
requires a different board entry for the same device's brand name.
On several such cases, the vendor even don't care to use a different
PCI (or USB) ID.

On a few of those devices, it is possible to discover the device
type by looking at the eeprom or doing some tests.

However, in order to do that, we would need to find someone with
some development knowledge and with the other revision of the
board.

So, instead of changing this entry, please add a new one that will
do the initialization for your board.

> 
> Signed-off-by: Daniel Gonzalez <dgcbueu< at >gmail.com>
> --- a/drivers/media/pci/cx88/cx88-cards.c
> +++ b/drivers/media/pci/cx88/cx88-cards.c
> @@ -1753,37 +1753,38 @@
>  	},
>  	[CX88_BOARD_GENIATECH_X8000_MT] = {
>  		/* Also PowerColor Real Angel 330 and Geniatech X800 OEM */
> +		/* Works like Leadtek WinFast DTV1800 Hybrid */

Had you just tested with the dtv1800, or did you use dscaler's regspy.exe
to get the proper GPIO values for this board?

>  		.name           = "Geniatech X8000-MT DVBT",
>  		.tuner_type     = TUNER_XC2028,
>  		.tuner_addr     = 0x61,
>  		.input          = { {
>  			.type   = CX88_VMUX_TELEVISION,
>  			.vmux   = 0,
> -			.gpio0  = 0x00000000,
> -			.gpio1  = 0x00e3e341,
> -			.gpio2  = 0x00000000,
> -			.gpio3  = 0x00000000,
> +			.gpio0  = 0x0400,
> +			.gpio1  = 0x6040,
> +			.gpio2  = 0x0000,
> +			.gpio3  = 0x0000,
>  		}, {
>  			.type   = CX88_VMUX_COMPOSITE1,
>  			.vmux   = 1,
> -			.gpio0  = 0x00000000,
> -			.gpio1  = 0x00e3e361,
> -			.gpio2  = 0x00000000,
> -			.gpio3  = 0x00000000,
> +			.gpio0  = 0x0400,
> +			.gpio1  = 0x6060,
> +			.gpio2  = 0x0000,
> +			.gpio3  = 0x0000,
>  		}, {
>  			.type   = CX88_VMUX_SVIDEO,
>  			.vmux   = 2,
> -			.gpio0  = 0x00000000,
> -			.gpio1  = 0x00e3e361,
> -			.gpio2  = 0x00000000,
> -			.gpio3  = 0x00000000,
> +			.gpio0  = 0x0400,
> +			.gpio1  = 0x6060,
> +			.gpio2  = 0x0000,
> +			.gpio3  = 0x0000,
>  		} },
>  		.radio = {
>  			.type   = CX88_RADIO,
> -			.gpio0  = 0x00000000,
> -			.gpio1  = 0x00e3e341,
> -			.gpio2  = 0x00000000,
> -			.gpio3  = 0x00000000,
> +			.gpio0  = 0x0400,
> +			.gpio1  = 0x6000,
> +			.gpio2  = 0x0000,
> +			.gpio3  = 0x0000,
>  		},
>  		.mpeg           = CX88_MPEG_DVB,
>  	},
> @@ -3114,7 +3115,6 @@
>  	/* Board-specific callbacks */
>  	switch (core->boardnr) {
>  	case CX88_BOARD_POWERCOLOR_REAL_ANGEL:
> -	case CX88_BOARD_GENIATECH_X8000_MT:
>  	case CX88_BOARD_KWORLD_ATSC_120:
>  		return cx88_xc3028_geniatech_tuner_callback(core,
>  							command, arg);
> @@ -3124,6 +3124,7 @@
>  	case CX88_BOARD_DVICO_FUSIONHDTV_DVB_T_PRO:
>  	case CX88_BOARD_DVICO_FUSIONHDTV_5_PCI_NANO:
>  		return cx88_dvico_xc2028_callback(core, command, arg);
> +	case CX88_BOARD_GENIATECH_X8000_MT:
>  	case CX88_BOARD_WINFAST_TV2000_XP_GLOBAL:
>  	case CX88_BOARD_WINFAST_DTV1800H:
>  		return cx88_xc3028_winfast1800h_callback(core, command, arg);
> @@ -3333,6 +3334,7 @@
>  		udelay(1000);
>  		break;
> 
> +	case CX88_BOARD_GENIATECH_X8000_MT:
>  	case CX88_BOARD_WINFAST_TV2000_XP_GLOBAL:
>  	case CX88_BOARD_WINFAST_DTV1800H:
>  		cx88_xc3028_winfast1800h_callback(core, XC2028_TUNER_RESET, 0);
> @@ -3380,11 +3382,12 @@
>  		ctl->demod = XC3028_FE_OREN538;
>  		break;
>  	case CX88_BOARD_GENIATECH_X8000_MT:
> -		/* FIXME: For this board, the xc3028 never recovers after being
> -		   powered down (the reset GPIO probably is not set properly).
> -		   We don't have access to the hardware so we cannot determine
> -		   which GPIO is used for xc3028, so just disable power xc3028
> -		   power management for now */
> +		ctl->demod = XC3028_FE_ZARLINK456;
> +		if (core->i2c_algo.udelay < 16)
> +			core->i2c_algo.udelay = 16;
> +		/* FIXME: this avoids the kernel message:
> +		 xc2028 2-0061: Error on line 1212: -6
> +		 (the reset GPIO probably is not set properly)*/
>  		ctl->disable_power_mgmt = 1;
>  		break;
>  	case CX88_BOARD_WINFAST_TV2000_XP_GLOBAL:
> --- a/drivers/media/pci/cx88/cx88-dvb.c
> +++ b/drivers/media/pci/cx88/cx88-dvb.c
> @@ -544,7 +544,8 @@
>  static const struct zl10353_config cx88_geniatech_x8000_mt = {
>  	.demod_address = (0x1e >> 1),
>  	.no_tuner = 1,
> -	.disable_i2c_gate_ctrl = 1,
> +	//.disable_i2c_gate_ctrl = 1,
> +	.if2           = 45600,
>  };
> 
>  static const struct s5h1411_config dvico_fusionhdtv7_config = {
> @@ -1365,13 +1366,15 @@
>  		}
>  		break;
>  	case CX88_BOARD_GENIATECH_X8000_MT:
> -		dev->ts_gen_cntrl = 0x00;
> 
>  		fe0->dvb.frontend = dvb_attach(zl10353_attach,
>  					       &cx88_geniatech_x8000_mt,
>  					       &core->i2c_adap);
> -		if (attach_xc3028(0x61, dev) < 0)
> -			goto frontend_detach;
> +		if (fe0->dvb.frontend) {
> +			fe0->dvb.frontend->ops.i2c_gate_ctrl = NULL;
> +			if (attach_xc3028(0x61, dev) < 0)
> +				goto frontend_detach;
> +		}
>  		break;
>  	 case CX88_BOARD_KWORLD_ATSC_120:
>  		fe0->dvb.frontend = dvb_attach(s5h1409_attach,
> --- a/drivers/media/pci/cx88/cx88-input.c
> +++ b/drivers/media/pci/cx88/cx88-input.c
> @@ -98,6 +98,7 @@
>  		/* Take out the parity part */
>  		gpio=(gpio & 0x7fd) + (auxgpio & 0xef);
>  		break;
> +	case CX88_BOARD_GENIATECH_X8000_MT:
>  	case CX88_BOARD_WINFAST_DTV1000:
>  	case CX88_BOARD_WINFAST_DTV1800H:
>  	case CX88_BOARD_WINFAST_DTV1800H_XC4000:
> @@ -290,6 +291,7 @@
>  		ir_codes = RC_MAP_HAUPPAUGE;
>  		ir->sampling = 1;
>  		break;
> +	case CX88_BOARD_GENIATECH_X8000_MT:
>  	case CX88_BOARD_WINFAST_DTV2000H:
>  	case CX88_BOARD_WINFAST_DTV2000H_J:
>  	case CX88_BOARD_WINFAST_DTV1800H:
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 

Cheers,
Mauro
