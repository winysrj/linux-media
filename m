Return-Path: <SRS0=I/aX=RX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77A46C43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 12:55:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4291F2146E
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 12:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553086509;
	bh=J1EtI3Pkd4rAMcQtj56PUDtH9N9PqMfY7CrNQ9XRdZY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=ho26k6IgUq+EMTkl6MzrtjWFWQ7ftsdrqkRWFZecwKs9TASS80Th+znYlI6ZKdk88
	 wO6a9WFEzd2nybH/W/aLSQvYST0P0jGKGJttzHl1xRRRIOVB/tX0nE3r8bsiaehxxg
	 VrhtD02hdRxA4eYP3HUHtw0XoFYAOPt+L039530Y=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727371AbfCTMzI (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Mar 2019 08:55:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:32880 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726239AbfCTMzH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Mar 2019 08:55:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=O+c99e+c05Yxpey9lniy6a0+/UDuPDzUYVNRu6a2lqk=; b=ao8kHguHVDFF4no6DOaPbAda9y
        WUTYMZdu9g/8I+bUEUI5SF0SD47kgClvIy0nzC9jrf2ocN+d8uCH/Uvj14LYe8izfJrkLS1DvQW6I
        LmXHNzOhpscCC6Xouf21eRCBRv65MxM81abeBF7RqYI1aOTR7f3w5MI9TGsK+AJSrxKxfG9HpPb7c
        KU/TKZNV+cK7N1DXoHg6zX8adEaeURKp5+fjkWKtyWvoWiInnBgMAt86dzNwsWniGzQMEqdyVWwYd
        SFB1wfWwh4qf29Q5qwq3us24+Uw5BjfYz8sYZW+KRzEgsN9YBtCfwLj5DOOzakOKYSZ8cTUcaadpg
        fUlDW6gg==;
Received: from [179.95.24.146] (helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1h6akL-0006Lw-J9; Wed, 20 Mar 2019 12:55:06 +0000
Date:   Wed, 20 Mar 2019 09:55:01 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     hverkuil-cisco@xs4all.nl
Cc:     linux-media@vger.kernel.org,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Subject: Re: [PATCH v5.1 1/2] vb2: add requires_requests bit for stateless
 codecs
Message-ID: <20190320095501.62ff031e@coco.lan>
In-Reply-To: <20190320123305.5224-2-hverkuil-cisco@xs4all.nl>
References: <20190320123305.5224-1-hverkuil-cisco@xs4all.nl>
        <20190320123305.5224-2-hverkuil-cisco@xs4all.nl>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Wed, 20 Mar 2019 13:33:04 +0100
hverkuil-cisco@xs4all.nl escreveu:

> From: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> 
> Stateless codecs require the use of the Request API as opposed of it
> being optional.
> 
> So add a bit to indicate this and let vb2 check for this.
> 
> If an attempt is made to queue a buffer without an associated request,
> then the EBADR error is returned to userspace.
> 
> Doing this check in the vb2 core simplifies drivers, since they
> don't have to check for this, they can just set this flag.
> 
> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> Reviewed-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> ---
>  Documentation/media/uapi/v4l/vidioc-qbuf.rst    | 4 ++++
>  drivers/media/common/videobuf2/videobuf2-core.c | 9 +++++++++
>  drivers/media/common/videobuf2/videobuf2-v4l2.c | 4 ++++
>  include/media/videobuf2-core.h                  | 3 +++
>  4 files changed, 20 insertions(+)
> 
> diff --git a/Documentation/media/uapi/v4l/vidioc-qbuf.rst b/Documentation/media/uapi/v4l/vidioc-qbuf.rst
> index c138d149faea..5739c3676062 100644
> --- a/Documentation/media/uapi/v4l/vidioc-qbuf.rst
> +++ b/Documentation/media/uapi/v4l/vidioc-qbuf.rst
> @@ -189,6 +189,10 @@ EACCES
>      The ``V4L2_BUF_FLAG_REQUEST_FD`` flag was set but the device does not
>      support requests for the given buffer type.
>  
> +EBADR
> +    The ``V4L2_BUF_FLAG_REQUEST_FD`` flag was not set but the device requires
> +    that the buffer is part of a request.
> +

Hmm... IMO, you should replace the previous text instead:

	EACCES
	    The ``V4L2_BUF_FLAG_REQUEST_FD`` flag was set but the device does not
	    support requests for the given buffer type.

Also, I would replace:

	device -> device driver

As this ia a device driver limitation of the current implementation, 
with may or may not reflect a hardware limitation.

>  EBUSY
>      The first buffer was queued via a request, but the application now tries
>      to queue it directly, or vice versa (it is not permitted to mix the two
> diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
> index 678a31a2b549..b98ec6e1a222 100644
> --- a/drivers/media/common/videobuf2/videobuf2-core.c
> +++ b/drivers/media/common/videobuf2/videobuf2-core.c
> @@ -1507,6 +1507,12 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb,
>  
>  	vb = q->bufs[index];
>  
> +	if (!req && vb->state != VB2_BUF_STATE_IN_REQUEST &&
> +	    q->requires_requests) {
> +		dprintk(1, "qbuf requires a request\n");
> +		return -EBADR;
> +	}
> +
>  	if ((req && q->uses_qbuf) ||
>  	    (!req && vb->state != VB2_BUF_STATE_IN_REQUEST &&
>  	     q->uses_requests)) {
> @@ -2238,6 +2244,9 @@ int vb2_core_queue_init(struct vb2_queue *q)
>  	    WARN_ON(!q->ops->buf_queue))
>  		return -EINVAL;
>  
> +	if (WARN_ON(q->requires_requests && !q->supports_requests))
> +		return -EINVAL;
> +

Shouldn't it also be EBADR?

>  	INIT_LIST_HEAD(&q->queued_list);
>  	INIT_LIST_HEAD(&q->done_list);
>  	spin_lock_init(&q->done_lock);
> diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
> index 74d3abf33b50..84de18b30a95 100644
> --- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
> +++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
> @@ -381,6 +381,10 @@ static int vb2_queue_or_prepare_buf(struct vb2_queue *q, struct media_device *md
>  		return 0;
>  
>  	if (!(b->flags & V4L2_BUF_FLAG_REQUEST_FD)) {
> +		if (q->requires_requests) {
> +			dprintk(1, "%s: queue requires requests\n", opname);
> +			return -EBADR;
> +		}
>  		if (q->uses_requests) {
>  			dprintk(1, "%s: queue uses requests\n", opname);
>  			return -EBUSY;
> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
> index c02af6370e9b..fe010ad62b90 100644
> --- a/include/media/videobuf2-core.h
> +++ b/include/media/videobuf2-core.h
> @@ -482,6 +482,8 @@ struct vb2_buf_ops {
>   *              has not been called. This is a vb1 idiom that has been adopted
>   *              also by vb2.
>   * @supports_requests: this queue supports the Request API.
> + * @requires_requests: this queue requires the Request API. If this is set to 1,
> + *		then supports_requests must be set to 1 as well.
>   * @uses_qbuf:	qbuf was used directly for this queue. Set to 1 the first
>   *		time this is called. Set to 0 when the queue is canceled.
>   *		If this is 1, then you cannot queue buffers from a request.
> @@ -556,6 +558,7 @@ struct vb2_queue {
>  	unsigned			allow_zero_bytesused:1;
>  	unsigned		   quirk_poll_must_check_waiting_for_buffers:1;
>  	unsigned			supports_requests:1;
> +	unsigned			requires_requests:1;
>  	unsigned			uses_qbuf:1;
>  	unsigned			uses_requests:1;
>  



Thanks,
Mauro
