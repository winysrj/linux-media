Return-path: <linux-media-owner@vger.kernel.org>
Received: from oyp.chewa.net ([91.121.6.101]:43194 "EHLO oyp.chewa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754705Ab2DTK5J (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Apr 2012 06:57:09 -0400
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [PATCH v4 02/14] Documentation: media: description of DMABUF importing
 in V4L2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri, 20 Apr 2012 12:56:53 +0200
From: =?UTF-8?Q?R=C3=A9mi_Denis-Courmont?= <remi@remlab.net>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	<linux-media@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
	<airlied@redhat.com>, <m.szyprowski@samsung.com>,
	<kyungmin.park@samsung.com>, <sumit.semwal@ti.com>,
	<daeinki@gmail.com>, <daniel.vetter@ffwll.ch>,
	<robdclark@gmail.com>, <pawel@osciak.com>,
	<linaro-mm-sig@lists.linaro.org>, <hverkuil@xs4all.nl>,
	<subashrp@gmail.com>
In-Reply-To: <4F912141.8060200@samsung.com>
References: <1334332076-28489-1-git-send-email-t.stanislaws@samsung.com> <1334332076-28489-3-git-send-email-t.stanislaws@samsung.com> <13761406.oTf8ZzmZpQ@avalon> <4F9021FE.2070903@samsung.com> <4F907798.3000304@redhat.com> <4F912141.8060200@samsung.com>
Message-ID: <d24e8c6e35352ed5800161713f728591@chewa.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 20 Apr 2012 10:41:37 +0200, Tomasz Stanislawski

<t.stanislaws@samsung.com> wrote:

>> Am I understanding wrong or are you saying that you want to drop

userptr

>> from V4L2 API in long-term? If so, why?

> 

> Dropping userptr is just some brainstorming idea.

> It was found out that userptr is not a good mean

> for buffer exchange between to two devices.



I can believe that. But I am also inclined to believe that DMABUF is

targetted at device-to-device transfer, while USERPTR is targetted at

device-to-user (or user-to-device) transfers. Are you saying applications

should use DMABUF and memory map the buffers? Or would you care to explain

how DMABUF addresses the problem space of USERPTR?



> The USERPTR simplifies userspace code but introduce

> a lot of complexity problems for the kernel drivers

> and frameworks.



It is not only a simplification. In some cases, USERPTR is the only I/O

method that supports zero copy in pretty much any circumstance. When the

user cannot reliably predict the maximum number of required buffers,

predicts a value larger than the device will negotiate, or needs buffers to

outlive STREAMOFF (?), MMAP requires memory copying. USERPTR does not.



Now, I do realize that some devices cannot support USERPTR efficiently,

then they should not support USERPTR. But for those devices that can, it

seems quite a nice performance enhancement.



-- 

Rémi Denis-Courmont

Sent from my collocated server
