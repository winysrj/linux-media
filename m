Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55496 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751377Ab0G1SIB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Jul 2010 14:08:01 -0400
Message-ID: <4C50720D.5000301@redhat.com>
Date: Wed, 28 Jul 2010 15:08:13 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jon Smirl <jonsmirl@gmail.com>
CC: Maxim Levitsky <maximlevitsky@gmail.com>,
	Jarod Wilson <jarod@wilsonet.com>,
	linux-input <linux-input@vger.kernel.org>,
	linux-media@vger.kernel.org
Subject: Re: Can I expect in-kernel decoding to work out of box?
References: <1280269990.21278.15.camel@maxim-laptop>	<1280273550.32216.4.camel@maxim-laptop>	<AANLkTi=493LW6ZBURCtyeSYPoX=xfz6n6z77Lw=a2C9D@mail.gmail.com>	<AANLkTimN1t-1a0v3S1zAXqk4MXJepKdsKP=cx9bmo=6g@mail.gmail.com>	<1280298606.6736.15.camel@maxim-laptop>	<AANLkTingNgxFLZcUszp-WDZocH+VK_+QTW8fB2PAR7XS@mail.gmail.com>	<4C502CE6.80106@redhat.com>	<1280327080.9175.58.camel@maxim-laptop>	<AANLkTi=Ww9yvN5RWaXEi+cB2QaDWn34nSVGAvKxbJ2k2@mail.gmail.com>	<4C505313.2010904@redhat.com> <AANLkTi=Ms0saB5b3+o9qQQYFNT96XStKCkVivB65q_33@mail.gmail.com>
In-Reply-To: <AANLkTi=Ms0saB5b3+o9qQQYFNT96XStKCkVivB65q_33@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 28-07-2010 14:04, Jon Smirl escreveu:
> On Wed, Jul 28, 2010 at 11:56 AM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
>> Em 28-07-2010 11:41, Jon Smirl escreveu:
>>
>>> It's possible to build a Linux IR decoder engine that can be loaded
>>> with the old LIRC config files.
>>
>> I think it is a good idea to have a decoder that works with such files anyway.
> 
> The recorder should use the Linux IR system to record the data. It
> would confusing to mix the systems. Users need to be really sure that
> the standard protocol decoders don't understand their protocol before
> resorting to this. Any one in this situation should post their
> recorded data so we can check for driver implementation errors.
> 
> An example: if you use irrecord on Sony remotes lirc always records
> them in raw mode. The true problem here is that irrecord doesn't
> understand that Sony remotes mix different flavors of the Sony
> protocol on a single remote. This leads you to think that the Sony
> protocol engine is broken when it really isn't. It's the irrecord tool
> that is broken.  The kernel IR system will decode these remotes
> correctly without resorting to raw mode.

A decoder like that should be a last-resort decoder, only in the
cases where there's no other option.

>> There are some good reasons for that, as it would allow in-kernel support for
>> protocols that may have some patent restrictions on a few countries that allow
>> patents on software.
> 
> Are there any IR protocols less than 20 (or 17) years old?

Yes. This protocol is brand new:
	https://www.smkusa.com/usa/technologies/qp/

And several new devices are starting to accept it.

> If they are
> older than that the patents have expired. I expect IR use to decline
> in the future, it will be replaced with RF4CE radio remotes.

I expect so, but it will take some time until this transition happens.

Cheers,
Mauro.
