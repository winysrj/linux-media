Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:34023 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420Ab2APH5i (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jan 2012 02:57:38 -0500
Received: by qadc10 with SMTP id c10so1137qad.19
        for <linux-media@vger.kernel.org>; Sun, 15 Jan 2012 23:57:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1325760118-27997-1-git-send-email-sumit.semwal@ti.com>
References: <1325760118-27997-1-git-send-email-sumit.semwal@ti.com>
Date: Mon, 16 Jan 2012 16:57:37 +0900
Message-ID: <CAH9JG2Uz3n+4ca7KvabO0pX_Mfbqp+YO7GpWR6CRWOwxcF7zxg@mail.gmail.com>
Subject: Re: [RFCv1 0/4] v4l: DMA buffer sharing support as a user
From: Kyungmin Park <kmpark@infradead.org>
To: Sumit Semwal <sumit.semwal@ti.com>
Cc: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
	arnd@arndb.de, jesse.barker@linaro.org, m.szyprowski@samsung.com,
	rob@ti.com, daniel@ffwll.ch, t.stanislaws@samsung.com,
	patches <patches@linaro.org>,
	=?UTF-8?B?64yA7J246riw?= <inki.dae@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Since dma_buf is merged at v3.3-rc, I hope to merge this one also at
this merge window.
Now it's tested at OMAP. also it's used at exynos but not yet fully tested.

Thank you,
Kyungmin Park

On 1/5/12, Sumit Semwal <sumit.semwal@ti.com> wrote:
> Hello Everyone,
>
> A very happy new year 2012! :)
>
> This patchset is an RFC for the way videobuf2 can be adapted to add support
> for
> DMA buffer sharing framework[1].
>
> The original patch-set for the idea, and PoC of buffer sharing was by
> Tomasz Stanislawski <t.stanislaws@samsung.com>, who demonstrated buffer
> sharing
> between two v4l2 devices[2]. This RFC is needed to adapt these patches to
> the
> changes that have happened in the DMA buffer sharing framework over past few
> months.
>
> To begin with, I have tried to adapt only the dma-contig allocator, and only
> as
> a user of dma-buf buffer. I am currently working on the v4l2-as-an-exporter
> changes, and will share as soon as I get it in some shape.
>
> As with the PoC [2], the handle for sharing buffers is a file-descriptor
> (fd).
> The usage documentation is also a part of [1].
>
> So, the current RFC has the following limitations:
> - Only buffer sharing as a buffer user,
> - doesn't handle cases where even for a contiguous buffer, the sg_table can
> have
>    more than one scatterlist entry.
>
>
> Thanks and best regards,
> ~Sumit.
>
> [1]: dma-buf patchset at: https://lkml.org/lkml/2011/12/26/29
> [2]: http://lwn.net/Articles/454389
>
> Sumit Semwal (4):
>   v4l: Add DMABUF as a memory type
>   v4l:vb2: add support for shared buffer (dma_buf)
>   v4l:vb: remove warnings about MEMORY_DMABUF
>   v4l:vb2: Add dma-contig allocator as dma_buf user
>
>  drivers/media/video/videobuf-core.c        |    4 +
>  drivers/media/video/videobuf2-core.c       |  186
> +++++++++++++++++++++++++++-
>  drivers/media/video/videobuf2-dma-contig.c |  125 +++++++++++++++++++
>  include/linux/videodev2.h                  |    8 ++
>  include/media/videobuf2-core.h             |   30 +++++
>  5 files changed, 352 insertions(+), 1 deletions(-)
>
> --
> 1.7.5.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
