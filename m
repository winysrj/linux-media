Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:59006 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbaIREHG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Sep 2014 00:07:06 -0400
Received: by mail-pa0-f48.google.com with SMTP id hz1so553384pad.35
        for <linux-media@vger.kernel.org>; Wed, 17 Sep 2014 21:07:05 -0700 (PDT)
Received: from [192.168.8.224] ([121.75.36.50])
        by mx.google.com with ESMTPSA id qc3sm18798888pab.48.2014.09.17.21.07.02
        for <linux-media@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Wed, 17 Sep 2014 21:07:04 -0700 (PDT)
Message-ID: <541A5A63.40903@gmail.com>
Date: Thu, 18 Sep 2014 16:06:59 +1200
From: "Chun Ming (Eric) Wong" <ericwongcm@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: AVerMedia AVerTV Hybrid+FM Cardbus (E506) driver problem on Xubuntu
 14.04
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I am trying to make my PCMCIA tunner card, AVerMedia AVerTV Hybrid+FM 
Cardbus (E506) work on Xubuntu 14.04.

I have followed the Basic approach on this page
http://www.linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_Device_Drivers

I have successfully build the binary and installed it.
However, the tuner card is not working on Xubuntu.
I have tested the same tuner card on Windows and it works fine on 
Windows with Avermedia's windows driver and application.

This page says this tuner card is supported
http://linuxtv.org/wiki/index.php/DVB-T_PCMCIA_Cards
The model written on my PCMCIA card is E506, NO E506R.
I am not sure if the R wording matters or not. I assume it is the same 
hardware.

And I also found this guide for this card but this guide is for older 
kernel, so I did not figure out jhow to follow this guide...
http://gentoo-en.vfose.ru/wiki/AverMedia_AverTV_Cardbus_Hybrid_E506R

