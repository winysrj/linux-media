Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:56799 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751825AbdJXLmq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Oct 2017 07:42:46 -0400
Received: by mail-oi0-f67.google.com with SMTP id v9so36239251oif.13
        for <linux-media@vger.kernel.org>; Tue, 24 Oct 2017 04:42:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <0ade6e417fbf2cd119aa1f2345f88a3810c03e11.1508844352.git.arvind.yadav.cs@gmail.com>
References: <0ade6e417fbf2cd119aa1f2345f88a3810c03e11.1508844352.git.arvind.yadav.cs@gmail.com>
From: Andrey Konovalov <andreyknvl@google.com>
Date: Tue, 24 Oct 2017 13:42:45 +0200
Message-ID: <CAAeHK+yU10k0ESZj2axpOCzC-7P9tq4oF2Z5-_7NpRN47JOJVA@mail.gmail.com>
Subject: Re: [RFT] media: dvb_frontend: Fix use-after-free in __dvb_frontend_free
To: Arvind Yadav <arvind.yadav.cs@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Max Kellermann <max.kellermann@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Colin Ian King <colin.king@canonical.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Kostya Serebryany <kcc@google.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-media@vger.kernel.org,
        syzkaller <syzkaller@googlegroups.com>,
        Matthias Schwarzott <zzam@gentoo.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Oct 24, 2017 at 1:36 PM, Arvind Yadav <arvind.yadav.cs@gmail.com> wrote:
> Here, dvb_free_device will free dvb_device. dvb_frontend_invoke_release
> is using  dvb_device after free.

Hi Arvind,

Matthias already suggested a fix. Also it looks like your patch is
based on an outdated tree, which doesn't contain the commit that seems
to have caused the bug (ead666000a5fe34bdc82d61838e4df2d416ea15e).

Thanks!

>
> Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
> ---
> This bug report by Andrey Konovalov (usb/media/dtt200u: use-after-free
> in __dvb_frontend_free).
>
>  drivers/media/dvb-core/dvb_frontend.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
> index 2fcba16..7f1ef12 100644
> --- a/drivers/media/dvb-core/dvb_frontend.c
> +++ b/drivers/media/dvb-core/dvb_frontend.c
> @@ -147,10 +147,10 @@ static void dvb_frontend_free(struct kref *ref)
>                 container_of(ref, struct dvb_frontend, refcount);
>         struct dvb_frontend_private *fepriv = fe->frontend_priv;
>
> -       dvb_free_device(fepriv->dvbdev);
> -
>         dvb_frontend_invoke_release(fe, fe->ops.release);
>
> +       dvb_free_device(fepriv->dvbdev);
> +
>         kfree(fepriv);
>  }
>
> --
> 1.9.1
>
