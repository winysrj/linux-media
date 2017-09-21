Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:47367 "EHLO
        mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751951AbdIUOAW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Sep 2017 10:00:22 -0400
Received: by mail-io0-f176.google.com with SMTP id e189so11089430ioa.4
        for <linux-media@vger.kernel.org>; Thu, 21 Sep 2017 07:00:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170921084018.30510-1-johan@kernel.org>
References: <20170921083739.GI3198@localhost> <20170921084018.30510-1-johan@kernel.org>
From: Andrey Konovalov <andreyknvl@google.com>
Date: Thu, 21 Sep 2017 16:00:20 +0200
Message-ID: <CAAeHK+zx-E+4LR95WNwuuMqZQrZANMNxKHtg6P_QMsBGzJ=t+w@mail.gmail.com>
Subject: Re: [PATCH] [media] cx231xx-cards: fix NULL-deref on missing
 association descriptor
To: Johan Hovold <johan@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Oleh Kravchenko <oleg@kaa.org.ua>, linux-media@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Kostya Serebryany <kcc@google.com>,
        syzkaller <syzkaller@googlegroups.com>,
        stable <stable@vger.kernel.org>,
        Sri Deevi <Srinivasa.Deevi@conexant.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Sep 21, 2017 at 10:40 AM, Johan Hovold <johan@kernel.org> wrote:
> Make sure to check that we actually have an Interface Association
> Descriptor before dereferencing it during probe to avoid dereferencing a
> NULL-pointer.
>
> Fixes: e0d3bafd0258 ("V4L/DVB (10954): Add cx231xx USB driver")
> Cc: stable <stable@vger.kernel.org>     # 2.6.30
> Cc: Sri Deevi <Srinivasa.Deevi@conexant.com>
> Reported-by: Andrey Konovalov <andreyknvl@google.com>
> Signed-off-by: Johan Hovold <johan@kernel.org>

Tested-by: Andrey Konovalov <andreyknvl@google.com>

Thanks!

> ---
>  drivers/media/usb/cx231xx/cx231xx-cards.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
> index e0daa9b6c2a0..9b742d569fb5 100644
> --- a/drivers/media/usb/cx231xx/cx231xx-cards.c
> +++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
> @@ -1684,7 +1684,7 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
>         nr = dev->devno;
>
>         assoc_desc = udev->actconfig->intf_assoc[0];
> -       if (assoc_desc->bFirstInterface != ifnum) {
> +       if (!assoc_desc || assoc_desc->bFirstInterface != ifnum) {
>                 dev_err(d, "Not found matching IAD interface\n");
>                 retval = -ENODEV;
>                 goto err_if;
> --
> 2.14.1
>
