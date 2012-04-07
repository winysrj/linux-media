Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:54404 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367Ab2DGHZn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Apr 2012 03:25:43 -0400
Received: by wibhr17 with SMTP id hr17so1010710wib.1
        for <linux-media@vger.kernel.org>; Sat, 07 Apr 2012 00:25:42 -0700 (PDT)
Message-ID: <4F7FEBF3.6060402@gmail.com>
Date: Sat, 07 Apr 2012 09:25:39 +0200
From: poma <pomidorabelisima@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org, maximlevitsky@gmail.com
Subject: Re: RTL28XX driver
References: <CAKZ=SG-pmn2BtqB+ihY9H9bvYCZq-E3uBsSaioPF5SRceq9iDg@mail.gmail.com>
In-Reply-To: <CAKZ=SG-pmn2BtqB+ihY9H9bvYCZq-E3uBsSaioPF5SRceq9iDg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/06/2012 11:11 AM, Thomas Mair wrote:
> Hello everyone,
> 
> i own a TerraTec Cinergy T Stick Black device, and was able to find a
> working driver for the device. It seems to be, that the driver was
> originally written by Realtek and has since been updated by different
> Developers to meet DVB API changes. I was wondering what would be the
> necessary steps to include the driver into the kernel sources?
> 
> The one thing that needs to be solved before even thinking about the
> integration, is the licencing of the code. I did find it on two
> different locations, but without any licencing information. So
> probably Realtek should be contacted. I am willing to deal with that,
> but need furter information on under whitch lisence the code has to be
> relased.
> 
> So far, I put up a Github repository for the driver, which enables me
> to compile the proper kernel modue at
> https://github.com/tmair/DVB-Realtek-RTL2832U-2.2.2-10tuner-mod_kernel-3.0.0
> The modificatioins to the driver where taken from openpli
> http://openpli.git.sourceforge.net/git/gitweb.cgi?p=openpli/openembedded;a=blob;f=recipes/linux/linux-etxx00/dvb-usb-rtl2832.patch;h=063114c8ce4a2dbcf8c8dde1b4ab4f8e329a2afa;hb=HEAD

modinfo dvb_usb_rtl2832
filename:
/lib/modules/3.3.1-2.fc16.x86_64/kernel/drivers/media/dvb/dvb-usb/dvb-usb-rtl2832.ko
license:        GPL
version:        2.2.2
description:    Driver for the RTL2832U DVB-T / RTL2836 DTMB USB2.0 device
author:         Dean Chung<DeanChung@realtek.com>
author:         Chialing Lu <chialing@realtek.com>
author:         Realtek
srcversion:     533BB7E5866E52F63B9ACCB
alias:          usb:v0CCDp00E0d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0CCDp00D4d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0CCDp00D3d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0413p6A03d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1680pA332d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v185Bp9520d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v185Bp9530d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v185Bp9540d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v185Bp9550d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v185Bp9580d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v185Bp0680d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v185Bp0650d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v185Bp0640d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v185Bp0630d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v185Bp0620d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1164p3284d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1164p3280d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1164p6601d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0413p6F11d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0413p6680d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1F4DpA683d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1F4Dp0139d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1F4DpD286d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1F4DpC280d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1F4DpD803d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1F4DpC803d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1F4DpB803d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1F4DpA803d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1F4Dp0837d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1B80pE41Dd*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1B80pD3A4d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1B80pD3A1d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1B80pE77Bd*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1B80pD39Ed*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1B80pD39Cd*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1B80pD39Bd*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1B80pD39Ad*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1B80pD398d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1B80pD397d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1B80pD396d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1B80pD395d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1B80pD394d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1B80pD393d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1554p5026d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1554p5020d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1554p5013d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v13D3p3282d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v13D3p3274d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v13D3p3234d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0CCDp00B3d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0CCDp00A9d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1D19p9202d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1D19p3103d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1D19p9201d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1D19p8202d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1D19p2101d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1D19p1108d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1D19p1107d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1D19p1106d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1D19p1105d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1D19p1104d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1D19p1103d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1D19p1102d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1D19p1101d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0BDAp2825d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0BDAp2824d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0BDAp2811d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0BDAp2810d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0BDAp2823d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0BDAp2822d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0BDAp2821d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0BDAp2820d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0BDAp2837d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0BDAp2834d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0BDAp2841d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0BDAp2840d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0BDAp2839d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0BDAp2836d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0BDAp2838d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0BDAp2832d*dc*dsc*dp*ic*isc*ip*
depends:        dvb-usb
vermagic:       3.3.1-2.fc16.x86_64 SMP mod_unload
parm:           debug:Set debugging level (0=disable, 1=info, 2=xfer,
4=rc (or-able)), default=0 (int)
parm:           demod:Set default demod type (0=dvb-t, 1=dtmb, 2=dvb-c),
default=0 (int)
parm:           dtmb_err_discard:Set error packet discard type (0=not
discard, 1=discard), default=0 (int)
parm:           rtl2832u_rc_mode:Set default rtl2832u_rc_mode (0=rc6,
1=rc5, 2=nec, 3=disable rc), default=3 (int)
parm:           rtl2832u_card_type:Set default rtl2832u_card_type type
(0=dongle, 1=mini card), default=0 (int)
parm:           snrdb:SNR type output (0=16bit, 1=dB decibel), default=0
(int)
parm:           adapter_nr:DVB adapter numbers (array of short)

dmesg
dvb-usb: found a 'DVB-T TV Stick' in warm state.
dvb-usb: will pass the complete MPEG2 transport stream to the software
demuxer.
DVB: registering new adapter (DVB-T TV Stick)
RTL2832U usb_init_bulk_setting : USB2.0 HIGH SPEED (480Mb/s)
RTL2832U check_tuner_type : FC0012 tuner on board...
DVB: registering adapter 2 frontend 0 (Realtek DVB-T RTL2832)...
dvb-usb: DVB-T TV Stick successfully initialized and connected.

btw there is a git repo at https://gitorious.org/rtl2832 by Maxim
tnx for standalone ver, tnx Gianluca for >=3.3 patch

> In the driver sources I stumbled accross many different devices
> containig the RTL28XX chipset, so I suppose the driver would enably
> quite many products to work.
> 
> As I am relatively new to the developement of dvb drivers I appreciate
> any help in stabilizing the driver and proper integration into the dvb
> API.
> 
> Greetings
> Thomas

rgds,
poma
