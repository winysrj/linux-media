Return-path: <linux-media-owner@vger.kernel.org>
Received: from bar.sig21.net ([80.81.252.164]:49949 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753941AbaIZNZ2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Sep 2014 09:25:28 -0400
Date: Fri, 26 Sep 2014 15:25:13 +0200
From: Johannes Stezenbach <js@linuxtv.org>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Shuah Khan <shuahkh@osg.samsung.com>,
	Shuah Khan <shuah.kh@samsung.com>, linux-media@vger.kernel.org
Subject: Re: em28xx breaks after hibernate
Message-ID: <20140926132513.GA30084@linuxtv.org>
References: <20140925181747.GA21522@linuxtv.org>
 <542462C4.7020907@osg.samsung.com>
 <20140926080030.GB31491@linuxtv.org>
 <20140926080824.GA8382@linuxtv.org>
 <20140926071411.61a011bd@recife.lan>
 <20140926110727.GA880@linuxtv.org>
 <20140926084215.772adce9@recife.lan>
 <20140926090316.5ae56d93@recife.lan>
 <20140926122721.GA11597@linuxtv.org>
 <20140926101222.778ebcaf@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140926101222.778ebcaf@recife.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Sep 26, 2014 at 10:12:22AM -0300, Mauro Carvalho Chehab wrote:
> Try to add a WARN_ON or printk at em28xx_usb_resume().

It is called two times, once during hibernate and once during resume:

root@debian:~# echo disk >/sys/power/state
[  107.108149] PM: Syncing filesystems ... done.
[  107.270300] Freezing user space processes ... (elapsed 0.001 seconds) done.
[  107.274762] PM: Marking nosave pages: [mem 0x0009f000-0x000fffff]
[  107.276921] PM: Basic memory bitmaps created
[  107.278508] PM: Preallocating image memory... done (allocated 27340 pages)
[  107.345275] PM: Allocated 109360 kbytes in 0.06 seconds (1822.66 MB/s)
[  107.346826] Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
[  107.351116] em2884 #0: Suspending extensions
[  107.352087] em2884 #0: Suspending video extensionem2884 #0: Suspending DVB extension
[  107.363558] em2884 #0: fe0 suspend 0[  107.365163] PM: freeze of devices complete after 14.358 msecs
[  107.367346] PM: late freeze of devices complete after 0.911 msecs
[  107.370100] PM: noirq freeze of devices complete after 1.382 msecs
[  107.371198] ACPI: Preparing to enter system sleep state S4
[  107.372302] PM: Saving platform NVS memory
[  107.373029] Disabling non-boot CPUs ...
[  107.377630] smpboot: CPU 1 is now offline
[  107.382106] smpboot: CPU 2 is now offline
[  107.385268] smpboot: CPU 3 is now offline
[  107.387263] PM: Creating hibernation image:
[  107.389233] PM: Need to copy 26730 pages
[  107.389233] PM: Normal pages needed: 26730 + 1024, available pages: 235257
[  107.389233] PM: Hibernation image created (26730 pages copied)
[  107.389233] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S0_] (20140724/hwxface-580)
[  107.389233] PM: Restoring platform NVS memory
[  107.389233] Enabling non-boot CPUs ...
[  107.389233] x86: Booting SMP configuration:
[  107.389648] smpboot: Booting Node 0 Processor 1 APIC 0x1
[  107.422489] CPU1 is up
[  107.423580] smpboot: Booting Node 0 Processor 2 APIC 0x2
[  107.456293] CPU2 is up
[  107.457454] smpboot: Booting Node 0 Processor 3 APIC 0x3
[  107.490161] CPU3 is up
[  107.490928] ACPI: Waking up from system sleep state S4
[  107.492909] PM: noirq thaw of devices complete after 0.941 msecs
[  107.494763] PM: early thaw of devices complete after 0.675 msecs
[  107.501301] rtc_cmos 00:00: System wakeup disabled by ACPI
[  107.535741] ------------[ cut here ]------------
[  107.536648] WARNING: CPU: 2 PID: 2055 at drivers/media/usb/em28xx/em28xx-cards.c:3505 em28xx_usb_resume+0x19/0x2f()
[  107.538554] Modules linked in:
[  107.539131] CPU: 2 PID: 2055 Comm: kworker/u8:11 Not tainted 3.17.0-rc5-00734-g214635f-dirty #87
[  107.540719] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
[  107.542559] Workqueue: events_unbound async_run_entry_fn
[  107.543541]  0000000000000000 ffff880034227bf8 ffffffff814bc918 0000000000000000
[  107.544954]  ffff880034227c30 ffffffff81032d75 ffffffff8141e3d1 ffff88003cb84000
[  107.546329]  0000000000000000 ffffffff813688d6 0000000000000000 ffff880034227c40
[  107.547742] Call Trace:
[  107.548189]  [<ffffffff814bc918>] dump_stack+0x4e/0x7a
[  107.549093]  [<ffffffff81032d75>] warn_slowpath_common+0x7a/0x93
[  107.550097]  [<ffffffff8141e3d1>] ? em28xx_usb_resume+0x19/0x2f
[  107.551082]  [<ffffffff813688d6>] ? usb_dev_restore+0x10/0x10
[  107.551993]  [<ffffffff81032e32>] warn_slowpath_null+0x15/0x17
[  107.552948]  [<ffffffff8141e3d1>] em28xx_usb_resume+0x19/0x2f
[  107.553924]  [<ffffffff813749a5>] usb_resume_interface.isra.6+0x9e/0xc1
[  107.555017]  [<ffffffff81374c3e>] usb_resume_both+0xe3/0x103
[  107.555904]  [<ffffffff813755c2>] usb_resume+0x16/0x5b
[  107.556745]  [<ffffffff813688e4>] usb_dev_thaw+0xe/0x10
[  107.557572]  [<ffffffff8131d564>] dpm_run_callback+0x3f/0x76
[  107.558458]  [<ffffffff8131e194>] device_resume+0x155/0x17f
[  107.559334]  [<ffffffff8131e1d6>] async_resume+0x18/0x3e
[  107.560224]  [<ffffffff8104c526>] async_run_entry_fn+0x5c/0x106
[  107.561170]  [<ffffffff8104585c>] process_one_work+0x1d2/0x38a
[  107.562104]  [<ffffffff81062d20>] ? trace_hardirqs_off_caller+0x40/0xad
[  107.563155]  [<ffffffff810462f0>] worker_thread+0x1f6/0x2a3
[  107.564050]  [<ffffffff810460fa>] ? rescuer_thread+0x214/0x214
[  107.564984]  [<ffffffff81049c09>] kthread+0xc7/0xcf
[  107.565736]  [<ffffffff8125d297>] ? debug_smp_processor_id+0x17/0x19
[  107.566750]  [<ffffffff8106555c>] ? trace_hardirqs_on_caller+0x183/0x19f
[  107.567816]  [<ffffffff81049b42>] ? __kthread_parkme+0x62/0x62
[  107.568793]  [<ffffffff814c84ac>] ret_from_fork+0x7c/0xb0
[  107.569649]  [<ffffffff81049b42>] ? __kthread_parkme+0x62/0x62
[  107.570564] ---[ end trace e08bef2cbd6b29cf ]---
[  107.571274] em2884 #0: Resuming extensions
[  107.571921] em2884 #0: Resuming video extensionem2884 #0: Resuming DVB extension
[  107.597838] drxk: status = 0x439130d9
[  107.598599] drxk: detected a drx-3913k, spin A2, xtal 20.250 MHz
[  107.656843] ata2.01: NODEV after polling detection
[  107.658105] ata1.01: NODEV after polling detection
[  107.660707] ata2.00: configured for MWDMA2
[  107.661689] ata1.00: configured for MWDMA2
[  107.682546] virtio-pci 0000:00:03.0: irq 24 for MSI/MSI-X
[  107.683798] virtio-pci 0000:00:03.0: irq 25 for MSI/MSI-X
[  107.684815] virtio-pci 0000:00:03.0: irq 26 for MSI/MSI-X
[  110.903099] drxk: DRXK driver version 0.9.4300
[  110.941624] em2884 #0: fe0 resume 0
[  110.942441] PM: thaw of devices complete after 3446.585 msecs
[  110.944355] PM: writing image.
[  110.946607] PM: Using 3 thread(s) for compression.
[  110.946607] PM: Compressing and saving image data (26783 pages)...
[  110.948648] PM: Image saving progress:   0%
[  111.017447] PM: Image saving progress:  10%
[  111.048111] PM: Image saving progress:  20%
[  111.078501] PM: Image saving progress:  30%
[  111.132577] PM: Image saving progress:  40%
[  111.224805] PM: Image saving progress:  50%
[  111.265438] PM: Image saving progress:  60%
[  111.302244] PM: Image saving progress:  70%
[  111.330929] PM: Image saving progress:  80%
[  111.380472] PM: Image saving progress:  90%
[  111.444906] PM: Image saving progress: 100%
[  111.460365] PM: Image saving done.
[  111.460995] PM: Wrote 107132 kbytes in 0.51 seconds (210.06 MB/s)
[  111.463028] PM: S|
[  111.487545] em2884 #0: Suspending extensions
[  111.488435] em2884 #0: Suspending video extension[  111.488655] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  111.492249] em2884 #0: Suspending DVB extension
[  111.498720] em2884 #0: fe0 suspend 0[  111.912096] sd 0:0:0:0: [sda] Stopping disk
[  111.913927] PM: hibernate of devices complete after 426.602 msecs
[  111.916300] PM: late hibernate of devices complete after 0.881 msecs
[  111.918800] PM: noirq hibernate of devices complete after 1.000 msecs
[  111.920437] ACPI: Preparing to enter system sleep state S4
[  111.921588] PM: Saving platform NVS memory
[  111.922544] Disabling non-boot CPUs ...
[  111.925574] smpboot: CPU 1 is now offline
[  111.929566] smpboot: CPU 2 is now offline
[  111.932933] smpboot: CPU 3 is now offline

