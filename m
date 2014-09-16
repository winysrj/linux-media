Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:3362 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138AbaIPGQf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Sep 2014 02:16:35 -0400
Message-ID: <5417D5AB.7040703@xs4all.nl>
Date: Tue, 16 Sep 2014 08:16:11 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [git:media_tree/devel] [media] BZ#84401: Revert "[media] v4l:
 vb2: Don't return POLLERR during transient buffer underruns"
References: <E1XTgMx-0000Vl-4j@www.linuxtv.org>
In-Reply-To: <E1XTgMx-0000Vl-4j@www.linuxtv.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/16/2014 02:05 AM, Mauro Carvalho Chehab wrote:
> This is an automatic generated email to let you know that the following patch were queued at the 
> http://git.linuxtv.org/media_tree.git tree:
> 
> Subject: [media] BZ#84401: Revert "[media] v4l: vb2: Don't return POLLERR during transient buffer underruns"
> Author:  Mauro Carvalho Chehab <m.chehab@samsung.com>
> Date:    Mon Sep 15 20:58:01 2014 -0300
> 
> This reverts commit 9241650d62f79a3da01f1d5e8ebd195083330b75.
> 
> The commit 9241650d62f7 was meant to solve an issue with Gstreamer
> version 0.10 with libv4l 1.2, where a fixup patch for DQBUF exposed
> a bad behavior ag Gstreamer.
> 
> It does that by returning POLERR if VB2 is not streaming.
> 
> However, it broke VBI userspace support on alevt and mtt (and maybe
> other VBI apps), as they rely on the old behavior.
> 
> Due to that, we need to roll back and restore the previous behavior.
> 
> It means that there are still some potential regressions by reverting it,
> but those are known to occur only if:
> 	- libv4l is version 1.2 or upper (due to DQBUF fixup);
> 	- Gstreamer version 1.2 or before are being used, as this bug
> got fixed on Gstreamer 1.4.
> 
> As both libv4l 1.2 and Gstreamer version 1.4 were released about the same
> time, and the fix went only on Kernel 3.16 and were not backported to
> stable, it is very unlikely that reverting it would cause much harm.
> 
> For more details, see:
> 	https://bugzilla.kernel.org/show_bug.cgi?id=84401
> 
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Pawel Osciak <pawel@osciak.com>
> Cc: Nicolas Dufresne <nicolas.dufresne@collabora.com>
> Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> 
>  drivers/media/v4l2-core/videobuf2-core.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> ---
> 
> http://git.linuxtv.org/media_tree.git?a=commitdiff;h=e0857d1d1af8478b33e63dbb22bb2160a807d868
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index 7e6aff6..7387821 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -2583,10 +2583,10 @@ unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table *wait)
>  	}
>  
>  	/*
> -	 * There is nothing to wait for if no buffer has been queued and the
> -	 * queue isn't streaming, or if the error flag is set.
> +	 * There is nothing to wait for if no buffer has been queued
> +	 * or if the error flag is set.
>  	 */
> -	if ((list_empty(&q->queued_list) && !vb2_is_streaming(q)) || q->error)
> +	if ((list_empty(&q->queued_list) || q->error)

As you've no doubt seen from the krobot messages there is one '(' too many here.

Regards,

	Hans

>  		return res | POLLERR;
>  
>  	/*
> 
> _______________________________________________
> linuxtv-commits mailing list
> linuxtv-commits@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linuxtv-commits
> 

