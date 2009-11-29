Return-path: <linux-media-owner@vger.kernel.org>
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39976 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751060AbZK2MjO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Nov 2009 07:39:14 -0500
Date: Sun, 29 Nov 2009 12:40:11 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
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
Message-ID: <20091129124011.4d8a6080@lxorguk.ukuu.org.uk>
In-Reply-To: <1259469121.3125.28.camel@palomino.walls.org>
References: <m3r5riy7py.fsf@intrepid.localdomain>
	<BDkdITRHqgB@lirc>
	<9e4733910911280906if1191a1jd3d055e8b781e45c@mail.gmail.com>
	<m3aay6y2m1.fsf@intrepid.localdomain>
	<9e4733910911280937k37551b38g90f4a60b73665853@mail.gmail.com>
	<1259469121.3125.28.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> BTW, circa 1995 my serial mouse "Just Worked" in Linux.  Sometime around

Correct X11 just talked to the serial ports. In fact that is still the
way to configure it if you want any sanity in life.

> and serial connected IRs.  It's also too convenient to access USB IR
> hardware from existing userspace drivers to bother porting into the
> kernel.

Userspace needs a way to identify IR hardware and to interface with it
using the right protocol. It's not clear the kernel needs to provide
anything more than minimal hardware interfaces in most case - be that
serial, libusb, ...
