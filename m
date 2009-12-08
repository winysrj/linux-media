Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7667 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755364AbZLHOH6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Dec 2009 09:07:58 -0500
Message-ID: <4B1E5DA3.7000206@redhat.com>
Date: Tue, 08 Dec 2009 12:07:31 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: Jon Smirl <jonsmirl@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	hermann pitton <hermann-pitton@arcor.de>,
	Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net,
	j@jannau.net, jarod@redhat.com, jarod@wilsonet.com,
	kraxel@redhat.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
 IR 	system?
References: <20091204220708.GD25669@core.coreip.homeip.net> <BEJgSGGXqgB@lirc>	<9e4733910912041628g5bedc9d2jbee3b0861aeb5511@mail.gmail.com>	<1260070593.3236.6.camel@pc07.localdom.local>	<20091206065512.GA14651@core.coreip.homeip.net>	<4B1B99A5.2080903@redhat.com> <m3638k6lju.fsf@intrepid.localdomain>	<9e4733910912060952h4aad49dake8e8486acb6566bc@mail.gmail.com>	<m3skbn6dv1.fsf@intrepid.localdomain>	<9e4733910912061323x22c618ccyf6edcee5b021cbe3@mail.gmail.com>	<4B1D934E.7030103@redhat.com> <m3hbs1vain.fsf@intrepid.localdomain>
In-Reply-To: <m3hbs1vain.fsf@intrepid.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Krzysztof Halasa wrote:
> Mauro Carvalho Chehab <mchehab@redhat.com> writes:
> 
>>> What is the interface for attaching an in-kernel decoder?
>> IMO, it should use the kfifo for it. However, if we allow both raw data and
>> in-kernel decoders to read data there, we'll need a spinlock to protect the
>> kfifo.
> 
> This may be an option, but I think we should be able to attach protocol
> decoders in parallel, directly to the IRQ handler. At least with RC-5
> (that's what I personally use) it means reliable decoding, no need for
> any timeouts, the code is clean, fast (can be a part of hard IRQ
> handler) and simple.
> 
> The decoder needs something like
> 	rc5_signal_change(ptr, space_or_mark, microseconds).
> 
> At least mark->space or space->mark events must be reported. For better
> reliability, both of them.

If you use a kfifo to store the event (space_or_mark, timestamp), 
the IRQ handler can return immediately, and a separate kernel thread 
can do the decode without needing to touch at the IRQ. It also helps to
have a decoder independent of the kernel driver.

Cheers,
Mauro.
