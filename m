Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:50567 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751518AbbEUGDS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 May 2015 02:03:18 -0400
Message-ID: <555D751D.60907@xs4all.nl>
Date: Thu, 21 May 2015 08:03:09 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: William Towle <william.towle@codethink.co.uk>,
	linux-kernel@lists.codethink.co.uk, linux-media@vger.kernel.org
CC: g.liakhovetski@gmx.de, sergei.shtylyov@cogentembedded.com,
	rob.taylor@codethink.co.uk
Subject: Re: [PATCH 15/20] media: rcar_vin: Don't advertise support for USERPTR
References: <1432139980-12619-1-git-send-email-william.towle@codethink.co.uk> <1432139980-12619-16-git-send-email-william.towle@codethink.co.uk>
In-Reply-To: <1432139980-12619-16-git-send-email-william.towle@codethink.co.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/20/2015 06:39 PM, William Towle wrote:
> rcar_vin requires physically contiguous buffer, so shouldn't advertise
> support for USERPTR.
> 
> Signed-off-by: Rob Taylor <rob.taylor@codethink.co.uk>
> Reviewed-by: William Towle <william.towle@codethink.co.uk>
> ---
>  drivers/media/platform/soc_camera/rcar_vin.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
> index 222002a..b530503 100644
> --- a/drivers/media/platform/soc_camera/rcar_vin.c
> +++ b/drivers/media/platform/soc_camera/rcar_vin.c
> @@ -1824,7 +1824,7 @@ static int rcar_vin_init_videobuf2(struct vb2_queue *vq,
>  	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
>  
>  	vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> -	vq->io_modes = VB2_MMAP | VB2_USERPTR;
> +	vq->io_modes = VB2_MMAP;

NACK.

USERPTR can be used, but the user pointer must point to physically contig
memory (and this is checked). There are cases where the system will carve out
phys. contig. memory and userspace has pointers to that. I'm pretty sure some of
this is used by systems where soc-camera is run.

Unfortunately, userspace has currently no way of knowing such userptr restrictions.
That's a failing of the API. It's ugly as hell, but it is in use today and can't
be dropped.

Regards,

	Hans

>  	vq->drv_priv = icd;
>  	vq->ops = &rcar_vin_vb2_ops;
>  	vq->mem_ops = &vb2_dma_contig_memops;
> 

