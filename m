Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:45472 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724Ab3J3Pgl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Oct 2013 11:36:41 -0400
Message-ID: <52712787.3010408@iki.fi>
Date: Wed, 30 Oct 2013 17:36:39 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] rtl2830: add parent for I2C adapter
References: <1382386335-3879-1-git-send-email-crope@iki.fi> <52658CA7.5080104@iki.fi> <20131030151620.GB3663@katana>
In-Reply-To: <20131030151620.GB3663@katana>
Content-Type: multipart/mixed;
 boundary="------------040603090403030106030600"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040603090403030106030600
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

(now with an attachement)

On 30.10.2013 17:16, Wolfram Sang wrote:
> Hi,
>
> sorry for the delay. The Kernel Summit made a pretty busy time out of
> the last weeks...
>
>> I found one of my drivers was crashing when DTV USB stick was
>> plugged. Patch in that mail patch fixes the problem.
>
> Well, if you have a parent, it should be set. This is always a good
> idea. Can't really tell why not having it causes the BUG, though.
>
>> I quickly looked possible I2C patches causing the problem and saw
>> that one as most suspicions:
>>
>> commit 3923172b3d700486c1ca24df9c4c5405a83e2309
>> i2c: reduce parent checking to a NOOP in non-I2C_MUX case
>
> Did you try reverting it? I am not sure this is the one.

Nope, not to mentio bisect. I have done bisect few times and I am not 
going to waste whole day of compiling and booting new kernels.

Crash disappeared whit that little patch. I did also some DVB USB core 
changes for 3.12, but I cannot see it could be root of cause that crash.


>>> i2c i2c-6: adapter [RTL2830 tuner I2C adapter] registered
>>> BUG: unable to handle kernel NULL pointer dereference at 0000000000000220
>>> IP: [<ffffffffa0002900>] i2c_register_adapter+0x130/0x390 [i2c_core]
>
> Can we have the full BUG output?

See attachement.

Anyway, I am going to ask Mauro to merge that I2C parent patch and maybe 
try to sent it stable too as it is likely a bit too late for 3.12 RC.


regards
Antti

-- 
http://palosaari.fi/

--------------040603090403030106030600
Content-Type: text/plain; charset=UTF-8;
 name="rtl2830_i2c_adapter_crash.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="rtl2830_i2c_adapter_crash.txt"

