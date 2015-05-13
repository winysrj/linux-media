Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp03.smtpout.orange.fr ([80.12.242.125]:49033 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753207AbbEMT07 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 May 2015 15:26:59 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-media@vger.kernel.org
Subject: Re: v4.1-rcX regression in v4l2 build
References: <87d225mve4.fsf@belgarion.home>
	<Pine.LNX.4.64.1505122221150.11250@axis700.grange>
	<Pine.LNX.4.64.1505122302570.11250@axis700.grange>
Date: Wed, 13 May 2015 21:26:03 +0200
In-Reply-To: <Pine.LNX.4.64.1505122302570.11250@axis700.grange> (Guennadi
	Liakhovetski's message of "Tue, 12 May 2015 23:09:14 +0200 (CEST)")
Message-ID: <87pp64l1o4.fsf@belgarion.home>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:
...zip...

First, a question for Russell :
  Given that the current PXA architecture is not implementing the
  clk_round_rate() function, while implementing clk_get(), etc..., is it correct
  to say that it is betraying the clk API by doing so ?

And now the answers to your mail Guennadi :
>> I've seen some patches on ALKML for PXA CCF, is it in the mainline now? 
>> Could that have been the reason? Is CONFIG_COMMON_CLK defined in your 
>> .config? Although, no, it's not PXA CCF, it's most probably this
No it's not in clock common framework yet.
PXA will switch to CCF in 4.2, as it missed the 4.1 merge window.

> I think I know how this is possible. PXA uses arch/arm/mach-pxa/clock.c 
> for clk ops, and clk_round_rate() isn't defined there... Can we add a 
> dummy for PXA? It won't be used anyway as long as PXA doesn't support CCF.
I could do it. I'm a bit reluctant because I already prepared my pull request
which fully shifts PXA to CCF, and adding a dummy function will create a merge
issue.

But is PXA the only one in this case ?
>From a first sight there are 5 ARM architectures in the same case :
    rj@belgarion:~/mio_linux/kernel/arch/arm$ grep -rsl 'EXPORT_SYMBOL(clk_round_rate' *
    mach-davinci/clock.c
    mach-lpc32xx/clock.c
    mach-omap1/clock.c
    plat-versatile/clock.c
    rj@belgarion:~/mio_linux/kernel/arch/arm$ grep -rsl 'EXPORT_SYMBOL(clk_get_rate' *
    mach-davinci/clock.c
    mach-ep93xx/clock.c
    mach-lpc32xx/clock.c
    mach-mmp/clock.c
    mach-omap1/clock.c
    mach-pxa/clock.c
    mach-sa1100/clock.c
    mach-w90x900/clock.c
    plat-versatile/clock.c

Cheers.

-- 
Robert
