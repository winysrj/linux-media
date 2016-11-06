Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:36528 "EHLO
        mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752216AbcKFPku (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 6 Nov 2016 10:40:50 -0500
MIME-Version: 1.0
From: =?UTF-8?Q?J=C3=B6rg_Otte?= <jrg.otte@gmail.com>
Date: Sun, 6 Nov 2016 16:40:48 +0100
Message-ID: <CADDKRnD6sQLsxwObi1Bo6k69P5ceqQHw7beT6C7TqZjUsDby+w@mail.gmail.com>
Subject: [v4.9-rc4] dvb-usb/cinergyT2 NULL pointer dereference
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since v4.9-rc4 I get following crash in dvb-usb-cinergyT2 module.

dvb-usb: found a 'TerraTec/qanu USB2.0 Highspeed DVB-T Receiver' in warm st=
ate.
BUG: unable to handle kernel NULL pointer dereference at           (null)
IP: [<ffffffff846617af>] __mutex_lock_slowpath+0x6f/0x100
PGD 0

Oops: 0002 [#1] SMP
Modules linked in: dvb_usb_cinergyT2(+) dvb_usb
CPU: 0 PID: 2029 Comm: modprobe Not tainted 4.9.0-rc4-dvbmod #24
Hardware name: FUJITSU LIFEBOOK A544/FJNBB35 , BIOS Version 1.17 05/09/2014
task: ffff88020e943840 task.stack: ffff8801f36ec000
RIP: 0010:[<ffffffff846617af>]  [<ffffffff846617af>]
__mutex_lock_slowpath+0x6f/0x100
RSP: 0018:ffff8801f36efb10  EFLAGS: 00010282
RAX: 0000000000000000 RBX: ffff88021509bdc8 RCX: 00000000c0000100
RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffff88021509bdcc
RBP: ffff8801f36efb58 R08: ffff88021f216320 R09: 0000000000100000
R10: ffff88021f216320 R11: 00000023fee6c5a1 R12: ffff88020e943840
R13: ffff88021509bdcc R14: 00000000ffffffff R15: ffff88021509bdd0
FS:  00007f21adb86740(0000) GS:ffff88021f200000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 0000000215bce000 CR4: 00000000001406f0
Stack:
 ffff88021509bdd0 0000000000000000 0000000000000000 ffffffffc0137c80
 ffff88021509bdc8 ffff8801f5944000 0000000000000001 ffffffffc0136b00
 ffff880213e52000 ffff88021509bdc8 ffffffff84661856 ffff88021509bd80
Call Trace:
 [<ffffffff84661856>] ? mutex_lock+0x16/0x25
 [<ffffffffc013616f>] ? cinergyt2_power_ctrl+0x1f/0x60 [dvb_usb_cinergyT2]
 [<ffffffffc012e67e>] ? dvb_usb_device_init+0x21e/0x5d0 [dvb_usb]
 [<ffffffffc0136021>] ? cinergyt2_usb_probe+0x21/0x50 [dvb_usb_cinergyT2]
 [<ffffffff844326f3>] ? usb_probe_interface+0xf3/0x2a0
 [<ffffffff8438e348>] ? driver_probe_device+0x208/0x2b0
 [<ffffffff8438e477>] ? __driver_attach+0x87/0x90
 [<ffffffff8438e3f0>] ? driver_probe_device+0x2b0/0x2b0
 [<ffffffff8438c612>] ? bus_for_each_dev+0x52/0x80
 [<ffffffff8438d983>] ? bus_add_driver+0x1a3/0x220
 [<ffffffff8438ec06>] ? driver_register+0x56/0xd0
 [<ffffffff84431527>] ? usb_register_driver+0x77/0x130
 [<ffffffffc013a000>] ? 0xffffffffc013a000
 [<ffffffff84000426>] ? do_one_initcall+0x46/0x180
 [<ffffffff840eb2c8>] ? free_vmap_area_noflush+0x38/0x70
 [<ffffffff840f3844>] ? kmem_cache_alloc+0x84/0xc0
 [<ffffffff840b802c>] ? do_init_module+0x50/0x1be
 [<ffffffff84095adb>] ? load_module+0x1d8b/0x2100
 [<ffffffff84093020>] ? find_symbol_in_section+0xa0/0xa0
 [<ffffffff84095fe9>] ? SyS_finit_module+0x89/0x90
 [<ffffffff846637a0>] ? entry_SYSCALL_64_fastpath+0x13/0x94
Code: e8 a7 1d 00 00 8b 03 83 f8 01 0f 84 97 00 00 00 48 8b 43 10 4c
8d 7b 08 48 89 63 10 4c 89 3c 24 41 be ff ff ff ff 48 89 44 24 08 <48>
89 20 4c 89 64 24 10 eb 1a 49 c7 44 24 08 02 00 00 00 c6 43
RIP  [<ffffffff846617af>] __mutex_lock_slowpath+0x6f/0x100
 RSP <ffff8801f36efb10>
CR2: 0000000000000000
---[ end trace 648d79474da94e34 ]---


Thanks, J=C3=B6rg
