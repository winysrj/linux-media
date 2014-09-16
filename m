Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:10178 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413AbaIPNvC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Sep 2014 09:51:02 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NBZ0007SYH1WW00@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 16 Sep 2014 09:51:01 -0400 (EDT)
Date: Tue, 16 Sep 2014 10:50:53 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Pawel Osciak <pawel@osciak.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>
Subject: Re: [RFC PATCH] vb2: regression fix for vbi capture & poll
Message-id: <20140916105053.6b8504cf.m.chehab@samsung.com>
In-reply-to: <541802B0.2020805@xs4all.nl>
References: <541802B0.2020805@xs4all.nl>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 16 Sep 2014 11:28:16 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> (My proposal to fix this. Note that it is untested, I plan to do that this
> evening)
> 
> Commit 9241650d62f7 broke vbi capture applications that expect POLLERR to be
> returned if STREAMON wasn't called.
> 
> Rather than checking whether buffers were queued AND vb2 was not yet streaming,
> just check whether streaming is in progress and return POLLERR if not.
> 
> This change makes it impossible to poll in one thread and call STREAMON in
> another, but doing that breaks existing applications and is also not according
> to the spec. So be it.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index 7e6aff6..0452fb2 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -2583,10 +2583,10 @@ unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
>  	}
>  
>  	/*
> -	 * There is nothing to wait for if no buffer has been queued and the
> -	 * queue isn't streaming, or if the error flag is set.
> +	 * There is nothing to wait for if the queue isn't streaming, or if
> +	 * the error flag is set.
>  	 */
> -	if ((list_empty(&q->queued_list) && !vb2_is_streaming(q)) || q->error)
> +	if (!vb2_is_streaming(q) || q->error)
>  		return res | POLLERR;

This makes the code even more different than what VB1 does. I suspect
that this will likely cause even more regressions.

The following (untested) patch seems to be what matches best what VB1
does, and are likely to cause less harm, but needs test of course. 

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 5b808e25fc09..0d86526cbcb0 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -2586,6 +2586,9 @@ unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
 	 * There is nothing to wait for if no buffer has been queued and the
 	 * queue isn't streaming, or if the error flag is set.
 	 */
+	if (!vb2_is_streaming(q))
+		vb2_internal_streamon(q, q->type);
+
 	if ((list_empty(&q->queued_list) && !vb2_is_streaming(q)) || q->error)
 		return res | POLLERR;
 
