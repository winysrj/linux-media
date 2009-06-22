Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:33191 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751228AbZFVL0q (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Jun 2009 07:26:46 -0400
Subject: Re: Sakar 57379 USB Digital Video Camera...
From: Andy Walls <awalls@radix.net>
To: Theodore Kilgore <kilgota@banach.math.auburn.edu>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.0906212230200.31693@banach.math.auburn.edu>
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
Content-Type: text/plain
Date: Mon, 22 Jun 2009 07:27:40 -0400
Message-Id: <1245670060.3178.14.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2009-06-21 at 22:39 -0500, Theodore Kilgore wrote:
> Andy,
> 
> You are right. Your camera is emitting JPEG while streaming. I just 
> succeeded in creating an image which resembles your test picture by 
> extracting the frame data for one frame, tacking on a header, and running 
> hex2bin on the combined file. I did not get the thing quite right, because 
> your header is from your JPEG photo (640x480) and your stream is probably 
> 320x240. But I got something out which is obviously recognizable.

Excellent.  Going from "It may never work" to "something recognizable"
in one weekend is good progress.

> Therefore with a little bit of further tweaking it will presumably come 
> out exactly so. Namely, I have to remember where to stick the two 
> dimensions into the header.

Yes, as far as I'm concerned the problem is solved.  The details are
left as an exercise for the reader. ;)


I'm not up to speed on Linux webcam kernel to userspace API details.
However, might I suggest going forward for testing at least, that when
one starts the webcam streaming, the driver emit the stream in the form
of an AVI.  You'd need an AVI header declaring only an MJPEG 'vids'
stream - no 'auds' nor 'idx' - and a 'movi' section with RIFF/AVI chunks
that have MJPEG headers and the webcam payload.

I haven't seen evidence that audio comes from the webcam when it is
streaming, but I haven't looked very much either.



>  As my students in courses like calculus say, 
> "Sir, it has been a long time since I studied that." Whereupon I reply, 
> "With my white hair, I wonder how far I could get with that excuse?"

:)

> I will send you a copy of the results for your amusement. It is obviously 
> the first attempt, so do not laugh at the fact that you get two copies of
> 
>  	 3
>  	x6
>  	--
> 
> side by side, please.

In retrospect, I should have used the 6x7 (or 6x9) flash card, so the
answer would have been 42. :)

Regards,
Andy


> Theodore Kilgore


