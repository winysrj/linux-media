Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:47937 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755113AbdK2OLz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Nov 2017 09:11:55 -0500
Subject: Re: [PATCH 12/12] media: videobuf2: don't use kernel-doc "/**"
 markups
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Pawel Osciak <pawel@osciak.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
From: Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <4445b878-2f86-cf97-bf01-5d317ad674bf@samsung.com>
Date: Wed, 29 Nov 2017 15:11:50 +0100
MIME-version: 1.0
In-reply-to: <2a87af6ba1b9df4dda91d7e1a7d750f295ce1e57.1511952372.git.mchehab@s-opensource.com>
Content-type: text/plain; charset="utf-8"; format="flowed"
Content-transfer-encoding: 7bit
Content-language: en-US
References: <46e42a303178ca1341d1ab3e0b5c1227b89b60ee.1511952372.git.mchehab@s-opensource.com>
        <CGME20171129104641epcas4p1fa8a43eb2ad2ace7dc59b3027c08816e@epcas4p1.samsung.com>
        <2a87af6ba1b9df4dda91d7e1a7d750f295ce1e57.1511952372.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On 2017-11-29 11:46, Mauro Carvalho Chehab wrote:
> While it would be very cool to have those functions using
> kernel-doc markups, the reality right now is that they
> don't follow kernel-doc rules, as parameters aren't documented.
>
> So, stop abusing on "/**" markups.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

