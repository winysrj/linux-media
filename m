Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from outbound.icp-qv1-irony-out3.iinet.net.au ([203.59.1.148])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <timf@iinet.net.au>) id 1Jbd0C-0001yD-F1
	for linux-dvb@linuxtv.org; Tue, 18 Mar 2008 15:41:31 +0100
From: timf <timf@iinet.net.au>
To: Hartmut Hackmann <hartmut.hackmann@t-online.de>
In-Reply-To: <47DEE11F.6060301@t-online.de>
References: <1204893775.10536.4.camel@ubuntu> <47D1A65B.3080900@t-online.de>
	<1205480517.5913.8.camel@ubuntu>  <47DEE11F.6060301@t-online.de>
Date: Tue, 18 Mar 2008 23:40:52 +0900
Message-Id: <1205851252.11231.7.camel@ubuntu>
Mime-Version: 1.0
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Kworld DVB-T 210 - dvb tuning problem
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

Hi Hartmut,


Apologies for the length of this msg, I'm not sure what info you may
need, so I'm trying to show you that all is not right.

1) New install of ubuntu 7.10 i386.

2) Install Me-tv, Tvtime.
Me-tv, in the absence of a channels.conf, scans
via /usr/share/doc/dvb-utils/examples/scan/dvb-t

3) I placed au-Perth_roleystone
into /usr/share/doc/dvb-utils/examples/scan/dvb-t:

# Australia / Perth (Roleystone transmitter)
# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
# SBS
T 704500000 7MHz 2/3 NONE QAM64 8k 1/8 NONE
# ABC
T 725500000 7MHz 3/4 NONE QAM64 8k 1/16 NONE
# Seven
T 746500000 7MHz 2/3 NONE QAM64 8k 1/16 NONE
# Nine
T 767500000 7MHz 3/4 NONE QAM64 8k 1/16 NONE
# Ten
T 788500000 7MHz 3/4 NONE QAM64 8k 1/16 NONE

4) Started Me-tv
Here is the output of Me-tv as it does it's first scan:

Failed to tune to transponder at 704500000	(Yet I'm viewing SBS on a
diff box!)
Failed to tune to transponder at 704500000
Found channel: ABC HDTV
Found channel: ABC1
Found channel: ABC2
Found channel: ABC1
Found channel: ABC3
Found channel: ABC DiG Radio
Found channel: ABC DiG Jazz
Found channel: 7 Digital
Found channel: 7 HD Digital
Found channel: 7 Digital 1
Found channel: 7 Digital 2
Found channel: 7 Digital 3
Found channel: 7 Program Guide
Found channel: Nine Digital
Found channel: Nine HD
Found channel: TEN HD
Found channel: TEN Digital
Found channel: TEN HD

Here is the first channels.conf Me-tv created:

ABC
HDTV:725500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE:516:0:736
ABC1:725500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE:512:650:737
ABC2:725500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE:513:651:738
ABC1:725500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE:512:650:739
ABC3:725500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE:512:650:740
ABC DiG
Radio:725500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE:0:690:742
ABC DiG
Jazz:725500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE:0:700:743
7
Digital:746500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE:1537:1538:1376
7 Digital
1:746500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE:1537:1538:1377
7 Digital
2:746500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE:1537:1538:1378
7 Digital
3:746500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE:1537:1538:1379
7 HD
Digital:746500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE:1601:0:1380
7 Program
Guide:746500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE:1633:1634:1382
Nine
Digital:767500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE:512:650:1025
Nine
HD:767500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE:522:0:1030
TEN
HD:788500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE:514:0:1665
TEN
Digital:788500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE:512:650:1669
TEN
HD:788500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE:514:0:1672

4) Deleted channels.conf, Me-tv rescan:
Here is the output of Me-tv as it does it's second scan:

Failed to tune to transponder at 704500000 (SBS still viewed on diff
box)
Failed to tune to transponder at 704500000
Failed to tune to transponder at 725500000 (only 3 channels here - ABC
HDTV, ABC1, ABC2)
Found channel: ABC HDTV
Found channel: ABC1
Found channel: ABC2
Found channel: ABC1
Found channel: ABC3
Found channel: ABC DiG Radio
Found channel: ABC DiG Jazz
Found channel: 7 Digital
Found channel: 7 HD Digital
Found channel: 7 Digital 1
Found channel: 7 Digital 2
Found channel: 7 Digital 3
Found channel: 7 Program Guide
Found channel: Nine Digital
Found channel: Nine HD
Found channel: TEN HD
Found channel: TEN Digital
Found channel: TEN HD

