Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:33079 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751658AbdINJQt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Sep 2017 05:16:49 -0400
MIME-Version: 1.0
In-Reply-To: <CAMuHMdU8A0dZR9RzeJ4Tz1gR4CYTc5A2Ni6r0D92q8ryDUpghw@mail.gmail.com>
References: <E1dY9S1-0004Ke-L1@www.linuxtv.org> <CAMuHMdU8A0dZR9RzeJ4Tz1gR4CYTc5A2Ni6r0D92q8ryDUpghw@mail.gmail.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 14 Sep 2017 11:16:48 +0200
Message-ID: <CAMuHMdW5p2LeA3DiEutpkaewGoqyi1UrWsUgPkDJB7XG7TsCvw@mail.gmail.com>
Subject: Re: [git:media_tree/master] media: adv7180: add missing adv7180cp,
 adv7180st i2c device IDs
To: stable <stable@vger.kernel.org>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>,
        Ulrich Hecht <ulrich.hecht+renesas@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Sep 13, 2017 at 10:50 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> On Thu, Jul 20, 2017 at 12:54 PM, Mauro Carvalho Chehab
> <mchehab@s-opensource.com> wrote:
>> This is an automatic generated email to let you know that the following patch were queued:
>>
>> Subject: media: adv7180: add missing adv7180cp, adv7180st i2c device IDs
>> Author:  Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
>> Date:    Mon Jul 3 04:43:33 2017 -0400
>>
>> Fixes a crash on Renesas R8A7793 Gose board that uses these "compatible"
>> entries.
>>
>> Signed-off-by: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
>> Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
>
> Fixes: ce1ec5c07e0671cc ("[media] media: adv7180: add adv7180cp,
> adv7180st compatible strings")
>
> This fix is now upstream, as commit 281ddc3cdc10413b ("media: adv7180: add
> missing adv7180cp, adv7180st i2c device IDs").
>
> Greg: Can you please backport it to v3.14.x?

Oops, v4.13.x, of course. The \pi-line is dead...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
