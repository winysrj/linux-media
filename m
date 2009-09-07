Return-path: <linux-media-owner@vger.kernel.org>
Received: from dsl-202-173-134-75.nsw.westnet.com.au ([202.173.134.75]:51327
	"EHLO mail.lemonrind.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241AbZIGRc2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Sep 2009 13:32:28 -0400
Subject: Re: Fusion HDTV Dual Digital Express - NSW Australia
Mime-Version: 1.0 (Apple Message framework v1075.2)
Content-Type: text/plain; charset=us-ascii; format=flowed; delsp=yes
From: Alex Ferrara <alex@receptiveit.com.au>
In-Reply-To: <702870ef0909070452o5eef67b5p6505c3db301ea65f@mail.gmail.com>
Date: Tue, 8 Sep 2009 03:32:25 +1000
Cc: linux-media@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <913A3AE3-6225-4C0B-AF44-716E993C4E6B@receptiveit.com.au>
References: <D8912B36-7521-4559-9E7A-3B9A7F6DC1E1@receptiveit.com.au> <702870ef0909070452o5eef67b5p6505c3db301ea65f@mail.gmail.com>
To: Vincent McIntyre <vincent.mcintyre@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I probably should elaborate a little.

I have two mythtv servers, one is in production with the two Dual  
Digital 4 PCI cards. I believe they are v2, and tht machine is running  
perfectly.

 > cat /etc/issue
Ubuntu 8.10

 > uname -a
Linux kaylee 2.6.27-8-server #1 SMP Thu Nov 6 18:18:16 UTC 2008 x86_64  
GNU/Linux

 > lsusb
Bus 013 Device 003: ID 0fe9:db98 DVICO
Bus 013 Device 002: ID 0fe9:db98 DVICO
Bus 013 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 012 Device 003: ID 0fe9:db98 DVICO
Bus 012 Device 002: ID 0fe9:db98 DVICO
Bus 012 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub

Now I did have the PCIe cards in that machine at one stage, but they  
played up sufficiently that I removed them and decided to revisit the  
issue at a later date.

I have recently built a development mythtv machine. It was installed  
with Ubuntu 9.04 but I have updated to the development tree of Ubuntu  
9.10 to preview Mythtv 0.22, which looks quite nice I might add.

My dev mythtv machine has the following

 >cat /etc/issue
Ubuntu karmic (development branch)

 >uname -a
Linux poseidon 2.6.31-9-server #29-Ubuntu SMP Sun Aug 30 18:37:42 UTC  
2009 x86_64 GNU/Linux

 >lspci
00:00.0 Host bridge: Intel Corporation 4 Series Chipset DRAM  
Controller (rev 03)
00:02.0 VGA compatible controller: Intel Corporation 4 Series Chipset  
Integrated Graphics Controller (rev 03)
00:02.1 Display controller: Intel Corporation 4 Series Chipset  
Integrated Graphics Controller (rev 03)
00:03.0 Communication controller: Intel Corporation 4 Series Chipset  
HECI Controller (rev 03)
00:19.0 Ethernet controller: Intel Corporation 82567V-2 Gigabit  
Network Connection
00:1a.0 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB  
UHCI Controller #4
00:1a.1 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB  
UHCI Controller #5
00:1a.2 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB  
UHCI Controller #6
00:1a.7 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB2  
EHCI Controller #2
00:1b.0 Audio device: Intel Corporation 82801JI (ICH10 Family) HD  
Audio Controller
00:1c.0 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI  
Express Port 1
00:1c.2 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI  
Express Port 3
00:1c.3 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI  
Express Port 4
00:1d.0 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB  
UHCI Controller #1
00:1d.1 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB  
UHCI Controller #2
00:1d.2 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB  
UHCI Controller #3
00:1d.7 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB2  
EHCI Controller #1
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 90)
00:1f.0 ISA bridge: Intel Corporation 82801JIB (ICH10) LPC Interface  
Controller
00:1f.2 SATA controller: Intel Corporation 82801JI (ICH10 Family) SATA  
AHCI Controller
00:1f.3 SMBus: Intel Corporation 82801JI (ICH10 Family) SMBus Controller
02:00.0 Multimedia video controller: Conexant Systems, Inc. CX23885  
PCI Video and Audio Decoder (rev 02)
03:00.0 IDE interface: JMicron Technology Corp. JMB368 IDE controller
04:06.0 FireWire (IEEE 1394): Agere Systems FW322/323 (rev 70)

