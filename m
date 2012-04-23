Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:21269 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420Ab2DWHuO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Apr 2012 03:50:14 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=UTF-8
Received: from euspt2 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M2X00D849QWB650@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 23 Apr 2012 08:49:44 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M2X0027M9RLDH@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 23 Apr 2012 08:50:10 +0100 (BST)
Date: Mon, 23 Apr 2012 09:50:05 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH v4 02/14] Documentation: media: description of DMABUF
 importing in V4L2
In-reply-to: <4F916660.7040608@redhat.com>
To: 'Mauro Carvalho Chehab' <mchehab@redhat.com>,
	=?UTF-8?Q?'R=C3=A9mi_Denis-Courmont'?= <remi@remlab.net>
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>,
	'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, kyungmin.park@samsung.com, sumit.semwal@ti.com,
	daeinki@gmail.com, daniel.vetter@ffwll.ch, robdclark@gmail.com,
	pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
	hverkuil@xs4all.nl, subashrp@gmail.com
Message-id: <056501cd2125$b286d5e0$179481a0$%szyprowski@samsung.com>
Content-language: pl
References: <1334332076-28489-1-git-send-email-t.stanislaws@samsung.com>
 <1334332076-28489-3-git-send-email-t.stanislaws@samsung.com>
 <13761406.oTf8ZzmZpQ@avalon> <4F9021FE.2070903@samsung.com>
 <4F907798.3000304@redhat.com> <4F912141.8060200@samsung.com>
 <d24e8c6e35352ed5800161713f728591@chewa.net> <4F916660.7040608@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Friday, April 20, 2012 3:37 PM Mauro Carvalho Chehab wrote:

(snipped)

> >> So my rough-idea was to remove USERPTR support from kernel
> >> drivers (if possible of course) and to provide an emulation
> >> layer in the userspace code like libv4l2.
> >>
> >> Please note that it is only a rough idea. Just brainstorming :)
> 
> > It is *too early* to start any discussion on this topic.
> > Especially until DMABUF is mature enough to become a good
> > alternative for userptr.
> 
> Looking at the hole picture, dropping USERPTR would only make
> sense if it is broken on dev2user (or user2dev) transfers.
> 
> Dropping its usage on dev2dev transfers makes sense, after having
> DMABUF implemented.
> 
> Yet, if some userspace application wants to abuse of USERPTR in order
> to use it for dev2dev transfer, there's not much that can be done at
> Kernel level.
> 
> It makes sense to put a big warn at the V4L2 Docs telling that this
> is not officially supported and can cause all sorts of issues at
> the machine/system.

Please note that all current drivers which use videobuf/videobuf2-dma-contig
are able to use userptr memory access method only with physically contiguous
memory. This means that in fact they work only buffers, which come from other
devices and dev2dev transfers are the only possibility. malloc()ed memory
buffers are rejected.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center



