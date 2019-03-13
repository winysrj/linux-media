Return-Path: <SRS0=adTL=RQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3440CC4360F
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 11:54:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC9802177E
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 11:54:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="PaRpLZaZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726421AbfCMLy0 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 13 Mar 2019 07:54:26 -0400
Received: from perceval.ideasonboard.com ([213.167.242.64]:51904 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726125AbfCMLyZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Mar 2019 07:54:25 -0400
Received: from [192.168.0.20] (cpc89242-aztw30-2-0-cust488.18-1.cable.virginm.net [86.31.129.233])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id C561C22;
        Wed, 13 Mar 2019 12:54:20 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1552478061;
        bh=xe82pEbsyzRGnG9vq4pew5zdLl1X1oAUUrvhqPf0uX4=;
        h=Reply-To:Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=PaRpLZaZkqDmkJ+O09A/20G5JnyJxyvfCeaoew4YtgskLBmqeJyjEkLfnzmUVt8xR
         UoNlnGnNn2z53QkTeK8Uz1MRJdwHGSJMUMM2D6VXouA5lYmhJZpVcCvJ+bGMBVmpqn
         9YJxjAhmt5bJbdthdhzMInlXudNdgIAAdRElVSec=
Reply-To: kieran.bingham@ideasonboard.com
Subject: Re: [PATCH v6 17/18] drm: rcar-du: vsp: Extract framebuffer
 (un)mapping to separate functions
To:     Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        dri-devel@lists.freedesktop.org
Cc:     linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Brian Starkey <brian.starkey@arm.com>
References: <20190313000532.7087-1-laurent.pinchart+renesas@ideasonboard.com>
 <20190313000532.7087-18-laurent.pinchart+renesas@ideasonboard.com>
From:   Kieran Bingham <kieran.bingham@ideasonboard.com>
Openpgp: preference=signencrypt
Autocrypt: addr=kieran.bingham@ideasonboard.com; keydata=
 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
 sbsRB8KNNvVXBOVNwko86rQqF9drZuw=
Organization: Ideas on Board
Message-ID: <ae7b2f15-55db-a5d0-6701-deaf2fce0524@ideasonboard.com>
Date:   Wed, 13 Mar 2019 11:54:18 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190313000532.7087-18-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Laurent,

On 13/03/2019 00:05, Laurent Pinchart wrote:
> The rcar_du_vsp_plane_prepare_fb() and rcar_du_vsp_plane_cleanup_fb()
> functions implement the DRM plane .prepare_fb() and .cleanup_fb()
> operations. They map and unmap the framebuffer to/from the VSP
> internally, which will be useful to implement writeback support. Split
> the mapping and unmapping out to separate functions.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Looks good to me, Just a refactor and nothing controversial.

Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>



> ---
>  drivers/gpu/drm/rcar-du/rcar_du_vsp.c | 68 ++++++++++++++++-----------
>  drivers/gpu/drm/rcar-du/rcar_du_vsp.h | 17 +++++++
>  2 files changed, 58 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
> index 29a08f7b0761..0806a69c4679 100644
> --- a/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
> +++ b/drivers/gpu/drm/rcar-du/rcar_du_vsp.c
> @@ -173,26 +173,16 @@ static void rcar_du_vsp_plane_setup(struct rcar_du_vsp_plane *plane)
>  			      plane->index, &cfg);
>  }
>  
> -static int rcar_du_vsp_plane_prepare_fb(struct drm_plane *plane,
> -					struct drm_plane_state *state)
> +int rcar_du_vsp_map_fb(struct rcar_du_vsp *vsp, struct drm_framebuffer *fb,
> +		       struct sg_table sg_tables[3])
>  {
> -	struct rcar_du_vsp_plane_state *rstate = to_rcar_vsp_plane_state(state);
> -	struct rcar_du_vsp *vsp = to_rcar_vsp_plane(plane)->vsp;
>  	struct rcar_du_device *rcdu = vsp->dev;
>  	unsigned int i;
>  	int ret;
>  
> -	/*
> -	 * There's no need to prepare (and unprepare) the framebuffer when the
> -	 * plane is not visible, as it will not be displayed.
> -	 */
> -	if (!state->visible)
> -		return 0;
> -
> -	for (i = 0; i < rstate->format->planes; ++i) {
> -		struct drm_gem_cma_object *gem =
> -			drm_fb_cma_get_gem_obj(state->fb, i);
> -		struct sg_table *sgt = &rstate->sg_tables[i];
> +	for (i = 0; i < fb->format->num_planes; ++i) {
> +		struct drm_gem_cma_object *gem = drm_fb_cma_get_gem_obj(fb, i);
> +		struct sg_table *sgt = &sg_tables[i];
>  
>  		ret = dma_get_sgtable(rcdu->dev, sgt, gem->vaddr, gem->paddr,
>  				      gem->base.size);
> @@ -207,15 +197,11 @@ static int rcar_du_vsp_plane_prepare_fb(struct drm_plane *plane,
>  		}
>  	}
>  
> -	ret = drm_gem_fb_prepare_fb(plane, state);
> -	if (ret)
> -		goto fail;
> -
>  	return 0;
>  
>  fail:
>  	while (i--) {
> -		struct sg_table *sgt = &rstate->sg_tables[i];
> +		struct sg_table *sgt = &sg_tables[i];
>  
>  		vsp1_du_unmap_sg(vsp->vsp, sgt);
>  		sg_free_table(sgt);
> @@ -224,22 +210,50 @@ static int rcar_du_vsp_plane_prepare_fb(struct drm_plane *plane,
>  	return ret;
>  }
>  
> +static int rcar_du_vsp_plane_prepare_fb(struct drm_plane *plane,
> +					struct drm_plane_state *state)
> +{
> +	struct rcar_du_vsp_plane_state *rstate = to_rcar_vsp_plane_state(state);
> +	struct rcar_du_vsp *vsp = to_rcar_vsp_plane(plane)->vsp;
> +	int ret;
> +
> +	/*
> +	 * There's no need to prepare (and unprepare) the framebuffer when the
> +	 * plane is not visible, as it will not be displayed.
> +	 */
> +	if (!state->visible)
> +		return 0;

What about writeback?

- Never mind - that doesn't call through here.

> +
> +	ret = rcar_du_vsp_map_fb(vsp, state->fb, rstate->sg_tables);
> +	if (ret < 0)
> +		return ret;
> +
> +	return drm_gem_fb_prepare_fb(plane, state);
> +}
> +
> +void rcar_du_vsp_unmap_fb(struct rcar_du_vsp *vsp, struct drm_framebuffer *fb,
> +			  struct sg_table sg_tables[3])
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < fb->format->num_planes; ++i) {
> +		struct sg_table *sgt = &sg_tables[i];
> +
> +		vsp1_du_unmap_sg(vsp->vsp, sgt);
> +		sg_free_table(sgt);
> +	}
> +}
> +
>  static void rcar_du_vsp_plane_cleanup_fb(struct drm_plane *plane,
>  					 struct drm_plane_state *state)
>  {
>  	struct rcar_du_vsp_plane_state *rstate = to_rcar_vsp_plane_state(state);
>  	struct rcar_du_vsp *vsp = to_rcar_vsp_plane(plane)->vsp;
> -	unsigned int i;
>  
>  	if (!state->visible)
>  		return;
>  
> -	for (i = 0; i < rstate->format->planes; ++i) {
> -		struct sg_table *sgt = &rstate->sg_tables[i];
> -
> -		vsp1_du_unmap_sg(vsp->vsp, sgt);
> -		sg_free_table(sgt);
> -	}
> +	rcar_du_vsp_unmap_fb(vsp, state->fb, rstate->sg_tables);
>  }
>  
>  static int rcar_du_vsp_plane_atomic_check(struct drm_plane *plane,
> diff --git a/drivers/gpu/drm/rcar-du/rcar_du_vsp.h b/drivers/gpu/drm/rcar-du/rcar_du_vsp.h
> index db232037f24a..9b4724159378 100644
> --- a/drivers/gpu/drm/rcar-du/rcar_du_vsp.h
> +++ b/drivers/gpu/drm/rcar-du/rcar_du_vsp.h
> @@ -12,8 +12,10 @@
>  
>  #include <drm/drm_plane.h>
>  
> +struct drm_framebuffer;
>  struct rcar_du_format_info;
>  struct rcar_du_vsp;
> +struct sg_table;
>  
>  struct rcar_du_vsp_plane {
>  	struct drm_plane plane;
> @@ -60,6 +62,10 @@ void rcar_du_vsp_enable(struct rcar_du_crtc *crtc);
>  void rcar_du_vsp_disable(struct rcar_du_crtc *crtc);
>  void rcar_du_vsp_atomic_begin(struct rcar_du_crtc *crtc);
>  void rcar_du_vsp_atomic_flush(struct rcar_du_crtc *crtc);
> +int rcar_du_vsp_map_fb(struct rcar_du_vsp *vsp, struct drm_framebuffer *fb,
> +		       struct sg_table sg_tables[3]);
> +void rcar_du_vsp_unmap_fb(struct rcar_du_vsp *vsp, struct drm_framebuffer *fb,
> +			  struct sg_table sg_tables[3]);
>  #else
>  static inline int rcar_du_vsp_init(struct rcar_du_vsp *vsp,
>  				   struct device_node *np,
> @@ -71,6 +77,17 @@ static inline void rcar_du_vsp_enable(struct rcar_du_crtc *crtc) { };
>  static inline void rcar_du_vsp_disable(struct rcar_du_crtc *crtc) { };
>  static inline void rcar_du_vsp_atomic_begin(struct rcar_du_crtc *crtc) { };
>  static inline void rcar_du_vsp_atomic_flush(struct rcar_du_crtc *crtc) { };
> +static inline int rcar_du_vsp_map_fb(struct rcar_du_vsp *vsp,
> +				     struct drm_framebuffer *fb,
> +				     struct sg_table sg_tables[3])
> +{
> +	return -ENXIO;
> +}
> +static inline void rcar_du_vsp_unmap_fb(struct rcar_du_vsp *vsp,
> +					struct drm_framebuffer *fb,
> +					struct sg_table sg_tables[3])
> +{
> +}
>  #endif
>  
>  #endif /* __RCAR_DU_VSP_H__ */
> 

-- 
Regards
--
Kieran
