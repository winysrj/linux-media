Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f176.google.com ([209.85.220.176]:43073 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509Ab3EMJiH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 May 2013 05:38:07 -0400
Received: by mail-vc0-f176.google.com with SMTP id ib11so5185670vcb.7
        for <linux-media@vger.kernel.org>; Mon, 13 May 2013 02:38:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPgLHd92D618-a7H7=wjo1W=5JqYvPR4kSga3UcqW84n=n0POg@mail.gmail.com>
References: <CAPgLHd92D618-a7H7=wjo1W=5JqYvPR4kSga3UcqW84n=n0POg@mail.gmail.com>
Date: Mon, 13 May 2013 17:38:05 +0800
Message-ID: <CAHG8p1DOT9TD6pJiGB7gqmH2TbKBaSp1S_jj9fGjXaV0MmJ+ag@mail.gmail.com>
Subject: Re: [PATCH v2] [media] blackfin: fix error return code in bcap_probe()
From: Scott Jiang <scott.jiang.linux@gmail.com>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	yongjun_wei@trendmicro.com.cn,
	"uclinux-dist-devel@blackfin.uclinux.org"
	<uclinux-dist-devel@blackfin.uclinux.org>,
	LMML <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2013/5/13 Wei Yongjun <weiyj.lk@gmail.com>:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> Fix to return a negative error code from the error handling
> case instead of 0, as done elsewhere in this function.
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
> v1 -> v2: move config->num_inputs check to the beginning of this function
> ---
>  drivers/media/platform/blackfin/bfin_capture.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
> index 0e55b08..391d9a9 100644
> --- a/drivers/media/platform/blackfin/bfin_capture.c
> +++ b/drivers/media/platform/blackfin/bfin_capture.c
> @@ -960,7 +960,7 @@ static int bcap_probe(struct platform_device *pdev)
>         int ret;
>
>         config = pdev->dev.platform_data;
> -       if (!config) {
> +       if (!config || !config->num_inputs) {
>                 v4l2_err(pdev->dev.driver, "Unable to get board config\n");
>                 return -ENODEV;
>         }
> @@ -1067,11 +1067,6 @@ static int bcap_probe(struct platform_device *pdev)
>                                                  NULL);
>         if (bcap_dev->sd) {
>                 int i;
> -               if (!config->num_inputs) {
> -                       v4l2_err(&bcap_dev->v4l2_dev,
> -                                       "Unable to work without input\n");
> -                       goto err_unreg_vdev;
> -               }
>
>                 /* update tvnorms from the sub devices */
>                 for (i = 0; i < config->num_inputs; i++)
> @@ -1079,6 +1074,7 @@ static int bcap_probe(struct platform_device *pdev)
>         } else {
>                 v4l2_err(&bcap_dev->v4l2_dev,
>                                 "Unable to register sub device\n");
> +               ret = -ENODEV;
>                 goto err_unreg_vdev;
>         }
>
>

Acked-by: Scott Jiang <scott.jiang.linux@gmail.com>
