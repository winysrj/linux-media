Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gh0-f180.google.com ([209.85.160.180]:51052 "EHLO
	mail-gh0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759291Ab2FAJfb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Jun 2012 05:35:31 -0400
Received: by ghbz12 with SMTP id z12so1823223ghb.11
        for <linux-media@vger.kernel.org>; Fri, 01 Jun 2012 02:35:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1337638227-20379-1-git-send-email-fabio.estevam@freescale.com>
References: <1337638227-20379-1-git-send-email-fabio.estevam@freescale.com>
Date: Fri, 1 Jun 2012 11:35:29 +0200
Message-ID: <CACKLOr1EZg2iKjXp7MPP37GFogCbmXHt9UQ2WcMhjVQkLRzLww@mail.gmail.com>
Subject: Re: [PATCH] video: mx2_camera: Fix build error due to the lack of
 'pixfmt' definition
From: javier Martin <javier.martin@vista-silicon.com>
To: Fabio Estevam <fabio.estevam@freescale.com>
Cc: g.liakhovetski@gmx.de, mchehab@infradead.org,
	linux-media@vger.kernel.org, kernel@pengutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Fabio,

On 22 May 2012 00:10, Fabio Estevam <fabio.estevam@freescale.com> wrote:
> commit d509835 ([media] media: mx2_camera: Fix mbus format handling) caused
> the following build error:
>
> drivers/media/video/mx2_camera.c:1032:42: error: 'pixfmt' undeclared (first use in this function)
> make[4]: *** [drivers/media/video/mx2_camera.o] Error 1
>
> Fix this build error by providing a 'pixfmt' definition.
>
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> ---
>  drivers/media/video/mx2_camera.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
> index ded26b7..ef72733 100644
> --- a/drivers/media/video/mx2_camera.c
> +++ b/drivers/media/video/mx2_camera.c
> @@ -989,6 +989,7 @@ static int mx2_camera_set_bus_param(struct soc_camera_device *icd)
>        int ret;
>        int bytesperline;
>        u32 csicr1 = pcdev->csicr1;
> +       u32 pixfmt = icd->current_fmt->host_fmt->fourcc;
>
>        ret = v4l2_subdev_call(sd, video, g_mbus_config, &cfg);
>        if (!ret) {
> --
> 1.7.1

This patch is not needed anymore since Guennadi has requested one of
my patches to be removed from 'for_v3.5':

[PATCH] Revert "[media] media: mx2_camera: Fix mbus format handling"

And I've sent a new version addressing this merge issue and the
problem mentioned by Guennadi:

[PATCH v3][for_v3.5] media: mx2_camera: Fix mbus format handling


-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
