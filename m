Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:35235 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161861AbaKNVdn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Nov 2014 16:33:43 -0500
Received: from ni.piap.pl (localhost.localdomain [127.0.0.1])
	by ni.piap.pl (Postfix) with ESMTP id C478E440E8C
	for <linux-media@vger.kernel.org>; Fri, 14 Nov 2014 22:33:41 +0100 (CET)
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Linux Media <linux-media@vger.kernel.org>
References: <m3lhneez9h.fsf@t19.piap.pl>
	<CANZNk82C9SmBXx4T=CxRjLGOZPuRdahwF4mXYUk8pJ427vdCPQ@mail.gmail.com>
Date: Fri, 14 Nov 2014 22:33:40 +0100
In-Reply-To: <CANZNk82C9SmBXx4T=CxRjLGOZPuRdahwF4mXYUk8pJ427vdCPQ@mail.gmail.com>
	(Andrey Utkin's message of "Fri, 14 Nov 2014 18:56:48 +0400")
MIME-Version: 1.0
Message-ID: <m3wq6xpivf.fsf@t19.piap.pl>
Content-Type: text/plain
Subject: Re: SOLO6x10: fix a race in IRQ handler.
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Andrey Utkin <andrey.krieger.utkin@gmail.com> writes:

> could you please point to some reading which explains this moment? Or
> you just know this from experience? The solo device specs are very
> terse about this, so I considered that it should work fine without
> regard to how fast we write back to that register.

The SOLO IRQ controller does the common thing, all drivers (for chips
using the relatively modern "write 1 to clear") have to follow this
sequence: first ACK the interrupts sources (so they are deasserted,
though they can be asserted again if new events arrive), and only then
service the chip.

> Also while you're at it, and if this really makes sense, you could
> merge these two writes (unrecognized bits, then recognized bits) to
> one write act.

I think my patch does exactly this, merges both writes.
-- 
Krzysztof Halasa

Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
