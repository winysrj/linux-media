Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:47113 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751606AbeDDQRX (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 4 Apr 2018 12:17:23 -0400
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH 14/15] v4l: vsp1: Add BRx dynamic assignment debugging
 messages
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, linux-renesas-soc@vger.kernel.org
References: <20180226214516.11559-1-laurent.pinchart+renesas@ideasonboard.com>
 <20180226214516.11559-15-laurent.pinchart+renesas@ideasonboard.com>
Message-ID: <8a014be6-d0ce-80bb-8834-741f9206ab31@ideasonboard.com>
Date: Wed, 4 Apr 2018 17:17:19 +0100
MIME-Version: 1.0
In-Reply-To: <20180226214516.11559-15-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 26/02/18 21:45, Laurent Pinchart wrote:
> Dynamic assignment of the BRU and BRS to pipelines is prone to
> regressions, add messages to make debugging easier. Keep it as a
> separate commit to ease removal of those messages once the code will
> deem to be completely stable.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Not really a review required here so much, so I'll just :

Acked-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

> ---
>  drivers/media/platform/vsp1/vsp1_drm.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
> index 87e31ba0ddf5..521bbc227110 100644
> --- a/drivers/media/platform/vsp1/vsp1_drm.c
> +++ b/drivers/media/platform/vsp1/vsp1_drm.c
> @@ -190,6 +190,10 @@ static int vsp1_du_pipeline_setup_bru(struct vsp1_device *vsp1,
>  
>  		/* Release our BRU if we have one. */
>  		if (pipe->bru) {
> +			dev_dbg(vsp1->dev, "%s: pipe %u: releasing %s\n",
> +				__func__, pipe->lif->index,
> +				BRU_NAME(pipe->bru));
> +
>  			/*
>  			 * The BRU might be acquired by the other pipeline in
>  			 * the next step. We must thus remove it from the list
> @@ -219,6 +223,9 @@ static int vsp1_du_pipeline_setup_bru(struct vsp1_device *vsp1,
>  		if (bru->pipe) {
>  			struct vsp1_drm_pipeline *owner_pipe;
>  
> +			dev_dbg(vsp1->dev, "%s: pipe %u: waiting for %s\n",
> +				__func__, pipe->lif->index, BRU_NAME(bru));
> +
>  			owner_pipe = to_vsp1_drm_pipeline(bru->pipe);
>  			owner_pipe->force_bru_release = true;
>  
> @@ -245,6 +252,9 @@ static int vsp1_du_pipeline_setup_bru(struct vsp1_device *vsp1,
>  				      &pipe->entities);
>  
>  		/* Add the BRU to the pipeline. */
> +		dev_dbg(vsp1->dev, "%s: pipe %u: acquired %s\n",
> +			__func__, pipe->lif->index, BRU_NAME(bru));
> +
>  		pipe->bru = bru;
>  		pipe->bru->pipe = pipe;
>  		pipe->bru->sink = &pipe->output->entity;
> @@ -549,6 +559,10 @@ int vsp1_du_setup_lif(struct device *dev, unsigned int pipe_index,
>  		drm_pipe->du_complete = NULL;
>  		pipe->num_inputs = 0;
>  
> +		dev_dbg(vsp1->dev, "%s: pipe %u: releasing %s\n",
> +			__func__, pipe->lif->index,
> +			BRU_NAME(pipe->bru));
> +
>  		list_del(&pipe->bru->list_pipe);
>  		pipe->bru->pipe = NULL;
>  		pipe->bru = NULL;
> 
