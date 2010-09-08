Return-path: <mchehab@pedra>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:57393 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755598Ab0IHPgv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Sep 2010 11:36:51 -0400
Date: Wed, 8 Sep 2010 08:36:45 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Input <linux-input@vger.kernel.org>,
	linux-media@vger.kernel.org, Jarod Wilson <jarod@redhat.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	David Hardeman <david@hardeman.nu>,
	Ville Syrjala <syrjala@sci.fi>
Subject: Re: [PATCH 0/6] Large scancode handling
Message-ID: <20100908153644.GC4190@core.coreip.homeip.net>
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
> 

Thanks Jiri.

-- 
Dmitry
