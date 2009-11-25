Return-path: <linux-media-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:45162 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934780AbZKYRMl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Nov 2009 12:12:41 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Jarod Wilson <jarod@wilsonet.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jarod Wilson <jarod@redhat.com>, linux-kernel@vger.kernel.org,
	Mario Limonciello <superm1@ubuntu.com>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	Janne Grunau <j@jannau.net>,
	Christoph Bartelmus <lirc@bartelmus.de>
Subject: Re: IR raw input is not sutable for input system
References: <200910200956.33391.jarod@redhat.com>
	<200910200958.50574.jarod@redhat.com> <4B0A765F.7010204@redhat.com>
	<4B0A81BF.4090203@redhat.com> <m36391tjj3.fsf@intrepid.localdomain>
	<20091123173726.GE17813@core.coreip.homeip.net>
	<4B0B6321.3050001@wilsonet.com>
	<1259105571.28219.20.camel@maxim-laptop>
Date: Wed, 25 Nov 2009 18:12:44 +0100
In-Reply-To: <1259105571.28219.20.camel@maxim-laptop> (Maxim Levitsky's
	message of "Wed, 25 Nov 2009 01:32:51 +0200")
Message-ID: <m38wdu7ckz.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Maxim Levitsky <maximlevitsky@gmail.com> writes:

> There are many protocols,

Few of them really popular.

> There are many receivers, and all have different accuracy.

Receivers? Accuracy? What do you mean exactly?

> Most remotes aren't designed to be used with PC, thus user has to invent
> mapping between buttons and actions.

Of course. You can't change that. Being designed to be used with PC is
not relevant.

> Its is not possible to identify remotes accurately, many remotes send
> just a 8 bit integer that specifies the 'model' thus many remotes can
> share it.

I have never seen a remote that sends "model" number.
But I admit I only used few universal (including programmable) and few
simple bundled remotes.

> Some don't send anything.

How do they communicate with the receiver?

> There are some weird remotes that send whole packet of data will all
> kind of states.

Of course. This is called "encoding".

> Think about it, video capture device is also an input device, a scanner
> is an input device too, sound card can work as input device too.

But their primary function isn't passing keystrokes, is it?

> Kernel job is to take the information from device and present it to
> userspace using uniform format, that is kernel does 1:1 translating, but
> doesn't parse the data.

Why do you think so?
This is less efficient, and more complicated. And would require
incompatible changes to drivers already in the kernel. Keyword:
"regression".

> lirc is well capable to decode it, and its not hard to add
> auto-detection based on existing configuration drivers, so IR devices
> will work with absolutely no configuration.

Really? You don't know what you're talking about. Forget this idea,
there is absolutely no way to use this without prior configuration. You
can get as far as suggesting default "bundled" model, if there was
something bundled with the receiver of course.

> Then as soon as you press a key, lirc can scan its config database, and
> find a config file to use.

Forget it.

> Also don't forget that there are pure userspace drivers. They won't have
> access to in-kernel decoder so they will still have to parse protocols,
> so will have code duplication, and will still need lirc thus.

This is not a problem. BTW I have nothing against lirc. It can get
keystrokes from input layer. That's the way I use it in fact.
-- 
Krzysztof Halasa
