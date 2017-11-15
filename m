Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f176.google.com ([209.85.216.176]:50073 "EHLO
        mail-qt0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752585AbdKOSjU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Nov 2017 13:39:20 -0500
MIME-Version: 1.0
In-Reply-To: <20171115181505.GB6736@w540>
References: <1510743363-25798-1-git-send-email-jacopo+renesas@jmondi.org>
 <1510743363-25798-2-git-send-email-jacopo+renesas@jmondi.org>
 <CAMuHMdUG6gAEyyC0ANBzmj3KA-940+C7e9Nv_rLkBSjtfeKR1g@mail.gmail.com> <20171115181505.GB6736@w540>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 15 Nov 2017 19:39:18 +0100
Message-ID: <CAMuHMdVA2iovgrLN6PEWQMLHXJiauGgYuLn1m6xtX1EirZ3oDw@mail.gmail.com>
Subject: Re: [PATCH v1 01/10] dt-bindings: media: Add Renesas CEU bindings
To: jacopo mondi <jacopo@jmondi.org>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

On Wed, Nov 15, 2017 at 7:15 PM, jacopo mondi <jacopo@jmondi.org> wrote:
> On Wed, Nov 15, 2017 at 02:07:31PM +0100, Geert Uytterhoeven wrote:
>> On Wed, Nov 15, 2017 at 11:55 AM, Jacopo Mondi
>> <jacopo+renesas@jmondi.org> wrote:
>> > --- /dev/null
>> > +++ b/Documentation/devicetree/bindings/media/renesas,ceu.txt
>> > @@ -0,0 +1,87 @@
>> > +Renesas Capture Engine Unit (CEU)
>> > +----------------------------------------------
>> > +
>> > +The Capture Engine Unit is the image capture interface found on Renesas
>> > +RZ chip series and on SH Mobile ones.
>> > +
>> > +The interface supports a single parallel input with up 8/16bits data bus width.
>>
>> ... with data bus widths up to 8/16 bits?
>>
>> > +
>> > +Required properties:
>> > +- compatible
>> > +       Must be "renesas,renesas-ceu".
>>
>> The double "renesas" part looks odd to me. What about "renesas,ceu"?
>
> I'm totally open for better "compatible" strings here, so yeah, let's
> got for the shorter one you proposed...
>
>> Shouldn't you add SoC-specific compatible values like "renesas,r7s72100-ceu",
>> too?
>
> Well, I actually have no SoC-specific data in the driver, so I don't
> need SoC specific "compatible" values. But if it's a good practice
> to have them anyway, I will add those in next spin..

You don't necessarily need them in the driver, but in the bindings and DTS,
just in case a difference is discovered later.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
