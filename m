Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:49508 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752203AbcLOUts (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Dec 2016 15:49:48 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, pawel@osciak.com,
        m.szyprowski@samsung.com, kyungmin.park@samsung.com,
        hverkuil@xs4all.nl, sumit.semwal@linaro.org, robdclark@gmail.com,
        daniel.vetter@ffwll.ch, labbott@redhat.com
Subject: Re: [RFC RESEND 06/11] vb2: Improve struct vb2_mem_ops documentation; alloc and put are for MMAP
Date: Thu, 15 Dec 2016 22:50:24 +0200
Message-ID: <1699087.svoNNaWGMy@avalon>
In-Reply-To: <1441972234-8643-7-git-send-email-sakari.ailus@linux.intel.com>
References: <1441972234-8643-1-git-send-email-sakari.ailus@linux.intel.com> <1441972234-8643-7-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Friday 11 Sep 2015 14:50:29 Sakari Ailus wrote:
> The alloc() and put() ops are for MMAP buffers only. Document it.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  include/media/videobuf2-core.h | 20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
> index a825bd5..efc9a19 100644
> --- a/include/media/videobuf2-core.h
> +++ b/include/media/videobuf2-core.h
> @@ -24,16 +24,16 @@ struct vb2_threadio_data;
> 
>  /**
>   * struct vb2_mem_ops - memory handling/memory allocator operations
> - * @alloc:	allocate video memory and, optionally, allocator private data,
> - *		return NULL on failure or a pointer to allocator private,
> - *		per-buffer data on success; the returned private structure
> - *		will then be passed as buf_priv argument to other ops in this
> - *		structure. Additional gfp_flags to use when allocating the
> - *		are also passed to this operation. These flags are from the
> - *		gfp_flags field of vb2_queue.
> - * @put:	inform the allocator that the buffer will no longer be used;
> - *		usually will result in the allocator freeing the buffer (if
> - *		no other users of this buffer are present); the buf_priv
> + * @alloc:	allocate video memory for an MMAP buffer and, optionally,
> + *		allocator private data, return NULL on failure or a pointer
> + *		to allocator private, per-buffer data on success; the returned
> + *		private structure will then be passed as buf_priv argument to
> + *		other ops in this structure. Additional gfp_flags to use when
> + *		allocating the are also passed to this operation. These flags

s/the are/the memory are/

Apart from that,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> + *		are from the gfp_flags field of vb2_queue.
> + * @put:	inform the allocator that the MMAP buffer will no longer be
> + *		used; usually will result in the allocator freeing the buffer
> + *		(if no other users of this buffer are present); the buf_priv
>   *		argument is the allocator private per-buffer structure
>   *		previously returned from the alloc callback.
>   * @get_userptr: acquire userspace memory for a hardware operation; used
> for

-- 
Regards,

Laurent Pinchart

