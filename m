Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:45780 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732590AbeHCMZJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 3 Aug 2018 08:25:09 -0400
Subject: Re: [PATCH v5 10/11] media: vsp1: Support Interlaced display
 pipelines
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
References: <cover.6efe8ff8efecd736e2aab039b2cf34d43e849939.1531857988.git-series.kieran.bingham+renesas@ideasonboard.com>
 <6d3afb327daf3941c84db9e16a4d7b3ba4faedf6.1531857988.git-series.kieran.bingham+renesas@ideasonboard.com>
 <3826962.GFlSaplMp3@avalon>
Reply-To: kieran.bingham+renesas@ideasonboard.com
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Message-ID: <fb5d8fca-52ee-a634-2d61-a75ca2293343@ideasonboard.com>
Date: Fri, 3 Aug 2018 11:29:21 +0100
MIME-Version: 1.0
In-Reply-To: <3826962.GFlSaplMp3@avalon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/08/18 23:44, Laurent Pinchart wrote:
> Hi Kieran,
> 
> Thank you for the patch.
> 
> On Tuesday, 17 July 2018 23:35:52 EEST Kieran Bingham wrote:
>> From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>>
>> Calculate the top and bottom fields for the interlaced frames and
>> utilise the extended display list command feature to implement the
>> auto-field operations. This allows the DU to update the VSP2 registers
>> dynamically based upon the currently processing field.
>>
>> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>>
>> ---
>>
>> v2:
>>  - fix erroneous BIT value which enabled interlaced
>>  - fix field handling at frame_end interrupt
>>
>> v3:
>>  - Pass DL through partition calls to allow autocmd's to be retrieved
>>  - Document interlaced field in struct vsp1_du_atomic_config
>>
>> v5:
>>  - Obtain autofld cmd in vsp1_rpf_configure_autofld()
>>  - Move VSP1_DL_EXT_AUTOFLD_INT to vsp1_regs.h
>>  - Rename VSP1_DL_EXT_AUTOFLD_INT -> VI6_DL_EXT_AUTOFLD_INT
>>  - move interlaced configuration parameter to pipe object
>>  - autofld: Set cmd->flags in one single expression.
>>
>>  drivers/media/platform/vsp1/vsp1_dl.c   | 10 ++++-
>>  drivers/media/platform/vsp1/vsp1_drm.c  | 16 +++++-
>>  drivers/media/platform/vsp1/vsp1_pipe.h |  2 +-
>>  drivers/media/platform/vsp1/vsp1_regs.h |  3 +-
>>  drivers/media/platform/vsp1/vsp1_rpf.c  | 72 ++++++++++++++++++++++++--
>>  include/media/vsp1.h                    |  2 +-
>>  6 files changed, 100 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/media/platform/vsp1/vsp1_dl.c
>> b/drivers/media/platform/vsp1/vsp1_dl.c index d5b3c24d160c..4963acac73f8
>> 100644
>> --- a/drivers/media/platform/vsp1/vsp1_dl.c
>> +++ b/drivers/media/platform/vsp1/vsp1_dl.c
>> @@ -946,6 +946,8 @@ void vsp1_dl_list_commit(struct vsp1_dl_list *dl, bool
>> internal) */
>>  unsigned int vsp1_dlm_irq_frame_end(struct vsp1_dl_manager *dlm)
>>  {
>> +	struct vsp1_device *vsp1 = dlm->vsp1;
>> +	u32 status = vsp1_read(vsp1, VI6_STATUS);
>>  	unsigned int flags = 0;
>>
>>  	spin_lock(&dlm->lock);
>> @@ -971,6 +973,14 @@ unsigned int vsp1_dlm_irq_frame_end(struct
>> vsp1_dl_manager *dlm) goto done;
>>
>>  	/*
>> +	 * Progressive streams report only TOP fields. If we have a BOTTOM
>> +	 * field, we are interlaced, and expect the frame to complete on the
>> +	 * next frame end interrupt.
>> +	 */
>> +	if (status & VI6_STATUS_FLD_STD(dlm->index))
>> +		goto done;
>> +
>> +	/*
>>  	 * The device starts processing the queued display list right after the
>>  	 * frame end interrupt. The display list thus becomes active.
>>  	 */
>> diff --git a/drivers/media/platform/vsp1/vsp1_drm.c
>> b/drivers/media/platform/vsp1/vsp1_drm.c index a16856856789..efdc9a676728
>> 100644
>> --- a/drivers/media/platform/vsp1/vsp1_drm.c
>> +++ b/drivers/media/platform/vsp1/vsp1_drm.c
>> @@ -671,8 +671,20 @@ int vsp1_du_setup_lif(struct device *dev, unsigned int
>> pipe_index, drm_pipe->width = cfg->width;
>>  	drm_pipe->height = cfg->height;
>>
>> -	dev_dbg(vsp1->dev, "%s: configuring LIF%u with format %ux%u\n",
>> -		__func__, pipe_index, cfg->width, cfg->height);
>> +	if (cfg->interlaced && !vsp1_feature(vsp1, VSP1_HAS_EXT_DL)) {
>> +		/*
>> +		 * Interlaced support requires extended display lists to
>> +		 * provide the auto-fld feature with the DU.
>> +		 */
>> +		dev_dbg(vsp1->dev, "Interlaced unsupported on this pipeline\n");
>> +		return -EINVAL;
>> +	}
> 
> As mentioned in the v4 review, this check should be moved to the DRM driver, 
> in the atomic check handler.

Ahh yes, this hunk was simply meant to be dropped.

Only VSPD and VSPDL entities are linked with the DU, and they all
support VSP_HAS_EXT_DL.

Any limitations from the DU side can simply be handled in the DU.

>> +
>> +	pipe->interlaced = cfg->interlaced;
>> +
>> +	dev_dbg(vsp1->dev, "%s: configuring LIF%u with format %ux%u%s\n",
>> +		__func__, pipe_index, cfg->width, cfg->height,
>> +		pipe->interlaced ? "i" : "");
>>
>>  	mutex_lock(&vsp1->drm->lock);
>>
>> diff --git a/drivers/media/platform/vsp1/vsp1_pipe.h
>> b/drivers/media/platform/vsp1/vsp1_pipe.h index 743d8f0db45c..ae646c9ef337
>> 100644
>> --- a/drivers/media/platform/vsp1/vsp1_pipe.h
>> +++ b/drivers/media/platform/vsp1/vsp1_pipe.h
>> @@ -104,6 +104,7 @@ struct vsp1_partition {
>>   * @entities: list of entities in the pipeline
>>   * @stream_config: cached stream configuration for video pipelines
>>   * @configured: when false the @stream_config shall be written to the
>> hardware + * @interlaced: True when the pipeline is configured in
>> interlaced mode * @partitions: The number of partitions used to process one
>> frame * @partition: The current partition for configuration to process *
>> @part_table: The pre-calculated partitions used by the pipeline @@ -142,6
>> +143,7 @@ struct vsp1_pipeline {
>>
>>  	struct vsp1_dl_body *stream_config;
>>  	bool configured;
>> +	bool interlaced;
>>
>>  	unsigned int partitions;
>>  	struct vsp1_partition *partition;
>> diff --git a/drivers/media/platform/vsp1/vsp1_regs.h
>> b/drivers/media/platform/vsp1/vsp1_regs.h index 5ea9f9070cf3..3738ff2f7b85
>> 100644
>> --- a/drivers/media/platform/vsp1/vsp1_regs.h
>> +++ b/drivers/media/platform/vsp1/vsp1_regs.h
>> @@ -28,6 +28,7 @@
>>  #define VI6_SRESET_SRTS(n)		(1 << (n))
>>
>>  #define VI6_STATUS			0x0038
>> +#define VI6_STATUS_FLD_STD(n)		(1 << ((n) + 28))
>>  #define VI6_STATUS_SYS_ACT(n)		(1 << ((n) + 8))
>>
>>  #define VI6_WPF_IRQ_ENB(n)		(0x0048 + (n) * 12)
>> @@ -80,6 +81,8 @@
>>  #define VI6_DL_EXT_CTRL_EXPRI		(1 << 4)
>>  #define VI6_DL_EXT_CTRL_EXT		(1 << 0)
>>
>> +#define VI6_DL_EXT_AUTOFLD_INT		BIT(0)
>> +
>>  #define VI6_DL_BODY_SIZE		0x0120
>>  #define VI6_DL_BODY_SIZE_UPD		(1 << 24)
>>  #define VI6_DL_BODY_SIZE_BS_MASK	(0x1ffff << 0)
>> diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c
>> b/drivers/media/platform/vsp1/vsp1_rpf.c index 69e5fe6e6b50..c728c193e09c
>> 100644
>> --- a/drivers/media/platform/vsp1/vsp1_rpf.c
>> +++ b/drivers/media/platform/vsp1/vsp1_rpf.c
>> @@ -20,6 +20,18 @@
>>  #define RPF_MAX_WIDTH				8190
>>  #define RPF_MAX_HEIGHT				8190
>>
>> +/* Pre extended display list command data structure. */
>> +struct vsp1_extcmd_auto_fld_body {
>> +	u32 top_y0;
>> +	u32 bottom_y0;
>> +	u32 top_c0;
>> +	u32 bottom_c0;
>> +	u32 top_c1;
>> +	u32 bottom_c1;
>> +	u32 reserved0;
>> +	u32 reserved1;
>> +};
>> +
>>  /*
>> ---------------------------------------------------------------------------
>> -- * Device Access
>>   */
>> @@ -64,6 +76,14 @@ static void rpf_configure_stream(struct vsp1_entity
>> *entity, pstride |= format->plane_fmt[1].bytesperline
>>  			<< VI6_RPF_SRCM_PSTRIDE_C_SHIFT;
>>
>> +	/*
>> +	 * pstride has both STRIDE_Y and STRIDE_C, but multiplying the whole
>> +	 * of pstride by 2 is conveniently OK here as we are multiplying both
>> +	 * values.
>> +	 */
>> +	if (pipe->interlaced)
>> +		pstride *= 2;
>> +
>>  	vsp1_rpf_write(rpf, dlb, VI6_RPF_SRCM_PSTRIDE, pstride);
>>
>>  	/* Format */
>> @@ -100,6 +120,9 @@ static void rpf_configure_stream(struct vsp1_entity
>> *entity, top = compose->top;
>>  	}
>>
>> +	if (pipe->interlaced)
>> +		top /= 2;
>> +
>>  	vsp1_rpf_write(rpf, dlb, VI6_RPF_LOC,
>>  		       (left << VI6_RPF_LOC_HCOORD_SHIFT) |
>>  		       (top << VI6_RPF_LOC_VCOORD_SHIFT));
>> @@ -169,6 +192,36 @@ static void rpf_configure_stream(struct vsp1_entity
>> *entity,
>>
>>  }
>>
>> +static void vsp1_rpf_configure_autofld(struct vsp1_rwpf *rpf,
>> +				       struct vsp1_dl_list *dl)
>> +{
>> +	const struct v4l2_pix_format_mplane *format = &rpf->format;
>> +	struct vsp1_dl_ext_cmd *cmd;
>> +	struct vsp1_extcmd_auto_fld_body *auto_fld;
>> +	u32 offset_y, offset_c;
>> +
>> +	cmd = vsp1_dl_get_pre_cmd(dl);
>> +	if (WARN_ONCE(!cmd, "Failed to obtain an autofld cmd"))
>> +		return;
>> +
>> +	/* Re-index our auto_fld to match the current RPF. */
>> +	auto_fld = cmd->data;
>> +	auto_fld = &auto_fld[rpf->entity.index];
>> +
>> +	auto_fld->top_y0 = rpf->mem.addr[0];
>> +	auto_fld->top_c0 = rpf->mem.addr[1];
>> +	auto_fld->top_c1 = rpf->mem.addr[2];
>> +
>> +	offset_y = format->plane_fmt[0].bytesperline;
>> +	offset_c = format->plane_fmt[1].bytesperline;
>> +
>> +	auto_fld->bottom_y0 = rpf->mem.addr[0] + offset_y;
>> +	auto_fld->bottom_c0 = rpf->mem.addr[1] + offset_c;
>> +	auto_fld->bottom_c1 = rpf->mem.addr[2] + offset_c;
>> +
>> +	cmd->flags |= VI6_DL_EXT_AUTOFLD_INT | BIT(16 + rpf->entity.index);
>> +}
>> +
>>  static void rpf_configure_frame(struct vsp1_entity *entity,
>>  				struct vsp1_pipeline *pipe,
>>  				struct vsp1_dl_list *dl,
>> @@ -221,6 +274,11 @@ static void rpf_configure_partition(struct vsp1_entity
>> *entity, crop.left += pipe->partition->rpf.left;
>>  	}
>>
>> +	if (pipe->interlaced) {
>> +		crop.height = round_down(crop.height / 2, fmtinfo->vsub);
>> +		crop.top = round_down(crop.top / 2, fmtinfo->vsub);
>> +	}
>> +
>>  	vsp1_rpf_write(rpf, dlb, VI6_RPF_SRC_BSIZE,
>>  		       (crop.width << VI6_RPF_SRC_BSIZE_BHSIZE_SHIFT) |
>>  		       (crop.height << VI6_RPF_SRC_BSIZE_BVSIZE_SHIFT));
>> @@ -249,9 +307,17 @@ static void rpf_configure_partition(struct vsp1_entity
>> *entity, fmtinfo->swap_uv)
>>  		swap(mem.addr[1], mem.addr[2]);
>>
>> -	vsp1_rpf_write(rpf, dlb, VI6_RPF_SRCM_ADDR_Y, mem.addr[0]);
>> -	vsp1_rpf_write(rpf, dlb, VI6_RPF_SRCM_ADDR_C0, mem.addr[1]);
>> -	vsp1_rpf_write(rpf, dlb, VI6_RPF_SRCM_ADDR_C1, mem.addr[2]);
>> +	/*
>> +	 * Interlaced pipelines will use the extended pre-cmd to process
>> +	 * SRCM_ADDR_{Y,C0,C1}
>> +	 */
>> +	if (pipe->interlaced) {
>> +		vsp1_rpf_configure_autofld(rpf, dl);
>> +	} else {
>> +		vsp1_rpf_write(rpf, dlb, VI6_RPF_SRCM_ADDR_Y, mem.addr[0]);
>> +		vsp1_rpf_write(rpf, dlb, VI6_RPF_SRCM_ADDR_C0, mem.addr[1]);
>> +		vsp1_rpf_write(rpf, dlb, VI6_RPF_SRCM_ADDR_C1, mem.addr[2]);
>> +	}
>>  }
>>
>>  static void rpf_partition(struct vsp1_entity *entity,
>> diff --git a/include/media/vsp1.h b/include/media/vsp1.h
>> index 678c24de1ac6..3093b9cb9067 100644
>> --- a/include/media/vsp1.h
>> +++ b/include/media/vsp1.h
>> @@ -25,6 +25,7 @@ int vsp1_du_init(struct device *dev);
>>   * struct vsp1_du_lif_config - VSP LIF configuration
>>   * @width: output frame width
>>   * @height: output frame height
>> + * @interlaced: true for interlaced pipelines
>>   * @callback: frame completion callback function (optional). When a
>> callback *	      is provided, the VSP driver guarantees that it will be
>> called once *	      and only once for each vsp1_du_atomic_flush() call.
>> @@ -33,6 +34,7 @@ int vsp1_du_init(struct device *dev);
>>  struct vsp1_du_lif_config {
>>  	unsigned int width;
>>  	unsigned int height;
>> +	bool interlaced;
>>
>>  	void (*callback)(void *data, bool completed, u32 crc);
>>  	void *callback_data;
> 
