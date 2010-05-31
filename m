Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:54051 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab0EaEDW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 May 2010 00:03:22 -0400
Date: Sun, 30 May 2010 22:06:48 -0500 (CDT)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Ondrej Zary <linux@rainbow-software.org>
cc: Andy Walls <awalls@md.metrocast.net>,
	Jean-Francois Moine <moinejf@free.fr>,
	linux-media@vger.kernel.org
Subject: Re: SPCA1527A/SPCA1528 (micro)SD camera in webcam mode
In-Reply-To: <201005310003.12761.linux@rainbow-software.org>
Message-ID: <alpine.LNX.2.00.1005302154040.14957@banach.math.auburn.edu>
References: <201005291909.33593.linux@rainbow-software.org> <201005302328.56690.linux@rainbow-software.org> <1275256691.4863.19.camel@localhost> <201005310003.12761.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Mon, 31 May 2010, Ondrej Zary wrote:

> On Sunday 30 May 2010 23:58:11 Andy Walls wrote:
> > On Sun, 2010-05-30 at 23:28 +0200, Ondrej Zary wrote:
> > > On Sunday 30 May 2010 21:26:14 Andy Walls wrote:
> > > > On Sun, 2010-05-30 at 19:55 +0200, Ondrej Zary wrote:
> > > > > On Sunday 30 May 2010 13:34:55 Jean-Francois Moine wrote:
> > > >
> > > > SP54 is Sunplus' ( http://www.sunplus.com.tw/ ) FourCC code for a
> > > > version of MJPEG with the headers removed according to
> > > >
> > > > 	http://www.fourcc.org/
> > > >
> > > > > Maybe we can dump some data, create AVI file from that and try to
> > > > > decode the file using that codec.
> > > >
> > > > FourCC.org points to this page:
> > > >
> > > > 	http://libland.fr.st/download.html
> > > >
> > > > which points to a utility to conver the data back into an MJPEG:
> > > >
> > > > 	http://mxhaard.free.fr/spca50x/Download/sp54convert.tar.gz
> > > >
> > > >
> > > > I have no idea if any of the above is true, 'cause I read it on the
> > > > Internet. ;)
> > >
> > > Modified that utility to work on raw video frame extracted from usbsnoop
> > > file. The bad news is that the resulting jpeg file is not readable.
> > >
> > > I also deleted the sp5x_32.dll file and the camera still works...
> >
> > I would try extracting a JPEG header from one of the files captured by
> > the camera in stand alone mode (either a JPEG still or MJPEG file), and
> > put that header together with the image data from the USB capture.  It
> > may not look perfect, but hopefully you will get something you
> > recognize.
> 
> Just thought about the same thing so I uploaded a video file: 
> http://www.rainbow-software.org/linux_files/spca1528/sunp0003.avi
> 
> > Attached was Theodore's first attempt of such a procedure with a header
> > extracted from a standalone image file from my Jeilin based camera and
> > USB snoop data from the same camera.  It wasn't perfect, but it was
> > recognizable.
> 
> Thanks, I'll try that tomorrow.
> 
> > I did look at the image data file Jean-Francois provided from your
> > usbsnoop logs.  To my eye the data looks like it is Huffman coded
> > (indicating JPEG).  Maybe I'm just seeing what I want to see.

Naturally, it makes me feel all excited to see my name in print. If anyone 
likes, you can send me the following:

	-- usbsniff output for one or two frames (it isn't so difficult 
for me to convert this to a binary file, actually) and I can fool around 
with trying to stick a JPEG header on it.

	-- one or two results of svv -gr in case that there is so much 
progress already. But the previous item ought to do just fine, too.

I could also comment that there could be some kind of obfuscated JPEG 
going on here. As a case in point I can mention the recently cracked 
decompression for the JL2005B/C/D based still cameras. The compression 
algorithm is pretty much standard JPEG, but two things are unusual. First, 
the compression or decompression proceeds down columns of width one block, 
not across rows. Second, the thing which is being compressed is the Bayer 
pattern, so each block is of width 16, not 8, and there are sub-blocks for 
each of R, G1, G2, and B.

If anyone is curious about this, the code can be pulled down from 
gphoto.svn.sourceforge.net, in trunk/libgphoto2/camlibs/jl2005c.

Theodore Kilgore
