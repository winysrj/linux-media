Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:24675 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751446Ab0IHObd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Sep 2010 10:31:33 -0400
Date: Wed, 8 Sep 2010 10:31:21 -0400
From: Jarod Wilson <jarod@redhat.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Input <linux-input@vger.kernel.org>,
	linux-media@vger.kernel.org,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	David Hardeman <david@hardeman.nu>,
	Jiri Kosina <jkosina@suse.cz>, Ville Syrjala <syrjala@sci.fi>
Subject: Re: [PATCH 0/6] Large scancode handling
Message-ID: <20100908143121.GD22323@redhat.com>
References: <20100908073233.32365.74621.stgit@hammer.corenet.prv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100908073233.32365.74621.stgit@hammer.corenet.prv>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Wed, Sep 08, 2010 at 12:41:38AM -0700, Dmitry Torokhov wrote:
> Hi Mauro,
> 
> I guess I better get off my behind and commit the changes to support large
> scancodes, or they will not make to 2.6.37 either... There isn't much
> changes, except I followed David's suggestion and changed boolean index
> field into u8 flags field. Still, please glance it over once again and
> shout if you see something you do not like.
> 
> Jiri, how do you want to handle the changes to HID? I could either push
> them through my tree together with the first patch or you can push through
> yours once the first change hits mainline.
> 
> Mauro, the same question goes for media/IR patch.
> 
> David, I suppose you still have the winbond remote so you could test
> changes to winbond-cir driver.

This'll be fun. :) David recently posted a patchset that among other
things, ports winbond-cir over to {ir,rc}-core to the tune of ~700 less
lines in winbond-cir.c. It also touches a fair amount of core bits, as
does a patchset posted by Maxim... I suspect this series should probably
go in first though.

> Ville, do you still have the hardware to try our ati_remote2 changes?

If not, I've got the hardware. (Speaking of which, porting ati_remote*
over to {ir,rc}-core is also on the TODO list, albeit with very very
low priority at the moment).

-- 
Jarod Wilson
jarod@redhat.com

