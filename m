Return-path: <linux-media-owner@vger.kernel.org>
Received: from web43139.mail.sp1.yahoo.com ([216.252.121.69]:42691 "HELO
	web43139.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753830AbZK2MaL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Nov 2009 07:30:11 -0500
Message-ID: <530866.1488.qm@web43139.mail.sp1.yahoo.com>
Date: Sun, 29 Nov 2009 04:30:16 -0800 (PST)
From: John Kumar <rjkft@yahoo.com>
Subject: Winfast PxDVR3200 with ubuntu 9.10
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,
I am trying to configure a Winfast PxDVR3200 H on Ubuntu
9.10 (Karmic). Although the card seems to be detected, there is no
signal when I try to scan for channels either using scan or a variety
of software interfaces (me tv, kaffeine, myth tv). All give a signal
strength of 0. Any help at all would be appreciated, is there something
simple I am missing. Details follow.

I have installed v4l-dvb and obtained and extracted the designated firmware (http://www.linuxtv.org/wiki/index.php/Xceive_XC3028/XC2028#How_to_Obtain_the_Firmware).

I manually selected the card type (12) via insmod, resulting in the card being detected and /dev/dvb/ having a adapter0 present.

dmesg:

[   14.984019] cx23885 driver version 0.0.2 loaded
[   14.984409] cx23885 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   14.984498] CORE cx23885[0]: subsystem: 107d:6f39, board: Leadtek Winfast PxDVR3200 H [card=12,insmod option]
[   15.231871] fglrx: module license 'Proprietary. (C) 2002 - ATI Technologies, Starnberg, GERMANY' taints kernel.
[   15.231875] Disabling lock debugging due to kernel taint
[   15.245281] [fglrx] Maximum main memory to use for locked dma buffers: 3799 MBytes.
[   15.245483] [fglrx]   vendor: 1002 device: 9442 count: 1
[   15.245855] [fglrx] ioport: bar 4, base 0xa000, size: 0x100
[   15.245867] pci 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   15.245871] pci 0000:01:00.0: setting latency timer to 64Hi All,
I am trying to configure a Winfast PxDVR3200 H on Ubuntu
9.10 (Karmic). Although the card seems to be detected, there is no
signal when I try to scan for channels either using scan or a variety
of software interfaces (me tv, kaffeine, myth tv). All give a signal
strength of 0. Any help at all would be appreciated, is there something
simple I am missing. Details follow.

I have installed v4l-dvb and obtained and extracted the designated firmware (http://www.linuxtv.org/wiki/index.php/Xceive_XC3028/XC2028#How_to_Obtain_the_Firmware).

I manually selected the card type (12) via insmod, resulting in the card being detected and /dev/dvb/ having a adapter0 present.

dmesg:

[   14.984019] cx23885 driver version 0.0.2 loaded
[   14.984409] cx23885 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   14.984498] CORE cx23885[0]: subsystem: 107d:6f39, board: Leadtek Winfast PxDVR3200 H [card=12,insmod option]
[   15.231871] fglrx: module license 'Proprietary. (C) 2002 - ATI Technologies, Starnberg, GERMANY' taints kernel.
[   15.231875] Disabling lock debugging due to kernel taint
[   15.245281] [fglrx] Maximum main memory to use for locked dma buffers: 3799 MBytes.
[   15.245483] [fglrx]   vendor: 1002 device: 9442 count: 1
[   15.245855] [fglrx] ioport: bar 4, base 0xa000, size: 0x100
[   15.245867] pci 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   15.245871] pci 0000:01:00.0: setting latency timer to 64
[   15.246071] [fglrx] Kernel PAT support is enabled
[   15.246090] [fglrx] module loaded - fglrx 8.66.10 [Sep  3 2009] with 1 minors
[   15.251862] cx25840 2-0044: cx23885 A/V decoder found @ 0x88 (cx23885[0])
[   15.256893] cx25840 2-0044: firmware: requesting v4l-cx23885-avcore-01.fw
[   15.319795] lp: driver loaded but no devices found
[   15.668482]   alloc irq_desc for 22 on node 0
[   15.668485]   alloc kstat_irqs on node 0
[   15.668490] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[   15.668549] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   16.171154] cx25840 2-0044: loaded v4l-cx23885-avcore-01.fw firmware (16382 bytes)
[   16.177442] cx23885_dvb_register() allocating 1 frontend(s)
[   16.177445] cx23885[0]: cx23885 based dvb card
[   16.345371] hda_codec: Unknown model for ALC889A, trying auto-probe from BIOS...
[   16.345540] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input6
[   16.349123] HDA Intel 0000:01:00.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[   16.349163] HDA Intel 0000:01:00.1: setting latency timer to 64
[   16.464242] xc2028 1-0061: creating new instance
[   16.464245] xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
[   16.464249] DVB: registering new adapter (cx23885[0])
[   16.464252] DVB: registering adapter 0 frontend 0 (Zarlink ZL10353 DVB-T)...
[   16.464462] cx23885_dev_checkrevision() Hardware revision = 0xa4
[   16.464469] cx23885[0]/0: found at 0000:03:00.0, rev: 3, irq: 17, latency: 0, mmio: 0xe8000000
[   16.464476] cx23885 0000:03:00.0: setting latency timer to 64

