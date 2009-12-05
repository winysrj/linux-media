Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:45418 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757492AbZLEBsq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Dec 2009 20:48:46 -0500
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
 IR  system?
From: Andy Walls <awalls@radix.net>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: Christoph Bartelmus <lirc@bartelmus.de>, dmitry.torokhov@gmail.com,
	j@jannau.net, jarod@redhat.com, jarod@wilsonet.com, khc@pm.waw.pl,
	kraxel@redhat.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	mchehab@redhat.com, superm1@ubuntu.com
In-Reply-To: <9e4733910912041628g5bedc9d2jbee3b0861aeb5511@mail.gmail.com>
References: <20091204220708.GD25669@core.coreip.homeip.net>
	 <BEJgSGGXqgB@lirc>
	 <9e4733910912041628g5bedc9d2jbee3b0861aeb5511@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Dec 2009 20:48:07 -0500
Message-Id: <1259977687.27969.18.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2009-12-04 at 19:28 -0500, Jon Smirl wrote:
> On Fri, Dec 4, 2009 at 6:01 PM, Christoph Bartelmus <lirc@bartelmus.de> wrote:
> > BTW, I just came across a XMP remote that seems to generate 3x64 bit scan
> > codes. Anyone here has docs on the XMP protocol?
> 
> Assuming a general purpose receiver (not one with fixed hardware
> decoding), is it important for Linux to receive IR signals from all
> possible remotes no matter how old or obscure?

Importance of any particular requirement is relative/subjective.  As is
usefulness of any existing functionality.

Personally, I just think it's cool to pick up a random remote and use
Linux to figure out its protocol and its codes and get it working.



>  Or is it acceptable to
> tell the user to throw away their dedicated remote and buy a universal
> multi-function one?

Nope.  That other OS provider forces device obsolescence or arbitrary
constraints on users quite often and I don't like it myself.  That's why
I use Linux.


>   Universal multi-function remotes are $12 in my
> grocery store - I don't even have to go to an electronics store.

The old remote in my possession costs $0, and I don't even have to leave
the house.


> I've been working off the premise of getting rid of obscure remotes
> and replacing them with a universal one. The universal one can be set
> to send a common protocol like JVC or Sony. That implies that we only
> need one or two protocol decoders in-kernel which greatly reduces the
> surface area of the problem.

The design should serve the users, the users should not serve the
design.  If the reduction of requirements scope starts forcing users to
buy new hardware, are we really serving the users or just asking them to
pay to compensate for our shortcomings?


Regards,
Andy

