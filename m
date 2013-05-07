Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f54.google.com ([209.85.219.54]:64918 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757416Ab3EGGaO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 May 2013 02:30:14 -0400
Received: by mail-oa0-f54.google.com with SMTP id j1so202037oag.13
        for <linux-media@vger.kernel.org>; Mon, 06 May 2013 23:30:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1367314149-16448-1-git-send-email-sachin.kamat@linaro.org>
References: <1367314149-16448-1-git-send-email-sachin.kamat@linaro.org>
Date: Tue, 7 May 2013 12:00:13 +0530
Message-ID: <CAK9yfHxqsb-Af3ESS2-ZChwF2xWPaJ4P66p2aKzU_T2P8+kx4A@mail.gmail.com>
Subject: Re: [PATCH 1/2] [media] soc_camera: Constify dev_pm_ops in mt9t031.c
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, sachin.kamat@linaro.org, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 30 April 2013 14:59, Sachin Kamat <sachin.kamat@linaro.org> wrote:
> Silences the following warning:
> WARNING: struct dev_pm_ops should normally be const
>
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
>  drivers/media/i2c/soc_camera/mt9t031.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/i2c/soc_camera/mt9t031.c b/drivers/media/i2c/soc_camera/mt9t031.c
> index 26a15b8..191e3f1 100644
> --- a/drivers/media/i2c/soc_camera/mt9t031.c
> +++ b/drivers/media/i2c/soc_camera/mt9t031.c
> @@ -595,7 +595,7 @@ static int mt9t031_runtime_resume(struct device *dev)
>         return 0;
>  }
>
> -static struct dev_pm_ops mt9t031_dev_pm_ops = {
> +static const struct dev_pm_ops mt9t031_dev_pm_ops = {
>         .runtime_suspend        = mt9t031_runtime_suspend,
>         .runtime_resume         = mt9t031_runtime_resume,
>  };
> --
> 1.7.9.5
>

ping..


-- 
With warm regards,
Sachin
