Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:33054 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750819AbdFZUDA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Jun 2017 16:03:00 -0400
MIME-Version: 1.0
In-Reply-To: <2c173ca0-533c-babc-dcc7-f265bc3fda5d@cogentembedded.com>
References: <20170623203456.503714406@cogentembedded.com> <20170626194905.zjvdzcdlnv74mnr5@rob-hp-laptop>
 <2c173ca0-533c-babc-dcc7-f265bc3fda5d@cogentembedded.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 26 Jun 2017 22:02:58 +0200
Message-ID: <CAMuHMdX_RWn_p5U2K8E+zHy8Pmm8azbA4uySyfDxpNKvD6acAw@mail.gmail.com>
Subject: Re: [PATCH v6] media: platform: Renesas IMR driver
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Rob Herring <robh@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Konstantin Kozhevnikov
        <Konstantin.Kozhevnikov@cogentembedded.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sergei,

On Mon, Jun 26, 2017 at 9:56 PM, Sergei Shtylyov
<sergei.shtylyov@cogentembedded.com> wrote:
> On 06/26/2017 10:49 PM, Rob Herring wrote:
>>> From: Konstantin Kozhevnikov <Konstantin.Kozhevnikov@cogentembedded.com>
>>>
>>> The image renderer, or the distortion correction engine, is a drawing
>>> processor with a simple instruction system capable of referencing video
>>> capture data or data in an external memory as the 2D texture data and
>>> performing texture mapping and drawing with respect to any shape that is
>>> split into triangular objects.
>>>
>>> This V4L2 memory-to-memory device driver only supports image renderer
>>> light
>>> extended 4 (IMR-LX4) found in the R-Car gen3 SoCs; the R-Car gen2 support
>>> can be added later...
>>>
>>> [Sergei: merged 2 original patches, added  the patch description, removed

[...]

>>> macros.]
>>
>>
>> TL;DR needed here IMO.
>
>    Not sure I understand... stands for "too long; didn't read", right?
>
>> Not sure anyone really cares every detail you
>> changed in re-writing this. If they did, it should all be separate
>> commits.
>
>    AFAIK this is a way that's things are dealt with when you submit somebody
> else's work with your changes. Sorry if the list is too long...

Based on a patch by Konstantin Kozhevnikov
<Konstantin.Kozhevnikov@cogentembedded.com>?

Of course, that's bad for your coworker's patch statistics...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
