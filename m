Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:32885 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932627AbdAIJ2x (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 9 Jan 2017 04:28:53 -0500
Received: by mail-wm0-f66.google.com with SMTP id r144so11769676wme.0
        for <linux-media@vger.kernel.org>; Mon, 09 Jan 2017 01:28:52 -0800 (PST)
Reply-To: dmiosga6200@gmail.com
Subject: Re: astrometa device driver
To: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc: crope@iki.fi, mchehab@s-opensource.com,
        linux-media <linux-media@vger.kernel.org>
References: <5c13f750-52d1-e8bd-d8f1-f00b8ca6c794@gmail.com>
 <CAFBinCAmdCz5UhjY148EmKAwKo=RKwz3G+J=Wme4g3HO70mCpQ@mail.gmail.com>
 <3322ca41-8b4a-e0a1-95d7-79891b2899ce@gmail.com>
 <CAFBinCDXg3irVYk=g3LZHixdfmjciZetDozV=CvndVG6KfJ3rQ@mail.gmail.com>
From: Dieter Miosga <dmiosga6200@gmail.com>
Message-ID: <44ca0477-fd0f-cf62-53a8-71558375072a@gmail.com>
Date: Mon, 9 Jan 2017 10:29:50 +0000
MIME-Version: 1.0
In-Reply-To: <CAFBinCDXg3irVYk=g3LZHixdfmjciZetDozV=CvndVG6KfJ3rQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

That's a clear instruction and it seems that
not much more efforts above the code-cook level are required.
I already took a look at the cx231xx, umt-10  and other drivers
related to the predecessor HanfTek 15f4:0131, but from the first view
I could not derive such a procedure!

Will report back to you on any remarkable progress
Dieter

On 01/09/17 00:44, Martin Blumenstingl wrote:
> On Mon, Jan 9, 2017 at 1:45 AM, Dieter Miosga <dmiosga6200@gmail.com> wrote:
>> Here's the result of the lsusb on the HanfTek 15f4:0135
> This USB ID is not registered with the cx231xx driver yet - thus the
> driver simply ignores your device.
> The basics steps for adding support for your card would be:
> 1. add new "#define CX231XX_BOARD_..." in cx231xx.h
> 2. add new entry to cx231xx_boards[] in cx231xx-cards.c with the
> correct values (NOTE: has to figure out the correct values, maybe
> Antti can give a hint which of the existing boards could be used as
> staring point)
> 3. add a new entry to cx231xx_id_table (with USB vendor/device IDs) in
> cx231xx-cards.c
> 4. add r820t_config to cx231xx-dvb.c (maybe you can even copy the one
> from rtl28xxu.c)
> 5. add mn88473_config to cx231xx-dvb.c (again, copying the one from
> rtl28xxu.c may work)
> 6. add a new case statement to dvb_init in cx231xx-dvb.c and connect
> the rt820t_config and mn88473_config (you can probably use the code of
> another board and adapt it accordingly)
> 7. test + bugfix :)
>
>
> Regards,
> Martin
>