Here is the second channels.conf Me-tv created:

ABC
HDTV:725500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE:516:0:736
ABC1:725500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE:512:650:737
ABC2:725500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE:513:651:738
ABC1:725500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE:512:650:739
ABC3:725500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE:512:650:740
ABC DiG
Radio:725500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE:0:690:742
ABC DiG
Jazz:725500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE:0:700:743
7
Digital:746500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE:1537:1538:1376
7 Digital
1:746500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE:1537:1538:1377
7 Digital
2:746500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE:1537:1538:1378
7 Digital
3:746500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE:1537:1538:1379
7 HD
Digital:746500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE:1601:0:1380
7 Program
Guide:746500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE:1633:1634:1382
Nine
Digital:767500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE:512:650:1025
Nine
HD:767500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE:522:0:1030
TEN
HD:788500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE:514:0:1665
TEN
Digital:788500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE:512:650:1669
TEN
HD:788500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE:514:0:1672

5) I then started Me-tv.
Here is the message it gave me:

Failed to open video stream: No demux plugin

6) I installed Kaffeine.
I placed au-Perth_roleystone into kaffeine.
This is the channels.dvb created by kaffeine:
#Generated by Kaffeine 0.5

That's correct - zero!
Kaffeine failed to scan anything.

7) Now I started Tvtime, commenced the channel scan, it failed to find
any channel!

8) Back to Kaffeine. No channels found!

9) Back to Me-tv, delete channels.conf.
Starts to scan, it very quickly jumps out with this message:

There are no usable channels in the channels.conf file

10) Reboot.

root@ubuntu2:/home/timf# scan /home/timf/au-Perth_roleystone
> /root/.tzap/channels.conf
scanning /home/timf/au-Perth_roleystone
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
initial transponder 704500000 1 2 9 3 1 2 0
initial transponder 725500000 1 3 9 3 1 1 0
initial transponder 746500000 1 2 9 3 1 1 0
initial transponder 767500000 1 3 9 3 1 1 0
initial transponder 788500000 1 3 9 3 1 1 0
>>> tune to:
704500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to:
704500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE (tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to:
725500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
0x0000 0x02e0: pmt_pid 0x0102 ABC -- ABC HDTV (running)
0x0000 0x02e1: pmt_pid 0x0100 ABC -- ABC1 (running)
0x0000 0x02e2: pmt_pid 0x0101 ABC -- ABC2 (running)
0x0000 0x02e3: pmt_pid 0x0103 ABC -- ABC1 (running)
0x0000 0x02e4: pmt_pid 0x0104 ABC -- ABC3 (running)
0x0000 0x02e6: pmt_pid 0x0105 ABC -- ABC DiG Radio (running)
0x0000 0x02e7: pmt_pid 0x0106 ABC -- ABC DiG Jazz (running)
Network Name 'ABC Perth'
>>> tune to:
746500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
Network Name 'Seven Network'
0x0000 0x0560: pmt_pid 0x0600 Seven Network -- 7 Digital (running)
0x0000 0x0564: pmt_pid 0x0640 Network Seven -- 7 HD Digital (running)
0x0000 0x0561: pmt_pid 0x0610 Seven Network -- 7 Digital 1 (running)
0x0000 0x0562: pmt_pid 0x0620 Network Seven -- 7 Digital 2 (running)
0x0000 0x0563: pmt_pid 0x0630 Network Seven -- 7 Digital 3 (running)
0x0000 0x0566: pmt_pid 0x0660 Seven Network -- 7 Program Guide (running)
>>> tune to:
767500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
0x0000 0x0401: pmt_pid 0x0100 Nine Network -- Nine Digital (running)
0x0000 0x0406: pmt_pid 0x0105 Nine Network -- Nine HD (running)
Network Name 'Nine Network'
>>> tune to:
788500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
0x0000 0x0681: pmt_pid 0x0101 Ten Perth -- TEN HD (running)
0x0000 0x0685: pmt_pid 0x0100 Ten Perth -- TEN Digital (running)
0x0000 0x0688: pmt_pid 0x0107 Ten Perth -- TEN HD (running)
Network Name 'Network TEN'
>>> tune to:
226500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_3_4:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
WARNING: filter timeout pid 0x0011
WARNING: filter timeout pid 0x0000
WARNING: filter timeout pid 0x0010
>>> tune to:
177500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_3_4:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
0x0506 0x0560: pmt_pid 0x0600 Seven Network -- 7 Digital (running)
0x0506 0x0564: pmt_pid 0x0640 Network Seven -- 7 HD Digital (running)
0x0506 0x0561: pmt_pid 0x0610 Seven Network -- 7 Digital 1 (running)
0x0506 0x0562: pmt_pid 0x0620 Network Seven -- 7 Digital 2 (running)
0x0506 0x0563: pmt_pid 0x0630 Network Seven -- 7 Digital 3 (running)
0x0506 0x0566: pmt_pid 0x0660 Seven Network -- 7 Program Guide (running)
Network Name 'Seven Network'
>>> tune to:
191625000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
0x0450 0x0401: pmt_pid 0x0100 Nine Network -- Nine Digital (running)
0x0450 0x0406: pmt_pid 0x0105 Nine Network -- Nine HD (running)
Network Name 'Nine Network'
>>> tune to:
219500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
0x0607 0x0681: pmt_pid 0x0101 Ten Perth -- TEN HD (running)
0x0607 0x0685: pmt_pid 0x0100 Ten Perth -- TEN Digital (running)
0x0607 0x0688: pmt_pid 0x0107 Ten Perth -- TEN HD (running)
Network Name 'Network TEN'
dumping lists (29 services)
Done.
root@ubuntu2:/home/timf# 

11) And yet I am viewing SBS (704.5MHz) on a different box at the same
time!

