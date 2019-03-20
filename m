Return-Path: <SRS0=I/aX=RX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C120BC43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 12:55:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8221F2184E
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 12:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553086548;
	bh=j317WtwHjtCD+jWf62mNS0f1bRXWMymUrVqvMNc/rYk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=IS+Pl5ay5yl3CKX23IRg7kpBSpNwDDIf4eKXyeqe7gtQYmM/4W6y63RkwXzU8wJe7
	 msFN0h+HST7Z+ZG3orWFxxpbXcKiOpr+cbcqXWt740CR+kbF4p8sq6ti4wZu/NnI+b
	 PsHN0yx9CK6ygTux9kQhTY9SJnSjPI2PukFt3v2U=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727135AbfCTMzs (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Mar 2019 08:55:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:32914 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726362AbfCTMzr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Mar 2019 08:55:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=UG5x1cTJMq4xnVr+GHD7riIdm3yYqs+QzlmkzKnSjeE=; b=A89Lh52gr1NbTrN621ivxM26Ui
        p7r9qCXZnCxDVuV75cRQeEGex9W3K2IUgJ7I7ikQPUWMpJ34fVXxJYOC/xW5vA2ypAhZzIH2Fy1ZB
        J8QDigeuq9YfZApN0Ume2aMncN5qg+5SDC34tMHWQ2gvf3CMejM8oSRdMHJP2hcv+C0RAEavoxo/D
        lF6X+pKM/mjMapRJwUodDaoFn6liW3v8KAHmPUVvSYlNjOrsvdJkUJOT4rnAXUERInKVfhENP8UgO
        HXHIetFv6nYS888SS89QVPT2t6jLU6g3Pskkaru+BHymnDVajrSym/bpYzdZprLbFBK3OhuDDkDhq
        +yxXg4+A==;
Received: from [179.95.24.146] (helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1h6akz-0006Nb-ET; Wed, 20 Mar 2019 12:55:46 +0000
Date:   Wed, 20 Mar 2019 09:55:41 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     hverkuil-cisco@xs4all.nl
Cc:     linux-media@vger.kernel.org,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Subject: Re: [PATCH v5.1 2/2] cedrus: set requires_requests
Message-ID: <20190320095541.445efaa5@coco.lan>
In-Reply-To: <20190320123305.5224-3-hverkuil-cisco@xs4all.nl>
References: <20190320123305.5224-1-hverkuil-cisco@xs4all.nl>
        <20190320123305.5224-3-hverkuil-cisco@xs4all.nl>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Wed, 20 Mar 2019 13:33:05 +0100
hverkuil-cisco@xs4all.nl escreveu:

> From: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> 
> The cedrus stateless decoder requires the use of request, so
> indicate this by setting requires_requests to 1.
> 
> Note that the cedrus driver never checked for this, and as far
> as I can tell would just crash if an attempt was made to queue
> a buffer without a request.
> 
> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> Acked-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> ---
>  drivers/staging/media/sunxi/cedrus/cedrus_video.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_video.c b/drivers/staging/media/sunxi/cedrus/cedrus_video.c
> index b47854b3bce4..9673874ece10 100644
> --- a/drivers/staging/media/sunxi/cedrus/cedrus_video.c
> +++ b/drivers/staging/media/sunxi/cedrus/cedrus_video.c
> @@ -536,6 +536,7 @@ int cedrus_queue_init(void *priv, struct vb2_queue *src_vq,
>  	src_vq->lock = &ctx->dev->dev_mutex;
>  	src_vq->dev = ctx->dev->dev;
>  	src_vq->supports_requests = true;
> +	src_vq->requires_requests = true;

looks OK to my eyes.

>  
>  	ret = vb2_queue_init(src_vq);
>  	if (ret)



Thanks,
Mauro
