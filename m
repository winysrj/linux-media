Return-Path: <SRS0=D6oO=QU=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 238ADC282C2
	for <linux-media@archiver.kernel.org>; Wed, 13 Feb 2019 09:22:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EDD47222C0
	for <linux-media@archiver.kernel.org>; Wed, 13 Feb 2019 09:22:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728827AbfBMJWX (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 13 Feb 2019 04:22:23 -0500
Received: from relay10.mail.gandi.net ([217.70.178.230]:45515 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726573AbfBMJWX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Feb 2019 04:22:23 -0500
Received: from aptenodytes (aaubervilliers-681-1-89-68.w90-88.abo.wanadoo.fr [90.88.30.68])
        (Authenticated sender: paul.kocialkowski@bootlin.com)
        by relay10.mail.gandi.net (Postfix) with ESMTPSA id 9BA37240004;
        Wed, 13 Feb 2019 09:22:20 +0000 (UTC)
Message-ID: <fc5e1a526cb2324d6116ec4af248b6ad7b6b078c.camel@bootlin.com>
Subject: Re: [PATCHv2 1/3] vb2: replace bool by bitfield in vb2_buffer
From:   Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To:     hverkuil-cisco@xs4all.nl, linux-media@vger.kernel.org
Cc:     Nicolas Dufresne <nicolas@ndufresne.ca>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>
Date:   Wed, 13 Feb 2019 10:22:20 +0100
In-Reply-To: <20190204101134.56283-2-hverkuil-cisco@xs4all.nl>
References: <20190204101134.56283-1-hverkuil-cisco@xs4all.nl>
         <20190204101134.56283-2-hverkuil-cisco@xs4all.nl>
Organization: Bootlin
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi,

On Mon, 2019-02-04 at 11:11 +0100, hverkuil-cisco@xs4all.nl wrote:
> From: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> 
> The bool type is not recommended for use in structs, so replace these
> by bitfields.
> 
> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>

Reviewed-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>

Cheers,

Paul

> ---
>  drivers/media/common/videobuf2/videobuf2-core.c | 12 ++++++------
>  include/media/videobuf2-core.h                  |  4 ++--
>  2 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
> index e07b6bdb6982..35cf36686e20 100644
> --- a/drivers/media/common/videobuf2/videobuf2-core.c
> +++ b/drivers/media/common/videobuf2/videobuf2-core.c
> @@ -934,7 +934,7 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
>  		/* sync buffers */
>  		for (plane = 0; plane < vb->num_planes; ++plane)
>  			call_void_memop(vb, finish, vb->planes[plane].mem_priv);
> -		vb->synced = false;
> +		vb->synced = 0;
>  	}
>  
>  	spin_lock_irqsave(&q->done_lock, flags);
> @@ -1313,8 +1313,8 @@ static int __buf_prepare(struct vb2_buffer *vb)
>  	for (plane = 0; plane < vb->num_planes; ++plane)
>  		call_void_memop(vb, prepare, vb->planes[plane].mem_priv);
>  
> -	vb->synced = true;
> -	vb->prepared = true;
> +	vb->synced = 1;
> +	vb->prepared = 1;
>  	vb->state = orig_state;
>  
>  	return 0;
> @@ -1803,7 +1803,7 @@ int vb2_core_dqbuf(struct vb2_queue *q, unsigned int *pindex, void *pb,
>  	}
>  
>  	call_void_vb_qop(vb, buf_finish, vb);
> -	vb->prepared = false;
> +	vb->prepared = 0;
>  
>  	if (pindex)
>  		*pindex = vb->index;
> @@ -1927,12 +1927,12 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
>  			for (plane = 0; plane < vb->num_planes; ++plane)
>  				call_void_memop(vb, finish,
>  						vb->planes[plane].mem_priv);
> -			vb->synced = false;
> +			vb->synced = 0;
>  		}
>  
>  		if (vb->prepared) {
>  			call_void_vb_qop(vb, buf_finish, vb);
> -			vb->prepared = false;
> +			vb->prepared = 0;
>  		}
>  		__vb2_dqbuf(vb);
>  
> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
> index 4849b865b908..2757d1902609 100644
> --- a/include/media/videobuf2-core.h
> +++ b/include/media/videobuf2-core.h
> @@ -269,8 +269,8 @@ struct vb2_buffer {
>  	 * vb2_plane:		per-plane information; do not change
>  	 */
>  	enum vb2_buffer_state	state;
> -	bool			synced;
> -	bool			prepared;
> +	unsigned int		synced:1;
> +	unsigned int		prepared:1;
>  
>  	struct vb2_plane	planes[VB2_MAX_PLANES];
>  	struct list_head	queued_entry;
-- 
Paul Kocialkowski, Bootlin
Embedded Linux and kernel engineering
https://bootlin.com

