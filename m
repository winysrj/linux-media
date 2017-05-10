Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f174.google.com ([209.85.161.174]:34616 "EHLO
        mail-yw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752046AbdEJLAe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 10 May 2017 07:00:34 -0400
Received: by mail-yw0-f174.google.com with SMTP id l14so13506293ywk.1
        for <linux-media@vger.kernel.org>; Wed, 10 May 2017 04:00:33 -0700 (PDT)
Received: from mail-yb0-f174.google.com (mail-yb0-f174.google.com. [209.85.213.174])
        by smtp.gmail.com with ESMTPSA id m184sm1288146ywd.1.2017.05.10.04.00.31
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 May 2017 04:00:31 -0700 (PDT)
Received: by mail-yb0-f174.google.com with SMTP id s22so6882754ybe.3
        for <linux-media@vger.kernel.org>; Wed, 10 May 2017 04:00:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1494255810-12672-14-git-send-email-sakari.ailus@linux.intel.com>
References: <1494255810-12672-1-git-send-email-sakari.ailus@linux.intel.com> <1494255810-12672-14-git-send-email-sakari.ailus@linux.intel.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Wed, 10 May 2017 19:00:10 +0800
Message-ID: <CAAFQd5CD_-754-xEXF7-r3SYWQoOn8FYVE_HXF_kuDfH2OtcYQ@mail.gmail.com>
Subject: Re: [RFC v4 13/18] vb2: Don't sync cache for a buffer if so requested
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org,
        dri-devel <dri-devel@lists.freedesktop.org>,
        posciak@chromium.org, Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, sumit.semwal@linaro.org,
        Rob Clark <robdclark@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, labbott@redhat.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Samu Onkalo <samu.onkalo@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Few comments inline.

On Mon, May 8, 2017 at 11:03 PM, Sakari Ailus
<sakari.ailus@linux.intel.com> wrote:
> From: Samu Onkalo <samu.onkalo@intel.com>
>
> The user may request to the driver (vb2) to skip the cache maintenance
> operations in case the buffer does not need cache synchronisation, e.g. in
> cases where the buffer is passed between hardware blocks without it being
> touched by the CPU.
[snip]
> @@ -1199,6 +1236,11 @@ static int __prepare_dmabuf(struct vb2_buffer *vb, const void *pb)
>                         dprintk(1, "buffer initialization failed\n");
>                         goto err;
>                 }
> +
> +               /* This is new buffer memory --- always synchronise cache. */
> +               __mem_prepare_planes(vb);
> +       } else if (!no_cache_sync) {
> +               __mem_prepare_planes(vb);

Do we actually need this at all for DMABUF, given that respective
callbacks in both vb2_dc and vb2_sg actually bail out if so?

>         }
>
>         ret = call_vb_qop(vb, buf_prepare, vb);
[snip]
> @@ -568,7 +571,11 @@ int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
>         }
>
>         ret = vb2_queue_or_prepare_buf(q, b, "qbuf");
> -       return ret ? ret : vb2_core_qbuf(q, b->index, b);
> +       if (ret)
> +               return ret;
> +
> +       return vb2_core_qbuf(q, b->index, b,
> +                            b->flags & V4L2_BUF_FLAG_NO_CACHE_SYNC);

Can we really let the userspace alone control this? I believe there
are drivers that need to do some fixup in OUTPUT buffers before
sending to the hardware or in CAPTURE buffer after getting from the
hardware, respectively in buf_prepare or buf_finish. I believe such
driver needs to be able to override this behavior.

Actually I'm wondering if we really need this buffer flag at all.
Wouldn't the following work for typical use cases that we actually
care about performance of?

buffer_needs_cache_sync = (buffer_type_is_MMAP &&
buffer_is_non_coherent && (buffer_is_mmapped ||
buffer_has_kernel_mapping)) || buffer_is_USERPTR

The above should cover all the fast paths that are used only to
exchange data between devices, without the CPU involved, assuming that
drivers that don't need the fixups I mentioned before are properly
updated to request no kernel mapping for allocated buffers.

I've added (buffer_is_USERPTR) to the equation as it's really hard to
imagine a use case where there is no CPU access to the buffer, but
USERPTR needs to be used (instead of DMABUF). I might be missing
something, though.

Best regards,
Tomasz
