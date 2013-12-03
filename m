Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:2092 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857Ab3LCJ6A (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Dec 2013 04:58:00 -0500
Message-ID: <529DAAB7.100@xs4all.nl>
Date: Tue, 03 Dec 2013 10:56:07 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	pawel@osciak.com, awalls@md.metrocast.net,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv2 PATCH 7/9] vb2: add thread support
References: <1385719124-11338-1-git-send-email-hverkuil@xs4all.nl> <2d9fc3a471c865ec61e1d2243140e5985940c5b7.1385719098.git.hans.verkuil@cisco.com> <2319725.0dGUTBP8Q9@avalon>
In-Reply-To: <2319725.0dGUTBP8Q9@avalon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/29/13 19:21, Laurent Pinchart wrote:
> Hi Hans,
> 
> Thank you for the patch.
> 
> On Friday 29 November 2013 10:58:42 Hans Verkuil wrote:
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> In order to implement vb2 DVB or ALSA support you need to be able to start
>> a kernel thread that queues and dequeues buffers, calling a callback
>> function for every captured/displayed buffer. This patch adds support for
>> that.
>>
>> It's based on drivers/media/v4l2-core/videobuf-dvb.c, but with all the DVB
>> specific stuff stripped out, thus making it much more generic.
> 
> Do you see any use for this outside of videobuf2-dvb ? If not I wonder whether 
> the code shouldn't be moved there. The sync objects framework being developed 
> for KMS will in my opinion cover the other use cases, and I'd like to 
> discourage non-DVB drivers to use vb2 threads in the meantime.

I'm using it for ALSA drivers which, at least in my case, require almost
identical functionality as that needed by DVB. But regardless of that, I really
don't like the way it was done in the old videobuf framework, mixing low-level
videobuf calls/data structure accesses with DVB code. That should be separate.

The vb2 core framework should provide the low-level functionality that is
needed by the videobuf2-dvb to build on.

Regards,

	Hans

