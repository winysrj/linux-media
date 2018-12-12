Return-Path: <SRS0=2Dg0=OV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2D6FC04EB8
	for <linux-media@archiver.kernel.org>; Wed, 12 Dec 2018 09:13:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A337B2086D
	for <linux-media@archiver.kernel.org>; Wed, 12 Dec 2018 09:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544606006;
	bh=WaogoaWjqAZub9nSxgTuyIeyKMGS/8IYF2akKtzDsMI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=g9ujHCedYY+JACZHAdkukayeupVqbhespeeQDWdz4iFhWe9LyemxfMNoxKQPemNp5
	 4v3OSAh0fAsS82IKYoR7B/BEuyBNpPou8a+dbGUK2GHaHdtXTTpbmYf22fDBlqMT25
	 +fHrX+cgQTWI6DGHEwqXIpSdFyNW9PaDA0z4FYy0=
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A337B2086D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726835AbeLLJNZ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 12 Dec 2018 04:13:25 -0500
Received: from casper.infradead.org ([85.118.1.10]:57272 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726755AbeLLJNZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Dec 2018 04:13:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=VQL2ACPpIZs+SYmSJm8fqhp0IdCmRaj/VsFPnWH5VRw=; b=RV0/kMl0Y6jnPLay5JaIS+rdRz
        DtkO7qLuRTIZidOzXgc6tSOVUQ2qHyj6eqF45CnZU2PNLmReBpyjkeA8hgE7g3BFegtGfa6DqZBvh
        nAsPN2cy1wGDQq93CrSEI8afNyiupThWnXJ8Uh1RFshBuPaii8DgU3NUjM+yDMgDjuBb5KMMP6hAB
        ViMSZqQ3FMBG2MtdjdPG5FoXFFwm07Z0hGdKgBXhkcrcJrU0PUhWBIuNNUxaeJNKSIobWypfa24aJ
        H7mt8q5epuw13l1XP4xq8G1/bkkQFiXHN3NvAleFkQzu+Pf8ZSOArMNAvZFpkn/FweUuXjb76BiNd
        zIB0QjGw==;
Received: from [177.159.254.7] (helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gX0a3-0007GM-Nc; Wed, 12 Dec 2018 09:13:24 +0000
Date:   Wed, 12 Dec 2018 07:13:19 -0200
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     hverkuil-cisco@xs4all.nl
Cc:     linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH 1/3] vb2: add buf_validate callback
Message-ID: <20181212071319.409ed29c@coco.lan>
In-Reply-To: <20181203124603.17932-1-hverkuil-cisco@xs4all.nl>
References: <20181203124603.17932-1-hverkuil-cisco@xs4all.nl>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Mon,  3 Dec 2018 13:46:01 +0100
hverkuil-cisco@xs4all.nl escreveu:

> From: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> 
> Adding the request API uncovered a pre-existing problem with
> validating output buffers.
> 
> The problem is that for output buffers the driver has to validate
> the 'field' field of struct v4l2_buffer. This is critical when
> encoding or deinterlacing interlaced video.
> 
> Drivers always did this in the buf_prepare callback, but that is
> not called from VIDIOC_QBUF in two situations: when queueing a
> buffer to a request and if VIDIOC_PREPARE_BUF has been called
> earlier for that buffer.

Hmm.. if I got it right, it will only affect drivers
using request API, right?

IMO, the description of the callback should be a way more
verbose, containing a summary of the explanation here.

> 
> As a result of this the 'field' value is not validated.
> 
> This patch adds a new buf_validate callback to validate the
> output buffer at QBUF time.
> 
> Note that PREPARE_BUF doesn't need to validate this: it just
> locks the buffer memory and doesn't need nor want to know about
> how this buffer is actually going to be used. It's the QBUF ioctl
> that determines this.
> 
> This issue was found by v4l2-compliance since it failed to replace
> V4L2_FIELD_ANY by a proper field value when testing the vivid video
> output in combination with requests.
> 
> There never was a test before for the PREPARE_BUF/QBUF case, so even
> though this bug has been present for quite some time, it was never
> noticed.
> 
> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> ---
>  drivers/media/common/videobuf2/videobuf2-core.c | 12 +++++++++---
>  include/media/videobuf2-core.h                  |  5 +++++
>  2 files changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
> index 0ca81d495bda..42eb7716f8a9 100644
> --- a/drivers/media/common/videobuf2/videobuf2-core.c
> +++ b/drivers/media/common/videobuf2/videobuf2-core.c
> @@ -499,9 +499,9 @@ static int __vb2_queue_free(struct vb2_queue *q, unsigned int buffers)
>  			pr_info("     buf_init: %u buf_cleanup: %u buf_prepare: %u buf_finish: %u\n",
>  				vb->cnt_buf_init, vb->cnt_buf_cleanup,
>  				vb->cnt_buf_prepare, vb->cnt_buf_finish);
> -			pr_info("     buf_queue: %u buf_done: %u buf_request_complete: %u\n",
> -				vb->cnt_buf_queue, vb->cnt_buf_done,
> -				vb->cnt_buf_request_complete);
> +			pr_info("     buf_validate: %u buf_queue: %u buf_done: %u buf_request_complete: %u\n",
> +				vb->cnt_buf_validate, vb->cnt_buf_queue,
> +				vb->cnt_buf_done, vb->cnt_buf_request_complete);
>  			pr_info("     alloc: %u put: %u prepare: %u finish: %u mmap: %u\n",
>  				vb->cnt_mem_alloc, vb->cnt_mem_put,
>  				vb->cnt_mem_prepare, vb->cnt_mem_finish,
> @@ -1506,6 +1506,12 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb,
>  		return -EBUSY;
>  	}
>  
> +	ret = call_vb_qop(vb, buf_validate, vb);
> +	if (ret) {
> +		dprintk(1, "buffer validation failed\n");
> +		return ret;
> +	}
> +
>  	if (req) {
>  		int ret;
>  
> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
> index e86981d615ae..c9f0f3f4ef9a 100644
> --- a/include/media/videobuf2-core.h
> +++ b/include/media/videobuf2-core.h
> @@ -294,6 +294,7 @@ struct vb2_buffer {
>  	u32		cnt_mem_num_users;
>  	u32		cnt_mem_mmap;
>  
> +	u32		cnt_buf_validate;
>  	u32		cnt_buf_init;
>  	u32		cnt_buf_prepare;
>  	u32		cnt_buf_finish;
> @@ -340,6 +341,9 @@ struct vb2_buffer {
>   * @wait_finish:	reacquire all locks released in the previous callback;
>   *			required to continue operation after sleeping while
>   *			waiting for a new buffer to arrive.
> + * @buf_validate:	called every time the buffer is queued from userspace;
> + *			drivers can use this to validate userspace-provided
> + *			information; optional.
>   * @buf_init:		called once after allocating a buffer (in MMAP case)
>   *			or after acquiring a new USERPTR buffer; drivers may
>   *			perform additional buffer-related initialization;
> @@ -407,6 +411,7 @@ struct vb2_ops {
>  	void (*wait_prepare)(struct vb2_queue *q);
>  	void (*wait_finish)(struct vb2_queue *q);
>  
> +	int (*buf_validate)(struct vb2_buffer *vb);
>  	int (*buf_init)(struct vb2_buffer *vb);
>  	int (*buf_prepare)(struct vb2_buffer *vb);
>  	void (*buf_finish)(struct vb2_buffer *vb);



Thanks,
Mauro
