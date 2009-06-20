Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:47337 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758AbZFTTXR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Jun 2009 15:23:17 -0400
Subject: Re: Sakar 57379 USB Digital Video Camera...
From: Andy Walls <awalls@radix.net>
To: Theodore Kilgore <kilgota@banach.math.auburn.edu>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.0906192253080.18675@banach.math.auburn.edu>
References: <1245375652.20630.6.camel@palomino.walls.org>
	 <alpine.LNX.2.00.0906182113010.17417@banach.math.auburn.edu>
	 <1245386416.20630.31.camel@palomino.walls.org>
	 <alpine.LNX.2.00.0906190016070.17528@banach.math.auburn.edu>
	 <1245435414.4181.7.camel@palomino.walls.org>
	 <alpine.LNX.2.00.0906191855110.18505@banach.math.auburn.edu>
	 <1245462845.3168.40.camel@palomino.walls.org>
	 <alpine.LNX.2.00.0906192253080.18675@banach.math.auburn.edu>
Content-Type: text/plain
Date: Sat, 20 Jun 2009 15:23:33 -0400
Message-Id: <1245525813.3178.24.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2009-06-19 at 23:38 -0500, Theodore Kilgore wrote:

> >>
> >> Now it is using the other pair of endpoints, 0x03 and 0x84.
> >
> > Hmmmm.  I wonder if we can use them anyway, without being connected in
> > "webcam" mode.
> 
> Nope. That was the previously mentioned bug in the Linux mass storage 
> driver. Namely the spec calls for using the first pair of endpoints 
> encountered. The bug consisted of the mass storage driver looking for the 
> last pair of endpoints encountered, instead. This was back around kernel 
> 2.6.18 or so when the problem got fixed.
> 
> The second pair of endpoints appears to be very much disconnected in mass 
> storage mode. The attempt to use them will result only in a string of 
> error messages. How well I remember. As to whether the first pair can be 
> used in webcam mode, I clearly have not tried to use them, but I would 
> have strong doubts whether it is even worth trying. Even if they would 
> work, what on earth would they be good for?

Just not having to disconnect the cam to get at the files on it.  It'll
probably be too much for the cheap device to deal with though.


It is interesting to note that the transfer logic of the the device
seems to be oriented around a 512 byte block size - the defacto disk
block size. 


> >> There is a sequence of init commands
> >>
> >>      00000000: 71 81
> >>      00000000: 70 05
> >>      00000000: 95 70
> >>      00000000: 00	(all the 00 are responses)
> >>      00000000: 71 81
> >>      00000000: 70 04
> >>      00000000: 95 70
> >>      00000000: 00
> >>      00000000: 71 00
> >>      00000000: 70 08
> >>      00000000: 95 70
> >>      00000000: 00
> >>      00000000: 94 02
> >>      00000000: de 24
> >>      00000000: 94 02
> >>      00000000: dd f0
> >>      00000000: 94 02
> >>      00000000: e3 2c
> >>      00000000: 94 02
> >>      00000000: e4 00
> >>      00000000: 94 02
> >>      00000000: e5 00
> >>      00000000: e5 00
> >>      00000000: 94 02
> >>      00000000: e6 2c
> >>      00000000: 94 03
> >>      00000000: aa 00
> >>      00000000: 71 1e
> >>      00000000: 70 06
> >>      00000000: 71 80
> >>      00000000: 70 07
> >>
> >> and then it starts to stream. The stream downloads 0x200 (512) bytes at a
> >> time. It appears that there is an SOF marker consisting of
> >>
> >> ff ff ff ff
> >>
> >> followed by at least two zeroes. These seem to occur only at the
> >> beginnings of some of the downloaded 0x200-sized blocks.
> >
> > Given that the AVI file is 320x240 @ 20 fps Motion JPEG, maybe the
> > streaming mode uses something similar.
> >
> > Assuming 6 bit RGB values at 320x240 @ 20 fps:
> >
> > 	(320*240) * 24 bpp * 20 fps = 36.864 Mbps
> >
> > Since this USB 1.1, I'm guessing the stream has to be compressed.
> 
> Sure looks that way. I took a closer look at the lines starting with ff ff 
> ff ff strings, and I found a couple more things. Here are several lines 
> from an extract from that snoop, consisting of what appear to be 
> consecutive SOF lines.
> 
>      00000000: ff ff ff ff 00 00 1c 70 3c 00 0f 01 00 00 00 00
>      00000000: ff ff ff ff 00 00 34 59 1e 00 1b 06 00 00 00 00
>      00000000: ff ff ff ff 00 00 36 89 1e 00 1c 07 00 00 00 00
>      00000000: ff ff ff ff 00 00 35 fc 1e 00 1b 08 00 00 00 00
>      00000000: ff ff ff ff 00 00 35 84 1e 00 1b 09 00 00 00 00
> 
> The last non-zero byte is a frame counter. Presumably, the gap between the 
> 01 and the 06 occurs because the camera was just then starting up and 
> things were a bit chaotic. The rest of the lines in the file are 
> completely consistent, counting consecutively from 09 to 49 (hex, of 
> course) at which point I killed the stream.
> 
> The byte previous to that one (reading downwards 0f 1b 1c 1b 1b ...) gives 
> the number of 0x200-byte blocks in that frame, before the next marker 
> comes along. So if we start from the frame labeled "06" then from there on 
> the frames are approximately the same size, but not identical. For example 
> the size of frame 06 is 0x1b*0x200. That is, 27*512 bytes.
> 
> I am not sure what the other numbers mean. Perhaps you have better guesses 
> than I do.

