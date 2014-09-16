Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:38626 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699AbaIPJJA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Sep 2014 05:09:00 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Pawel Osciak <pawel@osciak.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>
Subject: Re: [PATCH] [media] BZ#84401: Revert "[media] v4l: vb2: Don't return POLLERR during transient buffer underruns"
Date: Tue, 16 Sep 2014 12:09:01 +0300
Message-ID: <1803893.9xIcqpbx23@avalon>
In-Reply-To: <1410826255-2025-1-git-send-email-m.chehab@samsung.com>
References: <1410826255-2025-1-git-send-email-m.chehab@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Monday 15 September 2014 21:10:55 Mauro Carvalho Chehab wrote:
> This reverts commit 9241650d62f79a3da01f1d5e8ebd195083330b75.
> 
> The commit 9241650d62f7 was meant to solve an issue with Gstreamer
> version 0.10 with libv4l 1.2, where a fixup patch for DQBUF exposed
> a bad behavior ag Gstreamer.

That's not correct. The patch was created to solve an issue observed with the 
Gstreamer 0.10 v4l2src element accessing the video device directly, *without* 
libv4l.

The V4L2 specification documents poll() as follows.

"When the application did not call VIDIOC_QBUF or VIDIOC_STREAMON yet the 
poll() function succeeds, but sets the POLLERR flag in the revents field."

The vb2 poll implementation didn't conform with that, as it returned POLLERR 
when the buffer list was empty due to a transient buffer underrun, even if 
both VIDIOC_STREAMON and VIDIOC_QBUF have been called.

The commit thus brought the vb2 poll implementation in line with the 
specification. If we really want to revert it to its broken behaviour, then it 
would be fair to explain this in the revert message, and I want to know how 
you propose fixing this properly, as the revert really causes issues for 
userspace.

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
> ---
>  drivers/media/v4l2-core/videobuf2-core.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c
> b/drivers/media/v4l2-core/videobuf2-core.c index 7e6aff673a5a..7387821e7c72
> 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -2583,10 +2583,10 @@ unsigned int vb2_poll(struct vb2_queue *q, struct
> file *file, poll_table *wait) }
> 
>  	/*
> -	 * There is nothing to wait for if no buffer has been queued and the
> -	 * queue isn't streaming, or if the error flag is set.
> +	 * There is nothing to wait for if no buffer has been queued
> +	 * or if the error flag is set.
>  	 */
> -	if ((list_empty(&q->queued_list) && !vb2_is_streaming(q)) || q->error)
> +	if ((list_empty(&q->queued_list) || q->error)
>  		return res | POLLERR;
> 
>  	/*

-- 
Regards,

Laurent Pinchart

