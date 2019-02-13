Return-Path: <SRS0=D6oO=QU=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0034C282C2
	for <linux-media@archiver.kernel.org>; Wed, 13 Feb 2019 09:31:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A9E5E21901
	for <linux-media@archiver.kernel.org>; Wed, 13 Feb 2019 09:31:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726209AbfBMJbN (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 13 Feb 2019 04:31:13 -0500
Received: from mslow2.mail.gandi.net ([217.70.178.242]:37060 "EHLO
        mslow2.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725818AbfBMJbN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Feb 2019 04:31:13 -0500
Received: from relay12.mail.gandi.net (unknown [217.70.178.232])
        by mslow2.mail.gandi.net (Postfix) with ESMTP id 670363A7CC6
        for <linux-media@vger.kernel.org>; Wed, 13 Feb 2019 10:22:41 +0100 (CET)
Received: from aptenodytes (aaubervilliers-681-1-89-68.w90-88.abo.wanadoo.fr [90.88.30.68])
        (Authenticated sender: paul.kocialkowski@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id A4848200006;
        Wed, 13 Feb 2019 09:22:39 +0000 (UTC)
Message-ID: <bf52c276e12c095ceb832d5327efb13f25ca37c9.camel@bootlin.com>
Subject: Re: [PATCHv2 2/3] vb2: keep track of timestamp status
From:   Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To:     hverkuil-cisco@xs4all.nl, linux-media@vger.kernel.org
Cc:     Nicolas Dufresne <nicolas@ndufresne.ca>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>
Date:   Wed, 13 Feb 2019 10:22:39 +0100
In-Reply-To: <20190204101134.56283-3-hverkuil-cisco@xs4all.nl>
References: <20190204101134.56283-1-hverkuil-cisco@xs4all.nl>
         <20190204101134.56283-3-hverkuil-cisco@xs4all.nl>
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
> If a stream is stopped, or if a USERPTR/DMABUF buffer is queued
> backed by a different user address or dmabuf fd, then the timestamp
> should be skipped by vb2_find_timestamp since the memory it refers
> to is no longer valid.
> 
> So keep track of a 'copied_timestamp' state: it is set when the
> timestamp is copied from an output to a capture buffer, and is
> cleared when it is no longer valid.

Reviewed-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>

Cheers,

Paul

> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> ---
>  drivers/media/common/videobuf2/videobuf2-core.c | 3 +++
>  drivers/media/common/videobuf2/videobuf2-v4l2.c | 3 ++-
>  drivers/media/v4l2-core/v4l2-mem2mem.c          | 1 +
>  include/media/videobuf2-core.h                  | 3 +++
>  4 files changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
> index 35cf36686e20..dc29bd01d6c5 100644
> --- a/drivers/media/common/videobuf2/videobuf2-core.c
> +++ b/drivers/media/common/videobuf2/videobuf2-core.c
> @@ -1041,6 +1041,7 @@ static int __prepare_userptr(struct vb2_buffer *vb)
>  		if (vb->planes[plane].mem_priv) {
>  			if (!reacquired) {
>  				reacquired = true;
> +				vb->copied_timestamp = 0;
>  				call_void_vb_qop(vb, buf_cleanup, vb);
>  			}
>  			call_void_memop(vb, put_userptr, vb->planes[plane].mem_priv);
> @@ -1165,6 +1166,7 @@ static int __prepare_dmabuf(struct vb2_buffer *vb)
>  
>  		if (!reacquired) {
>  			reacquired = true;
> +			vb->copied_timestamp = 0;
>  			call_void_vb_qop(vb, buf_cleanup, vb);
>  		}
>  
> @@ -1943,6 +1945,7 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
>  		if (vb->request)
>  			media_request_put(vb->request);
>  		vb->request = NULL;
> +		vb->copied_timestamp = 0;
>  	}
>  }
>  
> diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
> index 3aeaea3af42a..55277370c313 100644
> --- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
> +++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
> @@ -604,7 +604,8 @@ int vb2_find_timestamp(const struct vb2_queue *q, u64 timestamp,
>  	unsigned int i;
>  
>  	for (i = start_idx; i < q->num_buffers; i++)
> -		if (q->bufs[i]->timestamp == timestamp)
> +		if (q->bufs[i]->copied_timestamp &&
> +		    q->bufs[i]->timestamp == timestamp)
>  			return i;
>  	return -1;
>  }
> diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
> index 631f4e2aa942..64b19ee1c847 100644
> --- a/drivers/media/v4l2-core/v4l2-mem2mem.c
> +++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
> @@ -992,6 +992,7 @@ void v4l2_m2m_buf_copy_data(const struct vb2_v4l2_buffer *out_vb,
>  	cap_vb->field = out_vb->field;
>  	cap_vb->flags &= ~mask;
>  	cap_vb->flags |= out_vb->flags & mask;
> +	cap_vb->vb2_buf.copied_timestamp = 1;
>  }
>  EXPORT_SYMBOL_GPL(v4l2_m2m_buf_copy_data);
>  
> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
> index 2757d1902609..62488d901747 100644
> --- a/include/media/videobuf2-core.h
> +++ b/include/media/videobuf2-core.h
> @@ -262,6 +262,8 @@ struct vb2_buffer {
>  	 * prepared:		this buffer has been prepared, i.e. the
>  	 *			buf_prepare op was called. It is cleared again
>  	 *			after the 'buf_finish' op is called.
> +	 * copied_timestamp:	the timestamp of this capture buffer was copied
> +	 *			from an output buffer.
>  	 * queued_entry:	entry on the queued buffers list, which holds
>  	 *			all buffers queued from userspace
>  	 * done_entry:		entry on the list that stores all buffers ready
> @@ -271,6 +273,7 @@ struct vb2_buffer {
>  	enum vb2_buffer_state	state;
>  	unsigned int		synced:1;
>  	unsigned int		prepared:1;
> +	unsigned int		copied_timestamp:1;
>  
>  	struct vb2_plane	planes[VB2_MAX_PLANES];
>  	struct list_head	queued_entry;
-- 
Paul Kocialkowski, Bootlin
Embedded Linux and kernel engineering
https://bootlin.com

