Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:43156 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753003AbbIKROx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Sep 2015 13:14:53 -0400
Message-ID: <55F30BC5.9020200@xs4all.nl>
Date: Fri, 11 Sep 2015 19:13:41 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-media@vger.kernel.org
CC: pawel@osciak.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sumit.semwal@linaro.org,
	robdclark@gmail.com, daniel.vetter@ffwll.ch, labbott@redhat.com
Subject: Re: [RFC RESEND 06/11] vb2: Improve struct vb2_mem_ops documentation;
 alloc and put are for MMAP
References: <1441972234-8643-1-git-send-email-sakari.ailus@linux.intel.com> <1441972234-8643-7-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1441972234-8643-7-git-send-email-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/11/2015 01:50 PM, Sakari Ailus wrote:
> The alloc() and put() ops are for MMAP buffers only. Document it.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>'

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

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
> + *		are from the gfp_flags field of vb2_queue.
> + * @put:	inform the allocator that the MMAP buffer will no longer be
> + *		used; usually will result in the allocator freeing the buffer
> + *		(if no other users of this buffer are present); the buf_priv
>   *		argument is the allocator private per-buffer structure
>   *		previously returned from the alloc callback.
>   * @get_userptr: acquire userspace memory for a hardware operation; used for
> 

