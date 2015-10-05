Return-path: <linux-media-owner@vger.kernel.org>
Received: from anchovy2.45ru.net.au ([203.30.46.146]:33881 "EHLO
	anchovy.45ru.net.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751495AbbJECAy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 4 Oct 2015 22:00:54 -0400
Subject: Re: Hauppauge WinTV-HVR2205 driver feedback
To: Steven Toth <stoth@kernellabs.com>
References: <5610B12B.8090201@tresar-electronics.com.au>
 <CALzAhNWuOhQNQFu-baXy6QzhV3AxCknh7XeKOBjp943nz66Qyw@mail.gmail.com>
Cc: Linux-Media <linux-media@vger.kernel.org>
From: Richard Tresidder <rtresidd@tresar-electronics.com.au>
Message-ID: <5611D97B.9020101@tresar-electronics.com.au>
Date: Mon, 5 Oct 2015 09:59:23 +0800
MIME-Version: 1.0
In-Reply-To: <CALzAhNWuOhQNQFu-baXy6QzhV3AxCknh7XeKOBjp943nz66Qyw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steven
    Nope standard x86_64
kernel 3.10.0-229.14.1.el7.x86_64

Was rather surprised as all my quick reading indicates that the kernel 
should quite happily do this...
Though looks like its the largest chunk you can request? I'm not well 
enough up to speed with the nitty gritty..

There is mention of something similar against this card on www linuxtv 
org wiki index.php  Hauppauge_WinTV-HVR-2200

********
Note: Some kernels will not have enough free memory available for the 
driver. The dmesg error will start with a message like this:
] modprobe: page allocation failure: order:10, mode:0x2000d0
followed by a stack trace and other debugging information. While the 
driver will load, no devices will be registered.
The simple workaround is to allocate more memory for the kernel:
sudo /bin/echo 16384 > /proc/sys/vm/min_free_kbytes
sudo rmmod saa7164
sudo modprobe saa7164
********

log snippet and trace from my system before the path I made...
***********
Oct  3 18:43:09 richos kernel: CORE saa7164[0]: subsystem: 0070:f120, 
board: Hauppauge WinTV-HVR2205 [card=13,autodetected]
Oct  3 18:43:09 richos kernel: saa7164[0]/0: found at 0000:04:00.0, rev: 
129, irq: 18, latency: 0, mmio: 0xf7800000
Oct  3 18:43:09 richos kernel: saa7164_downloadfirmware() no first image
Oct  3 18:43:09 richos kernel: saa7164_downloadfirmware() Waiting for 
firmware upload (NXP7164-2010-03-10.1.fw)
Oct  3 18:43:09 richos kernel: saa7164_downloadfirmware() firmware read 
4019072 bytes.
Oct  3 18:43:09 richos kernel: saa7164_downloadfirmware() firmware loaded.
Oct  3 18:43:09 richos kernel: Firmware file header part 1:
Oct  3 18:43:09 richos kernel: .FirmwareSize = 0x0
Oct  3 18:43:09 richos kernel: .BSLSize = 0x0
Oct  3 18:43:09 richos kernel: .Reserved = 0x3d538
Oct  3 18:43:09 richos kernel: .Version = 0x3
Oct  3 18:43:09 richos kernel: saa7164_downloadfirmware() 
SecBootLoader.FileSize = 4019072
Oct  3 18:43:09 richos kernel: saa7164_downloadfirmware() FirmwareSize = 
0x1fd6
Oct  3 18:43:09 richos kernel: saa7164_downloadfirmware() BSLSize = 0x0
Oct  3 18:43:09 richos kernel: saa7164_downloadfirmware() Reserved = 0x0
Oct  3 18:43:09 richos kernel: saa7164_downloadfirmware() Version = 
0x1661c00
Oct  3 18:43:09 richos kernel: modprobe: page allocation failure: 
order:10, mode:0x10c0d0
Oct  3 18:43:09 richos kernel: CPU: 1 PID: 23702 Comm: modprobe Tainted: 
GF          O--------------   3.10.0-229.14.1.el7.x86_64 #1
Oct  3 18:43:09 richos kernel: Hardware name: System manufacturer System 
Product Name/P7H55-M/USB3, BIOS 0312    05/26/2010
Oct  3 18:43:09 richos kernel: 000000000010c0d0 00000000a89d2ba5 
ffff8801011d7810 ffffffff81604516
Oct  3 18:43:09 richos kernel: ffff8801011d78a0 ffffffff8115c5c0 
0000000000000000 00000000ffffffff
Oct  3 18:43:09 richos kernel: ffff880117fd6000 ffffffff8115efa6 
ffff8801011d7870 00000000a89d2ba5
Oct  3 18:43:09 richos kernel: Call Trace:
Oct  3 18:43:09 richos kernel: [<ffffffff81604516>] dump_stack+0x19/0x1b
Oct  3 18:43:09 richos kernel: [<ffffffff8115c5c0>] 
warn_alloc_failed+0x110/0x180
Oct  3 18:43:09 richos kernel: [<ffffffff8115efa6>] ? 
drain_local_pages+0x16/0x20
Oct  3 18:43:09 richos kernel: [<ffffffff81160d48>] 
__alloc_pages_nodemask+0x9a8/0xb90
Oct  3 18:43:09 richos kernel: [<ffffffff8119f3a9>] 
alloc_pages_current+0xa9/0x170
Oct  3 18:43:09 richos kernel: [<ffffffff8115b53e>] 
__get_free_pages+0xe/0x50
Oct  3 18:43:09 richos kernel: [<ffffffff811aa13e>] 
kmalloc_order_trace+0x2e/0xa0
Oct  3 18:43:09 richos kernel: [<ffffffffa082b3b1>] 
saa7164_downloadimage+0x9f/0x486 [saa7164]
Oct  3 18:43:09 richos kernel: [<ffffffffa0820212>] 
saa7164_downloadfirmware+0x882/0xbe0 [saa7164]
Oct  3 18:43:09 richos kernel: [<ffffffff8110d78c>] ? 
request_threaded_irq+0xcc/0x170
Oct  3 18:43:09 richos kernel: [<ffffffffa081d843>] 
saa7164_initdev+0x583/0xfd0 [saa7164]
Oct  3 18:43:09 richos kernel: [<ffffffff813087a5>] 
local_pci_probe+0x45/0xa0
*******************

On 4/10/2015 10:03 PM, Steven Toth wrote:
>> Seems the kzalloc(4 * 1048576, GFP_KERNEL) in saa7164-fw.c  was failing..
>> kept getting:  kernel: modprobe: page allocation failure: order:10,
>> mode:0x10c0d0
> I don't think I've ever seen or heard of that in the entire history of
> the driver.
>
> Are you running on traditional x86/x86 hardware, or something embedded/custom?
>

