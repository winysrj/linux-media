Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34731 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755797Ab0BJUl7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Feb 2010 15:41:59 -0500
Message-ID: <4B731A10.9000108@redhat.com>
Date: Wed, 10 Feb 2010 18:41:52 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Carlos Jenkins <carlos.jenkins.perez@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: Want to help in MSI TV VOX USB 2.0
References: <f535cc5a1002100021u37bf47a5y50a0a90873a082e2@mail.gmail.com> 	<f535cc5a1002101058h4d8e4bd1p6fd03abd4f724f52@mail.gmail.com> 	<f535cc5a1002101101k709bbe9bv504cf33fab14dedc@mail.gmail.com> <f535cc5a1002101102w146050c5v91ddc6ec86542153@mail.gmail.com>
In-Reply-To: <f535cc5a1002101102w146050c5v91ddc6ec86542153@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Carlos Jenkins wrote:
> Hi everyone.
> 
> First of all, great job :)
> 
> My name is Carlos Jenkins, and I'm here to help getting to work the
> MSI TV VOX 8609 USB 2.0 device once again. I know it's an old device,
> but here where I live, in Costa Rica, we still have analog TV only. 

> So, what I did is reloading the module specifying the device:
> 
> shell$ sudo rmmod em28xx
> shell$ sudo modprobe --verbose --first-time em28xx card=5
> insmod /lib/modules/2.6.31-19-generic/kernel/drivers/media/video/em28xx/em28xx.ko
> card=5

That't the proper way. You may add it to /etc/modprobe.d/em28xx.conf:
	options em28xx card=5

To avoid needing to specify it every time.

> shell$ dmesg
> [  695.358240] em28xx: New device @ 480 Mbps (eb1a:2820, interface 0, class 0)
> [  695.358989] em28xx #0: chip ID is em2820 (or em2710)
> [  695.461103] em28xx #0: board has no eeprom
> [  695.462226] em28xx #0: Identified as MSI VOX USB 2.0 (card=5)
> [  695.830239] saa7115 5-0021: saa7114 found (1f7114d0e000000) @ 0x42
> (em28xx #0)
> [  698.043727] All bytes are equal. It is not a TEA5767
> [  698.043977] tuner 5-0060: chip found @ 0xc0 (em28xx #0)
> [  698.076232] tuner-simple 5-0060: creating new instance
> [  698.076241] tuner-simple 5-0060: type set to 37 (LG PAL (newer TAPC series))
> [  698.097987] em28xx #0: Config register raw data: 0x00
> [  698.228070] em28xx #0: v4l2 driver version 0.1.2
> [  698.624160] em28xx #0: V4L2 video device registered as video0
> [  698.624210] usbcore: registered new interface driver em28xx
> [  698.624217] em28xx driver loaded
> 
> (So far so good :D )
> 
> shell$ tvtime -v
> Ejecutando tvtime 1.0.2.
> Leyendo la configuración de /etc/tvtime/tvtime.xml
> Leyendo la configuración de /home/havok/.tvtime/tvtime.xml
> cpuinfo: CPU AMD Athlon(tm) 64 X2 Dual Core Processor 3800+, family
> 15, model 11, stepping 2.
> cpuinfo: CPU measured at 1002.171MHz.
> tvtime: Cannot set priority to -10: Permiso denegado.
> xcommon: Display :0.0, vendor The X.Org Foundation, vendor release 10604000
> xfullscreen: Using XINERAMA for dual-head information.
> xfullscreen: Pixels are square.
> xfullscreen: Number of displays is 1.
> xfullscreen: Head 0 at 0,0 with size 1440x900.
> xcommon: Have XTest, will use it to ping the screensaver.
> xcommon: Pixel aspect ratio 1:1.
> xcommon: Pixel aspect ratio 1:1.
> xcommon: Window manager is compiz and is EWMH compliant.
> xcommon: Using EWMH state fullscreen property.
> xcommon: Using EWMH state above property.
> xcommon: Using EWMH state below property.
> xcommon: Pixel aspect ratio 1:1.
> xcommon: Displaying in a 768x576 window inside 768x576 space.
> xvoutput: Using XVIDEO adaptor 355: NV17 Video Texture.
> speedycode: Using MMXEXT optimized functions.
> station: Reading stationlist from /home/havok/.tvtime/stationlist.xml
> videoinput: Using video4linux2 driver 'em28xx', card 'MSI VOX USB 2.0'
> (bus usb-0000:00:0b.1-6).
> videoinput: Version is 258, capabilities 5010041.
> videoinput: Width 720 too high, using 640 instead as suggested by the driver.
> videoinput: Maximum input width: 640 pixels.
> tvtime: Sampling input at 640 pixels per scanline.
> xcommon: Pixel aspect ratio 1:1.
> xcommon: Displaying in a 768x576 window inside 768x576 space.

The above messages seem ok, but I never tried to use tvtime with xinerama.
This used to be a very good application, but it is not maintained anymore.
Not sure if it works fine with newer xorg versions with xinerama. Also,
by default, tvtime enables channel signal detection, but several tuners
don't provide it. So, you need to disable it, in order for tvtime to work.

I suggest you to try mplayer instead. I'm not sure what video standard is
used in Costa Rica, nor what channel frequency list. So, you may need to
adjust the parameters bellow. For NTSC and 6 MHz channels, the command syntax
is:

mplayer -tv driver=v4l2:device=/dev/video0:norm=PAL-M:chanlist=us-bcast tv://

> [At this point the application freezes in a black screen, nothing can
> be done on the GUI]

Maybe due to the lack of signal.

Cheers,
Mauro
