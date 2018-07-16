Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:43556 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727479AbeGPStn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Jul 2018 14:49:43 -0400
Reply-To: kieran.bingham+renesas@ideasonboard.com
Subject: Re: [PATCH v4 10/11] media: vsp1: Support Interlaced display
 pipelines
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org
References: <cover.bd2eb66d11f8094114941107dbc78dc02c9c7fdd.1525354194.git-series.kieran.bingham+renesas@ideasonboard.com>
 <8e320ac8861b7fdd657a66138780c18fd66b1a19.1525354194.git-series.kieran.bingham+renesas@ideasonboard.com>
 <2663986.uvcnutGSNp@avalon>
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Message-ID: <f794f4d6-f524-293b-3df6-097f42bef372@ideasonboard.com>
Date: Mon, 16 Jul 2018 19:21:00 +0100
MIME-Version: 1.0
In-Reply-To: <2663986.uvcnutGSNp@avalon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Some questions here too :)

On 24/05/18 13:51, Laurent Pinchart wrote:
> Hi Kieran,
> 
> Thank you for the patch.
> 
> On Thursday, 3 May 2018 16:36:21 EEST Kieran Bingham wrote:
>> Calculate the top and bottom fields for the interlaced frames and
>> utilise the extended display list command feature to implement the
>> auto-field operations. This allows the DU to update the VSP2 registers
>> dynamically based upon the currently processing field.
>>
>> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>>
>> ---
>> v3:
>>  - Pass DL through partition calls to allow autocmd's to be retrieved
>>  - Document interlaced field in struct vsp1_du_atomic_config
>>
>> v2:
>>  - fix erroneous BIT value which enabled interlaced
>>  - fix field handling at frame_end interrupt
>> ---
>>  drivers/media/platform/vsp1/vsp1_dl.c   | 10 ++++-
>>  drivers/media/platform/vsp1/vsp1_drm.c  | 11 ++++-
>>  drivers/media/platform/vsp1/vsp1_regs.h |  1 +-
>>  drivers/media/platform/vsp1/vsp1_rpf.c  | 71 ++++++++++++++++++++++++--
>>  drivers/media/platform/vsp1/vsp1_rwpf.h |  1 +-
>>  include/media/vsp1.h                    |  2 +-
>>  6 files changed, 93 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/media/platform/vsp1/vsp1_dl.c
>> b/drivers/media/platform/vsp1/vsp1_dl.c index d33ae5f125bd..bbe9f3006f71
>> 100644
>> --- a/drivers/media/platform/vsp1/vsp1_dl.c
>> +++ b/drivers/media/platform/vsp1/vsp1_dl.c
>> @@ -906,6 +906,8 @@ void vsp1_dl_list_commit(struct vsp1_dl_list *dl, bool
>> internal) */
>>  unsigned int vsp1_dlm_irq_frame_end(struct vsp1_dl_manager *dlm)
>>  {
>> +	struct vsp1_device *vsp1 = dlm->vsp1;
>> +	u32 status = vsp1_read(vsp1, VI6_STATUS);
>>  	unsigned int flags = 0;
>>
>>  	spin_lock(&dlm->lock);
>> @@ -931,6 +933,14 @@ unsigned int vsp1_dlm_irq_frame_end(struct
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
>> b/drivers/media/platform/vsp1/vsp1_drm.c index 2c3db8b8adce..cc29c9d96bb7
>> 100644
>> --- a/drivers/media/platform/vsp1/vsp1_drm.c
>> +++ b/drivers/media/platform/vsp1/vsp1_drm.c
>> @@ -811,6 +811,17 @@ int vsp1_du_atomic_update(struct device *dev, unsigned
>> int pipe_index, return -EINVAL;
>>  	}
>>
>> +	if (!(vsp1_feature(vsp1, VSP1_HAS_EXT_DL)) && cfg->interlaced) {
> 
> Nitpicking, writing the condition as
> 
> 	if (cfg->interlaced && !(vsp1_feature(vsp1, VSP1_HAS_EXT_DL)))

Done.

> 
> would match the comment better. You can also drop the parentheses around the 
> vsp1_feature() call.
> 
>> +		/*
>> +		 * Interlaced support requires extended display lists to
>> +		 * provide the auto-fld feature with the DU.
>> +		 */
>> +		dev_dbg(vsp1->dev, "Interlaced unsupported on this output\n");
> 
> Could we catch this in the DU driver to fail atomic test ?

Ugh - I thought moving the configuration to vsp1_du_setup_lif() would
give us this, but that return value is not checked in the DU.

How can we interogate the VSP1 to ask it if it supports interlaced from
rcar_du_vsp_plane_atomic_check()?


Some dummy call to vsp1_du_setup_lif() to check the return value ? Or
should we implement a hook to call through to perform checks in the VSP1
DRM API?




> 
>> +		return -EINVAL;
>> +	}
>> +
>> +	rpf->interlaced = cfg->interlaced;
>> +
>>  	rpf->fmtinfo = fmtinfo;
>>  	rpf->format.num_planes = fmtinfo->planes;
>>  	rpf->format.plane_fmt[0].bytesperline = cfg->pitch;
>> diff --git a/drivers/media/platform/vsp1/vsp1_regs.h
>> b/drivers/media/platform/vsp1/vsp1_regs.h index d054767570c1..a2ac65cc5155
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
>> diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c
>> b/drivers/media/platform/vsp1/vsp1_rpf.c index 8fae7c485642..511b2e127820
>> 100644
>> --- a/drivers/media/platform/vsp1/vsp1_rpf.c
>> +++ b/drivers/media/platform/vsp1/vsp1_rpf.c
>> @@ -20,6 +20,20 @@
>>  #define RPF_MAX_WIDTH				8190
>>  #define RPF_MAX_HEIGHT				8190
>>
>> +/* Pre extended display list command data structure */
>> +struct vsp1_extcmd_auto_fld_body {
>> +	u32 top_y0;
>> +	u32 bottom_y0;
>> +	u32 top_c0;
>> +	u32 bottom_c0;
>> +	u32 top_c1;
>> +	u32 bottom_c1;
>> +	u32 reserved0;
>> +	u32 reserved1;
>> +} __packed;
>> +
>> +#define VSP1_DL_EXT_AUTOFLD_INT		BIT(0)
> 
> Should the bit definition be moved to vsp1_regs.h ?

Moved, (and renamed s/VSP1_/VI6_/)

> 
>>  /* ------------------------------------------------------------------------
>>   * Device Access
>>   */
>> @@ -64,6 +78,14 @@ static void rpf_configure_stream(struct vsp1_entity
>> *entity, pstride |= format->plane_fmt[1].bytesperline
>>  			<< VI6_RPF_SRCM_PSTRIDE_C_SHIFT;
>>
>> +	/*
>> +	 * pstride has both STRIDE_Y and STRIDE_C, but multiplying the whole
>> +	 * of pstride by 2 is conveniently OK here as we are multiplying both
>> +	 * values.
>> +	 */
>> +	if (rpf->interlaced)
>> +		pstride *= 2;
>> +
>>  	vsp1_rpf_write(rpf, dlb, VI6_RPF_SRCM_PSTRIDE, pstride);
>>
>>  	/* Format */
>> @@ -100,6 +122,9 @@ static void rpf_configure_stream(struct vsp1_entity
>> *entity, top = compose->top;
>>  	}
>>
>> +	if (rpf->interlaced)
>> +		top /= 2;
>> +
>>  	vsp1_rpf_write(rpf, dlb, VI6_RPF_LOC,
>>  		       (left << VI6_RPF_LOC_HCOORD_SHIFT) |
>>  		       (top << VI6_RPF_LOC_VCOORD_SHIFT));
>> @@ -169,6 +194,31 @@ static void rpf_configure_stream(struct vsp1_entity
>> *entity,
>>
>>  }
>>
>> +static void vsp1_rpf_configure_autofld(struct vsp1_rwpf *rpf,
>> +				       struct vsp1_dl_ext_cmd *cmd)
>> +{
>> +	const struct v4l2_pix_format_mplane *format = &rpf->format;
>> +	struct vsp1_extcmd_auto_fld_body *auto_fld = cmd->data;
>> +	u32 offset_y, offset_c;
>> +
>> +	/* Re-index our auto_fld to match the current RPF */
> 
> s/RPF/RPF./

Fixed.

> 
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
>> +	cmd->flags |= VSP1_DL_EXT_AUTOFLD_INT;
>> +	cmd->flags |= BIT(16 + rpf->entity.index);
> 
> Do you expect some flags to already be set ? If not, couldn't we assign the 
> value to the field instead of OR'ing it ?
No, I think you are correct. Moved to a single expression setting the
cmd->flags in one line.


> 
>> +}
>> +
>>  static void rpf_configure_frame(struct vsp1_entity *entity,
>>  				struct vsp1_pipeline *pipe,
>>  				struct vsp1_dl_list *dl,
>> @@ -192,6 +242,7 @@ static void rpf_configure_partition(struct vsp1_entity
>> *entity, struct vsp1_rwpf *rpf = to_rwpf(&entity->subdev);
>>  	struct vsp1_rwpf_memory mem = rpf->mem;
>>  	struct vsp1_device *vsp1 = rpf->entity.vsp1;
>> +	struct vsp1_dl_ext_cmd *cmd;
>>  	const struct vsp1_format_info *fmtinfo = rpf->fmtinfo;
>>  	const struct v4l2_pix_format_mplane *format = &rpf->format;
>>  	struct v4l2_rect crop;
>> @@ -220,6 +271,11 @@ static void rpf_configure_partition(struct vsp1_entity
>> *entity, crop.left += pipe->partition->rpf.left;
>>  	}
>>
>> +	if (rpf->interlaced) {
>> +		crop.height = round_down(crop.height / 2, fmtinfo->vsub);
>> +		crop.top = round_down(crop.top / 2, fmtinfo->vsub);
>> +	}
>> +
>>  	vsp1_rpf_write(rpf, dlb, VI6_RPF_SRC_BSIZE,
>>  		       (crop.width << VI6_RPF_SRC_BSIZE_BHSIZE_SHIFT) |
>>  		       (crop.height << VI6_RPF_SRC_BSIZE_BVSIZE_SHIFT));
>> @@ -248,9 +304,18 @@ static void rpf_configure_partition(struct vsp1_entity
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
>> +	if (rpf->interlaced) {
>> +		cmd = vsp1_dlm_get_autofld_cmd(dl);
> 
> How about moving this call to vsp1_rpf_configure_autofld() ?

Done.

> 
>> +		vsp1_rpf_configure_autofld(rpf, cmd);
>> +	} else {
>> +		vsp1_rpf_write(rpf, dlb, VI6_RPF_SRCM_ADDR_Y, mem.addr[0]);
>> +		vsp1_rpf_write(rpf, dlb, VI6_RPF_SRCM_ADDR_C0, mem.addr[1]);
>> +		vsp1_rpf_write(rpf, dlb, VI6_RPF_SRCM_ADDR_C1, mem.addr[2]);
>> +	}
>>  }
>>
>>  static void rpf_partition(struct vsp1_entity *entity,
>> diff --git a/drivers/media/platform/vsp1/vsp1_rwpf.h
>> b/drivers/media/platform/vsp1/vsp1_rwpf.h index 70742ecf766f..8d6e42f27908
>> 100644
>> --- a/drivers/media/platform/vsp1/vsp1_rwpf.h
>> +++ b/drivers/media/platform/vsp1/vsp1_rwpf.h
>> @@ -42,6 +42,7 @@ struct vsp1_rwpf {
>>  	struct v4l2_pix_format_mplane format;
>>  	const struct vsp1_format_info *fmtinfo;
>>  	unsigned int brx_input;
>> +	bool interlaced;
> 
> Shouldn't this be stored in the pipeline instead ? Interlacing is a property 
> of the whole pipeline, not of each input individually.
> 

Moved.

>>  	unsigned int alpha;
>>
>> diff --git a/include/media/vsp1.h b/include/media/vsp1.h
>> index 678c24de1ac6..c10883f30980 100644
>> --- a/include/media/vsp1.h
>> +++ b/include/media/vsp1.h
>> @@ -50,6 +50,7 @@ int vsp1_du_setup_lif(struct device *dev, unsigned int
>> pipe_index,
>>   * @dst: destination rectangle on the display (integer coordinates)
>>   * @alpha: alpha value (0: fully transparent, 255: fully opaque)
>>   * @zpos: Z position of the plane (from 0 to number of planes minus 1)
>> + * @interlaced: true for interlaced pipelines
>>   */
>>  struct vsp1_du_atomic_config {
>>  	u32 pixelformat;
>> @@ -59,6 +60,7 @@ struct vsp1_du_atomic_config {
>>  	struct v4l2_rect dst;
>>  	unsigned int alpha;
>>  	unsigned int zpos;
>> +	bool interlaced;
> 
> For the same reason shouldn't the interlaced flag be moved to 
> vsp1_du_lif_config ?
> 

Moved.

>>  };
>>
>>  /**
> 
