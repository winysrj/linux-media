Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:36796 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376AbcBZNUf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Feb 2016 08:20:35 -0500
MIME-Version: 1.0
In-Reply-To: <7803268.ksEo9HOBee@avalon>
References: <1455242450-24493-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
	<1455242450-24493-4-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
	<CAMuHMdW1bWPPL-4hRM=dx-216V4Aew1dg=i=ApkLww4RFXQgmg@mail.gmail.com>
	<7803268.ksEo9HOBee@avalon>
Date: Fri, 26 Feb 2016 14:20:34 +0100
Message-ID: <CAMuHMdU9qgjKo0w3WpC1cP3hFPio+8jp2kiH1baWdnjRtE2_Zw@mail.gmail.com>
Subject: Re: [PATCH/RFC 3/9] v4l: Add Renesas R-Car FCP driver
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Magnus Damm <magnus.damm@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-renesas-soc@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Mon, Feb 15, 2016 at 1:35 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
>> > --- /dev/null
>> > +++ b/Documentation/devicetree/bindings/media/renesas,fcp.txt
>> > @@ -0,0 +1,24 @@
>> > +Renesas R-Car Frame Compression Processor (FCP)
>> > +-----------------------------------------------
>> > +
>> > +The FCP is a companion module of video processing modules in the Renesas
>> > R-Car
>> > +Gen3 SoCs. It provides data compression and decompression, data caching,
>> > and
>> > +converting of AXI transaction in order to reduce the memory bandwidth.
>>
>> "conversion"?
>>
>> > +
>> > +There are three types of FCP whose configuration and behaviour highly
>> > depend +on the module they are paired with.
>> > +
>> > + - compatible: Must be one of the following
>> > +   - "renesas,fcpv" for the 'FCP for VSP' device
>>
>> Any chance this module can turn up in another SoC later? I guess yes.
>
> It's not just that it can, it will.
>
>> What about future-proofing using "renesas,r8a7795-fcpv" and "renesas,rcar-
>> gen3-fcpv"?
>
> Given that the device currently has registers and clock only, I wanted to keep
> the DT bindings simple. My plan is to introduce new compat strings later as
> needed, if needed, when incompatible FCP instances will be introduced. Feel
> free to challenge that :-)

I'm afraid that will be too late.
How are you gonna distinguish the new and incompatible variants from the
r8a7795 variant? Ah, by using "renesas,PartOfTheMonth-fcpv"?
So why not use "renesas,r8a7795-fcpv" now?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
