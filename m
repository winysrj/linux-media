Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:37928 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753807Ab0G1REL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Jul 2010 13:04:11 -0400
MIME-Version: 1.0
In-Reply-To: <4C505313.2010904@redhat.com>
References: <1280269990.21278.15.camel@maxim-laptop>
	<1280273550.32216.4.camel@maxim-laptop>
	<AANLkTi=493LW6ZBURCtyeSYPoX=xfz6n6z77Lw=a2C9D@mail.gmail.com>
	<AANLkTimN1t-1a0v3S1zAXqk4MXJepKdsKP=cx9bmo=6g@mail.gmail.com>
	<1280298606.6736.15.camel@maxim-laptop>
	<AANLkTingNgxFLZcUszp-WDZocH+VK_+QTW8fB2PAR7XS@mail.gmail.com>
	<4C502CE6.80106@redhat.com>
	<1280327080.9175.58.camel@maxim-laptop>
	<AANLkTi=Ww9yvN5RWaXEi+cB2QaDWn34nSVGAvKxbJ2k2@mail.gmail.com>
	<4C505313.2010904@redhat.com>
Date: Wed, 28 Jul 2010 13:04:09 -0400
Message-ID: <AANLkTi=Ms0saB5b3+o9qQQYFNT96XStKCkVivB65q_33@mail.gmail.com>
Subject: Re: Can I expect in-kernel decoding to work out of box?
From: Jon Smirl <jonsmirl@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
	Jarod Wilson <jarod@wilsonet.com>,
	linux-input <linux-input@vger.kernel.org>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jul 28, 2010 at 11:56 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Em 28-07-2010 11:41, Jon Smirl escreveu:
>
>> It's possible to build a Linux IR decoder engine that can be loaded
>> with the old LIRC config files.
>
> I think it is a good idea to have a decoder that works with such files anyway.

The recorder should use the Linux IR system to record the data. It
would confusing to mix the systems. Users need to be really sure that
the standard protocol decoders don't understand their protocol before
resorting to this. Any one in this situation should post their
recorded data so we can check for driver implementation errors.

An example: if you use irrecord on Sony remotes lirc always records
them in raw mode. The true problem here is that irrecord doesn't
understand that Sony remotes mix different flavors of the Sony
protocol on a single remote. This leads you to think that the Sony
protocol engine is broken when it really isn't. It's the irrecord tool
that is broken.  The kernel IR system will decode these remotes
correctly without resorting to raw mode.

> There are some good reasons for that, as it would allow in-kernel support for
> protocols that may have some patent restrictions on a few countries that allow
> patents on software.

Are there any IR protocols less than 20 (or 17) years old? If they are
older than that the patents have expired. I expect IR use to decline
in the future, it will be replaced with RF4CE radio remotes.

>
> We'll need to discuss the API requirements for such decoder, in order to load
> the RC decoding code into it.
>
> Cheers,
> Mauro.
>



-- 
Jon Smirl
jonsmirl@gmail.com
