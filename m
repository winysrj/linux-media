Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:64885 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608Ab2IOICQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Sep 2012 04:02:16 -0400
Received: by vbbff1 with SMTP id ff1so1383708vbb.19
        for <linux-media@vger.kernel.org>; Sat, 15 Sep 2012 01:02:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1345809975-20141-1-git-send-email-sachin.kamat@linaro.org>
References: <1345809975-20141-1-git-send-email-sachin.kamat@linaro.org>
Date: Sat, 15 Sep 2012 13:32:15 +0530
Message-ID: <CAK9yfHyySgxjNAPRG=m=Q0XOtcXizkAzS21_a-JhAZM-HoxW-g@mail.gmail.com>
Subject: Re: [PATCH] [media] mem2mem_testdev: Make m2mtest_dev_release
 function static
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, hans.verkuil@cisco.com,
	sachin.kamat@linaro.org, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ping...

On 24 August 2012 17:36, Sachin Kamat <sachin.kamat@linaro.org> wrote:
> Fixes the following warning:
> drivers/media/platform/mem2mem_testdev.c:73:6: warning:
> symbol 'm2mtest_dev_release' was not declared. Should it be static?
>
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
>  drivers/media/platform/mem2mem_testdev.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/media/platform/mem2mem_testdev.c b/drivers/media/platform/mem2mem_testdev.c
> index 0b496f3..771a84f 100644
> --- a/drivers/media/platform/mem2mem_testdev.c
> +++ b/drivers/media/platform/mem2mem_testdev.c
> @@ -70,7 +70,7 @@ MODULE_VERSION("0.1.1");
>         v4l2_dbg(1, 1, &dev->v4l2_dev, "%s: " fmt, __func__, ## arg)
>
>
> -void m2mtest_dev_release(struct device *dev)
> +static void m2mtest_dev_release(struct device *dev)
>  {}
>
>  static struct platform_device m2mtest_pdev = {
> --
> 1.7.4.1
>



-- 
With warm regards,
Sachin
