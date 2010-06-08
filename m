Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:34090 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752914Ab0FHRkf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Jun 2010 13:40:35 -0400
Date: Tue, 8 Jun 2010 19:40:31 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Christoph Bartelmus <lirc@bartelmus.de>, jarod@redhat.com,
	linux-media@vger.kernel.org, Jon Smirl <jonsmirl@gmail.com>,
	Andy Walls <awalls@md.metrocast.net>
Subject: Re: [PATCH 1/3] IR: add core lirc device interface
Message-ID: <20100608174031.GB5181@hardeman.nu>
References: <BQCH7Bq3jFB@christoph>
 <4C09482B.8030404@redhat.com>
 <20100607184434.GA19390@hardeman.nu>
 <AANLkTinDTJYUgxxJeSZ_jYYZuBXN8jsvkpZILLyc01jb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinDTJYUgxxJeSZ_jYYZuBXN8jsvkpZILLyc01jb@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jun 07, 2010 at 03:45:38PM -0400, Jarod Wilson wrote:
> On Mon, Jun 7, 2010 at 2:44 PM, David Härdeman <david@hardeman.nu> wrote:
> > On Fri, Jun 04, 2010 at 03:38:35PM -0300, Mauro Carvalho Chehab wrote:
> >> Em 04-06-2010 12:51, Christoph Bartelmus escreveu:
> >> > Hi Mauro,
> >> >
> >> > on 04 Jun 10 at 01:10, Mauro Carvalho Chehab wrote:
> >> >> Em 03-06-2010 19:06, Jarod Wilson escreveu:
> >> > [...]
> >> >>> As for the compat bits... I actually pulled them out of the Fedora kernel
> >> >>> and userspace for a while, and there were only a few people who really ran
> >> >>> into issues with it, but I think if the new userspace and kernel are rolled
> >> >>> out at the same time in a new distro release (i.e., Fedora 14, in our
> >> >>> particular case), it should be mostly transparent to users.
> >> >
> >> >> For sure this will happen on all distros that follows upstream: they'll
> >> >> update lirc to fulfill the minimal requirement at Documentation/Changes.
> >> >>
> >> >> The issue will appear only to people that manually compile kernel and lirc.
> >> >> Those users are likely smart enough to upgrade to a newer lirc version if
> >> >> they notice a trouble, and to check at the forums.
> >> >
> >> >>> Christoph
> >> >>> wasn't a fan of the change, and actually asked me to revert it, so I'm
> >> >>> cc'ing him here for further feedback, but I'm inclined to say that if this
> >> >>> is the price we pay to get upstream, so be it.
> >> >
> >> >> I understand Christoph view, but I think that having to deal with compat
> >> >> stuff forever is a high price to pay, as the impact of this change is
> >> >> transitory and shouldn't be hard to deal with.
> >> >
> >> > I'm not against doing this change, but it has to be coordinated between
> >> > drivers and user-space.
> >> > Just changing lirc.h is not enough. You also have to change all user-space
> >> > applications that use the affected ioctls to use the correct types.
> >> > That's what Jarod did not address last time so I asked him to revert the
> >> > change.
> >>
> >> For sure coordination between kernel and userspace is very important. I'm sure
> >> that Jarod can help with this sync. Also, after having the changes implemented
> >> on userspace, I expect one patch from you adding the minimal lirc requirement
> >> at Documentation/Changes.
> >>
> >> > And I'd also like to collect all other change request to the API
> >> > if there are any and do all changes in one go.
> >>
> >> You and Jarod are the most indicated people to point for such needs. Also, Jon
> >> and David may have some comments.
> >
> > David (who has been absent, sorry about that, life got in the way)
> > thinks that the lirc raw decoder should implement the minimum amount of
> > ioctl's possible while still being usable by the lirc userspace and
> > without going beyond being a raw pulse/space "decoder" or we'll risk
> > having to extend the entire decoder API just to support the lirc
> > compatability decoder.
> 
> Thus far, I can get 100% feature-parity w/lirc_mceusb in my ir-core
> mceusb driver by adding only 3 tx-specific callbacks to ir_dev_props,
> and they're all callbacks (set output mask, set carrier and ir tx
> function) that any rc-core native tx solution is also going to need.

Yes, but I hope...think...that we're going to have one set-RX-parameters 
and one set-TX-parameters callback when we're done. Setting parameters 
could be a costly operation so all settings should be passed to the 
driver in one go (whether they come from an ioctl or some fancy 
sysfs-with-transactions scheme).

On the other hand, changing the callbacks you're proposing once we 
actually have support in rc-core shouldn't be too much work, so I won't 
oppose those changes.

-- 
David Härdeman
