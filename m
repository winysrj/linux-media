Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f170.google.com ([74.125.82.170]:46767 "EHLO
        mail-ot0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750819AbdKCOo1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 3 Nov 2017 10:44:27 -0400
Received: by mail-ot0-f170.google.com with SMTP id h37so2630818otd.3
        for <linux-media@vger.kernel.org>; Fri, 03 Nov 2017 07:44:27 -0700 (PDT)
MIME-Version: 1.0
From: Andrey Konovalov <andreyknvl@google.com>
Date: Fri, 3 Nov 2017 15:44:26 +0100
Message-ID: <CAAeHK+x4oqdDAerf7xBcd1YdQwuNJApJ6ZkLT9z+-e9Ear=AGQ@mail.gmail.com>
Subject: usb/media/dw2102: null-ptr-deref in dvb_usb_adapter_frontend_init/tt_s2_4600_frontend_attach
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Anton Vasilyev <vasilyev@ispras.ru>,
        Bhumika Goyal <bhumirks@gmail.com>, Sean Young <sean@mess.org>,
        Alyssa Milburn <amilburn@zall.org>,
        Jonathan McDowell <noodles@earth.li>,
        linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Cc: Dmitry Vyukov <dvyukov@google.com>,
        Kostya Serebryany <kcc@google.com>,
        syzkaller <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

I've got the following report while fuzzing the kernel with syzkaller.

On commit 3a99df9a3d14cd866b5516f8cba515a3bfd554ab (4.14-rc7+).

The report is a little confusing, as the top stack frame is not
actually present. As far as my debugging showed, the NULL pointer
that's being executed actually corresponds to
m88ds3103_pdata.get_dvb_frontend in tt_s2_4600_frontend_attach().

dw2102: su3000_identify_state
dvb-usb: found a 'TeVii S482 (tuner 1)' in warm state.
dw2102: su3000_power_ctrl: 1, initialized 0
dvb-usb: bulk message failed: -22 (2/-30720)
dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
dvbdev: DVB: registering new adapter (TeVii S482 (tuner 1))
usb 1-1: media controller created
dvb-usb: bulk message failed: -22 (6/-30720)
dw2102: i2c transfer failed.
dvb-usb: bulk message failed: -22 (6/-30720)
dw2102: i2c transfer failed.
dvb-usb: bulk message failed: -22 (6/-30720)
dw2102: i2c transfer failed.
dvb-usb: bulk message failed: -22 (6/-30720)
dw2102: i2c transfer failed.
dvb-usb: bulk message failed: -22 (6/-30720)
dw2102: i2c transfer failed.
dvb-usb: bulk message failed: -22 (6/-30720)
dw2102: i2c transfer failed.
dvb-usb: MAC address: 02:02:02:02:02:02
dvbdev: dvb_create_media_entity: media entity 'dvb-demux' registered.
dvb-usb: bulk message failed: -22 (3/-30720)
dw2102: command 0x0e transfer failed.
dvb-usb: bulk message failed: -22 (3/-1)
dw2102: command 0x0e transfer failed.
dvb-usb: bulk message failed: -22 (3/-30720)
dw2102: command 0x0e transfer failed.
dvb-usb: bulk message failed: -22 (3/-1)
dw2102: command 0x0e transfer failed.
dvb-usb: bulk message failed: -22 (1/-1)
dw2102: command 0x51 transfer failed.
dvb-usb: bulk message failed: -22 (5/-30720)
dw2102: i2c transfer failed.
BUG: unable to handle kernel NULL pointer dereference at           (null)
IP:           (null)
PGD 6a9fb067 P4D 6a9fb067 PUD 684a4067 PMD 0
Oops: 0010 [#1] PREEMPT SMP KASAN
Modules linked in:
CPU: 1 PID: 40 Comm: kworker/1:1 Not tainted 4.14.0-rc7-44290-gf28444df2601 #50
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
Workqueue: usb_hub_wq hub_event
task: ffff88006bfe9700 task.stack: ffff88006b890000
RIP: 0010:          (null)
RSP: 0018:ffff88006b8973d0 EFLAGS: 00010293
RAX: ffff88006bfe9700 RBX: ffff880069f77780 RCX: ffffffff840c0153
RDX: 0000000000000000 RSI: ffffffff840c0161 RDI: ffff880060bc1980
RBP: ffff88006b8974b8 R08: ffff88006bfe9700 R09: 0000000000000005
R10: ffff88006bfe9700 R11: a23aacbae336f3e6 R12: ffff880060bc1980
R13: ffff8800629e5f00 R14: 00000000ffffffea R15: ffff8800629e56d8
FS:  0000000000000000(0000) GS:ffff88006cb00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000006349a000 CR4: 00000000000006e0
Call Trace:
 dvb_usb_adapter_frontend_init+0x358/0x4b0
drivers/media/usb/dvb-usb/dvb-usb-dvb.c:286
 dvb_usb_adapter_init drivers/media/usb/dvb-usb/dvb-usb-init.c:86
 dvb_usb_init drivers/media/usb/dvb-usb/dvb-usb-init.c:162
 dvb_usb_device_init.cold.7+0x971/0x1029
drivers/media/usb/dvb-usb/dvb-usb-init.c:277
 dw2102_probe+0xa67/0xc50 drivers/media/usb/dvb-usb/dw2102.c:2406
 usb_probe_interface+0x324/0x940 drivers/usb/core/driver.c:361
 really_probe drivers/base/dd.c:413
 driver_probe_device+0x522/0x740 drivers/base/dd.c:557
 __device_attach_driver+0x25d/0x2d0 drivers/base/dd.c:653
 bus_for_each_drv+0xff/0x160 drivers/base/bus.c:463
 __device_attach+0x1a8/0x2a0 drivers/base/dd.c:710
 device_initial_probe+0x1f/0x30 drivers/base/dd.c:757
 bus_probe_device+0x1fc/0x2a0 drivers/base/bus.c:523
 device_add+0xc27/0x15a0 drivers/base/core.c:1835
 usb_set_configuration+0xd4f/0x17a0 drivers/usb/core/message.c:1932
 generic_probe+0xbb/0x120 drivers/usb/core/generic.c:174
 usb_probe_device+0xab/0x100 drivers/usb/core/driver.c:266
 really_probe drivers/base/dd.c:413
 driver_probe_device+0x522/0x740 drivers/base/dd.c:557
 __device_attach_driver+0x25d/0x2d0 drivers/base/dd.c:653
 bus_for_each_drv+0xff/0x160 drivers/base/bus.c:463
 __device_attach+0x1a8/0x2a0 drivers/base/dd.c:710
 device_initial_probe+0x1f/0x30 drivers/base/dd.c:757
 bus_probe_device+0x1fc/0x2a0 drivers/base/bus.c:523
 device_add+0xc27/0x15a0 drivers/base/core.c:1835
 usb_new_device+0x7fa/0x1090 drivers/usb/core/hub.c:2538
 hub_port_connect drivers/usb/core/hub.c:4987
 hub_port_connect_change drivers/usb/core/hub.c:5093
 port_event drivers/usb/core/hub.c:5199
 hub_event_impl+0x17b8/0x3440 drivers/usb/core/hub.c:5311
 hub_event+0x38/0x50 drivers/usb/core/hub.c:5209
 process_one_work+0x925/0x15d0 kernel/workqueue.c:2113
 worker_thread+0xef/0x10d0 kernel/workqueue.c:2247
 kthread+0x346/0x410 kernel/kthread.c:231
 ret_from_fork+0x2a/0x40 arch/x86/entry/entry_64.S:431
Code:  Bad RIP value.
RIP:           (null) RSP: ffff88006b8973d0
CR2: 0000000000000000
---[ end trace ab991a6d52472450 ]---