When card is inserted kernel log reports this
[  306.016062] pcmcia_socket pcmcia_socket0: pccard: CardBus card 
inserted into slot 0
[  306.016109] pci 0000:03:00.0: [1131:7133] type 00 class 0x048000
[  306.016149] pci 0000:03:00.0: reg 0x10: [mem 0x00000000-0x000007ff]
[  306.016260] pci 0000:03:00.0: supports D1 D2
[  306.016474] pci 0000:03:00.0: BAR 0: assigned [mem 0x2c000000-0x2c0007ff]
[  306.016500] pci 0000:03:00.0: cache line size of 32 is not supported
[  306.016648] saa7134 0000:03:00.0: enabling device (0000 -> 0002)
[  306.016754] saa7133[0]: found at 0000:03:00.0, rev: 209, irq: 10, 
latency: 0, mmio: 0x2c000000
[  306.016774] saa7133[0]: subsystem: 1461:f436, board: AVerMedia 
Cardbus TV/Radio (E506R) [card=136,autodetected]
[  306.016813] saa7133[0]: board init: gpio is 220000
[  306.184041] saa7133[0]: i2c eeprom 00: 61 14 36 f4 00 00 00 00 00 00 
00 00 00 00 00 00
[  306.184060] saa7133[0]: i2c eeprom 10: 00 ff e2 0e ff 20 ff ff ff ff 
ff ff ff ff ff ff
[  306.184074] saa7133[0]: i2c eeprom 20: 01 40 01 02 02 01 01 03 08 ff 
00 ff ff ff ff ff
[  306.184088] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[  306.184102] saa7133[0]: i2c eeprom 40: ff 65 00 ff c2 1e ff ff ff ff 
ff ff ff ff ff ff
[  306.184115] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[  306.184129] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[  306.184143] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[  306.184156] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[  306.184170] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[  306.184184] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[  306.184197] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[  306.184211] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[  306.184225] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[  306.184238] saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[  306.184252] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[  306.189180] Registered IR keymap rc-avermedia-cardbus
[  306.189421] input: i2c IR (AVerMedia Cardbus remot as 
/devices/virtual/rc/rc0/input9
[  306.195172] rc0: i2c IR (AVerMedia Cardbus remot as 
/devices/virtual/rc/rc0
[  306.195184] ir-kbd-i2c: i2c IR (AVerMedia Cardbus remot detected at 
i2c-4/4-0040/ir0 [saa7133[0]]
[  306.220195] tuner 4-0061: Tuner -1 found with type(s) Radio TV.
[  306.220241] xc2028 4-0061: creating new instance
[  306.220245] xc2028 4-0061: type set to XCeive xc2028/xc3028 tuner
[  306.220598] saa7134 0000:03:00.0: Direct firmware load failed with 
error -2
[  306.220602] saa7134 0000:03:00.0: Falling back to user helper
[  306.228004] xc2028 4-0061: Could not load firmware xc3028-v27.fw.
[  306.240676] dvb_init() allocating 1 frontend
[  306.264100] xc2028 4-0061: attaching existing instance
[  306.264108] xc2028 4-0061: type set to XCeive xc2028/xc3028 tuner
[  306.264113] DVB: registering new adapter (saa7133[0])
[  306.264124] saa7134 0000:03:00.0: DVB: registering adapter 0 frontend 
0 (Zarlink MT352 DVB-T)...
[  306.364352] saa7133[0]: registered device video0 [v4l2]
[  306.366538] saa7133[0]: registered device vbi0
[  306.366620] saa7133[0]: registered device radio0
[  306.366676] saa7133[0]/alsa: saa7133[0] at 0x2c000000 irq 10 
registered as card -2

You can see there is an error there..
[  306.220598] saa7134 0000:03:00.0: Direct firmware load failed with 
error -2
[  306.220602] saa7134 0000:03:00.0: Falling back to user helper
[  306.228004] xc2028 4-0061: Could not load firmware xc3028-v27.fw.

Using tvheadend, tvheadend appears to be able to use this tuner card to 
scan channels but it will not pickup anything at all.

 From time to time, I also see this DSP error
[   26.207446] type=1400 audit(1410949979.461:41): apparmor="STATUS" 
operation="profile_replace" profile="unconfined" 
name="/usr/sbin/cups-browsed" pid=820 comm="apparmor_parser"
[   27.023625] type=1400 audit(1410949980.277:42): apparmor="STATUS" 
operation="profile_replace" profile="unconfined" 
name="/usr/lib/cups/backend/cups-pdf" pid=698 comm="apparmor_parser"
[   27.033047] type=1400 audit(1410949980.289:43): apparmor="STATUS" 
operation="profile_replace" profile="unconfined" name="/usr/sbin/cupsd" 
pid=698 comm="apparmor_parser"
[   27.066406] type=1400 audit(1410949980.321:44): apparmor="STATUS" 
operation="profile_load" profile="unconfined" name="/usr/sbin/tcpdump" 
pid=826 comm="apparmor_parser"
[   33.530805] init: plymouth-upstart-bridge main process ended, respawning
[   33.573435] init: plymouth-upstart-bridge main process (1191) 
terminated with status 1
[   33.573465] init: plymouth-upstart-bridge main process ended, respawning
[  329.072173] usb 2-2: USB disconnect, device number 2
[  329.628106] usb 2-2: new low-speed USB device number 3 using uhci_hcd
[  611.773019] saa7133[0]: dsp access error
[  611.773033] saa7133[0]: dsp access error
[  611.773052] saa7133[0]: dsp access error
[  611.773059] saa7133[0]: dsp access error
[  611.773075] saa7133[0]: dsp access error
[  611.773082] saa7133[0]: dsp access error
[  611.773098] saa7133[0]: dsp access error
[  611.773105] saa7133[0]: dsp access error
[  611.773121] saa7133[0]: dsp access error
[  611.773128] saa7133[0]: dsp access error
[  611.773144] saa7133[0]: dsp access error
[  611.773151] saa7133[0]: dsp access error
[  611.773167] saa7133[0]: dsp access error
[  611.773174] saa7133[0]: dsp access error
[  611.773190] saa7133[0]: dsp access error
[  611.773197] saa7133[0]: dsp access error
[  611.773213] saa7133[0]: dsp access error
[  611.773220] saa7133[0]: dsp access error
[  611.773236] saa7133[0]: dsp access error
[  611.773243] saa7133[0]: dsp access error
[  611.773259] saa7133[0]/irq[10,77943]: r=0xfffffff7 s=0xffffffff 
DONE_RA0 DONE_RA1 DONE_RA2 AR PE PWR_ON RDCAP INTL FIDT MMC TRIG_ERR 
CONF_ERR LOAD_ERR GPIO16 GPIO18 GPIO22 GPIO23 | RA0=vbi,b,odd,15
[  611.773299] saa7133[0]/irq: looping -- clearing PE (parity error!) 
enable bit

Maybe some recent changes in kernel somehow broke support for this tuner 
card?
I don't know. Please advice if you know what the problem is or how this 
can be solved.

Thanks

-- 
Eric Wong

