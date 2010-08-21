Return-path: <mchehab@pedra>
Received: from mail.kapsi.fi ([217.30.184.167]:54455 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751303Ab0HUHLC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Aug 2010 03:11:02 -0400
Message-ID: <4C6F7BC2.9080304@iki.fi>
Date: Sat, 21 Aug 2010 10:09:54 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: poma <pomidorabelisima@gmail.com>
CC: itesupport@ite.com.tw, info@maxlinear.com, briefkasten@terratec.de,
	TerraTux@terratec.de, help@lifeview.com.cn, europe@lifeview.it,
	support@lifeview.hk, sales@lifeview.hk, marketing@lifeview.hk,
	soporte@lifeview.es, ventas@lifeview.es,
	linux-media@vger.kernel.org
Subject: Re: Afatech AF9015 & MaxLinear MXL5007T dual tuner
References: <4C6F67AF.2090700@gmail.com>
In-Reply-To: <4C6F67AF.2090700@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Moikka,
It should be easy to add support AF9015 based MXL5007T since Linux 
drivers exists. I haven't added it due to lack of device. That support 
is asked very often in recent months.

regards
Antti

poma wrote:
> 
> Hi There,
> 
> This email is carbon copied to:
> ITE:
> itesupport@ite.com.tw
> MaxLinear:
> info@maxlinear.com
> TerraTec:
> briefkasten@terratec.de
> TerraTux@terratec.de
> Lifeview:
> help@lifeview.com.cn
> europe@lifeview.it
> support@lifeview.hk
> sales@lifeview.hk
> marketing@lifeview.hk
> soporte@lifeview.es
> ventas@lifeview.es
> Linux Media:
> linux-media@vger.kernel.org
> Antti Palosaari:
> crope@iki.fi
> http://palosaari.fi/linux/
> 
> 
> Devices:
> TerraTec
> http://www.terratec.net/en/products/Cinergy_T_Stick_Dual_RC_102261.html
> Lifeview
> http://www.notonlytv.net/p_lv52t.html
> 
> ICs:
> Demodulators:
> ITE-Afatech:
> http://www.ite.com.tw/EN/products_more.aspx?CategoryID=6&ID=15,62
> AF9015A-N1
> AF9013-N1
> Tuners:
> MaxLinear:
> http://www.maxlinear.com/assets/pdfs/MxL5007T.pdf
> MXL5007T
> MXL5007T
> 
> lsusb:
> Bus 002 Device 002: ID 15a4:9016 Afatech Technologies, Inc. AF9015 DVB-T 
> USB2.0 stick
> 
> dmesg:
> af9015_usb_probe: interface:0
> 00000000: 2b a5 9b 0b 00 00 00 00 a4 15 16 90 00 02 01 02  +...............
> 00000010: 03 80 00 fa fa 0a 40 ef 01 30 31 30 31 30 39 32  ......@..0101092
> 00000020: 31 30 39 30 30 30 30 31 ff ff ff ff ff ff ff ff  10900001........
> 00000030: 00 01 3a 01 00 08 02 00 da 11 00 00 b1 ff ff ff  ..:.............
> 00000040: ff ff ff ff ff 08 02 00 da 11 c4 04 b1 ff ff ff  ................
> 00000050: ff ff ff ff 10 26 00 00 04 03 09 04 10 03 41 00  .....&........A.
> 00000060: 66 00 61 00 74 00 65 00 63 00 68 00 10 03 44 00  f.a.t.e.c.h...D.
> 00000070: 56 00 42 00 2d 00 54 00 20 00 32 00 20 03 30 00  V.B.-.T. .2. .0.
> 00000080: 31 00 30 00 31 00 30 00 31 00 30 00 31 00 30 00  1.0.1.0.1.0.1.0.
> 00000090: 36 00 30 00 30 00 30 00 30 00 31 00 00 ff ff ff  6.0.0.0.0.1.....
> 000000a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
> 000000b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
> 000000c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
> 000000d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
> 000000e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
> 000000f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
> af9015_eeprom_hash: eeprom sum=403c71e6
> af9015_read_config: IR mode:1
> af9015_read_config: TS mode:1
> af9015_read_config: [0] xtal:2 set adc_clock:28000
> af9015_read_config: [0] IF1:4570
> af9015_read_config: [0] MT2060 IF1:0
> af9015: tuner id:177 not supported, please report!
> usbcore: registered new interface driver dvb_usb_af9015
> 
> Tanks for any help
> poma
> 


-- 
http://palosaari.fi/
