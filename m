Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:40991 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933633AbeAXNHy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 24 Jan 2018 08:07:54 -0500
Received: by mail-qt0-f193.google.com with SMTP id i1so10045071qtj.8
        for <linux-media@vger.kernel.org>; Wed, 24 Jan 2018 05:07:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180124074038.13275-1-mrkiko.rs@gmail.com>
References: <20180124074038.13275-1-mrkiko.rs@gmail.com>
From: =?UTF-8?Q?Honza_Petrou=C5=A1?= <jpetrous@gmail.com>
Date: Wed, 24 Jan 2018 14:07:52 +0100
Message-ID: <CAJbz7-0hBw_j8LXU5P=xTc2DQpNuU81S5BNub_TRkN2epQDhhA@mail.gmail.com>
Subject: Re: [PATCH] dib700: stop flooding system ring buffer
To: Enrico Mioso <mrkiko.rs@gmail.com>
Cc: linux-media@vger.kernel.org, Sean Young <sean@mess.org>,
        Piotr Oleszczyk <piotr.oleszczyk@gmail.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Enrico,

I'm not maintener, so treat next hints as hints only :)

2018-01-24 8:40 GMT+01:00 Enrico Mioso <mrkiko.rs@gmail.com>:
> Stop flooding system ring buffer with messages like:
> dib0700: stk7700ph_xc3028_callback: unknown command 2, arg 0
> while tuning an Asus My Cinema-U3000Hybrid dvb card.
>
> The correctness of this patch is opinable, but it's annoying me so much I
> sent it anyway.
>
> CC: linux-media@vger.kernel.org
> CC: Sean Young <sean@mess.org>
> CC: Piotr Oleszczyk <piotr.oleszczyk@gmail.com>
> CC: Andrey Konovalov <andreyknvl@google.com>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: Alexey Dobriyan <adobriyan@gmail.com>
> CC: Mauro Carvalho Chehab <mchehab@kernel.org>
> Signed-off-by: Enrico Mioso <mrkiko.rs@gmail.com>
> ---
>  drivers/media/usb/dvb-usb/dib0700_devices.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/media/usb/dvb-usb/dib0700_devices.c b/drivers/media/usb/dvb-usb/dib0700_devices.c
> index 366b05529915..bc5d250ed2f2 100644
> --- a/drivers/media/usb/dvb-usb/dib0700_devices.c
> +++ b/drivers/media/usb/dvb-usb/dib0700_devices.c
> @@ -432,8 +432,7 @@ static int stk7700ph_xc3028_callback(void *ptr, int component,
>         case XC2028_RESET_CLK:
>                 break;
>         default:
> -               err("%s: unknown command %d, arg %d\n", __func__,
> -                       command, arg);

May be change err() to debug() or something similar would be better?

> +               break;
>                 return -EINVAL;

Anyway it looks strange to break before return.

In both cases (w/ or w/o removal of message) I would stay
with -EINVAL for unknown command here.

>         }
>         return 0;
> --
> 2.16.1
>

/Honza