The first few become easy given your observations.  They are the actaul
payload size:

ceil(0x1c70/0x200) = ceil(0x0e.380) = 0x0f
ceil(0x3549/0x200) = ceil(0x1a.a48) = 0x1b
ceil(0x3689/0x200) = ceil(0x1b.448) = 0x1c
ceil(0x35fc/0x200) = ceil(0x1a.fe0) = 0x1b
ceil(0x3584/0x200) = ceil(0x1a.c20) = 0x1b

The lone 0x3c and the 0x1e's are not so easy:

0x3c = 60
0x1e = 30

Maybe an inidcation of frame rate?

I'll try and think about them a little more.

> >>
> >>      00000000: 71 00
> >>      00000000: 70 09
> >>      00000000: 71 80
> >>      00000000: 70 05
> >>
> >> It would be interesting to see your log file and to compare. I could also
> >> send you this one if you are curious, but it is 5,760,902 bytes so I
> >> should ask that if you want to see it then how to send it? Me, I suspect
> >> that if you have one of similar size and bz2 it and send it to me as an
> >> attachment, then it is not any problem.
> >
> > You could send it to me via email (my ISP bounces *really* big incoming
> > emails but at least 6 MB email can make it through).  However, without
> > the "source" of the image, it might be a little hard to decode the dump.
> >
> 
> I was not pointing the camera at anything in particular. Unless perhaps at 
> the laptop screen? Not sure.
> 
> > I was going to get a stream of:
> >
> > 1) a white sheet of paper
> > 2) a blue sheet of paper
> > 3) a red sheet of paper
> > 4) a green sheet of paper
> > 5) a black sheet of paper
> >
> > 6) a half-white, half black target with the regions separated vertically
> > 7) a half-white, half black target with the regions separated diagonally
> >
> > and maybe some other test patterns.  There's no shortage of construction
> > paper, crayons, and colored markers in my house.
> >
> 
> These are all good. Also I have found out it is sometimes helpful to point 
> a camera at a monitor screen, once I have learned to make raw files, and 
> to do things like xsetroot -solid c0/00/00 and then repeat for 00/c0/00 
> and again for 00/00/c0. and then take a picture of a "flag" by leaving a 
> white xterm sticking out into the picture in one corner.

Ah.  That is convenient.

I'm booting over to Windows now, to grab some dumps.

Regards,
Andy

