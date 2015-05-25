Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:64705 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752434AbbEYPEH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 May 2015 11:04:07 -0400
Date: Mon, 25 May 2015 17:03:52 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: William Towle <william.towle@codethink.co.uk>
cc: linux-kernel@lists.codethink.co.uk, linux-media@vger.kernel.org,
	sergei.shtylyov@cogentembedded.com, hverkuil@xs4all.nl,
	rob.taylor@codethink.co.uk
Subject: Re: [PATCH 14/20] media: rcar_vin: Reject videobufs that are too
 small for current format
In-Reply-To: <1432139980-12619-15-git-send-email-william.towle@codethink.co.uk>
Message-ID: <Pine.LNX.4.64.1505251703021.26358@axis700.grange>
References: <1432139980-12619-1-git-send-email-william.towle@codethink.co.uk>
 <1432139980-12619-15-git-send-email-william.towle@codethink.co.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 20 May 2015, William Towle wrote:

> In videobuf_setup reject buffers that are too small for the configured
> format. Fixes v4l2-complience issue.
> 
> Signed-off-by: Rob Taylor <rob.taylor@codethink.co.uk>
> Reviewed-by: William Towle <william.towle@codethink.co.uk>

Ditto: why Rob's Sob if you're the author?

Thanks
Guennadi

> ---
>  drivers/media/platform/soc_camera/rcar_vin.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
> index 571ab20..222002a 100644
> --- a/drivers/media/platform/soc_camera/rcar_vin.c
> +++ b/drivers/media/platform/soc_camera/rcar_vin.c
> @@ -541,6 +541,9 @@ static int rcar_vin_videobuf_setup(struct vb2_queue *vq,
>  		unsigned int bytes_per_line;
>  		int ret;
>  
> +		if (fmt->fmt.pix.sizeimage < icd->sizeimage)
> +			return -EINVAL;
> +
>  		xlate = soc_camera_xlate_by_fourcc(icd,
>  						   fmt->fmt.pix.pixelformat);
>  		if (!xlate)
> -- 
> 1.7.10.4
> 
