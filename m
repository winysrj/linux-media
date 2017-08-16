Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:46172 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752352AbdHPVxK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Aug 2017 17:53:10 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v2 1/8] v4l: vsp1: Protect fragments against overflow
Date: Thu, 17 Aug 2017 00:53:34 +0300
Message-ID: <1552146.CLukKW7q3G@avalon>
In-Reply-To: <a434f2ae9b782b0d8cb7a00b1e636c17c6dd48ad.1502723341.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.4457988ad8b64b5c7636e35039ef61d507af3648.1502723341.git-series.kieran.bingham+renesas@ideasonboard.com> <a434f2ae9b782b0d8cb7a00b1e636c17c6dd48ad.1502723341.git-series.kieran.bingham+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

Thank you for the patch.

On Monday 14 Aug 2017 16:13:24 Kieran Bingham wrote:
> The fragment write function relies on the code never asking it to
> write more than the entries available in the list.
> 
> Currently with each list body containing 256 entries, this is fine,
> but we can reduce this number greatly saving memory.
> 
> In preparation of this - add a level of protection to catch any
> buffer overflows.
> 
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> ---
>  drivers/media/platform/vsp1/vsp1_dl.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_dl.c
> b/drivers/media/platform/vsp1/vsp1_dl.c index 8b5cbb6b7a70..cb4625ae13c2
> 100644
> --- a/drivers/media/platform/vsp1/vsp1_dl.c
> +++ b/drivers/media/platform/vsp1/vsp1_dl.c
> @@ -50,6 +50,7 @@ struct vsp1_dl_entry {
>   * @dma: DMA address of the entries
>   * @size: size of the DMA memory in bytes
>   * @num_entries: number of stored entries
> + * @max_entries: number of entries available
>   */
>  struct vsp1_dl_body {
>  	struct list_head list;
> @@ -60,6 +61,7 @@ struct vsp1_dl_body {
>  	size_t size;
> 
>  	unsigned int num_entries;
> +	unsigned int max_entries;
>  };
> 
>  /**
> @@ -138,6 +140,7 @@ static int vsp1_dl_body_init(struct vsp1_device *vsp1,
> 
>  	dlb->vsp1 = vsp1;
>  	dlb->size = size;
> +	dlb->max_entries = num_entries;
> 
>  	dlb->entries = dma_alloc_wc(vsp1->bus_master, dlb->size, &dlb->dma,
>  				    GFP_KERNEL);
> @@ -220,6 +223,11 @@ void vsp1_dl_fragment_free(struct vsp1_dl_body *dlb)
>   */
>  void vsp1_dl_fragment_write(struct vsp1_dl_body *dlb, u32 reg, u32 data)
>  {
> +	if (unlikely(dlb->num_entries >= dlb->max_entries)) {
> +		WARN_ONCE(true, "DLB size exceeded (max %u)", dlb-
>max_entries);
> +		return;
> +	}

How about

	if (WARN_ONCE(dlb->num_entries >= dlb->max_entries,
		      "DLB size exceeded (max %u)", dlb->max_entries))
		return;

(WARN_ONCE contains the unlikely() already)

I'm not fussed either way,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

>  	dlb->entries[dlb->num_entries].addr = reg;
>  	dlb->entries[dlb->num_entries].data = data;
>  	dlb->num_entries++;

-- 
Regards,

Laurent Pinchart
