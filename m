Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:62901 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089Ab2LCGAx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Dec 2012 01:00:53 -0500
Received: by mail-oa0-f46.google.com with SMTP id h16so2307924oag.19
        for <linux-media@vger.kernel.org>; Sun, 02 Dec 2012 22:00:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAPgLHd_6Jnu5x0rEwVr-3Uw04f1MjB96AVQ1KAWFSoeCB2Gupg@mail.gmail.com>
References: <CAPgLHd_6Jnu5x0rEwVr-3Uw04f1MjB96AVQ1KAWFSoeCB2Gupg@mail.gmail.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Mon, 3 Dec 2012 11:30:32 +0530
Message-ID: <CA+V-a8t7w2TcyxO6ZPbpp3hV82e1592B7-32fOWt_tVLjvJWGw@mail.gmail.com>
Subject: Re: [PATCH -next] [media] davinci: vpbe: remove unused variable in vpbe_initialize()
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: manjunath.hadli@ti.com, prabhakar.lad@ti.com, mchehab@redhat.com,
	yongjun_wei@trendmicro.com.cn,
	davinci-linux-open-source@linux.davincidsp.com,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Wei,

Thanks for the patch.

On Mon, Dec 3, 2012 at 8:23 AM, Wei Yongjun <weiyj.lk@gmail.com> wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> The variable 'output_index' is initialized but never used
> otherwise, so remove the unused variable.
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Acked-by: Prabhakar Lad <prabhakar.lad@ti.com>

Regards,
--Prabhakar

> ---
>  drivers/media/platform/davinci/vpbe.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/drivers/media/platform/davinci/vpbe.c b/drivers/media/platform/davinci/vpbe.c
> index 7f5cf9b..e0c79c1 100644
> --- a/drivers/media/platform/davinci/vpbe.c
> +++ b/drivers/media/platform/davinci/vpbe.c
> @@ -584,7 +584,6 @@ static int vpbe_initialize(struct device *dev, struct vpbe_device *vpbe_dev)
>         struct v4l2_subdev **enc_subdev;
>         struct osd_state *osd_device;
>         struct i2c_adapter *i2c_adap;
> -       int output_index;
>         int num_encoders;
>         int ret = 0;
>         int err;
> @@ -731,7 +730,6 @@ static int vpbe_initialize(struct device *dev, struct vpbe_device *vpbe_dev)
>         /* set the current encoder and output to that of venc by default */
>         vpbe_dev->current_sd_index = 0;
>         vpbe_dev->current_out_index = 0;
> -       output_index = 0;
>
>         mutex_unlock(&vpbe_dev->lock);
>
>
>
> _______________________________________________
> Davinci-linux-open-source mailing list
> Davinci-linux-open-source@linux.davincidsp.com
> http://linux.davincidsp.com/mailman/listinfo/davinci-linux-open-source
