Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49030 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754477Ab1K2TpW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Nov 2011 14:45:22 -0500
Received: by bkas6 with SMTP id s6so936650bka.19
        for <linux-media@vger.kernel.org>; Tue, 29 Nov 2011 11:45:21 -0800 (PST)
Message-ID: <4ED5364B.9070106@gmail.com>
Date: Tue, 29 Nov 2011 20:45:15 +0100
From: poma <pomidorabelisima@gmail.com>
MIME-Version: 1.0
To: Maik Zumstrull <maik@zumstrull.net>, linux-media@vger.kernel.org
Subject: Re: Status of RTL283xU support?
References: <CAO=zWDJD19uCJJfdZQVQzHOSxLcXb11D+Avw--YV5mCk8qxPww@mail.gmail.com> <CAO=zWDJREu+AomDtuWTf5CaTwJh4BbQ79b4BtYJODhGvTqW9fg@mail.gmail.com>
In-Reply-To: <CAO=zWDJREu+AomDtuWTf5CaTwJh4BbQ79b4BtYJODhGvTqW9fg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 26.11.2011 17:20, Maik Zumstrull wrote:
> On Sat, Nov 26, 2011 at 13:47, Maik Zumstrull <maik@zumstrull.net> wrote:
..

> FYI, someone has contacted me off-list to point out that the newest(?)
> Realtek tree for these devices is available online:
> 
> Alessandro Ambrosini wrote:
> 
>> Dear maik,
>>
>> I've read your post here
>> http://www.mail-archive.com/linux-media@vger.kernel.org/msg39559.html
>> I have not a subscription to linux-media mailing list. I see your post
>> looking for in archive.
>>
>> Some days ago I've asked to Realtek if there are newer driver (latest on the
>> net was 2.2.0)
>> They kindly send me latest driver 2.2.2 kernel 2.6.x
>>
>> I've patched it yesterday for kernel 3.0.0 (Ubuntu 11.10) and they looks to
>> work fine.
>> I'm not an expert C coder, only an hobbyist. So I suppose there are
>> problems.
>>
>> Anyway here you can find:
>>
>> 1) original Realtek 2.2.2 driver "simplified version" (DVB-T only and 4
>> tuners only)
>> https://github.com/ambrosa/DVB-Realtek-RTL2832U-2.2.2-4_tuner
>>
>> 2) original Realtek 2.2.2 driver "full version" (DVB-T/ DTMB and 10 tuners)
>> https://github.com/ambrosa/DVB-Realtek-RTL2832U-2.2.2-10_tuner
>>
>> 3) driver "full" modded by me for kernel 3.0.0
>> https://github.com/ambrosa/DVB-Realtek-RTL2832U-2.2.2-10tuner-mod_kernel-3.0.0
>> README file explain about all
>>
>> They compile fine in Ubuntu 11.10 64 bit and works great.
..

Distro - Fedora release 16 (Verne)/3.1.2-1.fc16.x86_64
Device - DeLOCK USB 2.0 DVB-T Receiver 61744
http://www.delock.com/produkte/gruppen/Multimedia/Delock_USB_20_DVB-T_Receiver_61744.html
based on:
Realtek RTL2832U DVB-T demodulator-USB bridge & Fitipower FC0012 tuner

lsusb:
Bus 002 Device 003: ID 1f4d:b803 G-Tek Electronics Group Lifeview
LV5TDLX DVB-T [RTL2832U]

modinfo dvb_usb_rtl2832u:
filename:
/lib/modules/3.1.2-1.fc16.x86_64/kernel/drivers/media/dvb/dvb-usb/dvb-usb-rtl2832u.ko
license:        GPL
version:        2.2.2
description:    Driver for the RTL2832U DVB-T / RTL2836 DTMB USB2.0 device
author:         Dean Chung<DeanChung@realtek.com>
author:         Chialing Lu <chialing@realtek.com>
author:         Realtek
srcversion:     82E6C8E24DEE7DCA47B605E
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
vermagic:       3.1.2-1.fc16.x86_64 SMP mod_unload
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
parm:           adapter_nr:DVB adapter numbers (array of short)

dmesg:
dvb-usb: found a 'DVB-T TV Stick' in warm state.
dvb-usb: will pass the complete MPEG2 transport stream to the software
demuxer.
DVB: registering new adapter (DVB-T TV Stick)
RTL2832U usb_init_bulk_setting : USB2.0 HIGH SPEED (480Mb/s)
RTL2832U check_tuner_type : FC0012 tuner on board...
DVB: registering adapter 2 frontend 0 (Realtek DVB-T RTL2832)...
input: IR-receiver inside an USB DVB receiver as
/devices/pci0000:00/0000:00:04.1/usb2/2-2/input/input8
dvb-usb: schedule remote query interval to 287 msecs.
dvb-usb: DVB-T TV Stick successfully initialized and connected.
usbcore: registered new interface driver dvb_usb_rtl2832u
RTL2832U usb_init_bulk_setting : USB2.0 HIGH SPEED (480Mb/s)

git clone
git://github.com/ambrosa/DVB-Realtek-RTL2832U-2.2.2-10tuner-mod_kernel-3.0.0.git
cd DVB-Realtek-RTL2832U-2.2.2-10tuner-mod_kernel-3.0.0/
cd RTL2832-2.2.2_kernel-3.0.0/
Makefile:
KDIR = /usr/src/linux-headers-`uname -r`
change path - Fedora(kernel-devel):
KDIR = /usr/src/kernels/`uname -r`
make
su
make install

10x Maik 4 info & Alessandro 4 effort!
10x Realtek RD-team 4 source 2 ;)

rgds,
poma
