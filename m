Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-09.arcor-online.net ([151.189.21.49]:39361 "EHLO
	mail-in-09.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754524Ab0GEV2j (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Jul 2010 17:28:39 -0400
Subject: Re: Fwd: Firmware for HVR-1110
From: hermann pitton <hermann-pitton@arcor.de>
To: JD <jdg8tb@gmail.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <loom.20100705T210627-182@post.gmane.org>
References: <AANLkTimQqT99icH6wGhyizm-Zymg_wNrLhxS4yqGo1Wu@mail.gmail.com>
	 <AANLkTilBXOV-7d4mOtbwfZdiAy9qiWZiVB-aHR7x0OPm@mail.gmail.com>
	 <1278213195.3229.11.camel@pc07.localdom.local>
	 <loom.20100705T145800-336@post.gmane.org>
	 <loom.20100705T210627-182@post.gmane.org>
Content-Type: text/plain
Date: Mon, 05 Jul 2010 23:27:17 +0200
Message-Id: <1278365237.6089.25.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, JD,

Am Montag, den 05.07.2010, 19:08 +0000 schrieb JD:
> >
> 
> All seems to be working fine now, I followed the installtion guide for the
> HVR-1120 and used the tda10048 f/w and I can now find DVB channels; I am still
> not sure as to why my card is looking for a different f/w tho, and would like to
> know why if anyone finds out.
> 
> Thanks for your help.
> 

can't see the problem with different firmware in your logs.

I guess the root cause for all your prior trouble was that the HVR 1120
is packed as a HVR1110.

Such unfortunately is a known problem with new Hauppauge products since
a decade :(

That flaw is compensated by best auto detection and open eeprom content.
Also guys like Steven and Michael did develop the drivers you need on
that new card during their free time. (demodulator is in serial TS mode
and new tuner on saa7134)

All auto detection looks OK and of course also correct firmware is
uploaded then. Especially the C2 tuner variant is still quite new and I
guess Michael would prefer reports based on code on development level. 

Cheers,
Hermann


[   12.185935] saa7130/34: v4l2 driver version 0.2.15 loaded
[   12.185990] saa7134 0000:03:04.0: PCI INT A -> GSI 16 (level, low) ->
IRQ 16
[   12.185997] saa7133[0]: found at 0000:03:04.0, rev: 209, irq: 16,
latency: 64, mmio: 0xfebff800
[   12.186004] saa7133[0]: subsystem: 0070:6707, board: Hauppauge
WinTV-HVR1120 DVB-T/Hybrid [card=156,autodetected]
[   12.186027] saa7133[0]: board init: gpio is 40000
[   12.208619] IRQ 16/saa7133[0]: IRQF_DISABLED is not guaranteed on
shared IRQs
[   12.222966] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low)
-> IRQ 16
[   12.223016] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   12.292676] hda_codec: ALC662 rev1: BIOS auto-probing.
[   12.294322] input: HDA Digital PCBeep
as /devices/pci0000:00/0000:00:1b.0/input/input6
[   12.360024] saa7133[0]: i2c eeprom 00: 70 00 07 67 54 20 1c 00 43 43
a9 1c 55 d2 b2 92
[   12.360044] saa7133[0]: i2c eeprom 10: ff ff ff 0e ff 20 ff ff ff ff
ff ff ff ff ff ff
[   12.360062] saa7133[0]: i2c eeprom 20: 01 40 01 32 32 01 01 33 88 ff
00 b0 ff ff ff ff
[   12.360080] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   12.360097] saa7133[0]: i2c eeprom 40: ff 35 00 c0 96 10 06 32 97 04
00 20 00 ff ff ff
[   12.360114] saa7133[0]: i2c eeprom 50: ff 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   12.360131] saa7133[0]: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   12.360149] saa7133[0]: i2c eeprom 70: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   12.360166] saa7133[0]: i2c eeprom 80: 84 09 00 04 20 77 00 40 ba 54
5e f0 73 05 29 00
[   12.360183] saa7133[0]: i2c eeprom 90: 84 08 00 06 89 06 01 00 95 19
8d 72 07 70 73 09
[   12.360201] saa7133[0]: i2c eeprom a0: 23 5f 73 0a f4 9b 72 0b 2f 72
0e 01 72 0f 01 72
[   12.360215] saa7133[0]: i2c eeprom b0: 10 01 72 11 ff 73 13 a2 69 79
8d 00 00 00 00 00
[   12.360224] saa7133[0]: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   12.360233] saa7133[0]: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   12.360241] saa7133[0]: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   12.360250] saa7133[0]: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[   12.360260] i2c i2c-1: Invalid 7-bit address 0x7a
[   12.360745] tveeprom 1-0050: Hauppauge model 67209, rev C1F5, serial#
6182074
[   12.360748] tveeprom 1-0050: MAC address is 00-0D-FE-5E-54-BA
[   12.360750] tveeprom 1-0050: tuner model is NXP 18271C2 (idx 155,
type 54)
[   12.360753] tveeprom 1-0050: TV standards PAL(B/G) PAL(I) SECAM(L/L')
PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xf4)
[   12.360755] tveeprom 1-0050: audio processor is SAA7131 (idx 41)
[   12.360757] tveeprom 1-0050: decoder processor is SAA7131 (idx 35)
[   12.360759] tveeprom 1-0050: has radio, has IR receiver, has no IR
transmitter
[   12.360761] saa7133[0]: hauppauge eeprom: model=67209
[   12.628148] tuner 1-004b: chip found @ 0x96 (saa7133[0])
[   12.695985] r8169: eth0: link up
[   12.695992] r8169: eth0: link up
[   12.708063] tda829x 1-004b: setting tuner address to 60
[   12.954972] tda18271 1-0060: creating new instance
[   13.000021] TDA18271HD/C2 detected @ 1-0060
[   14.458202] CPU0 attaching NULL sched-domain.
[   14.458209] CPU1 attaching NULL sched-domain.
[   14.480104] CPU0 attaching sched-domain:
[   14.480108]  domain 0: span 0-1 level MC
[   14.480110]   groups: 0 1
[   14.480116] CPU1 attaching sched-domain:
[   14.480118]  domain 0: span 0-1 level MC
[   14.480120]   groups: 1 0
[   14.520030] tda18271: performing RF tracking filter calibration
[   15.810914] CPU0 attaching NULL sched-domain.
[   15.810921] CPU1 attaching NULL sched-domain.
[   15.832110] CPU0 attaching sched-domain:
[   15.832114]  domain 0: span 0-1 level MC
[   15.832117]   groups: 0 1
[   15.832122] CPU1 attaching sched-domain:
[   15.832124]  domain 0: span 0-1 level MC
[   15.832126]   groups: 1 0
[   23.436017] eth0: no IPv6 routers present
[   32.908024] tda18271: RF tracking filter calibration complete
[   32.964027] tda829x 1-004b: type set to tda8290+18271
[   37.940216] saa7133[0]: registered device video0 [v4l2]
[   37.940278] saa7133[0]: registered device vbi0
[   37.940335] saa7133[0]: registered device radio0
[   37.955306] saa7134 ALSA driver for DMA sound loaded
[   37.955319] IRQ 16/saa7133[0]: IRQF_DISABLED is not guaranteed on
shared IRQs
[   37.955342] saa7133[0]/alsa: saa7133[0] at 0xfebff800 irq 16
registered as card -2
[   37.996093] dvb_init() allocating 1 frontend
[   38.112029] tda829x 1-004b: type set to tda8290
[   38.128160] tda18271 1-0060: attaching existing instance
[   38.128166] DVB: registering new adapter (saa7133[0])
[   38.128172] DVB: registering adapter 0 frontend 0 (NXP TDA10048HN
DVB-T)...
[   38.456026] tda10048_firmware_upload: waiting for firmware upload
(dvb-fe-tda10048-1.0.fw)...
[   38.456034] saa7134 0000:03:04.0: firmware: requesting
dvb-fe-tda10048-1.0.fw
[   38.478776] tda10048_firmware_upload: firmware read 24878 bytes.
[   38.478780] tda10048_firmware_upload: firmware uploading
[   42.600036] tda10048_firmware_upload: firmware uploaded
[   44.720534] tda18271_write_regs: ERROR: idx = 0x5, len = 1,
i2c_transfer returned: -5
[   44.720542] tda18271c2_rf_tracking_filters_correction: error -5 on
line 264
[   46.012535] tda18271_write_regs: ERROR: idx = 0x13, len = 1,
i2c_transfer returned: -5
[   47.048045] tda18271_write_regs: ERROR: idx = 0x5, len = 1,
i2c_transfer returned: -5
[   47.048056] tda18271_set_analog_params: error -5 on line 1041


