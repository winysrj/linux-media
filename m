Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:65380 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbbBKIHY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Feb 2015 03:07:24 -0500
Message-id: <54DB0DB8.1010701@samsung.com>
Date: Wed, 11 Feb 2015 09:07:20 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
MIME-version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Pawel Osciak <pawel@osciak.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] media/videobuf2-dma-contig: Fix handling of sg_table
 structure
References: <1423498466-16718-1-git-send-email-ricardo.ribalda@gmail.com>
 <1423498466-16718-2-git-send-email-ricardo.ribalda@gmail.com>
In-reply-to: <1423498466-16718-2-git-send-email-ricardo.ribalda@gmail.com>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 2015-02-09 17:14, Ricardo Ribalda Delgado wrote:
> when sg_alloc_table_from_pages() does not fail it returns a sg_table
> structure with nents and nents_orig initialized to the same value.
>
> dma_map_sg returns the dma_map_sg returns the number of areas mapped
> by the hardware, which could be different than the areas given as an input.
> The output must be saved to nent.
> Unfortunately nent differs in sign to the output of dma_map_sg, so an
> intermediate value must be used.
>
> The output of dma_map, should be used to transverse the scatter list.
>
> dma_unmap_sg needs the value passed to dma_map_sg (nents_orig).
>
> sg_free_tables uses also orig_nent.
>
> This patch fix the file to follow this paradigm.
>
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> ---
>   drivers/media/v4l2-core/videobuf2-dma-contig.c | 10 ++++++----
>   1 file changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> index b481d20..c7e4bdd 100644
> --- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
> +++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> @@ -56,7 +56,7 @@ static void vb2_dc_sgt_foreach_page(struct sg_table *sgt,
>   	struct scatterlist *s;
>   	unsigned int i;
>   
> -	for_each_sg(sgt->sgl, s, sgt->orig_nents, i) {
> +	for_each_sg(sgt->sgl, s, sgt->nents, i) {
>   		struct page *page = sg_page(s);
>   		unsigned int n_pages = PAGE_ALIGN(s->offset + s->length)
>   			>> PAGE_SHIFT;

This code iterates over memory pages added to the scatter list not the 
dma chunks,
so orig_nents must be used. This change is not needed.

> @@ -260,7 +260,7 @@ static int vb2_dc_dmabuf_ops_attach(struct dma_buf *dbuf, struct device *dev,
>   
>   	rd = buf->sgt_base->sgl;
>   	wr = sgt->sgl;
> -	for (i = 0; i < sgt->orig_nents; ++i) {
> +	for (i = 0; i < sgt->nents; ++i) {
>   		sg_set_page(wr, sg_page(rd), rd->length, rd->offset);
>   		rd = sg_next(rd);
>   		wr = sg_next(wr);

Same comment as for videobuf2-dma-sg.c patch.

> @@ -324,6 +324,7 @@ static struct sg_table *vb2_dc_dmabuf_ops_map(
>   		mutex_unlock(lock);
>   		return ERR_PTR(-EIO);
>   	}
> +	sgt->nents = ret;
>   
>   	attach->dma_dir = dma_dir;
>   
> @@ -669,13 +670,14 @@ static void *vb2_dc_get_userptr(void *alloc_ctx, unsigned long vaddr,
>   	 * No need to sync to the device, this will happen later when the
>   	 * prepare() memop is called.
>   	 */
> -	sgt->nents = dma_map_sg_attrs(buf->dev, sgt->sgl, sgt->orig_nents,
> +	ret = dma_map_sg_attrs(buf->dev, sgt->sgl, sgt->orig_nents,
>   				      buf->dma_dir, &attrs);
> -	if (sgt->nents <= 0) {
> +	if (ret <= 0) {
>   		pr_err("failed to map scatterlist\n");
>   		ret = -EIO;
>   		goto fail_sgt_init;
>   	}
> +	sgt->nents = ret;

This one is okay, although the check for error could be simplified to a 
check
for zero value.

>   
>   	contig_size = vb2_dc_get_contiguous_size(sgt);
>   	if (contig_size < size) {

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

