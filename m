Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from main.gmane.org ([80.91.229.2] helo=ciao.gmane.org)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <gldd-linux-dvb@m.gmane.org>) id 1JkOub-0004If-NB
	for linux-dvb@linuxtv.org; Fri, 11 Apr 2008 21:27:55 +0200
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1JkOuU-00021l-6r
	for linux-dvb@linuxtv.org; Fri, 11 Apr 2008 19:27:42 +0000
Received: from 91.68.208.8 ([91.68.208.8])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-dvb@linuxtv.org>; Fri, 11 Apr 2008 19:27:42 +0000
Received: from frederic by 91.68.208.8 with local (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-dvb@linuxtv.org>; Fri, 11 Apr 2008 19:27:42 +0000
To: linux-dvb@linuxtv.org
From: Frederic MASSOT <frederic@juliana-multimedia.com>
Date: Fri, 11 Apr 2008 21:25:30 +0200
Message-ID: <ftoe35$pdu$1@ger.gmane.org>
Mime-Version: 1.0
Subject: [linux-dvb] No TV after an dist-upgrade
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi,

There is still one week, I was watching TV (DVB-T) on my PC with
Kaffeine without problems. My PC uses a Debian Etch, last weekend I do
an update to Etch (final), then Lenny, since everything works except the
TV. Strange !?

I use a DVB-T card ASUSTeK P7131 Dual, and I use a custom Linux kernel
2.6.24 with DVB support. I kept the same kernel (2.6.24) before and
after the upgrade.

- The card is well recognized by the kernel, dmesg output:

saa7133[0]: found at 0000:05:03.0, rev: 209, irq: 16, latency: 64, mmio:
0xff7ff000
saa7133[0]: subsystem: 1043:4876, board: ASUSTeK P7131 Hybrid
[card=3D112,autodetected]
saa7133[0]: board init: gpio is 0
input: saa7134 IR (ASUSTeK P7131 Hybri as /class/input/input4
saa7133[0]: i2c eeprom 00: 43 10 76 48 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
saa7133[0]: i2c eeprom 10: ff ff ff 0f ff 20 ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 20: 01 40 01 02 03 01 01 03 08 ff 00 d5 ff ff ff ff
saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 40: ff 21 00 c2 96 10 03 32 55 50 ff ff ff ff ff ff
saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
tuner 1-004b: chip found @ 0x96 (saa7133[0])
tda8290 1-004b: setting tuner address to 61
tuner 1-004b: type set to tda8290+75a
tda8290 1-004b: setting tuner address to 61
tuner 1-004b: type set to tda8290+75a
saa7133[0]: registered device video0 [v4l2]
saa7133[0]: registered device vbi0
saa7133[0]: registered device radio0
DVB: registering new adapter (saa7133[0])
DVB: registering frontend 0 (Philips TDA10046H DVB-T)...
tda1004x: setting up plls for 48MHz sampling clock
tda1004x: timeout waiting for DSP ready
tda1004x: found firmware revision 0 -- invalid
tda1004x: trying to boot from eeprom
tda1004x: timeout waiting for DSP ready
tda1004x: found firmware revision 0 -- invalid
tda1004x: waiting for firmware upload...
tda1004x: found firmware revision 29 -- ok
saa7134 ALSA driver for DMA sound loaded
saa7133[0]/alsa: saa7133[0] at 0xff7ff000 irq 16 registered as card -1


- Devices :
$ ls -l /dev/dvb/adapter0/
crw-rw---- 1 root video 212, 4 avr 11 19:55 demux0
crw-rw---- 1 root video 212, 5 avr 11 19:55 dvr0
crw-rw---- 1 root video 212, 3 avr 11 19:55 frontend0
crw-rw---- 1 root video 212, 7 avr 11 19:55 net0


- I use the file fr-Vannes, when I scan, I have these messages :

$ sudo scan /usr/share/doc/dvb-utils/examples/scan/dvb-t/fr-Vannes
scanning /usr/share/doc/dvb-utils/examples/scan/dvb-t/fr-Vannes
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
initial transponder 674167000 0 2 9 3 1 0 0
initial transponder 698167000 0 2 9 3 1 0 0
initial transponder 762167000 0 2 9 3 1 0 0
initial transponder 778167000 0 2 9 3 1 0 0
initial transponder 818167000 0 2 9 3 1 0 0
>>> tune to:
674167000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSI=
ON_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
WARNING: filter timeout pid 0x0502
WARNING: filter timeout pid 0x0504
WARNING: filter timeout pid 0x050a
WARNING: filter timeout pid 0x0500
WARNING: filter timeout pid 0x0011
WARNING: filter timeout pid 0x0503
WARNING: filter timeout pid 0x0506
WARNING: filter timeout pid 0x0505
WARNING: filter timeout pid 0x0010
>>> tune to:
698167000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSI=
ON_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
WARNING: filter timeout pid 0x0011
WARNING: filter timeout pid 0x0000
WARNING: filter timeout pid 0x0010
>>> tune to:
762167000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSI=
ON_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
WARNING: filter timeout pid 0x0011
WARNING: filter timeout pid 0x0000
WARNING: filter timeout pid 0x0010
>>> tune to:
778167000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSI=
ON_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
WARNING: filter timeout pid 0x0011
WARNING: filter timeout pid 0x0000
WARNING: filter timeout pid 0x0010
>>> tune to:
818167000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSI=
ON_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
WARNING: filter timeout pid 0x0011
WARNING: filter timeout pid 0x0000
WARNING: filter timeout pid 0x0010
dumping lists (7 services)
[0201]:674167000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRA=
NSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE:0:0:513
[0207]:674167000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRA=
NSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE:0:0:519
[02ff]:674167000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRA=
NSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE:0:0:767
[0206]:674167000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRA=
NSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE:0:0:518
[0205]:674167000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRA=
NSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE:0:0:517
[0204]:674167000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRA=
NSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE:0:0:516
[0203]:674167000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRA=
NSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE:0:0:515
Done.



I have no error messages in the log, it's one week that I seek, I do not
understand what is no longer working.


Regards.
-- =

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
|              FR=C9D=C9RIC MASSOT               |
|     http://www.juliana-multimedia.com      |
|   mailto:frederic@juliana-multimedia.com   |
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3DDebian=3DGNU/Linux=3D=3D=3D


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
