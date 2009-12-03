Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58501 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754841AbZLCRUx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Dec 2009 12:20:53 -0500
Date: Thu, 3 Dec 2009 15:19:56 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: Ferenc Wagner <wferi@niif.hu>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Jarod Wilson <jarod@wilsonet.com>,
	Jarod Wilson <jarod@redhat.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>, awalls@radix.net,
	j@jannau.net, khc@pm.waw.pl, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	lirc-list@lists.sourceforge.net, superm1@ubuntu.com,
	Christoph Bartelmus <lirc@bartelmus.de>
Subject: Re: [RFC v2] Another approach to IR
Message-ID: <20091203151956.70779717@pedra>
In-Reply-To: <9e4733910912030850w188f163bxa2ca149ec81c5bb1@mail.gmail.com>
References: <4B15852D.4050505@redhat.com>
	<4B16BE6A.7000601@redhat.com>
	<20091202195634.GB22689@core.coreip.homeip.net>
	<2D11378A-041C-4B56-91FF-3E62F5F19753@wilsonet.com>
	<20091202201404.GD22689@core.coreip.homeip.net>
	<4B16CCD7.20601@redhat.com>
	<20091202205323.GF22689@core.coreip.homeip.net>
	<4B16D87F.7080701@redhat.com>
	<87tyw8ujsr.fsf@tac.ki.iif.hu>
	<4B17E874.5020003@redhat.com>
	<9e4733910912030850w188f163bxa2ca149ec81c5bb1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 3 Dec 2009 11:50:04 -0500
Jon Smirl <jonsmirl@gmail.com> escreveu:

> On Thu, Dec 3, 2009 at 11:33 AM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
> > Ferenc Wagner wrote:
> >> Mauro Carvalho Chehab <mchehab@redhat.com> writes:
> >>
> >>> Dmitry Torokhov wrote:
> >>>
> >
> >> The interesting thing is that input.h defines KEY_TV, KEY_PC, KEY_SAT,
> >> KEY_CD, KEY_TAPE etc., but no corresponding scan codes will ever be sent
> >> by any remote (ok, I'm stretching it a bit).
> >
> > Unfortunately, this is not true. Some IR's do send a keycode for TV/PC/SAT/CD, etc.
> >
> > On those remotes, if you press TV and then press for example Channel UP
> > and press Radio, then press Channel UP, the channel UP code will be the same.
> >
> > For example, on Hauppauge Grey IR, we have:
> >
> > <TV>
> > [13425.128525] ir_g_keycode_from_table: em28xx IR (em28xx #0): scancode 0x1e1c keycode 0x179
> > [13425.136733] ir_input_key_event: em28xx IR (em28xx #0): key event code=377 down=1
> > [13425.144170] ir_input_key_event: em28xx IR (em28xx #0): key event code=377 down=0
> >
> > <CHANNEL UP>
> > [13428.350223] ir_g_keycode_from_table: em28xx IR (em28xx #0): scancode 0x1e20 keycode 0x192
> > [13428.358434] ir_input_key_event: em28xx IR (em28xx #0): key event code=402 down=1
> > [13428.365871] ir_input_key_event: em28xx IR (em28xx #0): key event code=402 down=0
> >
> > <Radio>
> > [13430.672266] ir_g_keycode_from_table: em28xx IR (em28xx #0): scancode 0x1e0c keycode 0x181
> > [13430.680473] ir_input_key_event: em28xx IR (em28xx #0): key event code=385 down=1
> > [13430.687913] ir_input_key_event: em28xx IR (em28xx #0): key event code=385 down=0
> >
> > <CHANNEL UP>
> > [13433.697268] ir_g_keycode_from_table: em28xx IR (em28xx #0): scancode 0x1e20 keycode 0x192
> > [13433.705480] ir_input_key_event: em28xx IR (em28xx #0): key event code=402 down=1
> > [13433.712916] ir_input_key_event: em28xx IR (em28xx #0): key event code=402 down=0
> >
> > In this IR, the address is bogus: it is always 0x1e. This scenario is very common with the
> > shipped IR's.
> 
> The remote is treating everything as a single integrated device which
> is not inconsistent with what has been said. In this case there really
> is only one multi-function device not two independent ones.
> 
> If you want to control two independent devices you need to buy a
> different remote. Remotes are cheap so that's not a big deal.
> 
> If you really want to use this remote to control two independent
> devices you need user space scripting to split the single device into
> two devices and then inject new events into the input layer. This is a
> complex case and not in the goal of getting 90% of users to "just
> work".

This remote is a typical example of the IR's that are provided together with media boards.
On all such IR's I know, it does generate one key event for TV, SAT, DVB, DVD... keys and
this event doesn't change the status of subsequent keys.

100% of the users of such boards will have the shipped IR. Some amount will be happy of
just using the provided IR to control different applications at their computer or embedded
hardware, and some amount will prefer to buy a multi-purpose IR that will allow him
to control not only his computer, but also, his TV, his Air conditioning, etc.

Both usages should be supported.

All I'm saying is that, in the case where people have only the shipped IR, if he wants to
see TV, the produced keycode will be KEY_TV, and then to change a channel, it will
receive KEY_CHANNELUP, to control his TV app. When the user decides to switch to DVB, 
he will press KEY_DVB and then KEY_PLAY to play his movie.

So, an application like MythTV should be able to work with those keys.

I don't see the need to create a separate code for KEY_PLAYDVB, as this can be simply mapped
as KEY_DVB and KEY_PLAY.


-- 

Cheers,
Mauro
