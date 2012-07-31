Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:35984 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634Ab2GaODx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Jul 2012 10:03:53 -0400
Received: by vbbff1 with SMTP id ff1so5772989vbb.19
        for <linux-media@vger.kernel.org>; Tue, 31 Jul 2012 07:03:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201207311639.02693.remi@remlab.net>
References: <1339684349-28882-1-git-send-email-t.stanislaws@samsung.com>
	<201207310833.56566.hverkuil@xs4all.nl>
	<36319543.mdnBULUSen@avalon>
	<201207311639.02693.remi@remlab.net>
Date: Tue, 31 Jul 2012 09:03:52 -0500
Message-ID: <CAF6AEGvZnz=1XEX9tuk_ZcfS14LXmnjeZGvOunWvi8aZ3sER5Q@mail.gmail.com>
Subject: Re: [PATCHv2 3/9] v4l: add buffer exporting via dmabuf
From: Rob Clark <rob.clark@linaro.org>
To: =?ISO-8859-1?Q?R=E9mi_Denis=2DCourmont?= <remi@remlab.net>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sumit.semwal@ti.com, daeinki@gmail.com,
	daniel.vetter@ffwll.ch, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, subashrp@gmail.com,
	mchehab@redhat.com, g.liakhovetski@gmx.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jul 31, 2012 at 8:39 AM, Rémi Denis-Courmont <remi@remlab.net> wrote:
> Le mardi 31 juillet 2012 14:56:14 Laurent Pinchart, vous avez écrit :
>> > For that matter, wouldn't it be useful to support exporting a userptr
>> > buffer at some point in the future?
>>
>> Shouldn't USERPTR usage be discouraged once we get dma-buf support ?
>
> USERPTR, where available, is currently the only way to perform zero-copy from
> kernel to userspace. READWRITE does not support zero-copy at all. MMAP only
> supports zero-copy if userspace knows a boundary on the number of concurrent
> buffers *and* the device can deal with that number of buffers; in general,
> MMAP requires memory copying.

hmm, this sounds like the problem is device pre-allocating buffers?
Anyways, last time I looked, the vb2 core supported changing dmabuf fd
each time you QBUF, in a similar way to what you can do w/ userptr.
So that seems to get you the advantages you miss w/ mmap without the
pitfalls of userptr.

> I am not sure DMABUF even supports transmitting data efficiently to userspace.
> In my understanding, it's meant for transmitting data between DSP's bypassing
> userspace entirely, in other words the exact opposite of what USERBUF does.

well, dmabuf's can be mmap'd.. so it is more a matter of where the
buffer gets allocated, malloc() or from some driver (v4l2 or other).
There are a *ton* of ways userspace allocated memory can go badly,
esp. if the hw has special requirements about memory (GFP_DMA32 in a
system w/ PAE/LPAE, certain ranges of memory, certain alignment of
memory, etc).

BR,
-R

> --
> Rémi Denis-Courmont
> http://www.remlab.net/
> http://fi.linkedin.com/in/remidenis
