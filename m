Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f44.google.com ([209.85.213.44]:35032 "EHLO
	mail-vk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753774AbcDVIXy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Apr 2016 04:23:54 -0400
Received: by mail-vk0-f44.google.com with SMTP id t129so127374615vkg.2
        for <linux-media@vger.kernel.org>; Fri, 22 Apr 2016 01:23:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5719DBE3.3040707@xs4all.nl>
References: <5719DBE3.3040707@xs4all.nl>
From: Jean-Michel Hautbois <jean-michel.hautbois@veo-labs.com>
Date: Fri, 22 Apr 2016 10:23:28 +0200
Message-ID: <CAH-u=82TugRcE1r=Rp=-YG9gVDV1i6bJixpZESBSqWPzhXZzsg@mail.gmail.com>
Subject: Re: [RFC] Streaming I/O: proposal to expose MMAP/USERPTR/DMABUF
 capabilities with QUERYCAP
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

2016-04-22 10:08 GMT+02:00 Hans Verkuil <hverkuil@xs4all.nl>:
> Hi all,
>
> I have always been unhappy with the fact that it is so hard to tell whether
> the USERPTR and/or DMABUF modes are available with Streaming I/O. QUERYCAP
> only tells you if Streaming I/O is available, but not in which flavors.
>
> So I propose the following:
>
> #define V4L2_CAP_STREAMING_MMAP V4L2_CAP_STREAMING
> #define V4L2_CAP_STREAMING_USERPTR 0x08000000
> #define V4L2_CAP_STREAMING_DMABUF  0x10000000
>
> All drivers that currently support CAP_STREAMING also support MMAP. For userptr
> and dmabuf support we add new caps. These can be set by the core if the driver
> uses vb2 since the core can query the io_modes field of vb2_queue.

So, you want to make it mandatory for future drivers that they support
MMAP. Fine with me.
BTW, dmabuf is still marked as experimental, what would make it part
of the API for good ?

> For the drivers that do not yet support vb2 we can add it manually.
>
> I was considering making it a requirement that the MMAP streaming mode is
> always present, but I don't know if that works once we get drivers that operate
> on secure memory. So I won't do that for now.

By using "#define V4L2_CAP_STREAMING_MMAP V4L2_CAP_STREAMING" you make
it mandatory... You would need a separate bit to indicate MMAP
otherwise...

> Since we are looking at device caps anyway: can we just drop V4L2_CAP_ASYNCIO?
> It's never been implemented, nor is it likely in the future. And we don't have
> all that many bits left before we need to use one of the reserved fields for
> additional capabilities.
>
> Regards,
>
>         Hans
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