12) Try a different hard drive.
dmesg after new install ubuntu 7.10 amd64, apply Hartmut's repo, reboot.
NOTE - no firmware found at new install, or after patch.

<snip>
[   44.243956] Linux video capture interface: v2.00
[   44.304301] saa7130/34: v4l2 driver version 0.2.14 loaded
[   44.304666] ACPI: PCI Interrupt 0000:05:01.0[A] -> GSI 17 (level,
low) -> IRQ 17
[   44.304674] saa7133[0]: found at 0000:05:01.0, rev: 209, irq: 17,
latency: 64, mmio: 0xfebff800
[   44.304680] saa7133[0]: subsystem: 17de:7250, board: KWorld DVB-T 210
[card=114,autodetected]
[   44.304690] saa7133[0]: board init: gpio is 100
[   44.356794] parport_pc 00:06: reported by Plug and Play ACPI
[   44.356906] parport0: PC-style at 0x378 (0x778), irq 7, dma 3
[PCSPP,TRISTATE,COMPAT,EPP,ECP,DMA]
[   44.438910] nvidia: module license 'NVIDIA' taints kernel.
[   44.465523] saa7133[0]: i2c eeprom 00: de 17 50 72 ff ff ff ff ff ff
ff ff ff ff ff ff
[   44.465531] saa7133[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   44.465538] saa7133[0]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   44.465544] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   44.465551] saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   44.465557] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   44.465564] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   44.465571] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   44.465577] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   44.465583] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   44.465590] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   44.465596] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   44.465603] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   44.465609] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   44.465616] saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   44.465622] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   44.906833] tuner' 0-004b: chip found @ 0x96 (saa7133[0])
[   45.007476] tda829x 0-004b: setting tuner address to 61
[   45.072125] tda829x 0-004b: type set to tda8290+75a
[   48.964105] saa7133[0]: registered device video0 [v4l2]
[   48.964125] saa7133[0]: registered device vbi0
[   48.964144] saa7133[0]: registered device radio0
[   49.028483] ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 17 (level,
low) -> IRQ 17
[   49.028503] PCI: Setting latency timer of device 0000:02:00.0 to 64
[   49.029096] sky2 0000:02:00.0: v1.18 addr 0xfeafc000 irq 17 Yukon-EC
Ultra (0xb4) rev 3
[   49.029446] sky2 eth0: addr 00:1b:fc:b3:85:32
[   49.029705] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 22 (level,
low) -> IRQ 22
[   49.030157] PCI: Setting latency timer of device 0000:00:1b.0 to 64
[   49.047064] saa7134 ALSA driver for DMA sound loaded
[   49.047089] saa7133[0]/alsa: saa7133[0] at 0xfebff800 irq 17
registered as card -2
[   49.185743] DVB: registering new adapter (saa7133[0])
[   49.185750] DVB: registering frontend 0 (Philips TDA10046H DVB-T)...
[   49.238054] hda_codec: Unknown model for ALC883, trying auto-probe
from BIOS...
[   49.278237] tda1004x: setting up plls for 48MHz sampling clock
[   49.355006] ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level,
low) -> IRQ 16
[   49.355018] PCI: Setting latency timer of device 0000:01:00.0 to 64
[   49.355169] NVRM: loading NVIDIA UNIX x86_64 Kernel Module  100.14.19
Wed Sep 12 14:08:38 PDT 2007
[   50.330401] loop: module loaded
[   50.347517] lp0: using parport0 (interrupt-driven).
[   50.439977] Adding 20474832k swap on /dev/sda3.  Priority:-1
extents:1 across:20474832k
[   50.781333] EXT3 FS on sda2, internal journal
[   51.526526] tda1004x: timeout waiting for DSP ready
[   51.566789] tda1004x: found firmware revision 0 -- invalid
[   51.566794] tda1004x: trying to boot from eeprom
[   51.746062] input: Power Button (FF) as /class/input/input4
<snip>
[   53.686958] Bluetooth: RFCOMM ver 1.8
[   53.912838] tda1004x: timeout waiting for DSP ready
[   53.952857] tda1004x: found firmware revision 0 -- invalid
[   53.952864] tda1004x: waiting for firmware upload...
[   53.989689] tda1004x: no firmware upload (timeout or file not found?)
[   53.989697] tda1004x: firmware upload failed
[   54.084951] tda827x_probe_version: could not read from tuner at addr:
0xc2
[   55.247554] sky2 eth0: Link is up at 100 Mbps, full duplex, flow
control rx
[   58.000140] NET: Registered protocol family 17
[   59.463229] NET: Registered protocol family 10
[   59.463448] lo: Disabled Privacy Extensions
[   70.223095] eth0: no IPv6 routers present
timf@ubuntu:~$ 

