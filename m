Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:53173
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751423AbdFGQ5D (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Jun 2017 12:57:03 -0400
Date: Wed, 7 Jun 2017 13:56:54 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Alexandru Gheorghe <Alexandru_Gheorghe@mentor.com>
Cc: <laurent.pinchart@ideasonboard.com>,
        <linux-renesas-soc@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>, <linux-media@vger.kernel.org>,
        <geert@linux-m68k.org>, <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH v2 1/2] v4l: vsp1: Add support for colorkey alpha
 blending
Message-ID: <20170607135654.067f4dda@vento.lan>
In-Reply-To: <1494152007-30094-2-git-send-email-Alexandru_Gheorghe@mentor.com>
References: <1494152007-30094-1-git-send-email-Alexandru_Gheorghe@mentor.com>
        <1494152007-30094-2-git-send-email-Alexandru_Gheorghe@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 7 May 2017 13:13:26 +0300
Alexandru Gheorghe <Alexandru_Gheorghe@mentor.com> escreveu:

> The vsp2 hw supports changing of the alpha of pixels that match a color
> key, this patch adds support for this feature in order to be used by
> the rcar-du driver.
> The colorkey is interpreted different depending of the pixel format:
> 	* RGB   - all color components have to match.
> 	* YCbCr - only the Y component has to match.
> 
> Signed-off-by: Alexandru Gheorghe <Alexandru_Gheorghe@mentor.com>

As most of the changes on this series are for DRM, from my side,
feel free to merge this via DRM tree.

Acked-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

> ---
>  drivers/media/platform/vsp1/vsp1_drm.c  |  3 +++
>  drivers/media/platform/vsp1/vsp1_rpf.c  | 10 ++++++++--
>  drivers/media/platform/vsp1/vsp1_rwpf.h |  3 +++
>  include/media/vsp1.h                    |  3 +++
>  4 files changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
> index 3627f08..a4d0aee 100644
> --- a/drivers/media/platform/vsp1/vsp1_drm.c
> +++ b/drivers/media/platform/vsp1/vsp1_drm.c
> @@ -393,6 +393,9 @@ int vsp1_du_atomic_update(struct device *dev, unsigned int rpf_index,
>  	else
>  		rpf->format.plane_fmt[1].bytesperline = cfg->pitch;
>  	rpf->alpha = cfg->alpha;
> +	rpf->colorkey = cfg->colorkey;
> +	rpf->colorkey_en = cfg->colorkey_en;
> +	rpf->colorkey_alpha = cfg->colorkey_alpha;
>  	rpf->interlaced = cfg->interlaced;
>  
>  	if (soc_device_match(r8a7795es1) && rpf->interlaced) {
> diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c b/drivers/media/platform/vsp1/vsp1_rpf.c
> index a12d6f9..91f2a9f 100644
> --- a/drivers/media/platform/vsp1/vsp1_rpf.c
> +++ b/drivers/media/platform/vsp1/vsp1_rpf.c
> @@ -356,8 +356,14 @@ static void rpf_configure(struct vsp1_entity *entity,
>  	}
>  
>  	vsp1_rpf_write(rpf, dl, VI6_RPF_MSK_CTRL, 0);
> -	vsp1_rpf_write(rpf, dl, VI6_RPF_CKEY_CTRL, 0);
> -
> +	if (rpf->colorkey_en) {
> +		vsp1_rpf_write(rpf, dl, VI6_RPF_CKEY_SET0,
> +			       (rpf->colorkey_alpha << 24) | rpf->colorkey);
> +		vsp1_rpf_write(rpf, dl, VI6_RPF_CKEY_CTRL,
> +			       VI6_RPF_CKEY_CTRL_SAPE0);
> +	} else {
> +		vsp1_rpf_write(rpf, dl, VI6_RPF_CKEY_CTRL, 0);
> +	}
>  }
>  
>  static const struct vsp1_entity_operations rpf_entity_ops = {
> diff --git a/drivers/media/platform/vsp1/vsp1_rwpf.h b/drivers/media/platform/vsp1/vsp1_rwpf.h
> index fbe6aa6..2d7f4b9 100644
> --- a/drivers/media/platform/vsp1/vsp1_rwpf.h
> +++ b/drivers/media/platform/vsp1/vsp1_rwpf.h
> @@ -51,6 +51,9 @@ struct vsp1_rwpf {
>  	unsigned int brs_input;
>  
>  	unsigned int alpha;
> +	u32 colorkey;
> +	bool colorkey_en;
> +	u32 colorkey_alpha;
>  
>  	u32 mult_alpha;
>  	u32 outfmt;
> diff --git a/include/media/vsp1.h b/include/media/vsp1.h
> index 97265f7..65e3934 100644
> --- a/include/media/vsp1.h
> +++ b/include/media/vsp1.h
> @@ -32,6 +32,9 @@ struct vsp1_du_atomic_config {
>  	struct v4l2_rect dst;
>  	unsigned int alpha;
>  	unsigned int zpos;
> +	u32 colorkey;
> +	u32 colorkey_alpha;
> +	bool colorkey_en;
>  	bool interlaced;
>  };
>  



Thanks,
Mauro
