Return-path: <linux-media-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:57411 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756013AbZLHPYh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Dec 2009 10:24:37 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jon Smirl <jonsmirl@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	hermann pitton <hermann-pitton@arcor.de>,
	Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net,
	j@jannau.net, jarod@redhat.com, jarod@wilsonet.com,
	kraxel@redhat.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel IR  system?
References: <BEJgSGGXqgB@lirc>
	<9e4733910912041628g5bedc9d2jbee3b0861aeb5511@mail.gmail.com>
	<1260070593.3236.6.camel@pc07.localdom.local>
	<20091206065512.GA14651@core.coreip.homeip.net>
	<4B1B99A5.2080903@redhat.com> <m3638k6lju.fsf@intrepid.localdomain>
	<9e4733910912060952h4aad49dake8e8486acb6566bc@mail.gmail.com>
	<m3skbn6dv1.fsf@intrepid.localdomain>
	<20091207184153.GD998@core.coreip.homeip.net>
	<m3my1u35t2.fsf@intrepid.localdomain>
	<20091207213811.GE998@core.coreip.homeip.net>
Date: Tue, 08 Dec 2009 16:24:40 +0100
In-Reply-To: <20091207213811.GE998@core.coreip.homeip.net> (Dmitry Torokhov's
	message of "Mon, 7 Dec 2009 13:38:11 -0800")
Message-ID: <m37hsxtrnr.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dmitry Torokhov <dmitry.torokhov@gmail.com> writes:

> No, the IR core responsible for registering receivers and decoders.

Well. This makes me think now that LIRC can be just "another decoder".

>> Those are simple things. The only part which needs to be stable is the
>> (in this case LIRC) kernel-user interface.
>
> For which some questions are still open. I believe Jon just oulined some
> of them.

Those are rather "how does it work", not "let's change something because
it's not optimal".

> No we do not. We do not merge something that we expect to rework almost
> completely (no, not the lirc-style device userspace inetrface, although
> even it is not completely finalized I believe, but the rest of the
> subsystem).

I don't think we need to rework it almost completely. Perhaps we need to
change a hook here or there.

> No, not at all. You merge core subsystem code, then start addig
> decoders...

You must have at least one common decoder merged with the core code,
otherwise you don't know if the core is adequate. And you have to have
at least one common input device.

But perhaps it is a workable idea after all, given the "another
decoder".
-- 
Krzysztof Halasa
