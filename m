Return-Path: <SRS0=7VZ/=QY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43CFBC43381
	for <linux-media@archiver.kernel.org>; Sun, 17 Feb 2019 20:06:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A87E92184A
	for <linux-media@archiver.kernel.org>; Sun, 17 Feb 2019 20:06:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="uJElGDoL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726169AbfBQUGj (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 17 Feb 2019 15:06:39 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:58914 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726012AbfBQUGj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 17 Feb 2019 15:06:39 -0500
Received: from [192.168.0.21] (cpc89242-aztw30-2-0-cust488.18-1.cable.virginm.net [86.31.129.233])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id C9FB049;
        Sun, 17 Feb 2019 21:06:35 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1550433996;
        bh=LvpiWIFCavmLRLT8ilIhutxckxDLriUnXi+CmNJqnNQ=;
        h=Reply-To:Subject:To:References:From:Date:In-Reply-To:From;
        b=uJElGDoLpilhMMo10qk2FJn+wwvLmfClbdVWa5g0Ji+8Z5kRH8JGKryvM5MqobJGl
         xVBF4YTdekBhHio3OQfDyWWlxAnQxlnu2hms3/+U1XoM15tVHbIQR+F4kLeUxGkTQS
         XOg4LQVo17qro30lhdqmjkjZXdSy+BnrD9vOXYB4=
Reply-To: kieran.bingham@ideasonboard.com
Subject: Re: [PATCH v4 7/7] media: vsp1: Provide a writeback video device
To:     Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
References: <20190217024852.23328-1-laurent.pinchart+renesas@ideasonboard.com>
 <20190217024852.23328-8-laurent.pinchart+renesas@ideasonboard.com>
From:   Kieran Bingham <kieran.bingham@ideasonboard.com>
Openpgp: preference=signencrypt
Autocrypt: addr=kieran.bingham@ideasonboard.com; keydata=
 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
 sbsRB8KNNvVXBOVNwko86rQqF9drZuw=
Organization: Ideas on Board
Message-ID: <42e86cc1-ff3d-1e98-9da6-b072497dbed2@ideasonboard.com>
Date:   Sun, 17 Feb 2019 20:06:32 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190217024852.23328-8-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Laurent,

Thank you for updating the patch,

On 17/02/2019 02:48, Laurent Pinchart wrote:
> From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> 
> When the VSP1 is used in an active display pipeline, the output of the
> WPF can supply the LIF entity directly and simultaneously write to
> memory.
> 
> Support this functionality in the VSP1 driver through a V4L2 video
> device node connected to the WPF.
> 
> The writeback video node support RGB formats only due to the WPF
> outputting RGB to the LIF. The pixel format can otherwise be configured
> freely.
> 
> The resolution of the captured frames are set by the display mode. A
> different resolution can be selected on the video node, in which case
> cropping or composing will be performed.
> 
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

For your changes,

With the documentation updated for vsp1_dl_body_write_patch(),

Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

> ---
> Changes since v3:
> 
> - Infer has_writeback from the number of LIFs and the generation
> - Remove vsp1_video::is_writeback
> - Describe writeback video nodes as 'writeback'
> - Add mechanism to patch active display lists
> - Handle writeback format restrictions
> - Don't wait for next page flip before completing writeback buffer

This is a nice addition.

> - Periods at the end of sentences.

You also fix writeback for the bitrot that the previous sets had now
that we have partition handling.

Interestingly my local implementation for this bitrot was just to
allocate a table for a single partition. I like your implementation
better :)


