Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:35696 "EHLO
        mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754340AbcI1Sbx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Sep 2016 14:31:53 -0400
Received: by mail-oi0-f53.google.com with SMTP id w11so64332685oia.2
        for <linux-media@vger.kernel.org>; Wed, 28 Sep 2016 11:31:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1475075593-22123-1-git-send-email-weiyj.lk@gmail.com>
References: <1475075593-22123-1-git-send-email-weiyj.lk@gmail.com>
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Date: Wed, 28 Sep 2016 20:31:51 +0200
Message-ID: <CA+M3ks4FBd6sHZk=kJeRg4=j+=+pMZ5dX+oyTdJrng0gE7DP-A@mail.gmail.com>
Subject: Re: [PATCH -next] staging: media: stih-cec: remove unused including <linux/version.h>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wei Yongjun <weiyongjun1@huawei.com>, kernel@stlinux.com,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        devel@driverdev.osuosl.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Acked-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>

2016-09-28 17:13 GMT+02:00 Wei Yongjun <weiyj.lk@gmail.com>:
> From: Wei Yongjun <weiyongjun1@huawei.com>
>
> Remove including <linux/version.h> that don't need it.
>
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> ---
>  drivers/staging/media/st-cec/stih-cec.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/drivers/staging/media/st-cec/stih-cec.c b/drivers/staging/me=
dia/st-cec/stih-cec.c
> index 2143448..b0aee1d 100644
> --- a/drivers/staging/media/st-cec/stih-cec.c
> +++ b/drivers/staging/media/st-cec/stih-cec.c
> @@ -16,7 +16,6 @@
>  #include <linux/module.h>
>  #include <linux/of.h>
>  #include <linux/platform_device.h>
> -#include <linux/version.h>
>
>  #include <media/cec.h>
>



--=20
Benjamin Gaignard

Graphic Study Group

Linaro.org =E2=94=82 Open source software for ARM SoCs

Follow Linaro: Facebook | Twitter | Blog
