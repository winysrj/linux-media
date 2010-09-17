Return-path: <mchehab@pedra>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:1521 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354Ab0IQIbH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Sep 2010 04:31:07 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Andy Walls <awalls@md.metrocast.net>
Subject: Re: RFC: Move ivtv utilities and ivtv X video extension to v4l-utils
Date: Fri, 17 Sep 2010 10:30:15 +0200
Cc: Hans de Goede <hdegoede@redhat.com>, linux-media@vger.kernel.org,
	ivtv-devel@ivtvdriver.org
References: <1284677925.2056.27.camel@morgan.silverblock.net>
In-Reply-To: <1284677925.2056.27.camel@morgan.silverblock.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201009171030.15512.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Friday, September 17, 2010 00:58:45 Andy Walls wrote:
> Hi Hans and Hans,
> 
> I'd like to move the source code maintained here:
> 
> http://ivtvdriver.org/svn/
> 
> to someplace where it may be less likely to suffer bit rot.
> I was hoping the v4l-utils git repo would be an appropriate place.
> 
> Do either of you have any opinions on this?

I agree with this, but it would require some work.

xf86-video-ivtv really belongs at freedesktop.org as part of the X video drivers.
Nobody ever made the effort to integrate it there, but it would be the right
thing to do.

ivtvtv is more a private test application I made to test the MPEG encoder/decoder
API. Either this has to be turned into a more full-fledged application for the
PVR-350 and then it definitely might be a good candidate for inclusion in
v4l-utils, or it stays here, or I can host it on my website as a simple tar
archive.

Looking that ivtv itself: in utils we have ivtv-radio, ivtvplay, ivtv-mpegindex,
ivtv-tune and cx25840ctl.

ivtv-radio is a good candidate for v4l-utils, but it would be really nice if it
could be made more general. E.g. v4l2-radio.

Ditto for ivtv-tune (although merging this functionality into v4l2-ctl is also
an interesting option).

cx25840ctl should really be integrated into v4l2-dbg.

ivtv-mpegindex isn't ivtv specific and can go to contrib/test.

ivtvplay I'm not sure about. There is a lot of overlap between ivtvplay and ivtvtv.

Regarding the test utilities: some of these can go to contrib/test, some
that are really ivtv specific can go to contrib/ivtv. And some should perhaps
just die.

Basically ivtv-utils is a bit of a mess: the really good stuff has already been
moved to v4l-utils (v4l2-ctl and v4l2-dbg both came out of ivtv and are now
maintained in v4l-utils).

So the best thing is probably to clean up the useful utilities and test tools,
making them generic where possible, and kill off the rest.

It could be interesting to hear which utilities from ivtv people actually use.

Regards,

	Hans

> 
> If you think it would be acceptable, do you have a preference on where
> they would be placed in the v4l-utils directory structure?
> 
> Thanks.
> 
> Regards,
> Andy
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
