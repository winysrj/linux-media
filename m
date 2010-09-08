Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:15368 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751486Ab0IHOYn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Sep 2010 10:24:43 -0400
Date: Wed, 8 Sep 2010 10:24:18 -0400
From: Jarod Wilson <jarod@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Input <linux-input@vger.kernel.org>,
	linux-media@vger.kernel.org,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	David Hardeman <david@hardeman.nu>,
	Ville Syrjala <syrjala@sci.fi>
Subject: Re: [PATCH 0/6] Large scancode handling
Message-ID: <20100908142418.GC22323@redhat.com>
References: <20100908073233.32365.74621.stgit@hammer.corenet.prv>
 <alpine.LNX.2.00.1009081147540.26813@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1009081147540.26813@pobox.suse.cz>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Wed, Sep 08, 2010 at 11:48:50AM +0200, Jiri Kosina wrote:
> On Wed, 8 Sep 2010, Dmitry Torokhov wrote:
> 
> > Hi Mauro,
> > 
> > I guess I better get off my behind and commit the changes to support large
> > scancodes, or they will not make to 2.6.37 either... There isn't much
> > changes, except I followed David's suggestion and changed boolean index
> > field into u8 flags field. Still, please glance it over once again and
> > shout if you see something you do not like.
> > 
> > Jiri, how do you want to handle the changes to HID? I could either push
> > them through my tree together with the first patch or you can push through
> > yours once the first change hits mainline.
> 
> I think that there will unlikely be any conflict in .37 merge window in 
> this area (and if there were, I'll sort it out).
> 
> So please add
> 
> 	Acked-by: Jiri Kosina <jkosina@suse.cz>
> 
> to the hid-input.c bits and feel free to take it through your tree, if it 
> is convenient for you.

It'll conflict a little bith with the tivo slide patch I posted yesterday,
but mostly just minor context changes. I can redo that patch on top of
these changes if that's preferred.

-- 
Jarod Wilson
jarod@redhat.com

