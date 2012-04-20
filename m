Return-path: <linux-media-owner@vger.kernel.org>
Received: from oyp.chewa.net ([91.121.6.101]:48561 "EHLO oyp.chewa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923Ab2DTNDc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Apr 2012 09:03:32 -0400
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [PATCH v4 02/14] Documentation: media: description of DMABUF importing
 in V4L2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri, 20 Apr 2012 15:03:17 +0200
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
In-Reply-To: <4F91559D.6060900@samsung.com>
References: <1334332076-28489-1-git-send-email-t.stanislaws@samsung.com> <1334332076-28489-3-git-send-email-t.stanislaws@samsung.com> <13761406.oTf8ZzmZpQ@avalon> <4F9021FE.2070903@samsung.com> <4F907798.3000304@redhat.com> <4F912141.8060200@samsung.com> <d24e8c6e35352ed5800161713f728591@chewa.net> <4F91559D.6060900@samsung.com>
Message-ID: <b0e35efc1f87894a7a5a7b1acf560566@chewa.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 20 Apr 2012 14:25:01 +0200, Tomasz Stanislawski

<t.stanislaws@samsung.com> wrote:

>>> The USERPTR simplifies userspace code but introduce

>>> a lot of complexity problems for the kernel drivers

>>> and frameworks.

>> 

>> It is not only a simplification. In some cases, USERPTR is the only I/O

>> method that supports zero copy in pretty much any circumstance.

> 

> Only for devices that have its own IOMMU that can access system memory.



Newer versions of the UVC driver have USERTPR, and simingly gspca seems

too. That is practically all USB capture devices... That might be

irrelevant for a smartphone manufacturer. That is very relevant for desktop

applications.



> Moreover the userptr must come from malloc or be a mmaped file.

> The other case are drivers that touch memory using CPU in the kernel

> space like VIVI or USB drivers.



I'd argue that USB is the most common case of V4L2 on the desktop...



>> When the user cannot reliably predict the maximum number of required

>> buffers, predicts a value larger than the device will negotiate, or

>> needs buffers to outlive STREAMOFF (?), MMAP requires memory copying.

>> USERPTR does not.

> 

> What does outlive STREAMOFF means in this context?



Depending how your multimedia pipeline is built, it is plausible that the

V4L2 source is shutdown (STREAMOFF then close()) before buffers coming from

it are released/destroyed downstream. I might be wrong, but I would expect

that V4L2 MMAP buffers become invalid after STREAMOFF+close()?



> Anyway, IMO allocation of the buffers at VIDIOC_REQBUFS was not the best

> idea because it introduces an allocation overhead for negotiations of

> the number of the buffers. An allocation at mmap was to late. There is a

> need for some intermediate state between REQBUFS and mmap. The ioctl

> BUF_PREPARE may help here.

> 

> Can you give me an example of a sane application is forced to negotiate

a

> larger number of buffers than it is actually going to use?



Outside the embedded world, the application typically does not know what

the latency of the multimedia pipeline is. If the latency is not known, the

number of buffers needed for zero copy cannot be precomputed for REQBUFS,

say:



count = 1 + latency / frame interval.



Even for a trivial analog TV viewer application, lip synchronization

requires picture frames to be bufferred to be long enough to account for

the latency of the audio input, dejitter, filtering and audio output. Those

values are usually not well determined at the time of requesting buffers

from the video capture device. Also the application may want to play nice

with PulseAudio. Then it will get very long audio buffers with very few

audio periods... more latency.



It gets harder or outright impossible for frameworks dealing with

complicated or arbitrary pipelines such as LibVLC or gstreamer. There is

far too much unpredictability and variability downstream of the V4L2 source

to estimate latency, and infer the number of buffers needed.



>> Now, I do realize that some devices cannot support USERPTR efficiently,

>> then they should not support USERPTR. 

> 

> The problem is not there is *NO* device that can handle USERPTR

reliably.

> The can handle USERPTR generated by malloc or page cache (not sure).

> Memory mmaped from other devices, frameworks etc may or may not work.

> Even if the device has its IOMMU the DMA layer provides no generic way

to

> transform from one device to the mapping in some other device.



I'm not saying that USERPTR should replace DMABUF. I'm saying USERPTR has

advantages over MMAP that DMABUF does not seem to cover as yet (if only

libv4l2 would not inhibit USERPTR...).



I'm definitely not saying that applications should rely on USERPTR being

supported. We agree that not all devices can support USERPTR.



> The userptr has its niches were it works pretty well like Web cams or

VIVI.

> I am saying that if ever DMABUF becomes a good alternative for USERPTR

> than maybe we should consider encouraging dropping USERPTR in the new

> drivers as 'obsolete' feature and providing some emulation layer in

libv4l2

> for legacy applications.



Sure.



-- 

Rémi Denis-Courmont

Sent from my collocated server
