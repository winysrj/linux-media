Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:53145 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755047AbbGTH7b (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jul 2015 03:59:31 -0400
Message-ID: <55ACAA20.3020204@xs4all.nl>
Date: Mon, 20 Jul 2015 09:58:24 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>,
	Kamil Debski <kamil@wypas.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Pawel Osciak <pawel@osciak.com>
Subject: [PATCH] v4l2-mem2mem: drop lock in v4l2_m2m_fop_mmap
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The v4l2_m2m_fop_mmap function takes the core mutex, but this will result in a potential
circular locking dependency:

[  262.517164] ======================================================
[  262.517166] [ INFO: possible circular locking dependency detected ]
[  262.517169] 4.2.0-rc2-koryphon #844 Not tainted
[  262.517171] -------------------------------------------------------
[  262.517173] v4l2-compliance/1379 is trying to acquire lock:
[  262.517175]  (&dev->dev_mutex){+.+.+.}, at: [<ffffffffa000ddab>] v4l2_m2m_fop_mmap+0x2b/0x90 [v4l2_mem2mem]
[  262.517187] 
               but task is already holding lock:
[  262.517189]  (&mm->mmap_sem){++++++}, at: [<ffffffff81159309>] vm_mmap_pgoff+0x69/0xc0
[  262.517199] 
               which lock already depends on the new lock.

[  262.517202] 
               the existing dependency chain (in reverse order) is:
[  262.517204] 
               -> #1 (&mm->mmap_sem){++++++}:
[  262.517209]        [<ffffffff810d0e6b>] __lock_acquire+0x62b/0xe80
[  262.517215]        [<ffffffff810d2095>] lock_acquire+0x65/0x90
[  262.517218]        [<ffffffff811612e5>] __might_fault+0x75/0xa0
[  262.517222]        [<ffffffffa06dead9>] video_usercopy+0x3e9/0x4e0 [videodev]
[  262.517231]        [<ffffffffa06debe0>] video_ioctl2+0x10/0x20 [videodev]
[  262.517238]        [<ffffffffa06d8663>] v4l2_ioctl+0xc3/0xe0 [videodev]
[  262.517243]        [<ffffffff811a8cac>] do_vfs_ioctl+0x2fc/0x550
[  262.517248]        [<ffffffff811a8f74>] SyS_ioctl+0x74/0x80
[  262.517252]        [<ffffffff81a4d2ee>] entry_SYSCALL_64_fastpath+0x12/0x76
[  262.517258] 
               -> #0 (&dev->dev_mutex){+.+.+.}:
[  262.517262]        [<ffffffff810cf464>] validate_chain.isra.38+0xd04/0x1170
[  262.517266]        [<ffffffff810d0e6b>] __lock_acquire+0x62b/0xe80
[  262.517270]        [<ffffffff810d2095>] lock_acquire+0x65/0x90
[  262.517273]        [<ffffffff81a48e3c>] mutex_lock_interruptible_nested+0x6c/0x4b0
[  262.517279]        [<ffffffffa000ddab>] v4l2_m2m_fop_mmap+0x2b/0x90 [v4l2_mem2mem]
[  262.517284]        [<ffffffffa06d80ff>] v4l2_mmap+0x4f/0x90 [videodev]
[  262.517288]        [<ffffffff8116b06c>] mmap_region+0x38c/0x5b0
[  262.517293]        [<ffffffff8116b585>] do_mmap_pgoff+0x2f5/0x3e0
[  262.517297]        [<ffffffff8115932a>] vm_mmap_pgoff+0x8a/0xc0
[  262.517300]        [<ffffffff81169bab>] SyS_mmap_pgoff+0x1cb/0x270
[  262.517304]        [<ffffffff8100876d>] SyS_mmap+0x1d/0x20
[  262.517309]        [<ffffffff81a4d2ee>] entry_SYSCALL_64_fastpath+0x12/0x76
[  262.517313] 
               other info that might help us debug this:

[  262.517315]  Possible unsafe locking scenario:

[  262.517318]        CPU0                    CPU1
[  262.517319]        ----                    ----
[  262.517321]   lock(&mm->mmap_sem);
[  262.517324]                                lock(&dev->dev_mutex);
[  262.517327]                                lock(&mm->mmap_sem);
[  262.517329]   lock(&dev->dev_mutex);
[  262.517332] 
                *** DEADLOCK ***

Since vb2_fop_mmap doesn't take the lock, neither should v4l2_m2m_fop_mmap.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
index dc853e5..7805da1 100644
--- a/drivers/media/v4l2-core/v4l2-mem2mem.c
+++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
@@ -874,18 +874,8 @@ EXPORT_SYMBOL_GPL(v4l2_m2m_ioctl_streamoff);
 int v4l2_m2m_fop_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct v4l2_fh *fh = file->private_data;
-	struct v4l2_m2m_ctx *m2m_ctx = fh->m2m_ctx;
-	int ret;
-
-	if (m2m_ctx->q_lock && mutex_lock_interruptible(m2m_ctx->q_lock))
-		return -ERESTARTSYS;
-
-	ret = v4l2_m2m_mmap(file, m2m_ctx, vma);
 
-	if (m2m_ctx->q_lock)
-		mutex_unlock(m2m_ctx->q_lock);
-
-	return ret;
+	return v4l2_m2m_mmap(file, fh->m2m_ctx, vma);
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_fop_mmap);
 
