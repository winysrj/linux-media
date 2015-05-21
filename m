Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:59504 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751629AbbEUF64 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 May 2015 01:58:56 -0400
Message-ID: <555D7419.8000303@xs4all.nl>
Date: Thu, 21 May 2015 07:58:49 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: William Towle <william.towle@codethink.co.uk>,
	linux-kernel@lists.codethink.co.uk, linux-media@vger.kernel.org
CC: g.liakhovetski@gmx.de, sergei.shtylyov@cogentembedded.com,
	rob.taylor@codethink.co.uk
Subject: Re: [PATCH 13/20] media: soc_camera: v4l2-compliance fixes for querycap
References: <1432139980-12619-1-git-send-email-william.towle@codethink.co.uk> <1432139980-12619-14-git-send-email-william.towle@codethink.co.uk>
In-Reply-To: <1432139980-12619-14-git-send-email-william.towle@codethink.co.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/20/2015 06:39 PM, William Towle wrote:
> Fill in bus_info field and zero reserved field.
> 
> Signed-off-by: Rob Taylor <rob.taylor@codethink.co.uk>
> Reviewed-by: William Towle <william.towle@codethink.co.uk>
> ---
>  drivers/media/platform/soc_camera/soc_camera.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
> index fd7497e..583c5e6 100644
> --- a/drivers/media/platform/soc_camera/soc_camera.c
> +++ b/drivers/media/platform/soc_camera/soc_camera.c
> @@ -954,6 +954,8 @@ static int soc_camera_querycap(struct file *file, void  *priv,
>  	WARN_ON(priv != file->private_data);
>  
>  	strlcpy(cap->driver, ici->drv_name, sizeof(cap->driver));
> +	strlcpy(cap->bus_info, "platform:soc_camera", sizeof(cap->bus_info));
> +	memset(cap->reserved, 0, sizeof(cap->reserved));

Why the memset? That shouldn't be needed.

Regards,

	Hans

>  	return ici->ops->querycap(ici, cap);
>  }
>  
> 

