Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15917 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753207Ab2DWOAi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Apr 2012 10:00:38 -0400
Message-ID: <4F956071.1040702@redhat.com>
Date: Mon, 23 Apr 2012 14:00:17 +0000
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Marek Szyprowski <m.szyprowski@samsung.com>
CC: =?UTF-8?B?J1LDqW1pIERlbmlzLUNvdXJtb250Jw==?= <remi@remlab.net>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	"'Laurent Pinchart'" <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, kyungmin.park@samsung.com, sumit.semwal@ti.com,
	daeinki@gmail.com, daniel.vetter@ffwll.ch, robdclark@gmail.com,
	pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
	hverkuil@xs4all.nl, subashrp@gmail.com
Subject: Re: [PATCH v4 02/14] Documentation: media: description of DMABUF
 importing in V4L2
References: <1334332076-28489-1-git-send-email-t.stanislaws@samsung.com> <1334332076-28489-3-git-send-email-t.stanislaws@samsung.com> <13761406.oTf8ZzmZpQ@avalon> <4F9021FE.2070903@samsung.com> <4F907798.3000304@redhat.com> <4F912141.8060200@samsung.com> <d24e8c6e35352ed5800161713f728591@chewa.net> <4F916660.7040608@redhat.com> <056501cd2125$b286d5e0$179481a0$%szyprowski@samsung.com>
In-Reply-To: <056501cd2125$b286d5e0$179481a0$%szyprowski@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 23-04-2012 07:50, Marek Szyprowski escreveu:
> Hi Mauro,
> 
> On Friday, April 20, 2012 3:37 PM Mauro Carvalho Chehab wrote:
> 
> (snipped)
> 
>>>> So my rough-idea was to remove USERPTR support from kernel
>>>> drivers (if possible of course) and to provide an emulation
>>>> layer in the userspace code like libv4l2.
>>>>
>>>> Please note that it is only a rough idea. Just brainstorming :)
>>
>>> It is *too early* to start any discussion on this topic.
>>> Especially until DMABUF is mature enough to become a good
>>> alternative for userptr.
>>
>> Looking at the hole picture, dropping USERPTR would only make
>> sense if it is broken on dev2user (or user2dev) transfers.
>>
>> Dropping its usage on dev2dev transfers makes sense, after having
>> DMABUF implemented.
>>
>> Yet, if some userspace application wants to abuse of USERPTR in order
>> to use it for dev2dev transfer, there's not much that can be done at
>> Kernel level.
>>
>> It makes sense to put a big warn at the V4L2 Docs telling that this
>> is not officially supported and can cause all sorts of issues at
>> the machine/system.
> 
> Please note that all current drivers which use videobuf/videobuf2-dma-contig
> are able to use userptr memory access method only with physically contiguous
> memory. 

Yes.

> This means that in fact they work only buffers, which come from other
> devices and dev2dev transfers are the only possibility. malloc()ed memory
> buffers are rejected.

Fragmented buffers can be detected, at Kernel level, and VB/VB2 can refuse
a fragmented memory when the hardware doesn't support it. However, checking
if the buffer is fragmented is not a safe way to detect that the buffer will
be used by a dev2dev transfer.

If the buffers are allocated very soon just after boot time which malloc(),
or if they use some different way of allocating the buffers (like reducing the max
ram area addressed by the kernel or using CMU or a simila approach), it could be 
possible to use videobuf(1/2)-dma-contig for userptr with user2dev/dev2user
transfers. This is actually used on some cases where this is used (like where 
the capture device only supports contiguous buffers).

If, for some reason, the hardware doesn't support dev2dev transfers on a
reliable way, some other strategy should be used.

Regards,
Mauro
