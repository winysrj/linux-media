Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:50894 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752211AbbFLJXA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Jun 2015 05:23:00 -0400
Message-ID: <557AA4E8.40208@xs4all.nl>
Date: Fri, 12 Jun 2015 11:22:48 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: William Towle <william.towle@codethink.co.uk>,
	linux-media@vger.kernel.org, linux-kernel@lists.codethink.co.uk
CC: guennadi liakhovetski <g.liakhovetski@gmx.de>,
	sergei shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH 15/15] media: rcar_vin: Reject videobufs that are too
 small for current format
References: <1433340002-1691-1-git-send-email-william.towle@codethink.co.uk> <1433340002-1691-16-git-send-email-william.towle@codethink.co.uk>
In-Reply-To: <1433340002-1691-16-git-send-email-william.towle@codethink.co.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/03/2015 04:00 PM, William Towle wrote:
> From: Rob Taylor <rob.taylor@codethink.co.uk>
> 
> In videobuf_setup reject buffers that are too small for the configured
> format. Fixes v4l2-complience issue.
> 
> Signed-off-by: Rob Taylor <rob.taylor@codethink.co.uk>
> Reviewed-by: William Towle <william.towle@codethink.co.uk>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks,

	Hans

> ---
>  drivers/media/platform/soc_camera/rcar_vin.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
> index cc993bc..1531a76 100644
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
> 

