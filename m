Return-path: <linux-media-owner@vger.kernel.org>
Received: from static-72-93-233-3.bstnma.fios.verizon.net ([72.93.233.3]:34819
	"EHLO mail.wilsonet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932306AbZKZEqU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Nov 2009 23:46:20 -0500
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was: Re: [PATCH 1/3 v2] lirc core device driver infrastructure
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
From: Jarod Wilson <jarod@wilsonet.com>
In-Reply-To: <m3638y5rrb.fsf@intrepid.localdomain>
Date: Wed, 25 Nov 2009 23:46:21 -0500
Cc: Andy Walls <awalls@radix.net>,
	Christoph Bartelmus <lirc@bartelmus.de>,
	dmitry.torokhov@gmail.com, j@jannau.net, jarod@redhat.com,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, mchehab@redhat.com, superm1@ubuntu.com
Content-Transfer-Encoding: 8BIT
Message-Id: <E63F6C2B-71FD-440D-B659-DC7BB96BEDF6@wilsonet.com>
References: <BDRae8rZjFB@christoph> <1259024037.3871.36.camel@palomino.walls.org> <6D934408-B713-49B6-A197-46CE663455AC@wilsonet.com> <m3fx827dgi.fsf@intrepid.localdomain> <4BFB11CF-1835-4AFA-BDC6-F42288A9A6F4@wilsonet.com> <m3638y5rrb.fsf@intrepid.localdomain>
To: Krzysztof Halasa <khc@pm.waw.pl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Nov 25, 2009, at 2:27 PM, Krzysztof Halasa wrote:

> Jarod Wilson <jarod@wilsonet.com> writes:
> 
>> Ah, but the approach I'd take to converting to in-kernel decoding[*]
>> would be this:
>> 
>> 1) bring drivers in in their current state
>>   - users keep using lirc as they always have
>> 
>> 2) add in-kernel decoding infra that feeds input layer
> 
> Well. I think the above is fine enough.
> 
>> 3) add option to use in-kernel decoding to existing lirc drivers
>>   - users can keep using lirc as they always have
>>   - users can optionally try out in-kernel decoding via a modparam
>> 
>> 4) switch the default mode from lirc decode to kernel decode for each lirc driver
>>   - modparam can be used to continue using lirc interface instead
>> 
>> 5) assuming users aren't coming at us with pitchforks, because things don't actually work reliably with in-kernel decoding, deprecate the lirc interface in driver
>> 
>> 6) remove lirc interface from driver, its now a pure input device
> 
> But 3-6 are IMHO not useful. We don't need lirc _or_ input. We need
> both at the same time: input for the general, simple case and for
> consistency with receivers decoding in firmware/hardware; input for
> special cases such as mapping the keys, protocols not supported by the
> kernel and so on (also for in-tree media drivers where applicable).
> 
>> [*] assuming, of course, that it was actually agreed upon that
>> in-kernel decoding was the right way, the only way, all others will be
>> shot on sight. ;)
> 
> I think: in-kernel decoding only as the general, primary means. Not the
> only one.

Okay, I read ya now. I got my wires crossed, thought you were advocating for dropping the lirc interface entirely. I think we're on the same page then. :)

-- 
Jarod Wilson
jarod@wilsonet.com



