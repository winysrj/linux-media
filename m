Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:40703 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751200AbeBLRaR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Feb 2018 12:30:17 -0500
Received: by mail-qt0-f196.google.com with SMTP id c19so468927qtm.7
        for <linux-media@vger.kernel.org>; Mon, 12 Feb 2018 09:30:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAMuHMdVXWQ4JzFAy52-o7CcyO2pz-f7eF0q2kYWvE8kJL_Q_Bw@mail.gmail.com>
References: <cover.1516008708.git.sean@mess.org> <0cb9a05c09295bcad4dd914ee44806ac6c244cbd.1516008708.git.sean@mess.org>
 <CANiq72nNX1aRZEfzLBZxfPC7CVk0ts6Q_5o8a9_9B0DWSzj4-A@mail.gmail.com> <CAMuHMdVXWQ4JzFAy52-o7CcyO2pz-f7eF0q2kYWvE8kJL_Q_Bw@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 12 Feb 2018 18:30:16 +0100
Message-ID: <CANiq72ny6ySP9kdL8GY9TRwA+MSxMpwxBk0cDZuEpy36w+srkA@mail.gmail.com>
Subject: Re: [PATCH 1/5] auxdisplay: charlcd: no need to call charlcd_gotoxy()
 if nothing changes
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Sean Young <sean@mess.org>, Willy Tarreau <w@1wt.eu>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Feb 12, 2018 at 2:59 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> On Mon, Feb 12, 2018 at 2:42 PM, Miguel Ojeda
> <miguel.ojeda.sandonis@gmail.com> wrote:
>> On Mon, Jan 15, 2018 at 10:58 AM, Sean Young <sean@mess.org> wrote:
>>> If the line extends beyond the width to the screen, nothing changes. The
>>> existing code will call charlcd_gotoxy every time for this case.
>>>
>>> Signed-off-by: Sean Young <sean@mess.org>
>>> ---
>>>  drivers/auxdisplay/charlcd.c | 7 ++++---
>>>  1 file changed, 4 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/auxdisplay/charlcd.c b/drivers/auxdisplay/charlcd.c
>>> index 642afd88870b..45ec5ce697c4 100644
>>> --- a/drivers/auxdisplay/charlcd.c
>>> +++ b/drivers/auxdisplay/charlcd.c
>>> @@ -192,10 +192,11 @@ static void charlcd_print(struct charlcd *lcd, char c)
>>>                         c = lcd->char_conv[(unsigned char)c];
>>>                 lcd->ops->write_data(lcd, c);
>>>                 priv->addr.x++;
>>> +
>>> +               /* prevents the cursor from wrapping onto the next line */
>>> +               if (priv->addr.x == lcd->bwidth)
>>> +                       charlcd_gotoxy(lcd);
>>>         }
>>> -       /* prevents the cursor from wrapping onto the next line */
>>> -       if (priv->addr.x == lcd->bwidth)
>>> -               charlcd_gotoxy(lcd);
>>>  }
>>>
>>
>> Willy, Geert: is this fine with you? Seems fine: charlcd_write_char()
>> right now does an unconditional write_cmd() when writing a normal
>> character; so unless some HW requires the command for some reason even
>> if there is nothing changed, we can skip it.
>
> Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
>

Thanks a lot, picking it up then.

Miguel

> Gr{oetje,eeting}s,
>
>                         Geert
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
>
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
