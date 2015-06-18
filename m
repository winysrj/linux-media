Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33695 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751331AbbFRLZy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Jun 2015 07:25:54 -0400
Date: Thu, 18 Jun 2015 13:25:48 +0200
From: Jan Kara <jack@suse.cz>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Jan Kara <jack@suse.cz>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Revert "[media] vb2: Push mmap_sem down to memops"
Message-ID: <20150618112548.GG21820@quack.suse.cz>
References: <557E7DC7.3000607@xs4all.nl>
 <20150618103335.GF21820@quack.suse.cz>
 <5582A146.5070003@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5582A146.5070003@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu 18-06-15 12:45:26, Hans Verkuil wrote:
> On 06/18/2015 12:33 PM, Jan Kara wrote:
> > On Mon 15-06-15 09:24:55, Hans Verkuil wrote:
> >> This reverts commit 48b25a3a713b90988b6882d318f7c0a6bed9aabc.
> >>
> >> That commit caused two regressions. The first is a BUG:
> >>
> >> BUG: unable to handle kernel NULL pointer dereference at 0000000000000100
> >> IP: [<ffffffff810d5cd0>] __lock_acquire+0x2f0/0x2070
> >> PGD 0
> >> Oops: 0000 [#1] PREEMPT SMP
> >> Modules linked in: vivid v4l2_dv_timings videobuf2_vmalloc videobuf2_memops videobuf2_core v4l2_common videodev media vmw_balloon vmw_vmci acpi_cpufreq processor button
> >> CPU: 0 PID: 1542 Comm: v4l2-ctl Not tainted 4.1.0-rc3-test-media #1190
> >> Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 05/20/2014
> >> task: ffff880220ce4200 ti: ffff88021d16c000 task.ti: ffff88021d16c000
> >> RIP: 0010:[<ffffffff810d5cd0>]  [<ffffffff810d5cd0>] __lock_acquire+0x2f0/0x2070
> >> RSP: 0018:ffff88021d16f9b8  EFLAGS: 00010002
> >> RAX: 0000000000000046 RBX: 0000000000000292 RCX: 0000000000000001
> >> RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000100
> >> RBP: ffff88021d16fa88 R08: 0000000000000001 R09: 0000000000000000
> >> R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000001
> >> R13: ffff880220ce4200 R14: 0000000000000100 R15: 0000000000000000
> >> FS:  00007f2441e7f740(0000) GS:ffff880236e00000(0000) knlGS:0000000000000000
> >> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> >> CR2: 0000000000000100 CR3: 0000000001e0b000 CR4: 00000000001406f0
> >> Stack:
> >>  ffff88021d16fa98 ffffffff810d6543 0000000000000006 0000000000000246
> >>  ffff88021d16fa08 ffffffff810d532d ffff880220ce4a78 ffff880200000000
> >>  ffff880200000001 0000000000000000 0000000000000001 000000000093a4a0
> >> Call Trace:
> >>  [<ffffffff810d6543>] ? __lock_acquire+0xb63/0x2070
> >>  [<ffffffff810d532d>] ? mark_held_locks+0x6d/0xa0
> >>  [<ffffffff810d37a8>] ? __lock_is_held+0x58/0x80
> >>  [<ffffffff810d852c>] lock_acquire+0x6c/0xa0
> >>  [<ffffffffa039f1f6>] ? vb2_vmalloc_put_userptr+0x36/0x110 [videobuf2_vmalloc]
> >>  [<ffffffff819b1a92>] down_read+0x42/0x60
> >>  [<ffffffffa039f1f6>] ? vb2_vmalloc_put_userptr+0x36/0x110 [videobuf2_vmalloc]
> >>  [<ffffffff819af1b1>] ? mutex_lock_nested+0x2b1/0x560
> >>  [<ffffffffa038fdc5>] ? vb2_queue_release+0x25/0x40 [videobuf2_core]
> >>  [<ffffffffa039f1f6>] vb2_vmalloc_put_userptr+0x36/0x110 [videobuf2_vmalloc]
> >>  [<ffffffffa038b626>] __vb2_queue_free+0x146/0x5e0 [videobuf2_core]
> >>  [<ffffffffa038fdd3>] vb2_queue_release+0x33/0x40 [videobuf2_core]
> >>  [<ffffffffa038fe75>] _vb2_fop_release+0x95/0xb0 [videobuf2_core]
> >>  [<ffffffffa038feb9>] vb2_fop_release+0x29/0x50 [videobuf2_core]
> >>  [<ffffffffa03ad372>] vivid_fop_release+0x92/0x230 [vivid]
> >>  [<ffffffffa0358460>] v4l2_release+0x30/0x80 [videodev]
> >>  [<ffffffff811a51d5>] __fput+0xe5/0x200
> >>  [<ffffffff811a5339>] ____fput+0x9/0x10
> >>  [<ffffffff810a9fa4>] task_work_run+0xc4/0xf0
> >>  [<ffffffff8108c670>] do_exit+0x3a0/0xaf0
> >>  [<ffffffff819b3a9b>] ? _raw_spin_unlock_irq+0x2b/0x60
> >>  [<ffffffff8108e0ff>] do_group_exit+0x4f/0xe0
> >>  [<ffffffff8109a170>] get_signal+0x200/0x8c0
> >>  [<ffffffff819b14b5>] ? __mutex_unlock_slowpath+0xf5/0x240
> >>  [<ffffffff81002593>] do_signal+0x23/0x820
> >>  [<ffffffff819b1609>] ? mutex_unlock+0x9/0x10
> >>  [<ffffffffa0358648>] ? v4l2_ioctl+0x78/0xf0 [videodev]
> >>  [<ffffffff819b4653>] ? int_very_careful+0x5/0x46
> >>  [<ffffffff810d54bd>] ? trace_hardirqs_on_caller+0x15d/0x200
> >>  [<ffffffff81002de0>] do_notify_resume+0x50/0x60
> >>  [<ffffffff819b46a6>] int_signal+0x12/0x17
> >> Code: ca 81 31 c0 e8 7a e2 8c 00 e8 aa 1d 8d 00 0f 1f 44 00 00 31 db 48 81 c4 a8 00 00 00 89 d8 5b 41 5c 41 5d 41 5e 41 5f 5d c3 66 90 <49> 81 3e 40 4e 02 82 b8 00 00 00 00 44 0f 44 e0 41 83 ff 01 0f
> >> RIP  [<ffffffff810d5cd0>] __lock_acquire+0x2f0/0x2070
> >>  RSP <ffff88021d16f9b8>
> >> CR2: 0000000000000100
> >> ---[ end trace 25595c2b8560cb57 ]---
> >> Fixing recursive fault but reboot is needed!
> > 
> > Ah, that's tricky. We can end up calling task_work_run() via
> > exit_task_work() after mm has been shut down. And the task work will be
> > dropping the last reference to all file descriptors which ends up shutting
> > down vb2 after current->mm has been cleaned up.
> > 
> > So in the light of this it's probably better for the initial patch to
> > completely avoid grabbing mmap_sem in put_userptr(). It breaks locking for
> > vma->vm_ops->close() but that's already broken in vb2 as I explained in my
> > other email. And the remainder of the patch set will make sure we don't
> > need mmap_sem in put_userptr() at all and thus fixes the whole issue.
> > 
> > This also explains why I never saw the problem in my testing - I was always
> > testing the patch set as a whole.
> > 
> > I'll send an updated first patch later today.
> 
> OK, good. I'm thinking: if it is OK with Andrew, then the low-level mm changes
> can be merged for 4.2 through his tree since that doesn't affect anything else
> (right?), but the vb2 changes I prefer to postpone to 4.3. I'd like to give it
> enough time for testing and shake-out any remaining issues (hopefully there
> aren't any, of course).

Yeah, the mm changes just provide the infrastructure so they don't depend
on anything. I think they are fine for 4.2.

> The omap_vout patch can go in for 4.3 as well (this driver might be
> removed in the near future, so there is no hurry there), and it's up to
> you what to do with the exynos drm driver.
> 
> Does this make sense?

OK. I think exynos drm driver conversion can go in with mm changes. I see
no point in waiting there. I agree with postpoing vb2 changes for 4.3 just
to be sure we got things right.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
