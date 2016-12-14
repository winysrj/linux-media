Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44849 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752445AbcLNT44 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Dec 2016 14:56:56 -0500
Subject: Re: [PATCHv3 RFC 4/4] media: Catch null pipes on pipeline stop
To: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        laurent.pinchart@ideasonboard.com
References: <1481651984-7687-1-git-send-email-kieran.bingham+renesas@ideasonboard.com>
 <1481651984-7687-5-git-send-email-kieran.bingham+renesas@ideasonboard.com>
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@iki.fi>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <21a24c35-e585-653d-ec78-2b737dee2227@ideasonboard.com>
Date: Wed, 14 Dec 2016 19:56:51 +0000
MIME-Version: 1.0
In-Reply-To: <1481651984-7687-5-git-send-email-kieran.bingham+renesas@ideasonboard.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Me.

Ok, so a bit of investigation into *why* we have an unbalanced
media_pipeline stop call.

After a suspend/resume cycle, the function vsp1_pm_runtime_resume() is
called by the PM framework.

The hardware is unable to reset successfully and the reset call returns
-ETIMEDOUT which gets passed back to the PM framework as a failure and
thus the device is not 'resumed'

This process is commenced, as the DU driver tries to enable the VSP, we
get the following call stack:

rcar_du_crtc_resume()
  rcar_du_vsp_enable()
    vsp1_du_setup_lif() // returns void
      vsp1_device_get() // returns -ETIMEDOUT,

As the vsp1_du_setup_lif() returns void, the fact that the hardware
failed to start is ignored.

Later we get a call to  rcar_du_vsp_disable(), which again calls into
vsp1_du_setup_lif(), this time to disable the pipeline. And it is here,
that the call to media_pipeline_stop() is an unbalanced call, as the
corresponding media_pipeline_start() would only have been called if the
vsp1_device_get() had succeeded, thus we find ourselves with a kernel
panic on a null dereference.

Sorry for the terse notes, they are possibly/probably really for me if I
get tasked to look back at this.
--
Regards

Kieran


On 13/12/16 17:59, Kieran Bingham wrote:
> media_entity_pipeline_stop() can be called through error paths with a
> NULL entity pipe object. In this instance, stopping is a no-op, so
> simply return without any action
> 
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> ---
> 
> I've marked this patch as RFC, although if deemed suitable, by all means
> integrate it as is.
> 
> When testing suspend/resume operations on VSP1, I encountered a segfault on the
> WARN_ON(!pipe->streaming_count) line, where 'pipe == NULL'. The simple
> protection fix is to return early in this instance, as this patch does however:
> 
> A) Does this early return path warrant a WARN() statement itself, to identify
> drivers which are incorrectly calling media_entity_pipeline_stop() with an
> invalid entity, or would this just be noise ...
> 
> and therefore..
> 
> B) I also partly assume this patch could simply get NAK'd with a request to go
> and dig out the root cause of calling media_entity_pipeline_stop() with an
> invalid entity. 
> 
> My brief investigation so far here so far shows that it's almost a second order
> fault - where the first suspend resume cycle completes but leaves the entity in
> an invalid state having followed an error path - and then on a second
> suspend/resume - the stop fails with the affected segfault.
> 
> If statement A) or B) apply here, please drop this patch from the series, and
> don't consider it a blocking issue for the other 3 patches.
> 
> Kieran
> 
> 
>  drivers/media/media-entity.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> index c68239e60487..93c9cbf4bf46 100644
> --- a/drivers/media/media-entity.c
> +++ b/drivers/media/media-entity.c
> @@ -508,6 +508,8 @@ void __media_entity_pipeline_stop(struct media_entity *entity)
>  	struct media_entity_graph *graph = &entity->pipe->graph;
>  	struct media_pipeline *pipe = entity->pipe;
>  
> +	if (!pipe)
> +		return;
>  
>  	WARN_ON(!pipe->streaming_count);
>  	media_entity_graph_walk_start(graph, entity);
> 
