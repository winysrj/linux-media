Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from el-out-1112.google.com ([209.85.162.182])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mrechberger@gmail.com>) id 1Jrwf9-0002nB-CS
	for linux-dvb@linuxtv.org; Fri, 02 May 2008 16:55:06 +0200
Received: by el-out-1112.google.com with SMTP id y26so617610ele.11
	for <linux-dvb@linuxtv.org>; Fri, 02 May 2008 07:54:57 -0700 (PDT)
Message-ID: <d9def9db0805020754tbe8fcd1k1c2bbe2024c17d9a@mail.gmail.com>
Date: Fri, 2 May 2008 16:54:55 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "luc legrand" <legrandluc@gmail.com>
In-Reply-To: <9f2475180805020625nd6ff2a9ked408aa61ba3553@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <9f2475180805020625nd6ff2a9ked408aa61ba3553@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Avermedia M115 MiniPCI hybrid
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

On 5/2/08, luc legrand <legrandluc@gmail.com> wrote:
> Hi !
>
> I have an Avermedia M115 MiniPCI hybrid that worked very well (I only
> use DVB-T with kaffeine) using v4l-dvb-experimentral of Markus
> Rechberger until kernel 2.6.24.
> Some info about this TV tuner here :
> http://www.avermedia.com/cgi-bin/products_odm_M115.asp
> http://bttv-gallery.de/
>
> Since kernel 2.6.24 I don't find how to make it work so I decide to
> give a try to the v4l-dvb tree on linuxtv.org.
> I followed the installation instructions here (case 2) :
> http://www.linuxtv.org/wiki/index.php/How_to_install_DVB_device_drivers
> The compilation seems to go without errors
>
> Then I followed the instructions here for the firmware (section how to
> obtain the firmware) :
> http://www.linuxtv.org/wiki/index.php/Xceive_XC3018
>
> But kaffeine doesn't recognize the tv tuner.
>
> Here is dmesg | grep saa :
>
> saa7130/34: v4l2 driver version 0.2.14 loaded
> saa7133[0]: found at 0000:09:04.0, rev: 209, irq: 16, latency: 0,
> mmio: 0xd2005000
> saa7133[0]: subsystem: 1461:a836, board: Avermedia M115
> [card=138,autodetected]
> saa7133[0]: board init: gpio is a400000
> saa7133[0]: i2c eeprom 00: 61 14 36 a8 00 00 00 00 00 00 00 00 00 00 00 00
> saa7133[0]: i2c eeprom 10: ff ff ff ff ff 20 ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 20: 01 40 01 02 02 01 01 03 08 ff 00 c0 ff ff ff ff
> saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 40: ff 65 00 ff c2 1e ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> tuner' 1-0061: chip found @ 0xc2 (saa7133[0])
> saa7133[0]: registered device video0 [v4l2]
> saa7133[0]: registered device vbi0
>
> here is dmesg | grep DVB :
>
> DVB: Unable to find symbol xc2028_attach()
>
> here is lspci -v :
>
> 09:04.0 Multimedia controller: Philips Semiconductors SAA7133/SAA7135
> Video Broadcast Decoder (rev d1)
>         Subsystem: Avermedia Technologies Inc Device a836
>         Flags: bus master, medium devsel, latency 64, IRQ 16
>         Memory at d2005000 (32-bit, non-prefetchable) [size=2K]
>         Capabilities: [40] Power Management version 2
>         Kernel driver in use: saa7134
>         Kernel modules: saa7134
>
> I try to use it under kdetv or tvtime without success and here is what
> dmesg tells me :
>
> tuner' 1-0061: Tuner has no way to set tv freq
>
> Here is what I see when I look in
> linux/drivers/media/video/saa7134/saa7134-cards.c of v4l-dvb at
> linuxtv.org :
>
>      4206 	[SAA7134_BOARD_AVERMEDIA_M115] = {
>      4207 		.name           = "Avermedia M115",
>      4208 		.audio_clock    = 0x187de7,
>      4209 		.tuner_type     = TUNER_XC2028,
>      4210 		.radio_type     = UNSET,
>      4211 		.tuner_addr	= ADDR_UNSET,
>      4212 		.radio_addr	= ADDR_UNSET,
>      4213 		.inputs         = {{
>      4214 			.name = name_tv,
>      4215 			.vmux = 1,
>      4216 			.amux = TV,
>      4217 			.tv   = 1,
>      4218 		}, {
>      4219 			.name = name_comp1,
>      4220 			.vmux = 3,
>      4221 			.amux = LINE1,
>      4222 		}, {
>      4223 			.name = name_svideo,
>      4224 			.vmux = 8,
>      4225 			.amux = LINE2,
>      4226 		} },
>      4227 	},
>
> And here is what I see when I look in
> linux/drivers/media/video/saa7134/saa7134-cards.c of
> v4l-dvb-experimental at mcentral.de
>
>      1709 	[SAA7134_BOARD_AVERMEDIA_M115] = {
>      1710 		.name		= "Avermedia M115",
>      1711 		.audio_clock	= 0x187de7,
>      1712 		.tuner_type	= TUNER_XCEIVE_XC3028,
>      1713 		.radio_type	= UNSET,
>      1714 		.tuner_addr	= 0x61,
>      1715 		.radio_addr	= ADDR_UNSET,
>      1716 		.mpeg           = SAA7134_MPEG_DVB,
>      1717 		.inputs		= {{
>      1718 			.name = name_tv,
>      1719 			.vmux = 1,
>      1720 			.amux = TV,
>      1721 			.tv   = 1,
>      1722 		},{
>      1723 			.name = name_comp1,
>      1724 			.vmux = 3,
>      1725 			.amux = LINE1,
>      1726 		},{
>      1727 			.name = name_svideo,
>      1728 			.vmux = 8,
>      1729 			.amux = LINE2,
>      1730 		}},
>      1731 	},
>
> Are the differences ok ? I mean especially for the tuner type.
> Do I made an error during the instalation ?
> If no, what can I do in order to help you add the support for this card ?
>

I updated the build script of v4l-dvb-experimental with the patch that
was submitted to the ML.

Markus

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
