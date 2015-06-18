Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58829 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754518AbbFRKdl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Jun 2015 06:33:41 -0400
Date: Thu, 18 Jun 2015 12:33:35 +0200
From: Jan Kara <jack@suse.cz>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Revert "[media] vb2: Push mmap_sem down to memops"
Message-ID: <20150618103335.GF21820@quack.suse.cz>
References: <557E7DC7.3000607@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <557E7DC7.3000607@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon 15-06-15 09:24:55, Hans Verkuil wrote:
> This reverts commit 48b25a3a713b90988b6882d318f7c0a6bed9aabc.
> 
> That commit caused two regressions. The first is a BUG:
> 
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000100
> IP: [<ffffffff810d5cd0>] __lock_acquire+0x2f0/0x2070
> PGD 0
> Oops: 0000 [#1] PREEMPT SMP
> Modules linked in: vivid v4l2_dv_timings videobuf2_vmalloc videobuf2_memops videobuf2_core v4l2_common videodev media vmw_balloon vmw_vmci acpi_cpufreq processor button
> CPU: 0 PID: 1542 Comm: v4l2-ctl Not tainted 4.1.0-rc3-test-media #1190
> Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 05/20/2014
> task: ffff880220ce4200 ti: ffff88021d16c000 task.ti: ffff88021d16c000
> RIP: 0010:[<ffffffff810d5cd0>]  [<ffffffff810d5cd0>] __lock_acquire+0x2f0/0x2070
> RSP: 0018:ffff88021d16f9b8  EFLAGS: 00010002
> RAX: 0000000000000046 RBX: 0000000000000292 RCX: 0000000000000001
> RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000100
> RBP: ffff88021d16fa88 R08: 0000000000000001 R09: 0000000000000000
> R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000001
> R13: ffff880220ce4200 R14: 0000000000000100 R15: 0000000000000000
> FS:  00007f2441e7f740(0000) GS:ffff880236e00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 0000000000000100 CR3: 0000000001e0b000 CR4: 00000000001406f0
> Stack:
>  ffff88021d16fa98 ffffffff810d6543 0000000000000006 0000000000000246
>  ffff88021d16fa08 ffffffff810d532d ffff880220ce4a78 ffff880200000000
>  ffff880200000001 0000000000000000 0000000000000001 000000000093a4a0
> Call Trace:
>  [<ffffffff810d6543>] ? __lock_acquire+0xb63/0x2070
>  [<ffffffff810d532d>] ? mark_held_locks+0x6d/0xa0
>  [<ffffffff810d37a8>] ? __lock_is_held+0x58/0x80
>  [<ffffffff810d852c>] lock_acquire+0x6c/0xa0
>  [<ffffffffa039f1f6>] ? vb2_vmalloc_put_userptr+0x36/0x110 [videobuf2_vmalloc]
>  [<ffffffff819b1a92>] down_read+0x42/0x60
>  [<ffffffffa039f1f6>] ? vb2_vmalloc_put_userptr+0x36/0x110 [videobuf2_vmalloc]
>  [<ffffffff819af1b1>] ? mutex_lock_nested+0x2b1/0x560
>  [<ffffffffa038fdc5>] ? vb2_queue_release+0x25/0x40 [videobuf2_core]
>  [<ffffffffa039f1f6>] vb2_vmalloc_put_userptr+0x36/0x110 [videobuf2_vmalloc]
>  [<ffffffffa038b626>] __vb2_queue_free+0x146/0x5e0 [videobuf2_core]
>  [<ffffffffa038fdd3>] vb2_queue_release+0x33/0x40 [videobuf2_core]
>  [<ffffffffa038fe75>] _vb2_fop_release+0x95/0xb0 [videobuf2_core]
>  [<ffffffffa038feb9>] vb2_fop_release+0x29/0x50 [videobuf2_core]
>  [<ffffffffa03ad372>] vivid_fop_release+0x92/0x230 [vivid]
>  [<ffffffffa0358460>] v4l2_release+0x30/0x80 [videodev]
>  [<ffffffff811a51d5>] __fput+0xe5/0x200
>  [<ffffffff811a5339>] ____fput+0x9/0x10
>  [<ffffffff810a9fa4>] task_work_run+0xc4/0xf0
>  [<ffffffff8108c670>] do_exit+0x3a0/0xaf0
>  [<ffffffff819b3a9b>] ? _raw_spin_unlock_irq+0x2b/0x60
>  [<ffffffff8108e0ff>] do_group_exit+0x4f/0xe0
>  [<ffffffff8109a170>] get_signal+0x200/0x8c0
>  [<ffffffff819b14b5>] ? __mutex_unlock_slowpath+0xf5/0x240
>  [<ffffffff81002593>] do_signal+0x23/0x820
>  [<ffffffff819b1609>] ? mutex_unlock+0x9/0x10
>  [<ffffffffa0358648>] ? v4l2_ioctl+0x78/0xf0 [videodev]
>  [<ffffffff819b4653>] ? int_very_careful+0x5/0x46
>  [<ffffffff810d54bd>] ? trace_hardirqs_on_caller+0x15d/0x200
>  [<ffffffff81002de0>] do_notify_resume+0x50/0x60
>  [<ffffffff819b46a6>] int_signal+0x12/0x17
> Code: ca 81 31 c0 e8 7a e2 8c 00 e8 aa 1d 8d 00 0f 1f 44 00 00 31 db 48 81 c4 a8 00 00 00 89 d8 5b 41 5c 41 5d 41 5e 41 5f 5d c3 66 90 <49> 81 3e 40 4e 02 82 b8 00 00 00 00 44 0f 44 e0 41 83 ff 01 0f
> RIP  [<ffffffff810d5cd0>] __lock_acquire+0x2f0/0x2070
>  RSP <ffff88021d16f9b8>
> CR2: 0000000000000100
> ---[ end trace 25595c2b8560cb57 ]---
> Fixing recursive fault but reboot is needed!

Ah, that's tricky. We can end up calling task_work_run() via
exit_task_work() after mm has been shut down. And the task work will be
dropping the last reference to all file descriptors which ends up shutting
down vb2 after current->mm has been cleaned up.

So in the light of this it's probably better for the initial patch to
completely avoid grabbing mmap_sem in put_userptr(). It breaks locking for
vma->vm_ops->close() but that's already broken in vb2 as I explained in my
other email. And the remainder of the patch set will make sure we don't
need mmap_sem in put_userptr() at all and thus fixes the whole issue.

This also explains why I never saw the problem in my testing - I was always
testing the patch set as a whole.

I'll send an updated first patch later today.

								Honza

> This can be reproduced by loading the vivid driver and running:
> 
> v4l2-ctl --stream-user
> 
> and pressing Ctrl-C. You may have to try a few times, but in my experience this BUG
> is triggered quite quickly.
> 
> The second is a possible deadlock:
> 
> Jun 14 18:44:07 test-media kernel: [   49.376650] ======================================================
> Jun 14 18:44:07 test-media kernel: [   49.376651] [ INFO: possible circular locking dependency detected ]
> Jun 14 18:44:07 test-media kernel: [   49.376653] 4.1.0-rc3-test-media #1190 Not tainted
> Jun 14 18:44:07 test-media kernel: [   49.376654] -------------------------------------------------------
> Jun 14 18:44:07 test-media kernel: [   49.376655] v4l2-compliance/1468 is trying to acquire lock:
> Jun 14 18:44:07 test-media kernel: [   49.376657]  (&mm->mmap_sem){++++++}, at: [<ffffffffa03a81f6>] vb2_vmalloc_put_userptr+0x36/0x110 [videobuf2_vmalloc]
> Jun 14 18:44:07 test-media kernel: [   49.376665]
> Jun 14 18:44:07 test-media kernel: [   49.376665] but task is already holding lock:
> Jun 14 18:44:07 test-media kernel: [   49.376666]  (&q->mmap_lock){+.+...}, at: [<ffffffffa0398dc5>] vb2_queue_release+0x25/0x40 [videobuf2_core]
> Jun 14 18:44:07 test-media kernel: [   49.376670]
> Jun 14 18:44:07 test-media kernel: [   49.376670] which lock already depends on the new lock.
> Jun 14 18:44:07 test-media kernel: [   49.376670]
> Jun 14 18:44:07 test-media kernel: [   49.376671]
> Jun 14 18:44:07 test-media kernel: [   49.376671] the existing dependency chain (in reverse order) is:
> Jun 14 18:44:07 test-media kernel: [   49.376672]
> Jun 14 18:44:07 test-media kernel: [   49.376672] -> #1 (&q->mmap_lock){+.+...}:
> Jun 14 18:44:07 test-media kernel: [   49.376675]        [<ffffffff810d852c>] lock_acquire+0x6c/0xa0
> Jun 14 18:44:07 test-media kernel: [   49.376682]        [<ffffffff819aef5e>] mutex_lock_nested+0x5e/0x560
> Jun 14 18:44:07 test-media kernel: [   49.376689]        [<ffffffffa03934a2>] vb2_mmap+0x232/0x350 [videobuf2_core]
> Jun 14 18:44:07 test-media kernel: [   49.376691]        [<ffffffffa0395a60>] vb2_fop_mmap+0x20/0x30 [videobuf2_core]
> Jun 14 18:44:07 test-media kernel: [   49.376694]        [<ffffffffa0361102>] v4l2_mmap+0x52/0x90 [videodev]
> Jun 14 18:44:07 test-media kernel: [   49.376698]        [<ffffffff81177e33>] mmap_region+0x3b3/0x5e0
> Jun 14 18:44:07 test-media kernel: [   49.376701]        [<ffffffff81178377>] do_mmap_pgoff+0x317/0x400
> Jun 14 18:44:07 test-media kernel: [   49.376703]        [<ffffffff81165320>] vm_mmap_pgoff+0x90/0xc0
> Jun 14 18:44:07 test-media kernel: [   49.376708]        [<ffffffff81176867>] SyS_mmap_pgoff+0x1d7/0x280
> Jun 14 18:44:07 test-media kernel: [   49.376709]        [<ffffffff81007f8d>] SyS_mmap+0x1d/0x20
> Jun 14 18:44:07 test-media kernel: [   49.376714]        [<ffffffff819b44ae>] system_call_fastpath+0x12/0x76
> Jun 14 18:44:07 test-media kernel: [   49.376716]
> Jun 14 18:44:07 test-media kernel: [   49.376716] -> #0 (&mm->mmap_sem){++++++}:
> Jun 14 18:44:07 test-media kernel: [   49.376718]        [<ffffffff810d79b3>] __lock_acquire+0x1fd3/0x2070
> Jun 14 18:44:07 test-media kernel: [   49.376720]        [<ffffffff810d852c>] lock_acquire+0x6c/0xa0
> Jun 14 18:44:07 test-media kernel: [   49.376721]        [<ffffffff819b1a92>] down_read+0x42/0x60
> Jun 14 18:44:07 test-media kernel: [   49.376723]        [<ffffffffa03a81f6>] vb2_vmalloc_put_userptr+0x36/0x110 [videobuf2_vmalloc]
> Jun 14 18:44:07 test-media kernel: [   49.376725]        [<ffffffffa0394626>] __vb2_queue_free+0x146/0x5e0 [videobuf2_core]
> Jun 14 18:44:07 test-media kernel: [   49.376727]        [<ffffffffa0398dd3>] vb2_queue_release+0x33/0x40 [videobuf2_core]
> Jun 14 18:44:07 test-media kernel: [   49.376729]        [<ffffffffa0398e75>] _vb2_fop_release+0x95/0xb0 [videobuf2_core]
> Jun 14 18:44:07 test-media kernel: [   49.376731]        [<ffffffffa0398eb9>] vb2_fop_release+0x29/0x50 [videobuf2_core]
> Jun 14 18:44:07 test-media kernel: [   49.376733]        [<ffffffffa03b6372>] vivid_fop_release+0x92/0x230 [vivid]
> Jun 14 18:44:07 test-media kernel: [   49.376737]        [<ffffffffa0361460>] v4l2_release+0x30/0x80 [videodev]
> Jun 14 18:44:07 test-media kernel: [   49.376739]        [<ffffffff811a51d5>] __fput+0xe5/0x200
> Jun 14 18:44:07 test-media kernel: [   49.376744]        [<ffffffff811a5339>] ____fput+0x9/0x10
> Jun 14 18:44:07 test-media kernel: [   49.376746]        [<ffffffff810a9fa4>] task_work_run+0xc4/0xf0
> Jun 14 18:44:07 test-media kernel: [   49.376749]        [<ffffffff81002dd1>] do_notify_resume+0x41/0x60
> Jun 14 18:44:07 test-media kernel: [   49.376752]        [<ffffffff819b46a6>] int_signal+0x12/0x17
> Jun 14 18:44:07 test-media kernel: [   49.376754]
> Jun 14 18:44:07 test-media kernel: [   49.376754] other info that might help us debug this:
> Jun 14 18:44:07 test-media kernel: [   49.376754]
> Jun 14 18:44:07 test-media kernel: [   49.376755]  Possible unsafe locking scenario:
> Jun 14 18:44:07 test-media kernel: [   49.376755]
> Jun 14 18:44:07 test-media kernel: [   49.376756]        CPU0                    CPU1
> Jun 14 18:44:07 test-media kernel: [   49.376757]        ----                    ----
> Jun 14 18:44:07 test-media kernel: [   49.376758]   lock(&q->mmap_lock);
> Jun 14 18:44:07 test-media kernel: [   49.376759]                                lock(&mm->mmap_sem);
> Jun 14 18:44:07 test-media kernel: [   49.376760]                                lock(&q->mmap_lock);
> Jun 14 18:44:07 test-media kernel: [   49.376761]   lock(&mm->mmap_sem);
> Jun 14 18:44:07 test-media kernel: [   49.376763]
> Jun 14 18:44:07 test-media kernel: [   49.376763]  *** DEADLOCK ***
> Jun 14 18:44:07 test-media kernel: [   49.376763]
> Jun 14 18:44:07 test-media kernel: [   49.376764] 2 locks held by v4l2-compliance/1468:
> Jun 14 18:44:07 test-media kernel: [   49.376765]  #0:  (&dev->mutex#3){+.+.+.}, at: [<ffffffffa0398e0a>] _vb2_fop_release+0x2a/0xb0 [videobuf2_core]
> Jun 14 18:44:07 test-media kernel: [   49.376770]  #1:  (&q->mmap_lock){+.+...}, at: [<ffffffffa0398dc5>] vb2_queue_release+0x25/0x40 [videobuf2_core]
> Jun 14 18:44:07 test-media kernel: [   49.376773]
> Jun 14 18:44:07 test-media kernel: [   49.376773] stack backtrace:
> Jun 14 18:44:07 test-media kernel: [   49.376776] CPU: 2 PID: 1468 Comm: v4l2-compliance Not tainted 4.1.0-rc3-test-media #1190
> Jun 14 18:44:07 test-media kernel: [   49.376777] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 05/20/2014
> Jun 14 18:44:07 test-media kernel: [   49.376779]  ffffffff8279e0b0 ffff88021d6f7ba8 ffffffff819a7aac 0000000000000011
> Jun 14 18:44:07 test-media kernel: [   49.376781]  ffffffff8279e0b0 ffff88021d6f7bf8 ffffffff819a3964 ffff88021d6f7bd8
> Jun 14 18:44:07 test-media kernel: [   49.376783]  ffff8800ac8aa100 0000000000000002 ffff8800ac8aa9a0 0000000000000002
> Jun 14 18:44:07 test-media kernel: [   49.376785] Call Trace:
> Jun 14 18:44:07 test-media kernel: [   49.376788]  [<ffffffff819a7aac>] dump_stack+0x4f/0x7b
> Jun 14 18:44:07 test-media kernel: [   49.376792]  [<ffffffff819a3964>] print_circular_bug+0x20f/0x251
> Jun 14 18:44:07 test-media kernel: [   49.376793]  [<ffffffff810d79b3>] __lock_acquire+0x1fd3/0x2070
> Jun 14 18:44:07 test-media kernel: [   49.376795]  [<ffffffff810d6543>] ? __lock_acquire+0xb63/0x2070
> Jun 14 18:44:07 test-media kernel: [   49.376797]  [<ffffffff810d37a8>] ? __lock_is_held+0x58/0x80
> Jun 14 18:44:07 test-media kernel: [   49.376798]  [<ffffffff810d852c>] lock_acquire+0x6c/0xa0
> Jun 14 18:44:07 test-media kernel: [   49.376800]  [<ffffffffa03a81f6>] ? vb2_vmalloc_put_userptr+0x36/0x110 [videobuf2_vmalloc]
> Jun 14 18:44:07 test-media kernel: [   49.376802]  [<ffffffff819b1a92>] down_read+0x42/0x60
> Jun 14 18:44:07 test-media kernel: [   49.376803]  [<ffffffffa03a81f6>] ? vb2_vmalloc_put_userptr+0x36/0x110 [videobuf2_vmalloc]
> Jun 14 18:44:07 test-media kernel: [   49.376805]  [<ffffffff819af1b1>] ? mutex_lock_nested+0x2b1/0x560
> Jun 14 18:44:07 test-media kernel: [   49.376807]  [<ffffffffa0398dc5>] ? vb2_queue_release+0x25/0x40 [videobuf2_core]
> Jun 14 18:44:07 test-media kernel: [   49.376808]  [<ffffffffa03a81f6>] vb2_vmalloc_put_userptr+0x36/0x110 [videobuf2_vmalloc]
> Jun 14 18:44:07 test-media kernel: [   49.376810]  [<ffffffffa0398e0a>] ? _vb2_fop_release+0x2a/0xb0 [videobuf2_core]
> Jun 14 18:44:07 test-media kernel: [   49.376812]  [<ffffffffa0394626>] __vb2_queue_free+0x146/0x5e0 [videobuf2_core]
> Jun 14 18:44:07 test-media kernel: [   49.376814]  [<ffffffffa0398dd3>] vb2_queue_release+0x33/0x40 [videobuf2_core]
> Jun 14 18:44:07 test-media kernel: [   49.376816]  [<ffffffffa0398e75>] _vb2_fop_release+0x95/0xb0 [videobuf2_core]
> Jun 14 18:44:07 test-media kernel: [   49.376818]  [<ffffffffa0398eb9>] vb2_fop_release+0x29/0x50 [videobuf2_core]
> Jun 14 18:44:07 test-media kernel: [   49.376820]  [<ffffffffa03b6372>] vivid_fop_release+0x92/0x230 [vivid]
> Jun 14 18:44:07 test-media kernel: [   49.376822]  [<ffffffffa0361460>] v4l2_release+0x30/0x80 [videodev]
> Jun 14 18:44:07 test-media kernel: [   49.376824]  [<ffffffff811a51d5>] __fput+0xe5/0x200
> Jun 14 18:44:07 test-media kernel: [   49.376825]  [<ffffffff819b4653>] ? int_very_careful+0x5/0x46
> Jun 14 18:44:07 test-media kernel: [   49.376827]  [<ffffffff811a5339>] ____fput+0x9/0x10
> Jun 14 18:44:07 test-media kernel: [   49.376828]  [<ffffffff810a9fa4>] task_work_run+0xc4/0xf0
> Jun 14 18:44:07 test-media kernel: [   49.376830]  [<ffffffff81002dd1>] do_notify_resume+0x41/0x60
> Jun 14 18:44:07 test-media kernel: [   49.376832]  [<ffffffff819b46a6>] int_signal+0x12/0x17
> 
> This can be triggered by loading the vivid module with the module option 'no_error_inj=1'
> and running 'v4l2-compliance -s5'. Again, it may take a few attempts to trigger this
> but for me it happens quite quickly.
> 
> Without this patch I cannot reproduce these two issues. So reverting is the best
> solution for now.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> ---
>  drivers/media/v4l2-core/videobuf2-core.c       | 2 ++
>  drivers/media/v4l2-core/videobuf2-dma-contig.c | 7 -------
>  drivers/media/v4l2-core/videobuf2-dma-sg.c     | 6 ------
>  drivers/media/v4l2-core/videobuf2-vmalloc.c    | 6 +-----
>  4 files changed, 3 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index 1a096a6..d835814 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -1662,7 +1662,9 @@ static int __buf_prepare(struct vb2_buffer *vb, const struct v4l2_buffer *b)
>  		ret = __qbuf_mmap(vb, b);
>  		break;
>  	case V4L2_MEMORY_USERPTR:
> +		down_read(&current->mm->mmap_sem);
>  		ret = __qbuf_userptr(vb, b);
> +		up_read(&current->mm->mmap_sem);
>  		break;
>  	case V4L2_MEMORY_DMABUF:
>  		ret = __qbuf_dmabuf(vb, b);
> diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> index 369df95..94c1e64 100644
> --- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
> +++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> @@ -532,9 +532,7 @@ static void vb2_dc_put_userptr(void *buf_priv)
>  		sg_free_table(sgt);
>  		kfree(sgt);
>  	}
> -	down_read(&current->mm->mmap_sem);
>  	vb2_put_vma(buf->vma);
> -	up_read(&current->mm->mmap_sem);
>  	kfree(buf);
>  }
>  
> @@ -618,7 +616,6 @@ static void *vb2_dc_get_userptr(void *alloc_ctx, unsigned long vaddr,
>  		goto fail_buf;
>  	}
>  
> -	down_read(&current->mm->mmap_sem);
>  	/* current->mm->mmap_sem is taken by videobuf2 core */
>  	vma = find_vma(current->mm, vaddr);
>  	if (!vma) {
> @@ -645,7 +642,6 @@ static void *vb2_dc_get_userptr(void *alloc_ctx, unsigned long vaddr,
>  	if (ret) {
>  		unsigned long pfn;
>  		if (vb2_dc_get_user_pfn(start, n_pages, vma, &pfn) == 0) {
> -			up_read(&current->mm->mmap_sem);
>  			buf->dma_addr = vb2_dc_pfn_to_dma(buf->dev, pfn);
>  			buf->size = size;
>  			kfree(pages);
> @@ -655,7 +651,6 @@ static void *vb2_dc_get_userptr(void *alloc_ctx, unsigned long vaddr,
>  		pr_err("failed to get user pages\n");
>  		goto fail_vma;
>  	}
> -	up_read(&current->mm->mmap_sem);
>  
>  	sgt = kzalloc(sizeof(*sgt), GFP_KERNEL);
>  	if (!sgt) {
> @@ -718,12 +713,10 @@ fail_get_user_pages:
>  		while (n_pages)
>  			put_page(pages[--n_pages]);
>  
> -	down_read(&current->mm->mmap_sem);
>  fail_vma:
>  	vb2_put_vma(buf->vma);
>  
>  fail_pages:
> -	up_read(&current->mm->mmap_sem);
>  	kfree(pages); /* kfree is NULL-proof */
>  
>  fail_buf:
> diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c b/drivers/media/v4l2-core/videobuf2-dma-sg.c
> index d7bcb05..7289b81 100644
> --- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
> +++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c
> @@ -264,7 +264,6 @@ static void *vb2_dma_sg_get_userptr(void *alloc_ctx, unsigned long vaddr,
>  	if (!buf->pages)
>  		goto userptr_fail_alloc_pages;
>  
> -	down_read(&current->mm->mmap_sem);
>  	vma = find_vma(current->mm, vaddr);
>  	if (!vma) {
>  		dprintk(1, "no vma for address %lu\n", vaddr);
> @@ -303,7 +302,6 @@ static void *vb2_dma_sg_get_userptr(void *alloc_ctx, unsigned long vaddr,
>  					     1, /* force */
>  					     buf->pages,
>  					     NULL);
> -	up_read(&current->mm->mmap_sem);
>  
>  	if (num_pages_from_user != buf->num_pages)
>  		goto userptr_fail_get_user_pages;
> @@ -333,10 +331,8 @@ userptr_fail_get_user_pages:
>  	if (!vma_is_io(buf->vma))
>  		while (--num_pages_from_user >= 0)
>  			put_page(buf->pages[num_pages_from_user]);
> -	down_read(&current->mm->mmap_sem);
>  	vb2_put_vma(buf->vma);
>  userptr_fail_find_vma:
> -	up_read(&current->mm->mmap_sem);
>  	kfree(buf->pages);
>  userptr_fail_alloc_pages:
>  	kfree(buf);
> @@ -370,9 +366,7 @@ static void vb2_dma_sg_put_userptr(void *buf_priv)
>  			put_page(buf->pages[i]);
>  	}
>  	kfree(buf->pages);
> -	down_read(&current->mm->mmap_sem);
>  	vb2_put_vma(buf->vma);
> -	up_read(&current->mm->mmap_sem);
>  	kfree(buf);
>  }
>  
> diff --git a/drivers/media/v4l2-core/videobuf2-vmalloc.c b/drivers/media/v4l2-core/videobuf2-vmalloc.c
> index f6656fe..2fe4c27 100644
> --- a/drivers/media/v4l2-core/videobuf2-vmalloc.c
> +++ b/drivers/media/v4l2-core/videobuf2-vmalloc.c
> @@ -89,7 +89,7 @@ static void *vb2_vmalloc_get_userptr(void *alloc_ctx, unsigned long vaddr,
>  	offset = vaddr & ~PAGE_MASK;
>  	buf->size = size;
>  
> -	down_read(&current->mm->mmap_sem);
> +
>  	vma = find_vma(current->mm, vaddr);
>  	if (vma && (vma->vm_flags & VM_PFNMAP) && (vma->vm_pgoff)) {
>  		if (vb2_get_contig_userptr(vaddr, size, &vma, &physp))
> @@ -121,7 +121,6 @@ static void *vb2_vmalloc_get_userptr(void *alloc_ctx, unsigned long vaddr,
>  		if (!buf->vaddr)
>  			goto fail_get_user_pages;
>  	}
> -	up_read(&current->mm->mmap_sem);
>  
>  	buf->vaddr += offset;
>  	return buf;
> @@ -134,7 +133,6 @@ fail_get_user_pages:
>  	kfree(buf->pages);
>  
>  fail_pages_array_alloc:
> -	up_read(&current->mm->mmap_sem);
>  	kfree(buf);
>  
>  	return NULL;
> @@ -146,7 +144,6 @@ static void vb2_vmalloc_put_userptr(void *buf_priv)
>  	unsigned long vaddr = (unsigned long)buf->vaddr & PAGE_MASK;
>  	unsigned int i;
>  
> -	down_read(&current->mm->mmap_sem);
>  	if (buf->pages) {
>  		if (vaddr)
>  			vm_unmap_ram((void *)vaddr, buf->n_pages);
> @@ -160,7 +157,6 @@ static void vb2_vmalloc_put_userptr(void *buf_priv)
>  		vb2_put_vma(buf->vma);
>  		iounmap((__force void __iomem *)buf->vaddr);
>  	}
> -	up_read(&current->mm->mmap_sem);
>  	kfree(buf);
>  }
>  
> -- 
> 2.1.4
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
