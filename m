Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:44570 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751385AbeBLNm6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Feb 2018 08:42:58 -0500
Received: by mail-qk0-f194.google.com with SMTP id n188so18369692qkn.11
        for <linux-media@vger.kernel.org>; Mon, 12 Feb 2018 05:42:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <0cb9a05c09295bcad4dd914ee44806ac6c244cbd.1516008708.git.sean@mess.org>
References: <cover.1516008708.git.sean@mess.org> <0cb9a05c09295bcad4dd914ee44806ac6c244cbd.1516008708.git.sean@mess.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 12 Feb 2018 14:42:57 +0100
Message-ID: <CANiq72nNX1aRZEfzLBZxfPC7CVk0ts6Q_5o8a9_9B0DWSzj4-A@mail.gmail.com>
Subject: Re: [PATCH 1/5] auxdisplay: charlcd: no need to call charlcd_gotoxy()
 if nothing changes
To: Sean Young <sean@mess.org>, Willy Tarreau <w@1wt.eu>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 15, 2018 at 10:58 AM, Sean Young <sean@mess.org> wrote:
> If the line extends beyond the width to the screen, nothing changes. The
> existing code will call charlcd_gotoxy every time for this case.
>
> Signed-off-by: Sean Young <sean@mess.org>
> ---
>  drivers/auxdisplay/charlcd.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/auxdisplay/charlcd.c b/drivers/auxdisplay/charlcd.c
> index 642afd88870b..45ec5ce697c4 100644
> --- a/drivers/auxdisplay/charlcd.c
> +++ b/drivers/auxdisplay/charlcd.c
> @@ -192,10 +192,11 @@ static void charlcd_print(struct charlcd *lcd, char c)
>                         c = lcd->char_conv[(unsigned char)c];
>                 lcd->ops->write_data(lcd, c);
>                 priv->addr.x++;
> +
> +               /* prevents the cursor from wrapping onto the next line */
> +               if (priv->addr.x == lcd->bwidth)
> +                       charlcd_gotoxy(lcd);
>         }
> -       /* prevents the cursor from wrapping onto the next line */
> -       if (priv->addr.x == lcd->bwidth)
> -               charlcd_gotoxy(lcd);
>  }
>

Willy, Geert: is this fine with you? Seems fine: charlcd_write_char()
right now does an unconditional write_cmd() when writing a normal
character; so unless some HW requires the command for some reason even
if there is nothing changed, we can skip it.

>  static void charlcd_clear_fast(struct charlcd *lcd)
> --
> 2.14.3
>
