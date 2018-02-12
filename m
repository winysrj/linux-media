Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:39862 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751441AbeBLUoD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Feb 2018 15:44:03 -0500
Received: by mail-qt0-f195.google.com with SMTP id f4so1155497qtj.6
        for <linux-media@vger.kernel.org>; Mon, 12 Feb 2018 12:44:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <cdfa0d36f2f2d306e0824205b4fca0b685991ee9.1516008708.git.sean@mess.org>
References: <cover.1516008708.git.sean@mess.org> <cdfa0d36f2f2d306e0824205b4fca0b685991ee9.1516008708.git.sean@mess.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 12 Feb 2018 21:44:02 +0100
Message-ID: <CANiq72kfqf+nhioH7nGPPsFh9PU7NsGLy+8bD7oXNiLCWx6ZeQ@mail.gmail.com>
Subject: Re: [PATCH 2/5] auxdisplay: charlcd: add flush function
To: Sean Young <sean@mess.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg KH <gregkh@linuxfoundation.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 15, 2018 at 10:58 AM, Sean Young <sean@mess.org> wrote:
> The Sasem Remote Controller has an LCD, which is connnected via usb.
> Multiple write reg or write data commands can be combined into one usb
> packet.
>
> The latency of usb is such that if we send commands one by one, we get
> very obvious tearing on the LCD.
>
> By adding a flush function, we can buffer all commands until either
> the usb packet is full or the lcd changes are complete.
>
> Signed-off-by: Sean Young <sean@mess.org>
> ---
>  drivers/auxdisplay/charlcd.c | 6 ++++++

Cc'ing Arnd and Greg since this touches include/misc as well.

Miguel

>  include/misc/charlcd.h       | 1 +
>  2 files changed, 7 insertions(+)
>
> diff --git a/drivers/auxdisplay/charlcd.c b/drivers/auxdisplay/charlcd.c
> index 45ec5ce697c4..a16c72779722 100644
> --- a/drivers/auxdisplay/charlcd.c
> +++ b/drivers/auxdisplay/charlcd.c
> @@ -642,6 +642,9 @@ static ssize_t charlcd_write(struct file *file, const char __user *buf,
>                 charlcd_write_char(the_charlcd, c);
>         }
>
> +       if (the_charlcd->ops->flush)
> +               the_charlcd->ops->flush(the_charlcd);
> +
>         return tmp - buf;
>  }
>
> @@ -703,6 +706,9 @@ static void charlcd_puts(struct charlcd *lcd, const char *s)
>
>                 charlcd_write_char(lcd, *tmp);
>         }
> +
> +       if (lcd->ops->flush)
> +               lcd->ops->flush(lcd);
>  }
>
>  /* initialize the LCD driver */
> diff --git a/include/misc/charlcd.h b/include/misc/charlcd.h
> index 23f61850f363..ff8fd456018e 100644
> --- a/include/misc/charlcd.h
> +++ b/include/misc/charlcd.h
> @@ -32,6 +32,7 @@ struct charlcd_ops {
>         void (*write_cmd_raw4)(struct charlcd *lcd, int cmd);   /* 4-bit only */
>         void (*clear_fast)(struct charlcd *lcd);
>         void (*backlight)(struct charlcd *lcd, int on);
> +       void (*flush)(struct charlcd *lcd);
>  };
>
>  struct charlcd *charlcd_alloc(unsigned int drvdata_size);
> --
> 2.14.3
>
