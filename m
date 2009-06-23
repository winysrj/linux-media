Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:39738 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752326AbZFWKgU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Jun 2009 06:36:20 -0400
Subject: Re: Sakar 57379 USB Digital Video Camera...
From: Andy Walls <awalls@radix.net>
To: Theodore Kilgore <kilgota@banach.math.auburn.edu>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.0906221025080.1721@banach.math.auburn.edu>
References: <1245375652.20630.6.camel@palomino.walls.org>
	 <alpine.LNX.2.00.0906182113010.17417@banach.math.auburn.edu>
	 <1245386416.20630.31.camel@palomino.walls.org>
	 <alpine.LNX.2.00.0906190016070.17528@banach.math.auburn.edu>
	 <1245435414.4181.7.camel@palomino.walls.org>
	 <alpine.LNX.2.00.0906191855110.18505@banach.math.auburn.edu>
	 <1245462845.3168.40.camel@palomino.walls.org>
	 <alpine.LNX.2.00.0906192253080.18675@banach.math.auburn.edu>
	 <1245525813.3178.24.camel@palomino.walls.org>
	 <1245538316.3296.36.camel@palomino.walls.org>
	 <alpine.LNX.2.00.0906201956270.28975@banach.math.auburn.edu>
	 <1245557957.3296.215.camel@palomino.walls.org>
	 <alpine.LNX.2.00.0906211019500.31206@banach.math.auburn.edu>
	 <1245634667.3815.54.camel@palomino.walls.org>
	 <alpine.LNX.2.00.0906212230200.31693@banach.math.auburn.edu>
	 <1245670060.3178.14.camel@palomino.walls.org>
	 <alpine.LNX.2.00.0906221025080.1721@banach.math.auburn.edu>
Content-Type: text/plain
Date: Tue, 23 Jun 2009 06:37:11 -0400
Message-Id: <1245753431.3172.30.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2009-06-22 at 10:51 -0500, Theodore Kilgore wrote:
> 
> On Mon, 22 Jun 2009, Andy Walls wrote:
> 
> > On Sun, 2009-06-21 at 22:39 -0500, Theodore Kilgore wrote:
> >> Andy,
> >>
> >> You are right. Your camera is emitting JPEG while streaming. I just
> >> succeeded in creating an image which resembles your test picture by
> >> extracting the frame data for one frame, tacking on a header, and running
> >> hex2bin on the combined file. I did not get the thing quite right, because
> >> your header is from your JPEG photo (640x480) and your stream is probably
> >> 320x240. But I got something out which is obviously recognizable.
> >
> > Excellent.  Going from "It may never work" to "something recognizable"
> > in one weekend is good progress.
> 
> Well, sometimes the easy and obvious just works, and one is lucky. If only 
> they were all that easy. 

I'd contend most would be easy and obvious, as anything created by
people is usually easy to understand.  People are generally lazy and
want to avoid what they perceive as extra effort.  If you couple that
with management pressure on engineers to keep costs down and maintain
project schedules, you often end up with very simple solutions.

The data encoding used by the camera is indicative of that.  For this
camera, the engineers decided to simply drop the (M)JPEG headers to save
USB communications bandwidth instead of using a different, better
compression algorithm; or a imlementing new USB 2.0 interface.


> Besides, as we well know, this list is a place 
> where geniuses hang out. So perhaps some of the pixie dust has rubbed off 
> on us.

I thought genius was inspiration and perspiration. Pixie dust - I knew
Edison wasn't telling the whole truth. ;)



> >
> >> Therefore with a little bit of further tweaking it will presumably come
> >> out exactly so. Namely, I have to remember where to stick the two
> >> dimensions into the header.
> >
> > Yes, as far as I'm concerned the problem is solved.  The details are
> > left as an exercise for the reader. ;)
> >
> 
> I will try to get on it. There is nothing left but details, but there are 
> lots of those.

Yes, I agree.  Getting those right is no small task.


> The first one is to get the header exactly right.

Well,  given that the Windows driver has the AVI video stream FourCC
'vids' appearing four or five times, I suspect there is more than 1
header template that the Windows driver can tack on to the incoming
stream.  I'm guessing that which one is used, depends on how the camera
stream is initialized.

There are probably all sorts of header permutations that will yield
viewable but suboptimal reconstruction. :(

Then again it's a cheap webcam, so by definition any image is probably
suboptimal.



>  Then 
> there is the question, what is _my_ camera doing? I did not check that 
> yet. And so on. So it is an algorithm now, but many steps remain to be 
> completed.

Yes.  I agree.

> 
> >
> > I'm not up to speed on Linux webcam kernel to userspace API details.
> > However, might I suggest going forward for testing at least, that when
> > one starts the webcam streaming, the driver emit the stream in the form
> > of an AVI.  You'd need an AVI header declaring only an MJPEG 'vids'
> > stream - no 'auds' nor 'idx' - and a 'movi' section with RIFF/AVI chunks
> > that have MJPEG headers and the webcam payload.
> 
> For all I know, it might be just a matter of following down a standard 
> path. Perhaps this is all handled already in libv4lconvert, and it is 
> merely a matter of plugging into that. I haven't checked yet, but that is 
> more or less what I expect right now.


Ah, OK.

> >
> > I haven't seen evidence that audio comes from the webcam when it is
> > streaming, but I haven't looked very much either.
> 
> Same. Actually, my impression is that these cameras can not walk and chew 
> gum at the same time. I would suspect that the audio is an either/or kind 
> of thing. Either on, and it can record audio but not stream it, or off. I 
> would be very surprised if an el cheapo like the one I have could do more. 
> I could be wrong, of course. Perhaps both of us ought to check closely.

I know it can simultaneously record audio and video to an AVI file in
it's local storage.  I'm thinking it would not make sense to shovel over
audio in webcam mode anyway, as most computers have their own microphone
to collect sound.


> >
> > In retrospect, I should have used the 6x7 (or 6x9) flash card, so the
> > answer would have been 42. :)
> 
> Well, then there would be no mysteries left, would there? We couldn't have 
> that.
> 
> This is Monday, and I have to go off to the salt mine. I may be able to 
> get back to this after coming home from the class.

I have no timeline in mind.  Having this webcam work will simply be a
"nice to have".  I'm available for testing and any
investigation/research that you don't have time to do.

Regards,
Andy


> Theodore Kilgore
> 

