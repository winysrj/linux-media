Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:47537 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751599AbdKKQO4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 11 Nov 2017 11:14:56 -0500
Reply-To: kieran.bingham@ideasonboard.com
Subject: Re: [PATCH v2] media: vsp1: Prevent suspending and resuming DRM
 pipelines
To: laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
References: <cover.3bc8f413af3b3a9548574c3591aad0bf5b10e181.1505493461.git-series.kieran.bingham+renesas@ideasonboard.com>
 <c1f99c379343a52a4923b3bf74a9e366f4e89dcb.1505898862.git-series.kieran.bingham+renesas@ideasonboard.com>
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Message-ID: <a35d3339-b1d3-cef0-4e20-8144095b1e2e@ideasonboard.com>
Date: Sat, 11 Nov 2017 16:14:51 +0000
MIME-Version: 1.0
In-Reply-To: <c1f99c379343a52a4923b3bf74a9e366f4e89dcb.1505898862.git-series.kieran.bingham+renesas@ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ping ...

This patch appears to have got lost in the post.

Could someone pick it up please?

--
Regards

Kieran

On 20/09/17 10:16, Kieran Bingham wrote:
> When used as part of a display pipeline, the VSP is stopped and
> restarted explicitly by the DU from its suspend and resume handlers.
> There is thus no need to stop or restart pipelines in the VSP suspend
> and resume handlers, and doing so would cause the hardware to be
> left in a misconfigured state.
> 
> Ensure that the VSP suspend and resume handlers do not affect DRM
> based pipelines.
> 
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> ---
>  drivers/media/platform/vsp1/vsp1_drv.c | 16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
> index 962e4c304076..ed25ba9d551b 100644
> --- a/drivers/media/platform/vsp1/vsp1_drv.c
> +++ b/drivers/media/platform/vsp1/vsp1_drv.c
> @@ -571,7 +571,13 @@ static int __maybe_unused vsp1_pm_suspend(struct device *dev)
>  {
>  	struct vsp1_device *vsp1 = dev_get_drvdata(dev);
>  
> -	vsp1_pipelines_suspend(vsp1);
> +	/*
> +	 * When used as part of a display pipeline, the VSP is stopped and
> +	 * restarted explicitly by the DU
> +	 */
> +	if (!vsp1->drm)
> +		vsp1_pipelines_suspend(vsp1);
> +
>  	pm_runtime_force_suspend(vsp1->dev);
>  
>  	return 0;
> @@ -582,7 +588,13 @@ static int __maybe_unused vsp1_pm_resume(struct device *dev)
>  	struct vsp1_device *vsp1 = dev_get_drvdata(dev);
>  
>  	pm_runtime_force_resume(vsp1->dev);
> -	vsp1_pipelines_resume(vsp1);
> +
> +	/*
> +	 * When used as part of a display pipeline, the VSP is stopped and
> +	 * restarted explicitly by the DU
> +	 */
> +	if (!vsp1->drm)
> +		vsp1_pipelines_resume(vsp1);
>  
>  	return 0;
>  }
> 
