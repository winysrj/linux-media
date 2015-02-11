Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:16579 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260AbbBKKnb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Feb 2015 05:43:31 -0500
Message-id: <54DB324F.5060704@samsung.com>
Date: Wed, 11 Feb 2015 11:43:27 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
MIME-version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Pawel Osciak <pawel@osciak.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH v2 2/3] media/videobuf2-dma-contig: Save output from
 dma_map_sg
References: <1423650827-16232-1-git-send-email-ricardo.ribalda@gmail.com>
 <1423650827-16232-2-git-send-email-ricardo.ribalda@gmail.com>
In-reply-to: <1423650827-16232-2-git-send-email-ricardo.ribalda@gmail.com>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 2015-02-11 11:33, Ricardo Ribalda Delgado wrote:
> dma_map_sg returns the number of areas mapped by the hardware,
> which could be different than the areas given as an input.
> The output must be saved to nent.
>
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>

Reviewed-by: Marek Szyprowski <m.szyprowski@samsung.com>

> ---
>   drivers/media/v4l2-core/videobuf2-dma-contig.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> index b481d20..bfb5917 100644
> --- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
> +++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> @@ -299,7 +299,6 @@ static struct sg_table *vb2_dc_dmabuf_ops_map(
>   	/* stealing dmabuf mutex to serialize map/unmap operations */
>   	struct mutex *lock = &db_attach->dmabuf->lock;
>   	struct sg_table *sgt;
> -	int ret;
>   
>   	mutex_lock(lock);
>   
> @@ -318,8 +317,9 @@ static struct sg_table *vb2_dc_dmabuf_ops_map(
>   	}
>   
>   	/* mapping to the client with new direction */
> -	ret = dma_map_sg(db_attach->dev, sgt->sgl, sgt->orig_nents, dma_dir);
> -	if (ret <= 0) {
> +	sgt->nents = dma_map_sg(db_attach->dev, sgt->sgl, sgt->orig_nents,
> +				dma_dir);
> +	if (!sgt->nents) {
>   		pr_err("failed to map scatterlist\n");
>   		mutex_unlock(lock);
>   		return ERR_PTR(-EIO);

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

