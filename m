Return-path: <mchehab@pedra>
Received: from cantor.suse.de ([195.135.220.2]:45706 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751836Ab0IMPAt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Sep 2010 11:00:49 -0400
Date: Mon, 13 Sep 2010 17:00:47 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Jarod Wilson <jarod@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Linux Input <linux-input@vger.kernel.org>,
	linux-media@vger.kernel.org,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	David Hardeman <david@hardeman.nu>,
	Ville Syrjala <syrjala@sci.fi>
Subject: Re: [PATCH 0/6] Large scancode handling
In-Reply-To: <20100908160908.GF22323@redhat.com>
Message-ID: <alpine.LNX.2.00.1009131700120.26813@pobox.suse.cz>
References: <20100908073233.32365.74621.stgit@hammer.corenet.prv> <alpine.LNX.2.00.1009081147540.26813@pobox.suse.cz> <20100908142418.GC22323@redhat.com> <4C87A87A.4060102@redhat.com> <20100908152234.GE22323@redhat.com> <alpine.LNX.2.00.1009081723400.26813@pobox.suse.cz>
 <20100908160908.GF22323@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, 8 Sep 2010, Jarod Wilson wrote:

> > > > > It'll conflict a little bith with the tivo slide patch I posted yesterday,
> > > > > but mostly just minor context changes. I can redo that patch on top of
> > > > > these changes if that's preferred.
> > > > 
> > > > I can handle those context changes when merging the patches at linux-next and
> > > > when merging upstream. We just need to sync in a way that Dmitry send his patch
> > > > series before mine when sending them to Linus, and I'll take care of fixing the
> > > > merge conflicts.
> > > 
> > > Ah, the specific conflicts I was referring here are confined to
> > > drivers/hid/hid-input.c, and I sent the patch thinking it would go in via
> > > the hid tree. It *is* for a remote, but its a pure HID device in this
> > > case.
> > 
> > Umm, what patch are you talking about please? I don't seem to have 
> > anything from you in my queue.
> 
> Gah. I suck. Forgot to cc you on it.
> 
> http://www.spinics.net/lists/linux-input/msg11007.html
> 
> Can resend and/or bounce you a copy if need be.

No need to resend, I'll dig it out from linux-input@ archives where I have 
overlooked it and will start a discussion in that thread if needed, so 
that we don't pollute this one.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
