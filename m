Return-path: <mchehab@pedra>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:1634 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801Ab0IQL0H (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Sep 2010 07:26:07 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Andy Walls <awalls@md.metrocast.net>
Subject: Re: RFC: Move ivtv utilities and ivtv X video extension to v4l-utils
Date: Fri, 17 Sep 2010 13:25:12 +0200
Cc: Hans de Goede <hdegoede@redhat.com>, linux-media@vger.kernel.org,
	ivtv-devel@ivtvdriver.org
References: <1284677925.2056.27.camel@morgan.silverblock.net> <201009171030.15512.hverkuil@xs4all.nl> <1284721149.2064.26.camel@morgan.silverblock.net>
In-Reply-To: <1284721149.2064.26.camel@morgan.silverblock.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201009171325.12247.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Friday, September 17, 2010 12:59:09 Andy Walls wrote:
> On Fri, 2010-09-17 at 10:30 +0200, Hans Verkuil wrote:
> > On Friday, September 17, 2010 00:58:45 Andy Walls wrote:
> > > Hi Hans and Hans,
> > > 
> > > I'd like to move the source code maintained here:
> > > 
> > > http://ivtvdriver.org/svn/
> > > 
> > > to someplace where it may be less likely to suffer bit rot.
> > > I was hoping the v4l-utils git repo would be an appropriate place.
> > > 
> > > Do either of you have any opinions on this?
> > 
> > I agree with this, but it would require some work.
> 
> OK.  But given your comments below, I'm going to change my execution
> strategy: move or port things incrementally, the most used/useful stuff
> first.
> 
> Distribution packages and end users might not like that ("Where did
> ivtv-tune go?") but I don't have a solid block of time to do things all
> in one go.

Distros should always (I hope) distribute v4l-utils these days, so together
with the remaining ivtv-utils the end-user still has a full set :-)

There is nothing to be done about this, and it is quite right that you tackle
this one utility at a time.

> 
> 
> > xf86-video-ivtv really belongs at freedesktop.org as part of the X video drivers.
> > Nobody ever made the effort to integrate it there, but it would be the right
> > thing to do.
> 
> OK.  That's going to be low on my list then.  Given my current
> availability, that might end up looking like a "dump and run" on
> freedesktop.org folks.  That wouldn't be good for anyone.  I suppose I
> should get Ian Armstrong's input on this particular item.

You should certainly do that. But I don't expect this X driver to change
much. And with a bit of luck X API changes might be done for you if this
driver is on freedesktop.org.

> 
> 
> > ivtvtv is more a private test application I made to test the MPEG encoder/decoder
> > API. Either this has to be turned into a more full-fledged application for the
> > PVR-350 and then it definitely might be a good candidate for inclusion in
> > v4l-utils, or it stays here, or I can host it on my website as a simple tar
> > archive.
> 
> Ok, that one will stay on ivtvdriver.org until it becomes better or
> overcome by time.
> 
> 
> > Looking that ivtv itself: in utils we have ivtv-radio, ivtvplay, ivtv-mpegindex,
> > ivtv-tune and cx25840ctl.
> > 
> > ivtv-radio is a good candidate for v4l-utils, but it would be really nice if it
> > could be made more general. E.g. v4l2-radio.
> 
> Yes.  There is not other application like it.  I also think that a
> v4l2-radio would be a good simple candidate for exercising some of the
> Media Controller API:
> 
> 1. Does this device have a radio?
> 2. What is the radio control node?
> 3. Does it have an associated ALSA card? What is the ALSA PCM node?
> 4. Does it have a V4L2 PCM node?

And what would be also great is if it could handle RDS data. We still need a
good test tool for that...

> 
> 
> > Ditto for ivtv-tune (although merging this functionality into v4l2-ctl is also
> > an interesting option).
> 
> Yes.  The only reason I use ivtv-tune is that v4l2-ctl requires me to
> know my analog channel frequencies by number just to change the
> channel. :(
> 
> Given that, I use ivtv-tune a lot.
> 
> Merging it's functionality into v4l2-ctl seems like the way to go.  I'd
> like to do it in such a way that a user preferences file isn't saved
> though.

I frankly always intended to add this functionality to v4l2-ctl, but I never
got around to doing that. The frequency tables are already in v4l-utils.

> 
> 
> > cx25840ctl should really be integrated into v4l2-dbg.
> 
> Hmmm.  That would be an oddly specific addition to v4l2-dbg.  Given that
> we have device nodes on subdev's coming soon, with subdev controls,
> maybe this is obsolete?

Actually, similar functionality already exists in v4l2-dbg for some devices.

The purpose of cx25840ctl is to set/get registers using symbolic names, so that
has nothing to do with subdev controls (those are definitely not meant for
debugging, instead their purpose is to provide more fine-grained control over
the subdev).
 
> Anyway, I never use it.  Which begs the question: If I don't use it, who
> does?

I never used it either. Mainly because I find the symbolic names useless since
all datasheets are always organized around the register address and not the name.
So if I have to use the name then I am forever searching like mad in the
datasheet. I much prefer a raw register address with a useful comment over a
symbolic name.

Looking at v4l2-dbg I would say that it should be easy to add at least the
symbolic register names to that tool. And then we can kill cx25840ctl.

> 
> 
> > ivtv-mpegindex isn't ivtv specific and can go to contrib/test.
> > 
> > ivtvplay I'm not sure about. There is a lot of overlap between ivtvplay and ivtvtv.
> 
> 
> 
> > Regarding the test utilities: some of these can go to contrib/test, some
> > that are really ivtv specific can go to contrib/ivtv. And some should perhaps
> > just die.
> 
> Thanks for the insight on where to put things.
> 
> I agree, some things should just die.  That's part of what I meant by
> bit-rot.
> 
> > Basically ivtv-utils is a bit of a mess: the really good stuff has already been
> > moved to v4l-utils (v4l2-ctl and v4l2-dbg both came out of ivtv and are now
> > maintained in v4l-utils).
> > 
> > So the best thing is probably to clean up the useful utilities and test tools,
> > making them generic where possible, and kill off the rest.
> 
> Yes.  Good strategy.
> 
> 
> > It could be interesting to hear which utilities from ivtv people actually use.
> 
> I'll poll the ivtv-users list later today.
> 
> My most used and useful:
> 
> 1. ivtv-tune: I can't remember freq <-> channel mappings
> 2. ivtv-radio: There is no other CLI tool like it.
> 
> Others I've found useful at times:
> 
> 3. ps-analyzer: Our version can decode MPEG Private ivtv/cx18 VBI
> packets

Definitely useful in contrib/test.

> 4. ivtvtv: Part of it was useful to test the VIDIOC_G_ENC_INDEX ioctl()

It would be so nice if someone actually had the time to clean this one up.
It is really meant as a testbed for (mostly) the decoder part of the PVR-350.
But it could also function very well as a playback utility demonstrating the
MPEG decoding API.

Regards,

	Hans

> 
> 
> Regards,
> Andy
> 
> > Regards,
> > 
> > 	Hans
> 
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
