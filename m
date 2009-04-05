Return-path: <linux-media-owner@vger.kernel.org>
Received: from cnc.isely.net ([64.81.146.143]:43375 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752594AbZDESkY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 5 Apr 2009 14:40:24 -0400
Date: Sun, 5 Apr 2009 13:40:21 -0500 (CDT)
From: Mike Isely <isely@isely.net>
Reply-To: Mike Isely <isely@pobox.com>
To: Jean Delvare <khali@linux-fr.org>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	LMML <linux-media@vger.kernel.org>,
	Andy Walls <awalls@radix.net>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mike Isely at pobox <isely@pobox.com>
Subject: Re: [PATCH 0/6] ir-kbd-i2c conversion to the new i2c binding model
In-Reply-To: <20090405164024.1459e4fe@hyperion.delvare>
Message-ID: <Pine.LNX.4.64.0904051334340.32738@cnc.isely.net>
References: <20090404142427.6e81f316@hyperion.delvare>
 <20090405070116.17ecadef@pedra.chehab.org> <20090405164024.1459e4fe@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 5 Apr 2009, Jean Delvare wrote:

> Hi Mauro,
> 
> On Sun, 5 Apr 2009 07:01:16 -0300, Mauro Carvalho Chehab wrote:
> > From the discussions we already have, I noticed some points to take care of:
> > 
> > 1) about the lirc support, I don't think we should change a kernel driver due
> > to an out-of-tree kernel driver. As I've commented on PATCH 3/6 discussion, we
> > need to better address this with lirc developers;
> 
> Well, the new binding model makes it harder for "rogue" drivers such as
> lirc_i2c. They will need _some_ form of cooperation from us, which will
> most likely come when they get merged into the kernel tree.
> 
> > 2) the way Mike is proposing to solve the issue with pvrusb2 will break
> > userspace usage for people that have those devices whose IR work with the
> > in-kernel IR i2c driver. This means that we'll cause a kernel regression due to
> > an out-of-tree driver;

It's an either/or.  If nothing is done, the ir-kbd-i2c become unusable 
for pvrusb2 but lirc (for now) continues to work.  If Jean's change is 
accepted as-is, then ir-kbd-i2c will be ok but now lirc is toast.  If I 
implement what I am suggesting, then it becomes possible at least for 
both cases to still work, but with a module option.  Not perfect, but it 
is the only way I see to allow this situation to retain some sanity.

In the longer term, the lirc folks are going to have to change what they 
are doing.  Fine, that's a problem they have to solve.  It's nothing I 
can do anyting about.  But I am not going to be the instigator that 
breaks lirc as used by the pvrusb2 driver.

In the short term, implementing the module option breaks the deadlock 
here.  Jean can continue getting rid of the old i2c model and I won't be 
a pain about it.


> > 
> > 3) So far, nobody gave us any positive return that the new IR model is working with
> > any of the touched drivers. So, more tests are needed. I'm expecting to have a
> > positive reply for each of the touched drivers. People, please test!
> 
> Yes, please! :)
> 
> > Since the merge window is almost finished, IMO, we should postpone those
> > changes to 2.6.31, (...)
> 
> The legacy i2c model will be gone in 2.6.30. Really. Hans and myself
> have put enough energy into this to not let it slip for just a
> miserable infrared support module which I understand is hardly used by
> anyone.
> 
> So it's really up to you, either you accept my ir-kbd-i2c conversion
> "now" (that is, when it has received the minimum testing and reviewing
> it deserves) and ir-kbd-i2c has a chance to work in 2.6.30, or you
> don't and I'll just have to mark ir-kbd-i2c as BROKEN to prevent build
> failures.

Accept his ir-kbd-i2c conversion now, minus the pvrusb2 changes.  I will 
deal with the pvrusb2 driver appropriately (and immediately).  That 
should resolve the issue for the short term.


> 
> > to better address the lirc issue and to give people more
> > time for testing, applying the changesets after the end of the merge window at
> > the v4l/dvb development tree. This will help people to test, review and propose
> > changes if needed.
> 
> These changes are on-going for over a year now. If the lirc people
> didn't hear about it so far, I doubt they will pay more attention just
> because we delay the deadline by 2 months. The only thing that will get
> their attention is when lirc_i2c break. So let's just do that ;)
> 
> Don't get me wrong. I don't want to be (too) rude to lirc developers.
> If they need help to port their code to the new i2c binding model, I'll
> help them. If they need help to merge lirc_i2c into the kernel, I'll
> help as well. But I don't see any point in delaying important, long
> awaited kernel changes just for them. As long as they are out-of-tree,
> they can fix things after the fact easily. They aren't affected by the
> merge window. They'll have several weeks before kernel 2.6.30 is
> actually released, which they can use to fix anything that broke.
> 

I agree.

  -Mike


-- 

Mike Isely
isely @ pobox (dot) com
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
