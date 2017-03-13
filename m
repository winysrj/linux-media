Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:36384 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751031AbdCMHnz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Mar 2017 03:43:55 -0400
MIME-Version: 1.0
In-Reply-To: <20170312220231.193801fd@vento.lan>
References: <1489324627-19126-1-git-send-email-geert@linux-m68k.org>
 <1489324627-19126-13-git-send-email-geert@linux-m68k.org> <20170312220231.193801fd@vento.lan>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 13 Mar 2017 08:43:52 +0100
Message-ID: <CAMuHMdXYkMWUYSoWRr87eq9t3dFjjM7R1cDwYxKOVBBLmX57mg@mail.gmail.com>
Subject: Re: [PATCH v2 12/23] MAINTAINERS: Add file patterns for media device
 tree bindings
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Mon, Mar 13, 2017 at 2:02 AM, Mauro Carvalho Chehab
<mchehab@osg.samsung.com> wrote:
> Em Sun, 12 Mar 2017 14:16:56 +0100
> Geert Uytterhoeven <geert@linux-m68k.org> escreveu:
>
>> Submitters of device tree binding documentation may forget to CC
>> the subsystem maintainer if this is missing.
>>
>> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
>> Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>
>> Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>
> As the To: is devicetree, I'm assuming that this patch will be
> applied there, so:
>
> Acked-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Thanks!

> I may also merge via my tree, if that would be better. Just let me
> know in such case.

Please apply to your tree, cfr.

| Please apply this patch directly if you want to be involved in device
| tree binding documentation for your subsystem.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
