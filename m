Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35568 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755223AbZLHOZ7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Dec 2009 09:25:59 -0500
Message-ID: <4B1E61E1.5070705@redhat.com>
Date: Tue, 08 Dec 2009 12:25:37 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Andy Walls <awalls@radix.net>,
	Jarod Wilson <jarod@wilsonet.com>,
	Christoph Bartelmus <lirc@bartelmus.de>, j@jannau.net,
	jarod@redhat.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	superm1@ubuntu.com
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was:
 Re: [PATCH 1/3 v2] lirc core device driver infrastructure
References: <BDRae8rZjFB@christoph>	<1259024037.3871.36.camel@palomino.walls.org>	<m3k4xe7dtz.fsf@intrepid.localdomain> <4B0E8B32.3020509@redhat.com>	<1259264614.1781.47.camel@localhost>	<6B4C84CD-F146-4B8B-A8BB-9963E0BA4C47@wilsonet.com>	<1260240142.3086.14.camel@palomino.walls.org>	<20091208042210.GA11147@core.coreip.homeip.net>	<4B1E3C1D.7070704@redhat.com> <m3vdghtuy1.fsf@intrepid.localdomain>
In-Reply-To: <m3vdghtuy1.fsf@intrepid.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Krzysztof Halasa wrote:
> Mauro Carvalho Chehab <mchehab@redhat.com> writes:
>> IMO, the better is to have an API to allow creation of multiple interfaces
>> per IR receiver, based on some scancode matching table and/or on some
>> matching mask.
> 
> I think setting the keytables for each logical device would do.

Yes.
> 
> I.e. just have a way to create additional logical devices. Each can have
> its own keytable. The decoders would send their output to all logical
> remotes, trying to match the tables etc.
> 
>> It should be possible to use the filter API to match different IR's by
>> vendor/product on protocols that supports it,
> 
> That would mean unnecessary limiting.

If the mask is (unsigned)-1, it will not add any limit. This should be the default.

The advantage of the mask is that you can speedup the keycode decoding by not calling
a seek routine in the cases where it doesn't make sense.

Also, the cost of scancode & scancode_mask is cheap enough, comparing with the 
potential optimization gain of not seeking a data in a table that wouldn't match anyway.

Also, the IR core may automatically generate such mask, by doing an "and" operation of all
the scancodes at the table during table initialization/changes. If the mask is zero, it
defaults to use a (unsigned) -1 mask.

Cheers,
Mauro.

