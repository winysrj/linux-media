Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:43978 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751298AbeERVEn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 May 2018 17:04:43 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kieran Bingham <kieran@ksquared.org.uk>
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: Re: [PATCH v11 10/10] media: vsp1: Move video configuration to a cached dlb
Date: Sat, 19 May 2018 00:05:05 +0300
Message-ID: <50895869.ZX84A3tOQ9@avalon>
In-Reply-To: <02b8eb289bd4af3a9717dff3a7750940588d505b.1526675940.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.4fb0850a617881b465a66140fdf06941777212ae.1526675940.git-series.kieran.bingham+renesas@ideasonboard.com> <02b8eb289bd4af3a9717dff3a7750940588d505b.1526675940.git-series.kieran.bingham+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

Thank you for the patch.

On Friday, 18 May 2018 23:42:03 EEST Kieran Bingham wrote:
> From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> 
> We are now able to configure a pipeline directly into a local display
> list body. Take advantage of this fact, and create a cacheable body to
> store the configuration of the pipeline in the video object.

s/video object/pipeline object/

> 
> vsp1_video_pipeline_run() is now the last user of the pipe->dl object.
> Convert this function to use the cached video->config body and obtain a

s/video->config/pipe->stream_config/

> local display list reference.
> 
> Attach the video->stream_config body to the display list when needed

s/video/pipe/

