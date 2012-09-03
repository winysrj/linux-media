Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:42235 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756375Ab2ICMah (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Sep 2012 08:30:37 -0400
Received: by wgbdr13 with SMTP id dr13so4623970wgb.1
        for <linux-media@vger.kernel.org>; Mon, 03 Sep 2012 05:30:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1345456164-12995-1-git-send-email-javier.martin@vista-silicon.com>
References: <1345456164-12995-1-git-send-email-javier.martin@vista-silicon.com>
Date: Mon, 3 Sep 2012 14:30:36 +0200
Message-ID: <CACKLOr1HLSvvz8Bs_qgHuF1qjshwnsXqtcuS3q5uWmGhTkpxkg@mail.gmail.com>
Subject: Re: [PATCH v3] media: mx2_camera: Don't modify non volatile
 parameters in try_fmt.
From: javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: fabio.estevam@freescale.com, laurent.pinchart@ideasonboard.com,
	g.liakhovetski@gmx.de, mchehab@infradead.org,
	Javier Martin <javier.martin@vista-silicon.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
Guennadi,did you pick this one?

Regards.

On 20 August 2012 11:49, Javier Martin <javier.martin@vista-silicon.com> wrote:
> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
> ---
> Changes since v2:
>  - Add Signed-off-by line.
>
> ---
>  drivers/media/video/mx2_camera.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
> index 2a33bcb..88dcae6 100644
> --- a/drivers/media/video/mx2_camera.c
> +++ b/drivers/media/video/mx2_camera.c
> @@ -1385,6 +1385,7 @@ static int mx2_camera_try_fmt(struct soc_camera_device *icd,
>         __u32 pixfmt = pix->pixelformat;
>         struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
>         struct mx2_camera_dev *pcdev = ici->priv;
> +       struct mx2_fmt_cfg *emma_prp;
>         unsigned int width_limit;
>         int ret;
>
> @@ -1447,12 +1448,12 @@ static int mx2_camera_try_fmt(struct soc_camera_device *icd,
>                 __func__, pcdev->s_width, pcdev->s_height);
>
>         /* If the sensor does not support image size try PrP resizing */
> -       pcdev->emma_prp = mx27_emma_prp_get_format(xlate->code,
> +       emma_prp = mx27_emma_prp_get_format(xlate->code,
>                                                    xlate->host_fmt->fourcc);
>
>         memset(pcdev->resizing, 0, sizeof(pcdev->resizing));
>         if ((mf.width != pix->width || mf.height != pix->height) &&
> -               pcdev->emma_prp->cfg.in_fmt == PRP_CNTL_DATA_IN_YUV422) {
> +               emma_prp->cfg.in_fmt == PRP_CNTL_DATA_IN_YUV422) {
>                 if (mx2_emmaprp_resize(pcdev, &mf, pix, false) < 0)
>                         dev_dbg(icd->parent, "%s: can't resize\n", __func__);
>         }
> --
> 1.7.9.5
>



-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
