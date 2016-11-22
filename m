Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:49165 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751433AbcKVViI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Nov 2016 16:38:08 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Leo Sperling <leosperling97@gmail.com>
Cc: mchehab@kernel.org, gregkh@linuxfoundation.org,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: media: davinci_vpfe: fix indentation issue in vpfe_video.c
Date: Tue, 22 Nov 2016 23:38:25 +0200
Message-ID: <20015099.LXK91D2HKf@avalon>
In-Reply-To: <1477224143-22653-1-git-send-email-leosperling97@gmail.com>
References: <1477224143-22653-1-git-send-email-leosperling97@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Leo,

Thank you for the patch, and sorry for the late reply.

On Sunday 23 Oct 2016 14:02:23 Leo Sperling wrote:
> This is a patch to the vpfe_video.c file that fixes an indentation
> warning reported by checkpatch.pl
> 
> Signed-off-by: Leo Sperling <leosperling97@gmail.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

and applied to my tree. I will send a pull request for v4.11.

> ---
>  drivers/staging/media/davinci_vpfe/vpfe_video.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.c
> b/drivers/staging/media/davinci_vpfe/vpfe_video.c index 8be9f85..c34bf46
> 100644
> --- a/drivers/staging/media/davinci_vpfe/vpfe_video.c
> +++ b/drivers/staging/media/davinci_vpfe/vpfe_video.c
> @@ -1143,8 +1143,8 @@ static int vpfe_buffer_prepare(struct vb2_buffer *vb)
>  	/* Initialize buffer */
>  	vb2_set_plane_payload(vb, 0, video->fmt.fmt.pix.sizeimage);
>  	if (vb2_plane_vaddr(vb, 0) &&
> -		vb2_get_plane_payload(vb, 0) > vb2_plane_size(vb, 0))
> -			return -EINVAL;
> +	    vb2_get_plane_payload(vb, 0) > vb2_plane_size(vb, 0))
> +		return -EINVAL;
> 
>  	addr = vb2_dma_contig_plane_dma_addr(vb, 0);
>  	/* Make sure user addresses are aligned to 32 bytes */

-- 
Regards,

Laurent Pinchart