> ---
>   drivers/media/v4l2-core/videobuf2-core.c | 56 ++++++++++++++++----------------
>   drivers/media/v4l2-core/videobuf2-v4l2.c | 10 +++---
>   2 files changed, 33 insertions(+), 33 deletions(-)
>
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index cb115ba6a1d2..a8589d96ef72 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -188,7 +188,7 @@ module_param(debug, int, 0644);
>   static void __vb2_queue_cancel(struct vb2_queue *q);
>   static void __enqueue_in_driver(struct vb2_buffer *vb);
>   
> -/**
> +/*
>    * __vb2_buf_mem_alloc() - allocate video memory for the given buffer
>    */
>   static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
> @@ -229,7 +229,7 @@ static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
>   	return ret;
>   }
>   
> -/**
> +/*
>    * __vb2_buf_mem_free() - free memory of the given buffer
>    */
>   static void __vb2_buf_mem_free(struct vb2_buffer *vb)
> @@ -243,7 +243,7 @@ static void __vb2_buf_mem_free(struct vb2_buffer *vb)
>   	}
>   }
>   
> -/**
> +/*
>    * __vb2_buf_userptr_put() - release userspace memory associated with
>    * a USERPTR buffer
>    */
> @@ -258,7 +258,7 @@ static void __vb2_buf_userptr_put(struct vb2_buffer *vb)
>   	}
>   }
>   
> -/**
> +/*
>    * __vb2_plane_dmabuf_put() - release memory associated with
>    * a DMABUF shared plane
>    */
> @@ -277,7 +277,7 @@ static void __vb2_plane_dmabuf_put(struct vb2_buffer *vb, struct vb2_plane *p)
>   	p->dbuf_mapped = 0;
>   }
>   
> -/**
> +/*
>    * __vb2_buf_dmabuf_put() - release memory associated with
>    * a DMABUF shared buffer
>    */
> @@ -289,7 +289,7 @@ static void __vb2_buf_dmabuf_put(struct vb2_buffer *vb)
>   		__vb2_plane_dmabuf_put(vb, &vb->planes[plane]);
>   }
>   
> -/**
> +/*
>    * __setup_offsets() - setup unique offsets ("cookies") for every plane in
>    * the buffer.
>    */
> @@ -317,7 +317,7 @@ static void __setup_offsets(struct vb2_buffer *vb)
>   	}
>   }
>   
> -/**
> +/*
>    * __vb2_queue_alloc() - allocate videobuf buffer structures and (for MMAP type)
>    * video buffer memory for all buffers/planes on the queue and initializes the
>    * queue
> @@ -386,7 +386,7 @@ static int __vb2_queue_alloc(struct vb2_queue *q, enum vb2_memory memory,
>   	return buffer;
>   }
>   
> -/**
> +/*
>    * __vb2_free_mem() - release all video buffer memory for a given queue
>    */
>   static void __vb2_free_mem(struct vb2_queue *q, unsigned int buffers)
> @@ -410,7 +410,7 @@ static void __vb2_free_mem(struct vb2_queue *q, unsigned int buffers)
>   	}
>   }
>   
> -/**
> +/*
>    * __vb2_queue_free() - free buffers at the end of the queue - video memory and
>    * related information, if no buffers are left return the queue to an
>    * uninitialized state. Might be called even if the queue has already been freed.
> @@ -544,7 +544,7 @@ bool vb2_buffer_in_use(struct vb2_queue *q, struct vb2_buffer *vb)
>   }
>   EXPORT_SYMBOL(vb2_buffer_in_use);
>   
> -/**
> +/*
>    * __buffers_in_use() - return true if any buffers on the queue are in use and
>    * the queue cannot be freed (by the means of REQBUFS(0)) call
>    */
> @@ -564,7 +564,7 @@ void vb2_core_querybuf(struct vb2_queue *q, unsigned int index, void *pb)
>   }
>   EXPORT_SYMBOL_GPL(vb2_core_querybuf);
>   
> -/**
> +/*
>    * __verify_userptr_ops() - verify that all memory operations required for
>    * USERPTR queue type have been provided
>    */
> @@ -577,7 +577,7 @@ static int __verify_userptr_ops(struct vb2_queue *q)
>   	return 0;
>   }
>   
> -/**
> +/*
>    * __verify_mmap_ops() - verify that all memory operations required for
>    * MMAP queue type have been provided
>    */
> @@ -590,7 +590,7 @@ static int __verify_mmap_ops(struct vb2_queue *q)
>   	return 0;
>   }
>   
> -/**
> +/*
>    * __verify_dmabuf_ops() - verify that all memory operations required for
>    * DMABUF queue type have been provided
>    */
> @@ -953,7 +953,7 @@ void vb2_discard_done(struct vb2_queue *q)
>   }
>   EXPORT_SYMBOL_GPL(vb2_discard_done);
>   
> -/**
> +/*
>    * __prepare_mmap() - prepare an MMAP buffer
>    */
>   static int __prepare_mmap(struct vb2_buffer *vb, const void *pb)
> @@ -966,7 +966,7 @@ static int __prepare_mmap(struct vb2_buffer *vb, const void *pb)
>   	return ret ? ret : call_vb_qop(vb, buf_prepare, vb);
>   }
>   
> -/**
> +/*
>    * __prepare_userptr() - prepare a USERPTR buffer
>    */
>   static int __prepare_userptr(struct vb2_buffer *vb, const void *pb)
> @@ -1082,7 +1082,7 @@ static int __prepare_userptr(struct vb2_buffer *vb, const void *pb)
>   	return ret;
>   }
>   
> -/**
> +/*
>    * __prepare_dmabuf() - prepare a DMABUF buffer
>    */
>   static int __prepare_dmabuf(struct vb2_buffer *vb, const void *pb)
> @@ -1215,7 +1215,7 @@ static int __prepare_dmabuf(struct vb2_buffer *vb, const void *pb)
>   	return ret;
>   }
>   
> -/**
> +/*
>    * __enqueue_in_driver() - enqueue a vb2_buffer in driver for processing
>    */
>   static void __enqueue_in_driver(struct vb2_buffer *vb)
> @@ -1298,7 +1298,7 @@ int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb)
>   }
>   EXPORT_SYMBOL_GPL(vb2_core_prepare_buf);
>   
> -/**
> +/*
>    * vb2_start_streaming() - Attempt to start streaming.
>    * @q:		videobuf2 queue
>    *
> @@ -1427,7 +1427,7 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
>   }
>   EXPORT_SYMBOL_GPL(vb2_core_qbuf);
>   
> -/**
> +/*
>    * __vb2_wait_for_done_vb() - wait for a buffer to become available
>    * for dequeuing
>    *
> @@ -1502,7 +1502,7 @@ static int __vb2_wait_for_done_vb(struct vb2_queue *q, int nonblocking)
>   	return 0;
>   }
>   
> -/**
> +/*
>    * __vb2_get_done_vb() - get a buffer ready for dequeuing
>    *
>    * Will sleep if required for nonblocking == false.
> @@ -1553,7 +1553,7 @@ int vb2_wait_for_all_buffers(struct vb2_queue *q)
>   }
>   EXPORT_SYMBOL_GPL(vb2_wait_for_all_buffers);
>   
> -/**
> +/*
>    * __vb2_dqbuf() - bring back the buffer to the DEQUEUED state
>    */
>   static void __vb2_dqbuf(struct vb2_buffer *vb)
> @@ -1625,7 +1625,7 @@ int vb2_core_dqbuf(struct vb2_queue *q, unsigned int *pindex, void *pb,
>   }
>   EXPORT_SYMBOL_GPL(vb2_core_dqbuf);
>   
> -/**
> +/*
>    * __vb2_queue_cancel() - cancel and stop (pause) streaming
>    *
>    * Removes all queued buffers from driver's queue and all buffers queued by
> @@ -1773,7 +1773,7 @@ int vb2_core_streamoff(struct vb2_queue *q, unsigned int type)
>   }
>   EXPORT_SYMBOL_GPL(vb2_core_streamoff);
>   
> -/**
> +/*
>    * __find_plane_by_offset() - find plane associated with the given offset off
>    */
>   static int __find_plane_by_offset(struct vb2_queue *q, unsigned long off,
> @@ -2104,7 +2104,7 @@ unsigned int vb2_core_poll(struct vb2_queue *q, struct file *file,
>   }
>   EXPORT_SYMBOL_GPL(vb2_core_poll);
>   
> -/**
> +/*
>    * struct vb2_fileio_buf - buffer context used by file io emulator
>    *
>    * vb2 provides a compatibility layer and emulator of file io (read and
> @@ -2118,7 +2118,7 @@ struct vb2_fileio_buf {
>   	unsigned int queued:1;
>   };
>   
> -/**
> +/*
>    * struct vb2_fileio_data - queue context used by file io emulator
>    *
>    * @cur_index:	the index of the buffer currently being read from or
> @@ -2155,7 +2155,7 @@ struct vb2_fileio_data {
>   	unsigned write_immediately:1;
>   };
>   
> -/**
> +/*
>    * __vb2_init_fileio() - initialize file io emulator
>    * @q:		videobuf2 queue
>    * @read:	mode selector (1 means read, 0 means write)
> @@ -2274,7 +2274,7 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
>   	return ret;
>   }
>   
> -/**
> +/*
>    * __vb2_cleanup_fileio() - free resourced used by file io emulator
>    * @q:		videobuf2 queue
>    */
> @@ -2293,7 +2293,7 @@ static int __vb2_cleanup_fileio(struct vb2_queue *q)
>   	return 0;
>   }
>   
> -/**
> +/*
>    * __vb2_perform_fileio() - perform a single file io (read or write) operation
>    * @q:		videobuf2 queue
>    * @data:	pointed to target userspace buffer
> diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c b/drivers/media/v4l2-core/videobuf2-v4l2.c
> index 0c0669976bdc..4075314a6989 100644
> --- a/drivers/media/v4l2-core/videobuf2-v4l2.c
> +++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
> @@ -49,7 +49,7 @@ module_param(debug, int, 0644);
>   #define V4L2_BUFFER_OUT_FLAGS	(V4L2_BUF_FLAG_PFRAME | V4L2_BUF_FLAG_BFRAME | \
>   				 V4L2_BUF_FLAG_KEYFRAME | V4L2_BUF_FLAG_TIMECODE)
>   
> -/**
> +/*
>    * __verify_planes_array() - verify that the planes array passed in struct
>    * v4l2_buffer from userspace can be safely used
>    */
> @@ -78,7 +78,7 @@ static int __verify_planes_array_core(struct vb2_buffer *vb, const void *pb)
>   	return __verify_planes_array(vb, pb);
>   }
>   
> -/**
> +/*
>    * __verify_length() - Verify that the bytesused value for each plane fits in
>    * the plane length and that the data offset doesn't exceed the bytesused value.
>    */
> @@ -181,7 +181,7 @@ static int vb2_queue_or_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b,
>   	return __verify_planes_array(q->bufs[b->index], b);
>   }
>   
> -/**
> +/*
>    * __fill_v4l2_buffer() - fill in a struct v4l2_buffer with information to be
>    * returned to userspace
>    */
> @@ -286,7 +286,7 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, void *pb)
>   		q->last_buffer_dequeued = true;
>   }
>   
> -/**
> +/*
>    * __fill_vb2_buffer() - fill a vb2_buffer with information provided in a
>    * v4l2_buffer by the userspace. It also verifies that struct
>    * v4l2_buffer has a valid number of planes.
> @@ -446,7 +446,7 @@ static const struct vb2_buf_ops v4l2_buf_ops = {
>   	.copy_timestamp		= __copy_timestamp,
>   };
>   
> -/**
> +/*
>    * vb2_querybuf() - query video buffer information
>    * @q:		videobuf queue
>    * @b:		buffer struct passed from userspace to vidioc_querybuf handler

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland
