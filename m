Return-Path: <SRS0=h5dj=RI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 802EBC4360F
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 05:41:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 57F112082C
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 05:41:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbfCEFlL (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Mar 2019 00:41:11 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:4212 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725782AbfCEFlL (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 5 Mar 2019 00:41:11 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id A45019DE3A9E89E7109F;
        Tue,  5 Mar 2019 13:41:08 +0800 (CST)
Received: from localhost (10.177.31.96) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.408.0; Tue, 5 Mar 2019
 13:40:59 +0800
From:   Yue Haibing <yuehaibing@huawei.com>
To:     <sean@mess.org>, <mchehab@kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] media: serial_ir: Fix use-after-free in serial_ir_init_module
Date:   Tue, 5 Mar 2019 13:40:26 +0800
Message-ID: <20190305054026.27744-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.31.96]
X-CFilter-Loop: Reflected
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

Syzkaller report this:

BUG: KASAN: use-after-free in sysfs_remove_file_ns+0x5f/0x70 fs/sysfs/file.c:468
Read of size 8 at addr ffff8881dc7ae030 by task syz-executor.0/6249

CPU: 1 PID: 6249 Comm: syz-executor.0 Not tainted 5.0.0-rc8+ #3
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1ubuntu1 04/01/2014
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0xfa/0x1ce lib/dump_stack.c:113
 print_address_description+0x65/0x270 mm/kasan/report.c:187
 kasan_report+0x149/0x18d mm/kasan/report.c:317
 ? 0xffffffffc1728000
 sysfs_remove_file_ns+0x5f/0x70 fs/sysfs/file.c:468
 sysfs_remove_file include/linux/sysfs.h:519 [inline]
 driver_remove_file+0x40/0x50 drivers/base/driver.c:122
 remove_bind_files drivers/base/bus.c:585 [inline]
 bus_remove_driver+0x186/0x220 drivers/base/bus.c:725
 driver_unregister+0x6c/0xa0 drivers/base/driver.c:197
 serial_ir_init_module+0x169/0x1000 [serial_ir]
 do_one_initcall+0xfa/0x5ca init/main.c:887
 do_init_module+0x204/0x5f6 kernel/module.c:3460
 load_module+0x66b2/0x8570 kernel/module.c:3808
 __do_sys_finit_module+0x238/0x2a0 kernel/module.c:3902
 do_syscall_64+0x147/0x600 arch/x86/entry/common.c:290
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x462e99
Code: f7 d8 64 89 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f9450132c58 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
RAX: ffffffffffffffda RBX: 000000000073bf00 RCX: 0000000000462e99
RDX: 0000000000000000 RSI: 0000000020000100 RDI: 0000000000000003
RBP: 00007f9450132c70 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f94501336bc
R13: 00000000004bcefa R14: 00000000006f6fb0 R15: 0000000000000004

Allocated by task 6249:
 set_track mm/kasan/common.c:85 [inline]
 __kasan_kmalloc.constprop.3+0xa0/0xd0 mm/kasan/common.c:495
 kmalloc include/linux/slab.h:545 [inline]
 kzalloc include/linux/slab.h:740 [inline]
 bus_add_driver+0xc0/0x610 drivers/base/bus.c:651
 driver_register+0x1bb/0x3f0 drivers/base/driver.c:170
 serial_ir_init_module+0xe8/0x1000 [serial_ir]
 do_one_initcall+0xfa/0x5ca init/main.c:887
 do_init_module+0x204/0x5f6 kernel/module.c:3460
 load_module+0x66b2/0x8570 kernel/module.c:3808
 __do_sys_finit_module+0x238/0x2a0 kernel/module.c:3902
 do_syscall_64+0x147/0x600 arch/x86/entry/common.c:290
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 6249:
 set_track mm/kasan/common.c:85 [inline]
 __kasan_slab_free+0x130/0x180 mm/kasan/common.c:457
 slab_free_hook mm/slub.c:1430 [inline]
 slab_free_freelist_hook mm/slub.c:1457 [inline]
 slab_free mm/slub.c:3005 [inline]
 kfree+0xe1/0x270 mm/slub.c:3957
 kobject_cleanup lib/kobject.c:662 [inline]
 kobject_release lib/kobject.c:691 [inline]
 kref_put include/linux/kref.h:67 [inline]
 kobject_put+0x146/0x240 lib/kobject.c:708
 bus_remove_driver+0x10e/0x220 drivers/base/bus.c:732
 driver_unregister+0x6c/0xa0 drivers/base/driver.c:197
 serial_ir_init_module+0x14c/0x1000 [serial_ir]
 do_one_initcall+0xfa/0x5ca init/main.c:887
 do_init_module+0x204/0x5f6 kernel/module.c:3460
 load_module+0x66b2/0x8570 kernel/module.c:3808
 __do_sys_finit_module+0x238/0x2a0 kernel/module.c:3902
 do_syscall_64+0x147/0x600 arch/x86/entry/common.c:290
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff8881dc7ae000
 which belongs to the cache kmalloc-256 of size 256
The buggy address is located 48 bytes inside of
 256-byte region [ffff8881dc7ae000, ffff8881dc7ae100)
The buggy address belongs to the page:
page:ffffea000771eb80 count:1 mapcount:0 mapping:ffff8881f6c02e00 index:0x0
flags: 0x2fffc0000000200(slab)
raw: 02fffc0000000200 ffffea0007d14800 0000000400000002 ffff8881f6c02e00
raw: 0000000000000000 00000000800c000c 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8881dc7adf00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff8881dc7adf80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff8881dc7ae000: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                     ^
 ffff8881dc7ae080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8881dc7ae100: fc fc fc fc fc fc fc fc 00 00 00 00 00 00 00 00

There are already cleanup handlings in serial_ir_init error path,
no need to call serial_ir_exit do it again in serial_ir_init_module,
otherwise will trigger a use-after-free issue.

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: fa5dc29c1fcc ("[media] lirc_serial: move out of staging and rename to serial_ir")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/media/rc/serial_ir.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/media/rc/serial_ir.c b/drivers/media/rc/serial_ir.c
index ffe2c67..3998ba2 100644
--- a/drivers/media/rc/serial_ir.c
+++ b/drivers/media/rc/serial_ir.c
@@ -773,8 +773,6 @@ static void serial_ir_exit(void)
 
 static int __init serial_ir_init_module(void)
 {
-	int result;
-
 	switch (type) {
 	case IR_HOMEBREW:
 	case IR_IRDEO:
@@ -802,12 +800,7 @@ static int __init serial_ir_init_module(void)
 	if (sense != -1)
 		sense = !!sense;
 
-	result = serial_ir_init();
-	if (!result)
-		return 0;
-
-	serial_ir_exit();
-	return result;
+	return serial_ir_init();
 }
 
 static void __exit serial_ir_exit_module(void)
-- 
2.7.0


