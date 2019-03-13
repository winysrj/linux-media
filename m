Return-Path: <SRS0=adTL=RQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06D36C4360F
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 11:42:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD9D02177E
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 11:42:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="PM7m9uhX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726142AbfCMLml (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 13 Mar 2019 07:42:41 -0400
Received: from perceval.ideasonboard.com ([213.167.242.64]:51802 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbfCMLmk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Mar 2019 07:42:40 -0400
Received: from [192.168.0.20] (cpc89242-aztw30-2-0-cust488.18-1.cable.virginm.net [86.31.129.233])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 715065AA;
        Wed, 13 Mar 2019 12:42:37 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1552477357;
        bh=sSnwcTAqgmb8PupapfPtDK4UmpiAFNbYsSeAw4IKDvM=;
        h=Reply-To:Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=PM7m9uhXGLP0rjiDjG0bTqv1jQiV7jUfwLXj1MJzPlxkoVGo94jea4/sKg/+ta7/I
         v6iQkEneoAGS7AfMlsGSwWqfnynUuFkkYfELEj3X3caGChA6gKFFJX5SjSqPVOjI1/
         sK6tV+1gmTgH+KvrBU/BXpO1hYD5sXMa7QhXRgFE=
Reply-To: kieran.bingham@ideasonboard.com
Subject: Re: [PATCH v6 11/18] media: vsp1: drm: Implement writeback support
To:     Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        dri-devel@lists.freedesktop.org
Cc:     linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Brian Starkey <brian.starkey@arm.com>
References: <20190313000532.7087-1-laurent.pinchart+renesas@ideasonboard.com>
 <20190313000532.7087-12-laurent.pinchart+renesas@ideasonboard.com>
From:   Kieran Bingham <kieran.bingham@ideasonboard.com>
Openpgp: preference=signencrypt
Autocrypt: addr=kieran.bingham@ideasonboard.com; keydata=
 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
 sbsRB8KNNvVXBOVNwko86rQqF9drZuw=
Organization: Ideas on Board
Message-ID: <ab98c192-9615-809c-2bdd-c1a2d72cff5b@ideasonboard.com>
Date:   Wed, 13 Mar 2019 11:42:34 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190313000532.7087-12-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Laurent,

On 13/03/2019 00:05, Laurent Pinchart wrote:
> Extend the vsp1_du_atomic_flush() API with writeback support by adding
> format, pitch and memory addresses of the writeback framebuffer.
> Writeback completion is reported through the existing frame completion
> callback with a new VSP1_DU_STATUS_WRITEBACK status flag.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> ---
>  drivers/media/platform/vsp1/vsp1_dl.c  | 14 ++++++++++++++
>  drivers/media/platform/vsp1/vsp1_dl.h  |  3 ++-
>  drivers/media/platform/vsp1/vsp1_drm.c | 25 ++++++++++++++++++++++++-
>  include/media/vsp1.h                   | 15 +++++++++++++++
>  4 files changed, 55 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_dl.c b/drivers/media/platform/vsp1/vsp1_dl.c
> index ed7cda4130f2..104b6f514536 100644
> --- a/drivers/media/platform/vsp1/vsp1_dl.c
> +++ b/drivers/media/platform/vsp1/vsp1_dl.c
> @@ -958,6 +958,9 @@ void vsp1_dl_list_commit(struct vsp1_dl_list *dl, unsigned int dl_flags)
>   *
>   * The VSP1_DL_FRAME_END_INTERNAL flag indicates that the display list that just
>   * became active had been queued with the internal notification flag.
> + *
> + * The VSP1_DL_FRAME_END_WRITEBACK flag indicates that the previously active
> + * display list had been queued with the writeback flag.

How does this interact with the possibility of the writeback being
disabled by the WPF in the event of it failing to get a DL.

It's only a small corner case, but will the 'writeback' report back as
though it succeeded? (without writing to memory, and thus giving an
unmodified buffer back?)


>   */
>  unsigned int vsp1_dlm_irq_frame_end(struct vsp1_dl_manager *dlm)
>  {
> @@ -995,6 +998,17 @@ unsigned int vsp1_dlm_irq_frame_end(struct vsp1_dl_manager *dlm)
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
> index e0fdb145e6ed..4d7bcfdc9bd9 100644
> --- a/drivers/media/platform/vsp1/vsp1_dl.h
> +++ b/drivers/media/platform/vsp1/vsp1_dl.h
> @@ -18,7 +18,8 @@ struct vsp1_dl_list;
>  struct vsp1_dl_manager;
>  
>  #define VSP1_DL_FRAME_END_COMPLETED		BIT(0)
> -#define VSP1_DL_FRAME_END_INTERNAL		BIT(1)
> +#define VSP1_DL_FRAME_END_WRITEBACK		BIT(1)

So below BIT(2) (code above) the flags match the externally exposed
bitfield for the VSP1_DU_STATUS_

While above (code below), are 'private' bitfields.

Should this requirement be documented here somehow? especially the
mapping of FRAME_END_{COMPLETED,WRITEBACK} to
DU_STATUS_{COMPLETED,WRITEBACK}.



> +#define VSP1_DL_FRAME_END_INTERNAL		BIT(2)


>  
>  /**
>   * struct vsp1_dl_ext_cmd - Extended Display command
> diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
> index 0367f88135bf..16826bf184c7 100644
> --- a/drivers/media/platform/vsp1/vsp1_drm.c
> +++ b/drivers/media/platform/vsp1/vsp1_drm.c
> @@ -37,7 +37,9 @@ static void vsp1_du_pipeline_frame_end(struct vsp1_pipeline *pipe,
>  
>  	if (drm_pipe->du_complete) {
>  		struct vsp1_entity *uif = drm_pipe->uif;
> -		unsigned int status = completion & VSP1_DU_STATUS_COMPLETE;
> +		unsigned int status = completion
> +				    & (VSP1_DU_STATUS_COMPLETE |
> +				       VSP1_DU_STATUS_WRITEBACK);
>  		u32 crc;
>  
>  		crc = uif ? vsp1_uif_get_crc(to_uif(&uif->subdev)) : 0;
> @@ -541,6 +543,8 @@ static void vsp1_du_pipeline_configure(struct vsp1_pipeline *pipe)
>  
>  	if (drm_pipe->force_brx_release)
>  		dl_flags |= VSP1_DL_FRAME_END_INTERNAL;
> +	if (pipe->output->writeback)
> +		dl_flags |= VSP1_DL_FRAME_END_WRITEBACK;
>  
>  	dl = vsp1_dl_list_get(pipe->output->dlm);
>  	dlb = vsp1_dl_list_get_body0(dl);
> @@ -870,12 +874,31 @@ void vsp1_du_atomic_flush(struct device *dev, unsigned int pipe_index,
>  	struct vsp1_device *vsp1 = dev_get_drvdata(dev);
>  	struct vsp1_drm_pipeline *drm_pipe = &vsp1->drm->pipe[pipe_index];
>  	struct vsp1_pipeline *pipe = &drm_pipe->pipe;
> +	int ret;
>  
>  	drm_pipe->crc = cfg->crc;
>  
>  	mutex_lock(&vsp1->drm->lock);
> +
> +	if (pipe->output->has_writeback && cfg->writeback.pixelformat) {

Is pipe->output->has_writeback necessary here? Can
cfg->writeback.pixelformat be set if pipe->output->has_writeback is false?

Hrm ... actually - Perhaps it is useful. It validates both sides of the
system.

pipe->output->has_writeback is a capability of the VSP, where as
cfg->writeback.pixelformat is a 'request' from the DU.


> +		const struct vsp1_du_writeback_config *wb_cfg = &cfg->writeback;
> +
> +		ret = vsp1_du_pipeline_set_rwpf_format(vsp1, pipe->output,
> +						       wb_cfg->pixelformat,
> +						       wb_cfg->pitch);
> +		if (WARN_ON(ret < 0))
> +			goto done;
> +
> +		pipe->output->mem.addr[0] = wb_cfg->mem[0];
> +		pipe->output->mem.addr[1] = wb_cfg->mem[1];
> +		pipe->output->mem.addr[2] = wb_cfg->mem[2];
> +		pipe->output->writeback = true;
> +	}
> +
>  	vsp1_du_pipeline_setup_inputs(vsp1, pipe);
>  	vsp1_du_pipeline_configure(pipe);
> +
> +done:
>  	mutex_unlock(&vsp1->drm->lock);
>  }
>  EXPORT_SYMBOL_GPL(vsp1_du_atomic_flush);
> diff --git a/include/media/vsp1.h b/include/media/vsp1.h
> index 877496936487..cc1b0d42ce95 100644
> --- a/include/media/vsp1.h
> +++ b/include/media/vsp1.h
> @@ -18,6 +18,7 @@ struct device;
>  int vsp1_du_init(struct device *dev);
>  
>  #define VSP1_DU_STATUS_COMPLETE		BIT(0)
> +#define VSP1_DU_STATUS_WRITEBACK	BIT(1)
>  
>  /**
>   * struct vsp1_du_lif_config - VSP LIF configuration
> @@ -83,12 +84,26 @@ struct vsp1_du_crc_config {
>  	unsigned int index;
>  };
>  
> +/**
> + * struct vsp1_du_writeback_config - VSP writeback configuration parameters
> + * @pixelformat: plane pixel format (V4L2 4CC)
> + * @pitch: line pitch in bytes for the first plane
> + * @mem: DMA memory address for each plane of the frame buffer
> + */
> +struct vsp1_du_writeback_config {
> +	u32 pixelformat;
> +	unsigned int pitch;
> +	dma_addr_t mem[3];
> +};
> +
>  /**
>   * struct vsp1_du_atomic_pipe_config - VSP atomic pipe configuration parameters
>   * @crc: CRC computation configuration
> + * @writeback: writeback configuration
>   */
>  struct vsp1_du_atomic_pipe_config {
>  	struct vsp1_du_crc_config crc;
> +	struct vsp1_du_writeback_config writeback;
>  };
>  
>  void vsp1_du_atomic_begin(struct device *dev, unsigned int pipe_index);
> 

-- 
Regards
--
Kieran
