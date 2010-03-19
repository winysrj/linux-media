Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:22542 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838Ab0CSMps (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Mar 2010 08:45:48 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=US-ASCII
Received: from eu_spt2 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0KZJ001ZP4S9HF00@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 19 Mar 2010 12:45:45 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0KZJ0019S4S8RF@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 19 Mar 2010 12:45:45 +0000 (GMT)
Date: Fri, 19 Mar 2010 13:43:56 +0100
From: Pawel Osciak <p.osciak@samsung.com>
Subject: RE: [PATCH/RFC] videobuf refactoring
In-reply-to: <201003182210.19055.hverkuil@xs4all.nl>
To: 'Hans Verkuil' <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, kyungmin.park@samsung.com
Message-id: <000e01cac761$d6c46230$844d2690$%osciak@samsung.com>
Content-language: pl
References: <201003182210.19055.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

>Hans Verkuil wrote:
>This patch is for discussion only. It is just to illustrate the possibilities.
>Once the cleanup patch Pawel posted is merged, then I can try to make a proper
>patch series for this depending on the feedback I get.

I went over your patch and it seems like a good next step in the cleanup.

>This patch is just a first phase at trying to bring some sense to the chaos.
>The main changes are:
>
>- All videobuf_qtype_ops now operate on buffers instead of whole queues.
>  Sometimes the queue is still passed, but in most cases that can probably
>  be avoided in the future. One restriction: the dma_sg needs to support
>  some V4L1 functionality where all buffers are mmapped with one mmap call.
>  This really requires videobuf_queue for now.

That's for the future, but we would probably even want them to operate on
planes.

>- Removed an unused op (mmap) and added a new one: vaddr. This returns
>  the virtual address of the buffer. This used to be vmalloc, but we are
>  not allocating anything, so that was a bad name,

That's true, at least those particular calls are not doing any vmalloc'ing.
We have to remember, that although right now they do, not all types of
memory provide kernel pointers. Since we need them for bounce buffers for
reading, we would either not be supporting it in those cases or would have
to actually vmalloc those read buffers.

>- I notice that after this patch the mmap_free op does the same thing for
>  all qtypes. This op can probably be removed. Frankly, I'm not sure what
>  it is supposed to do.

Should probably be replaced by a call verifying that nobody holds any
mappings/references to the buffers anymore, i.e. that freeing the buffers
is allowed.

>Is there anything in this patch that I shouldn't have done? I think this
>would be a major improvement but perhaps there is something magical somewhere
>that I don't know about.

Looks fine to me, although I have not (yet) fully considered all the implications
for read handling code. I have no idea about the implications on the compatibility
layer either.

Some minor comments:


>diff --git a/drivers/media/video/videobuf-core.c b/drivers/media/video/videobuf-core.c
>index 471178e..5f6798e 100644
>--- a/drivers/media/video/videobuf-core.c
>+++ b/drivers/media/video/videobuf-core.c

[snip]

>@@ -298,15 +298,16 @@ static void videobuf_status(struct videobuf_queue *q, struct v4l2_buffer *b,
> static int __videobuf_mmap_free(struct videobuf_queue *q)
> {
> 	int i;
>-	int rc;
>+	int rc = 0;
>
> 	if (!q)
> 		return 0;
>
> 	MAGIC_CHECK(q->int_ops->magic, MAGIC_QTYPE_OPS);
>
>-
>-	rc  = CALL(q, mmap_free, q);
>+	for (i = 0; !rc && i < VIDEO_MAX_FRAME; i++)
>+		if (q->bufs[i])
>+			rc  = CALL(q, mmap_free, q, q->bufs[i]);
>
> 	q->is_mmapped = 0;

The is_mmapped variable is actually not used anywhere now that I look at it.

>@@ -782,6 +783,49 @@ static ssize_t videobuf_read_zerocopy(struct videobuf_queue *q,
> 	return retval;
> }
>
>+static int __videobuf_copy_to_user(struct videobuf_queue *q,
>+				   struct videobuf_buffer *buf,
>+				   char __user *data, size_t count,
>+				   int nonblocking)
>+{
>+	void *vaddr = CALL(q, vaddr, buf);
>+
>+	/* copy to userspace */
>+	if (count > buf->size - q->read_off)
>+		count = buf->size - q->read_off;
>+
>+	if (copy_to_user(data, vaddr + q->read_off, count))
>+		return -EFAULT;
>+
>+	return count;
>+}
>+
>+static int __videobuf_copy_stream(struct videobuf_queue *q,
>+				  struct videobuf_buffer *buf,
>+				  char __user *data, size_t count, size_t pos,
>+				  int vbihack, int nonblocking)
>+{
>+	unsigned int *fc = CALL(q, vaddr, buf);

I'd add a check against fc == NULL, unless I am missing something.
Now that I look at it, there is no such check in current code either. I could
imagine a buffer without a kernel mapping. This requires a more in-depth
analysis of read handling code.



Best regards
--
Pawel Osciak
Linux Platform Group
Samsung Poland R&D Center


