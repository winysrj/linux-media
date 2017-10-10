Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:53689 "EHLO
        mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751826AbdJJL0z (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Oct 2017 07:26:55 -0400
Received: by mail-oi0-f54.google.com with SMTP id j126so44534778oia.10
        for <linux-media@vger.kernel.org>; Tue, 10 Oct 2017 04:26:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <71782d84353db85a9fb9e45ac09f1c2b53c5a04a.1507572539.git.arvind.yadav.cs@gmail.com>
References: <71782d84353db85a9fb9e45ac09f1c2b53c5a04a.1507572539.git.arvind.yadav.cs@gmail.com>
From: Andrey Konovalov <andreyknvl@google.com>
Date: Tue, 10 Oct 2017 13:26:54 +0200
Message-ID: <CAAeHK+wW1VzmHgr9n+MNyU8vig6xUQj12afPtTGcNECxjtkrRQ@mail.gmail.com>
Subject: Re: [PATCH] media: imon: Fix null-ptr-deref in imon_probe
To: Arvind Yadav <arvind.yadav.cs@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sean Young <sean@mess.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Andi Shyti <andi.shyti@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Dmitry Vyukov <dvyukov@google.com>,
        Kostya Serebryany <kcc@google.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-media@vger.kernel.org,
        syzkaller <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 9, 2017 at 8:14 PM, Arvind Yadav <arvind.yadav.cs@gmail.com> wrote:
> It seems that the return value of usb_ifnum_to_if() can be NULL and
> needs to be checked.

Hi Arvind,

Your patch fixes the issue.

Thanks!

Tested-by: Andrey Konovalov <andreyknvl@google.com>

>
> Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
> ---
> This bug report by Andrey Konovalov usb/media/imon: null-ptr-deref
> in imon_probe
>
>  drivers/media/rc/imon.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
> index 7b3f31c..0c46155 100644
> --- a/drivers/media/rc/imon.c
> +++ b/drivers/media/rc/imon.c
> @@ -2517,6 +2517,11 @@ static int imon_probe(struct usb_interface *interface,
>         mutex_lock(&driver_lock);
>
>         first_if = usb_ifnum_to_if(usbdev, 0);
> +       if (!first_if) {
> +               ret = -ENODEV;
> +               goto fail;
> +       }
> +
>         first_if_ctx = usb_get_intfdata(first_if);
>
>         if (ifnum == 0) {
> --
> 2.7.4
>
