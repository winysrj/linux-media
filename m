Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f175.google.com ([209.85.192.175]:34463 "EHLO
	mail-pf0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024AbcG0Hvy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jul 2016 03:51:54 -0400
Received: by mail-pf0-f175.google.com with SMTP id p64so8438853pfb.1
        for <linux-media@vger.kernel.org>; Wed, 27 Jul 2016 00:51:53 -0700 (PDT)
From: Kazunori Kobayashi <kkobayas@igel.co.jp>
Subject: Memory freeing when dmabuf fds are exported with VIDIOC_EXPBUF
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org,
	Damian Hobson-Garcia <dhobsong@igel.co.jp>
Message-ID: <36bf3ef2-e43a-3910-16e2-b51439be5622@igel.co.jp>
Date: Wed, 27 Jul 2016 16:51:47 +0900
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I have a question about memory freeing by calling REQBUF(0) before all the
dmabuf fds exported with VIDIOC_EXPBUF are closed.

In calling REQBUF(0), videobuf2-core returns -EBUSY when the reference count
of a vb2 buffer is more than 1. When dmabuf fds are not exported (usual V4L2_MEMORY_MMAP case),
the check is no problem, but when dmabuf fds are exported and some of them are
not closed (in other words the references to that memory are left),
we cannot succeed in calling REQBUF(0) despite being able to free the memory
after all the references are dropped.

Actually REQBUF(0) does not force a vb2 buffer to be freed but decreases
the refcount of it. Also all the vb2 memory allocators that support dmabuf exporting
(dma-contig, dma-sg, vmalloc) implements memory freeing by release() of dma_buf_ops,
so I think there is no need to return -EBUSY when exporting dmabuf fds.

Could you please tell me what you think?

The code that I am talking about is in drivers/media/v4l2-core/videobuf2-core.c:

   if (*count == 0 || q->num_buffers != 0 || q->memory != memory) {
          /*
           * We already have buffers allocated, so first check if they
           * are not in use and can be freed.
           */
          mutex_lock(&q->mmap_lock);
          if (q->memory == VB2_MEMORY_MMAP && __buffers_in_use(q)) {
                  mutex_unlock(&q->mmap_lock);
                  dprintk(1, "memory in use, cannot free\n");
                  return -EBUSY;
          }

Regards,
Kobayashi
-- 
---------------------------------
IGEL Co.,Ltd. Kazunori Kobayashi
kkobayas@igel.co.jp
http://www.igel.co.jp/
