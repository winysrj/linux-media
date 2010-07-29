Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:44901 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754117Ab0G2L6Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jul 2010 07:58:16 -0400
MIME-Version: 1.0
In-Reply-To: <1280370997.2392.75.camel@localhost>
References: <1280269990.21278.15.camel@maxim-laptop>
	<1280273550.32216.4.camel@maxim-laptop>
	<AANLkTi=493LW6ZBURCtyeSYPoX=xfz6n6z77Lw=a2C9D@mail.gmail.com>
	<AANLkTimN1t-1a0v3S1zAXqk4MXJepKdsKP=cx9bmo=6g@mail.gmail.com>
	<1280298606.6736.15.camel@maxim-laptop>
	<AANLkTingNgxFLZcUszp-WDZocH+VK_+QTW8fB2PAR7XS@mail.gmail.com>
	<4C502CE6.80106@redhat.com>
	<AANLkTinCs7f6zF-tYZqJ49CAjNWF=2MPGh0VRuU=VLzq@mail.gmail.com>
	<1280327929.11072.24.camel@morgan.silverblock.net>
	<AANLkTikFfXx4NBB2z2UXNt5Kt-2QrvTfvK0nQhSSqw8v@mail.gmail.com>
	<4C504FDB.4070400@redhat.com>
	<1280336530.19593.52.camel@morgan.silverblock.net>
	<AANLkTikotLLPcCvwwNFEe+80sV6w9F0pa_fx3f_jdK77@mail.gmail.com>
	<1280341109.26286.38.camel@morgan.silverblock.net>
	<4C508F87.6050906@redhat.com>
	<1280370997.2392.75.camel@localhost>
Date: Thu, 29 Jul 2010 07:58:15 -0400
Message-ID: <AANLkTikZb+114KMM9N8_LOXKeiVHP72N+7KctuJuXpG1@mail.gmail.com>
Subject: Re: Can I expect in-kernel decoding to work out of box?
From: Jon Smirl <jonsmirl@gmail.com>
To: Andy Walls <awalls@md.metrocast.net>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	Jarod Wilson <jarod@wilsonet.com>,
	linux-input <linux-input@vger.kernel.org>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jul 28, 2010 at 10:36 PM, Andy Walls <awalls@md.metrocast.net> wrote:
> As an example of simple hardware glitch filter, here's an excerpt
> from the public CX25480/1/2/3 datasheet on the IR low-pass (glitch)
> filter that's in the hardware:
>
> "the counter reloads using the value programmed to this register each
> time a qualified edge is detected [...]. Once the reload occurs, the
> counter begins decrementing. If the next programmed edge occurs before
> the counter reaches 0, the pulse measurement value is discarded, the
> filter modulus value is reloaded, and the next pulse measurement begins.
> Thus, any pulse measurement that ends before the counter reaches 0 is
> ignored."

You could make a small library that drivers could link in. That way we
won't get it implemented ten different ways. Devices that do the
filtering in firmware won't have to use the code.

There are lots of ways to design it. A simple one would be to sit on
each message until the next one arrives. Then make a decision to pass
the previous message up or declare the current edge a glitch and wait
for the next one.  It probably needs a timeout so that you don't sit
on long pulses forever waiting on the next one.

-- 
Jon Smirl
jonsmirl@gmail.com
