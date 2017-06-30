Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f196.google.com ([209.85.217.196]:35046 "EHLO
        mail-ua0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751649AbdF3KtI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Jun 2017 06:49:08 -0400
Received: by mail-ua0-f196.google.com with SMTP id j53so8418611uaa.2
        for <linux-media@vger.kernel.org>; Fri, 30 Jun 2017 03:49:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAK8P3a387vRR3ib_tAGw+zrfNWePuoKg8h1CGb4HLY4S8D65Uw@mail.gmail.com>
References: <1498815176-16108-1-git-send-email-prabhakar.csengg@gmail.com> <CAK8P3a387vRR3ib_tAGw+zrfNWePuoKg8h1CGb4HLY4S8D65Uw@mail.gmail.com>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Fri, 30 Jun 2017 11:48:36 +0100
Message-ID: <CA+V-a8v26_BK8vwvyP5vhSUtuWbRBe7pThMaKt_fi-G4uUWTmA@mail.gmail.com>
Subject: Re: [PATCH] media: platform: davinci: drop VPFE_CMD_S_CCDC_RAW_PARAMS
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sekhar Nori <nsekhar@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arnd,

On Fri, Jun 30, 2017 at 11:03 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Fri, Jun 30, 2017 at 11:32 AM, Prabhakar <prabhakar.csengg@gmail.com> =
wrote:
>> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
>>
>> For dm355 and dm644x the vpfe driver provided a ioctl to
>> configure the raw bayer config using a IOCTL, but since
>> the code was not properly implemented and aswell the
>> IOCTL was marked as 'experimental ioctl that will change
>> in future kernels', dropping this IOCTL.
>>
>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>> ---
>> As discussed at [1], there wouldn=E2=80=99t be any possible users of
>> the VPFE_CMD_S_CCDC_RAW_PARAMS IOCTL, but if someone complains
>> we might end up reverting the removal and fix it differently.
>>
>> Note: This patch is on top of [1].
>>
>> [1] https://patchwork.kernel.org/patch/9779385/
>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
>
Thanks for the Ack.

> I think it would be good to backport one or both of the patches to
> stable kernels, to close the potential risk of someone abusing the
> ioctl.

I think just your patch should be suffice to the stable kernel,
blocking this IOCTL.

Cheers,
--Prabhakar Lad
