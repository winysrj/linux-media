Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:37864 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262Ab2JILQX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Oct 2012 07:16:23 -0400
Received: by mail-wi0-f172.google.com with SMTP id hq12so5294325wib.1
        for <linux-media@vger.kernel.org>; Tue, 09 Oct 2012 04:16:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1349735823-30315-1-git-send-email-festevam@gmail.com>
References: <1349735823-30315-1-git-send-email-festevam@gmail.com>
Date: Tue, 9 Oct 2012 13:16:22 +0200
Message-ID: <CACKLOr3stV-Pup_w+DwGO3z842hct4RV+_hCVpL7Pu3QRFwH0w@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] [media]: mx2_camera: Fix regression caused by
 clock conversion
From: javier Martin <javier.martin@vista-silicon.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: g.liakhovetski@gmx.de, mchehab@infradead.org,
	kernel@pengutronix.de, gcembed@gmail.com,
	linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Fabio Estevam <fabio.estevam@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 9 October 2012 00:37, Fabio Estevam <festevam@gmail.com> wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
>
> Since mx27 transitioned to the commmon clock framework in 3.5, the correct way
> to acquire the csi clock is to get csi_ahb and csi_per clocks separately.
>
> By not doing so the camera sensor does not probe correctly:
>
> soc-camera-pdrv soc-camera-pdrv.0: Probing soc-camera-pdrv.0
> mx2-camera mx2-camera.0: Camera driver attached to camera 0
> ov2640 0-0030: Product ID error fb:fb
> mx2-camera mx2-camera.0: Camera driver detached from camera 0
> mx2-camera mx2-camera.0: MX2 Camera (CSI) driver probed, clock frequency: 66500000
>
> Adapt the mx2_camera driver to the new clock framework and make it functional
> again.
>
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> ---
> Changes since v1:
> - Rebased against linux-next 20121008.
>
>  drivers/media/platform/soc_camera/mx2_camera.c |   47 +++++++++++++++++-------
>  1 file changed, 34 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/media/platform/soc_camera/mx2_camera.c b/drivers/media/platform/soc_camera/mx2_camera.c
> index 403d7f1..9f8c5f0 100644
> --- a/drivers/media/platform/soc_camera/mx2_camera.c
> +++ b/drivers/media/platform/soc_camera/mx2_camera.c
> @@ -272,7 +272,8 @@ struct mx2_camera_dev {
>         struct device           *dev;
>         struct soc_camera_host  soc_host;
>         struct soc_camera_device *icd;
> -       struct clk              *clk_csi, *clk_emma_ahb, *clk_emma_ipg;
> +       struct clk              *clk_emma_ahb, *clk_emma_ipg;
> +       struct clk              *clk_csi_ahb, *clk_csi_per;
>
>         void __iomem            *base_csi, *base_emma;
>
> @@ -432,7 +433,8 @@ static void mx2_camera_deactivate(struct mx2_camera_dev *pcdev)
>  {
>         unsigned long flags;
>
> -       clk_disable_unprepare(pcdev->clk_csi);
> +       clk_disable_unprepare(pcdev->clk_csi_ahb);
> +       clk_disable_unprepare(pcdev->clk_csi_per);
>         writel(0, pcdev->base_csi + CSICR1);
>         if (cpu_is_mx27()) {
>                 writel(0, pcdev->base_emma + PRP_CNTL);
> @@ -460,7 +462,11 @@ static int mx2_camera_add_device(struct soc_camera_device *icd)
>         if (pcdev->icd)
>                 return -EBUSY;
>
> -       ret = clk_prepare_enable(pcdev->clk_csi);
> +       ret = clk_prepare_enable(pcdev->clk_csi_ahb);
> +       if (ret < 0)
> +               return ret;
> +
> +       ret = clk_prepare_enable(pcdev->clk_csi_per);
>         if (ret < 0)
>                 return ret;
>
> @@ -1725,11 +1731,18 @@ static int __devinit mx2_camera_probe(struct platform_device *pdev)
>                 goto exit;
>         }
>
> -       pcdev->clk_csi = devm_clk_get(&pdev->dev, "ahb");
> -       if (IS_ERR(pcdev->clk_csi)) {
> -               dev_err(&pdev->dev, "Could not get csi clock\n");
> -               err = PTR_ERR(pcdev->clk_csi);
> -               goto exit;
> +       pcdev->clk_csi_ahb = devm_clk_get(&pdev->dev, "ahb");
> +       if (IS_ERR(pcdev->clk_csi_ahb)) {
> +               dev_err(&pdev->dev, "Could not get csi ahb clock\n");
> +               err = PTR_ERR(pcdev->clk_csi_ahb);
> +               goto exit;
> +       }
> +
> +       pcdev->clk_csi_per = devm_clk_get(&pdev->dev, "per");
> +       if (IS_ERR(pcdev->clk_csi_per)) {
> +               dev_err(&pdev->dev, "Could not get csi per clock\n");
> +               err = PTR_ERR(pcdev->clk_csi_per);
> +               goto exit_csi_ahb;
>         }
>
>         pcdev->pdata = pdev->dev.platform_data;
> @@ -1738,14 +1751,15 @@ static int __devinit mx2_camera_probe(struct platform_device *pdev)
>
>                 pcdev->platform_flags = pcdev->pdata->flags;
>
> -               rate = clk_round_rate(pcdev->clk_csi, pcdev->pdata->clk * 2);
> +               rate = clk_round_rate(pcdev->clk_csi_per,
> +                                               pcdev->pdata->clk * 2);
>                 if (rate <= 0) {
>                         err = -ENODEV;
> -                       goto exit;
> +                       goto exit_csi_per;
>                 }
> -               err = clk_set_rate(pcdev->clk_csi, rate);
> +               err = clk_set_rate(pcdev->clk_csi_per, rate);
>                 if (err < 0)
> -                       goto exit;
> +                       goto exit_csi_per;
>         }
>
>         INIT_LIST_HEAD(&pcdev->capture);
> @@ -1801,7 +1815,7 @@ static int __devinit mx2_camera_probe(struct platform_device *pdev)
>                 goto exit_free_emma;
>
>         dev_info(&pdev->dev, "MX2 Camera (CSI) driver probed, clock frequency: %ld\n",
> -                       clk_get_rate(pcdev->clk_csi));
> +                       clk_get_rate(pcdev->clk_csi_per));
>
>         return 0;
>
> @@ -1812,6 +1826,10 @@ eallocctx:
>                 clk_disable_unprepare(pcdev->clk_emma_ipg);
>                 clk_disable_unprepare(pcdev->clk_emma_ahb);
>         }
> +exit_csi_per:
> +       clk_disable_unprepare(pcdev->clk_csi_per);
> +exit_csi_ahb:
> +       clk_disable_unprepare(pcdev->clk_csi_ahb);
>  exit:
>         return err;
>  }
> @@ -1831,6 +1849,9 @@ static int __devexit mx2_camera_remove(struct platform_device *pdev)
>                 clk_disable_unprepare(pcdev->clk_emma_ahb);
>         }
>
> +       clk_disable_unprepare(pcdev->clk_csi_per);
> +       clk_disable_unprepare(pcdev->clk_csi_ahb);
> +
>         dev_info(&pdev->dev, "MX2 Camera driver unloaded\n");
>
>         return 0;
> --
> 1.7.9.5
>

