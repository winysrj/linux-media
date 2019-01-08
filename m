Return-Path: <SRS0=gjtM=PQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B7B3C43387
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 13:09:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 178742087E
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 13:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1546952989;
	bh=61G0apFne7Z8iV+fpQoppUnIvq5Us6TIBQQFEbbi8ss=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=WXKWtB3g+1qHSisdvx2yFkyHqMsEpuk7TSCYPMA4MDnPbw83tHZDOYOpmc9avff/F
	 2xHU1rhWwTjZDwdl6Wbsh/3u/CtBV5ILsqICFe/pcqBCfx/Rld9X/yFld/+rEc+cqm
	 QOO47rfbVItjweJL2ysuHqI+2CNtVeC8p21ac5b0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728188AbfAHNJs (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 8 Jan 2019 08:09:48 -0500
Received: from casper.infradead.org ([85.118.1.10]:50782 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727484AbfAHNJs (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2019 08:09:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=uYNqUcaFouGWxYlaNEbdSphn+9z9F5n4CBjQuoP1Jzg=; b=ljp+AL0sL/qX1Mxb7HTT8Lv81x
        dmru2G2AvVVvQLerdJSgM0CmeCnqDqShhKiJZqObL7BGxkqa8IksPCgUH/QR2PKU0rVf4vie2RFX0
        ox2CeUtImLXQn5ABgac3Dw3KDY1uDIxTWWq60hxl6abI6GUBpKv/P17lTHXYKS9i6aVbtjJlq+q9/
        BfrC+pRtZ5SboczA+yoKGTlsez+cz3urWqkbi6V9EknQyDutniIdFALoBEoGFCrlYYQduQuHFKgqC
        jjmx51POlFB+uC/OnTbZ1sQfdy1p39LTy6gohy2tHKv3BRDZDjI5TtUcttv1OKxmT4NZarNviMv5e
        b1ukp5EA==;
Received: from 177.41.113.230.dynamic.adsl.gvt.net.br ([177.41.113.230] helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1ggr8c-0003P4-Co; Tue, 08 Jan 2019 13:09:46 +0000
Date:   Tue, 8 Jan 2019 11:09:42 -0200
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     linux-media@vger.kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH v2 2/3] videobuf2-dma-sg: Prevent size from overflowing
Message-ID: <20190108110942.7a58d455@coco.lan>
In-Reply-To: <20190108085836.9376-3-sakari.ailus@linux.intel.com>
References: <20190108085836.9376-1-sakari.ailus@linux.intel.com>
        <20190108085836.9376-3-sakari.ailus@linux.intel.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Tue,  8 Jan 2019 10:58:35 +0200
Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:

> buf->size is an unsigned long; casting that to int will lead to an
> overflow if buf->size exceeds INT_MAX.
> 
> Fix this by changing the type to unsigned long instead. This is possible
> as the buf->size is always aligned to PAGE_SIZE, and therefore the size
> will never have values lesser than 0.
> 
> Note on backporting to stable: the file used to be under
> drivers/media/v4l2-core, it was moved to the current location after 4.14.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: stable@vger.kernel.org
> Reviewed-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> ---
>  drivers/media/common/videobuf2/videobuf2-dma-sg.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/common/videobuf2/videobuf2-dma-sg.c b/drivers/media/common/videobuf2/videobuf2-dma-sg.c
> index 015e737095cd..5fdb8d7051f6 100644
> --- a/drivers/media/common/videobuf2/videobuf2-dma-sg.c
> +++ b/drivers/media/common/videobuf2/videobuf2-dma-sg.c
> @@ -59,7 +59,10 @@ static int vb2_dma_sg_alloc_compacted(struct vb2_dma_sg_buf *buf,
>  		gfp_t gfp_flags)
>  {
>  	unsigned int last_page = 0;
> -	int size = buf->size;
> +	unsigned long size = buf->size;

OK.

> +
> +	if (WARN_ON(size & ~PAGE_MASK))
> +		return -ENOMEM;

Hmm... why do we need a warn on here? This is called by this code:

static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
{
	struct vb2_queue *q = vb->vb2_queue;
	void *mem_priv;
	int plane;
	int ret = -ENOMEM;

	/*
	 * Allocate memory for all planes in this buffer
	 * NOTE: mmapped areas should be page aligned
	 */
	for (plane = 0; plane < vb->num_planes; ++plane) {
		unsigned long size = PAGE_ALIGN(vb->planes[plane].length);

		mem_priv = call_ptr_memop(vb, alloc,
				q->alloc_devs[plane] ? : q->dev,
				q->dma_attrs, size, q->dma_dir, q->gfp_flags);

With already insures that size is page aligned.

Thanks,
Mauro
