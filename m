Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-svr1.cs.utah.edu ([155.98.64.241]:34020 "EHLO
        mail-svr1.cs.utah.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751440AbdFZX4L (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Jun 2017 19:56:11 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Mon, 26 Jun 2017 17:50:06 -0600
From: Shaobo <shaobo@cs.utah.edu>
To: linux-media@vger.kernel.org
Cc: mchehab@kernel.org
Subject: Potentially invalid memory accesses in file
 drivers/media/v4l2-core/videobuf-core.c
Message-ID: <f4d974348cddddd30da0b1ca0a0083df@cs.utah.edu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi there,

My name is Shaobo He and I am a graduate student at University of Utah. 
I am using a static analysis tool to search for null pointer 
dereferences and came across a couple of potentially invalid memory 
accesses in the file drivers/media/v4l2-core/videobuf-core.c. Basically 
the expansion of the macro `CALL_PTR` is never examined although it can 
evaluate to NULL. The following is its definition and two uses:

#define CALLPTR(q, f, arg...)						\
	((q->int_ops->f) ? q->int_ops->f(arg) : NULL)

static int __videobuf_copy_to_user(struct videobuf_queue *q,
				   struct videobuf_buffer *buf,
				   char __user *data, size_t count,
				   int nonblocking)
{
	void *vaddr = CALLPTR(q, vaddr, buf);

	/* copy to userspace */
	if (count > buf->size - q->read_off)
		count = buf->size - q->read_off;

	if (copy_to_user(data, vaddr + q->read_off, count))
		return -EFAULT;

	return count;
}

static int __videobuf_copy_stream(struct videobuf_queue *q,
				  struct videobuf_buffer *buf,
				  char __user *data, size_t count, size_t pos,
				  int vbihack, int nonblocking)
{
	unsigned int *fc = CALLPTR(q, vaddr, buf);

	if (vbihack) {
		/* dirty, undocumented hack -- pass the frame counter
			* within the last four bytes of each vbi data block.
			* We need that one to maintain backward compatibility
			* to all vbi decoding software out there ... */
		fc += (buf->size >> 2) - 1;
		*fc = buf->field_count >> 1;
		dprintk(1, "vbihack: %d\n", *fc);
	}

	/* copy stuff using the common method */
	count = __videobuf_copy_to_user(q, buf, data, count, nonblocking);

	if ((count == -EFAULT) && (pos == 0))
		return -EFAULT;

	return count;
}

Both of the two functions could contain invalid memory accesses. The 
second function `__videobuf_copy_stream` is more problematic since if 
`buf-?size >> 2` evaluates to 1, which seems not totally impossible to 
me, then a NULL pointer dereference would occur.

Please let me know if it makes sense. Thanks for your time and I am 
looking forward to your reply.

Shaobo
