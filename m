Return-path: <mchehab@pedra>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:57264 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756639Ab1DYW2Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Apr 2011 18:28:25 -0400
Received: by qwk3 with SMTP id 3so32570qwk.19
        for <linux-media@vger.kernel.org>; Mon, 25 Apr 2011 15:28:24 -0700 (PDT)
MIME-Version: 1.0
From: "cumulus0007@gmail.com" <cumulus0007@gmail.com>
Date: Tue, 26 Apr 2011 00:28:03 +0200
Message-ID: <BANLkTi=m6sFyv7_xn1wMkDk-A01qAUgUeg@mail.gmail.com>
Subject: Zolid Hybrid TV Tuner analog and FM not working
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

my Zolid Hybrid TV Tuner
(http://www.linuxtv.org/wiki/index.php/Zolid_Hybrid_TV_Tuner) is
supposed to work thanks to a merged patch mentioned at the wiki page.
The creator of this patch states that DVB-T, analog and (later on the
thread) FM are working
(http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/9721/match=zolid).

Well, for me the analog reception does not work. DVB works fine,
although the reception could be improved. My dmesg spits out lots of
error messages I don't understand:

Apr 25 23:58:25 sander-desktop kernel: [ 2055.642093] Linux video
capture interface: v2.00
Apr 25 23:58:25 sander-desktop kernel: [ 2055.651741] saa7130/34: v4l2
driver version 0.2.16 loaded
Apr 25 23:58:25 sander-desktop kernel: [ 2055.651780] saa7133[0]:
found at 0000:05:00.0, rev: 209, irq: 16, latency: 64, mmio:
0xfebff800
Apr 25 23:58:25 sander-desktop kernel: [ 2055.651787] saa7133[0]:
subsystem: 1131:2004, board: Zolid Hybrid TV Tuner PCI
[card=173,autodetected]
Apr 25 23:58:25 sander-desktop kernel: [ 2055.651809] saa7133[0]:
board init: gpio is 0
Apr 25 23:58:25 sander-desktop kernel: [ 2055.830036] saa7133[0]: i2c
eeprom 00: 31 11 04 20 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
Apr 25 23:58:25 sander-desktop kernel: [ 2055.830050] saa7133[0]: i2c
eeprom 10: 00 ff 86 0f ff 20 ff ff ff ff ff ff ff ff ff ff
Apr 25 23:58:25 sander-desktop kernel: [ 2055.830061] saa7133[0]: i2c
eeprom 20: 01 40 01 02 03 01 01 03 08 ff 00 b2 ff ff ff ff
Apr 25 23:58:25 sander-desktop kernel: [ 2055.830073] saa7133[0]: i2c
eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Apr 25 23:58:25 sander-desktop kernel: [ 2055.830084] saa7133[0]: i2c
eeprom 40: ff 35 00 c0 96 10 03 32 21 05 ff ff ff ff ff ff
Apr 25 23:58:25 sander-desktop kernel: [ 2055.830096] saa7133[0]: i2c
eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Apr 25 23:58:25 sander-desktop kernel: [ 2055.830107] saa7133[0]: i2c
eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Apr 25 23:58:25 sander-desktop kernel: [ 2055.830119] saa7133[0]: i2c
eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Apr 25 23:58:25 sander-desktop kernel: [ 2055.830130] saa7133[0]: i2c
eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Apr 25 23:58:25 sander-desktop kernel: [ 2055.830142] saa7133[0]: i2c
eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Apr 25 23:58:25 sander-desktop kernel: [ 2055.830153] saa7133[0]: i2c
eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Apr 25 23:58:25 sander-desktop kernel: [ 2055.830165] saa7133[0]: i2c
eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Apr 25 23:58:25 sander-desktop kernel: [ 2055.830176] saa7133[0]: i2c
eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Apr 25 23:58:25 sander-desktop kernel: [ 2055.830188] saa7133[0]: i2c
eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Apr 25 23:58:25 sander-desktop kernel: [ 2055.830199] saa7133[0]: i2c
eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Apr 25 23:58:25 sander-desktop kernel: [ 2055.830218] saa7133[0]: i2c
eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Apr 25 23:58:25 sander-desktop kernel: [ 2055.931372] tuner 6-004b:
chip found @ 0x96 (saa7133[0])
Apr 25 23:58:26 sander-desktop kernel: [ 2056.100032] tda829x 6-004b:
setting tuner address to 60
Apr 25 23:58:26 sander-desktop kernel: [ 2056.173615] tda18271 6-0060:
creating new instance
Apr 25 23:58:26 sander-desktop kernel: [ 2056.261282] TDA18271HD/C2
detected @ 6-0060
Apr 25 23:58:28 sander-desktop kernel: [ 2058.650030] tda18271:
performing RF tracking filter calibration
Apr 25 23:59:01 sander-desktop kernel: [ 2091.680032] tda18271: RF
tracking filter calibration complete
Apr 25 23:59:01 sander-desktop kernel: [ 2091.790051] tda829x 6-004b:
type set to tda8290+18271
Apr 25 23:59:09 sander-desktop kernel: [ 2099.850349] saa7133[0]: dsp
access error
Apr 25 23:59:09 sander-desktop kernel: [ 2099.850353] saa7133[0]: dsp
access error
Apr 25 23:59:09 sander-desktop kernel: [ 2099.980120] saa7133[0]:
registered device video0 [v4l2]
Apr 25 23:59:09 sander-desktop kernel: [ 2099.980160] saa7133[0]:
registered device vbi0
Apr 25 23:59:09 sander-desktop kernel: [ 2099.980199] saa7133[0]:
registered device radio0
Apr 25 23:59:09 sander-desktop kernel: [ 2099.987454] saa7134 ALSA
driver for DMA sound loaded
Apr 25 23:59:09 sander-desktop kernel: [ 2099.987498] saa7133[0]/alsa:
saa7133[0] at 0xfebff800 irq 16 registered as card -2
Apr 25 23:59:10 sander-desktop rtkit-daemon[1618]: Successfully made
thread 3949 of process 3764 (n/a) owned by '1000' RT at priority 5.
Apr 25 23:59:10 sander-desktop rtkit-daemon[1618]: Supervising 4
threads of 1 processes of 1 users.
Apr 25 23:59:10 sander-desktop kernel: [ 2100.066089] dvb_init()
allocating 1 frontend
Apr 25 23:59:11 sander-desktop kernel: [ 2101.471482] tda18271 6-0060:
attaching existing instance
Apr 25 23:59:11 sander-desktop kernel: [ 2101.471488] DVB: registering
new adapter (saa7133[0])
Apr 25 23:59:11 sander-desktop kernel: [ 2101.471492] DVB: registering
adapter 0 frontend 0 (NXP TDA10048HN DVB-T)...
Apr 25 23:59:13 sander-desktop kernel: [ 2103.531278]
tda18271_write_regs: [6-0060|M] ERROR: idx = 0xc, len = 4,
i2c_transfer returned: -5
Apr 25 23:59:13 sander-desktop kernel: [ 2103.650026]
tda18271_write_regs: [6-0060|M] ERROR: idx = 0x1, len = 7,
i2c_transfer returned: -5
Apr 25 23:59:13 sander-desktop kernel: [ 2103.650032]
tda18271_channel_configuration: [6-0060|M] error -5 on line 184
Apr 25 23:59:13 sander-desktop kernel: [ 2103.650038]
tda18271_set_analog_params: [6-0060|M] error -5 on line 1045
Apr 25 23:59:14 sander-desktop kernel: [ 2104.950042]
tda18271_write_regs: [6-0060|M] ERROR: idx = 0xc, len = 4,
i2c_transfer returned: -5
Apr 25 23:59:15 sander-desktop kernel: [ 2105.110067]
tda18271_write_regs: [6-0060|M] ERROR: idx = 0x1, len = 7,
i2c_transfer returned: -5
Apr 25 23:59:15 sander-desktop kernel: [ 2105.110074]
tda18271_channel_configuration: [6-0060|M] error -5 on line 184
Apr 25 23:59:15 sander-desktop kernel: [ 2105.110079]
tda18271_set_analog_params: [6-0060|M] error -5 on line 1045
Apr 25 23:59:15 sander-desktop kernel: [ 2105.250032]
tda10048_firmware_upload: waiting for firmware upload
(dvb-fe-tda10048-1.0.fw)...
Apr 25 23:59:15 sander-desktop kernel: [ 2105.252036]
tda10048_firmware_upload: firmware read 24878 bytes.
Apr 25 23:59:15 sander-desktop kernel: [ 2105.252039]
tda10048_firmware_upload: firmware uploading
Apr 25 23:59:20 sander-desktop kernel: [ 2110.930042]
tda18271_write_regs: [6-0060|M] ERROR: idx = 0x25, len = 1,
i2c_transfer returned: -5
Apr 25 23:59:20 sander-desktop kernel: [ 2110.930048]
tda18271_channel_configuration: [6-0060|M] error -5 on line 119
Apr 25 23:59:20 sander-desktop kernel: [ 2110.930055]
tda18271_set_analog_params: [6-0060|M] error -5 on line 1045
Apr 25 23:59:21 sander-desktop kernel: [ 2111.210052]
tda18271_write_regs: [6-0060|M] ERROR: idx = 0x5, len = 1,
i2c_transfer returned: -5
Apr 25 23:59:21 sander-desktop kernel: [ 2111.210057] tda18271_init:
[6-0060|M] error -5 on line 830
Apr 25 23:59:21 sander-desktop kernel: [ 2111.210060] tda18271_tune:
[6-0060|M] error -5 on line 908
Apr 25 23:59:21 sander-desktop kernel: [ 2111.210063]
tda18271_set_analog_params: [6-0060|M] error -5 on line 1045
Apr 25 23:59:24 sander-desktop kernel: [ 2114.260042]
tda10048_firmware_upload: firmware uploaded
Apr 25 23:59:24 sander-desktop kernel: [ 2114.540222]
tda18271_write_regs: [6-0060|M] ERROR: idx = 0x5, len =


Worth noting is that some of those error messages are occuring on
Hauppauge WinTV-HVR-1120 boards as well. Since this Zolid boards is
much similar to the 1120, each boards' problems could be related to
eachother.

Honestly I don't have a clue what's going wrong on my machine, I
suppose changes in the tda18271 code have broken the support. I'm
running 2.6.35-25.


Sander Pientka
