Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.216.174]:53082 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755351AbZFWPga convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Jun 2009 11:36:30 -0400
Received: by pxi4 with SMTP id 4so104689pxi.33
        for <linux-media@vger.kernel.org>; Tue, 23 Jun 2009 08:36:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1243024963.14790.1316818399@webmail.messagingengine.com>
References: <1243024963.14790.1316818399@webmail.messagingengine.com>
Date: Wed, 24 Jun 2009 01:36:33 +1000
Message-ID: <b5c455cf0906230836q196f6fb3p81014ae2f1322515@mail.gmail.com>
Subject: Re: [linux-dvb] Gigabyte GT-P8000 dvb-t / analog / fm radio - pci
From: c kuruwita <ckuruwita.pub@gmail.com>
To: linux-media@vger.kernel.org
Cc: linux-dvb@linuxtv.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

You could try using the "card=" option when loading the kernel module
and use the cardnumber of a similar supported saa7134 dvb card.
you can find a complete list of supported card saa713 dvb cards in
"Documentation/video4linux/CARDLIST.saa7134".

Cheers

Chatura

On Sat, May 23, 2009 at 6:42 AM, <jhmoodie@telkomsa.net> wrote:
> Does anyone have any information on the support status of this card? Or
> perhaps any hints I might try to get it working?
>
> I have built and installed the latest V4L-DVB kernel driver modules, but
> no luck.
>
> I noticed windows installs Philips 3xhybrid drivers if this helps...
>
> Product website:
> http://www.gigabyte.com.tw/Products/TVCard/Products_Spec.aspx?ClassValue=TV+Card&ProductID=2757&ProductName=GT-P8000
>
> Tuner NXP 18271
> Decoder NXP 7131E
>
> lspci -vnn:
> 00:09.0 Multimedia controller [0480]: Philips Semiconductors
> SAA7131/SAA7133/SAA7135 Video Broadcast Decoder [1131:7133] (rev d1)
>        Subsystem: Giga-byte Technology Device [1458:9004]
>        Flags: bus master, medium devsel, latency 32, IRQ 11
>        Memory at e6000000 (32-bit, non-prefetchable) [size=2K]
>        Capabilities: [40] Power Management version 2
>        Kernel driver in use: saa7134
>        Kernel modules: saa7134
>
> dmesg output:
> [ 3089.801191] saa7130/34: v4l2 driver version 0.2.15 loaded
> [ 3089.801419] saa7133[0]: found at 0000:00:09.0, rev: 209, irq: 11,
> latency: 32, mmio: 0xe6000000
> [ 3089.801443] saa7133[0]: subsystem: 1458:9004, board: UNKNOWN/GENERIC
> [card=0,autodetected]
> [ 3089.801656] saa7133[0]: board init: gpio is 40000
> [ 3089.952088] saa7133[0]: i2c eeprom 00: 58 14 04 90 54 20 1c 00 43 43
> a9
> 1c 55 d2 b2 92
> [ 3089.952125] saa7133[0]: i2c eeprom 10: ff ff ff ff ff 20 ff ff ff ff
> ff
> ff ff ff ff ff
> [ 3089.952153] saa7133[0]: i2c eeprom 20: 01 40 01 02 02 01 01 03 08 ff
> 00
> b3 ff ff ff ff
> [ 3089.952180] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff
> ff
> ff ff ff ff ff
> [ 3089.952206] saa7133[0]: i2c eeprom 40: 50 35 00 c0 96 10 05 32 d5 15
> 0e
> 00 ff ff ff ff
> [ 3089.952233] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff
> ff
> ff ff ff ff ff
> [ 3089.952260] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff
> ff
> ff ff ff ff ff
> [ 3089.952287] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff
> ff
> ff ff ff ff ff
> [ 3089.952314] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff
> ff
> ff ff ff ff ff
> [ 3089.952340] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff
> ff
> ff ff ff ff ff
> [ 3089.952367] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff
> ff
> ff ff ff ff ff
> [ 3089.952394] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff
> ff
> ff ff ff ff ff
> [ 3089.952421] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff
> ff
> ff ff ff ff ff
> [ 3089.952447] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff
> ff
> ff ff ff ff ff
> [ 3089.952474] saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff
> ff
> ff ff ff ff ff
> [ 3089.952501] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff
> ff
> ff ff ff ff ff
> [ 3089.953430] saa7133[0]: registered device video0 [v4l2]
> [ 3089.953507] saa7133[0]: registered device vbi0
> [ 3090.023006] saa7134 ALSA driver for DMA sound loaded
> [ 3090.023158] saa7133[0]/alsa: saa7133[0] at 0xe6000000 irq 11
> registered
> as card -2
>
> --
>
>  raincloud@fastmail.fm
>
> --
> http://www.fastmail.fm - Email service worth paying for. Try it for free
>
>
> _______________________________________________
> linux-dvb users mailing list
> For V4L/DVB development, please use instead linux-media@vger.kernel.org
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>
