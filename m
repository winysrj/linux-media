Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.24]:2812 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932753AbZLFQit convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Dec 2009 11:38:49 -0500
MIME-Version: 1.0
In-Reply-To: <BENh5lRHqgB@lirc>
References: <9e4733910912041628g5bedc9d2jbee3b0861aeb5511@mail.gmail.com>
	 <BENh5lRHqgB@lirc>
Date: Sun, 6 Dec 2009 11:38:55 -0500
Message-ID: <9e4733910912060838j29f107cpd827e2d7b8a20c1c@mail.gmail.com>
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel IR
	system?
From: Jon Smirl <jonsmirl@gmail.com>
To: Christoph Bartelmus <lirc@bartelmus.de>
Cc: awalls@radix.net, dmitry.torokhov@gmail.com, j@jannau.net,
	jarod@redhat.com, jarod@wilsonet.com, khc@pm.waw.pl,
	kraxel@redhat.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	mchehab@redhat.com, superm1@ubuntu.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Dec 6, 2009 at 7:12 AM, Christoph Bartelmus <lirc@bartelmus.de> wrote:
> Hi Jon,
>
> on 04 Dec 09 at 19:28, Jon Smirl wrote:
>>> BTW, I just came across a XMP remote that seems to generate 3x64 bit
>>> scan codes. Anyone here has docs on the XMP protocol?
>>
>> Assuming a general purpose receiver (not one with fixed hardware
>> decoding), is it important for Linux to receive IR signals from all
>> possible remotes no matter how old or obscure? Or is it acceptable to
> [...]
>> Of course transmitting is a completely different problem, but we
>> haven't been talking about transmitting. I can see how we would need
>> to record any IR protocol in order to retransmit it. But that's in the
>> 5% of users world, not the 90% that want MythTV to "just work".  Use
>> something like LIRC if you want to transmit.
>
> I don't think anyone here is in the position to be able to tell what is
> 90% or 5%. Personally I use LIRC exclusively for transmit to my settop box
> using an old and obscure RECS80 protocol.
> No, I won't replace my setup just because it's old and obscure.

There are two groups, technically oriented people who can handle
messing around with IR protocols and everyone else.  I'm not proposing
to remove any capabilities from the first group. Instead I'd like to
see the creation of a "just works" option for the other group. We
don't know the size of the everyone else group yet because that option
doesn't exist. In general non-technical people way out number the
technical ones in broad user bases. For example I had to use LIRC to
get my remotes working, but I would have rather been in the everyone
else group and not had to learn about IR.

> Cable companies tend to provide XMP based boxes to subscribers more often
> these days. Simply not supporting these setups is a no-go for me.

I suspect what we categorize as "just works" will expand over time.
The in-kernel support can start small and add protocols and maps over
time. Support for XMP can start in LIRC and migrate into the kernel
after we fully understand the protocol and know that enough people are
using it to justify the effort of maintaining it in-kernel.  Adding
in-kernel support for a protocol is not going to make LIRC disappear.

The critical part is getting the initial design of the in-kernel IR
system right. That design is very hard to change after it gets into
everyone's systems and apps start depending on it. Writing up use
cases, modular protocols, figuring out how many bits are needed in
fields, how are maps written, can they be autoloaded, transmitting,
etc, etc. These are the important things to be discussing. LIRC users
obviously have a lot of knowledge in this area to contribute.

PS - another area we need to be thinking about is radio remotes like
the new RF4CE devices. The button presses from these remotes will come
in on the 802.15.4 networking stack and need to get routed into the
input subsystem somehow.

-- 
Jon Smirl
jonsmirl@gmail.com
