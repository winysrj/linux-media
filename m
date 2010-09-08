Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:12723 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752126Ab0IHPWp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Sep 2010 11:22:45 -0400
Date: Wed, 8 Sep 2010 11:22:34 -0400
From: Jarod Wilson <jarod@redhat.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Jiri Kosina <jkosina@suse.cz>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Linux Input <linux-input@vger.kernel.org>,
	linux-media@vger.kernel.org,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	David Hardeman <david@hardeman.nu>,
	Ville Syrjala <syrjala@sci.fi>
Subject: Re: [PATCH 0/6] Large scancode handling
Message-ID: <20100908152234.GE22323@redhat.com>
References: <20100908073233.32365.74621.stgit@hammer.corenet.prv>
 <alpine.LNX.2.00.1009081147540.26813@pobox.suse.cz>
 <20100908142418.GC22323@redhat.com>
 <4C87A87A.4060102@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C87A87A.4060102@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Wed, Sep 08, 2010 at 12:15:06PM -0300, Mauro Carvalho Chehab wrote:
> Em 08-09-2010 11:24, Jarod Wilson escreveu:
> > On Wed, Sep 08, 2010 at 11:48:50AM +0200, Jiri Kosina wrote:
> >> On Wed, 8 Sep 2010, Dmitry Torokhov wrote:
> >>
> >>> Hi Mauro,
> >>>
> >>> I guess I better get off my behind and commit the changes to support large
> >>> scancodes, or they will not make to 2.6.37 either... There isn't much
> >>> changes, except I followed David's suggestion and changed boolean index
> >>> field into u8 flags field. Still, please glance it over once again and
> >>> shout if you see something you do not like.
> >>>
> >>> Jiri, how do you want to handle the changes to HID? I could either push
> >>> them through my tree together with the first patch or you can push through
> >>> yours once the first change hits mainline.
> >>
> >> I think that there will unlikely be any conflict in .37 merge window in 
> >> this area (and if there were, I'll sort it out).
> >>
> >> So please add
> >>
> >> 	Acked-by: Jiri Kosina <jkosina@suse.cz>
> >>
> >> to the hid-input.c bits and feel free to take it through your tree, if it 
> >> is convenient for you.
> > 
> > It'll conflict a little bith with the tivo slide patch I posted yesterday,
> > but mostly just minor context changes. I can redo that patch on top of
> > these changes if that's preferred.
> 
> I can handle those context changes when merging the patches at linux-next and
> when merging upstream. We just need to sync in a way that Dmitry send his patch
> series before mine when sending them to Linus, and I'll take care of fixing the
> merge conflicts.

Ah, the specific conflicts I was referring here are confined to
drivers/hid/hid-input.c, and I sent the patch thinking it would go in via
the hid tree. It *is* for a remote, but its a pure HID device in this
case.

-- 
Jarod Wilson
jarod@redhat.com

