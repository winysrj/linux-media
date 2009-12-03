Return-path: <linux-media-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:38401 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754100AbZLCSF7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Dec 2009 13:05:59 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: Trent Piepho <xyzzy@speakeasy.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Jarod Wilson <jarod@redhat.com>,
	Jon Smirl <jonsmirl@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>, awalls@radix.net,
	j@jannau.net, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	lirc-list@lists.sourceforge.net, superm1@ubuntu.com,
	Christoph Bartelmus <lirc@bartelmus.de>
Subject: Re: [RFC v2] Another approach to IR
References: <4B15852D.4050505@redhat.com>
	<20091202093803.GA8656@core.coreip.homeip.net>
	<4B16614A.3000208@redhat.com>
	<20091202171059.GC17839@core.coreip.homeip.net>
	<9e4733910912020930t3c9fe973k16fd353e916531a4@mail.gmail.com>
	<4B16BE6A.7000601@redhat.com>
	<20091202195634.GB22689@core.coreip.homeip.net>
	<2D11378A-041C-4B56-91FF-3E62F5F19753@wilsonet.com>
	<20091202201404.GD22689@core.coreip.homeip.net>
	<434927DD-0E66-4D0E-B705-022B7FCCCDB0@wilsonet.com>
	<20091202204811.GE22689@core.coreip.homeip.net>
	<B8514BFF-DB1B-4475-9E6D-E2A567A998FA@wilsonet.com>
	<Pine.LNX.4.58.0912021300270.4729@shell2.speakeasy.net>
	<582D7897-47F8-44B6-959F-510790EAEA79@wilsonet.com>
Date: Thu, 03 Dec 2009 19:06:02 +0100
In-Reply-To: <582D7897-47F8-44B6-959F-510790EAEA79@wilsonet.com> (Jarod
	Wilson's message of "Wed, 2 Dec 2009 16:28:51 -0500")
Message-ID: <m3bpig2ar9.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jarod Wilson <jarod@wilsonet.com> writes:

> Perhaps we should clarify something here. Are we intending to
> auto-create a new input device for every IR command set we see arrive
> at the IR receiver?

We don't want this, and we aren't really able to do this, because we
never know if two different scan codes are part of the same or different
command set.

Sharing the protocol and e.g. group code doesn't mean it's the same
remote.

Different protocol doesn't mean it's a different remote and what's more
important, doesn't mean the user wants it to be a different logical
remote.
-- 
Krzysztof Halasa