> before committing to hardware.
> 
> Use a flag 'configured' to know when we should attach our stream_config
> to the next outgoing display list to reconfigure the hardware in the
> event of our first frame, or the first frame following a suspend/resume
> cycle.
> 
> Our video DL usage now looks like the below output:
> 
> dl->body0 contains our disposable runtime configuration. Max 41.
> dl_child->body0 is our partition specific configuration. Max 12.
> dl->bodies shows our constant configuration and LUTs.
> 
>   These two are LUT/CLU:
>      * dl->bodies[x]->num_entries 256 / max 256
>      * dl->bodies[x]->num_entries 4914 / max 4914
> 
> Which shows that our 'constant' configuration cache is currently
> utilised to a maximum of 64 entries.
> 
> trace-cmd report | \
>     grep max | sed 's/.*vsp1_dl_list_commit://g' | sort | uniq;
> 
>   dl->body0->num_entries 13 / max 128
>   dl->body0->num_entries 14 / max 128
>   dl->body0->num_entries 16 / max 128
>   dl->body0->num_entries 20 / max 128
>   dl->body0->num_entries 27 / max 128
>   dl->body0->num_entries 34 / max 128
>   dl->body0->num_entries 41 / max 128
>   dl_child->body0->num_entries 10 / max 128
>   dl_child->body0->num_entries 12 / max 128
>   dl->bodies[x]->num_entries 15 / max 128
>   dl->bodies[x]->num_entries 16 / max 128
>   dl->bodies[x]->num_entries 17 / max 128
>   dl->bodies[x]->num_entries 18 / max 128
>   dl->bodies[x]->num_entries 20 / max 128
>   dl->bodies[x]->num_entries 21 / max 128
>   dl->bodies[x]->num_entries 256 / max 256
>   dl->bodies[x]->num_entries 31 / max 128
>   dl->bodies[x]->num_entries 32 / max 128
>   dl->bodies[x]->num_entries 39 / max 128
>   dl->bodies[x]->num_entries 40 / max 128
>   dl->bodies[x]->num_entries 47 / max 128
>   dl->bodies[x]->num_entries 48 / max 128
>   dl->bodies[x]->num_entries 4914 / max 4914
>   dl->bodies[x]->num_entries 55 / max 128
>   dl->bodies[x]->num_entries 56 / max 128
>   dl->bodies[x]->num_entries 63 / max 128
>   dl->bodies[x]->num_entries 64 / max 128
> 
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> ---
> v11:
>  - Remove dlbs pool from video object.
>    Utilise the DLM pool for video->stream_config
>  - Improve comments
>  - clear the video->stream_config after it is released
>    object.
>  - stream_config and configured flag return to the pipe object.
> 
> v10:
>  - Removed pipe->configured flag, and use
>    pipe->state == VSP1_PIPELINE_STOPPED instead.
> 
> v8:
>  - Fix comments
>  - Rename video->pipe_config -> video->stream_config
> 
> v4:
>  - Adjust pipe configured flag to be reset on resume rather than suspend
>  - rename dl_child, dl_next
> 
> v3:
>  - 's/fragment/body/', 's/fragments/bodies/'
>  - video dlb cache allocation increased from 2 to 3 dlbs
> 
>  drivers/media/platform/vsp1/vsp1_dl.c    | 10 +++-
>  drivers/media/platform/vsp1/vsp1_dl.h    |  1 +-
>  drivers/media/platform/vsp1/vsp1_pipe.h  |  6 +-
>  drivers/media/platform/vsp1/vsp1_video.c | 69 +++++++++++++++----------
>  4 files changed, 56 insertions(+), 30 deletions(-)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_dl.c
> b/drivers/media/platform/vsp1/vsp1_dl.c index c7fa1cb088cd..0f97305de965
> 100644
> --- a/drivers/media/platform/vsp1/vsp1_dl.c
> +++ b/drivers/media/platform/vsp1/vsp1_dl.c
> @@ -813,6 +813,11 @@ void vsp1_dlm_reset(struct vsp1_dl_manager *dlm)
>  	dlm->pending = NULL;
>  }
> 
> +struct vsp1_dl_body *vsp1_dlm_dl_body_get(struct vsp1_dl_manager *dlm)
> +{
> +	return vsp1_dl_body_get(dlm->pool);
> +}
> +
>  struct vsp1_dl_manager *vsp1_dlm_create(struct vsp1_device *vsp1,
>  					unsigned int index,
>  					unsigned int prealloc)
> @@ -838,13 +843,14 @@ struct vsp1_dl_manager *vsp1_dlm_create(struct
> vsp1_device *vsp1,
>  	 * Initialize the display list body and allocate DMA memory for the body
>  	 * and the optional header. Both are allocated together to avoid memory
>  	 * fragmentation, with the header located right after the body in
> -	 * memory.
> +	 * memory. An extra body is allocated on top of the prealloc to account
> +	 * for the cached body used by the vsp1_video object.

s/vsp1_video/vsp1_pipeline/

Apart from that,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

There's no need to resubmit, I'll fix when applying.

>  	 */
>  	header_size = dlm->mode == VSP1_DL_MODE_HEADER
>  		    ? ALIGN(sizeof(struct vsp1_dl_header), 8)
> 
>  		    : 0;
> 
> -	dlm->pool = vsp1_dl_body_pool_create(vsp1, prealloc,
> +	dlm->pool = vsp1_dl_body_pool_create(vsp1, prealloc + 1,
>  					     VSP1_DL_NUM_ENTRIES, header_size);
>  	if (!dlm->pool)
>  		return NULL;
> diff --git a/drivers/media/platform/vsp1/vsp1_dl.h
> b/drivers/media/platform/vsp1/vsp1_dl.h index 216bd23029dd..7dba0469c92e
> 100644
> --- a/drivers/media/platform/vsp1/vsp1_dl.h
> +++ b/drivers/media/platform/vsp1/vsp1_dl.h
> @@ -28,6 +28,7 @@ struct vsp1_dl_manager *vsp1_dlm_create(struct vsp1_device
> *vsp1, void vsp1_dlm_destroy(struct vsp1_dl_manager *dlm);
>  void vsp1_dlm_reset(struct vsp1_dl_manager *dlm);
>  unsigned int vsp1_dlm_irq_frame_end(struct vsp1_dl_manager *dlm);
> +struct vsp1_dl_body *vsp1_dlm_dl_body_get(struct vsp1_dl_manager *dlm);
> 
>  struct vsp1_dl_list *vsp1_dl_list_get(struct vsp1_dl_manager *dlm);
>  void vsp1_dl_list_put(struct vsp1_dl_list *dl);
> diff --git a/drivers/media/platform/vsp1/vsp1_pipe.h
> b/drivers/media/platform/vsp1/vsp1_pipe.h index f1155d20fa2d..743d8f0db45c
> 100644
> --- a/drivers/media/platform/vsp1/vsp1_pipe.h
> +++ b/drivers/media/platform/vsp1/vsp1_pipe.h
> @@ -102,7 +102,8 @@ struct vsp1_partition {
>   * @uds: UDS entity, if present
>   * @uds_input: entity at the input of the UDS, if the UDS is present
>   * @entities: list of entities in the pipeline
> - * @dl: display list associated with the pipeline
> + * @stream_config: cached stream configuration for video pipelines
> + * @configured: when false the @stream_config shall be written to the
> hardware
>   * @partitions: The number of partitions used to process one frame
>   * @partition: The current partition for configuration to process *
> @part_table: The pre-calculated partitions used by the pipeline @@ -139,7
> +140,8 @@ struct vsp1_pipeline {
>  	 */
>  	struct list_head entities;
> 
> -	struct vsp1_dl_list *dl;
> +	struct vsp1_dl_body *stream_config;
> +	bool configured;
> 
>  	unsigned int partitions;
>  	struct vsp1_partition *partition;
> diff --git a/drivers/media/platform/vsp1/vsp1_video.c
> b/drivers/media/platform/vsp1/vsp1_video.c index c46291ff9e6b..81d47a09d7bc
> 100644
> --- a/drivers/media/platform/vsp1/vsp1_video.c
> +++ b/drivers/media/platform/vsp1/vsp1_video.c
> @@ -392,42 +392,51 @@ static void vsp1_video_pipeline_run(struct
> vsp1_pipeline *pipe) struct vsp1_device *vsp1 = pipe->output->entity.vsp1;
>  	struct vsp1_entity *entity;
>  	struct vsp1_dl_body *dlb;
> +	struct vsp1_dl_list *dl;
>  	unsigned int partition;
> 
> -	if (!pipe->dl)
> -		pipe->dl = vsp1_dl_list_get(pipe->output->dlm);
> +	dl = vsp1_dl_list_get(pipe->output->dlm);
> 
> -	dlb = vsp1_dl_list_get_body0(pipe->dl);
> +	/*
> +	 * If the VSP hardware isn't configured yet (which occurs either when
> +	 * processing the first frame or after a system suspend/resume), add the
> +	 * cached stream configuration to the display list to perform a full
> +	 * initialisation.
> +	 */
> +	if (!pipe->configured)
> +		vsp1_dl_list_add_body(dl, pipe->stream_config);
> +
> +	dlb = vsp1_dl_list_get_body0(dl);
> 
>  	list_for_each_entry(entity, &pipe->entities, list_pipe)
> -		vsp1_entity_configure_frame(entity, pipe, pipe->dl, dlb);
> +		vsp1_entity_configure_frame(entity, pipe, dl, dlb);
> 
>  	/* Run the first partition. */
> -	vsp1_video_pipeline_run_partition(pipe, pipe->dl, 0);
> +	vsp1_video_pipeline_run_partition(pipe, dl, 0);
> 
>  	/* Process consecutive partitions as necessary. */
>  	for (partition = 1; partition < pipe->partitions; ++partition) {
> -		struct vsp1_dl_list *dl;
> +		struct vsp1_dl_list *dl_next;
> 
> -		dl = vsp1_dl_list_get(pipe->output->dlm);
> +		dl_next = vsp1_dl_list_get(pipe->output->dlm);
> 
>  		/*
>  		 * An incomplete chain will still function, but output only
>  		 * the partitions that had a dl available. The frame end
>  		 * interrupt will be marked on the last dl in the chain.
>  		 */
> -		if (!dl) {
> +		if (!dl_next) {
>  			dev_err(vsp1->dev, "Failed to obtain a dl list. Frame will be
> incomplete\n"); break;
>  		}
> 
> -		vsp1_video_pipeline_run_partition(pipe, dl, partition);
> -		vsp1_dl_list_add_chain(pipe->dl, dl);
> +		vsp1_video_pipeline_run_partition(pipe, dl_next, partition);
> +		vsp1_dl_list_add_chain(dl, dl_next);
>  	}
> 
>  	/* Complete, and commit the head display list. */
> -	vsp1_dl_list_commit(pipe->dl, false);
> -	pipe->dl = NULL;
> +	vsp1_dl_list_commit(dl, false);
> +	pipe->configured = true;
> 
>  	vsp1_pipeline_run(pipe);
>  }
> @@ -791,7 +800,6 @@ static void vsp1_video_buffer_queue(struct vb2_buffer
> *vb) static int vsp1_video_setup_pipeline(struct vsp1_pipeline *pipe)
>  {
>  	struct vsp1_entity *entity;
> -	struct vsp1_dl_body *dlb;
>  	int ret;
> 
>  	/* Determine this pipelines sizes for image partitioning support. */
> @@ -799,14 +807,6 @@ static int vsp1_video_setup_pipeline(struct
> vsp1_pipeline *pipe) if (ret < 0)
>  		return ret;
> 
> -	/* Prepare the display list. */
> -	pipe->dl = vsp1_dl_list_get(pipe->output->dlm);
> -	if (!pipe->dl)
> -		return -ENOMEM;
> -
> -	/* Retrieve the default DLB from the list. */
> -	dlb = vsp1_dl_list_get_body0(pipe->dl);
> -
>  	if (pipe->uds) {
>  		struct vsp1_uds *uds = to_uds(&pipe->uds->subdev);
> 
> @@ -828,9 +828,18 @@ static int vsp1_video_setup_pipeline(struct
> vsp1_pipeline *pipe) }
>  	}
> 
> +	/*
> +	 * Compute and cache the stream configuration into a body. The cached
> +	 * body will be added to the display list by vsp1_video_pipeline_run()
> +	 * whenever the pipeline needs to be fully reconfigured.
> +	 */
> +	pipe->stream_config = vsp1_dlm_dl_body_get(pipe->output->dlm);
> +	if (!pipe->stream_config)
> +		return -ENOMEM;
> +
>  	list_for_each_entry(entity, &pipe->entities, list_pipe) {
> -		vsp1_entity_route_setup(entity, pipe, dlb);
> -		vsp1_entity_configure_stream(entity, pipe, dlb);
> +		vsp1_entity_route_setup(entity, pipe, pipe->stream_config);
> +		vsp1_entity_configure_stream(entity, pipe, pipe->stream_config);
>  	}
> 
>  	return 0;
> @@ -853,12 +862,14 @@ static void vsp1_video_cleanup_pipeline(struct
> vsp1_pipeline *pipe) {
>  	lockdep_assert_held(&pipe->lock);
> 
> +	/* Release any cached configuration from our output video. */
> +	vsp1_dl_body_put(pipe->stream_config);
> +	pipe->stream_config = NULL;
> +	pipe->configured = false;
> +
>  	/* Release our partition table allocation */
>  	kfree(pipe->part_table);
>  	pipe->part_table = NULL;
> -
> -	vsp1_dl_list_put(pipe->dl);
> -	pipe->dl = NULL;
>  }
> 
>  static int vsp1_video_start_streaming(struct vb2_queue *vq, unsigned int
> count) @@ -1232,6 +1243,12 @@ void vsp1_video_resume(struct vsp1_device
> *vsp1) if (pipe == NULL)
>  			continue;
> 
> +		/*
> +		 * The hardware may have been reset during a suspend and will
> +		 * need a full reconfiguration.
> +		 */
> +		pipe->configured = false;
> +
>  		spin_lock_irqsave(&pipe->irqlock, flags);
>  		if (vsp1_pipeline_ready(pipe))
>  			vsp1_video_pipeline_run(pipe);

-- 
Regards,

Laurent Pinchart
