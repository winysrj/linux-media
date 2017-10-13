Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:35434 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751571AbdJMXNq (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 13 Oct 2017 19:13:46 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@kernel.org, hansverk@cisco.com, kgene@kernel.org,
        krzk@kernel.org, s.nawrocki@samsung.com, shailendra.v@samsung.com,
        shuah@kernel.org, Julia.Lawall@lip6.fr, kyungmin.park@samsung.com,
        kamil@wypas.org, jtp.park@samsung.com, a.hajda@samsung.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 2/2] media: s5p-mfc: fix lockdep warning
Date: Fri, 13 Oct 2017 17:13:37 -0600
Message-Id: <4887afc17a24fbd103e8616b463269cef8482bf3.1507935819.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1507935819.git.shuahkh@osg.samsung.com>
References: <cover.1507935819.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1507935819.git.shuahkh@osg.samsung.com>
References: <cover.1507935819.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The driver mmap functions shouldn't take lock when calling vb2_mmap().
Fix it to not take the lock. The following lockdep warning is fixed
with this change.

[ 2106.181412] ======================================================
[ 2106.187563] WARNING: possible circular locking dependency detected
[ 2106.193718] 4.14.0-rc2-00002-gfab205f-dirty #4 Not tainted
[ 2106.199175] ------------------------------------------------------
[ 2106.205328] qtdemux0:sink/2614 is trying to acquire lock:
[ 2106.210701]  (&dev->mfc_mutex){+.+.}, at: [<bf175544>] s5p_mfc_mmap+0x28/0xd4 [s5p_mfc]
[ 2106.218672]
[ 2106.218672] but task is already holding lock:
[ 2106.224477]  (&mm->mmap_sem){++++}, at: [<c01df2e4>] vm_mmap_pgoff+0x44/0xb8
[ 2106.231497]
[ 2106.231497] which lock already depends on the new lock.
[ 2106.231497]
[ 2106.239642]
[ 2106.239642] the existing dependency chain (in reverse order) is:
[ 2106.247095]
[ 2106.247095] -> #1 (&mm->mmap_sem){++++}:
[ 2106.252473]        __might_fault+0x80/0xb0
[ 2106.256567]        video_usercopy+0x1cc/0x510 [videodev]
[ 2106.261845]        v4l2_ioctl+0xa4/0xdc [videodev]
[ 2106.266596]        do_vfs_ioctl+0xa0/0xa18
[ 2106.270667]        SyS_ioctl+0x34/0x5c
[ 2106.274395]        ret_fast_syscall+0x0/0x28
[ 2106.278637]
[ 2106.278637] -> #0 (&dev->mfc_mutex){+.+.}:
[ 2106.284186]        lock_acquire+0x6c/0x88
[ 2106.288173]        __mutex_lock+0x68/0xa34
[ 2106.292244]        mutex_lock_interruptible_nested+0x1c/0x24
[ 2106.297893]        s5p_mfc_mmap+0x28/0xd4 [s5p_mfc]
[ 2106.302747]        v4l2_mmap+0x54/0x88 [videodev]
[ 2106.307409]        mmap_region+0x3a8/0x638
[ 2106.311480]        do_mmap+0x330/0x3a4
[ 2106.315207]        vm_mmap_pgoff+0x90/0xb8
[ 2106.319279]        SyS_mmap_pgoff+0x90/0xc0
[ 2106.323439]        ret_fast_syscall+0x0/0x28
[ 2106.327683]
[ 2106.327683] other info that might help us debug this:
[ 2106.327683]
[ 2106.335656]  Possible unsafe locking scenario:
[ 2106.335656]
[ 2106.341548]        CPU0                    CPU1
[ 2106.346053]        ----                    ----
[ 2106.350559]   lock(&mm->mmap_sem);
[ 2106.353939]                                lock(&dev->mfc_mutex);
[ 2106.353939]                                lock(&dev->mfc_mutex);
[ 2106.365897]   lock(&dev->mfc_mutex);
[ 2106.369450]
[ 2106.369450]  *** DEADLOCK ***
[ 2106.369450]
[ 2106.375344] 1 lock held by qtdemux0:sink/2614:
[ 2106.379762]  #0:  (&mm->mmap_sem){++++}, at: [<c01df2e4>] vm_mmap_pgoff+0x44/0xb8
[ 2106.387214]
[ 2106.387214] stack backtrace:
[ 2106.391550] CPU: 7 PID: 2614 Comm: qtdemux0:sink Not tainted 4.14.0-rc2-00002-gfab205f-dirty #4
[ 2106.400213] Hardware name: SAMSUNG EXYNOS (Flattened Device Tree)
[ 2106.406285] [<c01102c8>] (unwind_backtrace) from [<c010cabc>] (show_stack+0x10/0x14)
[ 2106.413995] [<c010cabc>] (show_stack) from [<c08543a4>] (dump_stack+0x98/0xc4)
[ 2106.421187] [<c08543a4>] (dump_stack) from [<c016b2fc>] (print_circular_bug+0x254/0x410)
[ 2106.429245] [<c016b2fc>] (print_circular_bug) from [<c016c580>] (check_prev_add+0x468/0x938)
[ 2106.437651] [<c016c580>] (check_prev_add) from [<c016f4dc>] (__lock_acquire+0x1314/0x14fc)
[ 2106.445883] [<c016f4dc>] (__lock_acquire) from [<c016fefc>] (lock_acquire+0x6c/0x88)
[ 2106.453596] [<c016fefc>] (lock_acquire) from [<c0869fb4>] (__mutex_lock+0x68/0xa34)
[ 2106.461221] [<c0869fb4>] (__mutex_lock) from [<c086aa08>] (mutex_lock_interruptible_nested+0x1c/0x24)
[ 2106.470425] [<c086aa08>] (mutex_lock_interruptible_nested) from [<bf175544>] (s5p_mfc_mmap+0x28/0xd4 [s5p_mfc])
[ 2106.480494] [<bf175544>] (s5p_mfc_mmap [s5p_mfc]) from [<bf037120>] (v4l2_mmap+0x54/0x88 [videodev])
[ 2106.489575] [<bf037120>] (v4l2_mmap [videodev]) from [<c01f4798>] (mmap_region+0x3a8/0x638)
[ 2106.497875] [<c01f4798>] (mmap_region) from [<c01f4d58>] (do_mmap+0x330/0x3a4)
[ 2106.505068] [<c01f4d58>] (do_mmap) from [<c01df330>] (vm_mmap_pgoff+0x90/0xb8)
[ 2106.512260] [<c01df330>] (vm_mmap_pgoff) from [<c01f28cc>] (SyS_mmap_pgoff+0x90/0xc0)
[ 2106.520059] [<c01f28cc>] (SyS_mmap_pgoff) from [<c0108820>] (ret_fast_syscall+0x0/0x28)

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
Suggested-by: Hans Verkuil <hansverk@cisco.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 4c253fb..40c18b4 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -1047,8 +1047,6 @@ static int s5p_mfc_mmap(struct file *file, struct vm_area_struct *vma)
 	unsigned long offset = vma->vm_pgoff << PAGE_SHIFT;
 	int ret;
 
-	if (mutex_lock_interruptible(&dev->mfc_mutex))
-		return -ERESTARTSYS;
 	if (offset < DST_QUEUE_OFF_BASE) {
 		mfc_debug(2, "mmaping source\n");
 		ret = vb2_mmap(&ctx->vq_src, vma);
@@ -1057,7 +1055,6 @@ static int s5p_mfc_mmap(struct file *file, struct vm_area_struct *vma)
 		vma->vm_pgoff -= (DST_QUEUE_OFF_BASE >> PAGE_SHIFT);
 		ret = vb2_mmap(&ctx->vq_dst, vma);
 	}
-	mutex_unlock(&dev->mfc_mutex);
 	return ret;
 }
 
-- 
2.7.4
