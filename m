Return-path: <linux-media-owner@vger.kernel.org>
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44365 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751217AbZK2SL7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Nov 2009 13:11:59 -0500
Date: Sun, 29 Nov 2009 18:13:16 +0000
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
Message-ID: <20091129181316.7850f33c@lxorguk.ukuu.org.uk>
In-Reply-To: <2c0942db0911290949p89ae64bjc3c7501c2de6930c@mail.gmail.com>
References: <m3r5riy7py.fsf@intrepid.localdomain>
	<BDkdITRHqgB@lirc>
	<9e4733910911280906if1191a1jd3d055e8b781e45c@mail.gmail.com>
	<m3aay6y2m1.fsf@intrepid.localdomain>
	<9e4733910911280937k37551b38g90f4a60b73665853@mail.gmail.com>
	<1259469121.3125.28.camel@palomino.walls.org>
	<20091129124011.4d8a6080@lxorguk.ukuu.org.uk>
	<1259515703.3284.11.camel@maxim-laptop>
	<2c0942db0911290949p89ae64bjc3c7501c2de6930c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> If decoding can *only* be sanely handled in user-space, that's one
> thing. If it can be handled in kernel, then that would be better.

Why ?

I can compute fast fourier transforms in the kernel but that doesn't make
it better than doing it in user space. I can write web servers in the
kernel and the same applies.

Alan
