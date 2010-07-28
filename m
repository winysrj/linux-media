Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32458 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751999Ab0G1Sfv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Jul 2010 14:35:51 -0400
Message-ID: <4C50788B.2000204@redhat.com>
Date: Wed, 28 Jul 2010 15:35:55 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jon Smirl <jonsmirl@gmail.com>
CC: Andy Walls <awalls@md.metrocast.net>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	Jarod Wilson <jarod@wilsonet.com>,
	linux-input <linux-input@vger.kernel.org>,
	linux-media@vger.kernel.org
Subject: Re: Can I expect in-kernel decoding to work out of box?
References: <1280269990.21278.15.camel@maxim-laptop>	<1280273550.32216.4.camel@maxim-laptop>	<AANLkTi=493LW6ZBURCtyeSYPoX=xfz6n6z77Lw=a2C9D@mail.gmail.com>	<AANLkTimN1t-1a0v3S1zAXqk4MXJepKdsKP=cx9bmo=6g@mail.gmail.com>	<1280298606.6736.15.camel@maxim-laptop>	<AANLkTingNgxFLZcUszp-WDZocH+VK_+QTW8fB2PAR7XS@mail.gmail.com>	<4C502CE6.80106@redhat.com>	<1280327080.9175.58.camel@maxim-laptop>	<AANLkTi=Ww9yvN5RWaXEi+cB2QaDWn34nSVGAvKxbJ2k2@mail.gmail.com>	<4C505313.2010904@redhat.com>	<AANLkTi=Ms0saB5b3+o9qQQYFNT96XStKCkVivB65q_33@mail.gmail.com>	<1280337661.19593.66.camel@morgan.silverblock.net> <AANLkTikHpLHo7Z9XyYHVtnKapvJkHnV=wtqDK9yd6CFX@mail.gmail.com>
In-Reply-To: <AANLkTikHpLHo7Z9XyYHVtnKapvJkHnV=wtqDK9yd6CFX@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 28-07-2010 14:38, Jon Smirl escreveu:
> On Wed, Jul 28, 2010 at 1:21 PM, Andy Walls <awalls@md.metrocast.net> wrote:
>> On Wed, 2010-07-28 at 13:04 -0400, Jon Smirl wrote:
>>> On Wed, Jul 28, 2010 at 11:56 AM, Mauro Carvalho Chehab
>>> <mchehab@redhat.com> wrote:
>>>> Em 28-07-2010 11:41, Jon Smirl escreveu:
>>
>>>
>>> Are there any IR protocols less than 20 (or 17) years old? If they are
>>> older than that the patents have expired. I expect IR use to decline
>>> in the future, it will be replaced with RF4CE radio remotes.
>>
>> UEI's XMP protocol for one, IIRC.
> 
> The beauty of LIRC is that you can use any remote for input.  If one
> remote's protocols are patented, just use another remote.
> 
> Only in the case where we have to xmit the protocol is the patent
> conflict unavoidable. In that case we could resort to sending a raw
> pulse timing string that comes from user space.

Well, software patents are valid only on very few Countries. People that live
on a software-patent-free Country can keep using those protocols, if they
can just upload a set of rules for a generic driver. On the other hand,
a rule-hardcoded codec for a patented protocol cannot be inside Kernel, as
this would restrict kernel distribution on those non-software-patent-free
Countries.

Cheers,
Mauro.

