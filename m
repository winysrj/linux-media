Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:27166 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753121Ab0E3S35 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 May 2010 14:29:57 -0400
Subject: Re: SPCA1527A/SPCA1528 (micro)SD camera in webcam mode
From: Andy Walls <awalls@md.metrocast.net>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Ondrej Zary <linux@rainbow-software.org>,
	linux-media@vger.kernel.org
In-Reply-To: <20100530133455.489c4f46@tele>
References: <201005291909.33593.linux@rainbow-software.org>
	 <20100529202425.75b4ff56@tele>
	 <201005292132.09705.linux@rainbow-software.org>
	 <20100530133455.489c4f46@tele>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 30 May 2010 14:30:07 -0400
Message-ID: <1275244207.2275.22.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2010-05-30 at 13:34 +0200, Jean-Francois Moine wrote:
> On Sat, 29 May 2010 21:32:07 +0200
> Ondrej Zary <linux@rainbow-software.org> wrote:
> 
> > The Color Space/Compression reported by the driver is only one: RGB 24
> > The driver also uses these files which may (or may not) be related to
> > used compression: iyuv_32.dll, msh263.drv, msyuv.dll, tsbyuv.dll
> > In standalone mode, the camera records video in MJPEG format.
> 
> Hello Ondrej,
> 
> Bad news, the images are compressed by an unknown algorithm (unknown
> from Linux point of vue). The decompression function could be found in
> some part of the ms-win driver, but:
> - first, I have no time to search and disassemble this function,
> - then, I did have this problem with an other webcam (17a1:0118), and
>   after searching for a long time, nobody could find the function, and
>   the driver is in stand-by since 2 years,
> - eventually, is this legal?
> 
> All I can do is to code the driver and let you or anyone find the
> decompression function...

I ran into this with my daughetr's cheap little Sakar webcam based on a
Jeilin chip.  After some investigation about the chip and learning it
being only able to perform JPEG compression, it was rather easy to
figure out it was just sending MJPEG data with the headers stripped off.

This thread from last year tells most of the story

http://www.mail-archive.com/linux-media@vger.kernel.org/msg06766.html

(Many thanks to Theodore for doing the legwork on experiments and a new
GSPCA driver - jeilinj)

Since your camera records MJPEG in stand-alone mode (mine recorded MJPEG
in an AVI container in stand-alone mode), it stands to reason, your
camera may be doing the same sort of thing.  The payload of MJPEG data
will look very random since the compressed data is Huffman (entropy)
encoded in the final step of encoding.


Regards,
Andy



