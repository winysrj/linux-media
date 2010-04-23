Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15170 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751354Ab0DWS37 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Apr 2010 14:29:59 -0400
Message-ID: <4BD1E71D.5070102@redhat.com>
Date: Fri, 23 Apr 2010 15:29:49 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jon Smirl <jonsmirl@gmail.com>
CC: Jarod Wilson <jarod@wilsonet.com>,
	=?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>,
	linux-input@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 00/15] ir-core: Several improvements to allow adding LIRC
 	and decoder plugins
References: <20100401145632.5631756f@pedra>	 <t2z9e4733911004011844pd155bbe8g13e4cbcc1a5bf1f6@mail.gmail.com>	 <20100402102011.GA6947@hardeman.nu>	 <p2ube3a4a1004051349y11e3004bk1c71e3ab38d3f669@mail.gmail.com>	 <20100407093205.GB3029@hardeman.nu>	 <z2hbe3a4a1004231040uce51091fnf24b97de215e3ef1@mail.gmail.com> <o2l9e4733911004231106te8b727e9nfa75bfd9c73e9506@mail.gmail.com>
In-Reply-To: <o2l9e4733911004231106te8b727e9nfa75bfd9c73e9506@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jon Smirl wrote:
>> So now that I'm more or less done with porting the imon driver, I
>> think I'm ready to start tackling the mceusb driver. But I'm debating
>> on what approach to take with respect to lirc support. It sort of
>> feels like we should have lirc_dev ported as an ir "decoder"
>> driver/plugin before starting to port mceusb to ir-core, so that we
>> can maintain lirc compat and transmit support. Alternatively, I could
>> port mceusb without lirc support for now, leaving it to only use
>> in-kernel decoding and have no transmit support for the moment, then
>> re-add lirc support. I'm thinking that porting lirc_dev as, say,
>> ir-lirc-decoder first is probably the way to go though. Anyone else
>> want to share their thoughts on this?
> 
> I'd take whatever you think is the simplest path. It is more likely
> that initial testers will want to work with the new in-kernel system
> than the compatibility layer to LIRC. Existing users that are happy
> with the current LIRC should just keep on using it.

Agreed. You may start by adding either lirc "decoder" or mce. Both ways
will end on having the same result ;)

>> (Actually, while sharing thoughts... Should drivers/media/IR become
>> drivers/media/RC, ir-core.h become rc-core.h, ir-keytable.c become
>> rc-keytable.c and so on?)
> 
> Why aren't these files going into drivers/input/rc? My embedded system
> has a remote control and it has nothing to do with media.

Historical reasons. It were simpler to start from drivers/media, as we've
started with some already existing code there.

My intention is to write one or two big patches at the end, moving everything
to drivers/rc or drivers/input/rc and renaming the structures. The point is
that a patch like that will force people that are working on the code to rebase
to the newer names, so I prefer to postpone it to happen after we finish with
the big changes. A change like that won't affect just the new RC code, but also
several V4L/DVB drivers.

Maybe the right moment would be during the next merge window, as all pending 
work for 2.6.35 will be already finished, and people likely didn't start 
working for 2.6.36. So, my intention is to write such patch during the merge
week, just after sending the pending stuff.

-- 

Cheers,
Mauro
