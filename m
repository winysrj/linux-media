Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:38663 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755997Ab0E2TcW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 29 May 2010 15:32:22 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: "Jean-Francois Moine" <moinejf@free.fr>
Subject: Re: SPCA1527A/SPCA1528 (micro)SD camera in webcam mode
Date: Sat, 29 May 2010 21:32:07 +0200
Cc: linux-media@vger.kernel.org
References: <201005291909.33593.linux@rainbow-software.org> <20100529202425.75b4ff56@tele>
In-Reply-To: <20100529202425.75b4ff56@tele>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201005292132.09705.linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 29 May 2010 20:24:25 Jean-Francois Moine wrote:
> On Sat, 29 May 2010 19:09:32 +0200
>
> Ondrej Zary <linux@rainbow-software.org> wrote:
> > I got a MD80-clone camera based on SPCA1527A chip. It's webcam-like
> > camera with battery and microSD slot and can record video on its own.
> > It has two USB modes - mass storage (USB ID 04fc:0171) and webcam
> > mode (USB ID 04fc:1528). This chip seems to be used in many other SD
> > card cameras too.
> >
> > The webcam mode is not supported by gspca so I captured some data to
> > (hopefully) make support in gspca possible. There seems to be 3
> > interfaces:
>
> Hello Ondrej,
>
> I got your ms-win traces, thank you. The commands seem simple enough,
> but I don't know yet the compression algorithm of the images. I will
> have a look at this on next week. May you tell me if there are other
> resolutions than 320x240 and, also, what are the webcam controls?

The supported resolutions are:
160x120
176x144
320x240
352x288
640x480

The Color Space/Compression reported by the driver is only one: RGB 24
The driver also uses these files which may (or may not) be related to used 
compression: iyuv_32.dll, msh263.drv, msyuv.dll, tsbyuv.dll
In standalone mode, the camera records video in MJPEG format.


Controls:
Banding Filter - 50Hz/60Hz - bandwidth 3/4/5/6/7 (default=50Hz, 3)
Brightness - 0..255 (default=128)
Contrast - 1..8 (default=1)
Saturation - 0..8 (default=1)
Sharpness - 0..255 (default=0)
Hue - 0..360 (default=0)

I added some more logs to 
http://www.rainbow-software.org/linux_files/spca1528/

different resolutions (with default control settings):
usbsnoop-video-capture-160x120.log
usbsnoop-video-capture-176x144.log
usbsnoop-video-capture-352x288.log
usbsnoop-video-capture-640x480.log

160x120 with one control changed (other are at default values):
usbsnoop-controls-brightness-226.log
usbsnoop-controls-brightness-43.log
usbsnoop-controls-contrast-5.log
usbsnoop-controls-hue-91.log
usbsnoop-controls-saturation-4.log
usbsnoop-controls-sharpness-145.log

opening controls window with no capture running:
usbsnoop-open-controls.log

-- 
Ondrej Zary
