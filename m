Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:37889 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754990AbaIZOae (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Sep 2014 10:30:34 -0400
Message-ID: <54257888.90802@osg.samsung.com>
Date: Fri, 26 Sep 2014 08:30:32 -0600
From: Shuah Khan <shuahkh@osg.samsung.com>
MIME-Version: 1.0
To: Johannes Stezenbach <js@linuxtv.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: Shuah Khan <shuah.kh@samsung.com>, linux-media@vger.kernel.org,
	Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: em28xx breaks after hibernate
References: <542462C4.7020907@osg.samsung.com> <20140926080030.GB31491@linuxtv.org> <20140926080824.GA8382@linuxtv.org> <20140926071411.61a011bd@recife.lan> <20140926110727.GA880@linuxtv.org> <20140926084215.772adce9@recife.lan> <20140926090316.5ae56d93@recife.lan> <20140926122721.GA11597@linuxtv.org> <20140926101222.778ebcaf@recife.lan> <20140926132513.GA30084@linuxtv.org> <20140926142543.GA3806@linuxtv.org>
In-Reply-To: <20140926142543.GA3806@linuxtv.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/26/2014 08:25 AM, Johannes Stezenbach wrote:
> On Fri, Sep 26, 2014 at 03:25:13PM +0200, Johannes Stezenbach wrote:
>>
>> (snipped some irrelevant part of resume)
> 
> Looking closer, I snipped too much:
> 
> [    1.646784] Freeing unused kernel memory: 1080K (ffff8800018f2000 - ffff880001a00000)
> Loading, please wait...
> [    1.655328] busybox (67) used greatest stack depth: 13832 bytes left
> [    1.675777] udevd[80]: starting version 175
> [    1.714891] udevadm (81) used greatest stack depth: 13704 bytes left
> [    1.755582] ata_id (156) used greatest stack depth: 13512 bytes left
> [    1.805306] ata_id (163) used greatest stack depth: 12360 bytes left
> [    2.000165] tsc: Refined TSC clocksource calibration: 3299.998 MHz
> [    2.052171] usb 1-1: new high-speed USB device number 2 using ehci-pci
> [    2.095571] PM: Starting manual resume from disk
> [    2.096737] PM: Hibernation image partition 8:2 present
> [    2.097770] PM: Looking for hibernation image.
> [    2.099942] PM: Image signature found, resuming
> [    2.258955] PM: Preparing processes for restore.
> [    2.262675] Freezing user space processes ... (elapsed 0.003 seconds) done.
> [    2.262676] PM: Loading hibernation image.
> [    2.262732] PM: Marking nosave pages: [mem 0x0009f000-0x000fffff]
> [    2.262734] PM: Basic memory bitmaps created
> [    2.280526] PM: Using 3 thread(s) for decompression.
> [    2.280526] PM: Loading and decompressing image data (26873 pages)...
> [    2.325975] PM: Image loading progress:   0%
> 
> (this is from a different boot but suffient to show the problem)
> 
>> [    2.294251] PM: Image loading progress:   0%
>> [    2.351260] usb 1-1: New USB device found, idVendor=2040, idProduct=1605
>> [    2.352679] usb 1-1: New USB device strings: Mfr=0, Product=1, SerialNumber=2
>> [    2.354050] usb 1-1: Product: WinTV HVR-930C
>> [    2.354912] usb 1-1: SerialNumber: 4034209007
>> [    2.357962] em28xx: New device  WinTV HVR-930C @ 480 Mbps (2040:1605, interface 0, class 0)
>> [    2.359568] em28xx: Audio interface 0 found (Vendor Class)
>> [    2.360700] em28xx: Video interface 0 found: isoc
>> [    2.361590] em28xx: DVB interface 0 found: isoc
>> [    2.362961] em28xx: chip ID is em2884
>> [    2.426081] PM: Image loading progress:  10%
>> [    2.436945] em2884 #0: EEPROM ID = 26 00 01 00, EEPROM hash = 0x33f006aa
>> [    2.438478] em2884 #0: EEPROM info:
>> [    2.439412] em2884 #0:       microcode start address = 0x0004, boot configuration = 0x01
>> [    2.452383] PM: Image loading progress:  20%
>> [    2.461029] em2884 #0:       I2S audio, 5 sample rates
>> [    2.461990] em2884 #0:       500mA max power
>> [    2.462711] em2884 #0:       Table at offset 0x24, strings=0x1e82, 0x186a, 0x0000
>> [    2.464248] em2884 #0: Identified as Hauppauge WinTV HVR 930C (card=81)
>> [    2.465443] tveeprom 2-0050: Hauppauge model 16009, rev B1F0, serial# 7677167
>> [    2.466813] tveeprom 2-0050: MAC address is 00:0d:fe:75:24:ef
>> [    2.467856] tveeprom 2-0050: tuner model is Xceive XC5000 (idx 150, type 76)
>> [    2.469650] tveeprom 2-0050: TV standards PAL(B/G) PAL(I) SECAM(L/L') PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xf4)
>> [    2.471753] tveeprom 2-0050: audio processor is unknown (idx 45)
>> [    2.473053] tveeprom 2-0050: decoder processor is unknown (idx 44)
>> [    2.474484] tveeprom 2-0050: has no radio, has IR receiver, has no IR transmitter
>> [    2.476172] em2884 #0: analog set to isoc mode.
>> [    2.477250] em2884 #0: dvb set to isoc mode.
>> [    2.478407] em2884 #0: Registering V4L2 extension
>> [    2.483092] em2884 #0: Config register raw data: 0xc3
>> [    2.489036] PM: Image loading progress:  30%
>> [    2.503024] em2884 #0: V4L2 video device registered as video0
>> [    2.504239] em2884 #0: V4L2 extension successfully initialized
>> [    2.505670] em2884 #0: Binding DVB extension
>> [    2.509139] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/i8042/serio1/input/input3
>> [    2.515851] PM: Image loading progress:  40%
>> [    2.537861] PM: Image loading progress:  50%
>> [    2.555687] PM: Image loading progress:  60%
>> [    2.574087] PM: Image loading progress:  70%
>> [    2.595687] PM: Image loading progress:  80%
>> [    2.612580] PM: Image loading progress:  90%
>> [    2.631157] PM: Image loading progress: 100%
>> [    2.632448] PM: Image loading done.
>> [    2.633339] PM: Read 107132 kbytes in 0.53 seconds (202.13 MB/s)
>> [    2.641831] PM: Image successfully loaded
>> [    2.643767] em2884 #0: Suspending extensions
>> [    3.017460] Switched to clocksource tsc
>> [    3.820194] ------------[ cut here ]------------
>> [    3.821254] WARNING: CPU: 1 PID: 39 at drivers/base/firmware_class.c:1124 _request_firmware+0x205/0x568()
>> [    3.823213] Modules linked in:
>> [    3.823813] CPU: 1 PID: 39 Comm: kworker/1:1 Not tainted 3.17.0-rc5-00734-g214635f-dirty #87
>> [    3.825412] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
>> [    3.827381] Workqueue: events request_module_async
>> [    3.828196]  0000000000000000 ffff88003dff7b38 ffffffff814bc918 0000000000000000
>> [    3.829183]  ffff88003dff7b70 ffffffff81032d75 ffffffff8132094c 00000000fffffff5
>> [    3.830277]  ffff880039f46ea0 ffff88003ca3bf40 ffff880036540900 ffff88003dff7b80
>> [    3.831350] Call Trace:
>> [    3.831709]  [<ffffffff814bc918>] dump_stack+0x4e/0x7a
>> [    3.832417]  [<ffffffff81032d75>] warn_slowpath_common+0x7a/0x93
>> [    3.833145]  [<ffffffff8132094c>] ? _request_firmware+0x205/0x568
>> [    3.833823]  [<ffffffff81032e32>] warn_slowpath_null+0x15/0x17
>> [    3.834470]  [<ffffffff8132094c>] _request_firmware+0x205/0x568
>> [    3.835127]  [<ffffffff81065585>] ? trace_hardirqs_on+0xd/0xf
>> [    3.835764]  [<ffffffff81063c2c>] ? lockdep_init_map+0xc4/0x13f
>> [    3.836443]  [<ffffffff81320cdf>] request_firmware+0x30/0x42
>> [    3.837079]  [<ffffffff813f9570>] drxk_attach+0x546/0x651
>> [    3.837681]  [<ffffffff814c20f3>] em28xx_dvb_init.part.3+0xa3e/0x1cdf
>> [    3.838394]  [<ffffffff8106555c>] ? trace_hardirqs_on_caller+0x183/0x19f
>> [    3.839158]  [<ffffffff81065585>] ? trace_hardirqs_on+0xd/0xf
>> [    3.840239]  [<ffffffff814c5995>] ? mutex_unlock+0x9/0xb
>> [    3.841220]  [<ffffffff814c0da0>] ? em28xx_v4l2_init.part.11+0xcbd/0xd04
>> [    3.842409]  [<ffffffff81422f28>] em28xx_dvb_init+0x1d/0x1f
>> [    3.843412]  [<ffffffff8141ce11>] em28xx_init_extension+0x51/0x67
>> [    3.844524]  [<ffffffff8141e41c>] request_module_async+0x19/0x1b
>> [    3.845629]  [<ffffffff8104585c>] process_one_work+0x1d2/0x38a
>> [    3.846660]  [<ffffffff810462f0>] worker_thread+0x1f6/0x2a3
>> [    3.847611]  [<ffffffff810460fa>] ? rescuer_thread+0x214/0x214
>> [    3.848595]  [<ffffffff81049c09>] kthread+0xc7/0xcf
>> [    3.849399]  [<ffffffff8125d297>] ? debug_smp_processor_id+0x17/0x19
>> [    3.850416]  [<ffffffff8106555c>] ? trace_hardirqs_on_caller+0x183/0x19f
>> [    3.851516]  [<ffffffff81049b42>] ? __kthread_parkme+0x62/0x62
>> [    3.852495]  [<ffffffff814c84ac>] ret_from_fork+0x7c/0xb0
>> [    3.853426]  [<ffffffff81049b42>] ? __kthread_parkme+0x62/0x62
>> [    3.854408] ---[ end trace effa7bf83e0c1ff9 ]---
>> [    3.855156] usb 1-1: firmware: dvb-usb-hauppauge-hvr930c-drxk.fw will not be loaded
>> [    3.856430] drxk: Could not load firmware file dvb-usb-hauppauge-hvr930c-drxk.fw.
> 
> So, what is happening is that the em28xx driver still async initializes
> while the initramfs already has started resume.  Thus the rootfs in not
> mounted and the firmware is not loadable.  Maybe this is only an issue
> of my qemu test because I compiled a non-modular kernel but don't have
> the firmware in the initramfs for testing simplicity?
> 
> 

Right. We have an issue when media drivers are compiled static
(non-modular). I have been debugging that problem for a while.
We have to separate the two cases - if you are compiling em28xx
as static then you will run into the issue.

thanks,
-- Shuah


-- 
Shuah Khan
Sr. Linux Kernel Developer
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
