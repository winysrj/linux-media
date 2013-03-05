Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:64390 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755597Ab3CEKIC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Mar 2013 05:08:02 -0500
Date: Tue, 5 Mar 2013 11:07:48 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Albert Wang <twang13@marvell.com>
cc: corbet@lwn.net, linux-media@vger.kernel.org,
	Libin Yang <lbyang@marvell.com>
Subject: Re: [REVIEW PATCH V4 05/12] [media] marvell-ccic: add new formats
 support for marvell-ccic driver
In-Reply-To: <1360238687-15768-6-git-send-email-twang13@marvell.com>
Message-ID: <Pine.LNX.4.64.1303051058000.25837@axis700.grange>
References: <1360238687-15768-1-git-send-email-twang13@marvell.com>
 <1360238687-15768-6-git-send-email-twang13@marvell.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Looks pretty good to me now, just one nitpick:

On Thu, 7 Feb 2013, Albert Wang wrote:

> From: Libin Yang <lbyang@marvell.com>
> 
> This patch adds the new formats support for marvell-ccic.
> 
> Signed-off-by: Albert Wang <twang13@marvell.com>
> Signed-off-by: Libin Yang <lbyang@marvell.com>
> ---
>  drivers/media/platform/marvell-ccic/mcam-core.c |  189 +++++++++++++++++++----
>  drivers/media/platform/marvell-ccic/mcam-core.h |    6 +
>  2 files changed, 162 insertions(+), 33 deletions(-)
> 
> diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
> index f89fce7..0f9604e 100755
> --- a/drivers/media/platform/marvell-ccic/mcam-core.c
> +++ b/drivers/media/platform/marvell-ccic/mcam-core.c

[snip]

> @@ -971,11 +1062,35 @@ static void mcam_vb_buf_queue(struct vb2_buffer *vb)
>  {
>  	struct mcam_vb_buffer *mvb = vb_to_mvb(vb);
>  	struct mcam_camera *cam = vb2_get_drv_priv(vb->vb2_queue);
> +	struct v4l2_pix_format *fmt = &cam->pix_format;
>  	unsigned long flags;
>  	int start;
> +	dma_addr_t dma_handle;
> +	u32 pixel_count = fmt->width * fmt->height;
>  
>  	spin_lock_irqsave(&cam->dev_lock, flags);
> +	dma_handle = vb2_dma_contig_plane_dma_addr(vb, 0);
> +	BUG_ON(!dma_handle);

Again - a bit too strong. But the truth is - .buf_queue() cannot fail... 
Would it be possible to move this pointer calculation to .buf_prepare(), 
which does return an error code?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
