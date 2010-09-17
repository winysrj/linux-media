Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:19812 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751660Ab0IQK7w (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Sep 2010 06:59:52 -0400
Subject: Re: RFC: Move ivtv utilities and ivtv X video extension to
 v4l-utils
From: Andy Walls <awalls@md.metrocast.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Hans de Goede <hdegoede@redhat.com>, linux-media@vger.kernel.org,
	ivtv-devel@ivtvdriver.org
In-Reply-To: <201009171030.15512.hverkuil@xs4all.nl>
References: <1284677925.2056.27.camel@morgan.silverblock.net>
	 <201009171030.15512.hverkuil@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 17 Sep 2010 06:59:09 -0400
Message-ID: <1284721149.2064.26.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, 2010-09-17 at 10:30 +0200, Hans Verkuil wrote:
> On Friday, September 17, 2010 00:58:45 Andy Walls wrote:
> > Hi Hans and Hans,
> > 
> > I'd like to move the source code maintained here:
> > 
> > http://ivtvdriver.org/svn/
> > 
> > to someplace where it may be less likely to suffer bit rot.
> > I was hoping the v4l-utils git repo would be an appropriate place.
> > 
> > Do either of you have any opinions on this?
> 
> I agree with this, but it would require some work.

OK.  But given your comments below, I'm going to change my execution
strategy: move or port things incrementally, the most used/useful stuff
first.

Distribution packages and end users might not like that ("Where did
ivtv-tune go?") but I don't have a solid block of time to do things all
in one go.


> xf86-video-ivtv really belongs at freedesktop.org as part of the X video drivers.
> Nobody ever made the effort to integrate it there, but it would be the right
> thing to do.

OK.  That's going to be low on my list then.  Given my current
availability, that might end up looking like a "dump and run" on
freedesktop.org folks.  That wouldn't be good for anyone.  I suppose I
should get Ian Armstrong's input on this particular item.


> ivtvtv is more a private test application I made to test the MPEG encoder/decoder
> API. Either this has to be turned into a more full-fledged application for the
> PVR-350 and then it definitely might be a good candidate for inclusion in
> v4l-utils, or it stays here, or I can host it on my website as a simple tar
> archive.

Ok, that one will stay on ivtvdriver.org until it becomes better or
overcome by time.


> Looking that ivtv itself: in utils we have ivtv-radio, ivtvplay, ivtv-mpegindex,
> ivtv-tune and cx25840ctl.
> 
> ivtv-radio is a good candidate for v4l-utils, but it would be really nice if it
> could be made more general. E.g. v4l2-radio.

Yes.  There is not other application like it.  I also think that a
v4l2-radio would be a good simple candidate for exercising some of the
Media Controller API:

1. Does this device have a radio?
2. What is the radio control node?
3. Does it have an associated ALSA card? What is the ALSA PCM node?
4. Does it have a V4L2 PCM node?


> Ditto for ivtv-tune (although merging this functionality into v4l2-ctl is also
> an interesting option).

Yes.  The only reason I use ivtv-tune is that v4l2-ctl requires me to
know my analog channel frequencies by number just to change the
channel. :(

Given that, I use ivtv-tune a lot.

Merging it's functionality into v4l2-ctl seems like the way to go.  I'd
like to do it in such a way that a user preferences file isn't saved
though.


> cx25840ctl should really be integrated into v4l2-dbg.

Hmmm.  That would be an oddly specific addition to v4l2-dbg.  Given that
we have device nodes on subdev's coming soon, with subdev controls,
maybe this is obsolete?

Anyway, I never use it.  Which begs the question: If I don't use it, who
does?


> ivtv-mpegindex isn't ivtv specific and can go to contrib/test.
> 
> ivtvplay I'm not sure about. There is a lot of overlap between ivtvplay and ivtvtv.



> Regarding the test utilities: some of these can go to contrib/test, some
> that are really ivtv specific can go to contrib/ivtv. And some should perhaps
> just die.

Thanks for the insight on where to put things.

I agree, some things should just die.  That's part of what I meant by
bit-rot.

> Basically ivtv-utils is a bit of a mess: the really good stuff has already been
> moved to v4l-utils (v4l2-ctl and v4l2-dbg both came out of ivtv and are now
> maintained in v4l-utils).
> 
> So the best thing is probably to clean up the useful utilities and test tools,
> making them generic where possible, and kill off the rest.

Yes.  Good strategy.


> It could be interesting to hear which utilities from ivtv people actually use.

I'll poll the ivtv-users list later today.

My most used and useful:

1. ivtv-tune: I can't remember freq <-> channel mappings
2. ivtv-radio: There is no other CLI tool like it.

Others I've found useful at times:

3. ps-analyzer: Our version can decode MPEG Private ivtv/cx18 VBI
packets
4. ivtvtv: Part of it was useful to test the VIDIOC_G_ENC_INDEX ioctl()


Regards,
Andy

> Regards,
> 
> 	Hans


