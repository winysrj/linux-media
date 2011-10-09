Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:55238 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339Ab1JIOV2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 Oct 2011 10:21:28 -0400
Received: by yxl31 with SMTP id 31so4726864yxl.19
        for <linux-media@vger.kernel.org>; Sun, 09 Oct 2011 07:21:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1318166803-7392-4-git-send-email-martinez.javier@gmail.com>
References: <1318166803-7392-1-git-send-email-martinez.javier@gmail.com> <1318166803-7392-4-git-send-email-martinez.javier@gmail.com>
From: Javier Martinez Canillas <martinez.javier@gmail.com>
Date: Sun, 9 Oct 2011 16:21:07 +0200
Message-ID: <CAAwP0s140XJF9cXS1Nyyyzum+ka+hcs3hCxSzo4x6UNtuNyq0w@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] omap3isp: ccdc: Add support to ITU-R BT.656 video
 data format
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	Enrico <ebutera@users.berlios.de>,
	Gary Thomas <gary@mlbassoc.com>,
	Adam Pledger <a.pledger@thermoteknix.com>,
	Deepthy Ravi <deepthy.ravi@ti.com>,
	linux-media@vger.kernel.org,
	Javier Martinez Canillas <martinez.javier@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Oct 9, 2011 at 3:26 PM, Javier Martinez Canillas
