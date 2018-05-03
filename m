Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:59684 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750849AbeECJEf (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 3 May 2018 05:04:35 -0400
Reply-To: kieran.bingham@ideasonboard.com
Subject: Re: [PATCH v3 10/11] media: vsp1: Support Interlaced display
 pipelines
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
References: <cover.a15c17beeb074afaf226d19ff3c4fdba2f647500.1525336865.git-series.kieran.bingham+renesas@ideasonboard.com>
 <bad0151f22d3d7dabe2424c9410bfae1c679bfd4.1525336865.git-series.kieran.bingham+renesas@ideasonboard.com>
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Message-ID: <42ad373a-6beb-5821-6334-1feffd816dd8@ideasonboard.com>
Date: Thu, 3 May 2018 10:04:30 +0100
MIME-Version: 1.0
In-Reply-To: <bad0151f22d3d7dabe2424c9410bfae1c679bfd4.1525336865.git-series.kieran.bingham+renesas@ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Reviewers ...

Comments inline ...

On 03/05/18 09:44, Kieran Bingham wrote:
> Calculate the top and bottom fields for the interlaced frames and
> utilise the extended display list command feature to implement the
> auto-field operations. This allows the DU to update the VSP2 registers
> dynamically based upon the currently processing field.
> 
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> 
> ---
> v3:
>  - Pass DL through partition calls to allow autocmd's to be retrieved

This change itself could actually be folded into the TLB-Optimise series, but I
posted this in v3 here to show why it is necessary (currently).

I'll take suggestions on alternative implementations here too ...


>  - Document interlaced field in struct vsp1_du_atomic_config
> 
> v2:
>  - fix erroneous BIT value which enabled interlaced
>  - fix field handling at frame_end interrupt
> 
>  drivers/media/platform/vsp1/vsp1_dl.c     | 10 +++-
>  drivers/media/platform/vsp1/vsp1_drm.c    | 13 +++-
>  drivers/media/platform/vsp1/vsp1_entity.c |  3 +-
>  drivers/media/platform/vsp1/vsp1_entity.h |  2 +-
>  drivers/media/platform/vsp1/vsp1_regs.h   |  1 +-
>  drivers/media/platform/vsp1/vsp1_rpf.c    | 73 +++++++++++++++++++++++-
>  drivers/media/platform/vsp1/vsp1_rwpf.h   |  1 +-
>  drivers/media/platform/vsp1/vsp1_uds.c    |  1 +-
>  drivers/media/platform/vsp1/vsp1_video.c  |  2 +-
>  drivers/media/platform/vsp1/vsp1_wpf.c    |  1 +-
>  include/media/vsp1.h                      |  2 +-
>  11 files changed, 103 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_dl.c b/drivers/media/platform/vsp1/vsp1_dl.c
> index 6366a1fc92b9..f3e75cff5ab3 100644
> --- a/drivers/media/platform/vsp1/vsp1_dl.c
> +++ b/drivers/media/platform/vsp1/vsp1_dl.c
> @@ -906,6 +906,8 @@ void vsp1_dl_list_commit(struct vsp1_dl_list *dl, bool internal)
>   */
>  unsigned int vsp1_dlm_irq_frame_end(struct vsp1_dl_manager *dlm)
>  {
> +	struct vsp1_device *vsp1 = dlm->vsp1;
> +	u32 status = vsp1_read(vsp1, VI6_STATUS);
>  	unsigned int flags = 0;
>  
>  	spin_lock(&dlm->lock);
> @@ -931,6 +933,14 @@ unsigned int vsp1_dlm_irq_frame_end(struct vsp1_dl_manager *dlm)
>  		goto done;
>  
>  	/*
> +	 * Progressive streams report only TOP fields. If we have a BOTTOM
> +	 * field, we are interlaced, and expect the frame to complete on the
> +	 * next frame end interrupt.
> +	 */
> +	if (status & VI6_STATUS_FLD_STD(dlm->index))
> +		goto done;
> +
> +	/*
>  	 * The device starts processing the queued display list right after the
>  	 * frame end interrupt. The display list thus becomes active.
>  	 */
> diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
> index 7714be7f50af..cc29c9d96bb7 100644
> --- a/drivers/media/platform/vsp1/vsp1_drm.c
> +++ b/drivers/media/platform/vsp1/vsp1_drm.c
> @@ -556,7 +556,7 @@ static void vsp1_du_pipeline_configure(struct vsp1_pipeline *pipe)
>  		vsp1_entity_route_setup(entity, pipe, dlb);
>  		vsp1_entity_configure_stream(entity, pipe, dlb);
>  		vsp1_entity_configure_frame(entity, pipe, dl, dlb);
> -		vsp1_entity_configure_partition(entity, pipe, dlb);
> +		vsp1_entity_configure_partition(entity, pipe, dl, dlb);

This change, and other changes to vsp1_entity_configure_partition() could be
performed in tlb-optimise when the corresponding change is made to
vsp1_entity_configure_frame()

>  	}
>  
>  	vsp1_dl_list_commit(dl, drm_pipe->force_brx_release);
> @@ -811,6 +811,17 @@ int vsp1_du_atomic_update(struct device *dev, unsigned int pipe_index,
>  		return -EINVAL;
>  	}
>  
> +	if (!(vsp1_feature(vsp1, VSP1_HAS_EXT_DL)) && cfg->interlaced) {
> +		/*
> +		 * Interlaced support requires extended display lists to
> +		 * provide the auto-fld feature with the DU.
> +		 */
> +		dev_dbg(vsp1->dev, "Interlaced unsupported on this output\n");
> +		return -EINVAL;
> +	}
> +
> +	rpf->interlaced = cfg->interlaced;
> +
>  	rpf->fmtinfo = fmtinfo;
>  	rpf->format.num_planes = fmtinfo->planes;
>  	rpf->format.plane_fmt[0].bytesperline = cfg->pitch;
> diff --git a/drivers/media/platform/vsp1/vsp1_entity.c b/drivers/media/platform/vsp1/vsp1_entity.c
> index 7b29ef3532fc..da276a85aa95 100644
> --- a/drivers/media/platform/vsp1/vsp1_entity.c
> +++ b/drivers/media/platform/vsp1/vsp1_entity.c
> @@ -88,10 +88,11 @@ void vsp1_entity_configure_frame(struct vsp1_entity *entity,
>  
>  void vsp1_entity_configure_partition(struct vsp1_entity *entity,
>  				     struct vsp1_pipeline *pipe,
> +				     struct vsp1_dl_list *dl,

Same here

>  				     struct vsp1_dl_body *dlb)
>  {
>  	if (entity->ops->configure_partition)
> -		entity->ops->configure_partition(entity, pipe, dlb);
> +		entity->ops->configure_partition(entity, pipe, dl, dlb);
>  }
>  
>  /* -----------------------------------------------------------------------------
> diff --git a/drivers/media/platform/vsp1/vsp1_entity.h b/drivers/media/platform/vsp1/vsp1_entity.h
> index f329c69731d1..97acb7795cf1 100644
> --- a/drivers/media/platform/vsp1/vsp1_entity.h
> +++ b/drivers/media/platform/vsp1/vsp1_entity.h
> @@ -83,6 +83,7 @@ struct vsp1_entity_operations {
>  				struct vsp1_dl_list *, struct vsp1_dl_body *);
>  	void (*configure_partition)(struct vsp1_entity *,
>  				    struct vsp1_pipeline *,
> +				    struct vsp1_dl_list *,

Same here

>  				    struct vsp1_dl_body *);
>  	unsigned int (*max_width)(struct vsp1_entity *, struct vsp1_pipeline *);
>  	void (*partition)(struct vsp1_entity *, struct vsp1_pipeline *,
> @@ -163,6 +164,7 @@ void vsp1_entity_configure_frame(struct vsp1_entity *entity,
>  
>  void vsp1_entity_configure_partition(struct vsp1_entity *entity,
>  				     struct vsp1_pipeline *pipe,
> +				     struct vsp1_dl_list *dl,

Same here

>  				     struct vsp1_dl_body *dlb);
>  
>  struct media_pad *vsp1_entity_remote_pad(struct media_pad *pad);
> diff --git a/drivers/media/platform/vsp1/vsp1_regs.h b/drivers/media/platform/vsp1/vsp1_regs.h
> index d054767570c1..a2ac65cc5155 100644
> --- a/drivers/media/platform/vsp1/vsp1_regs.h
> +++ b/drivers/media/platform/vsp1/vsp1_regs.h
> @@ -28,6 +28,7 @@
>  #define VI6_SRESET_SRTS(n)		(1 << (n))
>  
>  #define VI6_STATUS			0x0038
> +#define VI6_STATUS_FLD_STD(n)		(1 << ((n) + 28))
>  #define VI6_STATUS_SYS_ACT(n)		(1 << ((n) + 8))
>  
>  #define VI6_WPF_IRQ_ENB(n)		(0x0048 + (n) * 12)
> diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c b/drivers/media/platform/vsp1/vsp1_rpf.c
> index a948670121a4..c1de22398423 100644
> --- a/drivers/media/platform/vsp1/vsp1_rpf.c
> +++ b/drivers/media/platform/vsp1/vsp1_rpf.c
> @@ -20,6 +20,20 @@
>  #define RPF_MAX_WIDTH				8190
>  #define RPF_MAX_HEIGHT				8190
>  
> +/* Pre extended display list command data structure */
> +struct vsp1_extcmd_auto_fld_body {
> +	u32 top_y0;
> +	u32 bottom_y0;
> +	u32 top_c0;
> +	u32 bottom_c0;
> +	u32 top_c1;
> +	u32 bottom_c1;
> +	u32 reserved0;
> +	u32 reserved1;
> +} __packed;
> +
> +#define VSP1_DL_EXT_AUTOFLD_INT		BIT(0)
> +
>  /* -----------------------------------------------------------------------------
>   * Device Access
>   */
> @@ -64,6 +78,14 @@ static void rpf_configure_stream(struct vsp1_entity *entity,
>  		pstride |= format->plane_fmt[1].bytesperline
>  			<< VI6_RPF_SRCM_PSTRIDE_C_SHIFT;
>  
> +	/*
> +	 * pstride has both STRIDE_Y and STRIDE_C, but multiplying the whole
> +	 * of pstride by 2 is conveniently OK here as we are multiplying both
> +	 * values.
> +	 */
> +	if (rpf->interlaced)
> +		pstride *= 2;
> +
>  	vsp1_rpf_write(rpf, dlb, VI6_RPF_SRCM_PSTRIDE, pstride);
>  
>  	/* Format */
> @@ -100,6 +122,9 @@ static void rpf_configure_stream(struct vsp1_entity *entity,
>  		top = compose->top;
>  	}
>  
> +	if (rpf->interlaced)
> +		top /= 2;
> +
>  	vsp1_rpf_write(rpf, dlb, VI6_RPF_LOC,
>  		       (left << VI6_RPF_LOC_HCOORD_SHIFT) |
>  		       (top << VI6_RPF_LOC_VCOORD_SHIFT));
> @@ -169,6 +194,31 @@ static void rpf_configure_stream(struct vsp1_entity *entity,
>  
>  }
>  
> +static void vsp1_rpf_configure_autofld(struct vsp1_rwpf *rpf,
> +				       struct vsp1_dl_ext_cmd *cmd)
> +{
> +	const struct v4l2_pix_format_mplane *format = &rpf->format;
> +	struct vsp1_extcmd_auto_fld_body *auto_fld = cmd->data;
> +	u32 offset_y, offset_c;
> +
> +	/* Re-index our auto_fld to match the current RPF */
> +	auto_fld = &auto_fld[rpf->entity.index];
> +
> +	auto_fld->top_y0 = rpf->mem.addr[0];
> +	auto_fld->top_c0 = rpf->mem.addr[1];
> +	auto_fld->top_c1 = rpf->mem.addr[2];
> +
> +	offset_y = format->plane_fmt[0].bytesperline;
> +	offset_c = format->plane_fmt[1].bytesperline;
> +
> +	auto_fld->bottom_y0 = rpf->mem.addr[0] + offset_y;
> +	auto_fld->bottom_c0 = rpf->mem.addr[1] + offset_c;
> +	auto_fld->bottom_c1 = rpf->mem.addr[2] + offset_c;
> +
> +	cmd->flags |= VSP1_DL_EXT_AUTOFLD_INT;
> +	cmd->flags |= BIT(16 + rpf->entity.index);
> +}
> +
>  static void rpf_configure_frame(struct vsp1_entity *entity,
>  				struct vsp1_pipeline *pipe,
>  				struct vsp1_dl_list *dl,
> @@ -186,11 +236,13 @@ static void rpf_configure_frame(struct vsp1_entity *entity,
>  
>  static void rpf_configure_partition(struct vsp1_entity *entity,
>  				    struct vsp1_pipeline *pipe,
> +				    struct vsp1_dl_list *dl,
>  				    struct vsp1_dl_body *dlb)
>  {
>  	struct vsp1_rwpf *rpf = to_rwpf(&entity->subdev);
>  	struct vsp1_rwpf_memory mem = rpf->mem;
>  	struct vsp1_device *vsp1 = rpf->entity.vsp1;
> +	struct vsp1_dl_ext_cmd *cmd;
>  	const struct vsp1_format_info *fmtinfo = rpf->fmtinfo;
>  	const struct v4l2_pix_format_mplane *format = &rpf->format;
>  	struct v4l2_rect crop;
> @@ -219,6 +271,11 @@ static void rpf_configure_partition(struct vsp1_entity *entity,
>  		crop.left += pipe->partition->rpf.left;
>  	}
>  
> +	if (rpf->interlaced) {
> +		crop.height = round_down(crop.height / 2, fmtinfo->vsub);
> +		crop.top = round_down(crop.top / 2, fmtinfo->vsub);
> +	}
> +
>  	vsp1_rpf_write(rpf, dlb, VI6_RPF_SRC_BSIZE,
>  		       (crop.width << VI6_RPF_SRC_BSIZE_BHSIZE_SHIFT) |
>  		       (crop.height << VI6_RPF_SRC_BSIZE_BVSIZE_SHIFT));
> @@ -247,11 +304,21 @@ static void rpf_configure_partition(struct vsp1_entity *entity,
>  	    fmtinfo->swap_uv)
>  		swap(mem.addr[1], mem.addr[2]);
>  
> -	vsp1_rpf_write(rpf, dlb, VI6_RPF_SRCM_ADDR_Y, mem.addr[0]);
> -	vsp1_rpf_write(rpf, dlb, VI6_RPF_SRCM_ADDR_C0, mem.addr[1]);
> -	vsp1_rpf_write(rpf, dlb, VI6_RPF_SRCM_ADDR_C1, mem.addr[2]);
> +	/*
> +	 * Interlaced pipelines will use the extended pre-cmd to process
> +	 * SRCM_ADDR_{Y,C0,C1}
> +	 */
> +	if (rpf->interlaced) {
> +		cmd = vsp1_dlm_get_autofld_cmd(dl);
> +		vsp1_rpf_configure_autofld(rpf, cmd);

Technically - if (rpf->interlaced) can only evaluate to true on DRM pipelines,
which don't use the image partitioning. So it might be possible to argue that
the vsp1_rpf_configure_autofld() call should be done in rpf_configure_frame().
Except I think it's reasonable to consider that the addresses and configuration
of the frame are still just the 'first and only partition' - thus I think it's
better to leave this here - and instead ensure that the requried DL is passed
through.

Unless there's a better way to get the cmd object ?



> +	} else {
> +		vsp1_rpf_write(rpf, dlb, VI6_RPF_SRCM_ADDR_Y, mem.addr[0]);
> +		vsp1_rpf_write(rpf, dlb, VI6_RPF_SRCM_ADDR_C0, mem.addr[1]);
> +		vsp1_rpf_write(rpf, dlb, VI6_RPF_SRCM_ADDR_C1, mem.addr[2]);
> +	}
>  }
>  
> +
>  static void rpf_partition(struct vsp1_entity *entity,
>  			  struct vsp1_pipeline *pipe,
>  			  struct vsp1_partition *partition,
> diff --git a/drivers/media/platform/vsp1/vsp1_rwpf.h b/drivers/media/platform/vsp1/vsp1_rwpf.h
> index 70742ecf766f..8d6e42f27908 100644
> --- a/drivers/media/platform/vsp1/vsp1_rwpf.h
> +++ b/drivers/media/platform/vsp1/vsp1_rwpf.h
> @@ -42,6 +42,7 @@ struct vsp1_rwpf {
>  	struct v4l2_pix_format_mplane format;
>  	const struct vsp1_format_info *fmtinfo;
>  	unsigned int brx_input;
> +	bool interlaced;
>  
>  	unsigned int alpha;
>  
> diff --git a/drivers/media/platform/vsp1/vsp1_uds.c b/drivers/media/platform/vsp1/vsp1_uds.c
> index 35f99844c19c..c20c84b54936 100644
> --- a/drivers/media/platform/vsp1/vsp1_uds.c
> +++ b/drivers/media/platform/vsp1/vsp1_uds.c
> @@ -304,6 +304,7 @@ static void uds_configure_stream(struct vsp1_entity *entity,
>  
>  static void uds_configure_partition(struct vsp1_entity *entity,
>  				    struct vsp1_pipeline *pipe,
> +				    struct vsp1_dl_list *dl,
>  				    struct vsp1_dl_body *dlb)
>  {
>  	struct vsp1_uds *uds = to_uds(&entity->subdev);
> diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
> index 2cbcc20fe980..b2109225cb2d 100644
> --- a/drivers/media/platform/vsp1/vsp1_video.c
> +++ b/drivers/media/platform/vsp1/vsp1_video.c
> @@ -384,7 +384,7 @@ static void vsp1_video_pipeline_run_partition(struct vsp1_pipeline *pipe,
>  	pipe->partition = &pipe->part_table[partition];
>  
>  	list_for_each_entry(entity, &pipe->entities, list_pipe)
> -		vsp1_entity_configure_partition(entity, pipe, dlb);
> +		vsp1_entity_configure_partition(entity, pipe, dl, dlb);
>  }
>  
>  static void vsp1_video_pipeline_run(struct vsp1_pipeline *pipe)
> diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
> index b61d05aaadf2..ea1d226371b2 100644
> --- a/drivers/media/platform/vsp1/vsp1_wpf.c
> +++ b/drivers/media/platform/vsp1/vsp1_wpf.c
> @@ -352,6 +352,7 @@ static void wpf_configure_frame(struct vsp1_entity *entity,
>  
>  static void wpf_configure_partition(struct vsp1_entity *entity,
>  				    struct vsp1_pipeline *pipe,
> +				    struct vsp1_dl_list *dl,
>  				    struct vsp1_dl_body *dlb)
>  {
>  	struct vsp1_rwpf *wpf = to_rwpf(&entity->subdev);
> diff --git a/include/media/vsp1.h b/include/media/vsp1.h
> index 678c24de1ac6..c10883f30980 100644
> --- a/include/media/vsp1.h
> +++ b/include/media/vsp1.h
> @@ -50,6 +50,7 @@ int vsp1_du_setup_lif(struct device *dev, unsigned int pipe_index,
>   * @dst: destination rectangle on the display (integer coordinates)
>   * @alpha: alpha value (0: fully transparent, 255: fully opaque)
>   * @zpos: Z position of the plane (from 0 to number of planes minus 1)
> + * @interlaced: true for interlaced pipelines
>   */
>  struct vsp1_du_atomic_config {
>  	u32 pixelformat;
> @@ -59,6 +60,7 @@ struct vsp1_du_atomic_config {
>  	struct v4l2_rect dst;
>  	unsigned int alpha;
>  	unsigned int zpos;
> +	bool interlaced;
>  };
>  
>  /**
> 