(snipped some irrelevant part of resume)

[    2.294251] PM: Image loading progress:   0%
[    2.351260] usb 1-1: New USB device found, idVendor=2040, idProduct=1605
[    2.352679] usb 1-1: New USB device strings: Mfr=0, Product=1, SerialNumber=2
[    2.354050] usb 1-1: Product: WinTV HVR-930C
[    2.354912] usb 1-1: SerialNumber: 4034209007
[    2.357962] em28xx: New device  WinTV HVR-930C @ 480 Mbps (2040:1605, interface 0, class 0)
[    2.359568] em28xx: Audio interface 0 found (Vendor Class)
[    2.360700] em28xx: Video interface 0 found: isoc
[    2.361590] em28xx: DVB interface 0 found: isoc
[    2.362961] em28xx: chip ID is em2884
[    2.426081] PM: Image loading progress:  10%
[    2.436945] em2884 #0: EEPROM ID = 26 00 01 00, EEPROM hash = 0x33f006aa
[    2.438478] em2884 #0: EEPROM info:
[    2.439412] em2884 #0:       microcode start address = 0x0004, boot configuration = 0x01
[    2.452383] PM: Image loading progress:  20%
[    2.461029] em2884 #0:       I2S audio, 5 sample rates
[    2.461990] em2884 #0:       500mA max power
[    2.462711] em2884 #0:       Table at offset 0x24, strings=0x1e82, 0x186a, 0x0000
[    2.464248] em2884 #0: Identified as Hauppauge WinTV HVR 930C (card=81)
[    2.465443] tveeprom 2-0050: Hauppauge model 16009, rev B1F0, serial# 7677167
[    2.466813] tveeprom 2-0050: MAC address is 00:0d:fe:75:24:ef
[    2.467856] tveeprom 2-0050: tuner model is Xceive XC5000 (idx 150, type 76)
[    2.469650] tveeprom 2-0050: TV standards PAL(B/G) PAL(I) SECAM(L/L') PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xf4)
[    2.471753] tveeprom 2-0050: audio processor is unknown (idx 45)
[    2.473053] tveeprom 2-0050: decoder processor is unknown (idx 44)
[    2.474484] tveeprom 2-0050: has no radio, has IR receiver, has no IR transmitter
[    2.476172] em2884 #0: analog set to isoc mode.
[    2.477250] em2884 #0: dvb set to isoc mode.
[    2.478407] em2884 #0: Registering V4L2 extension
[    2.483092] em2884 #0: Config register raw data: 0xc3
[    2.489036] PM: Image loading progress:  30%
[    2.503024] em2884 #0: V4L2 video device registered as video0
[    2.504239] em2884 #0: V4L2 extension successfully initialized
[    2.505670] em2884 #0: Binding DVB extension
[    2.509139] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/i8042/serio1/input/input3
[    2.515851] PM: Image loading progress:  40%
[    2.537861] PM: Image loading progress:  50%
[    2.555687] PM: Image loading progress:  60%
[    2.574087] PM: Image loading progress:  70%
[    2.595687] PM: Image loading progress:  80%
[    2.612580] PM: Image loading progress:  90%
[    2.631157] PM: Image loading progress: 100%
[    2.632448] PM: Image loading done.
[    2.633339] PM: Read 107132 kbytes in 0.53 seconds (202.13 MB/s)
[    2.641831] PM: Image successfully loaded
[    2.643767] em2884 #0: Suspending extensions
[    3.017460] Switched to clocksource tsc
[    3.820194] ------------[ cut here ]------------
[    3.821254] WARNING: CPU: 1 PID: 39 at drivers/base/firmware_class.c:1124 _request_firmware+0x205/0x568()
[    3.823213] Modules linked in:
[    3.823813] CPU: 1 PID: 39 Comm: kworker/1:1 Not tainted 3.17.0-rc5-00734-g214635f-dirty #87
[    3.825412] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
[    3.827381] Workqueue: events request_module_async
[    3.828196]  0000000000000000 ffff88003dff7b38 ffffffff814bc918 0000000000000000
[    3.829183]  ffff88003dff7b70 ffffffff81032d75 ffffffff8132094c 00000000fffffff5
[    3.830277]  ffff880039f46ea0 ffff88003ca3bf40 ffff880036540900 ffff88003dff7b80
[    3.831350] Call Trace:
[    3.831709]  [<ffffffff814bc918>] dump_stack+0x4e/0x7a
[    3.832417]  [<ffffffff81032d75>] warn_slowpath_common+0x7a/0x93
[    3.833145]  [<ffffffff8132094c>] ? _request_firmware+0x205/0x568
[    3.833823]  [<ffffffff81032e32>] warn_slowpath_null+0x15/0x17
[    3.834470]  [<ffffffff8132094c>] _request_firmware+0x205/0x568
[    3.835127]  [<ffffffff81065585>] ? trace_hardirqs_on+0xd/0xf
[    3.835764]  [<ffffffff81063c2c>] ? lockdep_init_map+0xc4/0x13f
[    3.836443]  [<ffffffff81320cdf>] request_firmware+0x30/0x42
[    3.837079]  [<ffffffff813f9570>] drxk_attach+0x546/0x651
[    3.837681]  [<ffffffff814c20f3>] em28xx_dvb_init.part.3+0xa3e/0x1cdf
[    3.838394]  [<ffffffff8106555c>] ? trace_hardirqs_on_caller+0x183/0x19f
[    3.839158]  [<ffffffff81065585>] ? trace_hardirqs_on+0xd/0xf
[    3.840239]  [<ffffffff814c5995>] ? mutex_unlock+0x9/0xb
[    3.841220]  [<ffffffff814c0da0>] ? em28xx_v4l2_init.part.11+0xcbd/0xd04
[    3.842409]  [<ffffffff81422f28>] em28xx_dvb_init+0x1d/0x1f
[    3.843412]  [<ffffffff8141ce11>] em28xx_init_extension+0x51/0x67
[    3.844524]  [<ffffffff8141e41c>] request_module_async+0x19/0x1b
[    3.845629]  [<ffffffff8104585c>] process_one_work+0x1d2/0x38a
[    3.846660]  [<ffffffff810462f0>] worker_thread+0x1f6/0x2a3
[    3.847611]  [<ffffffff810460fa>] ? rescuer_thread+0x214/0x214
[    3.848595]  [<ffffffff81049c09>] kthread+0xc7/0xcf
[    3.849399]  [<ffffffff8125d297>] ? debug_smp_processor_id+0x17/0x19
[    3.850416]  [<ffffffff8106555c>] ? trace_hardirqs_on_caller+0x183/0x19f
[    3.851516]  [<ffffffff81049b42>] ? __kthread_parkme+0x62/0x62
[    3.852495]  [<ffffffff814c84ac>] ret_from_fork+0x7c/0xb0
[    3.853426]  [<ffffffff81049b42>] ? __kthread_parkme+0x62/0x62
[    3.854408] ---[ end trace effa7bf83e0c1ff9 ]---
[    3.855156] usb 1-1: firmware: dvb-usb-hauppauge-hvr930c-drxk.fw will not be loaded
[    3.856430] drxk: Could not load firmware file dvb-usb-hauppauge-hvr930c-drxk.fw.
[    3.857673] drxk: Copy dvb-usb-hauppauge-hvr930c-drxk.fw to your hotplug directory!
[    3.859029] drxk: Trying to use the internal firmware, but this may not work well. Be warned.
[    3.882744] drxk: status = 0x439130d9
[    3.883528] drxk: detected a drx-3913k, spin A2, xtal 20.250 MHz
[    3.973967] drxk: DRXK driver version 0.9.4300
[    4.012165] drxk: frontend initialized.
[    4.013124] xc5000 2-0061: creating new instance
[    4.015903] xc5000: Successfully identified at address 0x61
[    4.017107] xc5000: Firmware has not been loaded previously
[    4.018217] DVB: registering new adapter (em2884 #0)
[    4.019212] usb 1-1: DVB: registering adapter 0 frontend 0 (DRXK DVB-C DVB-T)...
[    4.022903] dvb dvb0.frontend0: parent 1-1 should not be sleeping
[    4.025084] dvb dvb0.demux0: parent 1-1 should not be sleeping
[    4.026526] dvb dvb0.dvr0: parent 1-1 should not be sleeping
[    4.027823] dvb dvb0.net0: parent 1-1 should not be sleeping
[    4.028915] em2884 #0: DVB extension successfully initialized
[    4.030127] em2884 #0: Suspending video extension
[    4.033074] em2884 #0: Suspending DVB extensionem2884 #0: fe0 suspend 0
[    4.041692] PM: quiesce of devices complete after 1398.190 msecs
[    4.043760] PM: late quiesce of devices complete after 0.919 msecs
[    4.046615] PM: noirq quiesce of devices complete after 1.656 msecs
[    4.047897] Disabling non-boot CPUs ...
[    4.110865] smpboot: CPU 1 is now offline
[    4.169704] smpboot: CPU 2 is now offline
[    4.336176] smpboot: CPU 3 is now offline
[  107.389233] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S0_] (20140724/hwxface-580)
[  107.389233] PM: Restoring platform NVS memory
[  107.389233] Enabling non-boot CPUs ...
[  107.389233] x86: Booting SMP configuration:
[  107.389763] smpboot: Booting Node 0 Processor 1 APIC 0x1
[  107.422619] CPU1 is up
[  107.423716] smpboot: Booting Node 0 Processor 2 APIC 0x2
[  107.456494] CPU2 is up
[  107.457684] smpboot: Booting Node 0 Processor 3 APIC 0x3
[  107.490421] CPU3 is up
[  107.491250] ACPI: Waking up from system sleep state S4
[  107.494704] PM: noirq restore of devices complete after 2.308 msecs
[  107.496714] PM: early restore of devices complete after 0.683 msecs
[  107.520347] rtc_cmos 00:00: System wakeup disabled by ACPI
[  107.524108] usb usb1: root hub lost power or was reset
[  107.525203] sd 0:0:0:0: [sda] Starting disk
[  107.698445] virtio-pci 0000:00:03.0: irq 24 for MSI/MSI-X
[  107.699618] virtio-pci 0000:00:03.0: irq 25 for MSI/MSI-X
[  107.700705] virtio-pci 0000:00:03.0: irq 26 for MSI/MSI-X
[  107.840525] ata1.01: NODEV after polling detection
[  107.842662] ata1.00: configured for MWDMA2
[  107.844476] ata2.01: NODEV after polling detection
[  107.846051] ata2.00: configured for MWDMA2
[  108.110654] Clocksource tsc unstable (delta = -102508626 ns)
[  108.112463] Switched to clocksource hpet
[  108.164179] usb 1-1: reset high-speed USB device number 2 using ehci-pci
[  108.456147] ------------[ cut here ]------------
[  108.457648] WARNING: CPU: 2 PID: 2056 at drivers/media/usb/em28xx/em28xx-cards.c:3505 em28xx_usb_resume+0x19/0x2f()
[  108.459855] Modules linked in:
[  108.460522] CPU: 2 PID: 2056 Comm: kworker/u8:12 Not tainted 3.17.0-rc5-00734-g214635f-dirty #87
[  108.462294] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
[  108.464298] Workqueue: events_unbound async_run_entry_fn
[  108.465315]  0000000000000000 ffff88003cd9fbf8 ffffffff814bc918 0000000000000000
[  108.466784]  ffff88003cd9fc30 ffffffff81032d75 ffffffff8141e3d1 ffff88003cb84000
[  108.468450]  0000000000000000 ffffffff813688c6 0000000000000000 ffff88003cd9fc40
[  108.469907] Call Trace:
[  108.470399]  [<ffffffff814bc918>] dump_stack+0x4e/0x7a
[  108.471358]  [<ffffffff81032d75>] warn_slowpath_common+0x7a/0x93
[  108.472505]  [<ffffffff8141e3d1>] ? em28xx_usb_resume+0x19/0x2f
[  108.473575]  [<ffffffff813688c6>] ? usb_for_each_dev+0x2b/0x2b
[  108.474611]  [<ffffffff81032e32>] warn_slowpath_null+0x15/0x17
[  108.475685]  [<ffffffff8141e3d1>] em28xx_usb_resume+0x19/0x2f
[  108.476783]  [<ffffffff81374973>] usb_resume_interface.isra.6+0x6c/0xc1
[  108.477957]  [<ffffffff81374c3e>] usb_resume_both+0xe3/0x103
[  108.478943]  [<ffffffff813755c2>] usb_resume+0x16/0x5b
[  108.479849]  [<ffffffff813688d4>] usb_dev_restore+0xe/0x10
[  108.480778]  [<ffffffff8131d564>] dpm_run_callback+0x3f/0x76
[  108.481673]  [<ffffffff8131e194>] device_resume+0x155/0x17f
[  108.482670]  [<ffffffff8131e1d6>] async_resume+0x18/0x3e
[  108.483556]  [<ffffffff8104c526>] async_run_entry_fn+0x5c/0x106
[  108.484557]  [<ffffffff8104585c>] process_one_work+0x1d2/0x38a
[  108.485547]  [<ffffffff81062d20>] ? trace_hardirqs_off_caller+0x40/0xad
[  108.486689]  [<ffffffff810462f0>] worker_thread+0x1f6/0x2a3
[  108.487668]  [<ffffffff810460fa>] ? rescuer_thread+0x214/0x214
[  108.488661]  [<ffffffff81049c09>] kthread+0xc7/0xcf
[  108.489475]  [<ffffffff8125d297>] ? debug_smp_processor_id+0x17/0x19
[  108.490534]  [<ffffffff8106555c>] ? trace_hardirqs_on_caller+0x183/0x19f
[  108.491714]  [<ffffffff81049b42>] ? __kthread_parkme+0x62/0x62
[  108.492736]  [<ffffffff814c84ac>] ret_from_fork+0x7c/0xb0
[  108.493641]  [<ffffffff81049b42>] ? __kthread_parkme+0x62/0x62
[  108.494602] ---[ end trace e08bef2cbd6b29cf ]---
[  108.495392] em2884 #0: Resuming extensions
[  108.496054] em2884 #0: Resuming video extensionem2884 #0: Resuming DVB extension
[  108.521548] drxk: status = 0x439130d9
[  108.522319] drxk: detected a drx-3913k, spin A2, xtal 20.250 MHz
[  111.614883] drxk: DRXK driver version 0.9.4300
[  111.660574] em2884 #0: fe0 resume 0
[  111.661959] PM: restore of devices complete after 4142.650 msecs
[  111.665386] PM: Image restored successfully.
[  111.666893] PM: Basic memory bitmaps freed
[  111.668360] Restarting tasks ... done.

