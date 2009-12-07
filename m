Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:56601 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935596AbZLGViN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Dec 2009 16:38:13 -0500
Date: Mon, 7 Dec 2009 13:38:11 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Jon Smirl <jonsmirl@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	hermann pitton <hermann-pitton@arcor.de>,
	Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net,
	j@jannau.net, jarod@redhat.com, jarod@wilsonet.com,
	kraxel@redhat.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
	IR  system?
Message-ID: <20091207213811.GE998@core.coreip.homeip.net>
References: <BEJgSGGXqgB@lirc> <9e4733910912041628g5bedc9d2jbee3b0861aeb5511@mail.gmail.com> <1260070593.3236.6.camel@pc07.localdom.local> <20091206065512.GA14651@core.coreip.homeip.net> <4B1B99A5.2080903@redhat.com> <m3638k6lju.fsf@intrepid.localdomain> <9e4733910912060952h4aad49dake8e8486acb6566bc@mail.gmail.com> <m3skbn6dv1.fsf@intrepid.localdomain> <20091207184153.GD998@core.coreip.homeip.net> <m3my1u35t2.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m3my1u35t2.fsf@intrepid.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Dec 07, 2009 at 09:08:57PM +0100, Krzysztof Halasa wrote:
> Dmitry Torokhov <dmitry.torokhov@gmail.com> writes:
> 
> >> There is only one thing which needs attention before/when merging LIRC:
> >> the LIRC user-kernel interface. In-kernel "IR system" is irrelevant and,
> >> actually, making a correct IR core design without the LIRC merged can be
> >> only harder.
> >
> > This sounds like "merge first, think later"...
> 
> I'd say "merge the sane agreed and stable things first and think later
> about improvements".
> 
> > The question is why we need to merge lirc interface right now, before we
> > agreed on the sybsystem architecture?
> 
> Because we need the features and we can't improve something which is
> outside the kernel. What "subsystem architecture" do you want to
> discuss? Unrelated (input layer) interface?
>

No, the IR core responsible for registering receivers and decoders.

> Those are simple things. The only part which needs to be stable is the
> (in this case LIRC) kernel-user interface.

For which some questions are still open. I believe Jon just oulined some
of them.

> 
> > Noone _in kernel_ user lirc-dev
> > yet and, looking at the way things are shaping, no drivers will be
> > _directly_ using it after it is complete. So, even if we merge it right
> > away, the code will have to be restructured and reworked.
> 
> Sure. We do this constantly to every part of the kernel.

No we do not. We do not merge something that we expect to rework almost
completely (no, not the lirc-style device userspace inetrface, although
even it is not completely finalized I believe, but the rest of the
subsystem).

> 
> > Unfortunately,
> > just merging what Jarod posted, will introduce sysfs hierarchy which
> > is userspace interface as well (although we not as good maintaining it
> > at times) and will add more constraints on us.
> 
> Then perhaps it should be skipped, leaving only the things udev needs to
> create /dev/ entries. They don't have to be particularly stable.
> Perhaps it should go to the staging first. We can't work with the code
> outside the kernel, staging has not such limitation.

OK, say we add this to staging as is. What is next? Who will be using
this code that is now in staging? Do we encougrage driver's writers to
hook into it (given that we intend on redoing it soon)? Do something
else?

> 
> > That is why I think we should go the other way around - introduce the
> > core which receivers could plug into and decoder framework and once it
> > is ready register lirc-dev as one of the available decoders.
> 
> That means all the work has to be kept and then merged "atomically",
> it seems there is a lack of manpower for this.

No, not at all. You merge core subsystem code, then start addig
decoders... In the meantime driver-writers could start preparing their
drivers to plug into it.

In the mean time out-of-tree LIRC can be used by consumers undisturbed.

-- 
Dmitry
