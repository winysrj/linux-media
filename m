Return-path: <linux-media-owner@vger.kernel.org>
Received: from static-72-93-233-3.bstnma.fios.verizon.net ([72.93.233.3]:33012
	"EHLO mail.wilsonet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759453AbZKYRod convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Nov 2009 12:44:33 -0500
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was: Re: [PATCH 1/3 v2] lirc core device driver infrastructure
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
From: Jarod Wilson <jarod@wilsonet.com>
In-Reply-To: <m3fx827dgi.fsf@intrepid.localdomain>
Date: Wed, 25 Nov 2009 12:44:26 -0500
Cc: Andy Walls <awalls@radix.net>,
	Christoph Bartelmus <lirc@bartelmus.de>,
	dmitry.torokhov@gmail.com, j@jannau.net, jarod@redhat.com,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, mchehab@redhat.com, superm1@ubuntu.com
Content-Transfer-Encoding: 8BIT
Message-Id: <4BFB11CF-1835-4AFA-BDC6-F42288A9A6F4@wilsonet.com>
References: <BDRae8rZjFB@christoph> <1259024037.3871.36.camel@palomino.walls.org> <6D934408-B713-49B6-A197-46CE663455AC@wilsonet.com> <m3fx827dgi.fsf@intrepid.localdomain>
To: Krzysztof Halasa <khc@pm.waw.pl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Nov 25, 2009, at 11:53 AM, Krzysztof Halasa wrote:

> Jarod Wilson <jarod@wilsonet.com> writes:
...
>> Now, I'm all for "improving" things and integrating better with the
>> input subsystem, but what I don't really want to do is break
>> compatibility with the existing setups on thousands (and thousands?)
>> of MythTV boxes around the globe. The lirc userspace can be pretty
>> nimble. If we can come up with a shiny new way that raw IR can be
>> passed out through an input device, I'm pretty sure lirc userspace can
>> be adapted to handle that.
> 
> Lirc can already handle input layer. Since both ways require userspace
> changes, why not do it the right way the first time? Most of the code
> is already written.

There's obviously still some debate as to what "the right way" is. :)

And the matter of someone having the time to write the rest of the code that would be needed.

>> If a new input-layer-based transmit interface is developed, we can
>> take advantage of that too. But there's already a very mature lirc
>> interface for doing all of this. So why not start with adding things
>> more or less as they exist right now and evolve the drivers into an
>> idealized form? Getting *something* into the kernel in the first place
>> is a huge step in that direction.
> 
> What I see as potentially problematic is breaking compatibility multiple
> times.

Ah, but the approach I'd take to converting to in-kernel decoding[*] would be this:

1) bring drivers in in their current state
   - users keep using lirc as they always have

2) add in-kernel decoding infra that feeds input layer

3) add option to use in-kernel decoding to existing lirc drivers
   - users can keep using lirc as they always have
   - users can optionally try out in-kernel decoding via a modparam

4) switch the default mode from lirc decode to kernel decode for each lirc driver
   - modparam can be used to continue using lirc interface instead

5) assuming users aren't coming at us with pitchforks, because things don't actually work reliably with in-kernel decoding, deprecate the lirc interface in driver

6) remove lirc interface from driver, its now a pure input device

This would all be on a per-lirc-driver basis, and if/when all decoding could be reliably done in-kernel, and/or there was a way other than the lirc interface to pass raw IR signals out to userspace, the lirc interface could be removed entirely.

And we still need to consider IR transmitters as well. Those are handled quite well through the lirc interface, and I've not seen any concrete code (or even fully fleshed out ideas) on how IR transmit could be handled in this in-kernel decoding world.


[*] assuming, of course, that it was actually agreed upon that in-kernel decoding was the right way, the only way, all others will be shot on sight. ;)

-- 
Jarod Wilson
jarod@wilsonet.com



