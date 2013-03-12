Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:39462 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754198Ab3CLEmn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Mar 2013 00:42:43 -0400
Received: by mail-wi0-f174.google.com with SMTP id hi8so1492860wib.13
        for <linux-media@vger.kernel.org>; Mon, 11 Mar 2013 21:42:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPgLHd80DXpcUmY69Vcc72ALGh3LrSGPakm0iBeXNUqLY-+Nxg@mail.gmail.com>
References: <CAPgLHd80DXpcUmY69Vcc72ALGh3LrSGPakm0iBeXNUqLY-+Nxg@mail.gmail.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Tue, 12 Mar 2013 10:12:22 +0530
Message-ID: <CA+V-a8sxCACzpm1v-daH84rwCfX776dzFXJSTm2mu1A0JSsfmw@mail.gmail.com>
Subject: Re: [PATCH -next] [media] davinci: vpfe: fix return value check in vpfe_enable_clock()
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: mchehab@redhat.com, gregkh@linuxfoundation.org,
	sakari.ailus@iki.fi, laurent.pinchart@ideasonboard.com,
	hans.verkuil@cisco.com, yongjun_wei@trendmicro.com.cn,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
	dlos <davinci-linux-open-source@linux.davincidsp.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Wei,

Thanks for the patch! I'll queue it up for v3.10

On Mon, Mar 11, 2013 at 7:27 PM, Wei Yongjun <weiyj.lk@gmail.com> wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> In case of error, the function clk_get() returns ERR_PTR()
> and never returns NULL. The NULL test in the return value
> check should be replaced with IS_ERR().
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Regards,
--Prabhakar Lad

> ---
>  drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c b/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c
> index 7b35171..6a8222c 100644
> --- a/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c
> +++ b/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c
> @@ -243,7 +243,7 @@ static int vpfe_enable_clock(struct vpfe_device *vpfe_dev)
>
>                 vpfe_dev->clks[i] =
>                                 clk_get(vpfe_dev->pdev, vpfe_cfg->clocks[i]);
> -               if (vpfe_dev->clks[i] == NULL) {
> +               if (IS_ERR(vpfe_dev->clks[i])) {
>                         v4l2_err(vpfe_dev->pdev->driver,
>                                 "Failed to get clock %s\n",
>                                 vpfe_cfg->clocks[i]);
> @@ -264,7 +264,7 @@ static int vpfe_enable_clock(struct vpfe_device *vpfe_dev)
>         return 0;
>  out:
>         for (i = 0; i < vpfe_cfg->num_clocks; i++)
> -               if (vpfe_dev->clks[i]) {
> +               if (!IS_ERR(vpfe_dev->clks[i])) {
>                         clk_disable_unprepare(vpfe_dev->clks[i]);
>                         clk_put(vpfe_dev->clks[i]);
>                 }
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
