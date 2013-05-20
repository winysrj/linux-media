Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f176.google.com ([209.85.214.176]:48859 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754820Ab3ETL1J (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 May 2013 07:27:09 -0400
Received: by mail-ob0-f176.google.com with SMTP id wp18so6882858obc.35
        for <linux-media@vger.kernel.org>; Mon, 20 May 2013 04:27:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1368436761-12183-1-git-send-email-sachin.kamat@linaro.org>
References: <1368436761-12183-1-git-send-email-sachin.kamat@linaro.org>
Date: Mon, 20 May 2013 16:57:08 +0530
Message-ID: <CAK9yfHxOpoNFoTV6LkqTJGAL_K4R7n5e4ke0Cw-WeceWZ6MK_Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] [media] soc_camera/sh_mobile_csi2: Remove redundant platform_set_drvdata()
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, sachin.kamat@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 13 May 2013 14:49, Sachin Kamat <sachin.kamat@linaro.org> wrote:
> Commit 0998d06310 (device-core: Ensure drvdata = NULL when no
> driver is bound) removes the need to set driver data field to
> NULL.
>
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
>  drivers/media/platform/soc_camera/sh_mobile_csi2.c |    8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)
>
> diff --git a/drivers/media/platform/soc_camera/sh_mobile_csi2.c b/drivers/media/platform/soc_camera/sh_mobile_csi2.c
> index 09cb4fc..13a1f8f 100644
> --- a/drivers/media/platform/soc_camera/sh_mobile_csi2.c
> +++ b/drivers/media/platform/soc_camera/sh_mobile_csi2.c
> @@ -340,18 +340,13 @@ static int sh_csi2_probe(struct platform_device *pdev)
>         ret = v4l2_device_register_subdev(pdata->v4l2_dev, &priv->subdev);
>         dev_dbg(&pdev->dev, "%s(%p): ret(register_subdev) = %d\n", __func__, priv, ret);
>         if (ret < 0)
> -               goto esdreg;
> +               return ret;
>
>         pm_runtime_enable(&pdev->dev);
>
>         dev_dbg(&pdev->dev, "CSI2 probed.\n");
>
>         return 0;
> -
> -esdreg:
> -       platform_set_drvdata(pdev, NULL);
> -
> -       return ret;
>  }
>
>  static int sh_csi2_remove(struct platform_device *pdev)
> @@ -360,7 +355,6 @@ static int sh_csi2_remove(struct platform_device *pdev)
>
>         v4l2_device_unregister_subdev(&priv->subdev);
>         pm_runtime_disable(&pdev->dev);
> -       platform_set_drvdata(pdev, NULL);
>
>         return 0;
>  }
> --
> 1.7.9.5
>

Ping...

-- 
With warm regards,
Sachin
