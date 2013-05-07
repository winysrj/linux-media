Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:62765 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756960Ab3EGGwW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 May 2013 02:52:22 -0400
Date: Tue, 7 May 2013 08:52:19 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sachin Kamat <sachin.kamat@linaro.org>
cc: linux-media@vger.kernel.org, patches@linaro.org
Subject: Re: [PATCH 1/2] [media] soc_camera: Constify dev_pm_ops in mt9t031.c
In-Reply-To: <1367314149-16448-1-git-send-email-sachin.kamat@linaro.org>
Message-ID: <Pine.LNX.4.64.1305070852050.31972@axis700.grange>
References: <1367314149-16448-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 30 Apr 2013, Sachin Kamat wrote:

> Silences the following warning:
> WARNING: struct dev_pm_ops should normally be const
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>

Thanks, both queued for 3.11

Guennadi

> ---
>  drivers/media/i2c/soc_camera/mt9t031.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/i2c/soc_camera/mt9t031.c b/drivers/media/i2c/soc_camera/mt9t031.c
> index 26a15b8..191e3f1 100644
> --- a/drivers/media/i2c/soc_camera/mt9t031.c
> +++ b/drivers/media/i2c/soc_camera/mt9t031.c
> @@ -595,7 +595,7 @@ static int mt9t031_runtime_resume(struct device *dev)
>  	return 0;
>  }
>  
> -static struct dev_pm_ops mt9t031_dev_pm_ops = {
> +static const struct dev_pm_ops mt9t031_dev_pm_ops = {
>  	.runtime_suspend	= mt9t031_runtime_suspend,
>  	.runtime_resume		= mt9t031_runtime_resume,
>  };
> -- 
> 1.7.9.5
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
