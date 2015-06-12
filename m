Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:50894 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753195AbbFLJWP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Jun 2015 05:22:15 -0400
Message-ID: <557AA4BB.8010302@xs4all.nl>
Date: Fri, 12 Jun 2015 11:22:03 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: William Towle <william.towle@codethink.co.uk>,
	linux-media@vger.kernel.org, linux-kernel@lists.codethink.co.uk
CC: guennadi liakhovetski <g.liakhovetski@gmx.de>,
	sergei shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH 14/15] media: soc_camera: fill in bus_info field
References: <1433340002-1691-1-git-send-email-william.towle@codethink.co.uk> <1433340002-1691-15-git-send-email-william.towle@codethink.co.uk>
In-Reply-To: <1433340002-1691-15-git-send-email-william.towle@codethink.co.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/03/2015 04:00 PM, William Towle wrote:
> From: Rob Taylor <rob.taylor@codethink.co.uk>
> 
> Adapt soc_camera_querycap() so that cap->bus_info is populated in
> addition to cap->driver.
> 
> Signed-off-by: Rob Taylor <rob.taylor@codethink.co.uk>
> Reviewed-by: William Towle <william.towle@codethink.co.uk>
> ---
>  drivers/media/platform/soc_camera/soc_camera.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
> index 4e59833..675cfc4 100644
> --- a/drivers/media/platform/soc_camera/soc_camera.c
> +++ b/drivers/media/platform/soc_camera/soc_camera.c
> @@ -954,6 +954,7 @@ static int soc_camera_querycap(struct file *file, void  *priv,
>  	WARN_ON(priv != file->private_data);
>  
>  	strlcpy(cap->driver, ici->drv_name, sizeof(cap->driver));
> +	strlcpy(cap->bus_info, "platform:soc_camera", sizeof(cap->bus_info));

Sorry, but this is the wrong place. This should be done in rcar_vin_querycap.

If you have multiple soc_camera instances, then the bus_info should be unique
for each. And that's obviously not the case if it's done here.

The rcar driver will know, however.

Regards,

	Hans

>  	return ici->ops->querycap(ici, cap);
>  }
>  
> 

