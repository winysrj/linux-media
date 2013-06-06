Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f171.google.com ([209.85.214.171]:45609 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753972Ab3FFGpk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Jun 2013 02:45:40 -0400
Received: by mail-ob0-f171.google.com with SMTP id dn14so4105189obc.16
        for <linux-media@vger.kernel.org>; Wed, 05 Jun 2013 23:45:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1370005408-10853-8-git-send-email-arun.kk@samsung.com>
References: <1370005408-10853-1-git-send-email-arun.kk@samsung.com>
	<1370005408-10853-8-git-send-email-arun.kk@samsung.com>
Date: Thu, 6 Jun 2013 12:15:39 +0530
Message-ID: <CAK9yfHyu3rh-pRB5G2E2-WLxbEiZ=DZN5HCgYgCA7XTTG1AwSQ@mail.gmail.com>
Subject: Re: [RFC v2 07/10] exynos5-fimc-is: Adds scaler subdev
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Arun Kumar K <arun.kk@samsung.com>
Cc: linux-media@vger.kernel.org, s.nawrocki@samsung.com,
	kilyeon.im@samsung.com, shaik.ameer@samsung.com,
	arunkk.samsung@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 31 May 2013 18:33, Arun Kumar K <arun.kk@samsung.com> wrote:
> FIMC-IS has two hardware scalers named as scaler-codec and
> scaler-preview. This patch adds the common code handling the
> video nodes and subdevs of both the scalers.
>
> Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
> Signed-off-by: Kilyeon Im <kilyeon.im@samsung.com>
> ---

[snip]

> +static int scaler_video_capture_open(struct file *file)
> +{
> +       struct fimc_is_scaler *ctx = video_drvdata(file);
> +       int ret = 0;
> +
> +       /* Check if opened before */
> +       if (ctx->refcount >= FIMC_IS_MAX_INSTANCES) {
> +               pr_err("All instances are in use.\n");
> +               return -EBUSY;
> +       }
> +
> +       INIT_LIST_HEAD(&ctx->wait_queue);
> +       ctx->wait_queue_cnt = 0;
> +       INIT_LIST_HEAD(&ctx->run_queue);
> +       ctx->run_queue_cnt = 0;
> +
> +       ctx->fmt = NULL;
> +       ctx->refcount++;
> +
> +       return ret;

Directly return 0.

> +}
> +
> +static int scaler_video_capture_close(struct file *file)
> +{
> +       struct fimc_is_scaler *ctx = video_drvdata(file);
> +       int ret = 0;
> +
> +       ctx->refcount--;
> +       ctx->capture_state = 0;
> +       vb2_fop_release(file);
> +
> +       return ret;

ditto

-- 
With warm regards,
Sachin
