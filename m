Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:37481 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622Ab2GTHtY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Jul 2012 03:49:24 -0400
Received: by weyx8 with SMTP id x8so2369045wey.19
        for <linux-media@vger.kernel.org>; Fri, 20 Jul 2012 00:49:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1342083373-18245-1-git-send-email-javier.martin@vista-silicon.com>
References: <1342083373-18245-1-git-send-email-javier.martin@vista-silicon.com>
Date: Fri, 20 Jul 2012 09:49:22 +0200
Message-ID: <CACKLOr2CnQ6Dok_N-KCKMvp5dzSi=OP=WBFAfqaGr17enEkW8A@mail.gmail.com>
Subject: Re: [PATCH] media: mx2_camera: Add YUYV output format.
From: javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: fabio.estevam@freescale.com, laurent.pinchart@ideasonboard.com,
	g.liakhovetski@gmx.de, mchehab@infradead.org,
	Javier Martin <javier.martin@vista-silicon.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12 July 2012 10:56, Javier Martin <javier.martin@vista-silicon.com> wrote:
> Add explicit conversions from UYVY and YUYV to YUYV so that
> csicr1 configuration can be set properly for each format.
>
> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
> ---
>  drivers/media/video/mx2_camera.c |   40 ++++++++++++++++++++++++++++++++++++++
>  1 file changed, 40 insertions(+)
>
> diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
> index 0f01e7b..2a33bcb 100644
> --- a/drivers/media/video/mx2_camera.c
> +++ b/drivers/media/video/mx2_camera.c
> @@ -337,6 +337,34 @@ static struct mx2_fmt_cfg mx27_emma_prp_table[] = {
>                 }
>         },
>         {
> +               .in_fmt         = V4L2_MBUS_FMT_UYVY8_2X8,
> +               .out_fmt        = V4L2_PIX_FMT_YUYV,
> +               .cfg            = {
> +                       .channel        = 1,
> +                       .in_fmt         = PRP_CNTL_DATA_IN_YUV422,
> +                       .out_fmt        = PRP_CNTL_CH1_OUT_YUV422,
> +                       .src_pixel      = 0x22000888, /* YUV422 (YUYV) */
> +                       .ch1_pixel      = 0x62000888, /* YUV422 (YUYV) */
> +                       .irq_flags      = PRP_INTR_RDERR | PRP_INTR_CH1WERR |
> +                                               PRP_INTR_CH1FC | PRP_INTR_LBOVF,
> +                       .csicr1         = CSICR1_SWAP16_EN,
> +               }
> +       },
> +       {
> +               .in_fmt         = V4L2_MBUS_FMT_YUYV8_2X8,
> +               .out_fmt        = V4L2_PIX_FMT_YUYV,
> +               .cfg            = {
> +                       .channel        = 1,
> +                       .in_fmt         = PRP_CNTL_DATA_IN_YUV422,
> +                       .out_fmt        = PRP_CNTL_CH1_OUT_YUV422,
> +                       .src_pixel      = 0x22000888, /* YUV422 (YUYV) */
> +                       .ch1_pixel      = 0x62000888, /* YUV422 (YUYV) */
> +                       .irq_flags      = PRP_INTR_RDERR | PRP_INTR_CH1WERR |
> +                                               PRP_INTR_CH1FC | PRP_INTR_LBOVF,
> +                       .csicr1         = CSICR1_PACK_DIR,
> +               }
> +       },
> +       {
>                 .in_fmt         = V4L2_MBUS_FMT_YUYV8_2X8,
>                 .out_fmt        = V4L2_PIX_FMT_YUV420,
>                 .cfg            = {
> @@ -1146,6 +1174,18 @@ static int mx2_camera_get_formats(struct soc_camera_device *icd,
>                 }
>         }
>
> +       if (code == V4L2_MBUS_FMT_UYVY8_2X8) {
> +               formats++;
> +               if (xlate) {
> +                       xlate->host_fmt =
> +                               soc_mbus_get_fmtdesc(V4L2_MBUS_FMT_YUYV8_2X8);
> +                       xlate->code     = code;
> +                       dev_dbg(dev, "Providing host format %s for sensor code %d\n",
> +                               xlate->host_fmt->name, code);
> +                       xlate++;
> +               }
> +       }
> +
>         /* Generic pass-trough */
>         formats++;
>         if (xlate) {
> --
> 1.7.9.5
>

Any comments on this one?

Regards.

-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
