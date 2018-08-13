Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:60180 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728055AbeHMN7B (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Aug 2018 09:59:01 -0400
Date: Mon, 13 Aug 2018 08:17:10 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv17 18/34] davinci_vpfe: remove bogus vb2->state check
Message-ID: <20180813081710.483195ef@coco.lan>
In-Reply-To: <20180804124526.46206-19-hverkuil@xs4all.nl>
References: <20180804124526.46206-1-hverkuil@xs4all.nl>
        <20180804124526.46206-19-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat,  4 Aug 2018 14:45:10 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> There is no need to check the vb2 state in the buf_prepare
> callback: it can never be wrong.
> 
> Since VB2_BUF_STATE_PREPARED will be removed in the next patch
> we'll remove this unnecessary check (and use of that state) first.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Reviewed-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

> ---
>  drivers/staging/media/davinci_vpfe/vpfe_video.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.c b/drivers/staging/media/davinci_vpfe/vpfe_video.c
> index 1269a983455e..4e3ec7fdc90d 100644
> --- a/drivers/staging/media/davinci_vpfe/vpfe_video.c
> +++ b/drivers/staging/media/davinci_vpfe/vpfe_video.c
> @@ -1135,10 +1135,6 @@ static int vpfe_buffer_prepare(struct vb2_buffer *vb)
>  
>  	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_buffer_prepare\n");
>  
> -	if (vb->state != VB2_BUF_STATE_ACTIVE &&
> -	    vb->state != VB2_BUF_STATE_PREPARED)
> -		return 0;
> -
>  	/* Initialize buffer */
>  	vb2_set_plane_payload(vb, 0, video->fmt.fmt.pix.sizeimage);
>  	if (vb2_plane_vaddr(vb, 0) &&



Thanks,
Mauro
