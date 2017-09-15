Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:48504 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751369AbdIOQ6z (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Sep 2017 12:58:55 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH v1 1/3] media: vsp1: Prevent resuming DRM pipelines
Date: Fri, 15 Sep 2017 19:58:58 +0300
Message-ID: <1514508.N9eClCS3vr@avalon>
In-Reply-To: <f15075b98a75895d65132ebf5ffb7a6b55d76ac8.1505493461.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.3bc8f413af3b3a9548574c3591aad0bf5b10e181.1505493461.git-series.kieran.bingham+renesas@ideasonboard.com> <f15075b98a75895d65132ebf5ffb7a6b55d76ac8.1505493461.git-series.kieran.bingham+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

Thank you for the patch.

On Friday, 15 September 2017 19:42:05 EEST Kieran Bingham wrote:
> DRM pipelines utilising the VSP must stop all frame processing as part
> of the suspend operation to ensure the hardware is idle. Upon resume,
> the pipeline must not be started until the DU performs an atomic flush
> to restore the hardware configuration and state.
> 
> Therefore the vsp1_pipeline_resume() call is not needed for DRM
> pipelines, and we can disable it in this instance.

Being familiar with the issue I certainly understand the commit message, but I 
think it can be a bit confusing to a reader not familiar to the VSP/DU. How 
about something similar to the following ?

"When used as part of a display pipeline, the VSP is stopped and restarted 
explicitly by the DU from its suspend and resume handlers. There is thus no 
need to stop or restart pipelines in the VSP suspend and resume handlers."

> CC: linux-media@vger.kernel.org
> 
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> ---
>  drivers/media/platform/vsp1/vsp1_drv.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_drv.c
> b/drivers/media/platform/vsp1/vsp1_drv.c index 962e4c304076..7604c7994c74
> 100644
> --- a/drivers/media/platform/vsp1/vsp1_drv.c
> +++ b/drivers/media/platform/vsp1/vsp1_drv.c
> @@ -582,7 +582,13 @@ static int __maybe_unused vsp1_pm_resume(struct device
> *dev) struct vsp1_device *vsp1 = dev_get_drvdata(dev);
> 
>  	pm_runtime_force_resume(vsp1->dev);
> -	vsp1_pipelines_resume(vsp1);
> +
> +	/*
> +	 * DRM pipelines are stopped before suspend, and will be resumed after
> +	 * the DRM subsystem has reconfigured its pipeline with an atomic flush
> +	 */

I would also adapt this comment similarly to the commit message.

> +	if (!vsp1->drm)
> +		vsp1_pipelines_resume(vsp1);

Should we do the same in vsp1_pm_suspend() ? I know it shouldn't be strictly 
needed at the moment as vsp1_pipelines_suspend() should be a no-op when the 
pipelines are already stopped, but a symmetrical implementation sounds better 
to me.

I also wonder whether the check shouldn't be moved inside the 
vsp1_pipelines_suspend() and vsp1_pipelines_resume() functions as we will 
likely need to handle suspend/resume of display pipelines when adding 
writeback support, but we could do so later.

>  	return 0;
>  }

-- 
Regards,

Laurent Pinchart
