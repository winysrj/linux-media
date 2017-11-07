Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:58248 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933271AbdKGNow (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 7 Nov 2017 08:44:52 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Matthias Schwarzott <zzam@gentoo.org>,
        Andrey Konovalov <andreyknvl@google.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Shuah Khan <shuah@kernel.org>,
        Max Kellermann <max.kellermann@gmail.com>,
        Colin Ian King <colin.king@canonical.com>,
        Satendra Singh Thakur <satendra.t@samsung.com>
Subject: [PATCH] dvb_frontend: don't use-after-free the frontend struct
Date: Tue,  7 Nov 2017 08:44:37 -0500
Message-Id: <b1cb7372fa822af6c06c8045963571d13ad6348b.1510062212.git.mchehab@s-opensource.com>
In-Reply-To: <CAAeHK+zqZCYoYJMFuAtgmHxoF6qeoxp+Ybs8PA-O0YJWEQ7VFw@mail.gmail.com>
References: <CAAeHK+zqZCYoYJMFuAtgmHxoF6qeoxp+Ybs8PA-O0YJWEQ7VFw@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

dvb_frontend_invoke_release() may free the frontend struct.
So, the free logic can't update it anymore after calling it.

That's OK, as __dvb_frontend_free() is called only when the
krefs are zeroed, so nobody is using it anymore.

That should fix the following KASAN error:

The KASAN report looks like this (running on kernel 3e0cc09a3a2c40ec1ffb6b4e12da86e98feccb11 (4.14-rc5+)):
==================================================================
BUG: KASAN: use-after-free in __dvb_frontend_free+0x113/0x120
Write of size 8 at addr ffff880067d45a00 by task kworker/0:1/24

CPU: 0 PID: 24 Comm: kworker/0:1 Not tainted 4.14.0-rc5-43687-g06ab8a23e0e6 #545
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
Workqueue: usb_hub_wq hub_event
Call Trace:
 __dump_stack lib/dump_stack.c:16
 dump_stack+0x292/0x395 lib/dump_stack.c:52
 print_address_description+0x78/0x280 mm/kasan/report.c:252
 kasan_report_error mm/kasan/report.c:351
 kasan_report+0x23d/0x350 mm/kasan/report.c:409
 __asan_report_store8_noabort+0x1c/0x20 mm/kasan/report.c:435
 __dvb_frontend_free+0x113/0x120 drivers/media/dvb-core/dvb_frontend.c:156
 dvb_frontend_put+0x59/0x70 drivers/media/dvb-core/dvb_frontend.c:176
 dvb_frontend_detach+0x120/0x150 drivers/media/dvb-core/dvb_frontend.c:2803
 dvb_usb_adapter_frontend_exit+0xd6/0x160 drivers/media/usb/dvb-usb/dvb-usb-dvb.c:340
 dvb_usb_adapter_exit drivers/media/usb/dvb-usb/dvb-usb-init.c:116
 dvb_usb_exit+0x9b/0x200 drivers/media/usb/dvb-usb/dvb-usb-init.c:132
 dvb_usb_device_exit+0xa5/0xf0 drivers/media/usb/dvb-usb/dvb-usb-init.c:295
 usb_unbind_interface+0x21c/0xa90 drivers/usb/core/driver.c:423
 __device_release_driver drivers/base/dd.c:861
 device_release_driver_internal+0x4f1/0x5c0 drivers/base/dd.c:893
 device_release_driver+0x1e/0x30 drivers/base/dd.c:918
 bus_remove_device+0x2f4/0x4b0 drivers/base/bus.c:565
 device_del+0x5c4/0xab0 drivers/base/core.c:1985
 usb_disable_device+0x1e9/0x680 drivers/usb/core/message.c:1170
 usb_disconnect+0x260/0x7a0 drivers/usb/core/hub.c:2124
 hub_port_connect drivers/usb/core/hub.c:4754
 hub_port_connect_change drivers/usb/core/hub.c:5009
 port_event drivers/usb/core/hub.c:5115
 hub_event+0x1318/0x3740 drivers/usb/core/hub.c:5195
 process_one_work+0xc73/0x1d90 kernel/workqueue.c:2119
 worker_thread+0x221/0x1850 kernel/workqueue.c:2253
 kthread+0x363/0x440 kernel/kthread.c:231
 ret_from_fork+0x2a/0x40 arch/x86/entry/entry_64.S:431

Allocated by task 24:
 save_stack_trace+0x1b/0x20 arch/x86/kernel/stacktrace.c:59
 save_stack+0x43/0xd0 mm/kasan/kasan.c:447
 set_track mm/kasan/kasan.c:459
 kasan_kmalloc+0xad/0xe0 mm/kasan/kasan.c:551
 kmem_cache_alloc_trace+0x11e/0x2d0 mm/slub.c:2772
 kmalloc ./include/linux/slab.h:493
 kzalloc ./include/linux/slab.h:666
 dtt200u_fe_attach+0x4c/0x110 drivers/media/usb/dvb-usb/dtt200u-fe.c:212
 dtt200u_frontend_attach+0x35/0x80 drivers/media/usb/dvb-usb/dtt200u.c:136
 dvb_usb_adapter_frontend_init+0x32b/0x660 drivers/media/usb/dvb-usb/dvb-usb-dvb.c:286
 dvb_usb_adapter_init drivers/media/usb/dvb-usb/dvb-usb-init.c:86
 dvb_usb_init drivers/media/usb/dvb-usb/dvb-usb-init.c:162
 dvb_usb_device_init+0xf73/0x17f0 drivers/media/usb/dvb-usb/dvb-usb-init.c:277
 dtt200u_usb_probe+0xa1/0xe0 drivers/media/usb/dvb-usb/dtt200u.c:155
 usb_probe_interface+0x35d/0x8e0 drivers/usb/core/driver.c:361
 really_probe drivers/base/dd.c:413
 driver_probe_device+0x610/0xa00 drivers/base/dd.c:557
 __device_attach_driver+0x230/0x290 drivers/base/dd.c:653
 bus_for_each_drv+0x161/0x210 drivers/base/bus.c:463
 __device_attach+0x26b/0x3c0 drivers/base/dd.c:710
 device_initial_probe+0x1f/0x30 drivers/base/dd.c:757
 bus_probe_device+0x1eb/0x290 drivers/base/bus.c:523
 device_add+0xd0b/0x1660 drivers/base/core.c:1835
 usb_set_configuration+0x104e/0x1870 drivers/usb/core/message.c:1932
 generic_probe+0x73/0xe0 drivers/usb/core/generic.c:174
 usb_probe_device+0xaf/0xe0 drivers/usb/core/driver.c:266
 really_probe drivers/base/dd.c:413
 driver_probe_device+0x610/0xa00 drivers/base/dd.c:557
 __device_attach_driver+0x230/0x290 drivers/base/dd.c:653
 bus_for_each_drv+0x161/0x210 drivers/base/bus.c:463
 __device_attach+0x26b/0x3c0 drivers/base/dd.c:710
 device_initial_probe+0x1f/0x30 drivers/base/dd.c:757
 bus_probe_device+0x1eb/0x290 drivers/base/bus.c:523
 device_add+0xd0b/0x1660 drivers/base/core.c:1835
 usb_new_device+0x7b8/0x1020 drivers/usb/core/hub.c:2457
 hub_port_connect drivers/usb/core/hub.c:4903
 hub_port_connect_change drivers/usb/core/hub.c:5009
 port_event drivers/usb/core/hub.c:5115
 hub_event+0x194d/0x3740 drivers/usb/core/hub.c:5195
 process_one_work+0xc73/0x1d90 kernel/workqueue.c:2119
 worker_thread+0x221/0x1850 kernel/workqueue.c:2253
 kthread+0x363/0x440 kernel/kthread.c:231
 ret_from_fork+0x2a/0x40 arch/x86/entry/entry_64.S:431

Freed by task 24:
 save_stack_trace+0x1b/0x20 arch/x86/kernel/stacktrace.c:59
 save_stack+0x43/0xd0 mm/kasan/kasan.c:447
 set_track mm/kasan/kasan.c:459
 kasan_slab_free+0x72/0xc0 mm/kasan/kasan.c:524
 slab_free_hook mm/slub.c:1390
 slab_free_freelist_hook mm/slub.c:1412
 slab_free mm/slub.c:2988
 kfree+0xf6/0x2f0 mm/slub.c:3919
 dtt200u_fe_release+0x3c/0x50 drivers/media/usb/dvb-usb/dtt200u-fe.c:202
 dvb_frontend_invoke_release.part.13+0x1c/0x30 drivers/media/dvb-core/dvb_frontend.c:2790
 dvb_frontend_invoke_release drivers/media/dvb-core/dvb_frontend.c:2789
 __dvb_frontend_free+0xad/0x120 drivers/media/dvb-core/dvb_frontend.c:153
 dvb_frontend_put+0x59/0x70 drivers/media/dvb-core/dvb_frontend.c:176
 dvb_frontend_detach+0x120/0x150 drivers/media/dvb-core/dvb_frontend.c:2803
 dvb_usb_adapter_frontend_exit+0xd6/0x160 drivers/media/usb/dvb-usb/dvb-usb-dvb.c:340
 dvb_usb_adapter_exit drivers/media/usb/dvb-usb/dvb-usb-init.c:116
 dvb_usb_exit+0x9b/0x200 drivers/media/usb/dvb-usb/dvb-usb-init.c:132
 dvb_usb_device_exit+0xa5/0xf0 drivers/media/usb/dvb-usb/dvb-usb-init.c:295
 usb_unbind_interface+0x21c/0xa90 drivers/usb/core/driver.c:423
 __device_release_driver drivers/base/dd.c:861
 device_release_driver_internal+0x4f1/0x5c0 drivers/base/dd.c:893
 device_release_driver+0x1e/0x30 drivers/base/dd.c:918
 bus_remove_device+0x2f4/0x4b0 drivers/base/bus.c:565
 device_del+0x5c4/0xab0 drivers/base/core.c:1985
 usb_disable_device+0x1e9/0x680 drivers/usb/core/message.c:1170
 usb_disconnect+0x260/0x7a0 drivers/usb/core/hub.c:2124
 hub_port_connect drivers/usb/core/hub.c:4754
 hub_port_connect_change drivers/usb/core/hub.c:5009
 port_event drivers/usb/core/hub.c:5115
 hub_event+0x1318/0x3740 drivers/usb/core/hub.c:5195
 process_one_work+0xc73/0x1d90 kernel/workqueue.c:2119
 worker_thread+0x221/0x1850 kernel/workqueue.c:2253
 kthread+0x363/0x440 kernel/kthread.c:231
 ret_from_fork+0x2a/0x40 arch/x86/entry/entry_64.S:431

The buggy address belongs to the object at ffff880067d45500
 which belongs to the cache kmalloc-2048 of size 2048
The buggy address is located 1280 bytes inside of
 2048-byte region [ffff880067d45500, ffff880067d45d00)
The buggy address belongs to the page:
page:ffffea00019f5000 count:1 mapcount:0 mapping:          (null)
index:0x0 compound_mapcount: 0
flags: 0x100000000008100(slab|head)
raw: 0100000000008100 0000000000000000 0000000000000000 00000001000f000f
raw: dead000000000100 dead000000000200 ffff88006c002d80 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff880067d45900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff880067d45980: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff880067d45a00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                   ^
 ffff880067d45a80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff880067d45b00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================

Fixes: ead666000a5f ("media: dvb_frontend: only use kref after initialized")

Reported-by: Andrey Konovalov <andreyknvl@google.com>
Suggested-by: Matthias Schwarzott <zzam@gentoo.org>
Tested-by: Andrey Konovalov <andreyknvl@google.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-core/dvb_frontend.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index d485d5f6cc88..3ad83359098b 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -150,11 +150,8 @@ static void __dvb_frontend_free(struct dvb_frontend *fe)
 
 	dvb_frontend_invoke_release(fe, fe->ops.release);
 
-	if (!fepriv)
-		return;
-
-	kfree(fepriv);
-	fe->frontend_priv = NULL;
+	if (fepriv)
+		kfree(fepriv);
 }
 
 static void dvb_frontend_free(struct kref *ref)
-- 
2.13.6
