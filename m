Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:57300 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751887AbZFTBw5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Jun 2009 21:52:57 -0400
Subject: Re: Sakar 57379 USB Digital Video Camera...
From: Andy Walls <awalls@radix.net>
To: Theodore Kilgore <kilgota@banach.math.auburn.edu>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.0906191855110.18505@banach.math.auburn.edu>
References: <1245375652.20630.6.camel@palomino.walls.org>
	 <alpine.LNX.2.00.0906182113010.17417@banach.math.auburn.edu>
	 <1245386416.20630.31.camel@palomino.walls.org>
	 <alpine.LNX.2.00.0906190016070.17528@banach.math.auburn.edu>
	 <1245435414.4181.7.camel@palomino.walls.org>
	 <alpine.LNX.2.00.0906191855110.18505@banach.math.auburn.edu>
Content-Type: text/plain
Date: Fri, 19 Jun 2009 21:54:05 -0400
Message-Id: <1245462845.3168.40.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2009-06-19 at 19:26 -0500, Theodore Kilgore wrote:
> 
> On Fri, 19 Jun 2009, Andy Walls wrote:
> 
> > On Fri, 2009-06-19 at 12:47 -0500, Theodore Kilgore wrote:
> >>
> >> On Fri, 19 Jun 2009, Andy Walls wrote:
> >>
> >>> On Thu, 2009-06-18 at 21:43 -0500, Theodore Kilgore wrote:
> >>>>
> >>>> On Thu, 18 Jun 2009, Andy Walls wrote:
> >>>>>
> >>>>>
> >>>>>
> >>>>
> >>>> Interesting. To answer your question, I have no idea off the top of my
> >>>> head. I do have what seems to be a similar camera. It is
> >>>>
> >>>> Bus 005 Device 006: ID 0979:0371 Jeilin Technology Corp., Ltd
> >>>>
> >>>> and the rest of the lsusb output looks quite similar. I do not know,
> >>>> though, if it has any chance of working as a webcam. Somehow, the thought
> >>>> never occurred to me back when I got the thing. I would have to hunt some
> >>>> stuff down even to know if it is claimed to work as a webcam.
> >>>
> >>> The packaging that mine came in claims "3-in-1":
> >>>
> >>> digital video camcorder (with microphone)
> >>> digital camera
> >>> web cam
> >>>
> >>>
> >>>> You did say that it comes up as a different USB device when it is a
> >>>> webcam? You mean, a different product ID or so?
> >>>
> >>> Yes
> >>>
> >>> Look for this in the original lsusb output I provided
> >>> :
> >>>>> Webcam mode:
> >>>>>
> >>>>> Bus 003 Device 005: ID 0979:0280 Jeilin Technology Corp., Ltd
> >>>>> Device Descriptor:
> >>
> >> Oops, right you are. Blame it on my old eyes. They are the same age as the
> >> rest of me, but sometimes they feel older.
> 
> And the upshot is that we may have the same camera, at least as a webcam, 
> perhaps with a different name. I finally made mine to work in webcam mode. 
> On mine, one has to press down a button labelled "DV" at the same time as 
> pressing down the button with the picture of a camera beside it, to turn 
> on the webcam mode. As opposed to just pressing the "camera" button to 
> turn on the camera to shoot a picture.

Ah, very nice.  The secret handshake that only the manual (usually lost)
can tell you.



> > OK.  I have two steps to take:
> >
> > 1. Installing the driver and software on my sole remaining Windows
> > machine.  It already has snoopy.
> >
> > 2. Getting the camera away from my daughter for more than 2 minutes.
> > It's like the thing is glued to her hand. :)
> 
> I hope that you can still manage to do these things. I did get a snoop log 
> of my own, but it would be nice to have some confirmation, too, that the 
> cameras really are acting the same way. That may look like a stupid thing 
> to say until one realizes that things which have the same USB 
> Vendor:Product number do _not_ necessarily act the same way.

Yes.  I might need a little time.  This weekend is Father's day, and I
got to go see family tomorrow and will be hosting more family on
Saturday evening and Sunday.  I doubt I'll have time to look at this
before Sunday night (and by then I suspect I'll be drinking beer. :))

I did let gThumb import some files from my daughter's camera (Ireally
should have pulled them over myself from the "mass storage drive").
Here's how they ended up:

$ file *
00001.jpg: JPEG image data, EXIF standard 2.2
00002.jpg: JPEG image data, EXIF standard 2.2
00003.jpg: JPEG image data, EXIF standard 2.2
00004.avi: RIFF (little-endian) data, AVI, 320 x 240, 20.00 fps, video: Motion JPEG, audio: uncompressed PCM (mono, 8000 Hz)
00005.jpg: JPEG image data, EXIF standard 2.2
00006.jpg: JPEG image data, EXIF standard 2.2
00007.jpg: JPEG image data, EXIF standard 2.2
00008.jpg: JPEG image data, EXIF standard 2.2
00009.jpg: JPEG image data, EXIF standard 2.2
00010.jpg: JPEG image data, EXIF standard 2.2

All the photos were JPEGs and the movie was playable.  Totem/gstreamer
did a much better job of playing back the audio in the movie than
mplayer.  Surprising to me, but 8 ksps mono is just awful anyway.



