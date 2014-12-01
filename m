Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:35765 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752758AbaLAKsW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Dec 2014 05:48:22 -0500
Message-ID: <547C4765.1040807@xs4all.nl>
Date: Mon, 01 Dec 2014 11:48:05 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Nikhil Devshatwar <nikhil.nd@ti.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH v3 1/4] media: ti-vpe: Use data offset for getting dma_addr
 for a plane
References: <1417256860-20233-1-git-send-email-nikhil.nd@ti.com> <1417256860-20233-2-git-send-email-nikhil.nd@ti.com>
In-Reply-To: <1417256860-20233-2-git-send-email-nikhil.nd@ti.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/29/2014 11:27 AM, Nikhil Devshatwar wrote:
> The data_offset in v4l2_planes structure will help us point to the start of
> data content for that particular plane. This may be useful when a single
> buffer contains the data for different planes e.g. Y planes of two fields in
> the same buffer. With this, user space can pass queue top field and
> bottom field with same dmafd and different data_offsets.
> 
> Signed-off-by: Nikhil Devshatwar <nikhil.nd@ti.com>
> ---
> Changes from v2:
>  * Use data_offset only for OUTPUT stream buffers
> 
>  drivers/media/platform/ti-vpe/vpe.c |   10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
> index 9a081c2..ba26b83 100644
> --- a/drivers/media/platform/ti-vpe/vpe.c
> +++ b/drivers/media/platform/ti-vpe/vpe.c
> @@ -496,6 +496,14 @@ struct vpe_mmr_adb {
>  
>  #define VPE_SET_MMR_ADB_HDR(ctx, hdr, regs, offset_a)	\
>  	VPDMA_SET_MMR_ADB_HDR(ctx->mmr_adb, vpe_mmr_adb, hdr, regs, offset_a)
> +
> +static inline dma_addr_t vb2_dma_addr_plus_data_offset(struct vb2_buffer *vb,
> +	unsigned int plane_no)
> +{
> +	return vb2_dma_contig_plane_dma_addr(vb, plane_no) +
> +		vb->v4l2_planes[plane_no].data_offset;
> +}
> +
>  /*
>   * Set the headers for all of the address/data block structures.
>   */
> @@ -1043,7 +1051,7 @@ static void add_in_dtd(struct vpe_ctx *ctx, int port)
>  
>  		vpdma_fmt = fmt->vpdma_fmt[plane];
>  
> -		dma_addr = vb2_dma_contig_plane_dma_addr(vb, plane);
> +		dma_addr = vb2_dma_addr_plus_data_offset(vb, plane);
>  		if (!dma_addr) {
>  			vpe_err(ctx->dev,
>  				"acquiring input buffer(%d) dma_addr failed\n",
> 

Should there be a check somewhere that verifies that vb2_get_plane_payload() -
vb->v4l2_planes[plane_no].data_offset is still large enough for the image you
want to copy?

Regards,

	Hans
