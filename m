Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28424 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752282Ab2LOCQV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Dec 2012 21:16:21 -0500
Date: Fri, 14 Dec 2012 23:39:47 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Matthew Gyurgyik <matthew@pyther.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	David =?UTF-8?B?SMOkcmRlbWFu?= <david@hardeman.nu>
Subject: Re: em28xx: msi Digivox ATSC board id [0db0:8810]
Message-ID: <20121214233947.5471ba4c@redhat.com>
In-Reply-To: <50CBCE9A.4070006@iki.fi>
References: <50B5779A.9090807@pyther.net>
	<50C34A50.6000207@pyther.net>
	<50C35AD1.3040000@googlemail.com>
	<50C48891.2050903@googlemail.com>
	<50C4A520.6020908@pyther.net>
	<CAGoCfiwL3pCEr2Ys48pODXqkxrmXSntH+Tf1AwCT+MEgS-_FRw@mail.gmail.com>
	<50C4BA20.8060003@googlemail.com>
	<50C4BAFB.60304@googlemail.com>
	<50C4C525.6020006@googlemail.com>
	<50C4D011.6010700@pyther.net>
	<50C60220.8050908@googlemail.com>
	<CAGoCfizTfZVFkNvdQuuisOugM2BGipYd_75R63nnj=K7E8ULWQ@mail.gmail.com>
	<50C60772.2010904@googlemail.com>
	<CAGoCfizmchN0Lg1E=YmcoPjW3PXUsChb3JtDF20MrocvwV6+BQ@mail.gmail.com>
	<50C6226C.8090302@iki! .fi>
	<50C636E7.8060003@googlemail.com>
	<50C64AB0.7020407@iki.fi>
	<50C79CD6.4060501@googlemail.com>
	<50C79E9A.3050301@iki.fi>
	<20121213182336.2cca9da6@redhat.! com>
	<50CB46CE.60407@googlemail.com>
	<20121214173950.79bb963e@redhat.com>
	<20121214222631.1f191d6e@redhat.co! m>
	<50CBCAB9.602@iki.fi>
	<20121214230324.1e45c182@redhat.com>
	<50CBCE9A.4070006@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 15 Dec 2012 03:12:58 +0200
Antti Palosaari <crope@iki.fi> escreveu:

> On 12/15/2012 03:03 AM, Mauro Carvalho Chehab wrote:
> > Em Sat, 15 Dec 2012 02:56:25 +0200
> > Antti Palosaari <crope@iki.fi> escreveu:
> >
> >> NACK. NEC variant selection logic is broken by design.
> >
> > If you think so, then feel free to fix it without causing regressions to
> > the existing userspace.
> >
> > While you don't do it, I don't see anything wrong on this patch, as it
> > will behave just like any other NEC decoder.
> 
> yes, so true as I mentioned end of the mail.

Oh, I didn't saw your comments. Sorry.

Please, next time, drop the part of the code that you're not commenting.
On long emails like that, it is sometimes hard to see what's out there.

I'll reply to your comments there again.

> But it is very high 
> probability there is some non/wrong working keys when 32bit NEC variant 
> remote is used with that implementation.
> 
> And what happened those patches David sends sometime ago. I remember 
> there was a patch for the af9015 which removes that kind of logic from 
> the driver. If not change NEC to 32bit at least heuristic could be moved 
> to single point - rc-core.

There were some problems on his series, and it was breaking the userspace
API.

David made a new series, with a smaller set of patches that got applied,
without those changes.

The big issue there is to not break the current NEC userspace tables.

Unfortunately, when the NEC software decoder was written, it were taking
care only of the real NEC standard (the 24-bits and 32-bits variants aren't
part of any spec I'm aware of). When we latter added support for those
weird variants (RC-5 variants; Sony variants; NEC variants), it was
decided, after long debates at the mailing list, to not create a new 
protocol for each, but, instead, to add support for them into the existing 
code.

This is OK on most cases, as the variants are real variants, and the decoder
can properly distinguish them.

Unfortunately, NEC protocol variants don't fill on such case, as the only
difference is that they doesn't honour to the checksum bytes. So, again
after long discussions, it was decided to implement it the way it is.

Changing it right now is not trivial, as it is easy to break existing
userspace.

Regards,
Mauro

