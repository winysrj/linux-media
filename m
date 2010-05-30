Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:54544 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752199Ab0E3Rzh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 May 2010 13:55:37 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: "Jean-Francois Moine" <moinejf@free.fr>
Subject: Re: SPCA1527A/SPCA1528 (micro)SD camera in webcam mode
Date: Sun, 30 May 2010 19:55:22 +0200
Cc: linux-media@vger.kernel.org
References: <201005291909.33593.linux@rainbow-software.org> <201005292132.09705.linux@rainbow-software.org> <20100530133455.489c4f46@tele>
In-Reply-To: <20100530133455.489c4f46@tele>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201005301955.24442.linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sunday 30 May 2010 13:34:55 Jean-Francois Moine wrote:
> On Sat, 29 May 2010 21:32:07 +0200
>
> Ondrej Zary <linux@rainbow-software.org> wrote:
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

That's bad...

The driver contains file sp5x_32.dll which is registered in system.ini file as
[drivers32]
VIDC.SP54=SP5X_32.DLL

Seems that the codec is called SP54 - hope that it's used to decompress the 
data.

> All I can do is to code the driver and let you or anyone find the
> decompression function...

Maybe we can dump some data, create AVI file from that and try to decode the 
file using that codec.

-- 
Ondrej Zary
