Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:54846 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759688AbdKPNxc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 16 Nov 2017 08:53:32 -0500
MIME-Version: 1.0
In-Reply-To: <TY1PR06MB089529F042099069AD960093C02E0@TY1PR06MB0895.apcprd06.prod.outlook.com>
References: <1510834290-25434-1-git-send-email-fabrizio.castro@bp.renesas.com>
 <1510834290-25434-2-git-send-email-fabrizio.castro@bp.renesas.com>
 <CAMuHMdW+krUp5ELO4NFxGi8NZ5-H4vrtm-=OXyvZKMCk2f-WcQ@mail.gmail.com> <TY1PR06MB089529F042099069AD960093C02E0@TY1PR06MB0895.apcprd06.prod.outlook.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 16 Nov 2017 14:53:31 +0100
Message-ID: <CAMuHMdVLkhdb0nKMd8OzRK7=wnh_Dxww932Vq2P_OiL=a29V4w@mail.gmail.com>
Subject: Re: [PATCH 1/2] dt-bindings: media: rcar_vin: add device tree support
 for r8a774[35]
To: Fabrizio Castro <fabrizio.castro@bp.renesas.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        =?UTF-8?Q?Niklas_S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Simon Horman <horms+renesas@verge.net.au>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Fabrizio,

On Thu, Nov 16, 2017 at 2:45 PM, Fabrizio Castro
<fabrizio.castro@bp.renesas.com> wrote:
>> Subject: Re: [PATCH 1/2] dt-bindings: media: rcar_vin: add device tree support for r8a774[35]
>>
>> On Thu, Nov 16, 2017 at 1:11 PM, Fabrizio Castro
>> <fabrizio.castro@bp.renesas.com> wrote:
>> > --- a/Documentation/devicetree/bindings/media/rcar_vin.txt
>> > +++ b/Documentation/devicetree/bindings/media/rcar_vin.txt
>> > @@ -14,7 +14,10 @@ channel which can be either RGB, YUYV or BT656.
>> >     - "renesas,vin-r8a7790" for the R8A7790 device
>> >     - "renesas,vin-r8a7779" for the R8A7779 device
>> >     - "renesas,vin-r8a7778" for the R8A7778 device
>> > -   - "renesas,rcar-gen2-vin" for a generic R-Car Gen2 compatible device.
>> > +   - "renesas,vin-r8a7745" for the R8A7745 device
>> > +   - "renesas,vin-r8a7743" for the R8A7743 device
>>
>> Please keep the list sorted by SoC part number.
>
> It is sorted, just in descending order. Do you want me to re-order the full list in ascending order?

That may be a good idea, given the current order is non-standard and
counter-intuitive.

Thanks!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
