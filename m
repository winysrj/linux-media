Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:48523 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750866AbdIORCn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Sep 2017 13:02:43 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH v1 2/3] drm: rcar-du: Add suspend resume helpers
Date: Fri, 15 Sep 2017 20:02:46 +0300
Message-ID: <1607973.DTifMlLdNl@avalon>
In-Reply-To: <199d29db89a7953f59e1eb4e91a3421336e3ed2a.1505493461.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.3bc8f413af3b3a9548574c3591aad0bf5b10e181.1505493461.git-series.kieran.bingham+renesas@ideasonboard.com> <199d29db89a7953f59e1eb4e91a3421336e3ed2a.1505493461.git-series.kieran.bingham+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

Thank you for the patch.

On Friday, 15 September 2017 19:42:06 EEST Kieran Bingham wrote:
> The pipeline needs to ensure that the hardware is idle for suspend and
> resume operations.

I'm not sure to really understand this sentence.

> Implement suspend and resume functions using the DRM atomic helper
> functions.
> 
> CC: dri-devel@lists.freedesktop.org
> 
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

The rest of the patch looks good to me. With the commit message clarified,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/gpu/drm/rcar-du/rcar_du_drv.c | 18 +++++++++++++++---
>  drivers/gpu/drm/rcar-du/rcar_du_drv.h |  1 +
>  2 files changed, 16 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/gpu/drm/rcar-du/rcar_du_drv.c
> b/drivers/gpu/drm/rcar-du/rcar_du_drv.c index 09fbceade6b1..01b91d0c169c
> 100644
> --- a/drivers/gpu/drm/rcar-du/rcar_du_drv.c
> +++ b/drivers/gpu/drm/rcar-du/rcar_du_drv.c
> @@ -22,6 +22,7 @@
>  #include <linux/wait.h>
> 
>  #include <drm/drmP.h>
> +#include <drm/drm_atomic_helper.h>
>  #include <drm/drm_crtc_helper.h>
>  #include <drm/drm_fb_cma_helper.h>
>  #include <drm/drm_gem_cma_helper.h>
> @@ -267,9 +268,19 @@ static struct drm_driver rcar_du_driver = {
>  static int rcar_du_pm_suspend(struct device *dev)
>  {
>  	struct rcar_du_device *rcdu = dev_get_drvdata(dev);
> +	struct drm_atomic_state *state;
> 
>  	drm_kms_helper_poll_disable(rcdu->ddev);
> -	/* TODO Suspend the CRTC */
> +	drm_fbdev_cma_set_suspend_unlocked(rcdu->fbdev, true);
> +
> +	state = drm_atomic_helper_suspend(rcdu->ddev);
> +	if (IS_ERR(state)) {
> +		drm_fbdev_cma_set_suspend_unlocked(rcdu->fbdev, false);
> +		drm_kms_helper_poll_enable(rcdu->ddev);
> +		return PTR_ERR(state);
> +	}
> +
> +	rcdu->suspend_state = state;
> 
>  	return 0;
>  }
> @@ -278,9 +289,10 @@ static int rcar_du_pm_resume(struct device *dev)
>  {
>  	struct rcar_du_device *rcdu = dev_get_drvdata(dev);
> 
> -	/* TODO Resume the CRTC */
> -
> +	drm_atomic_helper_resume(rcdu->ddev, rcdu->suspend_state);
> +	drm_fbdev_cma_set_suspend_unlocked(rcdu->fbdev, false);
>  	drm_kms_helper_poll_enable(rcdu->ddev);
> +
>  	return 0;
>  }
>  #endif
> diff --git a/drivers/gpu/drm/rcar-du/rcar_du_drv.h
> b/drivers/gpu/drm/rcar-du/rcar_du_drv.h index f8cd79488ece..f400fde65a0c
> 100644
> --- a/drivers/gpu/drm/rcar-du/rcar_du_drv.h
> +++ b/drivers/gpu/drm/rcar-du/rcar_du_drv.h
> @@ -81,6 +81,7 @@ struct rcar_du_device {
> 
>  	struct drm_device *ddev;
>  	struct drm_fbdev_cma *fbdev;
> +	struct drm_atomic_state *suspend_state;
> 
>  	struct rcar_du_crtc crtcs[RCAR_DU_MAX_CRTCS];
>  	unsigned int num_crtcs;


-- 
Regards,

Laurent Pinchart
