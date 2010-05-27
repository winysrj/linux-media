Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55514 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757203Ab0E0VeH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 27 May 2010 17:34:07 -0400
Date: Thu, 27 May 2010 18:33:52 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Dmitri Belimov <d.belimov@gmail.com>
Cc: Luis Henrique Fagundes <lhfagundes@hacklab.com.br>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Stefan Ringel <stefan.ringel@arcor.de>,
	Bee Hock Goh <beehock@gmail.com>
Subject: Re: tm6000, alsa
Message-ID: <20100527183352.7a9462fe@pedra>
In-Reply-To: <20100526145219.11c81de0@glory.loctelecom.ru>
References: <20100518172329.6d9b520a@glory.loctelecom.ru>
	<20100526145219.11c81de0@glory.loctelecom.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dmitri,


Em Wed, 26 May 2010 14:52:19 +1000
Dmitri Belimov <d.belimov@gmail.com> escreveu:

> Hi 
> 
> Patches for review.
> Add new data structure list_head for many tm6000 cards.
> Rework tm6000-alsa.
> Comment some old code befor remove.

Please, always send one patch per email. Patchwork won't catch multiple patches on the same email,
and it makes harder for review them.

> 
> Now tm6000-alsa not load when tm6000 start. Need load tm6000-alsa manualy
> 
> [  210.777562] tm6000: New video device @ 480 Mbps (6000:dec0, ifnum 0)
> [  210.777566] tm6000: Found Beholder Wander DVB-T/TV/FM USB2.0
> [  211.700009] Board version = 0x67980bf4
> [  211.900011] board=0x67980bf4
> [  212.024512] tm6000 #0: i2c eeprom 00: 42 59 54 45 12 01 00 02 00 00 00 40 00 60 c0 de  BYTE.......@.`..
> [  212.216012] tm6000 #0: i2c eeprom 10: 01 00 10 20 40 01 28 03 42 00 65 00 68 00 6f 00  ... @.(.B.e.h.o.
> [  212.408012] tm6000 #0: i2c eeprom 20: 6c 00 64 00 65 00 72 00 20 00 49 00 6e 00 74 00  l.d.e.r. .I.n.t.
> [  212.600012] tm6000 #0: i2c eeprom 30: 6c 00 2e 00 20 00 4c 00 74 00 64 00 2e 00 ff ff  l... .L.t.d.....
> [  212.792012] tm6000 #0: i2c eeprom 40: 22 03 42 00 65 00 68 00 6f 00 6c 00 64 00 20 00  ".B.e.h.o.l.d. .
> [  212.984012] tm6000 #0: i2c eeprom 50: 54 00 56 00 20 00 57 00 61 00 6e 00 64 00 65 00  T.V. .W.a.n.d.e.
> [  213.176011] tm6000 #0: i2c eeprom 60: 72 00 ff ff ff ff ff ff ff ff 1a 03 56 00 69 00  r...........V.i.
> [  213.368012] tm6000 #0: i2c eeprom 70: 64 00 65 00 6f 00 43 00 61 00 70 00 74 00 75 00  d.e.o.C.a.p.t.u.
> [  213.560012] tm6000 #0: i2c eeprom 80: 72 00 65 00 ff ff ff ff ff ff ff ff ff ff ff ff  r.e.............
> [  213.752012] tm6000 #0: i2c eeprom 90: ff ff ff ff 16 03 30 00 30 00 30 00 30 00 30 00  ......0.0.0.0.0.
> [  213.944011] tm6000 #0: i2c eeprom a0: 30 00 32 00 30 00 34 00 31 00 ff ff ff ff ff ff  0.2.0.4.1.......
> [  214.136009] tm6000 #0: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
> [  214.328012] tm6000 #0: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
> [  214.520014] tm6000 #0: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
> [  214.712012] tm6000 #0: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
> [  214.904012] tm6000 #0: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff  ................
> [  215.084013]   ................
> [  215.104890] tuner 1-0061: chip found @ 0xc2 (tm6000 #0)
> [  215.160471] xc5000 1-0061: creating new instance
> [  215.216511] xc5000: Successfully identified at address 0x61
> [  215.216515] xc5000: Firmware has not been loaded previously
> [  215.216522] tuner 1-0061: Tuner frontend module has no way to set config
> [  215.328012] xc5000: waiting for firmware upload (dvb-fe-xc5000-1.6.114.fw)...
> [  215.328019] usb 1-1: firmware: requesting dvb-fe-xc5000-1.6.114.fw
> [  215.365986] xc5000: firmware read 12401 bytes.
> [  215.365989] xc5000: firmware uploading...
> [  227.128008] xc5000: firmware upload complete...
> [  229.036083] Trident TVMaster TM5600/TM6000/TM6010 USB2 board (Load status: 0)
> [  229.036114] usbcore: registered new interface driver tm6000
> [  229.052288] tm6000: open called (dev=video0)
> [  230.484571] Original value=255
> 
> load tm6000-alsa manualy
> [  259.141425] tm6000 ALSA driver for DMA sound loaded
> 
> unload tm6000-alsa
> [  309.364210] tm6000 ALSA driver for DMA sound unloaded
> 
> load tm6000-alsa manualy
> [  320.118131] tm6000 ALSA driver for DMA sound loaded
> 
> ALSA devices created
> arecord -l
> 
> **** List of CAPTURE Hardware Devices ****
> card 0: Intel [HDA Intel], device 0: ALC883 Analog [ALC883 Analog]
>   Subdevices: 1/1
>   Subdevice #0: subdevice #0
> card 0: Intel [HDA Intel], device 1: ALC883 Digital [ALC883 Digital]
>   Subdevices: 1/1
>   Subdevice #0: subdevice #0
> card 0: Intel [HDA Intel], device 2: ALC883 Analog [ALC883 Analog]
>   Subdevices: 1/1
>   Subdevice #0: subdevice #0
> card 1: default [], device 0: tm6000 Digital [tm6000 Digital]
>   Subdevices: 1/1
>   Subdevice #0: subdevice #0
> 
> If need I can rework this patches or it can be upload to tm6000 tree.
> 
> With my best regards, Dmitry.


-- 

Cheers,
Mauro
