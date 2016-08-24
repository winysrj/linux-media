Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54658 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752673AbcHXKWO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 24 Aug 2016 06:22:14 -0400
Date: Wed, 24 Aug 2016 13:21:43 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: mchehab@kernel.org, hans.verkuil@cisco.com,
        nenggun.kim@samsung.com, jh1009.sung@samsung.com,
        sw0312.kim@samsung.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] m2m-deinterlace: Fix error print during probe
Message-ID: <20160824102142.GJ12130@valkosipuli.retiisi.org.uk>
References: <20160823133939.2890-1-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160823133939.2890-1-peter.ujfalusi@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Peter!

On Tue, Aug 23, 2016 at 04:39:39PM +0300, Peter Ujfalusi wrote:
> v4l2_err() can not be used for printing error for missing interleaved
> support in DMA as this point the pcdev->v4l2_dev is not valid.
> 
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> ---
>  drivers/media/platform/m2m-deinterlace.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/m2m-deinterlace.c b/drivers/media/platform/m2m-deinterlace.c
> index 0fcb5c78031d..5a5dec348f4d 100644
> --- a/drivers/media/platform/m2m-deinterlace.c
> +++ b/drivers/media/platform/m2m-deinterlace.c
> @@ -1016,7 +1016,7 @@ static int deinterlace_probe(struct platform_device *pdev)
>  		return -ENODEV;
>  
>  	if (!dma_has_cap(DMA_INTERLEAVE, pcdev->dma_chan->device->cap_mask)) {
> -		v4l2_err(&pcdev->v4l2_dev, "DMA does not support INTERLEAVE\n");
> +		dev_err(&pdev->dev, "DMA does not support INTERLEAVE\n");
>  		goto rel_dma;
>  	}
>  

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