<martinez.javier@gmail.com> wrote:
> This patch adds to the ISP CCDC driver the ability to deinterlace video
> data when configured in interlaced mode and send progressive frames to
> user-space V4L2 applications.
>
> Signed-off-by: Javier Martinez Canillas <martinez.javier@gmail.com>
> ---
>  drivers/media/video/omap3isp/ispccdc.c |  104 ++++++++++++++++++++++++++------
>  1 files changed, 85 insertions(+), 19 deletions(-)
>
> diff --git a/drivers/media/video/omap3isp/ispccdc.c b/drivers/media/video/omap3isp/ispccdc.c
> index c25db54..7907081 100644
> --- a/drivers/media/video/omap3isp/ispccdc.c
> +++ b/drivers/media/video/omap3isp/ispccdc.c
> @@ -40,6 +40,8 @@
>  static struct v4l2_mbus_framefmt *
>  __ccdc_get_format(struct isp_ccdc_device *ccdc, struct v4l2_subdev_fh *fh,
>                  unsigned int pad, enum v4l2_subdev_format_whence which);
> +static bool ccdc_input_is_bt656(struct isp_ccdc_device *ccdc);
> +static bool ccdc_input_is_fldmode(struct isp_ccdc_device *ccdc);
>
>  static const unsigned int ccdc_fmts[] = {
>        V4L2_MBUS_FMT_Y8_1X8,
> @@ -889,12 +891,6 @@ static void ccdc_config_outlineoffset(struct isp_ccdc_device *ccdc,
>        isp_reg_writel(isp, offset & 0xffff,
>                       OMAP3_ISP_IOMEM_CCDC, ISPCCDC_HSIZE_OFF);
>
> -       isp_reg_clr(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SDOFST,
> -                   ISPCCDC_SDOFST_FINV);
> -
> -       isp_reg_clr(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SDOFST,
> -                   ISPCCDC_SDOFST_FOFST_4L);
> -
>        switch (oddeven) {
>        case EVENEVEN:
>                isp_reg_set(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SDOFST,
> @@ -1010,6 +1006,9 @@ static void ccdc_config_sync_if(struct isp_ccdc_device *ccdc,
>        if (pdata && pdata->vs_pol)
>                syn_mode |= ISPCCDC_SYN_MODE_VDPOL;
>
> +       if (pdata && pdata->fldmode)
> +               syn_mode |= ISPCCDC_SYN_MODE_FLDMODE;
> +
>        isp_reg_writel(isp, syn_mode, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SYN_MODE);
>
>        if (format->code == V4L2_MBUS_FMT_UYVY8_2X8)
> @@ -1115,6 +1114,10 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
>        unsigned int shift;
>        u32 syn_mode;
>        u32 ccdc_pattern;
> +       u32 nph;
> +       u32 nlv;
> +       u32 vd0;
> +       u32 vd1;
>
>        pad = media_entity_remote_source(&ccdc->pads[CCDC_PAD_SINK]);
>        sensor = media_entity_to_v4l2_subdev(pad->entity);
> @@ -1185,26 +1188,49 @@ static void ccdc_configure(struct isp_ccdc_device *ccdc)
>        }
>        ccdc_config_imgattr(ccdc, ccdc_pattern);
>
> +       /* In BT.656 a pixel is representd using two bytes */
> +       if (pdata->bt656)
> +               nph = format->width * 2 - 1;
> +       else
> +               nph = format->width - 1;
> +
> +       /* In interlaced mode a frame is composed fo two subrames */
> +       if (pdata->fldmode) {
> +               vd0 = nlv = format->height / 2 - 1;
> +               vd1 = format->height / 3;
> +       } else {
> +               vd0 = nlv = format->height - 2;
> +               vd1 = format->height * 2 / 3;
> +       }
> +
>        /* Generate VD0 on the last line of the image and VD1 on the
>         * 2/3 height line.
>         */
> -       isp_reg_writel(isp, ((format->height - 2) << ISPCCDC_VDINT_0_SHIFT) |
> -                      ((format->height * 2 / 3) << ISPCCDC_VDINT_1_SHIFT),
> +       isp_reg_writel(isp, (vd0 << ISPCCDC_VDINT_0_SHIFT) |
> +                      (vd1 << ISPCCDC_VDINT_1_SHIFT),
>                       OMAP3_ISP_IOMEM_CCDC, ISPCCDC_VDINT);
>
>        /* CCDC_PAD_SOURCE_OF */
>        format = &ccdc->formats[CCDC_PAD_SOURCE_OF];
>
>        isp_reg_writel(isp, (0 << ISPCCDC_HORZ_INFO_SPH_SHIFT) |
> -                      ((format->width - 1) << ISPCCDC_HORZ_INFO_NPH_SHIFT),
> +                      (nph << ISPCCDC_HORZ_INFO_NPH_SHIFT),
>                       OMAP3_ISP_IOMEM_CCDC, ISPCCDC_HORZ_INFO);
>        isp_reg_writel(isp, 0 << ISPCCDC_VERT_START_SLV0_SHIFT,
>                       OMAP3_ISP_IOMEM_CCDC, ISPCCDC_VERT_START);
> -       isp_reg_writel(isp, (format->height - 1)
> -                       << ISPCCDC_VERT_LINES_NLV_SHIFT,
> +       isp_reg_writel(isp, nlv << ISPCCDC_VERT_LINES_NLV_SHIFT,
>                       OMAP3_ISP_IOMEM_CCDC, ISPCCDC_VERT_LINES);
> +       isp_reg_writel(isp, 0 << ISPCCDC_VERT_START_SLV1_SHIFT,
> +                      OMAP3_ISP_IOMEM_CCDC, ISPCCDC_VERT_START);
>
> -       ccdc_config_outlineoffset(ccdc, ccdc->video_out.bpl_value, 0, 0);
> +
> +       if (pdata->fldmode) {
> +               ccdc_config_outlineoffset(ccdc, nph, EVENEVEN, 1);
> +               ccdc_config_outlineoffset(ccdc, nph, EVENODD, 1);
> +               ccdc_config_outlineoffset(ccdc, nph, ODDEVEN, 1);
> +               ccdc_config_outlineoffset(ccdc, nph, ODDODD, 1);
> +       } else
> +               ccdc_config_outlineoffset(ccdc, ccdc->video_out.bpl_value, 0, 0);
>
>        /* CCDC_PAD_SOURCE_VP */
>        format = &ccdc->formats[CCDC_PAD_SOURCE_VP];
> @@ -1495,10 +1521,30 @@ static int ccdc_isr_buffer(struct isp_ccdc_device *ccdc)
>                goto done;
>        }
>
> -       buffer = omap3isp_video_buffer_next(&ccdc->video_out, ccdc->error);
> -       if (buffer != NULL) {
> -               ccdc_set_outaddr(ccdc, buffer->isp_addr);
> -               restart = 1;
> +       /* In interlaced mode a frame is composed of two subframes so we don't have
> +        * to change the CCDC output memory on every end of frame.
> +        */
> +       if (!ccdc_input_is_fldmode(ccdc)) {
> +               if (!ccdc->interlaced_cnt) {
> +                       ccdc->interlaced_cnt = 1;
> +                       restart = 1;
> +               } else {
> +                       ccdc->interlaced_cnt = 0;
> +                       buffer = omap3isp_video_buffer_next(&ccdc->video_out,
> +                                                           ccdc->error);
> +                       if (buffer != NULL) {
> +                               ccdc_set_outaddr(ccdc, buffer->isp_addr);
> +                               restart = 1;
> +                       }
> +               }
> +       } else {
> +               buffer = omap3isp_video_buffer_next(&ccdc->video_out,
> +                                                   ccdc->error);
> +               if (buffer != NULL) {
> +                       ccdc_set_outaddr(ccdc, buffer->isp_addr);
> +                       restart = 1;
> +               }
> +
>        }
>
>        pipe->state |= ISP_PIPELINE_IDLE_OUTPUT;
> @@ -1764,6 +1810,7 @@ static int ccdc_set_stream(struct v4l2_subdev *sd, int enable)
>                        omap3isp_sbl_disable(isp, OMAP3_ISP_SBL_CCDC_WRITE);
>                omap3isp_subclk_disable(isp, OMAP3_ISP_SUBCLK_CCDC);
>                ccdc->underrun = 0;
> +               ccdc->interlaced_cnt = 0;
>                break;
>        }
>
> @@ -1781,9 +1828,9 @@ __ccdc_get_format(struct isp_ccdc_device *ccdc, struct v4l2_subdev_fh *fh,
>                return &ccdc->formats[pad];
>  }
>
> -static bool ccdc_input_is_bt656(struct isp_ccdc_device *ccdc)
> +struct isp_parallel_platform_data *ccdc_get_pdata(struct isp_ccdc_device *ccdc)
>  {
> -       const struct isp_parallel_platform_data *pdata = NULL;
> +       struct isp_parallel_platform_data *pdata = NULL;
>        const struct v4l2_subdev *sensor;
>        const struct media_pad *pad;
>
> @@ -1793,7 +1840,26 @@ static bool ccdc_input_is_bt656(struct isp_ccdc_device *ccdc)
>        pad = media_entity_remote_source(&ccdc->pads[CCDC_PAD_SINK]);
>        sensor = media_entity_to_v4l2_subdev(pad->entity);
>        pdata = &((struct isp_v4l2_subdevs_group *)sensor->host_priv)
> -               ->bus.parallel;
> +                ->bus.parallel;
> +
> +       return pdata;
> +}
> +
> +static bool ccdc_input_is_fldmode(struct isp_ccdc_device *ccdc)
> +
> +{
> +       const struct isp_parallel_platform_data *pdata = NULL;
> +
> +       pdata = ccdc_get_pdata(ccdc);
> +
> +       return pdata && pdata->bt656;
> +}

A noticed a small error, it should be:

return pdata && pdata->fldmode;

Sorry for that.

> +
> +static bool ccdc_input_is_bt656(struct isp_ccdc_device *ccdc)
> +{
> +       const struct isp_parallel_platform_data *pdata = NULL;
> +
> +       pdata = ccdc_get_pdata(ccdc);
>
>        return pdata && pdata->bt656;
>  }
> --
> 1.7.4.1
>
>

-- 
Javier Martínez Canillas
(+34) 682 39 81 69
Barcelona, Spain
