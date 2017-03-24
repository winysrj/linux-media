Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:32716 "EHLO
        mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S965791AbdCXSy5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Mar 2017 14:54:57 -0400
Date: Fri, 24 Mar 2017 19:54:52 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
To: Arushi Singhal <arushisinghal19971997@gmail.com>
cc: mchehab@kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, outreachy-kernel@googlegroups.com
Subject: Re: [Outreachy kernel] [PATCH v2] staging: media: davinci_vpfe:Replace
 a bit shift.
In-Reply-To: <20170324160506.GA14310@arushi-HP-Pavilion-Notebook>
Message-ID: <alpine.DEB.2.20.1703241954110.3056@hadrien>
References: <20170324160506.GA14310@arushi-HP-Pavilion-Notebook>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There should be a spac after every colon in the subject.  Please pay
attention to these small details, so you don't have to send the same patch
over and over.

julia

On Fri, 24 Mar 2017, Arushi Singhal wrote:

> This patch replaces bit shifting on 1 with the BIT(x) macro.
> This was done with coccinelle:
> @@
> constant c;
> @@
>
> -1 << c
> +BIT(c)
>
> Signed-off-by: Arushi Singhal <arushisinghal19971997@gmail.com>
> ---
> changes in v2
>  -Remove unnecessary parenthesis.
>
>  drivers/staging/media/davinci_vpfe/dm365_ipipe.c   |  2 +-
>  drivers/staging/media/davinci_vpfe/dm365_ipipeif.c |  2 +-
>  drivers/staging/media/davinci_vpfe/dm365_isif.c    | 10 +++++-----
>  drivers/staging/media/davinci_vpfe/dm365_resizer.c |  6 +++---
>  4 files changed, 10 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/staging/media/davinci_vpfe/dm365_ipipe.c b/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
> index 6a3434cebd79..7eeb53217168 100644
> --- a/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
> +++ b/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
> @@ -1815,7 +1815,7 @@ vpfe_ipipe_init(struct vpfe_ipipe_device *ipipe, struct platform_device *pdev)
>  	v4l2_subdev_init(sd, &ipipe_v4l2_ops);
>  	sd->internal_ops = &ipipe_v4l2_internal_ops;
>  	strlcpy(sd->name, "DAVINCI IPIPE", sizeof(sd->name));
> -	sd->grp_id = 1 << 16;	/* group ID for davinci subdevs */
> +	sd->grp_id = BIT(16);	/* group ID for davinci subdevs */
>  	v4l2_set_subdevdata(sd, ipipe);
>  	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
>
> diff --git a/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c b/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c
> index 46fd2c7f69c3..c07f028dd6be 100644
> --- a/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c
> +++ b/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c
> @@ -1021,7 +1021,7 @@ int vpfe_ipipeif_init(struct vpfe_ipipeif_device *ipipeif,
>
>  	sd->internal_ops = &ipipeif_v4l2_internal_ops;
>  	strlcpy(sd->name, "DAVINCI IPIPEIF", sizeof(sd->name));
> -	sd->grp_id = 1 << 16;	/* group ID for davinci subdevs */
> +	sd->grp_id = BIT(16);	/* group ID for davinci subdevs */
>
>  	v4l2_set_subdevdata(sd, ipipeif);
>
> diff --git a/drivers/staging/media/davinci_vpfe/dm365_isif.c b/drivers/staging/media/davinci_vpfe/dm365_isif.c
> index 569bcdc9ce2f..74b1247203b1 100644
> --- a/drivers/staging/media/davinci_vpfe/dm365_isif.c
> +++ b/drivers/staging/media/davinci_vpfe/dm365_isif.c
> @@ -821,7 +821,7 @@ isif_config_dfc(struct vpfe_isif_device *isif, struct vpfe_isif_dfc *vdfc)
>
>  	/* Correct whole line or partial */
>  	if (vdfc->corr_whole_line)
> -		val |= 1 << ISIF_VDFC_CORR_WHOLE_LN_SHIFT;
> +		val |= BIT(ISIF_VDFC_CORR_WHOLE_LN_SHIFT);
>
>  	/* level shift value */
>  	val |= (vdfc->def_level_shift & ISIF_VDFC_LEVEL_SHFT_MASK) <<
> @@ -849,7 +849,7 @@ isif_config_dfc(struct vpfe_isif_device *isif, struct vpfe_isif_dfc *vdfc)
>
>  	val = isif_read(isif->isif_cfg.base_addr, DFCMEMCTL);
>  	/* set DFCMARST and set DFCMWR */
> -	val |= 1 << ISIF_DFCMEMCTL_DFCMARST_SHIFT;
> +	val |= BIT(ISIF_DFCMEMCTL_DFCMARST_SHIFT);
>  	val |= 1;
>  	isif_write(isif->isif_cfg.base_addr, val, DFCMEMCTL);
>
> @@ -880,7 +880,7 @@ isif_config_dfc(struct vpfe_isif_device *isif, struct vpfe_isif_dfc *vdfc)
>  		}
>  		val = isif_read(isif->isif_cfg.base_addr, DFCMEMCTL);
>  		/* clear DFCMARST and set DFCMWR */
> -		val &= ~(1 << ISIF_DFCMEMCTL_DFCMARST_SHIFT);
> +		val &= ~BIT(ISIF_DFCMEMCTL_DFCMARST_SHIFT);
>  		val |= 1;
>  		isif_write(isif->isif_cfg.base_addr, val, DFCMEMCTL);
>
> @@ -1140,7 +1140,7 @@ static int isif_config_raw(struct v4l2_subdev *sd, int mode)
>  	isif_write(isif->isif_cfg.base_addr, val, CGAMMAWD);
>  	/* Configure DPCM compression settings */
>  	if (params->v4l2_pix_fmt == V4L2_PIX_FMT_SGRBG10DPCM8) {
> -		val =  1 << ISIF_DPCM_EN_SHIFT;
> +		val =  BIT(ISIF_DPCM_EN_SHIFT);
>  		val |= (params->dpcm_predictor &
>  			ISIF_DPCM_PREDICTOR_MASK) << ISIF_DPCM_PREDICTOR_SHIFT;
>  	}
> @@ -2044,7 +2044,7 @@ int vpfe_isif_init(struct vpfe_isif_device *isif, struct platform_device *pdev)
>  	v4l2_subdev_init(sd, &isif_v4l2_ops);
>  	sd->internal_ops = &isif_v4l2_internal_ops;
>  	strlcpy(sd->name, "DAVINCI ISIF", sizeof(sd->name));
> -	sd->grp_id = 1 << 16;	/* group ID for davinci subdevs */
> +	sd->grp_id = BIT(16);	/* group ID for davinci subdevs */
>  	v4l2_set_subdevdata(sd, isif);
>  	sd->flags |= V4L2_SUBDEV_FL_HAS_EVENTS | V4L2_SUBDEV_FL_HAS_DEVNODE;
>  	pads[ISIF_PAD_SINK].flags = MEDIA_PAD_FL_SINK;
> diff --git a/drivers/staging/media/davinci_vpfe/dm365_resizer.c b/drivers/staging/media/davinci_vpfe/dm365_resizer.c
> index 857b0e847c5e..3b3469adaf91 100644
> --- a/drivers/staging/media/davinci_vpfe/dm365_resizer.c
> +++ b/drivers/staging/media/davinci_vpfe/dm365_resizer.c
> @@ -1903,7 +1903,7 @@ int vpfe_resizer_init(struct vpfe_resizer_device *vpfe_rsz,
>  	v4l2_subdev_init(sd, &resizer_v4l2_ops);
>  	sd->internal_ops = &resizer_v4l2_internal_ops;
>  	strlcpy(sd->name, "DAVINCI RESIZER CROP", sizeof(sd->name));
> -	sd->grp_id = 1 << 16;	/* group ID for davinci subdevs */
> +	sd->grp_id = BIT(16);	/* group ID for davinci subdevs */
>  	v4l2_set_subdevdata(sd, vpfe_rsz);
>  	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
>
> @@ -1927,7 +1927,7 @@ int vpfe_resizer_init(struct vpfe_resizer_device *vpfe_rsz,
>  	v4l2_subdev_init(sd, &resizer_v4l2_ops);
>  	sd->internal_ops = &resizer_v4l2_internal_ops;
>  	strlcpy(sd->name, "DAVINCI RESIZER A", sizeof(sd->name));
> -	sd->grp_id = 1 << 16;	/* group ID for davinci subdevs */
> +	sd->grp_id = BIT(16);	/* group ID for davinci subdevs */
>  	v4l2_set_subdevdata(sd, vpfe_rsz);
>  	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
>
> @@ -1949,7 +1949,7 @@ int vpfe_resizer_init(struct vpfe_resizer_device *vpfe_rsz,
>  	v4l2_subdev_init(sd, &resizer_v4l2_ops);
>  	sd->internal_ops = &resizer_v4l2_internal_ops;
>  	strlcpy(sd->name, "DAVINCI RESIZER B", sizeof(sd->name));
> -	sd->grp_id = 1 << 16;	/* group ID for davinci subdevs */
> +	sd->grp_id = BIT(16);	/* group ID for davinci subdevs */
>  	v4l2_set_subdevdata(sd, vpfe_rsz);
>  	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
>
> --
> 2.11.0
>
> --
> You received this message because you are subscribed to the Google Groups "outreachy-kernel" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to outreachy-kernel+unsubscribe@googlegroups.com.
> To post to this group, send email to outreachy-kernel@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/outreachy-kernel/20170324160506.GA14310%40arushi-HP-Pavilion-Notebook.
> For more options, visit https://groups.google.com/d/optout.
>
