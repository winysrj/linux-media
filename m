Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:33948 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751120AbdECHWC (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 3 May 2017 03:22:02 -0400
MIME-Version: 1.0
In-Reply-To: <2382097.9ZIG3XAO0j@avalon>
References: <20170309200818.786255823@cogentembedded.com> <CAMuHMdV5-aMx4KuqShm47XtORJK8rMKzw6FUs2Hjsxia+jPfxg@mail.gmail.com>
 <2382097.9ZIG3XAO0j@avalon>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 3 May 2017 09:22:00 +0200
Message-ID: <CAMuHMdWE+o3gsFnxqBcvrD=PfHHb0i9uK3tsfWaNxfuhK3SNKg@mail.gmail.com>
Subject: Re: [PATCH v5] media: platform: Renesas IMR driver
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Konstantin Kozhevnikov
        <Konstantin.Kozhevnikov@cogentembedded.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Tue, May 2, 2017 at 11:17 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> On Wednesday 22 Mar 2017 10:34:16 Geert Uytterhoeven wrote:
>> On Thu, Mar 9, 2017 at 9:08 PM, Sergei Shtylyov wrote:
>> > --- /dev/null
>> > +++ media_tree/Documentation/devicetree/bindings/media/rcar_imr.txt
>> > @@ -0,0 +1,27 @@
>> > +Renesas R-Car Image Renderer (Distortion Correction Engine)
>> > +-----------------------------------------------------------
>> > +
>> > +The image renderer, or the distortion correction engine, is a drawing
>> > processor
>> > +with a simple instruction system capable of referencing video capture
>> > data or
>> > +data in an external memory as 2D texture data and performing texture
>> > mapping
>> > +and drawing with respect to any shape that is split into triangular
>> > objects.
>> > +
>> > +Required properties:
>> > +
>> > +- compatible: "renesas,<soctype>-imr-lx4", "renesas,imr-lx4" as a
>> > fallback for
>> > +  the image renderer light extended 4 (IMR-LX4) found in the R-Car gen3
>> > SoCs,
>> > +  where the examples with <soctype> are:
>> > +  - "renesas,r8a7795-imr-lx4" for R-Car H3,
>> > +  - "renesas,r8a7796-imr-lx4" for R-Car M3-W.
>>
>> Laurent: what do you think about the need for SoC-specific compatible
>> values for the various IM* blocks?
>
> There's no documented IP core version register, but when dumping all
> configuration registers on H3 and M3-W I noticed that register 0x002c, not
> documented in the datasheet, reads 0x14060514 on all four IMR instances in H3,
> and 0x20150505 on both instances in M3-W.
>
> This looks like a version register to me. If my assumption is correct, we
> could do without any SoC-specific compatible string.

I read this assumed version registers on all R-Car SoCs, after writing
zero to 0xe6150990 (SMSTPCR8).

IMR-X2 on R-Car H2:     0x12072009
IMR-LSX2 on R-Car H2:   0x12072009
IMR-LSX3 on R-Car V2H:  0x13052617
IMR-LX2 on R-Car M2-W:  0x12072009
IMR-LX2 on R-Car M2-N:  0x12072009
IMR-LX2 on R-Car E2:    0x13091909
IMR-LX3 on R-Car V2H:   0x13052617

Note that several IDs are the same, but you know the type from the
compatible value.

It would be good to get confirmation from the hardware team that this is
indeed a version register.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
