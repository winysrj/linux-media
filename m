Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f178.google.com ([209.85.216.178]:33306 "EHLO
        mail-qt0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751779AbcJRHwm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Oct 2016 03:52:42 -0400
Received: by mail-qt0-f178.google.com with SMTP id s49so142051386qta.0
        for <linux-media@vger.kernel.org>; Tue, 18 Oct 2016 00:52:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1476719053-17600-6-git-send-email-javier@osg.samsung.com>
References: <1476719053-17600-1-git-send-email-javier@osg.samsung.com> <1476719053-17600-6-git-send-email-javier@osg.samsung.com>
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Date: Tue, 18 Oct 2016 09:52:41 +0200
Message-ID: <CA+M3ks6ok-Xmn518-vpTiUPJCEThu+t7auAVKwDwQnt-A-Uh4A@mail.gmail.com>
Subject: Re: [PATCH 5/5] [media] st-cec: Fix module autoload
To: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        devel@driverdev.osuosl.org, kernel@stlinux.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks,

Acked-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>

2016-10-17 17:44 GMT+02:00 Javier Martinez Canillas <javier@osg.samsung.com=
>:
> If the driver is built as a module, autoload won't work because the modul=
e
> alias information is not filled. So user-space can't match the registered
> device with the corresponding module.
>
> Export the module alias information using the MODULE_DEVICE_TABLE() macro=
.
>
> Before this patch:
>
> $ modinfo drivers/staging/media//st-cec/stih-cec.ko | grep alias
> $
>
> After this patch:
>
> $ modinfo drivers/staging/media//st-cec/stih-cec.ko | grep alias
> alias:          of:N*T*Cst,stih-cecC*
> alias:          of:N*T*Cst,stih-cec
>
> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
>
> ---
>
>  drivers/staging/media/st-cec/stih-cec.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/staging/media/st-cec/stih-cec.c b/drivers/staging/me=
dia/st-cec/stih-cec.c
> index 214344866a6b..19d3ff30c8f8 100644
> --- a/drivers/staging/media/st-cec/stih-cec.c
> +++ b/drivers/staging/media/st-cec/stih-cec.c
> @@ -363,6 +363,7 @@ static const struct of_device_id stih_cec_match[] =3D=
 {
>         },
>         {},
>  };
> +MODULE_DEVICE_TABLE(of, stih_cec_match);
>
>  static struct platform_driver stih_cec_pdrv =3D {
>         .probe  =3D stih_cec_probe,
> --
> 2.7.4
>



--=20
Benjamin Gaignard

Graphic Study Group

Linaro.org =E2=94=82 Open source software for ARM SoCs

Follow Linaro: Facebook | Twitter | Blog
