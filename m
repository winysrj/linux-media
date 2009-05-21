Return-path: <linux-media-owner@vger.kernel.org>
Received: from imta-38.everyone.net ([216.200.145.38]:43344 "EHLO
	omta0106.mta.everyone.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752729AbZEUOZd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 May 2009 10:25:33 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Message-Id: <20090521070416.6042EBC1@resin11.mta.everyone.net>
Date: Thu, 21 May 2009 07:04:16 -0700
From: "Brad Allen" <braddo@tranceaddict.net>
Reply-To: <braddo@tranceaddict.net>
To: "Michael Krufky" <mkrufky@linuxtv.org>
Cc: <linux-media@vger.kernel.org>
Subject: Re: Leadtek Winfast DTV-1000S
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



--- mkrufky@linuxtv.org wrote:

From: Michael Krufky <mkrufky@linuxtv.org>
To: braddo@tranceaddict.net
Subject: Re: Leadtek Winfast DTV-1000S
Date: Wed, 20 May 2009 18:09:34 -0400

On Tue, May 19, 2009 at 3:50 AM, Brad Allen <braddo@tranceaddict.net> wrote:
> Dear Michael,
>
> Ive just bought a Leadtek Winfast DTV-1000S (18271, 14008, 7130 chipset), believing it would work under Linux as the kernel contains drivers for those three chips.
>
> Upon further investigation neither the SAA7134 or the TDA14008 drivers seem to support the 18271. The SAA7134 driver does however appear to work correctly. It just has no tuner to attach to it.
>
> I am desperate to get this card working, surely since the drivers for the chips are written its not a huge task. If you would be so kind as to offer your assistance with this issue I have basic C skills and am quite competent in linux so if theres anything at all I can do to assist you please let me know.
>
> Thanks in advance,
>
> Brad Allen
>

Brad,

I pushed support for a similar board today... You may be able to get
your card up and running by using board configuration #156, if you use
my latest code, located here:

http://kernellabs.com/hg/~mk/hvr1110

The board I have uses a saa7131, not a saa7130, so there may be some
minor differences...  Does your board support both analog and DVB-T,
or just DVB-T ?

Apologies for the late reply -- I am usually no better than this :-P

For quicker response, cc the linux-media mailing list in the future :-)

If this works for you, please let me know.  If not, I have some ideas.

Good Luck.

-Mike Krufky

Hi Mike,

Thanks for your reply. I have had a few minutes to try your latest code and I have both good and bad news to report.

Firstly all three chips are now correctly detected by the module, previously only the SAA7130 was. The DVB device is also now being created whereas before it wasn't.

The card is a DVB-T and FM tuner.

Here are the problems:

1) When loading the module I get the error "tuner 1-0060: Tuner has no way to set tv freq"

2) Trying to tune in channels in mythtv fails, it seems to work but nothing is detected. The signal strength meter works properly.

3) Attempting to view TV with mplayer fails with the following error:

ERROR OPENING FRONTEND DEVICE /dev/dvb/adapter0/frontend0: ERRNO DVB_SET_CHANNEL2, COULDN'T OPEN DEVICES OF CARD: 0, EXIT
ERROR, COULDN'T SET CHANNEL  0: Failed to open dvb://.

Here is the relevant part from dmesg:

[    6.453049] Linux video capture interface: v2.00
[    7.280900] saa7130/34: v4l2 driver version 0.2.15 loaded
[    7.282274] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 5
[    7.282345] PCI: setting IRQ 5 as level-triggered
[    7.282358] saa7134 0000:00:0f.0: PCI INT A -> Link[LNKC] -> GSI 5 (level, low) -> IRQ 5
[    7.282451] saa7130[0]: found at 0000:00:0f.0, rev: 1, irq: 5, latency: 32, mmio: 0xea001000
[    7.282550] saa7130[0]: subsystem: 107d:6655, board: Hauppauge WinTV-HVR1110r3 DVB-T/Hybrid [card=156,insmod option]
[    7.282699] saa7130[0]: board init: gpio is 2020009
[    7.301147] IRQ 5/saa7130[0]: IRQF_DISABLED is not guaranteed on shared IRQs
[    7.437801] saa7130[0]: i2c eeprom 00: 7d 10 55 66 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
[    7.438219] saa7130[0]: i2c eeprom 10: 00 ff 82 0e ff 20 ff ff ff ff ff ff ff ff ff ff
[    7.438541] saa7130[0]: i2c eeprom 20: 01 40 01 01 01 ff 01 03 08 ff 00 8a ff ff ff ff
[    7.439915] saa7130[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.440613] saa7130[0]: i2c eeprom 40: ff 35 00 c0 00 10 03 02 ff 04 ff ff ff ff ff ff
[    7.441307] saa7130[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.441984] saa7130[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.442680] saa7130[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.443374] saa7130[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.444067] saa7130[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.444746] saa7130[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.445441] saa7130[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.446137] saa7130[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.446815] saa7130[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.447511] saa7130[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.448203] saa7130[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.448889] tveeprom 1-0050: Encountered bad packet header [ff]. Corrupt or not a Hauppauge eeprom.
[    7.448976] saa7130[0]: warning: unknown hauppauge model #0
[    7.449059] saa7130[0]: hauppauge eeprom: model=0
[    7.517263] tea5767_autodetection: not probed - driver disabled by Kconfig
[    7.517359] tuner 1-0060: chip found @ 0xc0 (saa7130[0])
[    7.517442] tda829x_attach: not probed - driver disabled by Kconfig
[    7.517525] tuner 1-0060: Tuner has no way to set tv freq
[    7.518355] tuner 1-0060: Tuner has no way to set tv freq
[    7.518600] saa7130[0]: registered device video0 [v4l2]
[    7.518722] saa7130[0]: registered device vbi0
[    7.518844] saa7130[0]: registered device radio0
[    8.097217] dvb_init() allocating 1 frontend
[    8.116084] tda829x_attach: not probed - driver disabled by Kconfig
[    8.116186] tda18271 1-0060: creating new instance
[    8.120055] TDA18271HD/C1 detected @ 1-0060
[    8.337108] DVB: registering new adapter (saa7130[0])
[    8.337211] DVB: registering adapter 0 frontend 0 (NXP TDA10048HN DVB-T)...
[    8.420055] tda10048_firmware_upload: waiting for firmware upload (dvb-fe-tda10048-1.0.fw)...
[    8.420185] saa7134 0000:00:0f.0: firmware: requesting dvb-fe-tda10048-1.0.fw
[    8.608406] tda10048_firmware_upload: firmware read 24878 bytes.
[    8.608499] tda10048_firmware_upload: firmware uploading
[   11.839068] tda10048_firmware_upload: firmware uploaded

Please let me know if there is anything further I can do to help.

Thanks very much,

Brad
