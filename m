Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2.signet.nl ([83.96.147.103]:34882 "EHLO smtp2.signet.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751143AbdLZUCV (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Dec 2017 15:02:21 -0500
Received: from webmail.dds.nl (app2.dds.nl [81.21.136.118])
        by smtp2.signet.nl (Postfix) with ESMTP id BDE9440C27FE
        for <linux-media@vger.kernel.org>; Tue, 26 Dec 2017 20:55:17 +0100 (CET)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Tue, 26 Dec 2017 20:55:18 +0100
From: Xen <list@xenhideout.nl>
To: linux-media@vger.kernel.org
Subject: Philips Tiger TDA10046H/SAA7131e/TDA8290+75a corruption due to bad
 card loaded
Message-ID: <24fe0f3be8a3a6114183ca772f711e2e@xenhideout.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I'm not sure this is the right place but there are no user mailing lists 
anymore for V4L?

I have a Gigabyte GT-PTV-TAF-RH rev d0 card that others report as 
working since long time.

01:07.0 Multimedia controller: Philips Semiconductors 
SAA7131/SAA7133/SAA7135 Video Broadcast Decoder (rev d0)

I loaded this card using the wrong card identifier, I used 78:

card=78 -> ASUSTeK P7131 Dual                       1043:4862

and DVB-T worked for a while.

Within a day DVB-T stopped working:


$ dvbv5-scan nl-Free
Cannot calc frequency shift. Either bandwidth/symbol-rate is unavailable 
(yet).
Scanning frequency #1 618000000
Lock   (0x1f) Signal= 0,00% C/N= 77,65% UCB= 50886 postBER= 131070
ERROR    dvb_read_sections: no data read on section filter
ERROR    error while waiting for PAT table


VLC output:


[00007fa784005eb8] ts demux error: libdvbpsi error (PSI decoder): TS 
discontinuity (received 1, expected 11) for PID 0
[00007fa784005eb8] ts demux error: libdvbpsi error (PSI decoder): PSI 
section too long
[00007fa784005eb8] ts demux error: libdvbpsi error (misc PSI): Bad 
CRC_32 table 0xb7 !!!
[00007fa784005eb8] ts demux error: libdvbpsi error (PSI decoder): PSI 
section too long


To get output using card=78, I had to connect the cable to the FM 
connector; it has an "FM" and "TV" connector and I had to use the "FM" 
one to get DVB-T signal I could lock on to and successfully scan and 
view in VLC.

With card=81, this is now the "TV" connector, as it should be of course, 
but I did not know that in advance.

However after about 6 hours of usage the functioning ceased and I got 
the above output on the FM input (that was working before), and now with 
card=81, I get the same output on the TV connector. Consequently, I 
tried using this card in Windows XP SP3 32-bit, for which there are 
drivers, and no functioning; I did not test prior to this failing in 
Linux.

Did I wreck my card by using the wrong card= selector?

Would there by any way to reset this card to its default state in that 
case?







$ dmesg | grep saa
[  110.480504] saa7134: saa7130/34: v4l2 driver version 0, 2, 17 loaded
[  110.480799] saa7134: saa7133[0]: found at 0000:01:07.0, rev: 208, 
irq: 17, latency: 32, mmio: 0xfdeff000
[  110.480802] saa7134: saa7133[0]: subsystem: 1458:9001, board: Philips 
Tiger reference design [card=81,insmod option]
[  110.480820] saa7134: saa7133[0]: board init: gpio is 0
[  110.641457] saa7134: i2c eeprom 00: 58 14 01 90 54 20 1c 00 43 43 a9 
1c 55 d2 b2 92
[  110.641459] saa7134: i2c eeprom 10: 00 01 20 00 ff 20 ff 00 00 00 00 
00 00 00 00 00
[  110.641459] saa7134: i2c eeprom 20: 01 40 01 02 02 01 01 03 08 ff 00 
d5 00 00 00 00
[  110.641460] saa7134: i2c eeprom 30: 00 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00
[  110.641461] saa7134: i2c eeprom 40: ff 21 00 c2 96 10 03 32 15 00 00 
00 00 00 00 00
[  110.641461] saa7134: i2c eeprom 50: ff 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00
[  110.641462] saa7134: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00
[  110.641462] saa7134: i2c eeprom 70: 00 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00
[  110.641463] saa7134: i2c eeprom 80: 00 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00
[  110.641463] saa7134: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00
[  110.641464] saa7134: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00
[  110.641464] saa7134: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00
[  110.641465] saa7134: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00
[  110.641465] saa7134: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00
[  110.641466] saa7134: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00
[  110.641466] saa7134: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00

[  110.773504] tuner: 2-004b: Tuner -1 found with type(s) Radio TV.
[  110.901497] tda829x 2-004b: setting tuner address to 61
[  111.001643] tda829x 2-004b: type set to tda8290+75a

[  115.321420] saa7134: saa7133[0]: registered device video0 [v4l2]
[  115.321510] saa7134: saa7133[0]: registered device vbi0
[  115.321543] saa7134: saa7133[0]: registered device radio0
[  115.590567] saa7134_alsa: saa7134 ALSA driver for DMA sound loaded
[  115.590597] saa7134_alsa: saa7133[0]/alsa: saa7133[0] at 0xfdeff000 
irq 17 registered as card -2
[  116.146794] saa7134_dvb: dvb_init() allocating 1 frontend
[  116.161494] dvbdev: DVB: registering new adapter (saa7133[0])
[  116.161502] saa7134 0000:01:07.0: DVB: registering adapter 0 frontend 
0 (Philips TDA10046H DVB-T)...
