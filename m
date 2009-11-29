Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f212.google.com ([209.85.217.212]:59950 "EHLO
	mail-gx0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753976AbZK2E61 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Nov 2009 23:58:27 -0500
Date: Sat, 28 Nov 2009 20:58:30 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Andy Walls <awalls@radix.net>
Cc: Jon Smirl <jonsmirl@gmail.com>, Krzysztof Halasa <khc@pm.waw.pl>,
	Christoph Bartelmus <lirc@bartelmus.de>, j@jannau.net,
	jarod@redhat.com, jarod@wilsonet.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	maximlevitsky@gmail.com, mchehab@redhat.com,
	stefanr@s5r6.in-berlin.de, superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
	IR  system?
Message-ID: <20091129045829.GR6936@core.coreip.homeip.net>
References: <m3r5riy7py.fsf@intrepid.localdomain> <BDkdITRHqgB@lirc> <9e4733910911280906if1191a1jd3d055e8b781e45c@mail.gmail.com> <m3aay6y2m1.fsf@intrepid.localdomain> <9e4733910911280937k37551b38g90f4a60b73665853@mail.gmail.com> <1259450815.3137.19.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259450815.3137.19.camel@palomino.walls.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Nov 28, 2009 at 06:26:55PM -0500, Andy Walls wrote:
> Jon,
> 
> On Sat, 2009-11-28 at 12:37 -0500, Jon Smirl wrote:
> > On Sat, Nov 28, 2009 at 12:35 PM, Krzysztof Halasa <khc@pm.waw.pl> wrote:
> > > Jon Smirl <jonsmirl@gmail.com> writes:
> > >
> > >> There are two very basic things that we need to reach consensus on first.
> > >>
> > >> 1) Unification with mouse/keyboard in evdev - put IR on equal footing.
> 
> The only thing this buys for the user is remote/products bundles that
> work out of the box.  That can only be a solution for the 80% case.
> 
> I don't hear users crying out "Please integrate IR with the input
> system".  I do hear users say "I want my remote to work", and "How can I
> make my remote work?".  Users are not specifically asking for this
> integration of IR and the input system - a technical nuance.

Right, but if remotes work users did not care if we went through 20
revisions of the interface and how much effort was wasted. When we
talking about users here we do talk about application developers mostly,
not the consumers.

Well, consumers would bennefit of plug and play and proper power
management too.

-- 
Dmitry
