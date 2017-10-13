Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:54784 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753254AbdJMXNo (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 13 Oct 2017 19:13:44 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@kernel.org, hansverk@cisco.com, kgene@kernel.org,
        krzk@kernel.org, s.nawrocki@samsung.com, shailendra.v@samsung.com,
        shuah@kernel.org, Julia.Lawall@lip6.fr, kyungmin.park@samsung.com,
        kamil@wypas.org, jtp.park@samsung.com, a.hajda@samsung.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 1/2] media: exynos-gsc: fix lockdep warning
Date: Fri, 13 Oct 2017 17:13:36 -0600
Message-Id: <f1de8d306e45127bdcb53b4ee53a7d5dc3c5c95b.1507935819.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1507935819.git.shuahkh@osg.samsung.com>
References: <cover.1507935819.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1507935819.git.shuahkh@osg.samsung.com>
References: <cover.1507935819.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The driver mmap functions shouldn't take lock when calling vb2_mmap().
Fix it to not take the lock. The following lockdep warning is fixed
with this change.

[ 1990.972058] ======================================================
[ 1990.978172] WARNING: possible circular locking dependency detected
[ 1990.984327] 4.14.0-rc2-00002-gfab205f-dirty #4 Not tainted
[ 1990.989783] ------------------------------------------------------
[ 1990.995937] qtdemux0:sink/2765 is trying to acquire lock:
[ 1991.001309]  (&gsc->lock){+.+.}, at: [<bf1729f0>] gsc_m2m_mmap+0x24/0x5c [exynos_gsc]
[ 1991.009108]
               but task is already holding lock:
[ 1991.014913]  (&mm->mmap_sem){++++}, at: [<c01df2e4>] vm_mmap_pgoff+0x44/0xb8
[ 1991.021932]
               which lock already depends on the new lock.

[ 1991.030078]
               the existing dependency chain (in reverse order) is:
[ 1991.037530]
               -> #1 (&mm->mmap_sem){++++}:
[ 1991.042913]        __might_fault+0x80/0xb0
[ 1991.047096]        video_usercopy+0x1cc/0x510 [videodev]
[ 1991.052297]        v4l2_ioctl+0xa4/0xdc [videodev]
[ 1991.057036]        do_vfs_ioctl+0xa0/0xa18
[ 1991.061102]        SyS_ioctl+0x34/0x5c
[ 1991.064834]        ret_fast_syscall+0x0/0x28
[ 1991.069072]
               -> #0 (&gsc->lock){+.+.}:
[ 1991.074193]        lock_acquire+0x6c/0x88
[ 1991.078179]        __mutex_lock+0x68/0xa34
[ 1991.082247]        mutex_lock_interruptible_nested+0x1c/0x24
[ 1991.087888]        gsc_m2m_mmap+0x24/0x5c [exynos_gsc]
[ 1991.093029]        v4l2_mmap+0x54/0x88 [videodev]
[ 1991.097673]        mmap_region+0x3a8/0x638
[ 1991.101743]        do_mmap+0x330/0x3a4
[ 1991.105470]        vm_mmap_pgoff+0x90/0xb8
[ 1991.109542]        SyS_mmap_pgoff+0x90/0xc0
[ 1991.113702]        ret_fast_syscall+0x0/0x28
[ 1991.117945]
               other info that might help us debug this:

[ 1991.125918]  Possible unsafe locking scenario:

[ 1991.131810]        CPU0                    CPU1
[ 1991.136315]        ----                    ----
[ 1991.140821]   lock(&mm->mmap_sem);
[ 1991.144201]                                lock(&gsc->lock);
[ 1991.149833]                                lock(&mm->mmap_sem);
[ 1991.155725]   lock(&gsc->lock);
[ 1991.158845]
                *** DEADLOCK ***

[ 1991.164740] 1 lock held by qtdemux0:sink/2765:
[ 1991.169157]  #0:  (&mm->mmap_sem){++++}, at: [<c01df2e4>] vm_mmap_pgoff+0x44/0xb8
[ 1991.176609]
               stack backtrace:
[ 1991.180946] CPU: 2 PID: 2765 Comm: qtdemux0:sink Not tainted 4.14.0-rc2-00002-gfab205f-dirty #4
[ 1991.189608] Hardware name: SAMSUNG EXYNOS (Flattened Device Tree)
[ 1991.195686] [<c01102c8>] (unwind_backtrace) from [<c010cabc>] (show_stack+0x10/0x14)
[ 1991.203393] [<c010cabc>] (show_stack) from [<c08543a4>] (dump_stack+0x98/0xc4)
[ 1991.210586] [<c08543a4>] (dump_stack) from [<c016b2fc>] (print_circular_bug+0x254/0x410)
[ 1991.218644] [<c016b2fc>] (print_circular_bug) from [<c016c580>] (check_prev_add+0x468/0x938)
[ 1991.227049] [<c016c580>] (check_prev_add) from [<c016f4dc>] (__lock_acquire+0x1314/0x14fc)
[ 1991.235281] [<c016f4dc>] (__lock_acquire) from [<c016fefc>] (lock_acquire+0x6c/0x88)
[ 1991.242993] [<c016fefc>] (lock_acquire) from [<c0869fb4>] (__mutex_lock+0x68/0xa34)
[ 1991.250620] [<c0869fb4>] (__mutex_lock) from [<c086aa08>] (mutex_lock_interruptible_nested+0x1c/0x24)
[ 1991.259812] [<c086aa08>] (mutex_lock_interruptible_nested) from [<bf1729f0>] (gsc_m2m_mmap+0x24/0x5c [exynos_gsc])
[ 1991.270159] [<bf1729f0>] (gsc_m2m_mmap [exynos_gsc]) from [<bf037120>] (v4l2_mmap+0x54/0x88 [videodev])
[ 1991.279510] [<bf037120>] (v4l2_mmap [videodev]) from [<c01f4798>] (mmap_region+0x3a8/0x638)
[ 1991.287792] [<c01f4798>] (mmap_region) from [<c01f4d58>] (do_mmap+0x330/0x3a4)
[ 1991.294986] [<c01f4d58>] (do_mmap) from [<c01df330>] (vm_mmap_pgoff+0x90/0xb8)
[ 1991.302178] [<c01df330>] (vm_mmap_pgoff) from [<c01f28cc>] (SyS_mmap_pgoff+0x90/0xc0)
[ 1991.309977] [<c01f28cc>] (SyS_mmap_pgoff) from [<c0108820>] (ret_fast_syscall+0x0/0x28)

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
Suggested-by: Hans Verkuil <hansverk@cisco.com>
---
 drivers/media/platform/exynos-gsc/gsc-m2m.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/media/platform/exynos-gsc/gsc-m2m.c b/drivers/media/platform/exynos-gsc/gsc-m2m.c
index 2a2994e..722d7c4 100644
--- a/drivers/media/platform/exynos-gsc/gsc-m2m.c
+++ b/drivers/media/platform/exynos-gsc/gsc-m2m.c
@@ -726,14 +726,9 @@ static unsigned int gsc_m2m_poll(struct file *file,
 static int gsc_m2m_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct gsc_ctx *ctx = fh_to_ctx(file->private_data);
-	struct gsc_dev *gsc = ctx->gsc_dev;
 	int ret;
 
-	if (mutex_lock_interruptible(&gsc->lock))
-		return -ERESTARTSYS;
-
 	ret = v4l2_m2m_mmap(file, ctx->m2m_ctx, vma);
-	mutex_unlock(&gsc->lock);
 
 	return ret;
 }
-- 
2.7.4
