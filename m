Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:51081 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919AbZKZToT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Nov 2009 14:44:19 -0500
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was:
 Re: [PATCH 1/3 v2] lirc core device driver infrastructure
From: Andy Walls <awalls@radix.net>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Krzysztof Halasa <khc@pm.waw.pl>,
	Christoph Bartelmus <lirc@bartelmus.de>,
	dmitry.torokhov@gmail.com, j@jannau.net, jarod@redhat.com,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, superm1@ubuntu.com
In-Reply-To: <4B0E8B32.3020509@redhat.com>
References: <BDRae8rZjFB@christoph>
	 <1259024037.3871.36.camel@palomino.walls.org>
	 <m3k4xe7dtz.fsf@intrepid.localdomain>  <4B0E8B32.3020509@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 Nov 2009 14:43:34 -0500
Message-Id: <1259264614.1781.47.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2009-11-26 at 12:05 -0200, Mauro Carvalho Chehab wrote:
> Krzysztof Halasa wrote:
> > Andy Walls <awalls@radix.net> writes:
> > 
> >> I would also note that RC-6 Mode 6A, used by most MCE remotes, was
> >> developed by Philips, but Microsoft has some sort of licensing interest
> >> in it and it is almost surely encumbered somwhow:
> > 
> > I don't know about legal problems in some countries but from the
> > technical POV handling the protocol in the kernel is more efficient
> > or (/and) simpler.
> 
> A software licensing from Microsoft won't apply to Linux kernel, so I'm
> assuming that you're referring to some patent that they could be filled
> about RC6 mode 6A.
> 
> I don't know if is there any US patent pending about it (AFAIK, only US
> accepts software patents), but there are some prior-art for IR key
> decoding. So, I don't see what "innovation" RC6 would be adding. 
> If it is some new way to transmit waves, the patent issues
> aren't related to software, and the device manufacturer had already handled
> it when they made their devices.
>
>  If it is just a new keytable, this issue 
> could be easily solved by loading the keytable via userspace.
> 
> Also, assuming that you can use the driver only with a hardware that comes
> with a licensed software, the user has already the license for using it.
> 
> Do you have any details on what patents they are claiming?

The US Philips RC-6 patent is US Patent 5,877,702

http://www.google.com/patents?vid=USPAT5877702

Click on download PDF to get a copy of the whole patent.

I am not a lawyer.  Philips claims' all appear to tie to a transmitter
or receiver as part of a system, but most of the claims are about
information and bit positions and lengths.


I don't know for sure what Microsoft claims to be licensing.  I think it
is the protocol itself:

http://www.microsoft.com/presspass/Press/2002/Apr02/04-16FreestylePhilipsPR.mspx

"Under the terms of the agreement, Microsoft and Philips will license to
OEMs an IR protocol based on Philips proprietary RC6 IR technology. The
patented and globally adopted solution minimizes interference from other
remote-control devices in the household. Use of this established
protocol will help ensure uniform development of Windows infrared
remote-control products, which include infrared remote-control units and
remote-control receivers..."

http://download.microsoft.com/download/9/8/f/98f3fe47-dfc3-4e74-92a3-088782200fe7/TWEN05007_WinHEC05.ppt

See Slide 5, which has the bullet: "How to License RC6"

Since the content of the information field in RC-6 Mode 6A is left up to
OEMs, I would not be surprised by bogus "innovations" in OEM patents
about RC-6 Mode 6A contents.  I would not be at all surprised by
something like "a bit to indicate a toggled remote key press in the
information field" since RC-6's T bits for mode 6 indicate Mode 6A or
Mode 6B and not toggles.


IMO, given

a. the dearth of public information about RC-6, indicating someone
thinks it's their trade secret or intellectual property

b. Microsoft claiming to license something related to the MCE remote
protocols (which are obviously RC-6 Mode 6A),

c. my inability to draw a "clear, bright line" that RC-6 Mode 6A
encoding and decoding, as needed by MCE remotes, implemented in software
doesn't violate anyone's government granted rights to exclusivity.

I think it's much better to implement software RC-6 Mode 6A encoding and
decoding in user space, doing only the minimum needed to get the
hardware setup and going in the kernel.  

Encoding/decoding of RC-6 by microcontrollers with firmware doesn't
worry me. 


Maybe I'm being too conservative here, but I have a personal interest in
keeping Linux free and unencumbered even in the US which, I cannot deny,
has a patent system that is screwed up.

Regards,
Andy

> Cheers,
> Mauro.



