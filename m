Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:53118 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbZAYVRN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Jan 2009 16:17:13 -0500
From: Matthias Schwarzott <zzam@gentoo.org>
To: Patrick Boettcher <patrick.boettcher@desy.de>
Subject: Re: RFC - Flexcop Streaming watchdog (VDSB)
Date: Sun, 25 Jan 2009 22:17:08 +0100
Cc: linux-dvb@linuxtv.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <alpine.LRH.1.10.0901161548460.28478@pub2.ifh.de>
In-Reply-To: <alpine.LRH.1.10.0901161548460.28478@pub2.ifh.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901252217.08848.zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Freitag, 16. Januar 2009, Patrick Boettcher wrote:

I am looking forward to test your patch.

> There a struct-work-watchdog looking at the number of irq-received while
> having PIDs active in the PID-filter. If no IRQs are received, the
> pid-filter-system is reset.
>
Very good idea.

>
> Before asking to pull the patch I'd like to discuss an issue: my
> work-around is iterating over the pid-filter-list in the dvb_demux. I'm
> doing this in the struct-work-callback. In dvb_demux.c I see that this
> list is protected with a spinlock. When I now try to take the spinlock in
> the work-function I'll get a nice message saying, that I cannot do take a
> spinlock in a work-function.
>

> What can I do? What is the proper way to protect access to this list? Is
> it needed at all?

I thought this is a perfectly legetimate usage of spinlocks. What is the exact 
wording of the message. Is it a message of lockdep, or another kind of 
message?

Does it get better using spin_lock_irqsave instead of spin_lock_irq ?

Regards
Matthias