13) Most times, "tda1004x: found firmware revision 20 -- ok" appears
from a new install of ubuntu.
Shouldn't have to but will copy firmware into /lib...

Again, dmesg
<snip>
[   44.705797] Linux video capture interface: v2.00
[   44.715868] ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 17 (level,
low) -> IRQ 17
[   44.715882] PCI: Setting latency timer of device 0000:02:00.0 to 64
[   44.716338] sky2 0000:02:00.0: v1.18 addr 0xfeafc000 irq 17 Yukon-EC
Ultra (0xb4) rev 3
[   44.716629] sky2 eth0: addr 00:1b:fc:b3:85:32
[   44.743125] nvidia: module license 'NVIDIA' taints kernel.
[   44.999183] ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level,
low) -> IRQ 16
[   44.999192] PCI: Setting latency timer of device 0000:01:00.0 to 64
[   44.999283] NVRM: loading NVIDIA UNIX x86_64 Kernel Module  100.14.19
Wed Sep 12 14:08:38 PDT 2007
[   45.038102] saa7130/34: v4l2 driver version 0.2.14 loaded
[   45.038164] ACPI: PCI Interrupt 0000:05:01.0[A] -> GSI 17 (level,
low) -> IRQ 17
[   45.038172] saa7133[0]: found at 0000:05:01.0, rev: 209, irq: 17,
latency: 64, mmio: 0xfebff800
[   45.038177] saa7133[0]: subsystem: 17de:7250, board: KWorld DVB-T 210
[card=114,autodetected]
[   45.038184] saa7133[0]: board init: gpio is 100
[   45.193124] saa7133[0]: i2c eeprom 00: de 17 50 72 ff ff ff ff ff ff
ff ff ff ff ff ff
[   45.193138] saa7133[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   45.193149] saa7133[0]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   45.193160] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   45.193171] saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   45.193181] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   45.193192] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   45.193203] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   45.193214] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   45.193225] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   45.193236] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   45.193246] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   45.193257] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   45.193268] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   45.193279] saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   45.193290] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   45.362597] tuner' 0-004b: chip found @ 0x96 (saa7133[0])
[   45.451089] tda829x 0-004b: setting tuner address to 61
[   45.515667] tda829x 0-004b: type set to tda8290+75a
[   49.411813] saa7133[0]: registered device video0 [v4l2]
[   49.411839] saa7133[0]: registered device vbi0
[   49.411867] saa7133[0]: registered device radio0
[   49.476227] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 22 (level,
low) -> IRQ 22
[   49.476832] PCI: Setting latency timer of device 0000:00:1b.0 to 64
[   49.491099] saa7134 ALSA driver for DMA sound loaded
[   49.491124] saa7133[0]/alsa: saa7133[0] at 0xfebff800 irq 17
registered as card -2
[   49.629385] DVB: registering new adapter (saa7133[0])
[   49.629392] DVB: registering frontend 0 (Philips TDA10046H DVB-T)...
[   49.685697] hda_codec: Unknown model for ALC883, trying auto-probe
from BIOS...
[   49.721872] tda1004x: setting up plls for 48MHz sampling clock
[   50.650342] loop: module loaded
[   50.679408] lp0: using parport0 (interrupt-driven).
[   50.760172] Adding 20474832k swap on /dev/sda3.  Priority:-1
extents:1 across:20474832k
[   51.084663] EXT3 FS on sda2, internal journal
[   51.986627] tda1004x: timeout waiting for DSP ready
[   52.023796] input: Power Button (FF) as /class/input/input4
[   52.023813] ACPI: Power Button (FF) [PWRF]
[   52.023912] input: Power Button (CM) as /class/input/input5
[   52.023925] ACPI: Power Button (CM) [PWRB]
[   52.026680] tda1004x: found firmware revision 0 -- invalid
[   52.026685] tda1004x: trying to boot from eeprom
[   52.092993] No dock devices found.
<snip>
[   54.015117] Bluetooth: RFCOMM ver 1.8
[   54.384480] tda1004x: timeout waiting for DSP ready
[   54.424482] tda1004x: found firmware revision 0 -- invalid
[   54.424485] tda1004x: waiting for firmware upload...
[   55.760359] sky2 eth0: Link is up at 100 Mbps, full duplex, flow
control rx
[   58.951632] NET: Registered protocol family 17
[   62.002779] NET: Registered protocol family 10
[   62.002992] lo: Disabled Privacy Extensions
[   72.014443] eth0: no IPv6 routers present
[   73.030281] tda1004x: found firmware revision 20 -- ok
timf@ubuntu:~$ 

