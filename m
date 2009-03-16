Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:38982 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752634AbZCPLD0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2009 07:03:26 -0400
Date: Mon, 16 Mar 2009 08:02:57 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
Cc: "Trent Piepho" <xyzzy@speakeasy.org>, linux-media@vger.kernel.org
Subject: Re: REVIEW: bttv conversion to v4l2_subdev
Message-ID: <20090316080257.532a15d1@gaivota.chehab.org>
In-Reply-To: <37140.62.70.2.252.1237200252.squirrel@webmail.xs4all.nl>
References: <37140.62.70.2.252.1237200252.squirrel@webmail.xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 16 Mar 2009 11:44:12 +0100 (CET)
"Hans Verkuil" <hverkuil@xs4all.nl> wrote:

> >> > What new module parameters did you add?
> >>
> >> tvaudio to override the 'needs_tvaudio' from the card definition.
> >
> > At least on the first kernel with the new driver, IMO, the default should
> > for
> > this option should be 1.
> 
> I disagree. If you set it to 1 then incorrect card definitions will never
> be detected.

Good point. Yet, we should try to minimize troubles to the end user. I suspect
that we'll have more problems by disabling it than if we enable it. 

> You have a new tvaudio module option that you can use to
> setup the right value and, when used, prints a log message telling the
> user to inform the mailinglist about it.

Filling tvaudio with lots of options won't help if the user doesn't know what
should he do. It seems that we'll need some kind of FAQ describing how can an
user replicate the behaviour that he had with bttv with the new way.

> >
> > This seems even worse. The problem is not related with a I2C range, but
> > with
> > the fact that msp3400 were designed by the manufacturer to work at the
> > address
> > with addresses 0x40 or 0x44. There's no practical way (or reason) for any
> > bttv
> > vendor to use msp3400 on any other address.
> >
> > So, the bttv and other adapter should only use either one of those two i2c
> > addresses if they're trying to talk with msp3400.
> 
> Not sure what your point is. That's exactly what is happening. And as I
> stated it is my intention to move the list of possible addresses supported
> by an i2c device to the device's header in include/media. But I prefer to
> do that *after* all drivers are converted to v4l2_subdev so that I have a
> good overview of how the various devices are probed.
> 
> If you insist I can do this part first, but I'd really rather do it
> afterwards as part of a final cleanup sweep.

This can be done on a final step.

> >> > How has module loading changed?  Can one no longer *not* autoload
> >> modules
> >> > if you are trying to test drivers that are not installed in
> >> /lib/modules?
> >>
> >> The adapter driver initiates loading of the i2c modules and probes for
> >> and
> >> attaches to the i2c devices. Just doing 'modprobe foo' will no longer
> >> cause
> >> it to attach to any i2c adapter.
> >
> > I think that Trent's talking about a different issue. Since nobody knows
> > what
> > boards will be broken by this changeset, and assuming that this can
> > happen, it
> > is important to have some options for the user to change the behaviour, to
> > reproduce what we had before.
> 
> That's why I added the tvaudio module option.

See above. We should describe what options will now be needed, when converting
from a legacy /etc/modprobe.conf into a new one, while keeping the driver
working.

> 
> >
> > So, currently, if you load bttv with:
> > 	bttv autoload=0
> >
> > Any user can just load the drivers he knows that it works with his device,
> > avoiding to load other drivers that could cause troubles.
> >
> > IMO, we should have something like this, to offer as an option. Maybe
> > something like:
> > 	bttv probe_only_i2c_addresses=0x40,0x48,0x60
> 
> As far as I can tell this isn't needed at all and only makes things
> complicated for the user. If you really want to go this way, then we
> should add an msp3400 and tda7432 option alongside the tvaudio option.
> That way you can enable/disable each module that bttv needs. I believe
> that there is no need for this since msp3400 already detects whether it
> found a msp3400 or not, and tda7432 doesn't conflict with anything as far
> as I am aware.

I'm not concerned with things that we are aware, but with things we aren't.

We're touching hardly on a driver that none of us has a complete domain. It is
old, designed during kernel 2.2, supports a huge number of different boards
will all sorts of eccentricities, etc. 

I wouldn't doubt if some device has some I2C chipset that we aren't aware (and
currently untouched, when autoprobe=0). For example, some i2c chip at tda7432
and the new behaviour will incorrectly set it to wrong values since right now
autoload can't be disabled.


Cheers,
Mauro
