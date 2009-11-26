Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48786 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760278AbZKZO2Q (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Nov 2009 09:28:16 -0500
Message-ID: <4B0E9071.60002@redhat.com>
Date: Thu, 26 Nov 2009 12:28:01 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jarod Wilson <jarod@wilsonet.com>
CC: Krzysztof Halasa <khc@pm.waw.pl>,
	Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net,
	dmitry.torokhov@gmail.com, j@jannau.net, jarod@redhat.com,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, superm1@ubuntu.com
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was:
 Re: [PATCH 1/3 v2] lirc core device driver infrastructure
References: <BDZb9P9ZjFB@christoph> <m3skc25wpx.fsf@intrepid.localdomain> <E6F196CB-8F9E-4618-9283-F8F67D1D3EAF@wilsonet.com>
In-Reply-To: <E6F196CB-8F9E-4618-9283-F8F67D1D3EAF@wilsonet.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jarod Wilson wrote:
> On Nov 25, 2009, at 12:40 PM, Krzysztof Halasa wrote:
> 
>> lirc@bartelmus.de (Christoph Bartelmus) writes:
>>
>>> I'm not sure what two ways you are talking about. With the patches posted  
>>> by Jarod, nothing has to be changed in userspace.
>>> Everything works, no code needs to be written and tested, everybody is  
>>> happy.
>> The existing drivers use input layer. Do you want part of the tree to
>> use existing lirc interface while the other part uses their own
>> in-kernel (badly broken for example) code to do precisely the same
>> thing?
> 
> Took me a minute to figure out exactly what you were talking about. You're referring to the
> current in-kernel decoding done on an ad-hoc basis for assorted remotes 
> bundled with capture devices, correct?

They are not limited to the currently bundled IR's, since almost all drivers allow
replacing the existing scancode/keycode table to a new onw.

> Admittedly, unifying those and the lirc driven devices hasn't really been on my radar.

It should be done. Having two ways for doing the same thing is not an option. We'll
need to unify them sooner or later. The sooner, the better.

>> We can have a good code for both, or we can end up with "badly broken"
>> media drivers and incompatible, suboptimal existing lirc interface
>> (though most probably much better in terms of quality, especially after
>> Jarod's work).
> 
> Well, is there any reason most of those drivers with 
> currently-in-kernel-but-badly-broken decoding can't be converted to
> use the lirc interface if its merged into the kernel?

> And/or, everything
> could converge on a new in-kernel decoding infra that wasn't badly broken.
> Sure, there may be two separate ways of doing essentially the same thing
> for a while, but meh. The lirc way works NOW for an incredibly wide
> variety of receivers, transmitters, IR protocols, etc.

Yes: the same drivers support both pulse/space and in-hardware scancode conversion.
In order to use the raw pulse/space API, they'll need to generate pseudo pulse/space's.
This would be a dirty solution, IMHO.

Also, changing the drivers would not be that easy, since it will require lots of
tests with IR's and devices that the developers won't have. This is a weaker argument,
since no matter what decided, we'll need to change the drivers code (on lirc drivers
or on the in-kernel drivers) even without having all hardware available.

> I do concur that Just Works decoding for bundled remotes w/o having to 
> configure anything would be nice, and one way to go about doing that 
> certainly is via in-kernel IR decoding. But at the same time, the second
> you want to use something other than a bundled remote, things fall down, 
> and having to do a bunch of setkeycode ops seems less optimal than simply 
> dropping an appropriate lircd.conf in place.

I don't see this as an issue. We have by far too much work to be done in kernelspace
than the changes that are needed on userspace.

Replace the entire scancode table with setkeycode ops is very fast, and needs to be
done only once, at lirc startup. Once you load the new IR code at the driver,
the kernel will send the new keycodes to lirc.

It doesn't seem hard to modify lirc to do read the lircd.conf table and replace the
IR scancodes at the in-kernel driver. It took me half an hour to write my own keycode
loader code, and you can use it as the basis for such feature:
	http://linuxtv.org/hg/v4l-dvb/file/tip/v4l2-apps/util/keytable.c


Cheers,
Mauro.