> 
> Changes since v2:
>  - Rebased to v4.12-rc1
> 
> Changes since RFC
>  - Fix checkpatch.pl warnings
>  - Adapt to use a single source pad for the Writeback and LIF
>  - Use WPF properties to determine when to create links instead of VSP
>  - Remove incorrect vsp1_video_verify_format() changes
>  - Spelling and grammar fixes
> ---
>  drivers/media/platform/vsp1/vsp1_dl.c    |  83 +++++++++++++
>  drivers/media/platform/vsp1/vsp1_dl.h    |   4 +
>  drivers/media/platform/vsp1/vsp1_drm.c   |  14 ++-
>  drivers/media/platform/vsp1/vsp1_drv.c   |  17 ++-
>  drivers/media/platform/vsp1/vsp1_pipe.c  |   5 +
>  drivers/media/platform/vsp1/vsp1_pipe.h  |   6 +
>  drivers/media/platform/vsp1/vsp1_rwpf.h  |   2 +
>  drivers/media/platform/vsp1/vsp1_video.c | 150 +++++++++++++++++++++--
>  drivers/media/platform/vsp1/vsp1_video.h |   6 +
>  drivers/media/platform/vsp1/vsp1_wpf.c   |  49 ++++++--
>  10 files changed, 318 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_dl.c b/drivers/media/platform/vsp1/vsp1_dl.c
> index 886b3a69d329..591544382946 100644
> --- a/drivers/media/platform/vsp1/vsp1_dl.c
> +++ b/drivers/media/platform/vsp1/vsp1_dl.c
> @@ -115,6 +115,12 @@ struct vsp1_dl_body {
>  
>  	unsigned int num_entries;
>  	unsigned int max_entries;
> +
> +	unsigned int num_patches;
> +	struct {
> +		struct vsp1_dl_entry *entry;
> +		u32 data;
> +	} patches[2];

What's the significance of [2] ?
Perhaps it will be clear what two entry's support patching later...


Ok - yes - it's to patch both the Writeback enable and the display start
enable.


>  };
>  
>  /**
> @@ -361,6 +367,7 @@ void vsp1_dl_body_put(struct vsp1_dl_body *dlb)
>  		return;
>  
>  	dlb->num_entries = 0;
> +	dlb->num_patches = 0;
>  
>  	spin_lock_irqsave(&dlb->pool->lock, flags);
>  	list_add_tail(&dlb->free, &dlb->pool->free);
> @@ -388,6 +395,37 @@ void vsp1_dl_body_write(struct vsp1_dl_body *dlb, u32 reg, u32 data)
>  	dlb->num_entries++;
>  }
>  
> +/**
> + * vsp1_dl_body_write - Write a register to a display list body

s/_write/_write_patch/

"Store an update to an existing register for handling at display-start
interrupt...."? (or as you see fit)


> + * @dlb: The body
> + * @reg: The register address
> + * @data: The register value
> + *

+ patch: The updated value to modify...

> + * Write the given register and value to the display list body. The maximum
> + * number of entries that can be written in a body is specified when the body is
> + * allocated by vsp1_dl_body_alloc().

I guess this is a copy/paste hangover.

How about:

"Display lists in continuous mode are re-used by the hardware for
successive frames without needed to recommit a new display list. A patch
allows us to apply small changes to the display list before it is reused
to allow minor configuration changes without involving a full rewrite of
the list or facing a race at commit."


(Or however you see fit...)


> + */
> +void vsp1_dl_body_write_patch(struct vsp1_dl_body *dlb, u32 reg, u32 data,
> +			      u32 patch)
> +{
> +	if (WARN_ONCE(dlb->num_entries >= dlb->max_entries,
> +		      "DLB size exceeded (max %u)", dlb->max_entries))
> +		return;
> +
> +	if (WARN_ONCE(dlb->num_patches >= ARRAY_SIZE(dlb->patches),
> +		      "DLB patches size exceeded (max %lu)",
> +		      ARRAY_SIZE(dlb->patches)))
> +		return;
> +
> +	dlb->patches[dlb->num_patches].entry = &dlb->entries[dlb->num_entries];
> +	dlb->patches[dlb->num_patches].data = patch;
> +	dlb->num_patches++;
> +
> +	dlb->entries[dlb->num_entries].addr = reg;
> +	dlb->entries[dlb->num_entries].data = data;
> +	dlb->num_entries++;
> +}
> +
>  /* -----------------------------------------------------------------------------
>   * Display List Extended Command Management
>   */
> @@ -652,6 +690,7 @@ static void __vsp1_dl_list_put(struct vsp1_dl_list *dl)
>  	 * has at least one body, thus we reinitialise the entries list.
>  	 */
>  	dl->body0->num_entries = 0;
> +	dl->body0->num_patches = 0;
>  
>  	list_add_tail(&dl->list, &dl->dlm->free);
>  }
> @@ -930,6 +969,36 @@ void vsp1_dl_list_commit(struct vsp1_dl_list *dl, unsigned int dl_flags)
>   * Display List Manager
>   */
>  
> +/**
> + * vsp1_dlm_irq_display_start - Display list handler for the display start
> + *	interrupt
> + * @dlm: the display list manager
> + *
> + * Apply all patches registered for the active display list. This is used to
> + * disable writeback for the next frame.
> + */
> +void vsp1_dlm_irq_display_start(struct vsp1_dl_manager *dlm)
> +{
> +	struct vsp1_dl_body *dlb;
> +	struct vsp1_dl_list *dl;
> +	unsigned int i;
> +
> +	spin_lock(&dlm->lock);
> +
> +	dl = dlm->active;
> +	if (!dl)
> +		goto done;
> +
> +	list_for_each_entry(dlb, &dl->bodies, list) {
> +		for (i = 0; i < dlb->num_patches; ++i)
> +			dlb->patches[i].entry->data = dlb->patches[i].data;
> +		dlb->num_patches = 0;
> +	}
> +
> +done:
> +	spin_unlock(&dlm->lock);
> +}
> +
>  /**
>   * vsp1_dlm_irq_frame_end - Display list handler for the frame end interrupt
>   * @dlm: the display list manager
> @@ -947,6 +1016,9 @@ void vsp1_dl_list_commit(struct vsp1_dl_list *dl, unsigned int dl_flags)
>   *
>   * The VSP1_DL_FRAME_END_INTERNAL flag indicates that the display list that just
>   * became active had been queued with the internal notification flag.
> + *
> + * The VSP1_DL_FRAME_END_WRITEBACK flag indicates that the previously active
> + * display list had been queued with the writeback flag.
>   */
>  unsigned int vsp1_dlm_irq_frame_end(struct vsp1_dl_manager *dlm)
>  {
> @@ -984,6 +1056,17 @@ unsigned int vsp1_dlm_irq_frame_end(struct vsp1_dl_manager *dlm)
>  	if (status & VI6_STATUS_FLD_STD(dlm->index))
>  		goto done;
>  
> +	/*
> +	 * If the active display list has the writeback flag set, the frame
> +	 * completion marks the end of the writeback capture. Return the
> +	 * VSP1_DL_FRAME_END_WRITEBACK flag and reset the display list's
> +	 * writeback flag.
> +	 */
> +	if (dlm->active && (dlm->active->flags & VSP1_DL_FRAME_END_WRITEBACK)) {
> +		flags |= VSP1_DL_FRAME_END_WRITEBACK;
> +		dlm->active->flags &= ~VSP1_DL_FRAME_END_WRITEBACK;
> +	}
> +
>  	/*
>  	 * The device starts processing the queued display list right after the
>  	 * frame end interrupt. The display list thus becomes active.
> diff --git a/drivers/media/platform/vsp1/vsp1_dl.h b/drivers/media/platform/vsp1/vsp1_dl.h
> index e0fdb145e6ed..cbaa0bf0cbc2 100644
> --- a/drivers/media/platform/vsp1/vsp1_dl.h
> +++ b/drivers/media/platform/vsp1/vsp1_dl.h
> @@ -19,6 +19,7 @@ struct vsp1_dl_manager;
>  
>  #define VSP1_DL_FRAME_END_COMPLETED		BIT(0)
>  #define VSP1_DL_FRAME_END_INTERNAL		BIT(1)
> +#define VSP1_DL_FRAME_END_WRITEBACK		BIT(2)
>  
>  /**
>   * struct vsp1_dl_ext_cmd - Extended Display command
> @@ -54,6 +55,7 @@ struct vsp1_dl_manager *vsp1_dlm_create(struct vsp1_device *vsp1,
>  					unsigned int prealloc);
>  void vsp1_dlm_destroy(struct vsp1_dl_manager *dlm);
>  void vsp1_dlm_reset(struct vsp1_dl_manager *dlm);
> +void vsp1_dlm_irq_display_start(struct vsp1_dl_manager *dlm);
>  unsigned int vsp1_dlm_irq_frame_end(struct vsp1_dl_manager *dlm);
>  struct vsp1_dl_body *vsp1_dlm_dl_body_get(struct vsp1_dl_manager *dlm);
>  
> @@ -71,6 +73,8 @@ struct vsp1_dl_body *vsp1_dl_body_get(struct vsp1_dl_body_pool *pool);
>  void vsp1_dl_body_put(struct vsp1_dl_body *dlb);
>  
>  void vsp1_dl_body_write(struct vsp1_dl_body *dlb, u32 reg, u32 data);
> +void vsp1_dl_body_write_patch(struct vsp1_dl_body *dlb, u32 reg, u32 data,
> +			      u32 patch);
>  int vsp1_dl_list_add_body(struct vsp1_dl_list *dl, struct vsp1_dl_body *dlb);
>  int vsp1_dl_list_add_chain(struct vsp1_dl_list *head, struct vsp1_dl_list *dl);
>  
> diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
> index 9d20ef5cd5f8..e9d0ce432a2c 100644
> --- a/drivers/media/platform/vsp1/vsp1_drm.c
> +++ b/drivers/media/platform/vsp1/vsp1_drm.c
> @@ -23,6 +23,7 @@
>  #include "vsp1_pipe.h"
>  #include "vsp1_rwpf.h"
>  #include "vsp1_uif.h"
> +#include "vsp1_video.h"
>  
>  #define BRX_NAME(e)	(e)->type == VSP1_ENTITY_BRU ? "BRU" : "BRS"
>  
> @@ -34,7 +35,7 @@ static void vsp1_du_pipeline_frame_end(struct vsp1_pipeline *pipe,
>  				       unsigned int completion)
>  {
>  	struct vsp1_drm_pipeline *drm_pipe = to_vsp1_drm_pipeline(pipe);
> -	bool complete = completion == VSP1_DL_FRAME_END_COMPLETED;
> +	bool complete = completion & VSP1_DL_FRAME_END_COMPLETED;
>  
>  	if (drm_pipe->du_complete) {
>  		struct vsp1_entity *uif = drm_pipe->uif;
> @@ -48,6 +49,9 @@ static void vsp1_du_pipeline_frame_end(struct vsp1_pipeline *pipe,
>  		drm_pipe->force_brx_release = false;
>  		wake_up(&drm_pipe->wait_queue);
>  	}
> +
> +	if (completion & VSP1_DL_FRAME_END_WRITEBACK)
> +		vsp1_video_wb_frame_end(pipe->output->video);
>  }
>  
>  /* -----------------------------------------------------------------------------
> @@ -541,6 +545,8 @@ static void vsp1_du_pipeline_configure(struct vsp1_pipeline *pipe)
>  
>  	if (drm_pipe->force_brx_release)
>  		dl_flags |= VSP1_DL_FRAME_END_INTERNAL;
> +	if (pipe->output->writeback)
> +		dl_flags |= VSP1_DL_FRAME_END_WRITEBACK;
>  
>  	dl = vsp1_dl_list_get(pipe->output->dlm);
>  	dlb = vsp1_dl_list_get_body0(dl);
> @@ -859,8 +865,14 @@ void vsp1_du_atomic_flush(struct device *dev, unsigned int pipe_index,
>  	drm_pipe->crc = cfg->crc;
>  
>  	mutex_lock(&vsp1->drm->lock);
> +
> +	/* If we have a writeback node attached, update the video buffers. */
> +	if (pipe->output->video)
> +		vsp1_video_wb_prepare(pipe->output->video);
> +
>  	vsp1_du_pipeline_setup_inputs(vsp1, pipe);
>  	vsp1_du_pipeline_configure(pipe);
> +
>  	mutex_unlock(&vsp1->drm->lock);
>  }
>  EXPORT_SYMBOL_GPL(vsp1_du_atomic_flush);
> diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
> index c650e45bb0ad..235febd18ffa 100644
> --- a/drivers/media/platform/vsp1/vsp1_drv.c
> +++ b/drivers/media/platform/vsp1/vsp1_drv.c
> @@ -63,6 +63,21 @@ static irqreturn_t vsp1_irq_handler(int irq, void *data)
>  			vsp1_pipeline_frame_end(wpf->entity.pipe);
>  			ret = IRQ_HANDLED;
>  		}
> +
> +		/*
> +		 * Process the display start interrupt after the frame end
> +		 * interrupt to make sure the display list queue is correctly
> +		 * updated when processing the display start.
> +		 */
> +		if (wpf->has_writeback) {
> +			status = vsp1_read(vsp1, VI6_DISP_IRQ_STA(i));
> +			vsp1_write(vsp1, VI6_DISP_IRQ_STA(i), ~status & mask);
> +
> +			if (status & VI6_DISP_IRQ_STA_DST) {
> +				vsp1_pipeline_display_start(wpf->entity.pipe);
> +				ret = IRQ_HANDLED;
> +			}
> +		}
>  	}
>  
>  	return ret;
> @@ -435,7 +450,7 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
>  		vsp1->wpf[i] = wpf;
>  		list_add_tail(&wpf->entity.list_dev, &vsp1->entities);
>  
> -		if (vsp1->info->uapi) {
> +		if (vsp1->info->uapi || wpf->has_writeback) {
>  			struct vsp1_video *video = vsp1_video_create(vsp1, wpf);
>  
>  			if (IS_ERR(video)) {
> diff --git a/drivers/media/platform/vsp1/vsp1_pipe.c b/drivers/media/platform/vsp1/vsp1_pipe.c
> index 54ff539ffea0..016800c45bc1 100644
> --- a/drivers/media/platform/vsp1/vsp1_pipe.c
> +++ b/drivers/media/platform/vsp1/vsp1_pipe.c
> @@ -309,6 +309,11 @@ bool vsp1_pipeline_ready(struct vsp1_pipeline *pipe)
>  	return pipe->buffers_ready == mask;
>  }
>  
> +void vsp1_pipeline_display_start(struct vsp1_pipeline *pipe)
> +{
> +	vsp1_dlm_irq_display_start(pipe->output->dlm);
> +}
> +
>  void vsp1_pipeline_frame_end(struct vsp1_pipeline *pipe)
>  {
>  	unsigned int flags;
> diff --git a/drivers/media/platform/vsp1/vsp1_pipe.h b/drivers/media/platform/vsp1/vsp1_pipe.h
> index ae646c9ef337..82d51b891f1e 100644
> --- a/drivers/media/platform/vsp1/vsp1_pipe.h
> +++ b/drivers/media/platform/vsp1/vsp1_pipe.h
> @@ -47,6 +47,11 @@ struct vsp1_format_info {
>  	bool alpha;
>  };
>  
> +static inline bool vsp1_format_is_rgb(const struct vsp1_format_info *info)
> +{
> +	return info->mbus == MEDIA_BUS_FMT_ARGB8888_1X32;
> +}
> +
>  enum vsp1_pipeline_state {
>  	VSP1_PIPELINE_STOPPED,
>  	VSP1_PIPELINE_RUNNING,
> @@ -158,6 +163,7 @@ bool vsp1_pipeline_stopped(struct vsp1_pipeline *pipe);
>  int vsp1_pipeline_stop(struct vsp1_pipeline *pipe);
>  bool vsp1_pipeline_ready(struct vsp1_pipeline *pipe);
>  
> +void vsp1_pipeline_display_start(struct vsp1_pipeline *pipe);
>  void vsp1_pipeline_frame_end(struct vsp1_pipeline *pipe);
>  
>  void vsp1_pipeline_propagate_alpha(struct vsp1_pipeline *pipe,
> diff --git a/drivers/media/platform/vsp1/vsp1_rwpf.h b/drivers/media/platform/vsp1/vsp1_rwpf.h
> index 70742ecf766f..910990b27617 100644
> --- a/drivers/media/platform/vsp1/vsp1_rwpf.h
> +++ b/drivers/media/platform/vsp1/vsp1_rwpf.h
> @@ -35,6 +35,7 @@ struct vsp1_rwpf {
>  	struct v4l2_ctrl_handler ctrls;
>  
>  	struct vsp1_video *video;
> +	bool has_writeback;
>  
>  	unsigned int max_width;
>  	unsigned int max_height;
> @@ -61,6 +62,7 @@ struct vsp1_rwpf {
>  	} flip;
>  
>  	struct vsp1_rwpf_memory mem;
> +	bool writeback;
>  
>  	struct vsp1_dl_manager *dlm;
>  };
> diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
> index 8feaa8d89fe8..0ac3430292d0 100644
> --- a/drivers/media/platform/vsp1/vsp1_video.c
> +++ b/drivers/media/platform/vsp1/vsp1_video.c
> @@ -34,7 +34,6 @@
>  #include "vsp1_uds.h"
>  #include "vsp1_video.h"
>  
> -#define VSP1_VIDEO_DEF_FORMAT		V4L2_PIX_FMT_YUYV
>  #define VSP1_VIDEO_DEF_WIDTH		1024
>  #define VSP1_VIDEO_DEF_HEIGHT		768
>  
> @@ -45,6 +44,14 @@
>   * Helper functions
>   */
>  
> +static inline unsigned int vsp1_video_default_format(struct vsp1_video *video)
> +{
> +	if (video->rwpf->has_writeback)
> +		return V4L2_PIX_FMT_RGB24;
> +	else
> +		return V4L2_PIX_FMT_YUYV;
> +}
> +
>  static struct v4l2_subdev *
>  vsp1_video_remote_subdev(struct media_pad *local, u32 *pad)
>  {
> @@ -113,11 +120,13 @@ static int __vsp1_video_try_format(struct vsp1_video *video,
>  
>  	/*
>  	 * Retrieve format information and select the default format if the
> -	 * requested format isn't supported.
> +	 * requested format isn't supported. Writeback video nodes only support
> +	 * RGB formats.
>  	 */
>  	info = vsp1_get_format_info(video->vsp1, pix->pixelformat);
> -	if (info == NULL)
> -		info = vsp1_get_format_info(video->vsp1, VSP1_VIDEO_DEF_FORMAT);
> +	if (!info || (video->rwpf->has_writeback && !vsp1_format_is_rgb(info)))
> +		info = vsp1_get_format_info(video->vsp1,
> +					    vsp1_video_default_format(video));
>  
>  	pix->pixelformat = info->fourcc;
>  	pix->colorspace = V4L2_COLORSPACE_SRGB;
> @@ -946,6 +955,122 @@ static const struct vb2_ops vsp1_video_queue_qops = {
>  	.stop_streaming = vsp1_video_stop_streaming,
>  };
>  
> +/* -----------------------------------------------------------------------------
> + * Writeback Support
> + */
> +
> +static void vsp1_video_wb_buffer_queue(struct vb2_buffer *vb)
> +{
> +	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
> +	struct vsp1_video *video = vb2_get_drv_priv(vb->vb2_queue);
> +	struct vsp1_vb2_buffer *buf = to_vsp1_vb2_buffer(vbuf);
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&video->irqlock, flags);
> +	list_add_tail(&buf->queue, &video->irqqueue);
> +	spin_unlock_irqrestore(&video->irqlock, flags);
> +}
> +
> +static int vsp1_video_wb_start_streaming(struct vb2_queue *vq,
> +					 unsigned int count)
> +{
> +	struct vsp1_video *video = vb2_get_drv_priv(vq);
> +
> +	video->wb_running = true;
> +	return 0;
> +}
> +
> +static bool vsp1_video_wb_stopped(struct vsp1_video *video)
> +{
> +	unsigned long flags;
> +	bool stopped;
> +
> +	spin_lock_irqsave(&video->irqlock, flags);
> +	stopped = list_empty(&video->wb_queue);
> +	spin_unlock_irqrestore(&video->irqlock, flags);
> +
> +	return stopped;
> +}
> +
> +static void vsp1_video_wb_stop_streaming(struct vb2_queue *vq)
> +{
> +	struct vsp1_video *video = vb2_get_drv_priv(vq);
> +	struct vsp1_rwpf *rwpf = video->rwpf;
> +	struct vsp1_pipeline *pipe = rwpf->entity.pipe;
> +	unsigned long flags;
> +	int ret;
> +
> +	/* Disable writeback and wait for the pending frames to complete. */
> +	spin_lock_irqsave(&video->irqlock, flags);
> +	video->wb_running = false;
> +	spin_unlock_irqrestore(&video->irqlock, flags);
> +
> +	ret = wait_event_timeout(pipe->wq, vsp1_video_wb_stopped(video),
> +				 msecs_to_jiffies(500));
> +	if (ret == 0) {
> +		dev_err(video->vsp1->dev, "writeback stop timeout\n");
> +		list_splice_init(&video->wb_queue, &video->irqqueue);
> +	}
> +
> +	vsp1_video_release_buffers(video);
> +}
> +
> +static const struct vb2_ops vsp1_video_wb_queue_qops = {
> +	.queue_setup = vsp1_video_queue_setup,
> +	.buf_prepare = vsp1_video_buffer_prepare,
> +	.buf_queue = vsp1_video_wb_buffer_queue,
> +	.wait_prepare = vb2_ops_wait_prepare,
> +	.wait_finish = vb2_ops_wait_finish,
> +	.start_streaming = vsp1_video_wb_start_streaming,
> +	.stop_streaming = vsp1_video_wb_stop_streaming,
> +};
> +
> +void vsp1_video_wb_prepare(struct vsp1_video *video)
> +{
> +	struct vsp1_vb2_buffer *buf;
> +	unsigned long flags;
> +
> +	/*
> +	 * If writeback is disabled, return immediately. Otherwise remove the
> +	 * first buffer from the irqqueue, add it to the writeback queue and
> +	 * configure the WPF for writeback.
> +	 */
> +
> +	spin_lock_irqsave(&video->irqlock, flags);
> +
> +	if (!video->wb_running) {
> +		spin_unlock_irqrestore(&video->irqlock, flags);
> +		return;
> +	}
> +
> +	buf = list_first_entry_or_null(&video->irqqueue, struct vsp1_vb2_buffer,
> +				       queue);
> +	if (buf)
> +		list_move_tail(&buf->queue, &video->wb_queue);
> +
> +	spin_unlock_irqrestore(&video->irqlock, flags);
> +
> +	if (buf) {
> +		video->rwpf->mem = buf->mem;
> +		video->rwpf->writeback = true;
> +	}
> +}
> +
> +void vsp1_video_wb_frame_end(struct vsp1_video *video)
> +{
> +	struct vsp1_vb2_buffer *done;
> +	unsigned long flags;
> +
> +	/* Complete the first buffer from the writeback queue. */
> +	spin_lock_irqsave(&video->irqlock, flags);
> +	done = list_first_entry(&video->wb_queue, struct vsp1_vb2_buffer,
> +				queue);
> +	list_del(&done->queue);
> +	spin_unlock_irqrestore(&video->irqlock, flags);
> +
> +	vsp1_video_complete_buffer(video, done);
> +}
> +
>  /* -----------------------------------------------------------------------------
>   * V4L2 ioctls
>   */
> @@ -1045,6 +1170,13 @@ vsp1_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
>  	if (video->queue.owner && video->queue.owner != file->private_data)
>  		return -EBUSY;
>  
> +	/*
> +	 * Writeback video devices don't need to interface with the pipeline or
> +	 * verify formats, just turn streaming on.
> +	 */
> +	if (video->rwpf->has_writeback)
> +		return vb2_streamon(&video->queue, type);
> +
>  	/*
>  	 * Get a pipeline for the video node and start streaming on it. No link
>  	 * touching an entity in the pipeline can be activated or deactivated
> @@ -1273,7 +1405,7 @@ struct vsp1_video *vsp1_video_create(struct vsp1_device *vsp1,
>  		video->pad.flags = MEDIA_PAD_FL_SOURCE;
>  		video->video.vfl_dir = VFL_DIR_TX;
>  	} else {
> -		direction = "output";
> +		direction = rwpf->has_writeback ? "writeback" : "output";
>  		video->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
>  		video->pad.flags = MEDIA_PAD_FL_SINK;
>  		video->video.vfl_dir = VFL_DIR_RX;
> @@ -1282,6 +1414,7 @@ struct vsp1_video *vsp1_video_create(struct vsp1_device *vsp1,
>  	mutex_init(&video->lock);
>  	spin_lock_init(&video->irqlock);
>  	INIT_LIST_HEAD(&video->irqqueue);
> +	INIT_LIST_HEAD(&video->wb_queue);
>  
>  	/* Initialize the media entity... */
>  	ret = media_entity_pads_init(&video->video.entity, 1, &video->pad);
> @@ -1289,7 +1422,7 @@ struct vsp1_video *vsp1_video_create(struct vsp1_device *vsp1,
>  		return ERR_PTR(ret);
>  
>  	/* ... and the format ... */
> -	rwpf->format.pixelformat = VSP1_VIDEO_DEF_FORMAT;
> +	rwpf->format.pixelformat = vsp1_video_default_format(video);
>  	rwpf->format.width = VSP1_VIDEO_DEF_WIDTH;
>  	rwpf->format.height = VSP1_VIDEO_DEF_HEIGHT;
>  	__vsp1_video_try_format(video, &rwpf->format, &rwpf->fmtinfo);
> @@ -1310,7 +1443,10 @@ struct vsp1_video *vsp1_video_create(struct vsp1_device *vsp1,
>  	video->queue.lock = &video->lock;
>  	video->queue.drv_priv = video;
>  	video->queue.buf_struct_size = sizeof(struct vsp1_vb2_buffer);
> -	video->queue.ops = &vsp1_video_queue_qops;
> +	if (rwpf->has_writeback)
> +		video->queue.ops = &vsp1_video_wb_queue_qops;
> +	else
> +		video->queue.ops = &vsp1_video_queue_qops;
>  	video->queue.mem_ops = &vb2_dma_contig_memops;
>  	video->queue.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
>  	video->queue.dev = video->vsp1->bus_master;
> diff --git a/drivers/media/platform/vsp1/vsp1_video.h b/drivers/media/platform/vsp1/vsp1_video.h
> index f3cf5e2fdf5a..13b357b07ee2 100644
> --- a/drivers/media/platform/vsp1/vsp1_video.h
> +++ b/drivers/media/platform/vsp1/vsp1_video.h
> @@ -44,6 +44,9 @@ struct vsp1_video {
>  	struct vb2_queue queue;
>  	spinlock_t irqlock;
>  	struct list_head irqqueue;
> +
> +	bool wb_running;
> +	struct list_head wb_queue;
>  };
>  
>  static inline struct vsp1_video *to_vsp1_video(struct video_device *vdev)
> @@ -54,6 +57,9 @@ static inline struct vsp1_video *to_vsp1_video(struct video_device *vdev)
>  void vsp1_video_suspend(struct vsp1_device *vsp1);
>  void vsp1_video_resume(struct vsp1_device *vsp1);
>  
> +void vsp1_video_wb_prepare(struct vsp1_video *video);
> +void vsp1_video_wb_frame_end(struct vsp1_video *video);
> +
>  struct vsp1_video *vsp1_video_create(struct vsp1_device *vsp1,
>  				     struct vsp1_rwpf *rwpf);
>  void vsp1_video_cleanup(struct vsp1_video *video);
> diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
> index 18c49e3a7875..81650a625185 100644
> --- a/drivers/media/platform/vsp1/vsp1_wpf.c
> +++ b/drivers/media/platform/vsp1/vsp1_wpf.c
> @@ -240,6 +240,7 @@ static void wpf_configure_stream(struct vsp1_entity *entity,
>  	struct vsp1_device *vsp1 = wpf->entity.vsp1;
>  	const struct v4l2_mbus_framefmt *source_format;
>  	const struct v4l2_mbus_framefmt *sink_format;
> +	unsigned int index = wpf->entity.index;
>  	unsigned int i;
>  	u32 outfmt = 0;
>  	u32 srcrpf = 0;
> @@ -250,8 +251,9 @@ static void wpf_configure_stream(struct vsp1_entity *entity,
>  	source_format = vsp1_entity_get_pad_format(&wpf->entity,
>  						   wpf->entity.config,
>  						   RWPF_PAD_SOURCE);
> +
>  	/* Format */
> -	if (!pipe->lif) {
> +	if (!pipe->lif || wpf->writeback) {
>  		const struct v4l2_pix_format_mplane *format = &wpf->format;
>  		const struct vsp1_format_info *fmtinfo = wpf->fmtinfo;
>  
> @@ -276,8 +278,7 @@ static void wpf_configure_stream(struct vsp1_entity *entity,
>  
>  		vsp1_wpf_write(wpf, dlb, VI6_WPF_DSWAP, fmtinfo->swap);
>  
> -		if (vsp1_feature(vsp1, VSP1_HAS_WPF_HFLIP) &&
> -		    wpf->entity.index == 0)
> +		if (vsp1_feature(vsp1, VSP1_HAS_WPF_HFLIP) && index == 0)
>  			vsp1_wpf_write(wpf, dlb, VI6_WPF_ROT_CTRL,
>  				       VI6_WPF_ROT_CTRL_LN16 |
>  				       (256 << VI6_WPF_ROT_CTRL_LMEM_WD_SHIFT));
> @@ -288,11 +289,9 @@ static void wpf_configure_stream(struct vsp1_entity *entity,
>  
>  	wpf->outfmt = outfmt;
>  
> -	vsp1_dl_body_write(dlb, VI6_DPR_WPF_FPORCH(wpf->entity.index),
> +	vsp1_dl_body_write(dlb, VI6_DPR_WPF_FPORCH(index),
>  			   VI6_DPR_WPF_FPORCH_FP_WPFN);
>  
> -	vsp1_dl_body_write(dlb, VI6_WPF_WRBCK_CTRL(wpf->entity.index), 0);
> -
>  	/*
>  	 * Sources. If the pipeline has a single input and BRx is not used,
>  	 * configure it as the master layer. Otherwise configure all
> @@ -318,9 +317,24 @@ static void wpf_configure_stream(struct vsp1_entity *entity,
>  	vsp1_wpf_write(wpf, dlb, VI6_WPF_SRCRPF, srcrpf);
>  
>  	/* Enable interrupts. */
> -	vsp1_dl_body_write(dlb, VI6_WPF_IRQ_STA(wpf->entity.index), 0);
> -	vsp1_dl_body_write(dlb, VI6_WPF_IRQ_ENB(wpf->entity.index),
> +	vsp1_dl_body_write(dlb, VI6_WPF_IRQ_STA(index), 0);
> +	vsp1_dl_body_write(dlb, VI6_WPF_IRQ_ENB(index),
>  			   VI6_WFP_IRQ_ENB_DFEE);
> +
> +	/*
> +	 * Configure writeback for display pipelines. The wpf writeback flag is
> +	 * never set for memory-to-memory pipelines.
> +	 */
> +	vsp1_dl_body_write(dlb, VI6_DISP_IRQ_STA(index), 0);
> +	if (wpf->writeback) {

I feel like a comment here would be useful to make it clear that by
using _patch the VI6_DISP_IRQ_ENB_DSTE, and VI6_WPF_WRBCK_CTRL_WBMD will
be reset to 0 at the frame-end?

But maybe that's too verbose ... and won't be an issue once the function
documentation is updated for vsp1_dl_body_write_patch().


> +		vsp1_dl_body_write_patch(dlb, VI6_DISP_IRQ_ENB(index),
> +					 VI6_DISP_IRQ_ENB_DSTE, 0);
> +		vsp1_dl_body_write_patch(dlb, VI6_WPF_WRBCK_CTRL(index),
> +					 VI6_WPF_WRBCK_CTRL_WBMD, 0);
> +	} else {
> +		vsp1_dl_body_write(dlb, VI6_DISP_IRQ_ENB(index), 0);
> +		vsp1_dl_body_write(dlb, VI6_WPF_WRBCK_CTRL(index), 0);
> +	}
>  }
>  
>  static void wpf_configure_frame(struct vsp1_entity *entity,
> @@ -390,7 +404,11 @@ static void wpf_configure_partition(struct vsp1_entity *entity,
>  		       (0 << VI6_WPF_SZCLIP_OFST_SHIFT) |
>  		       (height << VI6_WPF_SZCLIP_SIZE_SHIFT));
>  
> -	if (pipe->lif)
> +	/*
> +	 * For display pipelines without writeback enabled there's no memory
> +	 * address to configure, return now.
> +	 */
> +	if (pipe->lif && !wpf->writeback)
>  		return;
>  
>  	/*
> @@ -479,6 +497,12 @@ static void wpf_configure_partition(struct vsp1_entity *entity,
>  	vsp1_wpf_write(wpf, dlb, VI6_WPF_DSTM_ADDR_Y, mem.addr[0]);
>  	vsp1_wpf_write(wpf, dlb, VI6_WPF_DSTM_ADDR_C0, mem.addr[1]);
>  	vsp1_wpf_write(wpf, dlb, VI6_WPF_DSTM_ADDR_C1, mem.addr[2]);
> +
> +	/*
> +	 * Writeback operates in single-shot mode and lasts for a single frame,
> +	 * reset the writeback flag to false for the next frame.
> +	 */
> +	wpf->writeback = false;


This differs from my implementation right? I think my version just ran
whenever there was a buffer available. (Except that when there was no
atomic_flush - there was a large amount of latency...)

I guess this comes down to the fact that we will not queue up frames
except unless there is a real frame-change caused by a fresh
atomic_flush ... and so the buffer rate does not reflect the display
refresh rate.

Now that I've written the above, I think that's made the reasoning
clearer for me so I've answered my own questions :)


>  }
>  
>  static unsigned int wpf_max_width(struct vsp1_entity *entity,
> @@ -529,6 +553,13 @@ struct vsp1_rwpf *vsp1_wpf_create(struct vsp1_device *vsp1, unsigned int index)
>  		wpf->max_height = WPF_GEN3_MAX_HEIGHT;
>  	}
>  
> +	/*
> +	 * On Gen3 WPFs with a LIF output can also write to memory for display

Hrm ... I might have said 'with an LIF'. ... but it depends whether you say:
   'with a liph'

or you spell it out:

   'with an ell-eye-eff

I personally spell out acronyms in my head, so that makes is 'an'.

It doesn't matter which really here though :-)


> +	 * writeback.
> +	 */
> +	if (vsp1->info->gen > 2 && index < vsp1->info->lif_count)
> +		wpf->has_writeback = true;
> +
>  	wpf->entity.ops = &wpf_entity_ops;
>  	wpf->entity.type = VSP1_ENTITY_WPF;
>  	wpf->entity.index = index;
> 

-- 
Regards
--
Kieran
