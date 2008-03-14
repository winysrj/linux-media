Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from outbound.icp-qv1-irony-out2.iinet.net.au ([203.59.1.107])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ihaywood@iinet.net.au>) id 1Ja7yy-0007IM-HY
	for linux-dvb@linuxtv.org; Fri, 14 Mar 2008 12:21:54 +0100
From: Ian Haywood <ihaywood@iinet.net.au>
To: linux-dvb <linux-dvb@linuxtv.org>
Date: Fri, 14 Mar 2008 22:23:03 +1100
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803142223.03954.ihaywood@iinet.net.au>
Subject: [linux-dvb] Tevion DVBT-220RF - tuning problem recurring on new
	kernels
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
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

I am unable to tune digital TV 
on a Tevion DVB T-220RF using kernel 2.6.24.3

> sudo scan -v /usr/share/doc/dvb-utils/examples/scan/dvb-t/au-Melbourne
scanning /usr/share/doc/dvb-utils/examples/scan/dvb-t/au-Melbourne
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
initial transponder 226500000 1 3 9 3 1 1 0
initial transponder 177500000 1 2 9 3 1 2 0
initial transponder 191625000 1 3 9 3 1 1 0
initial transponder 219500000 1 3 9 3 1 1 0
initial transponder 536625000 1 2 9 3 1 2 0
>>> tune to: 226500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
WARNING: >>> tuning failed!!!


This problem seems identical to that solved in 
http://www.linuxtv.org/pipermail/linux-dvb/2006-January/007689.html

however the relevant code seems to have changed since the fix was 
described and I can't seem to replicate it using the new driver code.
Specifically, manually editing saa7134-cards.c or tda8290.c to
set the the tuner address to 0x60 from 0x61 just stops the tda8290 driver
from loading.

I am using kernel 2.6.24.3,
The relevant dmesg entries are:
[   46.632313] saa7133[0]: found at 0000:00:0a.0, rev: 208, irq: 20, latency: 32, mmio: 0xe6008000
[   46.632946] saa7133[0]: subsystem: 17de:7201, board: Tevion/KWorld DVB-T 220RF [card=88,autodetected]
[   46.633026] saa7133[0]: board init: gpio is 100
[   46.770494] saa7133[0]: i2c eeprom 00: de 17 01 72 ff ff ff ff ff ff ff ff ff ff ff ff
[   46.771227] saa7133[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   46.771956] saa7133[0]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   46.772693] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   46.773440] saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   46.774167] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   46.774894] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   46.775623] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   47.009197] tuner 0-004b: chip found @ 0x96 (saa7133[0])
[   47.057166] tda8290 0-004b: setting tuner address to 61
[   47.161150] tuner 0-004b: type set to tda8290+75a
[   47.209142] tda8290 0-004b: setting tuner address to 61
[   47.313131] tuner 0-004b: type set to tda8290+75a
[   47.315906] saa7133[0]: registered device video0 [v4l2]
[   47.315984] saa7133[0]: registered device vbi0
[   47.316060] saa7133[0]: registered device radio0
......
[   47.611627] DVB: registering new adapter (saa7133[0])
[   47.611690] DVB: registering frontend 0 (Philips TDA10046H DVB-T)...
[   47.681091] tda1004x: setting up plls for 48MHz sampling clock
.......
[   49.614319] tda1004x: found firmware revision 23 -- ok

(The driver doesn't seem to pay any attention to firmware in /lib/firmware)

FWIW as an analogue tuner the saa7134 works 100%

Thanks for any help,

Ian Haywood

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
