Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:46383 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751475AbZKXA4H (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Nov 2009 19:56:07 -0500
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was:
 Re: [PATCH 1/3 v2] lirc core device driver infrastructure
From: Andy Walls <awalls@radix.net>
To: Christoph Bartelmus <lirc@bartelmus.de>
Cc: khc@pm.waw.pl, dmitry.torokhov@gmail.com, j@jannau.net,
	jarod@redhat.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	mchehab@redhat.com, superm1@ubuntu.com
In-Reply-To: <BDRae8rZjFB@christoph>
References: <BDRae8rZjFB@christoph>
Content-Type: text/plain
Date: Mon, 23 Nov 2009 19:53:57 -0500
Message-Id: <1259024037.3871.36.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2009-11-23 at 22:11 +0100, Christoph Bartelmus wrote:
> Czesc Krzysztof,
> 
> on 23 Nov 09 at 15:14, Krzysztof Halasa wrote:
> [...]
> > I think we shouldn't at this time worry about IR transmitters.
> 
> Sorry, but I have to disagree strongly.
> Any interface without transmitter support would be absolutely unacceptable  
> for many LIRC users, including myself.

I agree with Christoph.  

Is it that the input subsystem is better developed and seen as a
leverage point for development and thus an "easier" place to get results
earlier?  If so, then one should definitely deal with transmitters early
in the design, as that is where the most unknowns lie.

With the end of analog TV, people will have STBs feeding analog only
video cards.  Being able to change the channel on the STB with an IR
transmitter controlled by applications like MythTV is essential.


And on some different notes:

I generally don't understand the LIRC aversion I perceive in this thread
(maybe I just have a skewed perception).  Aside for a video card's
default remote setup, the suggestions so far don't strike me as any
simpler for the end user than LIRC -- maybe I'm just used to LIRC.  LIRC
already works for both transmit and receive and has existing support in
applications such as MythTV and mplayer.

I believe Jarod's intent is to have the LIRC components, that need to be
in kernel modules, moved into kernel mainline to avoid the headaches of
out of kernel driver maintenance.  I'm not sure it is time well spent
for developers, or end users, to develop yet another IR receive
implementation in addition to the ones we suffer with now.


I would also note that RC-6 Mode 6A, used by most MCE remotes, was
developed by Philips, but Microsoft has some sort of licensing interest
in it and it is almost surely encumbered somwhow:

http://download.microsoft.com/download/9/8/f/98f3fe47-dfc3-4e74-92a3-088782200fe7/TWEN05007_WinHEC05.ppt

"Microsoft recommends the Microsoft-Philips IR protocol (based on RC6)
              * You can become a licensee at no charge to you
[...]
  * How to license RC6
      * Contact RemoteMC @ microsoft.com for license agreement"


I would much rather that RC-6 be handled as much as possible in user
space than in the kernel.  LIRC userspace components already handle it,
IIRC.


Regards,
Andy "LIRC Fan-Boy" Walls


