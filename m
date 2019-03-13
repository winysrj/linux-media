Return-Path: <SRS0=adTL=RQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46D76C10F03
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 10:59:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1614F2184D
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 10:59:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="WOSZWrnt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbfCMK70 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 13 Mar 2019 06:59:26 -0400
Received: from perceval.ideasonboard.com ([213.167.242.64]:51362 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbfCMK7Z (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Mar 2019 06:59:25 -0400
Received: from [192.168.0.20] (cpc89242-aztw30-2-0-cust488.18-1.cable.virginm.net [86.31.129.233])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id AD5DB255;
        Wed, 13 Mar 2019 11:59:21 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1552474762;
        bh=KcpMOO27dsEcVotisfil2w50oTu4tHf+jesTLSjGNy4=;
        h=Reply-To:Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=WOSZWrntJ3HzcThUkQu+oxD6GuEdVJBUt3TqTxaJu+5fNwdpdV4TgrkKVlDsNiTIQ
         0eCMAOQas/bOdmqaUUtJ5oA227LM5NawYdojhABOz8WZKaxZMeQQ1mm7KlZScuOdT2
         4kNRjVRNIWV3XbAB/dd8H45xvlqfPJ+nMUiiNWoA=
Reply-To: kieran.bingham@ideasonboard.com
Subject: Re: [PATCH v6 08/18] media: vsp1: wpf: Add writeback support
To:     Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        dri-devel@lists.freedesktop.org
Cc:     linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Brian Starkey <brian.starkey@arm.com>
References: <20190313000532.7087-1-laurent.pinchart+renesas@ideasonboard.com>
 <20190313000532.7087-9-laurent.pinchart+renesas@ideasonboard.com>
From:   Kieran Bingham <kieran.bingham@ideasonboard.com>
Openpgp: preference=signencrypt
Autocrypt: addr=kieran.bingham@ideasonboard.com; keydata=
 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
 sbsRB8KNNvVXBOVNwko86rQqF9drZuw=
Organization: Ideas on Board
Message-ID: <197df400-59b3-f0ba-9fca-a275bc3b1b97@ideasonboard.com>
Date:   Wed, 13 Mar 2019 10:59:18 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190313000532.7087-9-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Laurent,

On 13/03/2019 00:05, Laurent Pinchart wrote:
> Add support for the writeback feature of the WPF, to enable capturing
> frames at the WPF output for display pipelines. To enable writeback the
> vsp1_rwpf structure mem field must be set to the address of the
> writeback buffer and the writeback field set to true before the WPF
> .configure_stream() and .configure_partition() are called. The WPF will
> enable writeback in the display list for a single frame, and writeback
> will then be automatically disabled.
> 

This looks good.

Took some time to go through it while I argue with myself, but I think I
reached an agreement with me in the end :)

Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>


> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> ---
>  drivers/media/platform/vsp1/vsp1_rwpf.h |  2 +
>  drivers/media/platform/vsp1/vsp1_wpf.c  | 73 ++++++++++++++++++++++---
>  2 files changed, 66 insertions(+), 9 deletions(-)
> 
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


Does this need to be initialised to false somewhere?

answering my own question;
 No - because we allocate the "struct vsp1_rwpf *wpf" with devm_kzalloc.

>  
>  	struct vsp1_dl_manager *dlm;
>  };
> diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
> index fc5c1b0f6633..390ac478336d 100644
> --- a/drivers/media/platform/vsp1/vsp1_wpf.c
> +++ b/drivers/media/platform/vsp1/vsp1_wpf.c
> @@ -232,6 +232,27 @@ static void vsp1_wpf_destroy(struct vsp1_entity *entity)
>  	vsp1_dlm_destroy(wpf->dlm);
>  }
>  
> +static int wpf_configure_writeback_chain(struct vsp1_rwpf *wpf,
> +					 struct vsp1_dl_list *dl)
> +{
> +	unsigned int index = wpf->entity.index;
> +	struct vsp1_dl_list *dl_next;
> +	struct vsp1_dl_body *dlb;
> +
> +	dl_next = vsp1_dl_list_get(wpf->dlm);> +	if (!dl_next) {
> +		dev_err(wpf->entity.vsp1->dev,
> +			"Failed to obtain a dl list, disabling writeback\n");
> +		return -ENOMEM;
> +	}
> +
> +	dlb = vsp1_dl_list_get_body0(dl_next);
> +	vsp1_dl_body_write(dlb, VI6_WPF_WRBCK_CTRL(index), 0);
> +	vsp1_dl_list_add_chain(dl, dl_next);

Two thoughts for future consideration.

1) There was a patch I had floated to reduce the allocations of the pool
sizes. This would need to be checked if it's ever reconsidered, as we
now use an extra DL.

