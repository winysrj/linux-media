Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:35450 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932726AbbHJV0L (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Aug 2015 17:26:11 -0400
From: poma <pomidorabelisima@gmail.com>
Subject: WARNING: CPU: 1 PID: 813 at kernel/module.c:291
 module_assert_mutex_or_preempt+0x49/0x90()
To: linux-media <linux-media@vger.kernel.org>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Message-ID: <55C916F0.8010303@gmail.com>
Date: Mon, 10 Aug 2015 23:26:08 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


------------[ cut here ]------------
WARNING: CPU: 1 PID: 813 at kernel/module.c:291 module_assert_mutex_or_preempt+0x49/0x90()
Modules linked in: mxl5007t af9013 ... dvb_usb_af9015(+) ... dvb_usb_v2 dvb_core rc_core ...
CPU: 1 PID: 813 Comm: systemd-udevd Not tainted 4.2.0-0.rc6.git0.1.fc24.x86_64+debug #1
...
Call Trace:
 [<ffffffff81868d8e>] dump_stack+0x4c/0x65
 [<ffffffff810ab406>] warn_slowpath_common+0x86/0xc0
 [<ffffffffa057d0b0>] ? af9013_read_ucblocks+0x20/0x20 [af9013]
 [<ffffffffa057d0b0>] ? af9013_read_ucblocks+0x20/0x20 [af9013]
 [<ffffffff810ab53a>] warn_slowpath_null+0x1a/0x20
 [<ffffffff81150529>] module_assert_mutex_or_preempt+0x49/0x90
 [<ffffffff81150822>] __module_address+0x32/0x150
 [<ffffffffa057d0b0>] ? af9013_read_ucblocks+0x20/0x20 [af9013]
 [<ffffffffa057d0b0>] ? af9013_read_ucblocks+0x20/0x20 [af9013]
 [<ffffffff81150956>] __module_text_address+0x16/0x70
 [<ffffffffa057d0b0>] ? af9013_read_ucblocks+0x20/0x20 [af9013]
 [<ffffffffa057d0b0>] ? af9013_read_ucblocks+0x20/0x20 [af9013]
 [<ffffffff81150f19>] symbol_put_addr+0x29/0x40
 [<ffffffffa04b77ad>] dvb_frontend_detach+0x7d/0x90 [dvb_core]
 [<ffffffffa04cdfd5>] dvb_usbv2_probe+0xc85/0x11a0 [dvb_usb_v2]
 [<ffffffffa05607c4>] af9015_probe+0x84/0xf0 [dvb_usb_af9015]
 [<ffffffff8161c03b>] usb_probe_interface+0x1bb/0x2e0
 [<ffffffff81579f26>] driver_probe_device+0x1f6/0x450
 [<ffffffff8157a214>] __driver_attach+0x94/0xa0
 [<ffffffff8157a180>] ? driver_probe_device+0x450/0x450
 [<ffffffff815778f3>] bus_for_each_dev+0x73/0xc0
 [<ffffffff815796fe>] driver_attach+0x1e/0x20
 [<ffffffff8157922e>] bus_add_driver+0x1ee/0x280
 [<ffffffff8157b0a0>] driver_register+0x60/0xe0
 [<ffffffff8161a87d>] usb_register_driver+0xad/0x160
 [<ffffffffa0567000>] ? 0xffffffffa0567000
 [<ffffffffa056701e>] af9015_usb_driver_init+0x1e/0x1000 [dvb_usb_af9015]
 [<ffffffff81002123>] do_one_initcall+0xb3/0x200
 [<ffffffff8124ac65>] ? kmem_cache_alloc_trace+0x355/0x380
 [<ffffffff81867c37>] ? do_init_module+0x28/0x1e9
 [<ffffffff81867c6f>] do_init_module+0x60/0x1e9
 [<ffffffff81154167>] load_module+0x21f7/0x28d0
 [<ffffffff8114f600>] ? m_show+0x1b0/0x1b0
 [<ffffffff81026d79>] ? sched_clock+0x9/0x10
 [<ffffffff810e6ddc>] ? local_clock+0x1c/0x20
 [<ffffffff811549b8>] SyS_init_module+0x178/0x1c0
 [<ffffffff8187282e>] entry_SYSCALL_64_fastpath+0x12/0x76
---[ end trace 31a9dd90d4f559f5 ]---


Ref.
https://bugzilla.redhat.com/show_bug.cgi?id=1252167
https://bugzilla.kernel.org/show_bug.cgi?id=102631