dmesg extract
[   10.010084] Linux video capture interface: v2.00
[   10.041692] cx23885 driver version 0.0.2 loaded
[   10.041863] cx23885 0000:02:00.0: PCI INT A -> GSI 18 (level, low) - 
 > IRQ 18
[   10.041913] CORE cx23885[0]: subsystem: 18ac:db78, board: DViCO  
FusionHDTV DVB-T Dual Express [card=11,autodetected]

 > lspci -n -s 02:00 && lspci -v -s 02:00
02:00.0 0400: 14f1:8852 (rev 02)
02:00.0 Multimedia video controller: Conexant Systems, Inc. CX23885  
PCI Video and Audio Decoder (rev 02)
         Subsystem: DViCO Corporation Device db78
         Flags: bus master, fast devsel, latency 0, IRQ 18
         Memory at d0400000 (64-bit, non-prefetchable) [size=2M]
         Capabilities: [40] Express Endpoint, MSI 00
         Capabilities: [80] Power Management version 2
         Capabilities: [90] Vital Product Data <?>
         Capabilities: [a0] Message Signalled Interrupts: Mask- 64bit+  
Queue=0/0 Enable-
         Capabilities: [100] Advanced Error Reporting <?>
         Capabilities: [200] Virtual Channel <?>
         Kernel driver in use: cx23885
         Kernel modules: cx23885

I am using the v4l stuff included in Ubuntu 9.10 Dev and I have  
extacted the necessary firmware using Steven Toths method  
(extract_xc3028.pl on HVR-12x0-14x0-17x0_1_25_25271_WHQL.zip)

I think the issue is in the firmware, as the frontends seem to behave  
correctly.

I have created the initial scanning data for my area
       # Australia / Goulburn / Rocky Hill
       # T freq bw fec_hi fec_lo mod transmission-mode guard-interval  
hierarchy
       # ABC
       T 725500000 7MHz 3/4 3/4 QAM64 8k 1/16 NONE

       # SBS
       T 746500000 7MHz 2/3 2/3 QAM64 8k 1/8 NONE

       # WIN
       T 767500000 7MHz 3/4 3/4 QAM64 8k 1/16 NONE

       # Prime
       T 788500000 7MHz 3/4 3/4 QAM64 8k 1/16 NONE

       # TEN
       T 809500000 7MHz 3/4 3/4 QAM64 8k 1/16 NONE

but when I manually scan using this transport data, some channels fail.


 >scan au-Goulburn
scanning au-Goulburn
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
initial transponder 725500000 1 3 3 3 1 1 0
initial transponder 746500000 1 2 2 3 1 2 0
initial transponder 767500000 1 3 3 3 1 1 0
initial transponder 788500000 1 3 3 3 1 1 0
initial transponder 809500000 1 3 3 3 1 1 0
 >>> tune to:  
725500000 
:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4 
:FEC_3_4:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
0x0000 0x02a0: pmt_pid 0x0000 ABC -- ABC HDTV (running)
0x0000 0x02a1: pmt_pid 0x0000 ABC -- ABC1 (running)
0x0000 0x02a2: pmt_pid 0x0000 ABC -- ABC2 (running)
0x0000 0x02a3: pmt_pid 0x0000 ABC -- ABC1 (running)
0x0000 0x02a4: pmt_pid 0x0000 ABC -- ABC3 (running)
0x0000 0x02a6: pmt_pid 0x0000 ABC -- ABC DiG Radio (running)
0x0000 0x02a7: pmt_pid 0x0000 ABC -- ABC DiG Jazz (running)
Network Name 'ABC NSW'
 >>> tune to:  
746500000 
:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3 
:FEC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE
0x0000 0x0351: pmt_pid 0x0401 SBS -- SBS ONE (running)
0x0000 0x0355: pmt_pid 0x0400 SBS -- SBS HD (running)
0x0000 0x0352: pmt_pid 0x0402 SBS -- SBS TWO (running)
0x0000 0x0353: pmt_pid 0x0408 SBS -- SBS 3 (running)
0x0000 0x0354: pmt_pid 0x0409 SBS -- SBS 4 (running)
0x0000 0x035e: pmt_pid 0x0403 SBS -- SBS Radio 1 (running)
0x0000 0x035f: pmt_pid 0x0404 SBS -- SBS Radio 2 (running)
Network Name 'SBS NSW'
 >>> tune to:  
