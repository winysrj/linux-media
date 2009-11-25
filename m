Return-path: <linux-media-owner@vger.kernel.org>
Received: from static-72-93-233-3.bstnma.fios.verizon.net ([72.93.233.3]:55566
	"EHLO mail.wilsonet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934914AbZKYSHT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Nov 2009 13:07:19 -0500
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was: Re: [PATCH 1/3 v2] lirc core device driver infrastructure
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
From: Jarod Wilson <jarod@wilsonet.com>
In-Reply-To: <m3skc25wpx.fsf@intrepid.localdomain>
Date: Wed, 25 Nov 2009 13:07:06 -0500
Cc: lirc@bartelmus.de (Christoph Bartelmus), awalls@radix.net,
	dmitry.torokhov@gmail.com, j@jannau.net, jarod@redhat.com,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, mchehab@redhat.com, superm1@ubuntu.com
Content-Transfer-Encoding: 8BIT
Message-Id: <E6F196CB-8F9E-4618-9283-F8F67D1D3EAF@wilsonet.com>
References: <BDZb9P9ZjFB@christoph> <m3skc25wpx.fsf@intrepid.localdomain>
To: Krzysztof Halasa <khc@pm.waw.pl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Nov 25, 2009, at 12:40 PM, Krzysztof Halasa wrote:

> lirc@bartelmus.de (Christoph Bartelmus) writes:
> 
>> I'm not sure what two ways you are talking about. With the patches posted  
>> by Jarod, nothing has to be changed in userspace.
>> Everything works, no code needs to be written and tested, everybody is  
>> happy.
> 
> The existing drivers use input layer. Do you want part of the tree to
> use existing lirc interface while the other part uses their own
> in-kernel (badly broken for example) code to do precisely the same
> thing?

Took me a minute to figure out exactly what you were talking about. You're referring to the current in-kernel decoding done on an ad-hoc basis for assorted remotes bundled with capture devices, correct?

Admittedly, unifying those and the lirc driven devices hasn't really been on my radar.

> We can have a good code for both, or we can end up with "badly broken"
> media drivers and incompatible, suboptimal existing lirc interface
> (though most probably much better in terms of quality, especially after
> Jarod's work).

Well, is there any reason most of those drivers with currently-in-kernel-but-badly-broken decoding can't be converted to use the lirc interface if its merged into the kernel? And/or, everything could converge on a new in-kernel decoding infra that wasn't badly broken. Sure, there may be two separate ways of doing essentially the same thing for a while, but meh. The lirc way works NOW for an incredibly wide variety of receivers, transmitters, IR protocols, etc.

I do concur that Just Works decoding for bundled remotes w/o having to configure anything would be nice, and one way to go about doing that certainly is via in-kernel IR decoding. But at the same time, the second you want to use something other than a bundled remote, things fall down, and having to do a bunch of setkeycode ops seems less optimal than simply dropping an appropriate lircd.conf in place.

-- 
Jarod Wilson
jarod@wilsonet.com



