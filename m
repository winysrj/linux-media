Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:11377 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964856Ab1GOGSH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jul 2011 02:18:07 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
Received: from eu_spt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LOD00I1G2U5MT20@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 15 Jul 2011 07:18:06 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LOD008ZN2U5LN@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 15 Jul 2011 07:18:05 +0100 (BST)
Date: Fri, 15 Jul 2011 08:17:15 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH] videobuf2: call buf_finish() on unprocessed buffers
In-reply-to: <20110714150934.74777696@bike.lwn.net>
To: 'Jonathan Corbet' <corbet@lwn.net>, linux-media@vger.kernel.org
Cc: 'Mauro Carvalho Chehab' <mchehab@redhat.com>
Message-id: <000101cc42b6$d7582160$86086420$%szyprowski@samsung.com>
Content-language: pl
References: <20110714150934.74777696@bike.lwn.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Thursday, July 14, 2011 11:10 PM Jonathan Corbet wrote:

> When user space stops streaming, there may be buffers which have been given
> to buf_prepare() and which may or may not have been passed to buf_queue().
> The videobuf2 core simply takes those buffers back; if buf_prepare() does
> work that needs cleaning up (like setting up a DMA mapping), that cleanup
> will not happen.
> 
> This patch establishes a simple contract with drivers: buffers given to
> buf_prepare() will eventually see a buf_finish() call.
> 
> Signed-off-by: Jonathan Corbet <corbet@lwn.net>

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

> ---
>  drivers/media/video/videobuf2-core.c |    8 +++++++-
>  1 files changed, 7 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/videobuf2-core.c
> b/drivers/media/video/videobuf2-core.c
> index 6ba1461..2ba08ab 100644
> --- a/drivers/media/video/videobuf2-core.c
> +++ b/drivers/media/video/videobuf2-core.c
> @@ -1177,6 +1177,7 @@ EXPORT_SYMBOL_GPL(vb2_streamon);
>   */
>  static void __vb2_queue_cancel(struct vb2_queue *q)
>  {
> +	struct vb2_buffer *vb;
>  	unsigned int i;
> 
>  	/*
> @@ -1188,13 +1189,18 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
>  	q->streaming = 0;
> 
>  	/*
> -	 * Remove all buffers from videobuf's list...
> +	 * Remove all buffers from videobuf's list...  Give the driver
> +	 * a chance to clean them up first, though.
>  	 */
> +	list_for_each_entry(vb, &q->queued_list, queued_entry)
> +		call_qop(q, buf_finish, vb);
>  	INIT_LIST_HEAD(&q->queued_list);
>  	/*
>  	 * ...and done list; userspace will not receive any buffers it
>  	 * has not already dequeued before initiating cancel.
>  	 */
> +	list_for_each_entry(vb, &q->done_list, done_entry)
> +		call_qop(q, buf_finish, vb);
>  	INIT_LIST_HEAD(&q->done_list);
>  	wake_up_all(&q->done_wq);
> 
> --
> 1.7.6

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


