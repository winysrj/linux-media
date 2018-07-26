Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:46227 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729410AbeGZOij (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Jul 2018 10:38:39 -0400
From: Peter <peterk@gmx.at>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: linux-media@vger.kernel.org, Max nibble <nibble.max@gmail.com>
Subject: media: dvbsky: issues with DVBSky T680CI
Date: Thu, 26 Jul 2018 15:22:00 +0200
Message-ID: <2381803.4uDTcB85kL@jp2>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

the last two commits on drivers/media/usb/dvb-usb-v2/dvbsky.c have negative 
effects on the operation of the DVBSky T680CI. With kernel 4.18-rc6, but 
commits 7d95fb746c4eece67308f1642a666ea1ebdbd2cc and 
14f4eaeddabce65deba2e1346efccf80f666f7b7 undone the device works.

Commit 14f4eaed ("media: dvbsky: fix driver unregister logic") causes the 
following:
After disconnecting the T680CI /dev/dvb/adapter0/frontend0 still exits. So, if 
connected again it cannot create a frontend:

[  560.756035] usb 2-3: new high-speed USB device number 4 using xhci_hcd
[  561.100030] usb 2-3: dvb_usb_v2: found a 'DVBSky T680CI' in warm state
[  561.100205] usb 2-3: dvb_usb_v2: will pass the complete MPEG2 transport 
stream to the software demuxer
[  561.100220] dvbdev: DVB: registering new adapter (DVBSky T680CI)
[  561.101426] usb 2-3: dvb_usb_v2: MAC address: xx:xx:xx:xx:xx:xx
[  561.109404] i2c i2c-8: Added multiplexed i2c bus 9
[  561.109410] si2168 8-0064: Silicon Labs Si2168-B40 successfully identified
[  561.109414] si2168 8-0064: firmware version: B 4.0.2
[  561.112485] si2157 9-0060: Silicon Labs Si2147/2148/2157/2158 successfully 
attached
[  561.119145] sp2 8-0040: CIMaX SP2 successfully attached
[  561.119161] usb 2-3: DVB: registering adapter 0 frontend 0 (Silicon Labs 
Si2168)...

[  561.119174] sysfs: cannot create duplicate filename '/class/dvb/
dvb0.frontend0'
[  561.119178] CPU: 0 PID: 17859 Comm: kworker/0:2 Not tainted 4.18.0-rc6 #1
[  561.119180] Hardware name: LENOVO 20BWS49800/20BWS49800, BIOS JBET70WW 
(1.34 ) 06/15/2018
[  561.119186] Workqueue: usb_hub_wq hub_event
[  561.119189] Call Trace:
[  561.119197]  dump_stack+0x46/0x5b
[  561.119202]  sysfs_warn_dup+0x51/0x60
[  561.119207]  sysfs_do_create_link_sd.isra.2+0x87/0xa0
[  561.119210]  device_add+0x2c9/0x630
[  561.119214]  device_create_groups_vargs+0xd8/0xe0
[  561.119218]  device_create+0x44/0x60
[  561.119223]  ? _cond_resched+0x10/0x40
[  561.119228]  ? kmem_cache_alloc_trace+0x159/0x160
[  561.119234]  dvb_register_device+0x21f/0x2b0 [dvb_core]
[  561.119240]  dvb_register_frontend+0x18c/0x220 [dvb_core]
[  561.119246]  ? dvb_usbv2_probe+0xb55/0x11b0 [dvb_usb_v2]
[  561.119249]  dvb_usbv2_probe+0xb55/0x11b0 [dvb_usb_v2]
[  561.119254]  usb_probe_interface+0xfc/0x300
[  561.119258]  driver_probe_device+0x2ec/0x4c0
[  561.119261]  ? __driver_attach+0x110/0x110
[  561.119263]  bus_for_each_drv+0x61/0xa0
[  561.119267]  __device_attach+0xd4/0x150
[  561.119270]  bus_probe_device+0x85/0xa0
[  561.119273]  device_add+0x40b/0x630
[  561.119276]  usb_set_configuration+0x4fb/0x8a0
[  561.119281]  generic_probe+0x23/0x70
[  561.119284]  driver_probe_device+0x2ec/0x4c0
[  561.119287]  ? __driver_attach+0x110/0x110
[  561.119289]  bus_for_each_drv+0x61/0xa0
[  561.119292]  __device_attach+0xd4/0x150
[  561.119295]  bus_probe_device+0x85/0xa0
[  561.119297]  device_add+0x40b/0x630
[  561.119301]  usb_new_device+0x1b3/0x3d0
[  561.119305]  hub_event+0x7a2/0x16e0
[  561.119310]  process_one_work+0x1cf/0x3f0
[  561.119314]  worker_thread+0x28/0x3c0
[  561.119317]  ? set_worker_desc+0xb0/0xb0
[  561.119321]  kthread+0x10e/0x130
[  561.119326]  ? kthread_create_worker_on_cpu+0x70/0x70
[  561.119329]  ret_from_fork+0x35/0x40
[  561.119351] dvbdev: dvb_register_device: failed to create device 
dvb0.frontend0 (-17)

[  561.148038] rc_core: IR keymap rc-dvbsky not found
[  561.148040] Registered IR keymap rc-empty
[  561.148101] rc rc0: DVBSky T680CI as /devices/pci0000:00/0000:00:14.0/
usb2/2-3/rc/rc0
[  561.148171] input: DVBSky T680CI as /devices/pci0000:00/0000:00:14.0/
usb2/2-3/rc/rc0/input17
[  561.148345] usb 2-3: dvb_usb_v2: schedule remote query interval to 300 
msecs
[  561.148351] usb 2-3: dvb_usb_v2: 'DVBSky T680CI' successfully initialized 
and connected

With commit 7d95fb74 ("media: dvbsky: use just one mutex for serializing 
device R/W ops") scanning and watching/recording of DVB-T2 channels doesn't 
work anymore (DVB-T/C not tested). Recordings are just empty files. dvbv5-scan 
outputs the following: 

$ dvbv5-scan dvb_channel.conf
Cannot calc frequency shift. Either bandwidth/symbol-rate is unavailable 
(yet).
Scanning frequency #1 498000000
Lock   (0x1f) Signal= -49,00dBm C/N= 27,25dB UCB= 0 postBER= 80,2x10^-3
ERROR    dvb_read_sections: no data read on section filter
ERROR    error while waiting for PAT table
Scanning frequency #2 578000000
Lock   (0x1f) Signal= -48,00dBm C/N= 32,75dB UCB= 0 postBER= 1,00
ERROR    dvb_read_sections: no data read on section filter
ERROR    error while waiting for PAT table
..

I also noticed that the module m88ds3103 is loaded automatically whenever the 
module dvb_usb_dvbsky is loaded. However, m88ds3103 is a DVB-S/S2 demodulator 
driver, but the T680CI is a DVB-T/T2/C device. Is there a reason why it is 
loaded automatically? Maybe because the dvbsky driver was written for S960/
S860 in the first place and support for T680CI was added later?

Could you please look into this? Thank you.

There is also a discontinuity issue with this device when a CAM is 
initialized. However, I'll address that later.

Peter
