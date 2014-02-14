Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yh0-f53.google.com ([209.85.213.53]:45488 "EHLO
	mail-yh0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932AbaBNBdi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Feb 2014 20:33:38 -0500
Received: by mail-yh0-f53.google.com with SMTP id v1so11038936yhn.12
        for <linux-media@vger.kernel.org>; Thu, 13 Feb 2014 17:33:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1392284450-41019-4-git-send-email-hverkuil@xs4all.nl>
References: <1392284450-41019-1-git-send-email-hverkuil@xs4all.nl> <1392284450-41019-4-git-send-email-hverkuil@xs4all.nl>
From: Pawel Osciak <pawel@osciak.com>
Date: Fri, 14 Feb 2014 10:32:58 +0900
Message-ID: <CAMm-=zAixs9jP8gAdCcLguC=eej=vx3GKPuwXXNJsXo=ieBE1w@mail.gmail.com>
Subject: Re: [RFCv3 PATCH 03/10] vb2: add note that buf_finish can be called
 with !vb2_is_streaming()
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: LMML <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks Hans.

Acked-by: Pawel Osciak <pawel@osciak.com>

On Thu, Feb 13, 2014 at 6:40 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> Drivers need to be aware that buf_finish can be called when there is no
> streaming going on, so make a note of that.
>
> Also add a bunch of missing periods at the end of sentences.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  include/media/videobuf2-core.h | 44 ++++++++++++++++++++++--------------------
>  1 file changed, 23 insertions(+), 21 deletions(-)
>
> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
> index f443ce0..82b7f0f 100644
> --- a/include/media/videobuf2-core.h
> +++ b/include/media/videobuf2-core.h
> @@ -34,49 +34,49 @@ struct vb2_fileio_data;
>   *             usually will result in the allocator freeing the buffer (if
>   *             no other users of this buffer are present); the buf_priv
>   *             argument is the allocator private per-buffer structure
> - *             previously returned from the alloc callback
> + *             previously returned from the alloc callback.
>   * @get_userptr: acquire userspace memory for a hardware operation; used for
>   *              USERPTR memory types; vaddr is the address passed to the
>   *              videobuf layer when queuing a video buffer of USERPTR type;
>   *              should return an allocator private per-buffer structure
>   *              associated with the buffer on success, NULL on failure;
>   *              the returned private structure will then be passed as buf_priv
> - *              argument to other ops in this structure
> + *              argument to other ops in this structure.
>   * @put_userptr: inform the allocator that a USERPTR buffer will no longer
> - *              be used
> + *              be used.
>   * @attach_dmabuf: attach a shared struct dma_buf for a hardware operation;
>   *                used for DMABUF memory types; alloc_ctx is the alloc context
>   *                dbuf is the shared dma_buf; returns NULL on failure;
>   *                allocator private per-buffer structure on success;
> - *                this needs to be used for further accesses to the buffer
> + *                this needs to be used for further accesses to the buffer.
>   * @detach_dmabuf: inform the exporter of the buffer that the current DMABUF
>   *                buffer is no longer used; the buf_priv argument is the
>   *                allocator private per-buffer structure previously returned
> - *                from the attach_dmabuf callback
> + *                from the attach_dmabuf callback.
>   * @map_dmabuf: request for access to the dmabuf from allocator; the allocator
>   *             of dmabuf is informed that this driver is going to use the
> - *             dmabuf
> + *             dmabuf.
>   * @unmap_dmabuf: releases access control to the dmabuf - allocator is notified
> - *               that this driver is done using the dmabuf for now
> + *               that this driver is done using the dmabuf for now.
>   * @prepare:   called every time the buffer is passed from userspace to the
> - *             driver, useful for cache synchronisation, optional
> + *             driver, useful for cache synchronisation, optional.
>   * @finish:    called every time the buffer is passed back from the driver
> - *             to the userspace, also optional
> + *             to the userspace, also optional.
>   * @vaddr:     return a kernel virtual address to a given memory buffer
>   *             associated with the passed private structure or NULL if no
> - *             such mapping exists
> + *             such mapping exists.
>   * @cookie:    return allocator specific cookie for a given memory buffer
>   *             associated with the passed private structure or NULL if not
> - *             available
> + *             available.
>   * @num_users: return the current number of users of a memory buffer;
>   *             return 1 if the videobuf layer (or actually the driver using
> - *             it) is the only user
> + *             it) is the only user.
>   * @mmap:      setup a userspace mapping for a given memory buffer under
> - *             the provided virtual memory region
> + *             the provided virtual memory region.
>   *
>   * Required ops for USERPTR types: get_userptr, put_userptr.
>   * Required ops for MMAP types: alloc, put, num_users, mmap.
> - * Required ops for read/write access types: alloc, put, num_users, vaddr
> + * Required ops for read/write access types: alloc, put, num_users, vaddr.
>   * Required ops for DMABUF types: attach_dmabuf, detach_dmabuf, map_dmabuf,
>   *                               unmap_dmabuf.
>   */
> @@ -258,27 +258,29 @@ struct vb2_buffer {
>   * @wait_prepare:      release any locks taken while calling vb2 functions;
>   *                     it is called before an ioctl needs to wait for a new
>   *                     buffer to arrive; required to avoid a deadlock in
> - *                     blocking access type
> + *                     blocking access type.
>   * @wait_finish:       reacquire all locks released in the previous callback;
>   *                     required to continue operation after sleeping while
> - *                     waiting for a new buffer to arrive
> + *                     waiting for a new buffer to arrive.
>   * @buf_init:          called once after allocating a buffer (in MMAP case)
>   *                     or after acquiring a new USERPTR buffer; drivers may
>   *                     perform additional buffer-related initialization;
>   *                     initialization failure (return != 0) will prevent
> - *                     queue setup from completing successfully; optional
> + *                     queue setup from completing successfully; optional.
>   * @buf_prepare:       called every time the buffer is queued from userspace
>   *                     and from the VIDIOC_PREPARE_BUF ioctl; drivers may
>   *                     perform any initialization required before each hardware
>   *                     operation in this callback; drivers that support
>   *                     VIDIOC_CREATE_BUFS must also validate the buffer size;
>   *                     if an error is returned, the buffer will not be queued
> - *                     in driver; optional
> + *                     in driver; optional.
>   * @buf_finish:                called before every dequeue of the buffer back to
>   *                     userspace; drivers may perform any operations required
> - *                     before userspace accesses the buffer; optional
> + *                     before userspace accesses the buffer; optional. Note:
> + *                     this op can be called as well when vb2_is_streaming()
> + *                     returns false!
>   * @buf_cleanup:       called once before the buffer is freed; drivers may
> - *                     perform any additional cleanup; optional
> + *                     perform any additional cleanup; optional.
>   * @start_streaming:   called once to enter 'streaming' state; the driver may
>   *                     receive buffers with @buf_queue callback before
>   *                     @start_streaming is called; the driver gets the number
> @@ -299,7 +301,7 @@ struct vb2_buffer {
>   *                     the buffer back by calling vb2_buffer_done() function;
>   *                     it is allways called after calling STREAMON ioctl;
>   *                     might be called before start_streaming callback if user
> - *                     pre-queued buffers before calling STREAMON
> + *                     pre-queued buffers before calling STREAMON.
>   */
>  struct vb2_ops {
>         int (*queue_setup)(struct vb2_queue *q, const struct v4l2_format *fmt,
> --
> 1.8.4.rc3
>



-- 
Best regards,
Pawel Osciak
