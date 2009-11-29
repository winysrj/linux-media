Return-path: <linux-media-owner@vger.kernel.org>
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44543 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752743AbZK2TC7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Nov 2009 14:02:59 -0500
Date: Sun, 29 Nov 2009 19:04:35 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ray Lee <ray-lk@madrabbit.org>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
	Andy Walls <awalls@radix.net>, Jon Smirl <jonsmirl@gmail.com>,
	Krzysztof Halasa <khc@pm.waw.pl>,
	Christoph Bartelmus <lirc@bartelmus.de>,
	dmitry.torokhov@gmail.com, j@jannau.net, jarod@redhat.com,
	jarod@wilsonet.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	mchehab@redhat.com, stefanr@s5r6.in-berlin.de, superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
 IR  system?
Message-ID: <20091129190435.6500ac84@lxorguk.ukuu.org.uk>
In-Reply-To: <2c0942db0911291052n6e9dd116x943ee636bcf548b9@mail.gmail.com>
References: <m3r5riy7py.fsf@intrepid.localdomain>
	<BDkdITRHqgB@lirc>
	<9e4733910911280906if1191a1jd3d055e8b781e45c@mail.gmail.com>
	<m3aay6y2m1.fsf@intrepid.localdomain>
	<9e4733910911280937k37551b38g90f4a60b73665853@mail.gmail.com>
	<1259469121.3125.28.camel@palomino.walls.org>
	<20091129124011.4d8a6080@lxorguk.ukuu.org.uk>
	<1259515703.3284.11.camel@maxim-laptop>
	<2c0942db0911290949p89ae64bjc3c7501c2de6930c@mail.gmail.com>
	<20091129181316.7850f33c@lxorguk.ukuu.org.uk>
	<2c0942db0911291052n6e9dd116x943ee636bcf548b9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Jon is asking for an architecture discussion, y'know, with use cases.
> Maxim seems to be saying it's obvious that what we have today works
> fine. Except it doesn't appear that we have a consensus that
> everything is fine, nor an obvious winner for how to reduce the
> complexity here and keep the kernel in a happy, maintainable state for
> the long haul.

The important point is that this is not an A or B discussion. There are
lots of ways to tackle it that are neither. If you look at things like
complex video format handling it is done in user space but with an
infrastructure to handle it.

I don't believe putting it in the kernel is the alternative to the
current setup. Cleaning up the way what we have today is presented to
applications is perfectly possible without a whole new pile of kernel
crap, because evdev was designed sensibly in the first place to allow
userspace added events.