This is currently allocated as 64 lists in vsp1_wpf_create() with:

 	wpf->dlm = vsp1_dlm_create(vsp1, index, 64);

which is actually 65 lists because there's a + 1 in vsp1_dlm_create(),
so I think we have more than we'll ever need for a display pipeline
currently.


2) I did think we could pre-allocate this write back display list and
re-use it, by always attaching the same "writeback disable display list"
to the chain.

If we do that - we'll have to be careful about the refcounting of the
chained list as it will automatically be put back on to the dlm->free
list currently when the frame completes.

I think it's probably only a small optimisation to re-use the list
anyway, so just getting a new one and chaining it is certainly adequate
for this solution.



> +
> +	return 0;
> +}
> +
>  static void wpf_configure_stream(struct vsp1_entity *entity,
>  				 struct vsp1_pipeline *pipe,
>  				 struct vsp1_dl_list *dl,
> @@ -241,9 +262,11 @@ static void wpf_configure_stream(struct vsp1_entity *entity,
>  	struct vsp1_device *vsp1 = wpf->entity.vsp1;
>  	const struct v4l2_mbus_framefmt *source_format;
>  	const struct v4l2_mbus_framefmt *sink_format;
> +	unsigned int index = wpf->entity.index;
>  	unsigned int i;
>  	u32 outfmt = 0;
>  	u32 srcrpf = 0;
> +	int ret;
>  
>  	sink_format = vsp1_entity_get_pad_format(&wpf->entity,
>  						 wpf->entity.config,
> @@ -251,8 +274,9 @@ static void wpf_configure_stream(struct vsp1_entity *entity,
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
> @@ -277,8 +301,7 @@ static void wpf_configure_stream(struct vsp1_entity *entity,
>  
>  		vsp1_wpf_write(wpf, dlb, VI6_WPF_DSWAP, fmtinfo->swap);
>  
> -		if (vsp1_feature(vsp1, VSP1_HAS_WPF_HFLIP) &&
> -		    wpf->entity.index == 0)
> +		if (vsp1_feature(vsp1, VSP1_HAS_WPF_HFLIP) && index == 0)
>  			vsp1_wpf_write(wpf, dlb, VI6_WPF_ROT_CTRL,
>  				       VI6_WPF_ROT_CTRL_LN16 |
>  				       (256 << VI6_WPF_ROT_CTRL_LMEM_WD_SHIFT));
> @@ -289,11 +312,9 @@ static void wpf_configure_stream(struct vsp1_entity *entity,
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
> @@ -319,9 +340,26 @@ static void wpf_configure_stream(struct vsp1_entity *entity,
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
> +	 * Configure writeback for display pipelines (the wpf writeback flag is
> +	 * never set for memory-to-memory pipelines). Start by adding a chained
> +	 * display list to disable writeback after a single frame, and process
> +	 * to enable writeback. If the display list allocation fails don't
> +	 * enable writeback as we wouldn't be able to safely disable it,
> +	 * resulting in possible memory corruption.
> +	 */
> +	if (wpf->writeback) {
> +		ret = wpf_configure_writeback_chain(wpf, dl);
> +		if (ret < 0)
> +			wpf->writeback = false;
> +	}
> +
> +	vsp1_dl_body_write(dlb, VI6_WPF_WRBCK_CTRL(index),
> +			   wpf->writeback ? VI6_WPF_WRBCK_CTRL_WBMD : 0);
>  }
>  
>  static void wpf_configure_frame(struct vsp1_entity *entity,
> @@ -391,7 +429,11 @@ static void wpf_configure_partition(struct vsp1_entity *entity,
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
> @@ -480,6 +522,12 @@ static void wpf_configure_partition(struct vsp1_entity *entity,
>  	vsp1_wpf_write(wpf, dlb, VI6_WPF_DSTM_ADDR_Y, mem.addr[0]);
>  	vsp1_wpf_write(wpf, dlb, VI6_WPF_DSTM_ADDR_C0, mem.addr[1]);
>  	vsp1_wpf_write(wpf, dlb, VI6_WPF_DSTM_ADDR_C1, mem.addr[2]);
> +
> +	/*
> +	 * Writeback operates in single-shot mode and lasts for a single frame,
> +	 * reset the writeback flag to false for the next frame.
> +	 */
> +	wpf->writeback = false;
>  }
>  
>  static unsigned int wpf_max_width(struct vsp1_entity *entity,
> @@ -530,6 +578,13 @@ struct vsp1_rwpf *vsp1_wpf_create(struct vsp1_device *vsp1, unsigned int index)
>  		wpf->max_height = WPF_GEN3_MAX_HEIGHT;
>  	}
>  
> +	/*
> +	 * On Gen3 WPFs with a LIF output can also write to memory for display
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