767500000 
:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4 
:FEC_3_4:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
WARNING: filter timeout pid 0x0011
Network Name 'WIN Digital'
WARNING: filter timeout pid 0x0031
 >>> tune to:  
788500000 
:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4 
:FEC_3_4:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
Network Name 'PRIME'
WARNING: filter timeout pid 0x0011
 >>> tune to:  
809500000 
:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4 
:FEC_3_4:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
0x0000 0x0807: pmt_pid 0x0160 Southern Cross Television -- SC10  
Canberra (running)
0x0000 0x0827: pmt_pid 0x06ae Southern Cross Television -- One HD  
Canberra (running)
0x0000 0x0847: pmt_pid 0x06b8 Southern Cross Television -- SC Ten  
(running)
Network Name 'Southern Cross Television'
 >>> tune to:  
226500000 
:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4 
:FEC_3_4:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
 >>> tune to:  
226500000 
:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4 
:FEC_3_4 
:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE  
(tuning failed)
WARNING: >>> tuning failed!!!
retrying with f=648500000
 >>> tune to:  
648500000 
:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4 
:FEC_3_4 
:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE  
(tuning failed)
WARNING: >>> tuning failed!!!
 >>> tune to:  
648500000 
:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4 
:FEC_3_4 
:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE  
(tuning failed)
WARNING: >>> tuning failed!!!
retrying with f=781500000
 >>> tune to:  
781500000 
:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4 
:FEC_3_4 
:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE  
(tuning failed)
WARNING: >>> tuning failed!!!
 >>> tune to:  
781500000 
:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4 
:FEC_3_4 
:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE  
(tuning failed)
WARNING: >>> tuning failed!!!
retrying with f=774500000
 >>> tune to:  
774500000 
:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4 
:FEC_3_4 
:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE  
(tuning failed)
WARNING: >>> tuning failed!!!
 >>> tune to:  
774500000 
:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4 
:FEC_3_4 
:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE  
(tuning failed)
WARNING: >>> tuning failed!!!
retrying with f=634500000
 >>> tune to:  
634500000 
:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4 
:FEC_3_4 
:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE  
(tuning failed)
WARNING: >>> tuning failed!!!
 >>> tune to:  
634500000 
:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4 
:FEC_3_4 
:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE  
(tuning failed)
WARNING: >>> tuning failed!!!
 >>> tune to:  
543500000 
:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3 
:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
 >>> tune to:  
543500000 
:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3 
:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE  
(tuning failed)
WARNING: >>> tuning failed!!!
retrying with f=711625000
 >>> tune to:  
711625000 
:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3 
:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE  
(tuning failed)
WARNING: >>> tuning failed!!!
 >>> tune to:  
711625000 
:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3 
:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE  
(tuning failed)
WARNING: >>> tuning failed!!!
retrying with f=599500000
 >>> tune to:  
599500000 
:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3 
:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE  
(tuning failed)
WARNING: >>> tuning failed!!!
 >>> tune to:  
599500000 
:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3 
:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE  
(tuning failed)
WARNING: >>> tuning failed!!!
 >>> tune to:  
219500000 
:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4 
:FEC_3_4:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
 >>> tune to:  
219500000 
:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4 
:FEC_3_4 
:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE  
(tuning failed)
WARNING: >>> tuning failed!!!
 >>> tune to:  
177500000 
:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4 
:FEC_1_2:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
 >>> tune to:  
