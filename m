Return-Path: <SRS0=I/aX=RX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C62DC4360F
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 10:21:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6920421850
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 10:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553077312;
	bh=8LzJgL2WUdoBOIJPWK7Esk1AOf9+E3bwAVsmIo5L95s=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=shCF4yeVdaRQNLC8qL8w28/BqJNpjKdQZiBrvvgDM7aX6vLY2Zxe0ylw+EG5YrlQU
	 Wa+8bwCAOSrKcmr/Bi2VZT0fVI5aLP8IdtEp57vmQbiB9SSlpkH0dpNDQWGeVjL9XY
	 HhMHMPi8sKGkDutLz07Z8mZquXULyHySypgcjX8U=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727585AbfCTKVv (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Mar 2019 06:21:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:51998 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727651AbfCTKVu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Mar 2019 06:21:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=obbYesvvmrrlZzPC8HbzGNNgGiPbVrxMqZWpSsRWcQ8=; b=PgCJ9FeZiDJxjpw8tKOEcjiK8D
        q4SeB9Xr8ZVxsR/EO2eFZ5vnBTYu9iE1P2JwinryO2/QuPmqfDHllvNgNGN08yMQqxLnUPTikcwPb
        qkJHygzYaUn9vyzlX4h903x0Nhb8Va3Za0F6dtd2q+rNHvPXZpiA46vGdo9Fk5yf91AUmeWn6Ea59
        1Nbypo/0d1vrFAJGc52kg14F5aCX79ZFvxtDGe9mXtAjNT7i8uN6WU7hIVz6RKzsS2gZnCFX3/aOM
        /MNoX0xs6cd3sFoIwuSkVHuGEL9UU7/vh9zSpkNvZ4yJygvNappmbhJHodpr4P2npydFIg0skMHxL
        BS6adxlA==;
Received: from [179.95.24.146] (helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1h6YLz-0001dS-Oc; Wed, 20 Mar 2019 10:21:48 +0000
Date:   Wed, 20 Mar 2019 07:21:43 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Dafna Hirschfeld <dafna3@gmail.com>
Cc:     linux-media@vger.kernel.org, hverkuil@xs4all.nl,
        helen.koike@collabora.com, Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: Re: [PATCH v5 01/23] vb2: add requires_requests bit for stateless
 codecs
Message-ID: <20190320072124.675fd13b@coco.lan>
In-Reply-To: <20190306211343.15302-2-dafna3@gmail.com>
References: <20190306211343.15302-1-dafna3@gmail.com>
        <20190306211343.15302-2-dafna3@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Wed,  6 Mar 2019 13:13:21 -0800
Dafna Hirschfeld <dafna3@gmail.com> escreveu:

> From: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> 
> Stateless codecs require the use of the Request API as opposed of it
> being optional.
> 
> So add a bit to indicate this and let vb2 check for this.
> 
> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
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

Huh? -EBUSY doesn't seem the right error code to be issued if a driver
ignores V4L2_BUF_CAP_REQUIRES_REQUESTS.

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

I also don't think that -EACCES is the right error. This is not a matter of
wrong permissions. Running the app as root won't make it work.

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



Thanks,
Mauro
