Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45047 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932116Ab0JSEDU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Oct 2010 00:03:20 -0400
MIME-Version: 1.0
In-Reply-To: <1287459219.16971.352.camel@gandalf.stny.rr.com>
References: <201009161632.59210.arnd@arndb.de>
	<201010181742.06678.arnd@arndb.de>
	<20101018184346.GD27089@kroah.com>
	<AANLkTin2KPNNXvwcWphhM-5qexB14FS7M7ezkCCYCZ2H@mail.gmail.com>
	<20101019004004.GB28380@kroah.com>
	<AANLkTi=ffaihP5-yNYFKAbAbX+XbRgWRXXfCZd4J3KwQ@mail.gmail.com>
	<20101019022413.GB30307@kroah.com>
	<AANLkTinv4VFpi=Jkc_5oyFgPbdLRg0ResJx9u9Puhm-7@mail.gmail.com>
	<1287459219.16971.352.camel@gandalf.stny.rr.com>
Date: Tue, 19 Oct 2010 14:03:17 +1000
Message-ID: <AANLkTimL5j1kcL5x+Om0==B30Pps=CAJM5X4NMV09koW@mail.gmail.com>
Subject: Re: [Ksummit-2010-discuss] [v2] Remaining BKL users, what to do
From: Dave Airlie <airlied@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Greg KH <greg@kroah.com>, codalist@telemann.coda.cs.cmu.edu,
	autofs@linux.kernel.org, Samuel Ortiz <samuel@sortiz.org>,
	Jan Kara <jack@suse.cz>,
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
	Arnd Bergmann <arnd@arndb.de>,
	Jan Harkes <jaharkes@cs.cmu.edu>, netdev@vger.kernel.org,
	Anders Larsen <al@alarsen.net>, linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	Bryan Schumaker <bjschuma@netapp.com>,
	Christoph Hellwig <hch@infradead.org>,
	ksummit-2010-discuss@lists.linux-foundation.org,
	Petr Vandrovec <vandrove@vc.cvut.cz>,
	Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
	linux-fsdevel@vger.kernel.org,
	Evgeniy Dushistov <dushistov@mail.ru>,
	Ingo Molnar <mingo@elte.hu>,
	Andrew Hendry <andrew.hendry@gmail.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

>>
>> like I'm sure the intersection of this driver and reality are getting
>> quite limited, but its still a userspace ABI change and needs to be
>> treated as such. Xorg 6.7 and XFree86 4.3 were the last users of the
>> old driver/API.
>
> Thus, you are saying that this will break for people with older user
> apps and have a newer kernel?

There are two drivers here:

i810

i830

The i830 case is the case I care less about since the ABI is only used
by older userspace and i915 provides a replacement.

the i810 case ABI is still in use today by distro userspaces that are
still released, i.e. i810 is still used in F14, Ubuntu 10.10, RHEL6
Beta etc.

I've snipped the rest of the argument on the grounds you are
conflating two cases that aren't the same.

>
>>
>> Well the thing is doing the work right is a non-trivial task and just
>> dropping support only screws the people using the hardware,
>> it doesn't place any burden on the distro developers to fix it up. If
>> people are really serious about making the BKL go away completely, I
>> think the onus should be on them to fix the drivers not on the users
>> who are using it, like I'm �guessing if this gets broken the bug will
>> end up in Novell or RH bugzilla in a year and nobody will ever see it.
>
> Well the problem comes down to testing it. I don't know of any developer
> that is removing the BKL that actually owns hardware to test out these
> broken drivers. And for the change not being trivial, means that there's
> no way to do in correctly.
>

So we can drop i830 using deprecation, however its pointless since the
fix for i810 is the same fix for i830 if we can work out the fix.

Well the way to do it correctly is make it so if the driver is
initialised and we do an SMP transition we warn the users, or we make
BROKEN_ON_SMP into a runtime thing that warns when the driver is
loaded on an SMP system. The intersection of SMP and this hardware is
definitely a very very small number and a lot more workable.

Dave.