177500000 
:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4 
:FEC_1_2 
:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE  
(tuning failed)
WARNING: >>> tuning failed!!!
dumping lists (25 services)
ABC HDTV: 
725500000 
:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4 
:FEC_3_4 
:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE: 
516:0:672
ABC1 
: 
725500000 
:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4 
:FEC_3_4 
:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE: 
512:650:673
ABC2 
: 
725500000 
:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4 
:FEC_3_4 
:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE: 
513:651:674
ABC1 
: 
725500000 
:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4 
:FEC_3_4 
:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE: 
512:650:675
ABC3 
: 
725500000 
:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4 
:FEC_3_4 
:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE: 
512:650:676
ABC DiG Radio: 
725500000 
:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4 
:FEC_3_4 
:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE: 
0:690:678
ABC DiG Jazz: 
725500000 
:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4 
:FEC_3_4 
:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE: 
0:700:679
SBS ONE: 
746500000 
:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3 
:FEC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE: 
161:81:849
SBS TWO: 
746500000 
:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3 
:FEC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE: 
162:83:850
SBS  
3 
: 
746500000 
:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3 
:FEC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE: 
161:81:851
SBS  
4 
: 
746500000 
:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3 
:FEC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE: 
161:81:852
SBS HD: 
746500000 
:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3 
:FEC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE: 
102:103:853
SBS Radio  
1 
: 
746500000 
:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3 
:FEC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE: 
0:201:862
SBS Radio  
2 
: 
746500000 
:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3 
:FEC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE: 
0:202:863
[0001]: 
767500000 
:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4 
:FEC_3_4 
:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE:33:36:1
[000a]: 
767500000 
:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4 
:FEC_3_4 
:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE:129:0:10
[0002]: 
767500000 
:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4 
:FEC_3_4 
:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE:0:0:2
[0946]: 
788500000 
:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4 
:FEC_3_4 
:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE: 
2740:2741:2374
[0960]: 
788500000 
:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4 
:FEC_3_4 
:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE: 
2740:2741:2400
[0961]: 
788500000 
:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4 
:FEC_3_4 
:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE: 
2740:2741:2401
[0962]: 
788500000 
:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4 
:FEC_3_4 
:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE: 
2740:2741:2402
[0963]: 
788500000 
:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4 
:FEC_3_4 
:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE: 
2740:2741:2403
SC10 Canberra: 
809500000 
:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4 
:FEC_3_4 
:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE: 
353:354:2055
One HD Canberra: 
809500000 
:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4 
:FEC_3_4 
:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE: 
1711:0:2087
SC Ten: 
809500000 
:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4 
:FEC_3_4 
:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE: 
353:354:2119
Done.

Doing the same procedure using the Dual Digital 4 on the other machine  
works perfectly.

I have also dual-booted a machine about a year ago with Linux/Windows  
XP media centre. Under media centre the card worked perfectly, and  
under linux, it displayed the same behaviour I now see. This would  
appear to rule out RF rig issues and weak signal. When I performed  
these tests, I could see the antenna directly pointing to the TV  
tower, which I could also visually see.

Since this seems to be an obscure problem, I'm not sure that there is  
enough critical mass to fix it.

aF

On 07/09/2009, at 9:52 PM, Vincent McIntyre wrote:

