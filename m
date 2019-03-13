Return-Path: <SRS0=adTL=RQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9309C10F03
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 11:26:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D2C92171F
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 11:26:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="CGvTawbn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725876AbfCML0U (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 13 Mar 2019 07:26:20 -0400
Received: from perceval.ideasonboard.com ([213.167.242.64]:51708 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbfCML0U (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Mar 2019 07:26:20 -0400
Received: from [192.168.0.20] (cpc89242-aztw30-2-0-cust488.18-1.cable.virginm.net [86.31.129.233])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 4D4E55AA;
        Wed, 13 Mar 2019 12:26:17 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1552476377;
        bh=sgwtzrtYgCXcvMz1Mo72wiNi+bGloM4/rtefdIXcUh4=;
        h=Reply-To:Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=CGvTawbnP3l6Mw/Xh+R0GAPoBZAkuqpycq4b6zyU+6AywtowJMAkioMjSoH6LQIWj
         JlE0R7KMy3W3OepfGF7CDCAr6RyyysonE/pFQkRe2vxiWqLby5G08XrtZm5O/kxCOj
         GuwD1H8B1/LPyh5ZaZJ2V00sqfPiIaRJJjeJiL6o=
Reply-To: kieran.bingham@ideasonboard.com
Subject: Re: [PATCH v6 10/18] media: vsp1: drm: Extend frame completion API to
 the DU driver
To:     Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        dri-devel@lists.freedesktop.org
Cc:     linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Brian Starkey <brian.starkey@arm.com>
References: <20190313000532.7087-1-laurent.pinchart+renesas@ideasonboard.com>
 <20190313000532.7087-11-laurent.pinchart+renesas@ideasonboard.com>
From:   Kieran Bingham <kieran.bingham@ideasonboard.com>
Openpgp: preference=signencrypt
Autocrypt: addr=kieran.bingham@ideasonboard.com; keydata=
 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
 sbsRB8KNNvVXBOVNwko86rQqF9drZuw=
Organization: Ideas on Board
Message-ID: <481d3ccd-ad52-9998-2edf-e7774f03145d@ideasonboard.com>
Date:   Wed, 13 Mar 2019 11:26:14 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190313000532.7087-11-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Laurent,

On 13/03/2019 00:05, Laurent Pinchart wrote:
> The VSP1 driver will need to pass extra flags to the DU through the
> frame completion API. Replace the completed bool flag by a bitmask to
> support this.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> ---
>  drivers/gpu/drm/rcar-du/rcar_du_vsp.c  | 4 ++--
>  drivers/media/platform/vsp1/vsp1_drm.c | 4 ++--
>  drivers/media/platform/vsp1/vsp1_drm.h | 2 +-
>  include/media/vsp1.h                   | 4 +++-
>  4 files changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
> index 76a39eee7c9c..28bfeb8c24fb 100644
> --- a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
> +++ b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
> @@ -26,14 +26,14 @@
>  #include "rcar_du_kms.h"
>  #include "rcar_du_vsp.h"
>  
> -static void rcar_du_vsp_complete(void *private, bool completed, u32 crc)
> +static void rcar_du_vsp_complete(void *private, unsigned int status, u32 crc)
>  {
>  	struct rcar_du_crtc *crtc = private;
>  
>  	if (crtc->vblank_enable)
>  		drm_crtc_handle_vblank(&crtc->crtc);
>  
> -	if (completed)
> +	if (status & VSP1_DU_STATUS_COMPLETE)
>  		rcar_du_crtc_finish_page_flip(crtc);
>  
>  	drm_crtc_add_crc_entry(&crtc->crtc, false, 0, &crc);
> diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
> index 5601a787688b..0367f88135bf 100644
> --- a/drivers/media/platform/vsp1/vsp1_drm.c
> +++ b/drivers/media/platform/vsp1/vsp1_drm.c
> @@ -34,14 +34,14 @@ static void vsp1_du_pipeline_frame_end(struct vsp1_pipeline *pipe,
>  				       unsigned int completion)
>  {
>  	struct vsp1_drm_pipeline *drm_pipe = to_vsp1_drm_pipeline(pipe);
> -	bool complete = completion & VSP1_DL_FRAME_END_COMPLETED;
>  
>  	if (drm_pipe->du_complete) {
>  		struct vsp1_entity *uif = drm_pipe->uif;
> +		unsigned int status = completion & VSP1_DU_STATUS_COMPLETE;


Why do you mask the bit(s) here?

Can't we just pass completion into
  drm_pipe->du_complete(p, completion, c); ?

[(edit: no, because completion contains things such as
VSP1_DL_FRAME_END_INTERNAL)]

Or are you relying on the fact that,
 VSP1_DL_FRAME_END_COMPLETED == VSP1_DU_STATUS_COMPLETE

in which case perhaps we should be more explicit somehow, either in code
or with a comment that this section is converting between the two
bitfield types.

However you resolve, the rest looks fine:

Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>



>  		u32 crc;
>  
>  		crc = uif ? vsp1_uif_get_crc(to_uif(&uif->subdev)) : 0;
> -		drm_pipe->du_complete(drm_pipe->du_private, complete, crc);
> +		drm_pipe->du_complete(drm_pipe->du_private, status, crc);
>  	}
>  
>  	if (completion & VSP1_DL_FRAME_END_INTERNAL) {
> diff --git a/drivers/media/platform/vsp1/vsp1_drm.h b/drivers/media/platform/vsp1/vsp1_drm.h
> index 8dfd274a59e2..e85ad4366fbb 100644
> --- a/drivers/media/platform/vsp1/vsp1_drm.h
> +++ b/drivers/media/platform/vsp1/vsp1_drm.h
> @@ -42,7 +42,7 @@ struct vsp1_drm_pipeline {
>  	struct vsp1_du_crc_config crc;
>  
>  	/* Frame synchronisation */
> -	void (*du_complete)(void *data, bool completed, u32 crc);
> +	void (*du_complete)(void *data, unsigned int status, u32 crc);
>  	void *du_private;
>  };
>  
> diff --git a/include/media/vsp1.h b/include/media/vsp1.h
> index 1cf868360701..877496936487 100644
> --- a/include/media/vsp1.h
> +++ b/include/media/vsp1.h
> @@ -17,6 +17,8 @@ struct device;
>  
>  int vsp1_du_init(struct device *dev);
>  
> +#define VSP1_DU_STATUS_COMPLETE		BIT(0)
> +
>  /**
>   * struct vsp1_du_lif_config - VSP LIF configuration
>   * @width: output frame width
> @@ -32,7 +34,7 @@ struct vsp1_du_lif_config {
>  	unsigned int height;
>  	bool interlaced;
>  
> -	void (*callback)(void *data, bool completed, u32 crc);
> +	void (*callback)(void *data, unsigned int status, u32 crc);
>  	void *callback_data;
>  };
>  
> 

-- 
Regards
--
Kieran