> 
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>  drivers/media/v4l2-core/videobuf2-core.c | 134 ++++++++++++++++++++++++++++
>>  include/media/videobuf2-core.h           |  28 +++++++
>>  2 files changed, 162 insertions(+)
>>
>> diff --git a/drivers/media/v4l2-core/videobuf2-core.c
>> b/drivers/media/v4l2-core/videobuf2-core.c index 853d391..a86d033 100644
>> --- a/drivers/media/v4l2-core/videobuf2-core.c
>> +++ b/drivers/media/v4l2-core/videobuf2-core.c
>> @@ -6,6 +6,9 @@
>>   * Author: Pawel Osciak <pawel@osciak.com>
>>   *	   Marek Szyprowski <m.szyprowski@samsung.com>
>>   *
>> + * The vb2_thread implementation was based on code from videobuf-dvb.c:
>> + * 	(c) 2004 Gerd Knorr <kraxel@bytesex.org> [SUSE Labs]
>> + *
>>   * This program is free software; you can redistribute it and/or modify
>>   * it under the terms of the GNU General Public License as published by
>>   * the Free Software Foundation.
>> @@ -18,6 +21,8 @@
>>  #include <linux/poll.h>
>>  #include <linux/slab.h>
>>  #include <linux/sched.h>
>> +#include <linux/freezer.h>
>> +#include <linux/kthread.h>
>>
>>  #include <media/v4l2-dev.h>
>>  #include <media/v4l2-fh.h>
>> @@ -2508,6 +2513,135 @@ size_t vb2_write(struct vb2_queue *q, const char
>> __user *data, size_t count, }
>>  EXPORT_SYMBOL_GPL(vb2_write);
>>
>> +struct vb2_threadio_data {
>> +	struct task_struct *thread;
>> +	vb2_thread_fnc fnc;
>> +	void *priv;
>> +	bool stop;
>> +};
>> +
>> +static int vb2_thread(void *data)
>> +{
>> +	struct vb2_queue *q = data;
>> +	struct vb2_threadio_data *threadio = q->threadio;
>> +	struct vb2_fileio_data *fileio = q->fileio;
>> +	int prequeue = 0;
>> +	int index = 0;
>> +	int ret = 0;
>> +
>> +	if (V4L2_TYPE_IS_OUTPUT(q->type))
>> +		prequeue = q->num_buffers;
>> +
>> +	set_freezable();
>> +
>> +	for (;;) {
>> +		struct vb2_buffer *vb;
>> +
>> +		/*
>> +		 * Call vb2_dqbuf to get buffer back.
>> +		 */
>> +		memset(&fileio->b, 0, sizeof(fileio->b));
>> +		fileio->b.type = q->type;
>> +		fileio->b.memory = q->memory;
>> +		if (prequeue) {
>> +			fileio->b.index = index++;
>> +			prequeue--;
>> +		} else {
>> +			call_qop(q, wait_finish, q);
>> +			ret = vb2_internal_dqbuf(q, &fileio->b, 0);
>> +			call_qop(q, wait_prepare, q);
>> +			dprintk(5, "file io: vb2_dqbuf result: %d\n", ret);
>> +		}
>> +		if (threadio->stop)
>> +			break;
>> +		if (ret)
>> +			break;
>> +		try_to_freeze();
>> +
>> +		vb = q->bufs[fileio->b.index];
>> +		if (!(fileio->b.flags & V4L2_BUF_FLAG_ERROR))
>> +			ret = threadio->fnc(vb, threadio->priv);
>> +		if (ret)
>> +			break;
>> +		call_qop(q, wait_finish, q);
>> +		ret = vb2_internal_qbuf(q, &fileio->b);
>> +		call_qop(q, wait_prepare, q);
>> +		if (ret)
>> +			break;
>> +	}
>> +
>> +	/* Hmm, linux becomes *very* unhappy without this ... */
>> +	while (!kthread_should_stop()) {
>> +		set_current_state(TASK_INTERRUPTIBLE);
>> +		schedule();
>> +	}
>> +	return 0;
>> +}
>> +
>> +int vb2_thread_start(struct vb2_queue *q, vb2_thread_fnc fnc, void *priv,
>> +		     const char *thread_name)
>> +{
>> +	struct vb2_threadio_data *threadio;
>> +	int ret = 0;
>> +
>> +	if (q->threadio)
>> +		return -EBUSY;
>> +	if (vb2_is_busy(q))
>> +		return -EBUSY;
>> +	if (WARN_ON(q->fileio))
>> +		return -EBUSY;
>> +
>> +	threadio = kzalloc(sizeof(*threadio), GFP_KERNEL);
>> +	if (threadio == NULL)
>> +		return -ENOMEM;
>> +	threadio->fnc = fnc;
>> +	threadio->priv = priv;
>> +
>> +	ret = __vb2_init_fileio(q, !V4L2_TYPE_IS_OUTPUT(q->type));
>> +	dprintk(3, "file io: vb2_init_fileio result: %d\n", ret);
>> +	if (ret)
>> +		goto nomem;
>> +	q->threadio = threadio;
>> +	threadio->thread = kthread_run(vb2_thread, q, "vb2-%s", thread_name);
>> +	if (IS_ERR(threadio->thread)) {
>> +		ret = PTR_ERR(threadio->thread);
>> +		threadio->thread = NULL;
>> +		goto nothread;
>> +	}
>> +	return 0;
>> +
>> +nothread:
>> +	__vb2_cleanup_fileio(q);
>> +nomem:
>> +	kfree(threadio);
>> +	return ret;
>> +}
>> +EXPORT_SYMBOL_GPL(vb2_thread_start);
>> +
>> +int vb2_thread_stop(struct vb2_queue *q)
>> +{
>> +	struct vb2_threadio_data *threadio = q->threadio;
>> +	struct vb2_fileio_data *fileio = q->fileio;
>> +	int err;
>> +
>> +	if (threadio == NULL)
>> +		return 0;
>> +	call_qop(q, wait_finish, q);
>> +	threadio->stop = true;
>> +	vb2_internal_streamoff(q, q->type);
>> +	call_qop(q, wait_prepare, q);
>> +	q->fileio = NULL;
>> +	fileio->req.count = 0;
>> +	vb2_reqbufs(q, &fileio->req);
>> +	kfree(fileio);
>> +	err = kthread_stop(threadio->thread);
>> +	threadio->thread = NULL;
>> +	kfree(threadio);
>> +	q->fileio = NULL;
>> +	q->threadio = NULL;
>> +	return err;
>> +}
>> +EXPORT_SYMBOL_GPL(vb2_thread_stop);
>>
>>  /*
>>   * The following functions are not part of the vb2 core API, but are helper
>> diff --git a/include/media/videobuf2-core.h
>> b/include/media/videobuf2-core.h index 1be7f39..7dea795 100644
>> --- a/include/media/videobuf2-core.h
>> +++ b/include/media/videobuf2-core.h
>> @@ -20,6 +20,7 @@
>>
>>  struct vb2_alloc_ctx;
>>  struct vb2_fileio_data;
>> +struct vb2_threadio_data;
>>
>>  /**
>>   * struct vb2_mem_ops - memory handling/memory allocator operations
>> @@ -330,6 +331,7 @@ struct v4l2_fh;
>>   *		buffers queued. If set, then retry calling start_streaming when
>>   *		queuing a new buffer.
>>   * @fileio:	file io emulator internal data, used only if emulator is 
> active
>> + * @threadio:	thread io internal data, used only if thread is active */
>>  struct vb2_queue {
>>  	enum v4l2_buf_type		type;
>> @@ -364,6 +366,7 @@ struct vb2_queue {
>>  	unsigned int			retry_start_streaming:1;
>>
>>  	struct vb2_fileio_data		*fileio;
>> +	struct vb2_threadio_data	*threadio;
>>  };
>>
>>  void *vb2_plane_vaddr(struct vb2_buffer *vb, unsigned int plane_no);
>> @@ -402,6 +405,31 @@ size_t vb2_read(struct vb2_queue *q, char __user *data,
>> size_t count, loff_t *ppos, int nonblock);
>>  size_t vb2_write(struct vb2_queue *q, const char __user *data, size_t
>> count, loff_t *ppos, int nonblock);
>> +/**
>> + * vb2_thread_fnc - callback function for use with vb2_thread
>> + *
>> + * This is called whenever a buffer is dequeued in the thread.
>> + */
>> +typedef int (*vb2_thread_fnc)(struct vb2_buffer *vb, void *priv);
>> +
>> +/**
>> + * vb2_thread_start() - start a thread for the given queue.
>> + * @q:		videobuf queue
>> + * @fnc:	callback function
>> + * @priv:	priv pointer passed to the callback function
>> + * @thread_name:the name of the thread. This will be prefixed with "vb2-".
>> + *
>> + * This starts a thread that will queue and dequeue until an error occurs
>> + * or @vb2_thread_stop is called.
>> + */
>> +int vb2_thread_start(struct vb2_queue *q, vb2_thread_fnc fnc, void *priv,
>> +		     const char *thread_name);
>> +
>> +/**
>> + * vb2_thread_stop() - stop the thread for the given queue.
>> + * @q:		videobuf queue
>> + */
>> +int vb2_thread_stop(struct vb2_queue *q);
>>
>>  /**
>>   * vb2_is_streaming() - return streaming status of the queue

