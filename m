Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-1.cisco.com ([144.254.224.140]:13926 "EHLO
	ams-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764Ab1LMNd5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Dec 2011 08:33:57 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linaro-mm-sig@lists.linaro.org
Subject: Re: [Linaro-mm-sig] [RFC v2 1/2] dma-buf: Introduce dma buffer sharing mechanism
Date: Tue, 13 Dec 2011 14:33:31 +0100
Cc: Daniel Vetter <daniel@ffwll.ch>, Arnd Bergmann <arnd@arndb.de>,
	linux@arm.linux.org.uk, "Semwal, Sumit" <sumit.semwal@ti.com>,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org
References: <1322816252-19955-1-git-send-email-sumit.semwal@ti.com> <201112071340.35267.arnd@arndb.de> <CAKMK7uFQiiUbkU-7c3Os0d0FJNyLbqS2HLPRLy3LGnOoCXV5Pw@mail.gmail.com>
In-Reply-To: <CAKMK7uFQiiUbkU-7c3Os0d0FJNyLbqS2HLPRLy3LGnOoCXV5Pw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201112131433.32051.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(I've been away for the past two weeks, so I'm only now catching up)


On Thursday 08 December 2011 22:44:08 Daniel Vetter wrote:
> On Wed, Dec 7, 2011 at 14:40, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Wednesday 07 December 2011, Semwal, Sumit wrote:
> >> Thanks for the excellent discussion - it indeed is very good learning
> >> for the relatively-inexperienced me :)
> >> 
> >> So, for the purpose of dma-buf framework, could I summarize the
> >> following and rework accordingly?:
> >> 1. remove mmap() dma_buf_op [and mmap fop], and introduce cpu_start(),
> >> cpu_finish() ops to bracket cpu accesses to the buffer. Also add
> >> DMABUF_CPU_START / DMABUF_CPU_FINI IOCTLs?
> > 
> > I think we'd be better off for now without the extra ioctls and
> > just document that a shared buffer must not be exported to user
> > space using mmap at all, to avoid those problems. Serialization
> > between GPU and CPU is on a higher level than the dma_buf framework
> > IMHO.
> 
> Agreed.
> 
> >> 2. remove sg_sync* ops for now (and we'll see if we need to add them
> >> later if needed)
> > 
> > Just removing the sg_sync_* operations is not enough. We have to make
> > the decision whether we want to allow
> > a) only coherent mappings of the buffer into kernel memory (requiring
> > an extension to the dma_map_ops on ARM to not flush caches at map/unmap
> > time)
> > b) not allowing any in-kernel mappings (same requirement on ARM, also
> > limits the usefulness of the dma_buf if we cannot access it from the
> > kernel or from user space)
> > c) only allowing streaming mappings, even if those are non-coherent
> > (requiring strict serialization between CPU (in-kernel) and dma users of
> > the buffer)
> 
> I think only allowing streaming access makes the most sense:
> - I don't see much (if any need) for the kernel to access a dma_buf -
> in all current usecases it just contains pixel data and no hw-specific
> things (like sg tables, command buffers, ..). At most I see the need
> for the kernel to access the buffer for dma bounce buffers, but that
> is internal to the dma subsystem (and hence does not need to be
> exposed).

There are a few situations where the kernel might actually access a dma_buf:

First of all there are some sensors that add meta data before the actual
pixel data, and a kernel driver might well want to read out that data and
process it. Secondly (and really very similar), video frames sent to/from
an FPGA can also contain meta data (Cisco does that on some of our products)
that the kernel may need to inspect.

I admit that these use-cases aren't very common, but they do exist.

> - Userspace can still access the contents through the exporting
> subsystem (e.g. use some gem mmap support). For efficiency reason gpu
> drivers are already messing around with cache coherency in a platform
> specific way (and hence violated the dma api a bit), so we could stuff
> the mmap coherency in there, too. When we later on extend dma_buf
> support so that other drivers than the gpu can export dma_bufs, we can
> then extend the official dma api with already a few drivers with
> use-patterns around.
> 
> But I still think that the kernel must not be required to enforce
> correct access ordering for the reasons outlined in my other mail.

I agree with Daniel on this.

BTW, the V4L2 subsystem has a clear concept of passing bufffer ownership: the
VIDIOC_QBUF and VIDIOC_DQBUF ioctls deal with that. Pretty much all V4L2 apps 
request the buffers, then mmap them, then call QBUF to give the ownership of 
those buffers to the kernel. While the kernel owns those buffers any access to 
the mmap'ped memory leads to undefined results. Only after calling DQBUF can 
userspace actually safely access that memory.

Allowing mmap() on the dma_buf's fd would actually make things easier for 
V4L2. It's an elegant way of mapping the memory.

Regards,

	Hans
