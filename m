Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:51047 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753199AbbFRMo7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Jun 2015 08:44:59 -0400
Date: Thu, 18 Jun 2015 09:44:53 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Jan Kara <jack@suse.cz>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git:media_tree/master] [media] vb2: Push mmap_sem down to
 memops
Message-ID: <20150618094453.5600f08d@recife.lan>
In-Reply-To: <20150618101208.GE21820@quack.suse.cz>
References: <E1Yo8Jc-0000K9-Sd@www.linuxtv.org>
	<55794C46.10501@xs4all.nl>
	<20150618101208.GE21820@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jan,

Please keep Andrew in the loop. The patch series is on his tree.

Regards,
Mauro

Em Thu, 18 Jun 2015 12:12:08 +0200
Jan Kara <jack@suse.cz> escreveu:

> On Thu 11-06-15 10:52:22, Hans Verkuil wrote:
> > Jan,
> > 
> > This patch causes a regressing in videobuf2-dma-sg with a potential deadlock:
> > 
> > [   82.290231] ======================================================
> > [   82.290232] [ INFO: possible circular locking dependency detected ]
> > [   82.290235] 4.1.0-rc3-tb1 #12 Not tainted
> > [   82.290236] -------------------------------------------------------
> > [   82.290238] qv4l2/1262 is trying to acquire lock:
> > [   82.290240]  (&mm->mmap_sem){++++++}, at: [<ffffffffa007a870>] vb2_dma_sg_put_userptr+0xf0/0x170 [videobuf2_dma_sg]
> > [   82.290247]
> >                but task is already holding lock:
> > [   82.290249]  (&q->mmap_lock){+.+.+.}, at: [<ffffffffa006a9ec>] __reqbufs.isra.13+0x7c/0x410 [videobuf2_core]
> > [   82.290255]
> >                which lock already depends on the new lock.
> 
> Thanks for the report! So I finally got to this after returning from
> vacation and dealing with more urgent stuff. Looking more at the code it
> seems to me that this particular code path going through
> vb2_ioctl_reqbufs() didn't have previously any mmap_sem protection. Thus we
> could call vma->vm_ops->close() from vb2_put_vma() without holding mmap_sem
> which is against the locking protocol.
> 
> My patch unintentionally fixed this but that introduced the lock inversion
> lockdep complains about. Now the full series removes the need for getting
> VMA reference in videobuf2 code so we don't need mmap_sem in put_userptr
> callbacks at all. So when the whole series is applied we are fine again.
> 
> So how shall we proceed? Just slap this patch at the beginning of the
> series to make sure it gets merged at once so the lock inversion isn't
> there for long? Or alternatively I can just remove mmap_sem from
> put_userptr() in this series. That will somewhat increase the amount of
> calls to vma->vm_ops->close() without mmap_sem util the whole series is
> applied. Any opinions guys?
> 
> 								Honza
> > [   82.290257]
> >                the existing dependency chain (in reverse order) is:
> > [   82.290259]
> >                -> #1 (&q->mmap_lock){+.+.+.}:
> > [   82.290262]        [<ffffffff8110bab9>] lock_acquire+0xc9/0x290
> > [   82.290267]        [<ffffffff81a9fc1e>] mutex_lock_nested+0x4e/0x3f0
> > [   82.290270]        [<ffffffffa00654a2>] vb2_mmap+0x232/0x350 [videobuf2_core]
> > [   82.290273]        [<ffffffffa0067ab5>] vb2_fop_mmap+0x25/0x30 [videobuf2_core]
> > [   82.290276]        [<ffffffffa002d11a>] v4l2_mmap+0x5a/0x90 [videodev]
> > [   82.290281]        [<ffffffff811f4bcb>] mmap_region+0x3bb/0x5f0
> > [   82.290285]        [<ffffffff811f511f>] do_mmap_pgoff+0x31f/0x400
> > [   82.290288]        [<ffffffff811dfbe0>] vm_mmap_pgoff+0x90/0xc0
> > [   82.290291]        [<ffffffff811f35af>] SyS_mmap_pgoff+0x1df/0x290
> > [   82.290294]        [<ffffffff8105ef42>] SyS_mmap+0x22/0x30
> > [   82.290297]        [<ffffffff81aa4517>] system_call_fastpath+0x12/0x6f
> > [   82.290300]
> >                -> #0 (&mm->mmap_sem){++++++}:
> > [   82.290303]        [<ffffffff8110adb3>] __lock_acquire+0x1d53/0x1fe0
> > [   82.290306]        [<ffffffff8110bab9>] lock_acquire+0xc9/0x290
> > [   82.290308]        [<ffffffff81aa1924>] down_read+0x34/0x50
> > [   82.290311]        [<ffffffffa007a870>] vb2_dma_sg_put_userptr+0xf0/0x170 [videobuf2_dma_sg]
> > [   82.290314]        [<ffffffffa0066656>] __vb2_queue_free+0x156/0x5f0 [videobuf2_core]
> > [   82.290317]        [<ffffffffa006aa0f>] __reqbufs.isra.13+0x9f/0x410 [videobuf2_core]
> > [   82.290320]        [<ffffffffa006b084>] vb2_ioctl_reqbufs+0x74/0xb0 [videobuf2_core]
> > [   82.290323]        [<ffffffffa0033d83>] v4l_reqbufs+0x43/0x50 [videodev]
> > [   82.290327]        [<ffffffffa00329f4>] __video_do_ioctl+0x274/0x310 [videodev]
> > [   82.290331]        [<ffffffffa00349a8>] video_usercopy+0x378/0x8f0 [videodev]
> > [   82.290336]        [<ffffffffa0034f35>] video_ioctl2+0x15/0x20 [videodev]
> > [   82.290340]        [<ffffffffa002d6d0>] v4l2_ioctl+0xd0/0xf0 [videodev]
> > [   82.290343]        [<ffffffff81238258>] do_vfs_ioctl+0x308/0x540
> > [   82.290347]        [<ffffffff81238511>] SyS_ioctl+0x81/0xa0
> > [   82.290349]        [<ffffffff81aa4517>] system_call_fastpath+0x12/0x6f
> > [   82.290352]
> >                other info that might help us debug this:
> > 
> > [   82.290354]  Possible unsafe locking scenario:
> > 
> > [   82.290356]        CPU0                    CPU1
> > [   82.290357]        ----                    ----
> > [   82.290358]   lock(&q->mmap_lock);
> > [   82.290360]                                lock(&mm->mmap_sem);
> > [   82.290362]                                lock(&q->mmap_lock);
> > [   82.290365]   lock(&mm->mmap_sem);
> > [   82.290367]
> >                 *** DEADLOCK ***
> > 
> > [   82.290369] 2 locks held by qv4l2/1262:
> > [   82.290370]  #0:  (&s->lock){+.+.+.}, at: [<ffffffffa002d65f>] v4l2_ioctl+0x5f/0xf0 [videodev]
> > [   82.290376]  #1:  (&q->mmap_lock){+.+.+.}, at: [<ffffffffa006a9ec>] __reqbufs.isra.13+0x7c/0x410 [videobuf2_core]
> > [   82.290382]
> >                stack backtrace:
> > [   82.290385] CPU: 1 PID: 1262 Comm: qv4l2 Not tainted 4.1.0-rc3-tb1 #12
> > [   82.290387] Hardware name:                  /DH67CF, BIOS BLH6710H.86A.0105.2011.0301.1654 03/01/2011
> > [   82.290388]  ffffffff82c46890 ffff8800b4bfb968 ffffffff81a98687 0000000000000007
> > [   82.290392]  ffffffff82c46890 ffff8800b4bfb9b8 ffffffff8110785d 0000000000000000
> > [   82.290395]  ffff8800b4bfba28 0000000000000001 ffff8800d51ce718 0000000000000001
> > [   82.290399] Call Trace:
> > [   82.290402]  [<ffffffff81a98687>] dump_stack+0x4f/0x7b
> > [   82.290405]  [<ffffffff8110785d>] print_circular_bug+0x1cd/0x230
> > [   82.290407]  [<ffffffff8110adb3>] __lock_acquire+0x1d53/0x1fe0
> > [   82.290411]  [<ffffffff812142b9>] ? kfree+0x169/0x570
> > [   82.290414]  [<ffffffff8110bab9>] lock_acquire+0xc9/0x290
> > [   82.290416]  [<ffffffffa007a870>] ? vb2_dma_sg_put_userptr+0xf0/0x170 [videobuf2_dma_sg]
> > [   82.290419]  [<ffffffff81aa1924>] down_read+0x34/0x50
> > [   82.290421]  [<ffffffffa007a870>] ? vb2_dma_sg_put_userptr+0xf0/0x170 [videobuf2_dma_sg]
> > [   82.290424]  [<ffffffffa007a870>] vb2_dma_sg_put_userptr+0xf0/0x170 [videobuf2_dma_sg]
> > [   82.290427]  [<ffffffffa0066656>] __vb2_queue_free+0x156/0x5f0 [videobuf2_core]
> > [   82.290430]  [<ffffffffa006aa0f>] __reqbufs.isra.13+0x9f/0x410 [videobuf2_core]
> > [   82.290434]  [<ffffffff811c8a59>] ? free_hot_cold_page+0x159/0x200
> > [   82.290437]  [<ffffffffa006b084>] vb2_ioctl_reqbufs+0x74/0xb0 [videobuf2_core]
> > [   82.290441]  [<ffffffffa0033d83>] v4l_reqbufs+0x43/0x50 [videodev]
> > [   82.290445]  [<ffffffffa00329f4>] __video_do_ioctl+0x274/0x310 [videodev]
> > [   82.290449]  [<ffffffffa0032780>] ? v4l_querycap+0x70/0x70 [videodev]
> > [   82.290453]  [<ffffffffa00349a8>] video_usercopy+0x378/0x8f0 [videodev]
> > [   82.290456]  [<ffffffff81108b11>] ? mark_held_locks+0x71/0xa0
> > [   82.290458]  [<ffffffff81108d4d>] ? trace_hardirqs_on+0xd/0x10
> > [   82.290461]  [<ffffffff81a9f98e>] ? mutex_lock_interruptible_nested+0x25e/0x4a0
> > [   82.290464]  [<ffffffffa002d65f>] ? v4l2_ioctl+0x5f/0xf0 [videodev]
> > [   82.290468]  [<ffffffffa002d65f>] ? v4l2_ioctl+0x5f/0xf0 [videodev]
> > [   82.290472]  [<ffffffffa0034f35>] video_ioctl2+0x15/0x20 [videodev]
> > [   82.290475]  [<ffffffffa002d6d0>] v4l2_ioctl+0xd0/0xf0 [videodev]
> > [   82.290478]  [<ffffffff81238258>] do_vfs_ioctl+0x308/0x540
> > [   82.290481]  [<ffffffff8124476c>] ? __fget_light+0x6c/0xa0
> > [   82.290484]  [<ffffffff81238511>] SyS_ioctl+0x81/0xa0
> > [   82.290487]  [<ffffffff81aa4517>] system_call_fastpath+0x12/0x6f
> > 
> > The problem is that the mmap_sem is now taken in vb2_dma_sg_put_userptr() when
> > that didn't happen before. This is fine when called from __qbuf_userptr, but
> > not when called from __vb2_queue_free. I will see if I have time to dig into
> > this during the weekend and solve it, but if not, then this has to be reverted
> > and the get_vaddr_frames() patch series postponed since it depends on this one.
> > 
> > Regards,
> > 
> > 	Hans
> > 
> > On 05/01/15 12:17, Mauro Carvalho Chehab wrote:
> > > This is an automatic generated email to let you know that the following patch were queued at the 
> > > http://git.linuxtv.org/cgit.cgi/media_tree.git tree:
> > > 
> > > Subject: [media] vb2: Push mmap_sem down to memops
> > > Author:  Jan Kara <jack@suse.cz>
> > > Date:    Tue Mar 17 08:56:31 2015 -0300
> > > 
> > > Currently vb2 core acquires mmap_sem just around call to
> > > __qbuf_userptr(). However since commit f035eb4e976ef5 (videobuf2: fix
> > > lockdep warning) it isn't necessary to acquire it so early as we no
> > > longer have to drop queue mutex before acquiring mmap_sem. So push
> > > acquisition of mmap_sem down into .get_userptr and .put_userptr memops
> > > so that the semaphore is acquired for a shorter time and it is clearer
> > > what it is needed for.
> > > 
> > > Signed-off-by: Jan Kara <jack@suse.cz>
> > > Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> > > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> > > 
> > >  drivers/media/v4l2-core/videobuf2-core.c       |    2 --
> > >  drivers/media/v4l2-core/videobuf2-dma-contig.c |    7 +++++++
> > >  drivers/media/v4l2-core/videobuf2-dma-sg.c     |    6 ++++++
> > >  drivers/media/v4l2-core/videobuf2-vmalloc.c    |    6 +++++-
> > >  4 files changed, 18 insertions(+), 3 deletions(-)
> > > 
> > > ---
> > > 
> > > http://git.linuxtv.org/cgit.cgi/media_tree.git/commit/?id=48b25a3a713b90988b6882d318f7c0a6bed9aabc
> > > 
> > > diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> > > index 66ada01..20cdbc0 100644
> > > --- a/drivers/media/v4l2-core/videobuf2-core.c
> > > +++ b/drivers/media/v4l2-core/videobuf2-core.c
> > > @@ -1657,9 +1657,7 @@ static int __buf_prepare(struct vb2_buffer *vb, const struct v4l2_buffer *b)
> > >  		ret = __qbuf_mmap(vb, b);
> > >  		break;
> > >  	case V4L2_MEMORY_USERPTR:
> > > -		down_read(&current->mm->mmap_sem);
> > >  		ret = __qbuf_userptr(vb, b);
> > > -		up_read(&current->mm->mmap_sem);
> > >  		break;
> > >  	case V4L2_MEMORY_DMABUF:
> > >  		ret = __qbuf_dmabuf(vb, b);
> > > diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> > > index 644dec7..620c4aa 100644
> > > --- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
> > > +++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> > > @@ -532,7 +532,9 @@ static void vb2_dc_put_userptr(void *buf_priv)
> > >  		sg_free_table(sgt);
> > >  		kfree(sgt);
> > >  	}
> > > +	down_read(&current->mm->mmap_sem);
> > >  	vb2_put_vma(buf->vma);
> > > +	up_read(&current->mm->mmap_sem);
> > >  	kfree(buf);
> > >  }
> > >  
> > > @@ -616,6 +618,7 @@ static void *vb2_dc_get_userptr(void *alloc_ctx, unsigned long vaddr,
> > >  		goto fail_buf;
> > >  	}
> > >  
> > > +	down_read(&current->mm->mmap_sem);
> > >  	/* current->mm->mmap_sem is taken by videobuf2 core */
> > >  	vma = find_vma(current->mm, vaddr);
> > >  	if (!vma) {
> > > @@ -642,6 +645,7 @@ static void *vb2_dc_get_userptr(void *alloc_ctx, unsigned long vaddr,
> > >  	if (ret) {
> > >  		unsigned long pfn;
> > >  		if (vb2_dc_get_user_pfn(start, n_pages, vma, &pfn) == 0) {
> > > +			up_read(&current->mm->mmap_sem);
> > >  			buf->dma_addr = vb2_dc_pfn_to_dma(buf->dev, pfn);
> > >  			buf->size = size;
> > >  			kfree(pages);
> > > @@ -651,6 +655,7 @@ static void *vb2_dc_get_userptr(void *alloc_ctx, unsigned long vaddr,
> > >  		pr_err("failed to get user pages\n");
> > >  		goto fail_vma;
> > >  	}
> > > +	up_read(&current->mm->mmap_sem);
> > >  
> > >  	sgt = kzalloc(sizeof(*sgt), GFP_KERNEL);
> > >  	if (!sgt) {
> > > @@ -713,10 +718,12 @@ fail_get_user_pages:
> > >  		while (n_pages)
> > >  			put_page(pages[--n_pages]);
> > >  
> > > +	down_read(&current->mm->mmap_sem);
> > >  fail_vma:
> > >  	vb2_put_vma(buf->vma);
> > >  
> > >  fail_pages:
> > > +	up_read(&current->mm->mmap_sem);
> > >  	kfree(pages); /* kfree is NULL-proof */
> > >  
> > >  fail_buf:
> > > diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c b/drivers/media/v4l2-core/videobuf2-dma-sg.c
> > > index 45c708e..afd4b51 100644
> > > --- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
> > > +++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c
> > > @@ -263,6 +263,7 @@ static void *vb2_dma_sg_get_userptr(void *alloc_ctx, unsigned long vaddr,
> > >  	if (!buf->pages)
> > >  		goto userptr_fail_alloc_pages;
> > >  
> > > +	down_read(&current->mm->mmap_sem);
> > >  	vma = find_vma(current->mm, vaddr);
> > >  	if (!vma) {
> > >  		dprintk(1, "no vma for address %lu\n", vaddr);
> > > @@ -301,6 +302,7 @@ static void *vb2_dma_sg_get_userptr(void *alloc_ctx, unsigned long vaddr,
> > >  					     1, /* force */
> > >  					     buf->pages,
> > >  					     NULL);
> > > +	up_read(&current->mm->mmap_sem);
> > >  
> > >  	if (num_pages_from_user != buf->num_pages)
> > >  		goto userptr_fail_get_user_pages;
> > > @@ -328,8 +330,10 @@ userptr_fail_get_user_pages:
> > >  	if (!vma_is_io(buf->vma))
> > >  		while (--num_pages_from_user >= 0)
> > >  			put_page(buf->pages[num_pages_from_user]);
> > > +	down_read(&current->mm->mmap_sem);
> > >  	vb2_put_vma(buf->vma);
> > >  userptr_fail_find_vma:
> > > +	up_read(&current->mm->mmap_sem);
> > >  	kfree(buf->pages);
> > >  userptr_fail_alloc_pages:
> > >  	kfree(buf);
> > > @@ -362,7 +366,9 @@ static void vb2_dma_sg_put_userptr(void *buf_priv)
> > >  			put_page(buf->pages[i]);
> > >  	}
> > >  	kfree(buf->pages);
> > > +	down_read(&current->mm->mmap_sem);
> > >  	vb2_put_vma(buf->vma);
> > > +	up_read(&current->mm->mmap_sem);
> > >  	kfree(buf);
> > >  }
> > >  
> > > diff --git a/drivers/media/v4l2-core/videobuf2-vmalloc.c b/drivers/media/v4l2-core/videobuf2-vmalloc.c
> > > index 657ab30..0ba40be 100644
> > > --- a/drivers/media/v4l2-core/videobuf2-vmalloc.c
> > > +++ b/drivers/media/v4l2-core/videobuf2-vmalloc.c
> > > @@ -89,7 +89,7 @@ static void *vb2_vmalloc_get_userptr(void *alloc_ctx, unsigned long vaddr,
> > >  	offset = vaddr & ~PAGE_MASK;
> > >  	buf->size = size;
> > >  
> > > -
> > > +	down_read(&current->mm->mmap_sem);
> > >  	vma = find_vma(current->mm, vaddr);
> > >  	if (vma && (vma->vm_flags & VM_PFNMAP) && (vma->vm_pgoff)) {
> > >  		if (vb2_get_contig_userptr(vaddr, size, &vma, &physp))
> > > @@ -121,6 +121,7 @@ static void *vb2_vmalloc_get_userptr(void *alloc_ctx, unsigned long vaddr,
> > >  		if (!buf->vaddr)
> > >  			goto fail_get_user_pages;
> > >  	}
> > > +	up_read(&current->mm->mmap_sem);
> > >  
> > >  	buf->vaddr += offset;
> > >  	return buf;
> > > @@ -133,6 +134,7 @@ fail_get_user_pages:
> > >  	kfree(buf->pages);
> > >  
> > >  fail_pages_array_alloc:
> > > +	up_read(&current->mm->mmap_sem);
> > >  	kfree(buf);
> > >  
> > >  	return NULL;
> > > @@ -144,6 +146,7 @@ static void vb2_vmalloc_put_userptr(void *buf_priv)
> > >  	unsigned long vaddr = (unsigned long)buf->vaddr & PAGE_MASK;
> > >  	unsigned int i;
> > >  
> > > +	down_read(&current->mm->mmap_sem);
> > >  	if (buf->pages) {
> > >  		if (vaddr)
> > >  			vm_unmap_ram((void *)vaddr, buf->n_pages);
> > > @@ -157,6 +160,7 @@ static void vb2_vmalloc_put_userptr(void *buf_priv)
> > >  		vb2_put_vma(buf->vma);
> > >  		iounmap((__force void __iomem *)buf->vaddr);
> > >  	}
> > > +	up_read(&current->mm->mmap_sem);
> > >  	kfree(buf);
> > >  }
> > >  
> > > 
> > > _______________________________________________
> > > linuxtv-commits mailing list
> > > linuxtv-commits@linuxtv.org
> > > http://www.linuxtv.org/cgi-bin/mailman/listinfo/linuxtv-commits
> > > 
