Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:54096 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755845Ab0EaDqH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 May 2010 23:46:07 -0400
Date: Sun, 30 May 2010 22:15:52 -0500 (CDT)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Andy Walls <awalls@md.metrocast.net>
cc: Jean-Francois Moine <moinejf@free.fr>,
	Ondrej Zary <linux@rainbow-software.org>,
	linux-media@vger.kernel.org
Subject: Re: SPCA1527A/SPCA1528 (micro)SD camera in webcam mode
In-Reply-To: <1275273390.4863.30.camel@localhost>
Message-ID: <alpine.LNX.2.00.1005302209500.14957@banach.math.auburn.edu>
References: <201005291909.33593.linux@rainbow-software.org>  <201005292132.09705.linux@rainbow-software.org>  <20100530133455.489c4f46@tele>  <201005301955.24442.linux@rainbow-software.org>  <20100530201343.223a10bd@tele>
 <1275273390.4863.30.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Sun, 30 May 2010, Andy Walls wrote:

> On Sun, 2010-05-30 at 20:13 +0200, Jean-Francois Moine wrote:
> > On Sun, 30 May 2010 19:55:22 +0200
> > Ondrej Zary <linux@rainbow-software.org> wrote:
> > 
> > > That's bad...
> > > 
> > > The driver contains file sp5x_32.dll which is registered in
> > > system.ini file as [drivers32]
> > > VIDC.SP54=SP5X_32.DLL
> > > 
> > > Seems that the codec is called SP54 - hope that it's used to
> > > decompress the data.
> > > 
> > > > All I can do is to code the driver and let you or anyone find the
> > > > decompression function...
> > > 
> > > Maybe we can dump some data, create AVI file from that and try to
> > > decode the file using that codec.
> > 
> > It is easy to get images from the usbsnoop files. I join an image
> > extracted from your file usbsnoop-video-capture-640x480.log. If you
> > want more images, they are in IsoPackets. The first 2 bytes of each isoc
> > packet mean:
> > - '02 80' or '02 81': first of intermediate part of the image ('0' or
> >   '1' is the image sequence number)
> > - '02 82' or '02 83': last part of the image
> > 
> > Someone had an idea to try and guess the compression algorithm: do
> > usbsnoop's with full black and full white images. But this idea did not
> > work with the other webcam: the images were quite the same!
> 
> I have attached an image I constructed from the image data file you
> provided, the MJPEG headers in the AVI file Ondrej provided, and the
> Huffman table in the jpeg.h file in the gspca driver.
> 
> If you zoom in, there is an small pattern in the top left portion of the
> scan.
> 
> I doesn't look quite like an whole image, but it does look like the
> start of one.
> 
> Regards,
> Andy

Downloaded it. And, hmmm. Here are the error messages on trying to look at 
the output:

kilgota@khayyam:~$ display test1.jpg
display: Corrupt JPEG data: premature end of data segment `test1.jpg' @ 
warning/jpeg.c/EmitMessage/228.
display: Unsupported marker type 0x3a `test1.jpg' @ 
error/jpeg.c/EmitMessage/233.
kilgota@khayyam:~$ 

Quite possibly it _is_ going down "strips" or such. That is what the 
JL2005C cameras are doing. Each vertical strip of 16 bytes from the 
picture is in fact a separate JPEG image, and needs to be separately 
processed, and then the results glued together into an image. This is even 
seen in the raw data, once one is so wise that it is all figured out. The 
data for each strip ends with FF D9. So one suggestion here would be to 
see how many times the FF D9 is coming up in the data. There may be a 
pattern to that.

Theodore Kilgore
