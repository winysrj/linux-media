Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f176.google.com ([209.85.214.176]:45763 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965294Ab3HHPAx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Aug 2013 11:00:53 -0400
Received: by mail-ob0-f176.google.com with SMTP id uz19so5012194obc.35
        for <linux-media@vger.kernel.org>; Thu, 08 Aug 2013 08:00:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1375973557-23333-3-git-send-email-g.liakhovetski@gmx.de>
References: <1375973557-23333-1-git-send-email-g.liakhovetski@gmx.de>
	<1375973557-23333-3-git-send-email-g.liakhovetski@gmx.de>
Date: Thu, 8 Aug 2013 20:30:52 +0530
Message-ID: <CAK9yfHx=D1z-Tdw_TQn_p_zqG7RLfU82w1efQ9+iraPXr+Wj3w@mail.gmail.com>
Subject: Re: [PATCH 2/6] V4L2: mx3_camera: convert to managed resource allocation
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi ,

On 8 August 2013 20:22, Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> Use devm_* resource allocators to simplify the driver's probe and clean up
> paths.
>
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
>  drivers/media/platform/soc_camera/mx3_camera.c |   47 +++++-------------------
>  1 files changed, 10 insertions(+), 37 deletions(-)
>
> diff --git a/drivers/media/platform/soc_camera/mx3_camera.c b/drivers/media/platform/soc_camera/mx3_camera.c
> index 1047e3e..e526096 100644
> --- a/drivers/media/platform/soc_camera/mx3_camera.c
> +++ b/drivers/media/platform/soc_camera/mx3_camera.c
> @@ -1151,23 +1151,19 @@ static int mx3_camera_probe(struct platform_device *pdev)
>         struct soc_camera_host *soc_host;
>
>         res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -       if (!res) {
> -               err = -ENODEV;
> -               goto egetres;
> -       }
> +       base = devm_ioremap_resource(&pdev->dev, res);
> +       if (IS_ERR(base))
> +               return PTR_ERR(base);
>
> -       mx3_cam = vzalloc(sizeof(*mx3_cam));
> +       mx3_cam = devm_kzalloc(&pdev->dev, sizeof(*mx3_cam), GFP_KERNEL);
>         if (!mx3_cam) {
>                 dev_err(&pdev->dev, "Could not allocate mx3 camera object\n");

This print is also redundant as kzalloc prints error on failure.


-- 
With warm regards,
Sachin