> I have some issues with what I think is the same card, I'm in Sydney,
> using mythtv.
> I also have the DViCo Fusion Dual Digital 4 rev 1. (setup details at  
> the end)
>
> At first when I scanned I could not get the SBS HD transport.
> Sometime between 28 Jun and 19 July I stopped being able to tune
> anything from channel 9 as well. This does not appear to have been
> triggered by a v4l code change, I did not
> pull from the tree in that time frame.
>
> The symptom I see when it "fails" is that mythv reports some signal,
> but it fails to get lock.
>
> When I try to rescan, I get weird errors - after mythtv-backend stops,
> I start getting USB errors of this kind:
>
> kernel: [  663.703978] dvb-usb: recv bulk message failed: -110
> kernel: [  663.703994] zl10353: write to reg 62 failed (err = -121)!
> kernel: [  664.836658] dvb-usb: recv bulk message failed: -110
> kernel: [  664.836665] zl10353: write to reg 62 failed (err = -121)!
> kernel: [  665.699864] dvb-usb: bulk message failed: -110 (4/0)
> kernel: [  665.699869] cxusb: i2c read failed
> kernel: [  666.832545] dvb-usb: bulk message failed: -110 (5/0)
> kernel: [  666.832551] zl10353: write to reg 50 failed (err = -121)!
> kernel: [  667.696001] dvb-usb: bulk message failed: -110 (5/0)
> kernel: [  667.696016] zl10353: write to reg 50 failed (err = -121)!
> kernel: [  668.828433] dvb-usb: bulk message failed: -110 (2/0)
> kernel: [  669.691639] dvb-usb: bulk message failed: -110 (4/0)
>
>
> At this point, the channel scan stalls out and the machine is very
> sluggish because of the DoSing of the USB bus. To recover I have to
> halt the machine and bring it up again.
> It's unclear to me if it is a problem with the Dual DIgital 4 or the
> Dual Digital Express.
>
> This appears to be a longstanding issue, existing from 2.6.26 (my
> kernel) through to 2.6.30 (see
> http://www.spinics.net/lists/linux-media/msg08244.html)
>
>
> I attempted to avoid the power cycling of the card by loading the
> tuner module with
> options tuner_xc2028 no_poweroff=1
> in /etc/modprobe.d/options, but with this option turned on I was
> unable to receive any stations.
>
> Alex, just to confirm we have the same card could you post the PCI  
> IDs?
>
> When the card is detected I see in syslog:
> kernel: [   57.768535] CORE cx23885[0]: subsystem: 18ac:db78, board:
> DViCO FusionHDTV DVB-T Dual Express [card=11,autodetected]
>
> and lspci gives me
> (lspci -n -s 04:00 && lspci -v -s 04:00)
> (sudo lspci -n -s 4:00 && sudo lspci -v -s 4:00; )
> 04:00.0 0400: 14f1:8852 (rev 02)
> 04:00.0 Multimedia video controller: Conexant Systems, Inc. CX23885
> PCI Video and Audio Decoder (rev 02)
>        Subsystem: DViCO Corporation FusionHDTV DVB-T Dual Express
>        Flags: bus master, fast devsel, latency 0, IRQ 19
>        Memory at 90000000 (64-bit, non-prefetchable) [size=2M]
>        Capabilities: [40] Express Endpoint IRQ 0
>        Capabilities: [80] Power Management version 2
>        Capabilities: [90] Vital Product Data
>        Capabilities: [a0] Message Signalled Interrupts: Mask- 64bit+
> Queue=0/0 Enable-
>
>
> My system details:
>  (cd ~/v4l; hg identify)
>  2b49813f8482 tip
>
>  /etc/issue
>  Ubuntu 8.04.3 LTS
>
>  uname -a
>  2.6.24-24-generic #1 SMP Tue Aug 18 17:04:53 UTC 2009 i686 GNU/Linux
>
>  lspci
> 00:00.0 0600: 8086:29c0 (rev 02)
> 00:00.0 Host bridge: Intel Corporation 82G33/G31/P35/P31 Express DRAM
> Controller (rev 02)
> 00:02.0 0300: 8086:29c2 (rev 02)
> 00:02.0 VGA compatible controller: Intel Corporation 82G33/G31 Express
> Integrated Graphics Controller (rev 02)
> 00:03.0 0780: 8086:29c4 (rev 02)
> 00:03.0 Communication controller: Intel Corporation 82G33/G31/P35/P31
> Express MEI Controller (rev 02)
> 00:19.0 0200: 8086:294c (rev 02)
> 00:19.0 Ethernet controller: Intel Corporation 82566DC-2 Gigabit
> Network Connection (rev 02)
> 00:1a.0 0c03: 8086:2937 (rev 02)
> 00:1a.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB
> UHCI Controller #4 (rev 02)
> 00:1a.1 0c03: 8086:2938 (rev 02)
> 00:1a.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB
> UHCI Controller #5 (rev 02)
> 00:1a.2 0c03: 8086:2939 (rev 02)
> 00:1a.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB
> UHCI Controller #6 (rev 02)
> 00:1a.7 0c03: 8086:293c (rev 02)
> 00:1a.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2
> EHCI Controller #2 (rev 02)
> 00:1b.0 0403: 8086:293e (rev 02)
> 00:1b.0 Audio device: Intel Corporation 82801I (ICH9 Family) HD Audio
> Controller (rev 02)
> 00:1c.0 0604: 8086:2940 (rev 02)
> 00:1c.0 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express
> Port 1 (rev 02)
> 00:1c.1 0604: 8086:2942 (rev 02)
> 00:1c.2 0604: 8086:2944 (rev 02)
> 00:1c.2 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express
> Port 3 (rev 02)
> 00:1c.3 0604: 8086:2946 (rev 02)
> 00:1c.3 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express
> Port 4 (rev 02)
> 00:1c.4 0604: 8086:2948 (rev 02)
> 00:1c.4 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express
> Port 5 (rev 02)
> 00:1d.0 0c03: 8086:2934 (rev 02)
> 00:1d.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB
> UHCI Controller #1 (rev 02)
> 00:1d.1 0c03: 8086:2935 (rev 02)
> 00:1d.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB
> UHCI Controller #2 (rev 02)
> 00:1d.2 0c03: 8086:2936 (rev 02)
> 00:1d.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB
> UHCI Controller #3 (rev 02)
> 00:1d.7 0c03: 8086:293a (rev 02)
> 00:1d.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2
> EHCI Controller #1 (rev 02)
> 00:1e.0 0604: 8086:244e (rev 92)
> 00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 92)
> 00:1f.0 0601: 8086:2912 (rev 02)
> 00:1f.0 ISA bridge: Intel Corporation 82801IH (ICH9DH) LPC Interface
> Controller (rev 02)
> 00:1f.2 0106: 8086:2922 (rev 02)
> 00:1f.2 SATA controller: Intel Corporation 82801IR/IO/IH (ICH9R/DO/DH)
> 6 port SATA AHCI Controller (rev 02)
> 00:1f.3 0c05: 8086:2930 (rev 02)
> 00:1f.3 SMBus: Intel Corporation 82801I (ICH9 Family) SMBus  
> Controller (rev 02)
> 02:00.0 0101: 11ab:6101 (rev b2)
> 02:00.0 IDE interface: Marvell Technology Group Ltd. 88SE6101
> single-port PATA133 interface (rev b2)
> 04:00.0 0400: 14f1:8852 (rev 02)
> 04:00.0 Multimedia video controller: Conexant Systems, Inc. CX23885
> PCI Video and Audio Decoder (rev 02)
> 06:00.0 0200: 10ec:8185 (rev 20)
> 06:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8185
> IEEE 802.11a/b/g Wireless LAN Controller (rev 20)
> 06:01.0 0c03: 1106:3038 (rev 61)
> 06:01.0 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
> Controller (rev 61)
> 06:01.1 0c03: 1106:3038 (rev 61)
> 06:01.1 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
> Controller (rev 61)
> 06:01.2 0c03: 1106:3104 (rev 63)
> 06:01.2 USB Controller: VIA Technologies, Inc. USB 2.0 (rev 63)
> 06:03.0 0c00: 104c:8023
> 06:03.0 FireWire (IEEE 1394): Texas Instruments TSB43AB22/A
> IEEE-1394a-2000 Controller (PHY/Link)
>
>  lsusb
> 00:1f.3 0c05: 8086:2930 (rev 02)
> 00:1f.3 SMBus: Intel Corporation 82801I (ICH9 Family) SMBus  
> Controller (rev 02)
> 02:00.0 0101: 11ab:6101 (rev b2)
> 02:00.0 IDE interface: Marvell Technology Group Ltd. 88SE6101
> single-port PATA133 interface (rev b2)
> 04:00.0 0400: 14f1:8852 (rev 02)
> 04:00.0 Multimedia video controller: Conexant Systems, Inc. CX23885
> PCI Video and Audio Decoder (rev 02)
> 06:00.0 0200: 10ec:8185 (rev 20)
> 06:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8185
> IEEE 802.11a/b/g Wireless LAN Controller (rev 20)
> 06:01.0 0c03: 1106:3038 (rev 61)
> 06:01.0 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
> Controller (rev 61)
> 06:01.1 0c03: 1106:3038 (rev 61)
> 06:01.1 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
> Controller (rev 61)
> 06:01.2 0c03: 1106:3104 (rev 63)
> 06:01.2 USB Controller: VIA Technologies, Inc. USB 2.0 (rev 63)
> 06:03.0 0c00: 104c:8023
> 06:03.0 FireWire (IEEE 1394): Texas Instruments TSB43AB22/A
> IEEE-1394a-2000 Controller (PHY/Link)
>
>
>
> On 9/7/09, Alex Ferrara <alex@receptiveit.com.au> wrote:
>> I bought several of these cards over a year ago thinking that they
>> worked under Linux, but I found that while the cards seem to work
>> flawlessly for some people, in some geographic locations, they don't
>> work for me in Goulburn NSW pointing to Mt Gray.
>>
>> I have a mythtv backend with 2 x Dvico Dual Digital 4 PCI cards and
>> they are working perfectly, but the Dual Express cards will not tune
>> all transports. It seems that Prime and TEN hardly get enough signal
>> to tune.
>>
>> I have done some tests, and under Windows with MCE the cards work
>> perfectly using the same antenna
>>
>> I've heard that these cards have some sort of pre-amp that isn't
>> getting turned on in Linux. This might be part of the issue. I have
>> tried increasing signal amplification, but that degrades the other
>> signals that are working ok without the extra amp.
>>
>> If anyone can shed some light, I would be very appreciative
>>
>> aF
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux- 
>> media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>

