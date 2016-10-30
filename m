Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.southpole.se ([37.247.8.11]:39149 "EHLO mail.southpole.se"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751670AbcJ3MoC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 30 Oct 2016 08:44:02 -0400
Received: from [192.168.1.138] (assp.southpole.se [37.247.8.10])
        by mail.southpole.se (Postfix) with ESMTPSA id F24114404EC
        for <linux-media@vger.kernel.org>; Sun, 30 Oct 2016 13:22:24 +0100 (CET)
To: linux-media@vger.kernel.org
From: Benjamin Larsson <benjamin@southpole.se>
Subject: [BUG] non working drivers with current linuxtv git on Ubuntu 16.04.1
 LTS
Message-ID: <bdd2742f-3249-9a9b-9703-be0be33bb556@southpole.se>
Date: Sun, 30 Oct 2016 13:22:24 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Just a plain driver install on a newly installed box. The faulting 
drivers did work before using the Ubuntu 16.04 kernel.


WARNING: You are using an experimental version of the media stack.
As the driver is backported to an older kernel, it doesn't offer
enough quality for its usage in production.
Use it with care.
Latest git patches (needed if you report a bug to 
linux-media@vger.kernel.org):
bd676c0c04ec94bd830b9192e2c33f2c4532278d [media] v4l2-flash-led-class: 
remove a now unused var
079933dbcb02132cc48ba052882fe0a9e3b0b762 [media] v4l: flash led class: 
Fix of_node release in probe() error path
c762ff1f7e3b09293c22ce62135ef550c1b3327c [media] coda: fix the error 
path in coda_probe()


I followed the instructions from the user part on the wiki.

I got this for my anysee card:

dvb_usb_anysee: disagrees about version of symbol dvb_ca_en50221_init
dvb_usb_anysee: Unknown symbol dvb_ca_en50221_init (err -22)
dvb_usb_anysee: disagrees about version of symbol dvb_ca_en50221_release
dvb_usb_anysee: Unknown symbol dvb_ca_en50221_release (err -22)
dvb_usb_anysee: disagrees about version of symbol rc_keydown
dvb_usb_anysee: Unknown symbol rc_keydown (err -22)
dvb_usb_anysee: disagrees about version of symbol 
dvb_usbv2_generic_rw_locked
dvb_usb_anysee: Unknown symbol dvb_usbv2_generic_rw_locked (err -22)


And this for my Mygica T230 card:

dvb-usb: found a 'Mygica T230 DVB-T/T2/C' in warm state.
BUG: unable to handle kernel NULL pointer dereference at           (null)
IP: [<ffffffff8182f688>] __mutex_lock_slowpath+0x98/0x130
PGD 0
Oops: 0002 [#1] SMP
Modules linked in: dvb_usb_cxusb(OE+) dib0070(OE) dvb_usb_rtl28xxu(OE+) 
dvb_usb_dw2102(OE+) dvb_usb(OE) dvb_usb_v2(OE) dvb_core(OE) rc_core(OE) 
ipmi_ssif media(OE) lpc_sch joydev input_leds i2c_ismt ipmi_si 
8250_fintek ipmi_msghandler shpchp mac_hid kvm_intel kvm irqbypass 
ib_iser rdma_cm iw_cm ib_cm ib_sa ib_mad ib_core ib_addr iscsi_tcp 
libiscsi_tcp libiscsi scsi_transport_iscsi autofs4 btrfs raid10 
multipath linear raid456 async_raid6_recov async_memcpy async_pq 
async_xor async_tx xor raid6_pq libcrc32c raid0 raid1 hid_generic igb 
dca usbhid ptp pps_core i2c_algo_bit hid ahci libahci fjes
CPU: 3 PID: 571 Comm: systemd-udevd Tainted: G           OE 
4.4.0-45-generic #66-Ubuntu
Hardware name: Supermicro X9SBAA/X9SBAA, BIOS 1.00 04/29/2014
task: ffff880231678000 ti: ffff880232048000 task.ti: ffff880232048000
RIP: 0010:[<ffffffff8182f688>]  [<ffffffff8182f688>] 
__mutex_lock_slowpath+0x98/0x130
RSP: 0018:ffff88023204b920  EFLAGS: 00010282
RAX: 0000000000000000 RBX: ffff88023152fea8 RCX: 0000000000000000
RDX: 0000000000000001 RSI: ffff880231678000 RDI: ffff88023152feac
RBP: ffff88023204b970 R08: ffff880232048000 R09: 0000000000000000
R10: 0000000000000325 R11: 0000000000000000 R12: ffff88023152feac
R13: ffff880231678000 R14: 00000000ffffffff R15: ffff88023152feb0
FS:  00007fc5390d68c0(0000) GS:ffff88023fd80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000023262f000 CR4: 00000000000006e0
Stack:
ffff88023152feb0 0000000000000000 ffff88023204b978 0000000027226a0c
01ff880200000000 ffff88023152fea8 ffff88023152fe40 ffff88023152fea8
ffff8800ba9e4000 0000000000000000 ffff88023204b988 ffffffff8182f73f
Call Trace:
[<ffffffff8182f73f>] mutex_lock+0x1f/0x30
[<ffffffffc04793da>] cxusb_ctrl_msg+0x5a/0xe0 [dvb_usb_cxusb]
[<ffffffffc0479ac8>] cxusb_power_ctrl+0x58/0x60 [dvb_usb_cxusb]
[<ffffffffc047b0db>] cxusb_d680_dmb_power_ctrl+0x2b/0x90 [dvb_usb_cxusb]
[<ffffffffc050e5a1>] dvb_usb_device_power_ctrl.part.4+0x31/0x50 [dvb_usb]
[<ffffffffc050e5ea>] dvb_usb_device_power_ctrl+0x2a/0x40 [dvb_usb]
[<ffffffffc050e844>] dvb_usb_device_init+0x244/0x750 [dvb_usb]
[<ffffffff8128baca>] ? kernfs_activate+0x7a/0xe0
[<ffffffffc0479360>] cxusb_probe+0x260/0x280 [dvb_usb_cxusb]
[<ffffffff8161e858>] usb_probe_interface+0x118/0x2f0
[<ffffffff815550d2>] driver_probe_device+0x222/0x4a0
[<ffffffff815553d4>] __driver_attach+0x84/0x90
[<ffffffff81555350>] ? driver_probe_device+0x4a0/0x4a0
[<ffffffff81552cfc>] bus_for_each_dev+0x6c/0xc0
[<ffffffff8155488e>] driver_attach+0x1e/0x20
[<ffffffff815543cb>] bus_add_driver+0x1eb/0x280
[<ffffffff81555ce0>] driver_register+0x60/0xe0
[<ffffffff8161d224>] usb_register_driver+0x84/0x140
[<ffffffffc03d8000>] ? 0xffffffffc03d8000
[<ffffffffc03d801e>] cxusb_driver_init+0x1e/0x1000 [dvb_usb_cxusb]
[<ffffffff81002123>] do_one_initcall+0xb3/0x200
[<ffffffff811cfa51>] ? __vunmap+0x91/0xe0
[<ffffffff811ebc03>] ? kmem_cache_alloc_trace+0x183/0x1f0
[<ffffffff811ec9fa>] ? kfree+0x13a/0x150
[<ffffffff8118caa3>] do_init_module+0x5f/0x1cf
[<ffffffff8110a2ff>] load_module+0x166f/0x1c10
[<ffffffff811068a0>] ? __symbol_put+0x60/0x60
[<ffffffff81213760>] ? kernel_read+0x50/0x80
[<ffffffff8110aae4>] SYSC_finit_module+0xb4/0xe0
[<ffffffff8110ab2e>] SyS_finit_module+0xe/0x10
[<ffffffff818318b2>] entry_SYSCALL_64_fastpath+0x16/0x71
Code: e8 ae 1f 00 00 8b 03 83 f8 01 0f 84 94 00 00 00 48 8b 43 10 4c 8d 
7b 08 48 89 63 10 41 be ff ff ff ff 4c 89 3c 24 48 89 44 24 08 <48> 89 
20 4c 89 6c 24 10 eb 1f 49 c7 45 00 02 00 00 00 4c 89 e7
RIP  [<ffffffff8182f688>] __mutex_lock_slowpath+0x98/0x130
  RSP <ffff88023204b920>
CR2: 0000000000000000
---[ end trace b28b9190ee8e4917 ]---

MvH
Benjamin Larsson
