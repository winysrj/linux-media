Return-path: <linux-media-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:55557 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751737AbZK1UVy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Nov 2009 15:21:54 -0500
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
	<4B117DEA.3030400@s5r6.in-berlin.de>
	<9e4733910911281208t23c938a2l7537e248e1eda4ae@mail.gmail.com>
Date: Sat, 28 Nov 2009 21:21:57 +0100
In-Reply-To: <9e4733910911281208t23c938a2l7537e248e1eda4ae@mail.gmail.com>
	(Jon Smirl's message of "Sat, 28 Nov 2009 15:08:40 -0500")
Message-ID: <m3fx7ywgbe.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jon Smirl <jonsmirl@gmail.com> writes:

> We have one IR receiver device and multiple remotes. How does the
> input system know how many devices to create corresponding to how many
> remotes you have? There is no current mechanism to do that. You need
> an input device for each remote so that you can do the EVIOCSKEYCODE
> against it. Some type of "create subdevice" IOCTL will need to be
> built.

Thinking about it, I'm not sure. Why do we want multiple remote devices?
(not multiple remotes, that's clear).
-- 
Krzysztof Halasa
