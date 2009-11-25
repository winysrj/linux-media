Return-path: <linux-media-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:32867 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759493AbZKYT1t (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Nov 2009 14:27:49 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: Andy Walls <awalls@radix.net>,
	Christoph Bartelmus <lirc@bartelmus.de>,
	dmitry.torokhov@gmail.com, j@jannau.net, jarod@redhat.com,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, mchehab@redhat.com, superm1@ubuntu.com
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was: Re: [PATCH 1/3 v2] lirc core device driver infrastructure
References: <BDRae8rZjFB@christoph>
	<1259024037.3871.36.camel@palomino.walls.org>
	<6D934408-B713-49B6-A197-46CE663455AC@wilsonet.com>
	<m3fx827dgi.fsf@intrepid.localdomain>
	<4BFB11CF-1835-4AFA-BDC6-F42288A9A6F4@wilsonet.com>
Date: Wed, 25 Nov 2009 20:27:52 +0100
In-Reply-To: <4BFB11CF-1835-4AFA-BDC6-F42288A9A6F4@wilsonet.com> (Jarod
	Wilson's message of "Wed, 25 Nov 2009 12:44:26 -0500")
Message-ID: <m3638y5rrb.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jarod Wilson <jarod@wilsonet.com> writes:

> Ah, but the approach I'd take to converting to in-kernel decoding[*]
> would be this:
>
> 1) bring drivers in in their current state
>    - users keep using lirc as they always have
>
> 2) add in-kernel decoding infra that feeds input layer

Well. I think the above is fine enough.

> 3) add option to use in-kernel decoding to existing lirc drivers
>    - users can keep using lirc as they always have
>    - users can optionally try out in-kernel decoding via a modparam
>
> 4) switch the default mode from lirc decode to kernel decode for each lirc driver
>    - modparam can be used to continue using lirc interface instead
>
> 5) assuming users aren't coming at us with pitchforks, because things don't actually work reliably with in-kernel decoding, deprecate the lirc interface in driver
>
> 6) remove lirc interface from driver, its now a pure input device

But 3-6 are IMHO not useful. We don't need lirc _or_ input. We need
both at the same time: input for the general, simple case and for
consistency with receivers decoding in firmware/hardware; input for
special cases such as mapping the keys, protocols not supported by the
kernel and so on (also for in-tree media drivers where applicable).

> [*] assuming, of course, that it was actually agreed upon that
> in-kernel decoding was the right way, the only way, all others will be
> shot on sight. ;)

I think: in-kernel decoding only as the general, primary means. Not the
only one.
-- 
Krzysztof Halasa