> Well, here are some of the things I learned:
> 
> As a stillcam, it is confirmed that my cam is a standard mass storage 
> device, transparent SCSI, bulk. It uses outep 0x01 and inep 0x82 (the 
> first pair of endpoints).
> 
> Here it is as a mass storage device.
> 
> 
> T:  Bus=05 Lev=01 Prnt=01 Port=01 Cnt=01 Dev#=  2 Spd=12  MxCh= 0
> D:  Ver= 1.10 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 8 #Cfgs=  1
> P:  Vendor=0979 ProdID=0371 Rev= 1.00
> S:  Manufacturer=Jeilin
> S:  Product=USB 1.1 Device
> S:  SerialNumber=09790
                   ^^^^^
So much for a unique serial number.  I haven't checked mine yet, but I
bet it's the same.

> C:* #Ifs= 1 Cfg#= 1 Atr=80 MxPwr=500mA
> I:* If#= 0 Alt= 0 #EPs= 4 Cls=08(stor.) Sub=06 Prot=50 Driver=usb-storage
> E:  Ad=01(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
> E:  Ad=82(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
> E:  Ad=03(O) Atr=02(Bulk) MxPS=   8 Ivl=0ms
> E:  Ad=84(I) Atr=02(Bulk) MxPS=   8 Ivl=0ms
> 
> and here it is as a webcam.
> 
> 
> T:  Bus=05 Lev=01 Prnt=01 Port=01 Cnt=01 Dev#= 16 Spd=12  MxCh= 0
> D:  Ver= 1.10 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 8 #Cfgs=  1
> P:  Vendor=0979 ProdID=0280 Rev= 1.00
> S:  Manufacturer=Jeilin
> S:  Product=USB 1.1 Device
> C:* #Ifs= 1 Cfg#= 1 Atr=80 MxPwr=500mA
> I:* If#= 0 Alt= 0 #EPs= 4 Cls=00(>ifc ) Sub=00 Prot=00 Driver=(none)
> E:  Ad=01(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
> E:  Ad=82(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
> E:  Ad=03(O) Atr=02(Bulk) MxPS=   8 Ivl=0ms
> E:  Ad=84(I) Atr=02(Bulk) MxPS=   8 Ivl=0ms
> 
> Now it is using the other pair of endpoints, 0x03 and 0x84.

Hmmmm.  I wonder if we can use them anyway, without being connected in
"webcam" mode.



> There is a sequence of init commands
> 
>      00000000: 71 81
>      00000000: 70 05
>      00000000: 95 70
>      00000000: 00	(all the 00 are responses)
>      00000000: 71 81
>      00000000: 70 04
>      00000000: 95 70
>      00000000: 00
>      00000000: 71 00
>      00000000: 70 08
>      00000000: 95 70
>      00000000: 00
>      00000000: 94 02
>      00000000: de 24
>      00000000: 94 02
>      00000000: dd f0
>      00000000: 94 02
>      00000000: e3 2c
>      00000000: 94 02
>      00000000: e4 00
>      00000000: 94 02
>      00000000: e5 00
>      00000000: e5 00
>      00000000: 94 02
>      00000000: e6 2c
>      00000000: 94 03
>      00000000: aa 00
>      00000000: 71 1e
>      00000000: 70 06
>      00000000: 71 80
>      00000000: 70 07
> 
> and then it starts to stream. The stream downloads 0x200 (512) bytes at a 
> time. It appears that there is an SOF marker consisting of
> 
> ff ff ff ff
> 
> followed by at least two zeroes. These seem to occur only at the 
> beginnings of some of the downloaded 0x200-sized blocks.

Given that the AVI file is 320x240 @ 20 fps Motion JPEG, maybe the
streaming mode uses something similar.  

Assuming 6 bit RGB values at 320x240 @ 20 fps:

	(320*240) * 24 bpp * 20 fps = 36.864 Mbps

Since this USB 1.1, I'm guessing the stream has to be compressed.



> There is a closing sequence at the end which is similar to the init 
> sequence
> 
>      00000000: 71 00
>      00000000: 70 09
>      00000000: 71 80
>      00000000: 70 05
> 
> It would be interesting to see your log file and to compare. I could also 
> send you this one if you are curious, but it is 5,760,902 bytes so I 
> should ask that if you want to see it then how to send it? Me, I suspect 
> that if you have one of similar size and bz2 it and send it to me as an 
> attachment, then it is not any problem.

You could send it to me via email (my ISP bounces *really* big incoming
emails but at least 6 MB email can make it through).  However, without
the "source" of the image, it might be a little hard to decode the dump.

I was going to get a stream of:

1) a white sheet of paper
2) a blue sheet of paper
3) a red sheet of paper
4) a green sheet of paper
5) a black sheet of paper

6) a half-white, half black target with the regions separated vertically
7) a half-white, half black target with the regions separated diagonally

and maybe some other test patterns.  There's no shortage of construction
paper, crayons, and colored markers in my house.


> Now, having found an excuse not to finish grading those papers today, I 
> will probably have to pay more concentrated attention to grading and 
> travel planning tomorrow. But do send the log along anyway if you can get 
> it done.

The most interesting tasks are the ones we're not required to do. :)

I probably can't send logs until Monday, but I will when I get the
chance.  

Regards,
Andy

> Theodore Kilgore


