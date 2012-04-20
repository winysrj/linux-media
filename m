Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:44969 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388Ab2DTIln (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Apr 2012 04:41:43 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1
Received: from euspt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M2R001IRS5PHH80@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 20 Apr 2012 09:41:49 +0100 (BST)
Received: from [106.116.48.223] by spt1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0M2R00MMYS5GS8@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 20 Apr 2012 09:41:41 +0100 (BST)
Date: Fri, 20 Apr 2012 10:41:37 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [PATCH v4 02/14] Documentation: media: description of DMABUF
 importing in V4L2
In-reply-to: <4F907798.3000304@redhat.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sumit.semwal@ti.com, daeinki@gmail.com,
	daniel.vetter@ffwll.ch, robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, hverkuil@xs4all.nl,
	remi@remlab.net, subashrp@gmail.com
Message-id: <4F912141.8060200@samsung.com>
References: <1334332076-28489-1-git-send-email-t.stanislaws@samsung.com>
 <1334332076-28489-3-git-send-email-t.stanislaws@samsung.com>
 <13761406.oTf8ZzmZpQ@avalon> <4F9021FE.2070903@samsung.com>
 <4F907798.3000304@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On 04/19/2012 10:37 PM, Mauro Carvalho Chehab wrote:
> Em 19-04-2012 11:32, Tomasz Stanislawski escreveu:
>  
>> Hi Laurent,
>>
>> One may find similar sentences in MMAP, USERPTR and DMABUF.
>> Maybe the common parts like description of STREAMON/OFF,
>> QBUF/DQBUF shuffling should be moved to separate section
>> like "Streaming" :).
>>
>> Maybe it is worth to introduce a separate patch for this change.
>>
>> Frankly, I would prefer to keep the Doc in the current form till
>> importer support gets merged. Later the Doc could be fixed.
>>
>> BTW. What is the sense of merging userptr and dmabuf section
>> if userptr is going to dropped in long-term?
> 
> I didn't read yet the rest of the thread, so sorry, if I'm making wrong assumptions...
> Am I understanding wrong or are you saying that you want to drop userptr
> from V4L2 API in long-term? If so, why?

Dropping userptr is just some brainstorming idea.
It was found out that userptr is not a good mean
for buffer exchange between to two devices.
The USERPTR simplifies userspace code but introduce
a lot of complexity problems for the kernel drivers
and frameworks.

The problem is that memory mmaped to the userspace may
not be a part of the system memory. It often happens for
devices that use remap_pfn or dma_mmap_* to mmap the
memory to the userspace.

It is was empirically conjured the it is not possible
to access this kind of memory by the other device
without a platform-specific hacks or workarounds.

The DMABUF was introduced to help in such a case.

The basic short-term idea is to drop userptr support for
buffers that are MMAPed by other device.

The userptr will be used for memory allocated using malloc
(anonymous pages) or (maybe) mmaped files. There are of
course cache synchronization problems but there are
a lesser concern.

However this approach will work only for devices that
have its own IOMMU which can be configured to access system
memory. Otherwise, the memory has to copied anyway
to device's own buffers.

Moreover copying a large amount of data should not happen
in the kernel-space.

All the reasons make userptr an unreliable and complex to
implement feature.

So my rough-idea was to remove USERPTR support from kernel
drivers (if possible of course) and to provide an emulation
layer in the userspace code like libv4l2.

Please note that it is only a rough idea. Just brainstorming :)

It is *too early* to start any discussion on this topic.
Especially until DMABUF is mature enough to become a good
alternative for userptr.

Regards,
Tomasz Stanislawski

> 
> Regards,
> Mauro
> 

