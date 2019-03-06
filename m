Return-Path: <SRS0=KHCC=RJ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF419C43381
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 12:45:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A617720652
	for <linux-media@archiver.kernel.org>; Wed,  6 Mar 2019 12:45:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729371AbfCFMpa (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 6 Mar 2019 07:45:30 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:4652 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726317AbfCFMpa (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 6 Mar 2019 07:45:30 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 29121D80806560970C7E;
        Wed,  6 Mar 2019 20:45:27 +0800 (CST)
Received: from localhost (10.177.31.96) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.408.0; Wed, 6 Mar 2019
 20:45:17 +0800
From:   Yue Haibing <yuehaibing@huawei.com>
To:     <mchehab@kernel.org>, <hverkuil-cisco@xs4all.nl>,
        <sakari.ailus@linux.intel.com>
CC:     <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] media: cpia2: Fix use-after-free in cpia2_exit
Date:   Wed, 6 Mar 2019 20:45:08 +0800
Message-ID: <20190306124508.18920-1-yuehaibing@huawei.com>
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
Read of size 8 at addr ffff8881f59a6b70 by task syz-executor.0/8363

CPU: 0 PID: 8363 Comm: syz-executor.0 Not tainted 5.0.0-rc8+ #3
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1ubuntu1 04/01/2014
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0xfa/0x1ce lib/dump_stack.c:113
 print_address_description+0x65/0x270 mm/kasan/report.c:187
 kasan_report+0x149/0x18d mm/kasan/report.c:317
 sysfs_remove_file_ns+0x5f/0x70 fs/sysfs/file.c:468
 sysfs_remove_file include/linux/sysfs.h:519 [inline]
 driver_remove_file+0x40/0x50 drivers/base/driver.c:122
 usb_remove_newid_files drivers/usb/core/driver.c:212 [inline]
 usb_deregister+0x12a/0x3b0 drivers/usb/core/driver.c:1005
 cpia2_exit+0xa/0x16 [cpia2]
 __do_sys_delete_module kernel/module.c:1018 [inline]
 __se_sys_delete_module kernel/module.c:961 [inline]
 __x64_sys_delete_module+0x3dc/0x5e0 kernel/module.c:961
 do_syscall_64+0x147/0x600 arch/x86/entry/common.c:290
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x462e99
Code: f7 d8 64 89 02 b8 ff ff ff ff c3 66 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f86f3754c58 EFLAGS: 00000246 ORIG_RAX: 00000000000000b0
RAX: ffffffffffffffda RBX: 000000000073bf00 RCX: 0000000000462e99
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000020000300
RBP: 0000000000000002 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f86f37556bc
R13: 00000000004bcca9 R14: 00000000006f6b48 R15: 00000000ffffffff

Allocated by task 8363:
 set_track mm/kasan/common.c:85 [inline]
 __kasan_kmalloc.constprop.3+0xa0/0xd0 mm/kasan/common.c:495
 kmalloc include/linux/slab.h:545 [inline]
 kzalloc include/linux/slab.h:740 [inline]
 bus_add_driver+0xc0/0x610 drivers/base/bus.c:651
 driver_register+0x1bb/0x3f0 drivers/base/driver.c:170
 usb_register_driver+0x267/0x520 drivers/usb/core/driver.c:965
 0xffffffffc1b4817c
 do_one_initcall+0xfa/0x5ca init/main.c:887
 do_init_module+0x204/0x5f6 kernel/module.c:3460
 load_module+0x66b2/0x8570 kernel/module.c:3808
 __do_sys_finit_module+0x238/0x2a0 kernel/module.c:3902
 do_syscall_64+0x147/0x600 arch/x86/entry/common.c:290
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 8363:
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
 usb_register_driver+0x341/0x520 drivers/usb/core/driver.c:980
 0xffffffffc1b4817c
 do_one_initcall+0xfa/0x5ca init/main.c:887
 do_init_module+0x204/0x5f6 kernel/module.c:3460
 load_module+0x66b2/0x8570 kernel/module.c:3808
 __do_sys_finit_module+0x238/0x2a0 kernel/module.c:3902
 do_syscall_64+0x147/0x600 arch/x86/entry/common.c:290
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff8881f59a6b40
 which belongs to the cache kmalloc-256 of size 256
The buggy address is located 48 bytes inside of
 256-byte region [ffff8881f59a6b40, ffff8881f59a6c40)
The buggy address belongs to the page:
page:ffffea0007d66980 count:1 mapcount:0 mapping:ffff8881f6c02e00 index:0x0
flags: 0x2fffc0000000200(slab)
raw: 02fffc0000000200 dead000000000100 dead000000000200 ffff8881f6c02e00
raw: 0000000000000000 00000000800c000c 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8881f59a6a00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff8881f59a6a80: 00 00 00 00 00 00 00 00 00 00 fc fc fc fc fc fc
>ffff8881f59a6b00: fc fc fc fc fc fc fc fc fb fb fb fb fb fb fb fb
                                                             ^
 ffff8881f59a6b80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8881f59a6c00: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc

cpia2_init does not check return value of cpia2_init, if it failed
in usb_register_driver, there is already cleanup using driver_unregister.
No need call cpia2_usb_cleanup on module exit.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/media/usb/cpia2/cpia2_v4l.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/usb/cpia2/cpia2_v4l.c b/drivers/media/usb/cpia2/cpia2_v4l.c
index 95c0bd4..45caf78 100644
--- a/drivers/media/usb/cpia2/cpia2_v4l.c
+++ b/drivers/media/usb/cpia2/cpia2_v4l.c
@@ -1240,8 +1240,7 @@ static int __init cpia2_init(void)
 	LOG("%s v%s\n",
 	    ABOUT, CPIA_VERSION);
 	check_parameters();
-	cpia2_usb_init();
-	return 0;
+	return cpia2_usb_init();
 }
 
 
-- 
2.7.0


