Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:57515 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752699AbeC1Mbj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Mar 2018 08:31:39 -0400
Subject: Re: [PATCH 03/15] v4l: vsp1: Remove unused field from
 vsp1_drm_pipeline structure
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, linux-renesas-soc@vger.kernel.org
References: <20180226214516.11559-1-laurent.pinchart+renesas@ideasonboard.com>
 <20180226214516.11559-4-laurent.pinchart+renesas@ideasonboard.com>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <8b3ed86f-03fd-f089-d93c-7bdc842aacec@ideasonboard.com>
Date: Wed, 28 Mar 2018 13:31:35 +0100
MIME-Version: 1.0
In-Reply-To: <20180226214516.11559-4-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for the patch,

On 26/02/18 21:45, Laurent Pinchart wrote:
> The vsp1_drm_pipeline enabled field is set but never used. Remove it.
> 

Indeed - not used.

> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

> ---
>  drivers/media/platform/vsp1/vsp1_drm.c | 4 ----
>  drivers/media/platform/vsp1/vsp1_drm.h | 2 --
>  2 files changed, 6 deletions(-)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
> index a1f2ba044092..a267f12f0cc8 100644
> --- a/drivers/media/platform/vsp1/vsp1_drm.c
> +++ b/drivers/media/platform/vsp1/vsp1_drm.c
> @@ -273,10 +273,6 @@ EXPORT_SYMBOL_GPL(vsp1_du_setup_lif);
>   */
>  void vsp1_du_atomic_begin(struct device *dev, unsigned int pipe_index)
>  {
> -	struct vsp1_device *vsp1 = dev_get_drvdata(dev);
> -	struct vsp1_drm_pipeline *drm_pipe = &vsp1->drm->pipe[pipe_index];
> -
> -	drm_pipe->enabled = drm_pipe->pipe.num_inputs != 0;
>  }
>  EXPORT_SYMBOL_GPL(vsp1_du_atomic_begin);
>  
> diff --git a/drivers/media/platform/vsp1/vsp1_drm.h b/drivers/media/platform/vsp1/vsp1_drm.h
> index 1cd9db785bf7..9aa19325cbe9 100644
> --- a/drivers/media/platform/vsp1/vsp1_drm.h
> +++ b/drivers/media/platform/vsp1/vsp1_drm.h
> @@ -20,13 +20,11 @@
>  /**
>   * vsp1_drm_pipeline - State for the API exposed to the DRM driver
>   * @pipe: the VSP1 pipeline used for display
> - * @enabled: pipeline state at the beginning of an update
>   * @du_complete: frame completion callback for the DU driver (optional)
>   * @du_private: data to be passed to the du_complete callback
>   */
>  struct vsp1_drm_pipeline {
>  	struct vsp1_pipeline pipe;
> -	bool enabled;
>  
>  	/* Frame synchronisation */
>  	void (*du_complete)(void *, bool);
> 