loka 30 17:28:09 localhost.localdomain kernel: usb 2-2: new high-speed USB device number 2 using ehci-pci
loka 30 17:28:09 localhost.localdomain kernel: usb 2-2: New USB device found, idVendor=14aa, idProduct=0160
loka 30 17:28:09 localhost.localdomain kernel: usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
loka 30 17:28:09 localhost.localdomain kernel: [31B blob data]
loka 30 17:28:09 localhost.localdomain kernel: [36B blob data]
loka 30 17:28:09 localhost.localdomain kernel: usb 2-2: SerialNumber: 0000000000065658
loka 30 17:28:09 localhost.localdomain mtp-probe[3060]: checking bus 2, device 2: "/sys/devices/pci0000:00/0000:00:13.2/usb2/2-2"
loka 30 17:28:09 localhost.localdomain mtp-probe[3060]: bus: 2, device: 2 was not an MTP device
loka 30 17:28:09 localhost.localdomain kernel: usb 2-2: dvb_usb_v2: found a 'Freecom USB2.0 DVB-T' in warm state
loka 30 17:28:09 localhost.localdomain kernel: usb 2-2: dvb_usb_v2: will pass the complete MPEG2 transport stream to the software demuxer
loka 30 17:28:09 localhost.localdomain kernel: DVB: registering new adapter (Freecom USB2.0 DVB-T)
loka 30 17:28:09 localhost.localdomain kernel: BUG: unable to handle kernel NULL pointer dereference at 0000000000000220
loka 30 17:28:09 localhost.localdomain kernel: IP: [<ffffffffa0002900>] i2c_register_adapter+0x130/0x390 [i2c_core]
loka 30 17:28:09 localhost.localdomain systemd-udevd[434]: worker [3059] terminated by signal 9 (Killed)
loka 30 17:28:09 localhost.localdomain systemd-udevd[434]: worker [3059] failed while handling '/devices/pci0000:00/0000:00:13.2/usb2/2-2/2-2:1.0'
loka 30 17:28:09 localhost.localdomain kernel: PGD 0 
loka 30 17:28:09 localhost.localdomain kernel: Oops: 0000 [#1] SMP 
loka 30 17:28:09 localhost.localdomain kernel: Modules linked in: dvb_usb_rtl28xxu(O+) rtl2830(O) dvb_usb_v2(O) fuse nf_conntrack_netbios_ns nf_conntrack_broadcast ipt_MAS...p6table_man
loka 30 17:28:09 localhost.localdomain kernel:  btusb snd_pcm bluetooth rc_core(O) microcode nfsd serio_raw edac_core pcspkr k10temp edac_mce_amd r8169 snd_page_alloc rfkill snd_time...
loka 30 17:28:09 localhost.localdomain kernel: CPU: 1 PID: 3059 Comm: systemd-udevd Tainted: G           O 3.12.0-rc2+ #69
loka 30 17:28:09 localhost.localdomain kernel: Hardware name: System manufacturer System Product Name/M5A78L-M/USB3, BIOS 1503    11/14/2012
loka 30 17:28:09 localhost.localdomain kernel: task: ffff8800cf87ed60 ti: ffff8800bee5a000 task.ti: ffff8800bee5a000
loka 30 17:28:09 localhost.localdomain kernel: RIP: 0010:[<ffffffffa0002900>]  [<ffffffffa0002900>] i2c_register_adapter+0x130/0x390 [i2c_core]
loka 30 17:28:09 localhost.localdomain kernel: RSP: 0018:ffff8800bee5baa8  EFLAGS: 00010246
loka 30 17:28:09 localhost.localdomain kernel: RAX: 0000000000000000 RBX: ffff880237066520 RCX: ffff8800cee94da8
loka 30 17:28:09 localhost.localdomain kernel: RDX: ffff8800cee95e88 RSI: ffff88030971aec8 RDI: ffffffff81c70e60
loka 30 17:28:09 localhost.localdomain kernel: RBP: ffff8800bee5bac8 R08: ffff8800cee95e88 R09: 0000000000000000
loka 30 17:28:09 localhost.localdomain kernel: R10: 0000000000005457 R11: 0000000000000000 R12: 0000000000000000
loka 30 17:28:09 localhost.localdomain kernel: R13: ffff880237066568 R14: 0000000000000000 R15: ffff880237066520
loka 30 17:28:09 localhost.localdomain kernel: FS:  00007fd41e084880(0000) GS:ffff88031fc40000(0000) knlGS:0000000000000000
loka 30 17:28:09 localhost.localdomain kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
loka 30 17:28:09 localhost.localdomain kernel: CR2: 0000000000000220 CR3: 00000000b8724000 CR4: 00000000000007e0
loka 30 17:28:09 localhost.localdomain kernel: Stack:
loka 30 17:28:09 localhost.localdomain kernel:  ffff880237066520 ffff880237066520 0000000000000009 ffff880237066008
loka 30 17:28:09 localhost.localdomain kernel:  ffff8800bee5bae8 ffffffffa0002bbe ffff880237066000 ffff88030a00a0b0
loka 30 17:28:09 localhost.localdomain kernel:  ffff8800bee5bb28 ffffffffa067e3ed 00ff88030a00a000 ffff88030a00a420
loka 30 17:28:09 localhost.localdomain kernel: Call Trace:
loka 30 17:28:09 localhost.localdomain kernel:  [<ffffffffa0002bbe>] i2c_add_adapter+0x5e/0x70 [i2c_core]
loka 30 17:28:09 localhost.localdomain kernel:  [<ffffffffa067e3ed>] rtl2830_attach+0x11d/0xd30 [rtl2830]
loka 30 17:28:09 localhost.localdomain kernel:  [<ffffffffa068f345>] rtl2831u_frontend_attach+0xc5/0x1c0 [dvb_usb_rtl28xxu]
loka 30 17:28:09 localhost.localdomain kernel:  [<ffffffffa0686807>] dvb_usbv2_probe+0x607/0x1160 [dvb_usb_v2]
loka 30 17:28:09 localhost.localdomain kernel:  [<ffffffff814058a8>] ? __pm_runtime_set_status+0x128/0x1f0
loka 30 17:28:09 localhost.localdomain kernel:  [<ffffffff81476a94>] usb_probe_interface+0x1c4/0x2f0
loka 30 17:28:09 localhost.localdomain kernel:  [<ffffffff813f9387>] driver_probe_device+0x87/0x390
loka 30 17:28:09 localhost.localdomain kernel:  [<ffffffff813f9763>] __driver_attach+0x93/0xa0
loka 30 17:28:09 localhost.localdomain kernel:  [<ffffffff813f96d0>] ? __device_attach+0x40/0x40
loka 30 17:28:09 localhost.localdomain kernel:  [<ffffffff813f7243>] bus_for_each_dev+0x63/0xa0
loka 30 17:28:09 localhost.localdomain kernel:  [<ffffffff813f8dde>] driver_attach+0x1e/0x20
loka 30 17:28:09 localhost.localdomain kernel:  [<ffffffff813f8950>] bus_add_driver+0x200/0x2d0
loka 30 17:28:09 localhost.localdomain kernel:  [<ffffffff813f9d94>] driver_register+0x64/0xf0
loka 30 17:28:09 localhost.localdomain kernel:  [<ffffffff81475281>] usb_register_driver+0x81/0x160
loka 30 17:28:09 localhost.localdomain kernel:  [<ffffffffa0698000>] ? 0xffffffffa0697fff
loka 30 17:28:09 localhost.localdomain kernel:  [<ffffffffa069801e>] rtl28xxu_usb_driver_init+0x1e/0x1000 [dvb_usb_rtl28xxu]
loka 30 17:28:09 localhost.localdomain kernel:  [<ffffffff810020fa>] do_one_initcall+0xfa/0x1b0
loka 30 17:28:09 localhost.localdomain kernel:  [<ffffffff81053523>] ? set_memory_nx+0x43/0x50
loka 30 17:28:09 localhost.localdomain kernel:  [<ffffffff810d374d>] load_module+0x1b9d/0x2640
loka 30 17:28:09 localhost.localdomain kernel:  [<ffffffff810cf9b0>] ? store_uevent+0x40/0x40
loka 30 17:28:09 localhost.localdomain kernel:  [<ffffffff810d4366>] SyS_finit_module+0x86/0xb0
loka 30 17:28:09 localhost.localdomain kernel:  [<ffffffff816659a9>] system_call_fastpath+0x16/0x1b
loka 30 17:28:09 localhost.localdomain kernel: Code: df 01 00 00 48 81 fa 60 02 00 a0 0f 84 fa 01 00 00 48 83 78 10 00 0f 84 9f 01 00 00 48 83 78 08 00 0f 84 94 01 00 00 4...4 24 00 00 
loka 30 17:28:09 localhost.localdomain kernel: RIP  [<ffffffffa0002900>] i2c_register_adapter+0x130/0x390 [i2c_core]
loka 30 17:28:09 localhost.localdomain kernel:  RSP <ffff8800bee5baa8>
loka 30 17:28:09 localhost.localdomain kernel: CR2: 0000000000000220
loka 30 17:28:09 localhost.localdomain kernel: ---[ end trace fb79592d1bc9e92c ]---
loka 30 17:28:10 localhost.localdomain kernel: usb 2-2: USB disconnect, device number 2


--------------040603090403030106030600--
