Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35797 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935711AbZLGXuj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Dec 2009 18:50:39 -0500
Message-ID: <4B1D94C4.3030102@redhat.com>
Date: Mon, 07 Dec 2009 21:50:28 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Christoph Bartelmus <lirc@bartelmus.de>
CC: jonsmirl@gmail.com, awalls@radix.net, dmitry.torokhov@gmail.com,
	j@jannau.net, jarod@redhat.com, jarod@wilsonet.com, khc@pm.waw.pl,
	kraxel@redhat.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
 IR  system?
References: <BENh5lRHqgB@lirc>
In-Reply-To: <BENh5lRHqgB@lirc>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Christoph Bartelmus wrote:
> Hi Jon,
> 
> on 04 Dec 09 at 19:28, Jon Smirl wrote:
>>> BTW, I just came across a XMP remote that seems to generate 3x64 bit
>>> scan codes. Anyone here has docs on the XMP protocol?
>> Assuming a general purpose receiver (not one with fixed hardware
>> decoding), is it important for Linux to receive IR signals from all
>> possible remotes no matter how old or obscure? Or is it acceptable to
> [...]
>> Of course transmitting is a completely different problem, but we
>> haven't been talking about transmitting. I can see how we would need
>> to record any IR protocol in order to retransmit it. But that's in the
>> 5% of users world, not the 90% that want MythTV to "just work".  Use
>> something like LIRC if you want to transmit.
> 
> I don't think anyone here is in the position to be able to tell what is  
> 90% or 5%.

True. Yet, cases like IR devices made by someone's own use is something
that we don't need to care to have an in-kernel driver.

> Personally I use LIRC exclusively for transmit to my settop box  
> using an old and obscure RECS80 protocol.
> No, I won't replace my setup just because it's old and obscure.
> 
> Cable companies tend to provide XMP based boxes to subscribers more often  
> these days. Simply not supporting these setups is a no-go for me.

I don't see any reason why not supporting STB protocols. Several such
hardware use Linux, anyway. So, eventually the STB manufacturers may send
us decoders that work with their IR's.

Cheers,
Mauro.



