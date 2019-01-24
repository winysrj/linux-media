Return-Path: <SRS0=42/h=QA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EA75C282C3
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 09:03:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 68DA620854
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 09:03:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727386AbfAXJDc (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 24 Jan 2019 04:03:32 -0500
Received: from mail.bootlin.com ([62.4.15.54]:57373 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726997AbfAXJDc (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Jan 2019 04:03:32 -0500
Received: by mail.bootlin.com (Postfix, from userid 110)
        id 8BF90209BE; Thu, 24 Jan 2019 10:03:29 +0100 (CET)
Received: from aptenodytes (aaubervilliers-681-1-87-206.w90-88.abo.wanadoo.fr [90.88.29.206])
        by mail.bootlin.com (Postfix) with ESMTPSA id 58B25209B6;
        Thu, 24 Jan 2019 10:03:19 +0100 (CET)
Message-ID: <8cef37db336ae899b63b6fb52c9f6b64766a5a4e.camel@bootlin.com>
Subject: Re: [PATCHv2] vb2: vb2_find_timestamp: drop restriction on buffer
 state
From:   Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To:     Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>
Date:   Thu, 24 Jan 2019 10:03:19 +0100
In-Reply-To: <3bc5f149-895d-468d-81ee-1c7c4cbae8d8@xs4all.nl>
References: <3bc5f149-895d-468d-81ee-1c7c4cbae8d8@xs4all.nl>
Organization: Bootlin
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

HI,

On Thu, 2019-01-24 at 09:47 +0100, Hans Verkuil wrote:
> There really is no reason why vb2_find_timestamp can't just find
> buffers in any state. Drop that part of the test.
> 
> This also means that vb->timestamp should only be set to 0 when
> the driver doesn't copy timestamps.
> 
> This change allows for more efficient pipelining (i.e. you can use
> a buffer for a reference frame even when it is queued).
> 
> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>

Reviewed-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>

I guess I'll prepare a new patch to revert the change I made earlier
for cedrus, since it's no longer needed!

Cheers,

Paul

> ---
> Changes since v1: set timestamp to 0 unless copy_timestamp is set instead of also
> checking whether it is an output queue.
> ---
> diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
> index 75ea90e795d8..2a093bff0bf5 100644
> --- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
> +++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
> @@ -567,7 +567,7 @@ static int __fill_vb2_buffer(struct vb2_buffer *vb, struct vb2_plane *planes)
>  	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
>  	unsigned int plane;
> 
> -	if (!vb->vb2_queue->is_output || !vb->vb2_queue->copy_timestamp)
> +	if (!vb->vb2_queue->copy_timestamp)
>  		vb->timestamp = 0;
> 
>  	for (plane = 0; plane < vb->num_planes; ++plane) {
> @@ -594,14 +594,9 @@ int vb2_find_timestamp(const struct vb2_queue *q, u64 timestamp,
>  {
>  	unsigned int i;
> 
> -	for (i = start_idx; i < q->num_buffers; i++) {
> -		struct vb2_buffer *vb = q->bufs[i];
> -
> -		if ((vb->state == VB2_BUF_STATE_DEQUEUED ||
> -		     vb->state == VB2_BUF_STATE_DONE) &&
> -		    vb->timestamp == timestamp)
> +	for (i = start_idx; i < q->num_buffers; i++)
> +		if (q->bufs[i]->timestamp == timestamp)
>  			return i;
> -	}
>  	return -1;
>  }
>  EXPORT_SYMBOL_GPL(vb2_find_timestamp);
> diff --git a/include/media/videobuf2-v4l2.h b/include/media/videobuf2-v4l2.h
> index a9961bc776dc..8a10889dc2fd 100644
> --- a/include/media/videobuf2-v4l2.h
> +++ b/include/media/videobuf2-v4l2.h
> @@ -59,8 +59,7 @@ struct vb2_v4l2_buffer {
>   * vb2_find_timestamp() - Find buffer with given timestamp in the queue
>   *
>   * @q:		pointer to &struct vb2_queue with videobuf2 queue.
> - * @timestamp:	the timestamp to find. Only buffers in state DEQUEUED or DONE
> - *		are considered.
> + * @timestamp:	the timestamp to find.
>   * @start_idx:	the start index (usually 0) in the buffer array to start
>   *		searching from. Note that there may be multiple buffers
>   *		with the same timestamp value, so you can restart the search
-- 
Paul Kocialkowski, Bootlin
Embedded Linux and kernel engineering
https://bootlin.com

