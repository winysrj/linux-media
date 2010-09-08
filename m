Return-path: <mchehab@pedra>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:49487 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754811Ab0IHPep (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Sep 2010 11:34:45 -0400
Date: Wed, 8 Sep 2010 08:34:36 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jarod Wilson <jarod@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Input <linux-input@vger.kernel.org>,
	linux-media@vger.kernel.org,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	David Hardeman <david@hardeman.nu>,
	Jiri Kosina <jkosina@suse.cz>, Ville Syrjala <syrjala@sci.fi>
Subject: Re: [PATCH 0/6] Large scancode handling
Message-ID: <20100908153435.GA4190@core.coreip.homeip.net>
References: <20100908073233.32365.74621.stgit@hammer.corenet.prv>
 <20100908143121.GD22323@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100908143121.GD22323@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Wed, Sep 08, 2010 at 10:31:21AM -0400, Jarod Wilson wrote:
> On Wed, Sep 08, 2010 at 12:41:38AM -0700, Dmitry Torokhov wrote:
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
> > 
> > Mauro, the same question goes for media/IR patch.
> > 
> > David, I suppose you still have the winbond remote so you could test
> > changes to winbond-cir driver.
> 
> This'll be fun. :) David recently posted a patchset that among other
> things, ports winbond-cir over to {ir,rc}-core to the tune of ~700 less
> lines in winbond-cir.c. It also touches a fair amount of core bits, as
> does a patchset posted by Maxim... I suspect this series should probably
> go in first though.
> 

Hmm, the only reason for conversion is that I want to do the back
converstion get/setkeycode_new->get/setkeycode sometimes around
2.6.37-rc2. So it should be perfectly fine for David's changes to go in
and I will just drop my patch completely.

> > Ville, do you still have the hardware to try our ati_remote2 changes?
> 
> If not, I've got the hardware. (Speaking of which, porting ati_remote*
> over to {ir,rc}-core is also on the TODO list, albeit with very very
> low priority at the moment).

Ok, then we'' pencil you in for testing if we do not hear from Ville ;)

-- 
Dmitry
