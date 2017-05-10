Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f179.google.com ([209.85.161.179]:34913 "EHLO
        mail-yw0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752606AbdEJKN2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 10 May 2017 06:13:28 -0400
Received: by mail-yw0-f179.google.com with SMTP id l135so13009986ywb.2
        for <linux-media@vger.kernel.org>; Wed, 10 May 2017 03:13:28 -0700 (PDT)
Received: from mail-yw0-f175.google.com (mail-yw0-f175.google.com. [209.85.161.175])
        by smtp.gmail.com with ESMTPSA id n5sm1193266ywd.15.2017.05.10.03.13.25
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 May 2017 03:13:26 -0700 (PDT)
Received: by mail-yw0-f175.google.com with SMTP id b68so12998570ywe.3
        for <linux-media@vger.kernel.org>; Wed, 10 May 2017 03:13:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1494255810-12672-8-git-send-email-sakari.ailus@linux.intel.com>
References: <1494255810-12672-1-git-send-email-sakari.ailus@linux.intel.com> <1494255810-12672-8-git-send-email-sakari.ailus@linux.intel.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Wed, 10 May 2017 18:13:04 +0800
Message-ID: <CAAFQd5CSf33de4r3WX_v8ZuLwb6SFFtP5EQY=Bh5t8y3UiR+sA@mail.gmail.com>
Subject: Re: [RFC v4 07/18] vb2: dma-contig: Remove redundant sgt_base field
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org,
        dri-devel <dri-devel@lists.freedesktop.org>,
        posciak@chromium.org, Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, sumit.semwal@linaro.org,
        Rob Clark <robdclark@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, labbott@redhat.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Some comments inline.

On Mon, May 8, 2017 at 11:03 PM, Sakari Ailus
<sakari.ailus@linux.intel.com> wrote:
> The struct vb2_dc_buf contains two struct sg_table fields: sgt_base and
> dma_sgt. The former is used by DMA-BUF buffers whereas the latter is used
> by USERPTR.
>
> Unify the two, leaving dma_sgt.
>
> MMAP buffers do not need cache flushing since they have been allocated
> using dma_alloc_coherent().
>
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/v4l2-core/videobuf2-dma-contig.c | 25 +++++++++++++------------
>  1 file changed, 13 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> index a8a46a8..ddbbcf0 100644
> --- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
> +++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> @@ -31,12 +31,13 @@ struct vb2_dc_buf {
>         unsigned long                   attrs;
>         enum dma_data_direction         dma_dir;
>         struct sg_table                 *dma_sgt;
> -       struct frame_vector             *vec;
>
>         /* MMAP related */
>         struct vb2_vmarea_handler       handler;
>         refcount_t                      refcount;
> -       struct sg_table                 *sgt_base;
> +
> +       /* USERPTR related */
> +       struct frame_vector             *vec;
>
>         /* DMABUF related */
>         struct dma_buf_attachment       *db_attach;
> @@ -96,7 +97,7 @@ static void vb2_dc_prepare(void *buf_priv)
>         struct sg_table *sgt = buf->dma_sgt;
>
>         /* DMABUF exporter will flush the cache for us */
> -       if (!sgt || buf->db_attach)
> +       if (!buf->vec)

While at it, can we change the comment above to actually refer to what
this condition is checking? Maybe it's just me, but it's very
confusing, as the condition is actually (!USERPTR), while the comment
mentions DMABUF alone and not even mentioning about MMAP. Maybe we
could have something like this:

/*
 * Only USERPTR needs cache maintenance. DMABUF exporter will flush
 * the cache for us, while MMAP buffers are coherent by design.
 */

I guess it could be done as a separate patch after this series,
especially considering the message might actually change, since we are
going to allow cached MMAP buffers.

>                 return;
>
>         dma_sync_sg_for_device(buf->dev, sgt->sgl, sgt->orig_nents,
> @@ -109,7 +110,7 @@ static void vb2_dc_finish(void *buf_priv)
>         struct sg_table *sgt = buf->dma_sgt;
>
>         /* DMABUF exporter will flush the cache for us */

Here too.

Best regards,
Tomasz
