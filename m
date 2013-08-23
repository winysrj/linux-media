Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f181.google.com ([209.85.220.181]:60823 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754394Ab3HWDVA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Aug 2013 23:21:00 -0400
Received: by mail-vc0-f181.google.com with SMTP id hz10so76447vcb.26
        for <linux-media@vger.kernel.org>; Thu, 22 Aug 2013 20:20:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPgLHd-0+fYLMh+Ff+cgewBPy1itjp-EtbAjzs5UrJsqrY3aNg@mail.gmail.com>
References: <CAPgLHd-0+fYLMh+Ff+cgewBPy1itjp-EtbAjzs5UrJsqrY3aNg@mail.gmail.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Fri, 23 Aug 2013 08:50:39 +0530
Message-ID: <CA+V-a8szUWiURmmuWReyH1xWSheyn9COOgdGkfFTSkbOPh44FQ@mail.gmail.com>
Subject: Re: [PATCH -next] [media] davinci: vpif_capture: fix error return
 code in vpif_probe()
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
	linux-media <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Wei,

I retract my Ack.

On Fri, Aug 23, 2013 at 8:30 AM, Wei Yongjun <weiyj.lk@gmail.com> wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> Fix to return -ENODEV in the subdevice register error handling
> case instead of 0, as done elsewhere in this function.
>
> Introduced by commit 873229e4fdf34196aa5d707957c59ba54c25eaba
> ([media] media: davinci: vpif: capture: add V4L2-async support)
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  drivers/media/platform/davinci/vpif_capture.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
> index 7fbde6d..e4b6a26 100644
> --- a/drivers/media/platform/davinci/vpif_capture.c
> +++ b/drivers/media/platform/davinci/vpif_capture.c
> @@ -2160,6 +2160,7 @@ static __init int vpif_probe(struct platform_device *pdev)
>
>                         if (!vpif_obj.sd[i]) {
>                                 vpif_err("Error registering v4l2 subdevice\n");
> +                               err = -ENOMEM;

This should be err = -ENODEV

Regards,
--Prabhakar Lad
