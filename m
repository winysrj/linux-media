Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f192.google.com ([209.85.221.192]:38400 "EHLO
	mail-qy0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932599AbZLEA2M (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Dec 2009 19:28:12 -0500
MIME-Version: 1.0
In-Reply-To: <BEJgSGGXqgB@lirc>
References: <20091204220708.GD25669@core.coreip.homeip.net> <BEJgSGGXqgB@lirc>
Date: Fri, 4 Dec 2009 19:28:17 -0500
Message-ID: <9e4733910912041628g5bedc9d2jbee3b0861aeb5511@mail.gmail.com>
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel IR
	system?
From: Jon Smirl <jonsmirl@gmail.com>
To: Christoph Bartelmus <lirc@bartelmus.de>
Cc: dmitry.torokhov@gmail.com, awalls@radix.net, j@jannau.net,
	jarod@redhat.com, jarod@wilsonet.com, khc@pm.waw.pl,
	kraxel@redhat.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	mchehab@redhat.com, superm1@ubuntu.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Dec 4, 2009 at 6:01 PM, Christoph Bartelmus <lirc@bartelmus.de> wrote:
> BTW, I just came across a XMP remote that seems to generate 3x64 bit scan
> codes. Anyone here has docs on the XMP protocol?

Assuming a general purpose receiver (not one with fixed hardware
decoding), is it important for Linux to receive IR signals from all
possible remotes no matter how old or obscure? Or is it acceptable to
tell the user to throw away their dedicated remote and buy a universal
multi-function one?  Universal multi-function remotes are $12 in my
grocery store - I don't even have to go to an electronics store.

I've been working off the premise of getting rid of obscure remotes
and replacing them with a universal one. The universal one can be set
to send a common protocol like JVC or Sony. That implies that we only
need one or two protocol decoders in-kernel which greatly reduces the
surface area of the problem.

>From my perspective Linux needs the capability to receive about 40
buttons on about five devices. How those 200 unique codes get into the
box doesn't really matter so I was picking a simple protocol and
setting the universal remote to support five devices in that protocol.

Of course transmitting is a completely different problem, but we
haven't been talking about transmitting. I can see how we would need
to record any IR protocol in order to retransmit it. But that's in the
5% of users world, not the 90% that want MythTV to "just work".  Use
something like LIRC if you want to transmit.

My goal was to make it simple for people to do really basic tasks like
using a remote to pause their music player. Something like: plug in
MSMCE receiver, program remote to send codes for Sony CR-114 mp3
player, hit pause button, music stops.

-- 
Jon Smirl
jonsmirl@gmail.com
