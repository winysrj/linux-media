Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-2.cisco.com ([173.38.203.52]:51278 "EHLO
	aer-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756550AbaIRKKv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Sep 2014 06:10:51 -0400
Message-ID: <541AAFA6.6080605@cisco.com>
Date: Thu, 18 Sep 2014 12:10:46 +0200
From: Hans Verkuil <hansverk@cisco.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Pawel Osciak <pawel@osciak.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>
Subject: Re: [PATCH v2] [media] BZ#84401: Revert "[media] v4l: vb2: Don't
 return POLLERR during transient buffer underruns"
References: <1410826255-2025-1-git-send-email-m.chehab@samsung.com> <20140918070619.32d4e4b1@recife.lan>
In-Reply-To: <20140918070619.32d4e4b1@recife.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

This doesn't fix the problem *at all*.

See http://www.mail-archive.com/linux-media@vger.kernel.org/msg79474.html for
the right fix.

So for your patch:

Nacked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

On 09/18/14 12:06, Mauro Carvalho Chehab wrote:
> This reverts commit 9241650d62f79a3da01f1d5e8ebd195083330b75.
> 
> The commit 9241650d62f7 was meant to solve a race issue that
> affects Gstreamer version 0.10, when streaming for a long time.
> 
> It does that by returning POLERR if VB2 is not streaming.
> 
> However, it broke VBI userspace support on alevt and mtt (and maybe
> other VBI apps), as they rely on the old behavior.
> 
> Due to that, we need to roll back and restore the previous behavior.
> 
> For more details, see:
> 	https://bugzilla.kernel.org/show_bug.cgi?id=84401
> 
> So, let's rollback the change for now, and work on some other
> fix for it.
> 
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Pawel Osciak <pawel@osciak.com>
> Cc: Nicolas Dufresne <nicolas.dufresne@collabora.com>
> Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> 
> 
> --
> 
> v2: Just changed the description.
> 
> This is a regression that broke a core feature with most (all) VBI
> apps. We should hurry sending a fix for it.
> 
> So, let's just revert the patch while we're discussing/testing a
> solution that would solve Laurent's usecase scenario without breaking
> VBI.
> 
> PS.: this patch should, of course, be c/c to 3.16 too, but I think we'll
> need to do a manual backport, as the check for q->error is likely newer
> than 3.16.
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index 7e6aff673a5a..da2d0adcc992 100644
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
> +	if (list_empty(&q->queued_list) || q->error)
>  		return res | POLLERR;
>  
>  	/*
> 