14) Again exactly same result as last time with dvb, analog.

15) With this refactoring, do the app developers have to adjust
anything? Tzap has problems also.

This actually worse than before, it is now not tuning correctly.
What do I try next? Very frustrating.
Do you want any debug options?

PS. I've actually managed to get the remote to work through a very
convoluted approach via the archives (Hermann), using ir-kbd-i2c.c,
saa7134-i2c.c. But it's no use unless we can fix this tuning/scanning
issue.

Regards,
Tim


On Mon, 2008-03-17 at 22:22 +0100, Hartmut Hackmann wrote:
> Hi, Tim
> 
> timf schrieb:
> > On Fri, 2008-03-07 at 21:32 +0100, Hartmut Hackmann wrote:
> >> Hi, Tim
> >>
> >> timf schrieb:
> >>> Hi Hartmut,
> >>> I noticed you had a bit to do with implementing this card.
> >>>
> >>> With a fresh install of ubuntu 7.10 (kernel i386 2.6.22-14-generic),
> >>> the card is auto recognised as: Kworld DVB-T 210 (card=114)
> >>>
> >>> However, tda1004 firmware does not load.
> >>> Used download-firmware, placed dvb-fe-tda10046.fw
> >>> into /lib/firmware/2.6.22-14-generic
> >>>
> >>> Rebooted.
> >>>
> >>> Now, again card is recognised, firmware recognised as version 20.
> >>> Here is the strange part:
> >>> - using dvb-utils scan, each time I run that I get a different result in
> >>> channels.
> >>> - I try to scan with Kaffeine - nothing
> >>> - I try to scan with Me-tv - nothing
> >>> - I try to scan with tvtime - all channels obtained ( no audio).
> >>>
> >>> Now, after reboot, if I first start tvtime (analog tv), view a channel,
> >>> turn tvtime off, and then :
> >>> - if I place a previously good channels.dvb in Kaffeine - it plays all
> >>> channels.
> >>> - if I place a previously good channels.conf in Me-tv - it plays all
> >>> channels. 
> >>>
> >>> Would it be correct to say that the "switch" is not working for DVB
> >>> after boot?
> >>>
> >>> I have studied the code, but I need your help to point me in the right
> >>> direction.
> >>>
> >>> Thanks,
> >>> Tim
> >>>
> >> Hermann reported something similar. I have an idea what the reason could
> >> be. Please let me check.
> >> Best regards
> >>   Hartmut
> > 
> > Hi Hartmut,
> > 
> > Further to this, is the Remote Control meant to work for this card?
> > 
> <snip>
> Looks like the Remote is not supported. I can't help here since i don't have access
> to this card.
> 
> 
> In my personal Repository:
>   http://linuxtv.org/hg/~hhackmann/v4l-dvb/
> the problems with the tuning code should be fixed.
> Can you please give it a try?
> 
> Best Regards
>   Hartmut

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
