Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:33759 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753672AbbGXOPy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jul 2015 10:15:54 -0400
Message-ID: <55B24852.2010200@xs4all.nl>
Date: Fri, 24 Jul 2015 16:14:42 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: William Towle <william.towle@codethink.co.uk>,
	linux-media@vger.kernel.org, linux-kernel@lists.codethink.co.uk
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH 12/13] media: rcar_vin: fill in bus_info field
References: <1437654103-26409-1-git-send-email-william.towle@codethink.co.uk> <1437654103-26409-13-git-send-email-william.towle@codethink.co.uk>
In-Reply-To: <1437654103-26409-13-git-send-email-william.towle@codethink.co.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/23/2015 02:21 PM, William Towle wrote:
> From: Rob Taylor <rob.taylor@codethink.co.uk>
> 
> Adapt rcar_vin_querycap() so that cap->bus_info is populated with
> something meaningful/unique.
> 
> Signed-off-by: Rob Taylor <rob.taylor@codethink.co.uk>
> Signed-off-by: William Towle <william.towle@codethink.co.uk>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  drivers/media/platform/soc_camera/rcar_vin.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
> index dab729a..93e20d6 100644
> --- a/drivers/media/platform/soc_camera/rcar_vin.c
> +++ b/drivers/media/platform/soc_camera/rcar_vin.c
> @@ -1799,6 +1799,7 @@ static int rcar_vin_querycap(struct soc_camera_host *ici,
>  	strlcpy(cap->card, "R_Car_VIN", sizeof(cap->card));
>  	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
>  	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
> +	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s%d", DRV_NAME, ici->nr);
>  
>  	return 0;
>  }
> 

