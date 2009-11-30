Return-path: <linux-media-owner@vger.kernel.org>
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:38115 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752696AbZK3RnN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Nov 2009 12:43:13 -0500
Date: Mon, 30 Nov 2009 12:45:12 -0500
To: Andy Walls <awalls@radix.net>
Cc: Jon Smirl <jonsmirl@gmail.com>, Krzysztof Halasa <khc@pm.waw.pl>,
	Christoph Bartelmus <lirc@bartelmus.de>,
	dmitry.torokhov@gmail.com, j@jannau.net, jarod@redhat.com,
	jarod@wilsonet.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	maximlevitsky@gmail.com, mchehab@redhat.com,
	stefanr@s5r6.in-berlin.de, superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
	IR  system?
Message-ID: <20091130174512.GA762@caffeine.csclub.uwaterloo.ca>
References: <m3r5riy7py.fsf@intrepid.localdomain> <BDkdITRHqgB@lirc> <9e4733910911280906if1191a1jd3d055e8b781e45c@mail.gmail.com> <m3aay6y2m1.fsf@intrepid.localdomain> <9e4733910911280937k37551b38g90f4a60b73665853@mail.gmail.com> <1259450815.3137.19.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259450815.3137.19.camel@palomino.walls.org>
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Nov 28, 2009 at 06:26:55PM -0500, Andy Walls wrote:
> The only thing this buys for the user is remote/products bundles that
> work out of the box.  That can only be a solution for the 80% case.
> 
> I don't hear users crying out "Please integrate IR with the input
> system".  I do hear users say "I want my remote to work", and "How can I
> make my remote work?".  Users are not specifically asking for this
> integration of IR and the input system - a technical nuance.  If such a
> tecnical desire-ment drives excessive rework, I doubt anyone will care
> enough about IR to follow through to make a complete system.

Please integrate it so I can stop having issues with the lirc moduels
when going to a new kernel version.

> What does "equal footing" mean as an incentive anyway?  The opportunity
> to reimplement *everything* that exists for IR already over again in
> kernel-space for the sake of developer technical desires?  That's just a
> lot of work for "not invented here" syndrome.  IR transceivers are
> arguably superior to keyboards and mice anyway because they can transmit
> data too.

I have no idea.  I am sure you guys will come up with a great interface.
I just use lirc with my mythtv box.

-- 
Len Sorensen
