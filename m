Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:33906 "EHLO
	mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755989AbcCCL4b (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Mar 2016 06:56:31 -0500
MIME-Version: 1.0
In-Reply-To: <3162705.iiHBb2SECU@avalon>
References: <1455242450-24493-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
	<1535853.p3kynkDehl@avalon>
	<8737s8armo.wl%kuninori.morimoto.gx@renesas.com>
	<3162705.iiHBb2SECU@avalon>
Date: Thu, 3 Mar 2016 12:56:29 +0100
Message-ID: <CAMuHMdWai64fZg6b2ZSWKwRQg325ZKNS2mfm5oAY-B4YXtvUgg@mail.gmail.com>
Subject: Re: [PATCH/RFC 1/9] clk: shmobile: r8a7795: Add FCP clocks
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-renesas-soc@vger.kernel.org,
	Geert Uytterhoeven <geert+renesas@glider.be>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Thu, Mar 3, 2016 at 11:49 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> On Thursday 03 March 2016 08:37:02 Kuninori Morimoto wrote:
>> >>>>  - s2d2 (for 200MHz)
>> >>>>  - s2d1 (for 400MHz)
>> >>>
>> >>> Thank you for the information. Do you mean that different FCP instances
>> >>> use different clocks ? If so, could you tell us which clock is used by
>> >>> each instance in th H3 ES1 ?
>> >>
>> >> Sorry for my confusable mail.
>> >> All FCP on H3 ES1 is using above,
>> >> but, M3 or E3 will use different clock.
>> >>
>> >> Is this more clear ?
>> >
>> > Does it mean that every FCP instance uses both the S2D2 and the S2D1
>> > clocks as functional clocks on H3 ES1 ?
>>
>>  - s2d2 (200MHz) is for APB-IF,
>>  - s2d1 (400MHz) is for AXI-IF, and internal
>>
>> Is this clear answer ?
>
> It is, thank you very much for putting up with my slow mind ;-)
>
> Geert, deciding what clock to use as a parent for the MSTP clock becomes
> interesting, As S2D2 clocks the control interface I propose picking it. This
> shows the limits of the MSTP clock model though, MSTP is really a module stop
> bit, not a clock.

Quoting R-Car Gen3 rev. 0.5E:
"Under software control, the CPG is capable of turning the supply of
clock signals
 to individual modules on or off and of resetting individual modules."

So it is a clock signal, or better (or worse): clock signals (plural).

Hence MSTP gates one or more clocks. Sigh...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
