Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from mail-out.m-online.net ([212.18.0.9])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <zzam@gentoo.org>) id 1JPHgq-0005h9-Es
	for linux-dvb@linuxtv.org; Wed, 13 Feb 2008 14:30:20 +0100
From: Matthias Schwarzott <zzam@gentoo.org>
To: Eduard Huguet <eduardhc@gmail.com>
Date: Wed, 13 Feb 2008 14:29:48 +0100
References: <47ADC81B.4050203@gmail.com> <200802122208.07450.zzam@gentoo.org>
	<47B2E157.3050702@gmail.com>
In-Reply-To: <47B2E157.3050702@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802131429.48596.zzam@gentoo.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Some tests on Avermedia A700
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
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On Mittwoch, 13. Februar 2008, Eduard Huguet wrote:
> Hi,
>     Here you have the dmesg output of "modprobe saa7134 i2c_scan=1":
>
> [  773.619247] saa7133[0]: found at 0000:00:09.0, rev: 209, irq: 23,
> latency: 64, mmio: 0xf7ffa800
> [  773.619258] saa7133[0]: subsystem: 1461:a7a1, board: Avermedia A700
> [card=132,autodetected]
> [  773.619273] saa7133[0]: board init: gpio is 2f200
> [  773.865218] saa7133[0]: i2c eeprom 00: 61 14 a1 a7 ff ff ff ff ff ff
> ff ff ff ff ff ff
> [  773.865270] saa7133[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [  773.865312] saa7133[0]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [  773.865351] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [  773.865393] saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [  773.865433] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [  773.865459] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [  773.865702] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [  773.865727] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [  773.865753] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [  773.865780] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [  773.865810] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [  773.865840] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [  773.865868] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [  773.865897] saa7133[0]: i2c eeprom e0: 00 01 81 af ea b5 ff ff ff ff
> ff ff ff ff ff ff
> [  773.865923] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff
> ff ff ff ff ff ff
> [  773.870157] saa7133[0]: i2c scan: found device @ 0x1c  [???]
> [  773.883118] saa7133[0]: i2c scan: found device @ 0xa0  [eeprom]
> [  773.891907] saa7133[0]: registered device video0 [v4l2]
> [  773.892250] saa7133[0]: registered device vbi0
> [  774.011780] zl1003x_attach: tuner initialization (Zarlink ZL10036
> addr=0x60) ok
> [  774.011805] DVB: registering new adapter (saa7133[0])
> [  774.011819] DVB: registering frontend 0 (Zarlink ZL10313 DVB-S)...
>
>
> These are the results of "lspci -vvnn" (after loading the driver):
>
> 00:09.0 Multimedia controller [0480]: Philips Semiconductors
> SAA7133/SAA7135 Video Broadcast Decoder [1131:7133] (rev d1)
>         Subsystem: Avermedia Technologies Inc Unknown device [1461:a7a1]
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR+ FastB2B- DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 64 (63750ns min, 63750ns max)
>         Interrupt: pin A routed to IRQ 23
>         Region 0: Memory at f7ffa800 (32-bit, non-prefetchable) [size=2K]
>         Capabilities: [40] Power Management version 2
>                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                 Status: D0 PME-Enable- DSel=0 DScale=3 PME-
>         Kernel driver in use: saa7134
>         Kernel modules: saa7134
>
added note about different gpio values and eeprom content to wiki.

Regards
Matthias
-- 
Matthias Schwarzott (zzam)

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
