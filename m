Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:34199 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755101Ab0E3WDY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 May 2010 18:03:24 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Andy Walls <awalls@md.metrocast.net>
Subject: Re: SPCA1527A/SPCA1528 (micro)SD camera in webcam mode
Date: Mon, 31 May 2010 00:03:10 +0200
Cc: "Jean-Francois Moine" <moinejf@free.fr>,
	linux-media@vger.kernel.org
References: <201005291909.33593.linux@rainbow-software.org> <201005302328.56690.linux@rainbow-software.org> <1275256691.4863.19.camel@localhost>
In-Reply-To: <1275256691.4863.19.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201005310003.12761.linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sunday 30 May 2010 23:58:11 Andy Walls wrote:
> On Sun, 2010-05-30 at 23:28 +0200, Ondrej Zary wrote:
> > On Sunday 30 May 2010 21:26:14 Andy Walls wrote:
> > > On Sun, 2010-05-30 at 19:55 +0200, Ondrej Zary wrote:
> > > > On Sunday 30 May 2010 13:34:55 Jean-Francois Moine wrote:
> > >
> > > SP54 is Sunplus' ( http://www.sunplus.com.tw/ ) FourCC code for a
> > > version of MJPEG with the headers removed according to
> > >
> > > 	http://www.fourcc.org/
> > >
> > > > Maybe we can dump some data, create AVI file from that and try to
> > > > decode the file using that codec.
> > >
> > > FourCC.org points to this page:
> > >
> > > 	http://libland.fr.st/download.html
> > >
> > > which points to a utility to conver the data back into an MJPEG:
> > >
> > > 	http://mxhaard.free.fr/spca50x/Download/sp54convert.tar.gz
> > >
> > >
> > > I have no idea if any of the above is true, 'cause I read it on the
> > > Internet. ;)
> >
> > Modified that utility to work on raw video frame extracted from usbsnoop
> > file. The bad news is that the resulting jpeg file is not readable.
> >
> > I also deleted the sp5x_32.dll file and the camera still works...
>
> I would try extracting a JPEG header from one of the files captured by
> the camera in stand alone mode (either a JPEG still or MJPEG file), and
> put that header together with the image data from the USB capture.  It
> may not look perfect, but hopefully you will get something you
> recognize.

Just thought about the same thing so I uploaded a video file: 
http://www.rainbow-software.org/linux_files/spca1528/sunp0003.avi

> Attached was Theodore's first attempt of such a procedure with a header
> extracted from a standalone image file from my Jeilin based camera and
> USB snoop data from the same camera.  It wasn't perfect, but it was
> recognizable.

Thanks, I'll try that tomorrow.

> I did look at the image data file Jean-Francois provided from your
> usbsnoop logs.  To my eye the data looks like it is Huffman coded
> (indicating JPEG).  Maybe I'm just seeing what I want to see.
>
>
> Regards,
> Andy

-- 
Ondrej Zary
