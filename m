Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp5-g21.free.fr ([212.27.42.5]:50710 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208Ab0E3Ldp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 May 2010 07:33:45 -0400
Date: Sun, 30 May 2010 13:34:55 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: linux-media@vger.kernel.org
Subject: Re: SPCA1527A/SPCA1528 (micro)SD camera in webcam mode
Message-ID: <20100530133455.489c4f46@tele>
In-Reply-To: <201005292132.09705.linux@rainbow-software.org>
References: <201005291909.33593.linux@rainbow-software.org>
	<20100529202425.75b4ff56@tele>
	<201005292132.09705.linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 29 May 2010 21:32:07 +0200
Ondrej Zary <linux@rainbow-software.org> wrote:

> The Color Space/Compression reported by the driver is only one: RGB 24
> The driver also uses these files which may (or may not) be related to
> used compression: iyuv_32.dll, msh263.drv, msyuv.dll, tsbyuv.dll
> In standalone mode, the camera records video in MJPEG format.

Hello Ondrej,

Bad news, the images are compressed by an unknown algorithm (unknown
from Linux point of vue). The decompression function could be found in
some part of the ms-win driver, but:
- first, I have no time to search and disassemble this function,
- then, I did have this problem with an other webcam (17a1:0118), and
  after searching for a long time, nobody could find the function, and
  the driver is in stand-by since 2 years,
- eventually, is this legal?

All I can do is to code the driver and let you or anyone find the
decompression function...

Best regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
