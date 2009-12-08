Return-path: <linux-media-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:47685 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754966AbZLHONl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Dec 2009 09:13:41 -0500
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Andy Walls <awalls@radix.net>,
	Jarod Wilson <jarod@wilsonet.com>,
	Christoph Bartelmus <lirc@bartelmus.de>, j@jannau.net,
	jarod@redhat.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	superm1@ubuntu.com
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was: Re: [PATCH 1/3 v2] lirc core device driver infrastructure
References: <BDRae8rZjFB@christoph>
	<1259024037.3871.36.camel@palomino.walls.org>
	<m3k4xe7dtz.fsf@intrepid.localdomain> <4B0E8B32.3020509@redhat.com>
	<1259264614.1781.47.camel@localhost>
	<6B4C84CD-F146-4B8B-A8BB-9963E0BA4C47@wilsonet.com>
	<1260240142.3086.14.camel@palomino.walls.org>
	<20091208042210.GA11147@core.coreip.homeip.net>
	<4B1E3C1D.7070704@redhat.com>
Date: Tue, 08 Dec 2009 15:13:42 +0100
In-Reply-To: <4B1E3C1D.7070704@redhat.com> (Mauro Carvalho Chehab's message of
	"Tue, 08 Dec 2009 09:44:29 -0200")
Message-ID: <m3vdghtuy1.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro Carvalho Chehab <mchehab@redhat.com> writes:

> With RC-5, you have no fields describing the remote. So, all the driver could
> do is an educated guess.

It can't even do that, e.g. single remotes (even the dumb ones) can send
different code groups (addresses) for different keys.

> IMO, the better is to have an API to allow creation of multiple interfaces
> per IR receiver, based on some scancode matching table and/or on some
> matching mask.

I think setting the keytables for each logical device would do.

I.e. just have a way to create additional logical devices. Each can have
its own keytable. The decoders would send their output to all logical
remotes, trying to match the tables etc.

> It should be possible to use the filter API to match different IR's by
> vendor/product on protocols that supports it,

That would mean unnecessary limiting.

> or to match address/command
> tuples on protocols where you just have those fields.

Precisely.
-- 
Krzysztof Halasa
