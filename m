Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:44907 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752585Ab2LKLze (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Dec 2012 06:55:34 -0500
Received: by mail-lb0-f174.google.com with SMTP id gi11so2780467lbb.19
        for <linux-media@vger.kernel.org>; Tue, 11 Dec 2012 03:55:32 -0800 (PST)
Message-ID: <50C71F2E.6090004@gmail.com>
Date: Tue, 11 Dec 2012 16:55:26 +0500
From: Saad Bin Javed <sbjaved@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: Kworld PCI Analog TV Card Lite PVR-7134SE
References: <50C71D1D.4030709@gmail.com>
In-Reply-To: <50C71D1D.4030709@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/11/2012 02:22 AM, Alfredo Jesús Delaiti wrote:
> Hi
>
> Read:
>
> http://www.linuxtv.org/wiki/index.php/Kworld_PCI_Analog_TV_Card_Lite
>
> Alfredo
>
> El 10/12/12 15:06, Saad Bin Javed escribió:
>> Can anybody help setting up this card? I posted details in an earlier
>> message but got no response. This list is my last hope to get this
>> thing working.

I've tried following the wiki, but i'm unable to set the correct tuner.
Please take a look at my card and onboard chips
(http://tinypic.com/view.php?pic=2lwnmuc&s=6) and the dmesg output.

This is after manually specifying card=153 and tuner=61 (sudo modprobe
saa7134 card=153 tuner=61)

[ 2142.483753] Linux video capture interface: v2.00
[ 2142.517975] saa7130/34: v4l2 driver version 0, 2, 17 loaded
[ 2142.518013] saa7134 0000:02:00.0: PCI INT A -> GSI 16 (level, low) ->
IRQ 16
[ 2142.518021] saa7134[0]: found at 0000:02:00.0, rev: 1, irq: 16,
latency: 32, mmio: 0xfe400000
[ 2142.518030] saa7134[0]: subsystem: 17de:712b, board: Kworld Plus TV
Analog Lite PCI [card=153,insmod option]
[ 2142.518050] saa7134[0]: board init: gpio is 80407f
[ 2142.546076] IR NEC protocol handler initialized
[ 2142.548285] IR RC5(x) protocol handler initialized
[ 2142.550044] IR RC6 protocol handler initialized
[ 2142.552768] IR JVC protocol handler initialized
[ 2142.554466] IR Sony protocol handler initialized
[ 2142.562683] Registered IR keymap rc-kworld-plus-tv-analog
[ 2142.562767] input: saa7134 IR (Kworld Plus TV Anal as
/devices/pci0000:00/0000:00:1c.0/0000:01:00.0/0000:02:00.0/rc/rc0/input7
[ 2142.563834] rc0: saa7134 IR (Kworld Plus TV Anal as
/devices/pci0000:00/0000:00:1c.0/0000:01:00.0/0000:02:00.0/rc/rc0
[ 2142.564266] IR MCE Keyboard/mouse protocol handler initialized
[ 2142.587345] lirc_dev: IR Remote Control driver registered, major 250
[ 2142.587783] IR LIRC bridge handler initialized
[ 2142.710404] saa7134[0]: i2c eeprom 00: de 17 2b 71 10 28 ff ff ff ff
ff ff ff ff ff ff
[ 2142.710416] saa7134[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[ 2142.710427] saa7134[0]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[ 2142.710436] saa7134[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[ 2142.710446] saa7134[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[ 2142.710456] saa7134[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[ 2142.710466] saa7134[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[ 2142.710476] saa7134[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[ 2142.710485] saa7134[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[ 2142.710495] saa7134[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[ 2142.710505] saa7134[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[ 2142.710515] saa7134[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[ 2142.710525] saa7134[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[ 2142.710534] saa7134[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[ 2142.710544] saa7134[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[ 2142.710554] saa7134[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[ 2142.725718] i2c-core: driver [tuner] using legacy suspend method
[ 2142.725721] i2c-core: driver [tuner] using legacy resume method
[ 2142.754313] All bytes are equal. It is not a TEA5767
[ 2142.754323] tuner 14-0060: Tuner -1 found with type(s) Radio TV.
[ 2142.756682] tea5767 14-0060: type set to Philips TEA5767HN FM Radio
[ 2142.786402] saa7134[0]: registered device video0 [v4l2]
[ 2142.787009] saa7134[0]: registered device vbi0
[ 2142.787585] saa7134[0]: registered device radio0
[ 2142.810813] saa7134 ALSA driver for DMA sound loaded
[ 2142.810839] saa7134[0]/alsa: saa7134[0] at 0xfe400000 irq 16
registered as card -2

Saad




