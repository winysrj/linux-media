Return-Path: <SRS0=ZIWa=RP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E35BFC43381
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 07:57:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B9F66214D8
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 07:57:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727055AbfCLH5o (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Mar 2019 03:57:44 -0400
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:48816 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726518AbfCLH5o (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Mar 2019 03:57:44 -0400
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud8.xs4all.net with ESMTPA
        id 3cI6hYV454HFn3cIAhIFoh; Tue, 12 Mar 2019 08:57:42 +0100
Subject: Re: [PATCH] media: vb2-dc: skip CPU sync in map/unmap dma_buf
To:     Lucas Stach <l.stach@pengutronix.de>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, kernel@pengutronix.de,
        patchwork-lst@pengutronix.de
References: <20190228071943.13072-1-l.stach@pengutronix.de>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <74da532d-5490-0cd4-32a9-12606994775b@xs4all.nl>
Date:   Tue, 12 Mar 2019 08:57:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190228071943.13072-1-l.stach@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfFCp/hDz+zkuDC7o1XWNswIfCGH4xrowL1ZGQ5OSSIpVcDqN6Q2wR6TBJkzPD2stXxWuIRG0Qf9x02WLSy6zdI9QQS//N79LKhqX3y/mvKc8Nzibs/vm
 OKUFUS7rUs0ejP+JXWgMmkhO48efdJqHT/jWmGJz+7c14cuMtMZD6wUFzFkQbTYQbOSsfOvrfXhJ6ekUAlwifv5WQeM1vq7Fj8PhH1VU0KrI/CP7q0Sk4p+F
 l6Emb2eO0HfhxqwCPkNfj1Gpui6PK3KRSmSFdrNwPOHyj6hdDMZUuJSN1Tii3JBsZgwOyNqMOFsv62dSu4g7RS/CzAhLm/j5zhIPY3c30ALP+r0RJGthJYmp
 OZyIcce2CAh724wG2c+MIHD6r0AvhTHqoltKaAiDHPSo1HJV9yenWRe+pbmyjzxtsyq7RNxb
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Pawel and/or Marek, can you take a look at this?

It looks sane to me, but I'd like to have a second opinion as well before
merging this.

On 2/28/19 8:19 AM, Lucas Stach wrote:
> This is rougly equivalent to ca0e68e21aae (drm/prime: skip CPU sync
> in map/unmap dma_buf). The contig memory allocated is already device
> coherent memory, so there is no point in doing a CPU sync when
> mapping it to another device. Also most importers currently cache
> the mapping so the CPU sync would only happen on the first import.
> With that in mind we are better off with not pretending to do a
> cache synchronization at all.
> 
> This gets rid of a lot of CPU overhead in uses where those dma-bufs
> are regularily imported and detached again, like Weston is currently
> doing in the DRM compositor.

Lucas, one question: shouldn't the same be done for dma-sg and vmalloc?

Regards,

	Hans

> 
> Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
> ---
>  drivers/media/common/videobuf2/videobuf2-dma-contig.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/common/videobuf2/videobuf2-dma-contig.c b/drivers/media/common/videobuf2/videobuf2-dma-contig.c
> index aff0ab7bf83d..d38f097c14ae 100644
> --- a/drivers/media/common/videobuf2/videobuf2-dma-contig.c
> +++ b/drivers/media/common/videobuf2/videobuf2-dma-contig.c
> @@ -273,8 +273,8 @@ static void vb2_dc_dmabuf_ops_detach(struct dma_buf *dbuf,
>  
>  	/* release the scatterlist cache */
>  	if (attach->dma_dir != DMA_NONE)
> -		dma_unmap_sg(db_attach->dev, sgt->sgl, sgt->orig_nents,
> -			attach->dma_dir);
> +		dma_unmap_sg_attrs(db_attach->dev, sgt->sgl, sgt->orig_nents,
> +			attach->dma_dir, DMA_ATTR_SKIP_CPU_SYNC);
>  	sg_free_table(sgt);
>  	kfree(attach);
>  	db_attach->priv = NULL;
> @@ -305,8 +305,8 @@ static struct sg_table *vb2_dc_dmabuf_ops_map(
>  	}
>  
>  	/* mapping to the client with new direction */
> -	sgt->nents = dma_map_sg(db_attach->dev, sgt->sgl, sgt->orig_nents,
> -				dma_dir);
> +	sgt->nents = dma_map_sg_attrs(db_attach->dev, sgt->sgl, sgt->orig_nents,
> +				dma_dir, DMA_ATTR_SKIP_CPU_SYNC);
>  	if (!sgt->nents) {
>  		pr_err("failed to map scatterlist\n");
>  		mutex_unlock(lock);
> 