This patch doesn't fix the BUG it claims to, since I have it working
properly in our Visstrim M10 platform without it. Look:

soc-camera-pdrv soc-camera-pdrv.0: Probing soc-camera-pdrv.0
mx2-camera mx2-camera.0: Camera driver attached to camera 0
ov7670 0-0021: chip found @ 0x42 (imx-i2c)
[..]
mx2-camera mx2-camera.0: Camera driver detached from camera 0
mx2-camera mx2-camera.0: MX2 Camera (CSI) driver probed, clock
frequency: 66500000

Furthermore, it's not correct, since there isn't such "per" clock for
the CSI in 3.5 [1], 3.6 [2], linux-next-20121008[3], or
next-20121009[4].

[1] http://lxr.linux.no/#linux+v3.5/arch/arm/mach-imx/clk-imx27.c#L226
[2] http://lxr.linux.no/#linux+v3.6/arch/arm/mach-imx/clk-imx27.c#L226
[3] http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=blob;f=arch/arm/mach-imx/clk-imx27.c;h=3b6b640eed247ea1b7848c7a7fa01801f0190cde;hb=cc925138a0dd9ae388135bb3cf11ee1729f9c4e9#l226
[4] http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=blob;f=arch/arm/mach-imx/clk-imx27.c;h=3b6b640eed247ea1b7848c7a7fa01801f0190cde;hb=b066f61482c7eac44e656499426a3c56d29c32ed#l226

Regards.
-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
