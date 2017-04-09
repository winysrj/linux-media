Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:34584 "EHLO
        mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751610AbdDIDZY (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 8 Apr 2017 23:25:24 -0400
Received: by mail-oi0-f43.google.com with SMTP id g204so46427906oib.1
        for <linux-media@vger.kernel.org>; Sat, 08 Apr 2017 20:25:24 -0700 (PDT)
MIME-Version: 1.0
From: Adam Zegelin <adam@zegelin.com>
Date: Sun, 9 Apr 2017 13:25:23 +1000
Message-ID: <CAP2KGUmvsnWOE9t8uR5YQuGNptt8OcUmbALjB3pD6ChpA0tcug@mail.gmail.com>
Subject: HauppaugeTV-quadHD DVB-T mpeg risc op code errors
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I recently purchased a HauppaugeTV-quadHD DVB-T/T2/C tuner in Australia.

I followed the guide on linuxtv.org available here:
https://www.linuxtv.org/wiki/index.php/Hauppauge_WinTV-quadHD_(DVB-T/T2/C)

I installed the dvb-demod-si2168-b40-01.fw firmware file.

Device nodes for the card are present:
/dev/dvb/adapter3
/dev/dvb/adapter3/net0
/dev/dvb/adapter3/dvr0
/dev/dvb/adapter3/demux0
/dev/dvb/adapter3/frontend0
/dev/dvb/adapter2
/dev/dvb/adapter2/net0
/dev/dvb/adapter2/dvr0
/dev/dvb/adapter2/demux0
/dev/dvb/adapter2/frontend0
/dev/dvb/adapter1
/dev/dvb/adapter1/net0
/dev/dvb/adapter1/dvr0
/dev/dvb/adapter1/demux0
/dev/dvb/adapter1/frontend0
/dev/dvb/adapter0
/dev/dvb/adapter0/net0
/dev/dvb/adapter0/dvr0
/dev/dvb/adapter0/demux0
/dev/dvb/adapter0/frontend0

I cannot get any dvb-t application to work. TvHeadend detects the
adapters, but is unable to scan.
w_scan fails too, for example:
$ ./w_scan -c AU
w_scan version 20170107 (compiled for DVB API 5.10)
using settings for AUSTRALIA
DVB aerial
DVB-T AU
scan type TERRESTRIAL, channellist 3
output format vdr-2.0
WARNING: could not guess your codepage. Falling back to 'UTF-8'
output charset 'UTF-8', use -C <charset> to override
Info: using DVB adapter auto detection.
        /dev/dvb/adapter0/frontend0 -> TERRESTRIAL "Silicon Labs
Si2168": very good :-))

Using TERRESTRIAL frontend (adapter /dev/dvb/adapter0/frontend0)
-_-_-_-_ Getting frontend capabilities-_-_-_-_
Using DVB API 5.10
frontend 'Silicon Labs Si2168' supports
DVB-T2
INVERSION_AUTO
QAM_AUTO
TRANSMISSION_MODE_AUTO
GUARD_INTERVAL_AUTO
HIERARCHY_AUTO
FEC_AUTO
BANDWIDTH_AUTO not supported, trying 6/7/8 MHz.
FREQ (42.00MHz ... 870.00MHz)
-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
Scanning DVB-T...
Scanning 7MHz frequencies...
177500: (time: 00:00.009)         signal ok:    QAM_AUTO f = 177500
kHz I999B7C999D999T999G999Y999 (0:0:0)
        Info: no data from PAT after 2 seconds
        deleting (QAM_AUTO f = 177500 kHz I999B7C999D999T999G999Y999 (0:0:0))
177625: (time: 00:02.513)         signal ok:    QAM_AUTO f = 177625
kHz I999B7C999D999T999G999Y999 (0:0:0)
        Info: no data from PAT after 2 seconds
        deleting (QAM_AUTO f = 177625 kHz I999B7C999D999T999G999Y999 (0:0:0))
184500: (time: 00:05.519)         signal ok:    QAM_AUTO f = 184500
kHz I999B7C999D999T999G999Y999 (0:0:0)
        Info: no data from PAT after 2 seconds
        deleting (QAM_AUTO f = 184500 kHz I999B7C999D999T999G999Y999 (0:0:0))
184625: (time: 00:08.499)         signal ok:    QAM_AUTO f = 184625
kHz I999B7C999D999T999G999Y999 (0:0:0)
        Info: no data from PAT after 2 seconds
        deleting (QAM_AUTO f = 184625 kHz I999B7C999D999T999G999Y999 (0:0:0))


The `lspci` output for this card is:
01:00.0 PCI bridge: Pericom Semiconductor Device 2304 (rev 05)
02:01.0 PCI bridge: Pericom Semiconductor Device 2304 (rev 05)
02:02.0 PCI bridge: Pericom Semiconductor Device 2304 (rev 05)
03:00.0 Multimedia video controller: Conexant Systems, Inc. CX23885
PCI Video and Audio Decoder (rev 03)
04:00.0 Multimedia video controller: Conexant Systems, Inc. CX23885
PCI Video and Audio Decoder (rev 03)

`dmesg` output for each of the CX23885 devices on boot is:
[    2.108823] tveeprom: Hauppauge model 166200, rev B5I6, serial# 4035886915
[    2.108827] tveeprom: MAC address is 00:0d:fe:8e:bf:43
[    2.108830] tveeprom: tuner model is SiLabs Si2157 (idx 186, type 4)
[    2.108833] tveeprom: TV standards ATSC/DVB Digital (eeprom 0x80)
[    2.108835] tveeprom: audio processor is CX23885 (idx 39)
[    2.108836] tveeprom: decoder processor is CX23885 (idx 33)
[    2.108838] tveeprom: has no radio, has IR receiver, has no IR transmitter
[    2.108841] cx23885: cx23885[0]: warning: unknown hauppauge model #166200
[    2.108842] cx23885: cx23885[0]: hauppauge eeprom: model=166200
[    2.108846] cx23885: cx23885_dvb_register() allocating 1 frontend(s)
[    2.108849] cx23885: cx23885[0]: cx23885 based dvb card
[    2.118763] i2c i2c-4: Added multiplexed i2c bus 7
[    2.118768] si2168 4-0064: Silicon Labs Si2168-B40 successfully identified
[    2.118772] si2168 4-0064: firmware version: B 4.0.2
[    2.122432] si2157 5-0060: Silicon Labs Si2147/2148/2157/2158
successfully attached
[    2.122457] dvbdev: DVB: registering new adapter (cx23885[0])
[    2.122464] cx23885 0000:03:00.0: DVB: registering adapter 0
frontend 0 (Silicon Labs Si2168)...
[    2.123007] cx23885: cx23885_dvb_register() allocating 1 frontend(s)
[    2.123010] cx23885: cx23885[0]: cx23885 based dvb card
[    2.129982] i2c i2c-4: Added multiplexed i2c bus 8
[    2.129987] si2168 4-0066: Silicon Labs Si2168-B40 successfully identified
[    2.129990] si2168 4-0066: firmware version: B 4.0.2
[    2.132024] si2157 5-0062: Silicon Labs Si2147/2148/2157/2158
successfully attached
[    2.132043] dvbdev: DVB: registering new adapter (cx23885[0])
[    2.132048] cx23885 0000:03:00.0: DVB: registering adapter 1
frontend 0 (Silicon Labs Si2168)...
[    2.132503] cx23885: cx23885_dev_checkrevision() Hardware revision = 0xa4
[    2.132511] cx23885: cx23885[0]/0: found at 0000:03:00.0, rev: 3,
irq: 17, latency: 0, mmio: 0xdf200000
[    2.132625] cx23885 0000:04:00.0: enabling device (0000 -> 0002)
[    2.132854] cx23885: CORE cx23885[1]: subsystem: 0070:6b28, board:
Hauppauge WinTV-QuadHD-DVB [card=56,autodetected]

On use (such as via w_scan), dmesg shows the firmware is successfully loaded:
[  266.951738] si2168 4-0064: downloading firmware from file
'dvb-demod-si2168-b40-01.fw'
[  267.558055] si2168 4-0064: firmware version: B 4.0.11

Shortly after, dmesg is spammed with errors from the CX23885 driver:
[  267.982887] cx23885: cx23885[0]: mpeg risc op code error
[  267.982958] cx23885: cx23885[0]: TS1 B - dma channel status dump
[  267.982963] cx23885: cx23885[0]:   cmds: init risc lo   : 0xffeff000
[  267.982966] cx23885: cx23885[0]:   cmds: init risc hi   : 0x00000000
[  267.982970] cx23885: cx23885[0]:   cmds: cdt base       : 0x00010580
[  267.982973] cx23885: cx23885[0]:   cmds: cdt size       : 0x0000000a
[  267.982976] cx23885: cx23885[0]:   cmds: iq base        : 0x00010400
[  267.982980] cx23885: cx23885[0]:   cmds: iq size        : 0x00000010
[  267.982983] cx23885: cx23885[0]:   cmds: risc pc lo     : 0xffeff018
[  267.982986] cx23885: cx23885[0]:   cmds: risc pc hi     : 0x00000000
[  267.982989] cx23885: cx23885[0]:   cmds: iq wr ptr      : 0x00004106
[  267.982993] cx23885: cx23885[0]:   cmds: iq rd ptr      : 0x00004100
[  267.982996] cx23885: cx23885[0]:   cmds: cdt current    : 0x00010588
[  267.982999] cx23885: cx23885[0]:   cmds: pci target lo  : 0xffff8eb0
[  267.983002] cx23885: cx23885[0]:   cmds: pci target hi  : 0x00000000
[  267.983005] cx23885: cx23885[0]:   cmds: line / byte    : 0x00070000
[  267.983009] cx23885: cx23885[0]:   risc0:
[  267.983011] 0x1c0002f0 [ write sol eol count=752 ]
[  267.983018] cx23885: cx23885[0]:   risc1:
[  267.983019] 0xffff8bc0 [ INVALID sol eol irq2 irq1 23 22 21 20 19
18 cnt1 cnt0 resync count=3008 ]
[  267.983033] cx23885: cx23885[0]:   risc2:
[  267.983034] 0x00000000 [ INVALID count=0 ]
[  267.983038] cx23885: cx23885[0]:   risc3:
[  267.983039] 0x1c0002f0 [ write sol eol count=752 ]
[  267.983046] cx23885: cx23885[0]:   (0x00010400) iq 0:
[  267.983047] 0x1c0002f0 [ write sol eol count=752 ]
[  267.983053] cx23885: cx23885[0]:   iq 1: 0xffff91a0 [ arg #1 ]
[  267.983057] cx23885: cx23885[0]:   iq 2: 0x00000000 [ arg #2 ]
[  267.983060] cx23885: cx23885[0]:   (0x0001040c) iq 3:
[  267.983061] 0x1c0002f0 [ write sol eol count=752 ]
[  267.983067] cx23885: cx23885[0]:   iq 4: 0xffff9490 [ arg #1 ]
[  267.983070] cx23885: cx23885[0]:   iq 5: 0x00000000 [ arg #2 ]
[  267.983073] cx23885: cx23885[0]:   (0x00010418) iq 6:
[  267.983074] 0x1c0002f0 [ write sol eol count=752 ]
[  267.983080] cx23885: cx23885[0]:   iq 7: 0xffff8eb0 [ arg #1 ]
[  267.983083] cx23885: cx23885[0]:   iq 8: 0x00000000 [ arg #2 ]
[  267.983086] cx23885: cx23885[0]:   (0x00010424) iq 9:
[  267.983088] 0x00000000 [ INVALID count=0 ]
[  267.983092] cx23885: cx23885[0]:   (0x00010428) iq a:
[  267.983093] 0x1c0002f0 [ write sol eol count=752 ]
[  267.983099] cx23885: cx23885[0]:   iq b: 0xffff82f0 [ arg #1 ]
[  267.983102] cx23885: cx23885[0]:   iq c: 0x00000000 [ arg #2 ]
[  267.983105] cx23885: cx23885[0]:   (0x00010434) iq d:
[  267.983106] 0x1c0002f0 [ write sol eol count=752 ]
[  267.983112] cx23885: cx23885[0]:   iq e: 0xffff85e0 [ arg #1 ]
[  267.983115] cx23885: cx23885[0]:   iq f: 0x00000000 [ arg #2 ]
[  267.983117] cx23885: cx23885[0]: fifo: 0x00005000 -> 0x6000
[  267.983119] cx23885: cx23885[0]: ctrl: 0x00010400 -> 0x10460
[  267.983122] cx23885: cx23885[0]:   ptr1_reg: 0x00005480
[  267.983125] cx23885: cx23885[0]:   ptr2_reg: 0x00010598
[  267.983128] cx23885: cx23885[0]:   cnt1_reg: 0x00000019
[  267.983131] cx23885: cx23885[0]:   cnt2_reg: 0x00000007
[  271.698258] cx23885: cx23885[0]: mpeg risc op code error

$ uname -a
Linux htpc-server 4.10.6-1-ARCH #1 SMP PREEMPT Mon Mar 27 08:28:22
CEST 2017 x86_64 GNU/Linux

This card works successfully on Windows 10 with the Hauppauge WinTV application.
All 4 tuners work (the 4-up view can tune to 4 independent channels).

Any help would be greatly appreciated.

Regards,
Adam