lsmod:
cx23885               135144  0 
cx2341x                15108  1 cx23885
v4l2_common            20512  3 cx25840,cx23885,cx2341x
videodev               43552  3 cx25840,cx23885,v4l2_common
v4l1_compat            16644  1 videodev
v4l2_compat_ioctl32    12416  1 videodev
videobuf_dma_sg        14372  1 cx23885
videobuf_dvb            8452  1 cx23885
dvb_core              107700  2 cx23885,videobuf_dvb
videobuf_core          20964  3 cx23885,videobuf_dma_sg,videobuf_dvb
ir_common              51396  1 cx23885
btcx_risc               5672  1 cx23885
tveeprom               14884  1 cx23885

ls -al /dev/dvb/adapter0/
total 0
drwxr-xr-x  2 root root     120 2009-11-29 21:49 .
drwxr-xr-x  3 root root      60 2009-11-29 21:49 ..
crw-rw----+ 1 root video 212, 1 2009-11-29 21:49 demux0
crw-rw----+ 1 root video 212, 2 2009-11-29 21:49 dvr0
crw-rw----+ 1 root video 212, 0 2009-11-29 21:49 frontend0
crw-rw----+ 1 root video 212, 3 2009-11-29 21:49 net0

however when I try to scan, I get the following output:
scanning /usr/share/dvb/dvb-t/au-Melbourne
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
initial transponder 226500000 1 3 9 3 1 1 0
initial transponder 177500000 1 3 9 3 1 1 0
initial transponder 191625000 1 3 9 3 1 1 0
initial transponder 219500000 1 3 9 3 1 1 0
initial transponder 536625000 1 2 9 3 1 2 0
>>>
tune to:
226500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>>
tune to:
226500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
(tuning failed)
WARNING: >>> tuning failed!!!
>>>
tune to:
177500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>>
tune to:
177500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
(tuning failed)
WARNING: >>> tuning failed!!!
>>>
tune to:
191625000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>>
tune to:
191625000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
(tuning failed)
WARNING: >>> tuning failed!!!
>>>
tune to:
219500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>>
tune to:
219500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
(tuning failed)
WARNING: >>> tuning failed!!!
>>>
tune to:
536625000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>>
tune to:
536625000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE
(tuning failed)
WARNING: >>> tuning failed!!!
ERROR: initial tuning failed
dumping lists (0 services)
Done.

Notably, the following output is found (multiple times) in dmesg after scanning:
[  523.621853] cx23885 0000:03:00.0: firmware: requesting xc3028-v27.fw
[  523.638284] xc2028 1-0061: Loading 80 firmware images from xc3028-v27.fw, type: xc2028 firmware, ver 2.7
[  523.838414] xc2028 1-0061: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
[  524.474232] xc2028 1-0061: i2c output error: rc = -5 (should be 64)
[  524.481383] xc2028 1-0061: -5 returned from send
[  524.481387] xc2028 1-0061: Error -22 while loading base firmware

Anyway, anyhelp would be appreciated, I feel as though I am close. Cheers

