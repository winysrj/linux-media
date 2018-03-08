Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:43830 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934577AbeCHI3a (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Mar 2018 03:29:30 -0500
MIME-Version: 1.0
In-Reply-To: <20180307230209.GB2205@bigcity.dyn.berto.se>
References: <20180307225816.9801-1-niklas.soderlund+renesas@ragnatech.se> <20180307230209.GB2205@bigcity.dyn.berto.se>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 8 Mar 2018 09:29:29 +0100
Message-ID: <CAMuHMdV_e8o9BrrjhrXM1CVgXyNTRCrUmt0NwVU2N=qkzavqkg@mail.gmail.com>
Subject: Re: [PATCH v2] i2c: adv748x: afe: fix sparse warning
To: =?UTF-8?Q?Niklas_S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Mar 8, 2018 at 12:02 AM, Niklas S=C3=B6derlund
<niklas.soderlund@ragnatech.se> wrote:
> CC linux-media.
>
> It's linux-media@vger.kernel.org not linux-media@vger.kernel.or, sorry
> for the noise.
>
> On 2018-03-07 23:58:16 +0100, Niklas S=C3=B6derlund wrote:
>> This fixes the following sparse warning:
>>
>> drivers/media/i2c/adv748x/adv748x-afe.c:294:34:    expected unsigned int=
 [usertype] *signal
>> drivers/media/i2c/adv748x/adv748x-afe.c:294:34:    got int *<noident>
>> drivers/media/i2c/adv748x/adv748x-afe.c:294:34: warning: incorrect type =
in argument 2 (different signedness)
>>
>> Signed-off-by: Niklas S=C3=B6derlund <niklas.soderlund+renesas@ragnatech=
.se>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k=
.org

In personal conversations with technical people, I call myself a hacker. Bu=
t
when I'm talking to journalists I just say "programmer" or something like t=
hat.
                                -- Linus Torvalds
