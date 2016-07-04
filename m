Return-path: <linux-media-owner@vger.kernel.org>
Received: from swift.blarg.de ([78.47.110.205]:33199 "EHLO swift.blarg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753198AbcGDMIs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jul 2016 08:08:48 -0400
Subject: [PATCH 1/2] drivers/media/dvb-core/en50221: use kref to manage
 struct dvb_ca_private
From: Max Kellermann <max@duempel.org>
To: linux-media@vger.kernel.org, shuahkh@osg.samsung.com,
	mchehab@osg.samsung.com
Cc: linux-kernel@vger.kernel.org
Date: Mon, 04 Jul 2016 14:08:45 +0200
Message-ID: <146763412568.10008.7316707423893692579.stgit@woodpecker.blarg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Don't free the object until the file handle has been closed.  Fixes
use-after-free bug which occurs when I disconnect my DVB-S received
while VDR is running.

This is a crash dump of such a use-after-free:

    general protection fault: 0000 [#1] SMP
    CPU: 0 PID: 2541 Comm: CI adapter on d Not tainted 4.7.0-rc1-hosting+ #49
    Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
    task: ffff880027d7ce00 ti: ffff88003d8f8000 task.ti: ffff88003d8f8000
    RIP: 0010:[<ffffffff812f3d1f>]  [<ffffffff812f3d1f>] dvb_ca_en50221_io_read_condition.isra.7+0x6f/0x150
    RSP: 0018:ffff88003d8fba98  EFLAGS: 00010206
    RAX: 0000000059534255 RBX: 000000753d470f90 RCX: ffff88003c74d181
    RDX: 00000001bea04ba9 RSI: ffff88003d8fbaf4 RDI: 3a3030a56d763fc0
    RBP: ffff88003d8fbae0 R08: ffff88003c74d180 R09: 0000000000000000
    R10: 0000000000000001 R11: 0000000000000000 R12: ffff88003c480e00
    R13: 00000000ffffffff R14: 0000000059534255 R15: 0000000000000000
    FS:  00007fb4209b4700(0000) GS:ffff88003fc00000(0000) knlGS:0000000000000000
    CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
    CR2: 00007f06445f4078 CR3: 000000003c55b000 CR4: 00000000000006b0
    Stack:
     ffff88003d8fbaf4 000000003c2170c0 0000000000004000 0000000000000000
     ffff88003c480e00 ffff88003d8fbc80 ffff88003c74d180 ffff88003d8fbb8c
     0000000000000000 ffff88003d8fbb10 ffffffff812f3e37 ffff88003d8fbb00
    Call Trace:
     [<ffffffff812f3e37>] dvb_ca_en50221_io_poll+0x37/0xa0
     [<ffffffff8113109b>] do_sys_poll+0x2db/0x520

This is a backtrace of the kernel attempting to lock a freed mutex:

    #0  0xffffffff81083d40 in rep_nop () at ./arch/x86/include/asm/processor.h:569
    #1  cpu_relax () at ./arch/x86/include/asm/processor.h:574
    #2  virt_spin_lock (lock=<optimized out>) at ./arch/x86/include/asm/qspinlock.h:57
    #3  native_queued_spin_lock_slowpath (lock=0xffff88003c480e90, val=761492029) at kernel/locking/qspinlock.c:304
    #4  0xffffffff810d1a06 in pv_queued_spin_lock_slowpath (val=<optimized out>, lock=<optimized out>) at ./arch/x86/include/asm/paravirt.h:669
    #5  queued_spin_lock_slowpath (val=<optimized out>, lock=<optimized out>) at ./arch/x86/include/asm/qspinlock.h:28
    #6  queued_spin_lock (lock=<optimized out>) at include/asm-generic/qspinlock.h:107
    #7  __mutex_lock_common (use_ww_ctx=<optimized out>, ww_ctx=<optimized out>, ip=<optimized out>, nest_lock=<optimized out>, subclass=<optimized out>,
        state=<optimized out>, lock=<optimized out>) at kernel/locking/mutex.c:526
    #8  mutex_lock_interruptible_nested (lock=0xffff88003c480e88, subclass=<optimized out>) at kernel/locking/mutex.c:647
    #9  0xffffffff812f49fe in dvb_ca_en50221_io_do_ioctl (file=<optimized out>, cmd=761492029, parg=0x1 <irq_stack_union+1>)
        at drivers/media/dvb-core/dvb_ca_en50221.c:1210
    #10 0xffffffff812ee660 in dvb_usercopy (file=<optimized out>, cmd=761492029, arg=<optimized out>, func=<optimized out>) at drivers/media/dvb-core/dvbdev.c:883
    #11 0xffffffff812f3410 in dvb_ca_en50221_io_ioctl (file=<optimized out>, cmd=<optimized out>, arg=<optimized out>) at drivers/media/dvb-core/dvb_ca_en50221.c:1284
    #12 0xffffffff8112eddd in vfs_ioctl (arg=<optimized out>, cmd=<optimized out>, filp=<optimized out>) at fs/ioctl.c:43
    #13 do_vfs_ioctl (filp=0xffff88003c480e90, fd=<optimized out>, cmd=<optimized out>, arg=<optimized out>) at fs/ioctl.c:674
    #14 0xffffffff8112f30c in SYSC_ioctl (arg=<optimized out>, cmd=<optimized out>, fd=<optimized out>) at fs/ioctl.c:689
    #15 SyS_ioctl (fd=6, cmd=2148298626, arg=140734533693696) at fs/ioctl.c:680
    #16 0xffffffff8103feb2 in entry_SYSCALL_64 () at arch/x86/entry/entry_64.S:207

Signed-off-by: Max Kellermann <max@duempel.org>
---
 drivers/media/dvb-core/dvb_ca_en50221.c |   24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-core/dvb_ca_en50221.c b/drivers/media/dvb-core/dvb_ca_en50221.c
index b1e3a26..b5b5b19 100644
--- a/drivers/media/dvb-core/dvb_ca_en50221.c
+++ b/drivers/media/dvb-core/dvb_ca_en50221.c
@@ -123,6 +123,7 @@ struct dvb_ca_slot {
 
 /* Private CA-interface information */
 struct dvb_ca_private {
+	struct kref refcount;
 
 	/* pointer back to the public data structure */
 	struct dvb_ca_en50221 *pub;
@@ -173,6 +174,22 @@ static void dvb_ca_private_free(struct dvb_ca_private *ca)
 	kfree(ca);
 }
 
+static void dvb_ca_private_release(struct kref *ref)
+{
+	struct dvb_ca_private *ca = container_of(ref, struct dvb_ca_private, refcount);
+	dvb_ca_private_free(ca);
+}
+
+static void dvb_ca_private_get(struct dvb_ca_private *ca)
+{
+	kref_get(&ca->refcount);
+}
+
+static void dvb_ca_private_put(struct dvb_ca_private *ca)
+{
+	kref_put(&ca->refcount, dvb_ca_private_release);
+}
+
 static void dvb_ca_en50221_thread_wakeup(struct dvb_ca_private *ca);
 static int dvb_ca_en50221_read_data(struct dvb_ca_private *ca, int slot, u8 * ebuf, int ecount);
 static int dvb_ca_en50221_write_data(struct dvb_ca_private *ca, int slot, u8 * ebuf, int ecount);
@@ -1570,6 +1587,8 @@ static int dvb_ca_en50221_io_open(struct inode *inode, struct file *file)
 	dvb_ca_en50221_thread_update_delay(ca);
 	dvb_ca_en50221_thread_wakeup(ca);
 
+	dvb_ca_private_get(ca);
+
 	return 0;
 }
 
@@ -1598,6 +1617,8 @@ static int dvb_ca_en50221_io_release(struct inode *inode, struct file *file)
 
 	module_put(ca->pub->owner);
 
+	dvb_ca_private_put(ca);
+
 	return err;
 }
 
@@ -1693,6 +1714,7 @@ int dvb_ca_en50221_init(struct dvb_adapter *dvb_adapter,
 		ret = -ENOMEM;
 		goto exit;
 	}
+	kref_init(&ca->refcount);
 	ca->pub = pubca;
 	ca->flags = flags;
 	ca->slot_count = slot_count;
@@ -1772,6 +1794,6 @@ void dvb_ca_en50221_release(struct dvb_ca_en50221 *pubca)
 	for (i = 0; i < ca->slot_count; i++) {
 		dvb_ca_en50221_slot_shutdown(ca, i);
 	}
-	dvb_ca_private_free(ca);
+	dvb_ca_private_put(ca);
 	pubca->private = NULL;
 }

