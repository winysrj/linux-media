Return-path: <mchehab@pedra>
Received: from eu1sys200aog109.obsmtp.com ([207.126.144.127]:33417 "EHLO
	eu1sys200aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753779Ab0KIJzB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Nov 2010 04:55:01 -0500
From: Michael PARKER <michael.parker@st.com>
To: =?iso-8859-1?Q?Daniel_Gl=F6ckner?= <daniel-gl@gmx.net>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Tue, 9 Nov 2010 10:34:29 +0100
Subject: RE: Format of /dev/video0 data for HVR-4000 frame grabber
Message-ID: <A3BF01DB4A606149A4C20C4C4C808F6C2A2CACB0B5@SAFEX1MAIL1.st.com>
References: <A3BF01DB4A606149A4C20C4C4C808F6C2A2CACB088@SAFEX1MAIL1.st.com>
 <20101109091024.GA15043@minime.bse>
In-Reply-To: <20101109091024.GA15043@minime.bse>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Daniel,

Many thanks for your mail. Please excuse the naivety of my questions - I'm a h/w guy and a nube to the s/w world.

> -----Original Message-----
> From: Daniel Glöckner [mailto:daniel-gl@gmx.net]
> Sent: 09 November 2010 09:10
> To: Michael PARKER
> Cc: linux-media@vger.kernel.org
> Subject: Re: Format of /dev/video0 data for HVR-4000 frame grabber
> 
> On Tue, Nov 09, 2010 at 09:43:29AM +0100, Michael PARKER wrote:
> > I'm attempting to capture a single frame from the /dev/video0 output of
> > my HVR-4000 card's analogue tuner as a JPEG.
> >
> > Whilst several resources exist for capturing the output of a card with
> > h/w MPEG compression, I'm unable to determine the format of the
> > /dev/video0 data for a frame grabber such as the HVR-4000.
> 
> According to the sourcecode the cx88 chip can do 8 bit grayscale,
> 15/16/24/32 bit RGB/BGR, and two variants of 4:2:2 YCbCr.

Do you know which of these is the default format or how to determine the format I'm seeing coming out of /dev/video0? 

Do you have a suggestion for how data captured from /dev/video0 can be converted into a recognisable image format (JPEG, GIF, PNG etc.)?

I'm keen, if possible, to grab the single frame image using just command line tools and without recourse to ioctls, compiled code etc.

> > Can anyone suggest a means by which I can capture a single frame from a
> > frame grabber card? Can I just use "dd if=/dev/video0 of=image.jpg bs=64K"
> > or similar or do I have to access the card via the V4L2 drivers?
> 
> Yes, dd should work but you need to use a blocksize that can hold a
> complete frame and count=1 if you want a single frame. JPEG, as
> mentioned above, is not possible with this board.

Presumably blocksize is just x * y * depth? Do you happen to know the default x/y for the cx88 output? 

I assume that x/y can be set via ioctls but, as stated earlier, I'm keen to avoid writing/compiling code if I can. 

Do I need to make any allowance for any form of header within the blocksize?

Also, how do I synchronise dd to the beginning of a new frame (and thus avoid capturing sections of two frames)?

Thanks again,

Mike
