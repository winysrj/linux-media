Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:56256 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750889AbaKWMxZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Nov 2014 07:53:25 -0500
Message-ID: <5471D8BF.6000903@xs4all.nl>
Date: Sun, 23 Nov 2014 13:53:19 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Nikhil Devshatwar <nikhil.nd@ti.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH v2 1/4] media: ti-vpe: Use data offset for getting dma_addr
 for a plane
References: <1415964052-30351-1-git-send-email-nikhil.nd@ti.com> <1415964052-30351-2-git-send-email-nikhil.nd@ti.com>
In-Reply-To: <1415964052-30351-2-git-send-email-nikhil.nd@ti.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/14/2014 12:20 PM, Nikhil Devshatwar wrote:
> The data_offset in v4l2_planes structure will help us point to the start of
> data content for that particular plane. This may be useful when a single
> buffer contains the data for different planes e.g. Y planes of two fields in
> the same buffer. With this, user space can pass queue top field and
> bottom field with same dmafd and different data_offsets.
> 
> Signed-off-by: Nikhil Devshatwar <nikhil.nd@ti.com>
> ---
>  drivers/media/platform/ti-vpe/vpe.c |   12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
> index 0ae19ee..e59eb81 100644
> --- a/drivers/media/platform/ti-vpe/vpe.c
> +++ b/drivers/media/platform/ti-vpe/vpe.c
> @@ -495,6 +495,14 @@ struct vpe_mmr_adb {
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
> @@ -1002,7 +1010,7 @@ static void add_out_dtd(struct vpe_ctx *ctx, int port)
>  		int plane = fmt->coplanar ? p_data->vb_part : 0;
>  
>  		vpdma_fmt = fmt->vpdma_fmt[plane];
> -		dma_addr = vb2_dma_contig_plane_dma_addr(vb, plane);
> +		dma_addr = vb2_dma_addr_plus_data_offset(vb, plane);
>  		if (!dma_addr) {
>  			vpe_err(ctx->dev,
>  				"acquiring output buffer(%d) dma_addr failed\n",
> @@ -1042,7 +1050,7 @@ static void add_in_dtd(struct vpe_ctx *ctx, int port)
>  
>  		vpdma_fmt = fmt->vpdma_fmt[plane];
>  
> -		dma_addr = vb2_dma_contig_plane_dma_addr(vb, plane);
> +		dma_addr = vb2_dma_addr_plus_data_offset(vb, plane);
>  		if (!dma_addr) {
>  			vpe_err(ctx->dev,
>  				"acquiring input buffer(%d) dma_addr failed\n",
> 

I suspect this does not do what you want. data_offset is set by the application
for an output stream (i.e. from memory to the hardware) and it is set by the
driver for a capture stream (i.e. from hardware to memory). It looks like you
expect that it is set by the application for capture streams as well, but
that's not true.

Regards,

	Hans
