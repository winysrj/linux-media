Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:31311 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752611Ab0E3T0F (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 May 2010 15:26:05 -0400
Subject: Re: SPCA1527A/SPCA1528 (micro)SD camera in webcam mode
From: Andy Walls <awalls@md.metrocast.net>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Jean-Francois Moine <moinejf@free.fr>, linux-media@vger.kernel.org
In-Reply-To: <201005301955.24442.linux@rainbow-software.org>
References: <201005291909.33593.linux@rainbow-software.org>
	 <201005292132.09705.linux@rainbow-software.org>
	 <20100530133455.489c4f46@tele>
	 <201005301955.24442.linux@rainbow-software.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 30 May 2010 15:26:14 -0400
Message-ID: <1275247574.7020.7.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2010-05-30 at 19:55 +0200, Ondrej Zary wrote:
> On Sunday 30 May 2010 13:34:55 Jean-Francois Moine wrote:
> > On Sat, 29 May 2010 21:32:07 +0200
> >
> > Ondrej Zary <linux@rainbow-software.org> wrote:
> > > The Color Space/Compression reported by the driver is only one: RGB 24
> > > The driver also uses these files which may (or may not) be related to
> > > used compression: iyuv_32.dll, msh263.drv, msyuv.dll, tsbyuv.dll
> > > In standalone mode, the camera records video in MJPEG format.
> >
> > Hello Ondrej,
> >
> > Bad news, the images are compressed by an unknown algorithm (unknown
> > from Linux point of vue). The decompression function could be found in
> > some part of the ms-win driver, but:
> > - first, I have no time to search and disassemble this function,
> > - then, I did have this problem with an other webcam (17a1:0118), and
> >   after searching for a long time, nobody could find the function, and
> >   the driver is in stand-by since 2 years,
> > - eventually, is this legal?
> 
> That's bad...
> 
> The driver contains file sp5x_32.dll which is registered in system.ini file as
> [drivers32]
> VIDC.SP54=SP5X_32.DLL
> 
> Seems that the codec is called SP54 - hope that it's used to decompress the 
> data.
> 
> > All I can do is to code the driver and let you or anyone find the
> > decompression function...


SP54 is Sunplus' ( http://www.sunplus.com.tw/ ) FourCC code for a
version of MJPEG with the headers removed according to 

	http://www.fourcc.org/


> Maybe we can dump some data, create AVI file from that and try to decode the 
> file using that codec.

FourCC.org points to this page:

	http://libland.fr.st/download.html

which points to a utility to conver the data back into an MJPEG:
 
	http://mxhaard.free.fr/spca50x/Download/sp54convert.tar.gz


I have no idea if any of the above is true, 'cause I read it on the
Internet. ;)

Regards,
Andy

