Return-Path: <SRS0=ZIWa=RP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A18E6C43381
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 15:29:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 792602083D
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 15:29:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbfCLP3f (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Mar 2019 11:29:35 -0400
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:37037 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725895AbfCLP3f (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Mar 2019 11:29:35 -0400
X-Originating-IP: 90.88.22.102
Received: from aptenodytes (aaubervilliers-681-1-80-102.w90-88.abo.wanadoo.fr [90.88.22.102])
        (Authenticated sender: paul.kocialkowski@bootlin.com)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id E66EA240008;
        Tue, 12 Mar 2019 15:29:31 +0000 (UTC)
Message-ID: <8c7f6920833513818a290b778f0a4dc4a03c99b0.camel@bootlin.com>
Subject: Re: [PATCH v5 01/23] vb2: add requires_requests bit for stateless
 codecs
From:   Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To:     Dafna Hirschfeld <dafna3@gmail.com>, linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Date:   Tue, 12 Mar 2019 16:29:31 +0100
In-Reply-To: <20190306211343.15302-2-dafna3@gmail.com>
References: <20190306211343.15302-1-dafna3@gmail.com>
         <20190306211343.15302-2-dafna3@gmail.com>
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

On Wed, 2019-03-06 at 13:13 -0800, Dafna Hirschfeld wrote:
> From: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> 
> Stateless codecs require the use of the Request API as opposed of it
> being optional.
> 
> So add a bit to indicate this and let vb2 check for this.
> 
> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>

Reviewed-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>

Cheers,

Paul

> ---
>  drivers/media/common/videobuf2/videobuf2-core.c | 5 ++++-
>  drivers/media/common/videobuf2/videobuf2-v4l2.c | 6 ++++++
>  include/media/videobuf2-core.h                  | 3 +++
>  3 files changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
> index 15b6b9c0a2e4..d8cf9d3ec54d 100644
> --- a/drivers/media/common/videobuf2/videobuf2-core.c
> +++ b/drivers/media/common/videobuf2/videobuf2-core.c
> @@ -1518,7 +1518,7 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb,
>  
>  	if ((req && q->uses_qbuf) ||
>  	    (!req && vb->state != VB2_BUF_STATE_IN_REQUEST &&
> -	     q->uses_requests)) {
> +	     (q->uses_requests || q->requires_requests))) {
>  		dprintk(1, "queue in wrong mode (qbuf vs requests)\n");
>  		return -EBUSY;
>  	}
> @@ -2247,6 +2247,9 @@ int vb2_core_queue_init(struct vb2_queue *q)
>  	    WARN_ON(!q->ops->buf_queue))
>  		return -EINVAL;
>  
> +	if (WARN_ON(q->requires_requests && !q->supports_requests))
> +		return -EINVAL;
> +
>  	INIT_LIST_HEAD(&q->queued_list);
>  	INIT_LIST_HEAD(&q->done_list);
>  	spin_lock_init(&q->done_lock);
> diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
> index d09dee20e421..4dc4855056f1 100644
> --- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
> +++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
> @@ -385,6 +385,10 @@ static int vb2_queue_or_prepare_buf(struct vb2_queue *q, struct media_device *md
>  			dprintk(1, "%s: queue uses requests\n", opname);
>  			return -EBUSY;
>  		}
> +		if (q->requires_requests) {
> +			dprintk(1, "%s: queue requires requests\n", opname);
> +			return -EACCES;
> +		}
>  		return 0;
>  	} else if (!q->supports_requests) {
>  		dprintk(1, "%s: queue does not support requests\n", opname);
> @@ -658,6 +662,8 @@ static void fill_buf_caps(struct vb2_queue *q, u32 *caps)
>  #ifdef CONFIG_MEDIA_CONTROLLER_REQUEST_API
>  	if (q->supports_requests)
>  		*caps |= V4L2_BUF_CAP_SUPPORTS_REQUESTS;
> +	if (q->requires_requests)
> +		*caps |= V4L2_BUF_CAP_REQUIRES_REQUESTS;
>  #endif
>  }
>  
> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
> index 910f3d469005..fbf8dbbcbc09 100644
> --- a/include/media/videobuf2-core.h
> +++ b/include/media/videobuf2-core.h
> @@ -484,6 +484,8 @@ struct vb2_buf_ops {
>   *              has not been called. This is a vb1 idiom that has been adopted
>   *              also by vb2.
>   * @supports_requests: this queue supports the Request API.
> + * @requires_requests: this queue requires the Request API. If this is set to 1,
> + *		then supports_requests must be set to 1 as well.
>   * @uses_qbuf:	qbuf was used directly for this queue. Set to 1 the first
>   *		time this is called. Set to 0 when the queue is canceled.
>   *		If this is 1, then you cannot queue buffers from a request.
> @@ -558,6 +560,7 @@ struct vb2_queue {
>  	unsigned			allow_zero_bytesused:1;
>  	unsigned		   quirk_poll_must_check_waiting_for_buffers:1;
>  	unsigned			supports_requests:1;
> +	unsigned			requires_requests:1;
>  	unsigned			uses_qbuf:1;
>  	unsigned			uses_requests:1;
>  
-- 
Paul Kocialkowski, Bootlin
Embedded Linux and kernel engineering
https://bootlin.com

