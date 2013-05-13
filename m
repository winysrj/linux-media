Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f171.google.com ([209.85.215.171]:51979 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754796Ab3EMT3S (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 May 2013 15:29:18 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: Inki Dae <inki.dae@samsung.com>,
	'Maarten Lankhorst' <maarten.lankhorst@canonical.com>,
	'linux-fbdev' <linux-fbdev@vger.kernel.org>,
	'Kyungmin Park' <kyungmin.park@samsung.com>,
	"'myungjoo.ham'" <myungjoo.ham@samsung.com>,
	'YoungJun Cho' <yj44.cho@samsung.com>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: Introduce a new helper framework for buffer synchronization
Date: Mon, 13 May 2013 21:29:08 +0200
Message-ID: <4008658.mlznVFUzcs@flatron>
In-Reply-To: <027a01ce4fcc$5e7c7320$1b755960$%dae@samsung.com>
References: <CAAQKjZNNw4qddo6bE5OY_CahrqDtqkxdO7Pm9RCguXyj9F4cMQ@mail.gmail.com> <5190B7D8.3010803@canonical.com> <027a01ce4fcc$5e7c7320$1b755960$%dae@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Monday 13 of May 2013 20:24:01 Inki Dae wrote:
> > -----Original Message-----
> > From: Maarten Lankhorst [mailto:maarten.lankhorst@canonical.com]
> > Sent: Monday, May 13, 2013 6:52 PM
> > To: Inki Dae
> > Cc: 'Rob Clark'; 'Daniel Vetter'; 'DRI mailing list'; linux-arm-
> > kernel@lists.infradead.org; linux-media@vger.kernel.org;
> > 'linux-fbdev';
> > 'Kyungmin Park'; 'myungjoo.ham'; 'YoungJun Cho'
> > Subject: Re: Introduce a new helper framework for buffer
> > synchronization> 
> > Op 13-05-13 11:21, Inki Dae schreef:
> > >> -----Original Message-----
> > >> From: Maarten Lankhorst [mailto:maarten.lankhorst@canonical.com]
> > >> Sent: Monday, May 13, 2013 5:01 PM
> > >> To: Inki Dae
> > >> Cc: Rob Clark; Daniel Vetter; DRI mailing list; linux-arm-
> > >> kernel@lists.infradead.org; linux-media@vger.kernel.org;
> > >> linux-fbdev;
> > >> Kyungmin Park; myungjoo.ham; YoungJun Cho
> > >> Subject: Re: Introduce a new helper framework for buffer
> > 
> > synchronization
> > 
> > >> Op 09-05-13 09:33, Inki Dae schreef:
> > >>> Hi all,
> > >>> 
> > >>> This post introduces a new helper framework based on dma fence.
> > >>> And
> > 
> > the
> > 
> > >>> purpose of this post is to collect other opinions and advices
> > >>> before
> > 
> > RFC
> > 
> > >>> posting.
> > >>> 
> > >>> First of all, this helper framework, called fence helper, is in
> > 
> > progress
> > 
> > >>> yet so might not have enough comments in codes and also might need
> > >>> to
> > 
> > be
> > 
> > >>> more cleaned up. Moreover, we might be missing some parts of the
> > >>> dma
> > >> 
> > >> fence.
> > >> 
> > >>> However, I'd like to say that all things mentioned below has been
> > 
> > tested
> > 
> > >>> with Linux platform and worked well.
> > >>> ....
> > >>> 
> > >>> And tutorial for user process.
> > >>> 
> > >>>         just before cpu access
> > >>>         
> > >>>                 struct dma_buf_fence *df;
> > >>>                 
> > >>>                 df->type = DMA_BUF_ACCESS_READ or
> 
> DMA_BUF_ACCESS_WRITE;
> 
> > >>>                 ioctl(fd, DMA_BUF_GET_FENCE, &df);
> > >>>         
> > >>>         after memset or memcpy
> > >>>         
> > >>>                 ioctl(fd, DMA_BUF_PUT_FENCE, &df);
> > >> 
> > >> NAK.
> > >> 
> > >> Userspace doesn't need to trigger fences. It can do a buffer idle
> > >> wait,
> > >> and postpone submitting new commands until after it's done using
> > >> the
> > >> buffer.
> > > 
> > > Hi Maarten,
> > > 
> > > It seems that you say user should wait for a buffer like KDS does:
> > > KDS
> > 
> > uses
> > 
> > > select() to postpone submitting new commands. But I think this way
> > 
> > assumes
> > 
> > > that every data flows a DMA device to a CPU. For example, a CPU
> > > should
> > 
> > keep
> > 
> > > polling for the completion of a buffer access by a DMA device. This
> > 
> > means
> > 
> > > that the this way isn't considered for data flow to opposite case;
> > > CPU
> > 
> > to
> > 
> > > DMA device.
> > 
> > Not really. You do both things the same way. You first wait for the bo
> > to be idle, this could be implemented by adding poll support to the
> > dma-buf fd.
> > Then you either do your read or write. Since userspace is supposed to
> > be the one controlling the bo it should stay idle at that point. If
> > you have another thread queueing
> > the buffer againbefore your thread is done that's a bug in the
> 
> application,
> 
> > and can be solved with userspace locking primitives. No need for the
> > kernel to get involved.
> 
> Yes, that is how we have synchronized buffer between CPU and DMA device
> until now without buffer synchronization mechanism. I thought that it's
> best to make user not considering anything: user can access a buffer
> regardless of any DMA device controlling and the buffer synchronization
> is performed in kernel level. Moreover, I think we could optimize
> graphics and multimedia hardware performance because hardware can do
> more works: one thread accesses a shared buffer and the other controls
> DMA device with the shared buffer in parallel.

Could you explain this point? I thought that if there is a shared buffer 
accessible for user and DMA device, only one of them can use it at the 
moment, i.e. the buffer is useless for the reading user (or read DMA) 
until (write) DMA (or writing user) finishes writing for it. Is it 
incorrect? Or this is not the point here?

I'm not an expert here and I'm just trying to understand the idea, so 
correct me if I'm wrong. Thanks in advance.

Best regards,
Tomasz

> Thus, we could avoid
> sequential processing and that is my intention. Aren't you think about
> that we could improve hardware utilization with such way or other? of
> course, there could be better way.
> 
> > >> Kernel space doesn't need the root hole you created by giving a
> > >> dereferencing a pointer passed from userspace.
> > >> Your next exercise should be to write a security exploit from the
> > >> api
> > 
> > you
> > 
> > >> created here. It's the only way to learn how to write safe code.
> > >> Hint:
> > >> df.ctx = mmap(..);
> > > 
> > > Also I'm not clear to use our way yet and that is why I posted. As
> > > you
> > > mentioned, it seems like that using mmap() is more safe. But there
> > > is
> > 
> > one
> > 
> > > issue it makes me confusing. For your hint, df.ctx = mmap(..), the
> > > issue> 
> > is
> > 
> > > that dmabuf mmap can be used to map a dmabuf with user space. And
> > > the
> > 
> > dmabuf
> > 
> > > means a physical memory region allocated by some allocator such as
> > > drm
> > 
> > gem
> > 
> > > or ion.
> > > 
> > > There might be my missing point so could you please give me more
> > 
> > comments?
> > 
> > My point was that userspace could change df.ctx to some mmap'd memory,
> > forcing the kernel to execute some code prepared by userspace.
> 
> Understood. I have to find a better way. And for this, I'd like to
> listen attentively more opinions and advices.
> 
> Thanks for comments,
> Inki Dae
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
