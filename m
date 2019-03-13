Return-Path: <SRS0=adTL=RQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E0A6C10F03
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 11:13:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4DF382171F
	for <linux-media@archiver.kernel.org>; Wed, 13 Mar 2019 11:13:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="MaydWP7a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725868AbfCMLNE (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 13 Mar 2019 07:13:04 -0400
Received: from perceval.ideasonboard.com ([213.167.242.64]:51474 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbfCMLNE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Mar 2019 07:13:04 -0400
Received: from [192.168.0.20] (cpc89242-aztw30-2-0-cust488.18-1.cable.virginm.net [86.31.129.233])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 0A99E5AA;
        Wed, 13 Mar 2019 12:13:00 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1552475581;
        bh=JU2/8ClNm/YgprJeGleh9vMR9k/X0NG+PKvtHYLUjtw=;
        h=Reply-To:Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=MaydWP7ai8X3HTIPD7d5xYVG8GExEhQbph7nfCaIwDpxr6UNBYDPpjKw1QC/KLvGc
         lyFftEtr+es5xl9XB54ViQ58+JKTe9hZty3V9O3oRzniK5AiNb7bCSb4DzzloeB5h4
         LEd0q22TswQlGNln3WVsJma26JoBHs37+matXaK4=
Reply-To: kieran.bingham@ideasonboard.com
Subject: Re: [PATCH v6 09/18] media: vsp1: drm: Split RPF format setting to
 separate function
To:     Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        dri-devel@lists.freedesktop.org
Cc:     linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Brian Starkey <brian.starkey@arm.com>
References: <20190313000532.7087-1-laurent.pinchart+renesas@ideasonboard.com>
 <20190313000532.7087-10-laurent.pinchart+renesas@ideasonboard.com>
From:   Kieran Bingham <kieran.bingham@ideasonboard.com>
Openpgp: preference=signencrypt
Autocrypt: addr=kieran.bingham@ideasonboard.com; keydata=
 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
 sbsRB8KNNvVXBOVNwko86rQqF9drZuw=
Organization: Ideas on Board
Message-ID: <7b446a1c-823e-2cb9-64c4-26f6c828ac7a@ideasonboard.com>
Date:   Wed, 13 Mar 2019 11:12:57 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190313000532.7087-10-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Laurent,

On 13/03/2019 00:05, Laurent Pinchart wrote:
> The code that initializes the RPF format-related fields for display
> pipelines will also be useful for the WPF to implement writeback
> support. Split it from vsp1_du_atomic_update() to a new
> vsp1_du_pipeline_set_rwpf_format() function.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> ---
>  drivers/media/platform/vsp1/vsp1_drm.c | 55 ++++++++++++++++----------
>  1 file changed, 35 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
> index 4f1bc51d1ef4..5601a787688b 100644
> --- a/drivers/media/platform/vsp1/vsp1_drm.c
> +++ b/drivers/media/platform/vsp1/vsp1_drm.c
> @@ -566,6 +566,36 @@ static void vsp1_du_pipeline_configure(struct vsp1_pipeline *pipe)
>  	vsp1_dl_list_commit(dl, dl_flags);
>  }
>  
> +static int vsp1_du_pipeline_set_rwpf_format(struct vsp1_device *vsp1,
> +					    struct vsp1_rwpf *rwpf,
> +					    u32 pixelformat, unsigned int pitch)
> +{
> +	const struct vsp1_format_info *fmtinfo;
> +	unsigned int chroma_hsub;
> +
> +	fmtinfo = vsp1_get_format_info(vsp1, pixelformat);
> +	if (!fmtinfo) {
> +		dev_dbg(vsp1->dev, "Unsupported pixel format %08x for RPF\n",

Isn't this now a RWPF ?

Other than that

Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>


> +			pixelformat);
> +		return -EINVAL;
> +	}
> +
> +	/*
> +	 * Only formats with three planes can affect the chroma planes pitch.
> +	 * All formats with two planes have a horizontal subsampling value of 2,
> +	 * but combine U and V in a single chroma plane, which thus results in
> +	 * the luma plane and chroma plane having the same pitch.
> +	 */
> +	chroma_hsub = (fmtinfo->planes == 3) ? fmtinfo->hsub : 1;
> +
> +	rwpf->fmtinfo = fmtinfo;
> +	rwpf->format.num_planes = fmtinfo->planes;
> +	rwpf->format.plane_fmt[0].bytesperline = pitch;
> +	rwpf->format.plane_fmt[1].bytesperline = pitch / chroma_hsub;
> +
> +	return 0;
> +}
> +
>  /* -----------------------------------------------------------------------------
>   * DU Driver API
>   */
> @@ -773,9 +803,8 @@ int vsp1_du_atomic_update(struct device *dev, unsigned int pipe_index,
>  {
>  	struct vsp1_device *vsp1 = dev_get_drvdata(dev);
>  	struct vsp1_drm_pipeline *drm_pipe = &vsp1->drm->pipe[pipe_index];
> -	const struct vsp1_format_info *fmtinfo;
> -	unsigned int chroma_hsub;
>  	struct vsp1_rwpf *rpf;
> +	int ret;
>  
>  	if (rpf_index >= vsp1->info->rpf_count)
>  		return -EINVAL;
> @@ -808,25 +837,11 @@ int vsp1_du_atomic_update(struct device *dev, unsigned int pipe_index,
>  	 * Store the format, stride, memory buffer address, crop and compose
>  	 * rectangles and Z-order position and for the input.
>  	 */
> -	fmtinfo = vsp1_get_format_info(vsp1, cfg->pixelformat);
> -	if (!fmtinfo) {
> -		dev_dbg(vsp1->dev, "Unsupported pixel format %08x for RPF\n",
> -			cfg->pixelformat);
> -		return -EINVAL;
> -	}
> +	ret = vsp1_du_pipeline_set_rwpf_format(vsp1, rpf, cfg->pixelformat,
> +					       cfg->pitch);
> +	if (ret < 0)
> +		return ret;
>  
> -	/*
> -	 * Only formats with three planes can affect the chroma planes pitch.
> -	 * All formats with two planes have a horizontal subsampling value of 2,
> -	 * but combine U and V in a single chroma plane, which thus results in
> -	 * the luma plane and chroma plane having the same pitch.
> -	 */
> -	chroma_hsub = (fmtinfo->planes == 3) ? fmtinfo->hsub : 1;
> -
> -	rpf->fmtinfo = fmtinfo;
> -	rpf->format.num_planes = fmtinfo->planes;
> -	rpf->format.plane_fmt[0].bytesperline = cfg->pitch;
> -	rpf->format.plane_fmt[1].bytesperline = cfg->pitch / chroma_hsub;
>  	rpf->alpha = cfg->alpha;
>  
>  	rpf->mem.addr[0] = cfg->mem[0];
> 

-- 
Regards
--
Kieran
