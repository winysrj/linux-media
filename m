Return-path: <mchehab@pedra>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61117 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873Ab0IHPgO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Sep 2010 11:36:14 -0400
Date: Wed, 8 Sep 2010 08:36:09 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Jarod Wilson <jarod@redhat.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Input <linux-input@vger.kernel.org>,
	linux-media@vger.kernel.org,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	David Hardeman <david@hardeman.nu>,
	Ville Syrjala <syrjala@sci.fi>
Subject: Re: [PATCH 0/6] Large scancode handling
Message-ID: <20100908153608.GB4190@core.coreip.homeip.net>
References: <20100908073233.32365.74621.stgit@hammer.corenet.prv>
 <alpine.LNX.2.00.1009081147540.26813@pobox.suse.cz>
 <20100908142418.GC22323@redhat.com>
 <4C87A87A.4060102@redhat.com>
 <20100908152234.GE22323@redhat.com>
 <alpine.LNX.2.00.1009081723400.26813@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1009081723400.26813@pobox.suse.cz>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Wed, Sep 08, 2010 at 05:25:13PM +0200, Jiri Kosina wrote:
> On Wed, 8 Sep 2010, Jarod Wilson wrote:
> 
> > > > It'll conflict a little bith with the tivo slide patch I posted yesterday,
> > > > but mostly just minor context changes. I can redo that patch on top of
> > > > these changes if that's preferred.
> > > 
> > > I can handle those context changes when merging the patches at linux-next and
> > > when merging upstream. We just need to sync in a way that Dmitry send his patch
> > > series before mine when sending them to Linus, and I'll take care of fixing the
> > > merge conflicts.
> > 
> > Ah, the specific conflicts I was referring here are confined to
> > drivers/hid/hid-input.c, and I sent the patch thinking it would go in via
> > the hid tree. It *is* for a remote, but its a pure HID device in this
> > case.
> 
> Umm, what patch are you talking about please? I don't seem to have 
> anything from you in my queue.
> 

Depending on the extent of the patch in question I could take it through
my tree as well to avoid too much interdependencies between trees at
merge window time...

-- 
Dmitry
