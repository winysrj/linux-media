Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg1-f193.google.com ([209.85.215.193]:44772 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390693AbeIUWsi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Sep 2018 18:48:38 -0400
Received: by mail-pg1-f193.google.com with SMTP id r1-v6so6312050pgp.11
        for <linux-media@vger.kernel.org>; Fri, 21 Sep 2018 09:58:53 -0700 (PDT)
MIME-Version: 1.0
References: <20180921100045.20181-1-natechancellor@gmail.com>
In-Reply-To: <20180921100045.20181-1-natechancellor@gmail.com>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Fri, 21 Sep 2018 09:58:41 -0700
Message-ID: <CAKwvOdk+u1EeREHkhtOGg9Didg6ibppz5Od8Txp7EnMw05gtFA@mail.gmail.com>
Subject: Re: [PATCH] media: pxa_camera: Fix check for pdev->dev.of_node
To: Nathan Chancellor <natechancellor@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Sep 21, 2018 at 3:00 AM Nathan Chancellor
<natechancellor@gmail.com> wrote:
>
> Clang warns that the address of a pointer will always evaluated as true
> in a boolean context.
>
> drivers/media/platform/pxa_camera.c:2400:17: warning: address of
> 'pdev->dev.of_node' will always evaluate to 'true'
> [-Wpointer-bool-conversion]
>         if (&pdev->dev.of_node && !pcdev->pdata) {
>              ~~~~~~~~~~^~~~~~~ ~~
> 1 warning generated.
>
> Judging from the rest of the kernel, it seems like this was an error and
> just the value of of_node should be checked rather than the address.
>
> Reported-by: Nick Desaulniers <ndesaulniers@google.com>
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> ---
>  drivers/media/platform/pxa_camera.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/platform/pxa_camera.c b/drivers/media/platform/pxa_camera.c
> index 3288d22de2a0..6717834e8041 100644
> --- a/drivers/media/platform/pxa_camera.c
> +++ b/drivers/media/platform/pxa_camera.c
> @@ -2397,7 +2397,7 @@ static int pxa_camera_probe(struct platform_device *pdev)
>         pcdev->res = res;
>
>         pcdev->pdata = pdev->dev.platform_data;
> -       if (&pdev->dev.of_node && !pcdev->pdata) {
> +       if (pdev->dev.of_node && !pcdev->pdata) {

pdev->dev.of_node is a `struct device_node *`, so this is the correct
way to check that it's not NULL.  It's use in
pxa_camera_pdata_from_dt() is necessitated on the caller checking that
it's not NULL.

Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

>                 err = pxa_camera_pdata_from_dt(&pdev->dev, pcdev, &pcdev->asd);
>         } else {
>                 pcdev->platform_flags = pcdev->pdata->flags;
> --
> 2.19.0
>


-- 
Thanks,
~Nick Desaulniers
