Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:63458 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007Ab3C0E10 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Mar 2013 00:27:26 -0400
Received: by mail-wi0-f178.google.com with SMTP id ez12so1833430wid.5
        for <linux-media@vger.kernel.org>; Tue, 26 Mar 2013 21:27:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1364311408-8710-1-git-send-email-standby24x7@gmail.com>
References: <1364311408-8710-1-git-send-email-standby24x7@gmail.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Wed, 27 Mar 2013 09:57:05 +0530
Message-ID: <CA+V-a8uVtnsGpWHfVdw9TTbi_jhxVmkzgHpVoBxO3URLjj_jrw@mail.gmail.com>
Subject: Re: [PATCH] staging: davinci: Fix typo in staging/media/davinci
To: Masanari Iida <standby24x7@gmail.com>
Cc: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	linux-media <linux-media@vger.kernel.org>,
	devel@driverdev.osuosl.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Masanari,

Thanks for the patch!

On Tue, Mar 26, 2013 at 8:53 PM, Masanari Iida <standby24x7@gmail.com> wrote:
> Correct spelling typo in staging/media/davinci
>
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> ---
>  drivers/staging/media/davinci_vpfe/davinci-vpfe-mc.txt | 2 +-
>  drivers/staging/media/davinci_vpfe/dm365_isif.c        | 6 +++---
>  drivers/staging/media/davinci_vpfe/vpfe_video.c        | 8 ++++----
>  drivers/staging/media/davinci_vpfe/vpfe_video.h        | 2 +-
>  4 files changed, 9 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/staging/media/davinci_vpfe/davinci-vpfe-mc.txt b/drivers/staging/media/davinci_vpfe/davinci-vpfe-mc.txt
> index 1dbd564..a1e9177 100644
> --- a/drivers/staging/media/davinci_vpfe/davinci-vpfe-mc.txt
> +++ b/drivers/staging/media/davinci_vpfe/davinci-vpfe-mc.txt
> @@ -38,7 +38,7 @@ interface to userspace.
>         DAVINCI RESIZER A
>         DAVINCI RESIZER B
>
> -Each possible link in the VPFE is modeled by a link in the Media controller
> +Each possible link in the VPFE is modelled by a link in the Media controller

s/modeled/modelled are one and the same. you can keep it as is.
Rest of the patch looks OK. With this change you can add my ACK.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Regards,
--Prabhakar

>  interface. For an example program see [1].
>
>
> diff --git a/drivers/staging/media/davinci_vpfe/dm365_isif.c b/drivers/staging/media/davinci_vpfe/dm365_isif.c
> index ebeea72..6d4a93c 100644
> --- a/drivers/staging/media/davinci_vpfe/dm365_isif.c
> +++ b/drivers/staging/media/davinci_vpfe/dm365_isif.c
> @@ -685,7 +685,7 @@ static void isif_config_bclamp(struct vpfe_isif_device *isif,
>         val = (bc->bc_mode_color & ISIF_BC_MODE_COLOR_MASK) <<
>                 ISIF_BC_MODE_COLOR_SHIFT;
>
> -       /* Enable BC and horizontal clamp caculation paramaters */
> +       /* Enable BC and horizontal clamp calculation paramaters */
>         val = val | 1 | ((bc->horz.mode & ISIF_HORZ_BC_MODE_MASK) <<
>               ISIF_HORZ_BC_MODE_SHIFT);
>
> @@ -722,7 +722,7 @@ static void isif_config_bclamp(struct vpfe_isif_device *isif,
>                 isif_write(isif->isif_cfg.base_addr, val, CLHWIN2);
>         }
>
> -       /* vertical clamp caculation paramaters */
> +       /* vertical clamp calculation paramaters */
>         /* OB H Valid */
>         val = bc->vert.ob_h_sz_calc & ISIF_VERT_BC_OB_H_SZ_MASK;
>
> @@ -1569,7 +1569,7 @@ isif_pad_set_crop(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
>                 crop->rect.width = format->width;
>                 crop->rect.height = format->height;
>         }
> -       /* adjust the width to 16 pixel boundry */
> +       /* adjust the width to 16 pixel boundary */
>         crop->rect.width = ((crop->rect.width + 15) & ~0xf);
>         vpfe_isif->crop = crop->rect;
>         if (crop->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
> diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.c b/drivers/staging/media/davinci_vpfe/vpfe_video.c
> index 99ccbeb..c91d356 100644
> --- a/drivers/staging/media/davinci_vpfe/vpfe_video.c
> +++ b/drivers/staging/media/davinci_vpfe/vpfe_video.c
> @@ -357,7 +357,7 @@ static int vpfe_pipeline_disable(struct vpfe_pipeline *pipe)
>   *
>   * Set the pipeline to the given stream state.
>   *
> - * Return 0 if successfull, or the return value of the failed video::s_stream
> + * Return 0 if successful, or the return value of the failed video::s_stream
>   * operation otherwise.
>   */
>  static int vpfe_pipeline_set_stream(struct vpfe_pipeline *pipe,
> @@ -644,7 +644,7 @@ static int vpfe_g_fmt(struct file *file, void *priv,
>   * fills v4l2_fmtdesc structure with output format set on adjacent subdev,
>   * only one format is enumearted as subdevs are already configured
>   *
> - * Return 0 if successfull, error code otherwise
> + * Return 0 if successful, error code otherwise
>   */
>  static int vpfe_enum_fmt(struct file *file, void  *priv,
>                                    struct v4l2_fmtdesc *fmt)
> @@ -769,7 +769,7 @@ static int vpfe_try_fmt(struct file *file, void *priv,
>   * fills v4l2_input structure with input available on media chain,
>   * only one input is enumearted as media chain is setup by this time
>   *
> - * Return 0 if successfull, -EINVAL is media chain is invalid
> + * Return 0 if successful, -EINVAL is media chain is invalid
>   */
>  static int vpfe_enum_input(struct file *file, void *priv,
>                                  struct v4l2_input *inp)
> @@ -779,7 +779,7 @@ static int vpfe_enum_input(struct file *file, void *priv,
>         struct vpfe_device *vpfe_dev = video->vpfe_dev;
>
>         v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_enum_input\n");
> -       /* enumerate from the subdev user has choosen through mc */
> +       /* enumerate from the subdev user has chosen through mc */
>         if (inp->index < sdinfo->num_inputs) {
>                 memcpy(inp, &sdinfo->inputs[inp->index],
>                        sizeof(struct v4l2_input));
> diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.h b/drivers/staging/media/davinci_vpfe/vpfe_video.h
> index bf8af01..df0aeec 100644
> --- a/drivers/staging/media/davinci_vpfe/vpfe_video.h
> +++ b/drivers/staging/media/davinci_vpfe/vpfe_video.h
> @@ -138,7 +138,7 @@ struct vpfe_video_device {
>         v4l2_std_id                             stdid;
>         /*
>          * offset where second field starts from the starting of the
> -        * buffer for field seperated YCbCr formats
> +        * buffer for field separated YCbCr formats
>          */
>         u32                                     field_off;
>  };
> --
> 1.8.2.135.g7b592fa
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
