Return-path: <linux-media-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:47843 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752375AbZK3UDk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Nov 2009 15:03:40 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Andy Walls <awalls@radix.net>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Ray Lee <ray-lk@madrabbit.org>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Jon Smirl <jonsmirl@gmail.com>,
	Christoph Bartelmus <lirc@bartelmus.de>,
	dmitry.torokhov@gmail.com, j@jannau.net, jarod@redhat.com,
	jarod@wilsonet.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	stefanr@s5r6.in-berlin.de, superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel IR  system?
References: <m3r5riy7py.fsf@intrepid.localdomain> <BDkdITRHqgB@lirc>
	<9e4733910911280906if1191a1jd3d055e8b781e45c@mail.gmail.com>
	<m3aay6y2m1.fsf@intrepid.localdomain>
	<9e4733910911280937k37551b38g90f4a60b73665853@mail.gmail.com>
	<1259469121.3125.28.camel@palomino.walls.org>
	<20091129124011.4d8a6080@lxorguk.ukuu.org.uk>
	<1259515703.3284.11.camel@maxim-laptop>
	<2c0942db0911290949p89ae64bjc3c7501c2de6930c@mail.gmail.com>
	<1259537732.5231.11.camel@palomino.walls.org>
	<4B13B2FA.4050600@redhat.com>
	<1259585852.3093.31.camel@palomino.walls.org>
Date: Mon, 30 Nov 2009 21:03:42 +0100
In-Reply-To: <1259585852.3093.31.camel@palomino.walls.org> (Andy Walls's
	message of "Mon, 30 Nov 2009 07:57:32 -0500")
Message-ID: <m3iqcrvkyp.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Andy Walls <awalls@radix.net> writes:

> Nonetheless I'd still rather debug a problem with a dead process in
> userspace than an oops or panic (not that an end user cares) and avoid
> the risk of filesystem corruption.

I'll concentrate on IRQ-driven space/mark drivers/devices since it's
what I've been using. They are: very simple hardware (as simple as a
TSOP1836 3-pin receiver "chip" + a resistor), very simple driver (the
hardware signals change in input state with IRQ). Something like maybe
50 lines of code + the (default) key mapping table.

Anyway, you can't move the whole driver to userspace, as it has to
handle IRQs with timestamps.

It doesn't have to sleep.

It's about the last thing I'd worry about WRT the stability.

> So are we optimizing for the embedded/STB and HTPC with no keyboard use
> case, or the desktop or HTPC with a keyboard for maintencance?

IOW the question is: do we want to continue supporting keyboard-less
machines?
-- 
Krzysztof Halasa
