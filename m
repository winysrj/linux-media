Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57951 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754053Ab3AKOxq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Jan 2013 09:53:46 -0500
Date: Fri, 11 Jan 2013 12:53:00 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Benny Amorsen <benny+usenet@amorsen.dk>
Cc: Jonathan McCrohan <jmccrohan@gmail.com>,
	Oliver Schinagl <oliver+list@schinagl.nl>,
	Jiri Slaby <jirislaby@gmail.com>,
	Manu Abraham <abraham.manu@gmail.com>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Johannes Stezenbach <js@linuxtv.org>,
	linux-media <linux-media@vger.kernel.org>,
	Christoph Pfister <christophpfister@gmail.com>
Subject: Re: [RFC] Initial scan files troubles and brainstorming
Message-ID: <20130111125300.773e8a2d@redhat.com>
In-Reply-To: <m3d2xbolnl.fsf@ursa.amorsen.dk>
References: <50EF0A4F.1000604@gmail.com>
	<CAHFNz9LrW4GCZb-BwJ8v7b8iT-+8pe-LAy8ZRN+mBDNLsssGPg@mail.gmail.com>
	<CAOcJUbwya++5nW_MKvGOGbeXCbxFgahu_AWEGBb6TLNx0Pz53A@mail.gmail.com>
	<CAHFNz9JTGZ1MmFCGqyyP0F4oa6t4048O+EYX50zH2J-axpkGVA@mail.gmail.com>
	<50EF2155.5060905@schinagl.nl>
	<CAHFNz9KxaShq=F1ePVbcz1j8jTv3ourn=xHM8kMFE_wiAU5JRA@mail.gmail.com>
	<50EF256B.8030308@gmail.com>
	<CAHFNz9KbwzYV_YLY-9StTn0DRV+vvFFhiG6FGcbjQ-EYV5S4wA@mail.gmail.com>
	<50EF276C.1080101@gmail.com>
	<50EF2AC0.20206@schinagl.nl>
	<20130111011232.GA3255@lambda.dereenigne.org>
	<20130111102317.63b26248@redhat.com>
	<m3d2xbolnl.fsf@ursa.amorsen.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 11 Jan 2013 15:10:38 +0100
Benny Amorsen <benny+usenet@amorsen.dk> escreveu:

> Mauro Carvalho Chehab <mchehab@redhat.com> writes:
> 
> > That's said, this is just database entries where the values were obtained
> > from a public service. Anyone else with access to the same
> > transponders/carriers would be obtaining the very same data. So, I don't 
> > think that copyright law applies here. IANAL, but it sounds to me
> > that such info would be public domain.
> 
> Please be aware that in at least the EU database compilations _can_ be
> copyrighted. It makes life a lot simpler for distributions if you just
> pretend that it can be copyrighted and apply a license. 

Yes. Better safe than sorry.

> If you want
> something approaching public domain, the BSD license is an obvious
> choice. Going with the LGPL as you propose later in the email is
> perfectly fine too.

Changing to BSD could be a problem, as re-licensing would require an
ack from the original contributors, except if the license is a compatible
one. Collecting everyone's ack on such change could be painful, and for
no good reason.

So, to make it simpler, I would just use the LGPL.

Regards,
Mauro
