Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:42388 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757431Ab2EVPNQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 May 2012 11:13:16 -0400
Received: by yenm10 with SMTP id m10so5466598yen.19
        for <linux-media@vger.kernel.org>; Tue, 22 May 2012 08:13:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAKMK7uGwAo48cGpevwfjcnvMkNiimsq0nwkZJT6cSsGWP8FRWw@mail.gmail.com>
References: <1331913881-13105-1-git-send-email-rob.clark@linaro.org>
	<4FBB98E0.8040600@samsung.com>
	<20120522143234.GC4629@phenom.ffwll.local>
	<4FBBAA0F.6090503@samsung.com>
	<CAKMK7uGwAo48cGpevwfjcnvMkNiimsq0nwkZJT6cSsGWP8FRWw@mail.gmail.com>
Date: Tue, 22 May 2012 16:13:15 +0100
Message-ID: <CAPM=9tyd4sx_RiKSXThzAocC5xC7NAhQB+HVmvoxXCLvWodU-w@mail.gmail.com>
Subject: Re: [PATCH] dma-buf: add get_dma_buf()
From: Dave Airlie <airlied@gmail.com>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>, patches@linaro.org,
	dri-devel@lists.freedesktop.org, Rob Clark <rob.clark@linaro.org>,
	linaro-mm-sig@lists.linaro.org,
	=?UTF-8?B?67CV6rK966+8?= <kyungmin.park@samsung.com>,
	Rob Clark <rob@ti.com>, airlied@redhat.com,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	sumit.semwal@linaro.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 22, 2012 at 4:05 PM, Daniel Vetter <daniel@ffwll.ch> wrote:
> On Tue, May 22, 2012 at 5:00 PM, Tomasz Stanislawski
> <t.stanislaws@samsung.com> wrote:
>> On 05/22/2012 04:32 PM, Daniel Vetter wrote:
>>> On Tue, May 22, 2012 at 03:47:12PM +0200, Tomasz Stanislawski wrote:
>>>> Hi,
>>>> I think I discovered an interesting issue with dma_buf.
>>>> I found out that dma_buf_fd does not increase reference
>>>> count for dma_buf::file. This leads to potential kernel
>>>> crash triggered by user space. Please, take a look on
>>>> the scenario below:
>>>>
>>>> The applications spawns two thread. One of them is exporting DMABUF.
>>>>
>>>>       Thread I         |   Thread II       | Comments
>>>> -----------------------+-------------------+-----------------------------------
>>>> dbuf = dma_buf_export  |                   | dma_buf is creates, refcount is 1
>>>> fd = dma_buf_fd(dbuf)  |                   | assume fd is set to 42, refcount is still 1
>>>>                        |      close(42)    | The file descriptor is closed asynchronously, dbuf's refcount drops to 0
>>>>                        |  dma_buf_release  | dbuf structure is freed, dbuf becomes a dangling pointer
>>>> int size = dbuf->size; |                   | the dbuf is dereferenced, causing a kernel crash
>>>> -----------------------+-------------------+-----------------------------------
>>>>
>>>> I think that the problem could be fixed in two ways.
>>>> a) forcing driver developer to call get_dma_buf just before calling dma_buf_fd.
>>>> b) increasing dma_buf->file's reference count at dma_buf_fd
>>>>
>>>> I prefer solution (b) because it prevents symmetry between dma_buf_fd and close.
>>>> I mean that dma_buf_fd increases reference count, close decreases it.
>>>>
>>>> What is your opinion about the issue?
>>>
>>> I guess most exporters would like to hang onto the exported dma_buf a bit
>>> and hence need a reference (e.g. to cache the dma_buf as long as the
>>> underlying buffer object exists). So I guess we can change the semantics
>>> of dma_buf_fd from transferring the reference you currently have (and
>>> hence forbidding any further access by the caller) to grabbing a reference
>>> of it's on for the fd that is created.
>>> -Daniel
>>
>> Hi Daniel,
>> Would it be simpler, safer and more intuitive if dma_buf_fd increased
>> dmabuf->file's reference counter?
>
> That's actually what I wanted to say. Message seems to have been lost
> in transit ;-)

Now I've thought about it and Tomasz has pointed it out I agree,

Now we just have to work out when to drop that reference, which I
don't see anyone addressing :-)

I love lifetime rules.

Dave.
