Return-path: <linux-media-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:37897 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752856AbZK1TzA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Nov 2009 14:55:00 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net,
	dmitry.torokhov@gmail.com, j@jannau.net, jarod@redhat.com,
	jarod@wilsonet.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	maximlevitsky@gmail.com, mchehab@redhat.com, superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel IR  system?
References: <m3r5riy7py.fsf@intrepid.localdomain> <BDkdITRHqgB@lirc>
	<9e4733910911280906if1191a1jd3d055e8b781e45c@mail.gmail.com>
	<4B116954.5050706@s5r6.in-berlin.de>
	<9e4733910911281058i1b28f33bh64c724a89dcb8cf5@mail.gmail.com>
Date: Sat, 28 Nov 2009 20:55:03 +0100
In-Reply-To: <9e4733910911281058i1b28f33bh64c724a89dcb8cf5@mail.gmail.com>
	(Jon Smirl's message of "Sat, 28 Nov 2009 13:58:27 -0500")
Message-ID: <m3ws1awhk8.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jon Smirl <jonsmirl@gmail.com> writes:

> EVIOCSKEYCODE is lacking, first parameter is an INT. Some decoded IR
> codes are over 32b. Christoph posted an example that needs 128b.

This only means that the existing interface is limited.

> This
> is a problem with ioctls, they change size depending on platform and
> endianess.

But not this: you can use fixed-width u16, u32, u64 and e.g. u8[x].
I don't know an arch which changes int sizes depending on endianness,
is there any?
32/64 binary compatibility needs some minimal effort.
-- 
Krzysztof Halasa