John
[   15.246071] [fglrx] Kernel PAT support is enabled
[   15.246090] [fglrx] module loaded - fglrx 8.66.10 [Sep  3 2009] with 1 minors
[   15.251862] cx25840 2-0044: cx23885 A/V decoder found @ 0x88 (cx23885[0])
[   15.256893] cx25840 2-0044: firmware: requesting v4l-cx23885-avcore-01.fw
[   15.319795] lp: driver loaded but no devices found
[   15.668482]   alloc irq_desc for 22 on node 0
[   15.668485]   alloc kstat_irqs on node 0
[   15.668490] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[   15.668549] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   16.171154] cx25840 2-0044: loaded v4l-cx23885-avcore-01.fw firmware (16382 bytes)
[   16.177442] cx23885_dvb_register() allocating 1 frontend(s)
[   16.177445] cx23885[0]: cx23885 based dvb card
[   16.345371] hda_codec: Unknown model for ALC889A, trying auto-probe from BIOS...
[   16.345540] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input6
[   16.349123] HDA Intel 0000:01:00.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[   16.349163] HDA Intel 0000:01:00.1: setting latency timer to 64
[   16.464242] xc2028 1-0061: creating new instance
[   16.464245] xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
[   16.464249] DVB: registering new adapter (cx23885[0])
[   16.464252] DVB: registering adapter 0 frontend 0 (Zarlink ZL10353 DVB-T)...
[   16.464462] cx23885_dev_checkrevision() Hardware revision = 0xa4
[   16.464469] cx23885[0]/0: found at 0000:03:00.0, rev: 3, irq: 17, latency: 0, mmio: 0xe8000000
[   16.464476] cx23885 0000:03:00.0: setting latency timer to 64

lsmod:
cx23885               135144  0 
cx2341x                15108  1 cx23885
v4l2_common            20512  3 cx25840,cx23885,cx2341x
videodev               43552  3 cx25840,cx23885,v4l2_common
v4l1_compat            16644  1 videodev
v4l2_compat_ioctl32    12416  1 videodev
videobuf_dma_sg        14372  1 cx23885
videobuf_dvb            8452  1 cx23885
dvb_core              107700  2 cx23885,videobuf_dvb
videobuf_core          20964  3 cx23885,videobuf_dma_sg,videobuf_dvb
ir_common              51396  1 cx23885
btcx_risc               5672  1 cx23885
tveeprom               14884  1 cx23885

ls -al /dev/dvb/adapter0/
total 0
drwxr-xr-x  2 root root     120 2009-11-29 21:49 .
drwxr-xr-x  3 root root      60 2009-11-29 21:49 ..
crw-rw----+ 1 root video 212, 1 2009-11-29 21:49 demux0
crw-rw----+ 1 root video 212, 2 2009-11-29 21:49 dvr0
crw-rw----+ 1 root video 212, 0 2009-11-29 21:49 frontend0
crw-rw----+ 1 root video 212, 3 2009-11-29 21:49 net0

however when I try to scan, I get the following output:
scanning /usr/share/dvb/dvb-t/au-Melbourne
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
initial transponder 226500000 1 3 9 3 1 1 0
initial transponder 177500000 1 3 9 3 1 1 0
initial transponder 191625000 1 3 9 3 1 1 0
initial transponder 219500000 1 3 9 3 1 1 0
initial transponder 536625000 1 2 9 3 1 2 0
>>>
tune to:
226500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>>
tune to:
226500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
(tuning failed)
WARNING: >>> tuning failed!!!
>>>
tune to:
177500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>>
tune to:
177500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
(tuning failed)
WARNING: >>> tuning failed!!!
>>>
tune to:
191625000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>>
tune to:
191625000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
(tuning failed)
WARNING: >>> tuning failed!!!
>>>
tune to:
219500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>>
tune to:
219500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_3_4:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_16:HIERARCHY_NONE
(tuning failed)
WARNING: >>> tuning failed!!!
>>>
tune to:
536625000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>>
tune to:
536625000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_8:HIERARCHY_NONE
(tuning failed)
WARNING: >>> tuning failed!!!
ERROR: initial tuning failed
dumping lists (0 services)
Done.

Notably, the following output is found (multiple times) in dmesg after scanning:
[  523.621853] cx23885 0000:03:00.0: firmware: requesting xc3028-v27.fw
[  523.638284] xc2028 1-0061: Loading 80 firmware images from xc3028-v27.fw, type: xc2028 firmware, ver 2.7
[  523.838414] xc2028 1-0061: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
[  524.474232] xc2028 1-0061: i2c output error: rc = -5 (should be 64)
[  524.481383] xc2028 1-0061: -5 returned from send
[  524.481387] xc2028 1-0061: Error -22 while loading base firmware

Anyway, anyhelp would be appreciated, I feel as though I am close. Cheers

John


      
