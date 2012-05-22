Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:35486 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040Ab2EVObR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 May 2012 10:31:17 -0400
Received: by wgbdr13 with SMTP id dr13so6141993wgb.1
        for <linux-media@vger.kernel.org>; Tue, 22 May 2012 07:31:16 -0700 (PDT)
Date: Tue, 22 May 2012 16:32:34 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: Rob Clark <rob.clark@linaro.org>, linaro-mm-sig@lists.linaro.org,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	patches@linaro.org, sumit.semwal@linaro.org, daniel@ffwll.ch,
	airlied@redhat.com, Rob Clark <rob@ti.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	=?utf-8?B?J+uwleqyveuvvCc=?= <kyungmin.park@samsung.com>,
	InKi Dae <daeinki@gmail.com>
Subject: Re: [PATCH] dma-buf: add get_dma_buf()
Message-ID: <20120522143234.GC4629@phenom.ffwll.local>
References: <1331913881-13105-1-git-send-email-rob.clark@linaro.org>
 <4FBB98E0.8040600@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FBB98E0.8040600@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 22, 2012 at 03:47:12PM +0200, Tomasz Stanislawski wrote:
> Hi,
> I think I discovered an interesting issue with dma_buf.
> I found out that dma_buf_fd does not increase reference
> count for dma_buf::file. This leads to potential kernel
> crash triggered by user space. Please, take a look on
> the scenario below:
> 
> The applications spawns two thread. One of them is exporting DMABUF.
> 
>       Thread I         |   Thread II       | Comments
> -----------------------+-------------------+-----------------------------------
> dbuf = dma_buf_export  |                   | dma_buf is creates, refcount is 1
> fd = dma_buf_fd(dbuf)  |                   | assume fd is set to 42, refcount is still 1
>                        |      close(42)    | The file descriptor is closed asynchronously, dbuf's refcount drops to 0
>                        |  dma_buf_release  | dbuf structure is freed, dbuf becomes a dangling pointer
> int size = dbuf->size; |                   | the dbuf is dereferenced, causing a kernel crash
> -----------------------+-------------------+-----------------------------------
> 
> I think that the problem could be fixed in two ways.
> a) forcing driver developer to call get_dma_buf just before calling dma_buf_fd.
> b) increasing dma_buf->file's reference count at dma_buf_fd
> 
> I prefer solution (b) because it prevents symmetry between dma_buf_fd and close.
> I mean that dma_buf_fd increases reference count, close decreases it.
> 
> What is your opinion about the issue?

I guess most exporters would like to hang onto the exported dma_buf a bit
and hence need a reference (e.g. to cache the dma_buf as long as the
underlying buffer object exists). So I guess we can change the semantics
of dma_buf_fd from transferring the reference you currently have (and
hence forbidding any further access by the caller) to grabbing a reference
of it's on for the fd that is created.
-Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
