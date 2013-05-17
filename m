Return-path: <linux-media-owner@vger.kernel.org>
Received: from vserver.eikelenboom.it ([84.200.39.61]:47947 "EHLO
	smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644Ab3EQJE7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 May 2013 05:04:59 -0400
Date: Fri, 17 May 2013 11:04:50 +0200
From: Sander Eikelenboom <linux@eikelenboom.it>
Message-ID: <1756541549.20130517110450@eikelenboom.it>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [media] cx25821 regression from 3.9: BUG: bad unlock balance detected!
In-Reply-To: <201305171025.24166.hverkuil@xs4all.nl>
References: <1139404719.20130516194142@eikelenboom.it> <201305171025.24166.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Friday, May 17, 2013, 10:25:24 AM, you wrote:

> On Thu May 16 2013 19:41:42 Sander Eikelenboom wrote:
>> Hi Hans / Mauro,
>> 
>> With 3.10.0-rc1 (including the cx25821 changes from Hans), I get the bug below which wasn't present with 3.9.

> How do I reproduce this? I've tried to, but I can't make this happen.

> Looking at the code I can't see how it could hit this bug anyway.

I'm using "motion" to grab and process 6 from the video streams of the card i have (card with 8 inputs).
It seems the cx25821 underwent quite some changes between 3.9 and 3.10.

And in the past there have been some more locking issues around mmap and media devices, although they seem to appear as circular locking dependencies and with different devices.
   - http://www.mail-archive.com/linux-media@vger.kernel.org/msg46217.html
   - Under kvm: http://www.spinics.net/lists/linux-media/msg63322.html

- Perhaps that running in a VM could have to do with it ?
   - The driver on 3.9 occasionaly gives this, probably latency related (but continues to work):
     cx25821: cx25821_video_wakeup: 2 buffers handled (should be 1)

     Could it be something double unlocking in that path ?

- Is there any extra debugging i could enable that could pinpoint the issue ?


--

Sander



> Regards,

>         Hans

>> 
>> --
>> Sander
>> 
>> 
>> [   53.004968] =====================================
>> [   53.004968] [ BUG: bad unlock balance detected! ]
>> [   53.004968] 3.10.0-rc1-20130516-jens+ #1 Not tainted
>> [   53.004968] -------------------------------------
>> [   53.004968] motion/3328 is trying to release lock (&dev->lock) at:
>> [   53.004968] [<ffffffff819be5f9>] mutex_unlock+0x9/0x10
>> [   53.004968] but there are no more locks to release!
>> [   53.004968]
>> [   53.004968] other info that might help us debug this:
>> [   53.004968] 1 lock held by motion/3328:
>> [   53.004968]  #0:  (&mm->mmap_sem){++++++}, at: [<ffffffff81156cae>] vm_munmap+0x3e/0x70
>> [   53.004968]
>> [   53.004968] stack backtrace:
>> [   53.004968] CPU: 1 PID: 3328 Comm: motion Not tainted 3.10.0-rc1-20130516-jens+ #1
>> [   53.004968] Hardware name: Xen HVM domU, BIOS 4.3-unstable 05/16/2013
>> [   53.004968]  ffffffff819be5f9 ffff88002ac35c58 ffffffff819b9029 ffff88002ac35c88
>> [   53.004968]  ffffffff810e615e ffff88002ac35cb8 ffff88002b7c18a8 ffffffff819be5f9
>> [   53.004968]  00000000ffffffff ffff88002ac35d28 ffffffff810eb17e ffffffff810e7ba5
>> [   53.004968] Call Trace:
>> [   53.004968]  [<ffffffff819be5f9>] ? mutex_unlock+0x9/0x10
>> [   53.004968]  [<ffffffff819b9029>] dump_stack+0x19/0x1b
>> [   53.004968]  [<ffffffff810e615e>] print_unlock_imbalance_bug+0xfe/0x110
>> [   53.004968]  [<ffffffff819be5f9>] ? mutex_unlock+0x9/0x10
>> [   53.004968]  [<ffffffff810eb17e>] lock_release_non_nested+0x1ce/0x320
>> [   53.004968]  [<ffffffff810e7ba5>] ? debug_check_no_locks_freed+0x105/0x1b0
>> [   53.353529]  [<ffffffff819be5f9>] ? mutex_unlock+0x9/0x10
>> [   53.353529]  [<ffffffff810eb3cc>] lock_release+0xfc/0x250
>> [   53.353529]  [<ffffffff819be4b2>] __mutex_unlock_slowpath+0xb2/0x1f0
>> [   53.353529]  [<ffffffff819be5f9>] mutex_unlock+0x9/0x10
>> [   53.353529]  [<ffffffff81711105>] videobuf_waiton+0x55/0x230
>> [   53.353529]  [<ffffffff8114d052>] ? tlb_finish_mmu+0x32/0x50
>> [   53.353529]  [<ffffffff81154a46>] ? unmap_region+0xc6/0x100
>> [   53.353529]  [<ffffffff81172e05>] ? kmem_cache_free+0x195/0x230
>> [   53.353529]  [<ffffffff8172d3d9>] cx25821_free_buffer+0x49/0xa0
>> [   53.353529]  [<ffffffff8172f939>] cx25821_buffer_release+0x9/0x10
>> [   53.353529]  [<ffffffff81712c35>] videobuf_vm_close+0xc5/0x160
>> [   53.353529]  [<ffffffff81154aa5>] remove_vma+0x25/0x60
>> [   53.353529]  [<ffffffff81156b67>] do_munmap+0x307/0x410
>> [   53.353529]  [<ffffffff81156cbc>] vm_munmap+0x4c/0x70
>> [   53.353529]  [<ffffffff81157c09>] SyS_munmap+0x9/0x10
>> [   53.353529]  [<ffffffff819c20a9>] system_call_fastpath+0x16/0x1b
>> 


