Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f169.google.com ([209.85.214.169]:58163 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060AbaAOSDz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jan 2014 13:03:55 -0500
Received: by mail-ob0-f169.google.com with SMTP id wp4so1569280obc.0
        for <linux-media@vger.kernel.org>; Wed, 15 Jan 2014 10:03:54 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 15 Jan 2014 10:03:54 -0800
Message-ID: <CABMudhSp7q63iFMFeMHPiMOtA9WXVo6usp0U9auvN32db+d51g@mail.gmail.com>
Subject: Purpose of mem_ops in source and destination queue
From: m silverstri <michael.j.silverstri@gmail.com>
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I think the sequence of using a V4L2 codec mem2mem driver is like this:
1. queue buffer for input buffer
2. queue buffer for output buffer
3. Streamon OUTPUT plane
4. Streamoff Capture plane
5. dequeue buffer for input buffer
6. dequeue buffer for output buffer

And for the driver implementation, I see it needs to setup mem_ops for
source and destination queue:
for example,
http://lxr.free-electrons.com/source/drivers/media/platform/s5p-jpeg/jpeg-core.c
src_vq->mem_ops = &vb2_dma_contig_memops;
dst_vq->mem_ops = &vb2_dma_contig_memops;

My question is why we need the mem_ops in source and destination
queues. In other woreds, why the driver need to allocate memory when
user space applcation has provided the memory via #1 and #2 above?

Thank you.
