Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39616 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752666Ab2DTNhN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Apr 2012 09:37:13 -0400
Message-ID: <4F916660.7040608@redhat.com>
Date: Fri, 20 Apr 2012 10:36:32 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: =?UTF-8?B?UsOpbWkgRGVuaXMtQ291cm1vbnQ=?= <remi@remlab.net>
CC: Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sumit.semwal@ti.com, daeinki@gmail.com,
	daniel.vetter@ffwll.ch, robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, hverkuil@xs4all.nl,
	subashrp@gmail.com
Subject: Re: [PATCH v4 02/14] Documentation: media: description of DMABUF
 importing in V4L2
References: <1334332076-28489-1-git-send-email-t.stanislaws@samsung.com> <1334332076-28489-3-git-send-email-t.stanislaws@samsung.com> <13761406.oTf8ZzmZpQ@avalon> <4F9021FE.2070903@samsung.com> <4F907798.3000304@redhat.com> <4F912141.8060200@samsung.com> <d24e8c6e35352ed5800161713f728591@chewa.net>
In-Reply-To: <d24e8c6e35352ed5800161713f728591@chewa.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 20-04-2012 07:56, Rémi Denis-Courmont escreveu:
> On Fri, 20 Apr 2012 10:41:37 +0200, Tomasz Stanislawski
> <t.stanislaws@samsung.com> wrote:
>>> Am I understanding wrong or are you saying that you want to drop
> userptr
>>> from V4L2 API in long-term? If so, why?
>>
>> Dropping userptr is just some brainstorming idea.
>> It was found out that userptr is not a good mean
>> for buffer exchange between to two devices.
> 
> I can believe that. But I am also inclined to believe that DMABUF is
> targetted at device-to-device transfer, while USERPTR is targetted at
> device-to-user (or user-to-device) transfers. Are you saying applications
> should use DMABUF and memory map the buffers? Or would you care to explain
> how DMABUF addresses the problem space of USERPTR?

I agree with Rémi. Userptr were never meant to be used by dev2dev
transfer. The overlay mode were designed for it.

I remember I've pointed it a few times at the mailing list.

The DMABUF is the proper replacement for the overlay mode, and, after
having it fully implemented, we can deprecate and remove the overlay
mode.
> 
>> The USERPTR simplifies userspace code but introduce
>> a lot of complexity problems for the kernel drivers
>> and frameworks.
> 
> It is not only a simplification. In some cases, USERPTR is the only I/O
> method that supports zero copy in pretty much any circumstance. When the
> user cannot reliably predict the maximum number of required buffers,
> predicts a value larger than the device will negotiate, or needs buffers to
> outlive STREAMOFF (?), MMAP requires memory copying. USERPTR does not.

Yes, that's my understand too. USERPTR works helps to
avoid buffer copying.
> 
> Now, I do realize that some devices cannot support USERPTR efficiently,
> then they should not support USERPTR. But for those devices that can, it
> seems quite a nice performance enhancement.

Agreed.

A quick note about that: for USB devices, with the current implementations,
there will always be a copy inside the Kernel, as the USB and other transport
headers should be removed.

For them, the cost of MMAP and USERPTR is the same (not all USB drivers
export USERPTR, because of a limitation at videobuf-vmalloc).

>> The problem is that memory mmaped to the userspace may
>> not be a part of the system memory. It often happens for
>> devices that use remap_pfn or dma_mmap_* to mmap the
>> memory to the userspace.
>> 
>> It is was empirically conjured the it is not possible
>> to access this kind of memory by the other device
>> without a platform-specific hacks or workarounds.

As I warned in the past: USERPTR were never meant to be used 
for dev2dev transfers.

>> 
>> The DMABUF was introduced to help in such a case.
>> 
>> The basic short-term idea is to drop userptr support for
>> buffers that are MMAPed by other device.

You should, instead, just drop userptr support on devices where
DMA scatter/gather is not supported, and migrate all dev2dev
use cases to DMABUF.

>> 
>> The userptr will be used for memory allocated using malloc
>> (anonymous pages) or (maybe) mmaped files. There are of
>> course cache synchronization problems but there are
>> a lesser concern.
>> 
>> However this approach will work only for devices that
>> have its own IOMMU which can be configured to access system
>> memory. Otherwise, the memory has to copied anyway
>> to device's own buffers.
>> 
>> Moreover copying a large amount of data should not happen
>> in the kernel-space.
>> 
>> All the reasons make userptr an unreliable and complex to
>> implement feature.
>> 
>> So my rough-idea was to remove USERPTR support from kernel
>> drivers (if possible of course) and to provide an emulation
>> layer in the userspace code like libv4l2.
>> 
>> Please note that it is only a rough idea. Just brainstorming :)

> It is *too early* to start any discussion on this topic.
> Especially until DMABUF is mature enough to become a good
> alternative for userptr.

Looking at the hole picture, dropping USERPTR would only make 
sense if it is broken on dev2user (or user2dev) transfers.

Dropping its usage on dev2dev transfers makes sense, after having
DMABUF implemented. 

Yet, if some userspace application wants to abuse of USERPTR in order
to use it for dev2dev transfer, there's not much that can be done at 
Kernel level.

It makes sense to put a big warn at the V4L2 Docs telling that this
is not officially supported and can cause all sorts of issues at
the machine/system.

Regards,
Mauro

