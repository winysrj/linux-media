Return-path: <linux-media-owner@vger.kernel.org>
Received: from imr-da01.mx.aol.com ([205.188.105.143]:55257 "EHLO
	imr-da01.mx.aol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753403Ab2F0VyN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jun 2012 17:54:13 -0400
Message-ID: <4FEB56DC.1090105@netscape.net>
Date: Wed, 27 Jun 2012 15:54:20 -0300
From: =?ISO-8859-1?Q?Alfredo_Jes=FAs_Delaiti?=
	<alfredodelaiti@netscape.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: dheitmueller/cx23885_fixes.git and mygica x8507
References: <4FE9FA7F.60800@netscape.net> <CAGoCfiyWLdtNVX-2CT9PraAvq-4WL3vUjqaw8o7+S-10R-eCQw@mail.gmail.com> <4FEA80C3.90102@netscape.net> <CAGoCfiwaXZev2yjUuFDB-Z-kZcgoBA+6V7VZ3LBidzw7zb9x3A@mail.gmail.com>
In-Reply-To: <CAGoCfiwaXZev2yjUuFDB-Z-kZcgoBA+6V7VZ3LBidzw7zb9x3A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

El 27/06/12 01:52, Devin Heitmueller escribió:
> On Tue, Jun 26, 2012 at 11:40 PM, Alfredo Jesús Delaiti
> <alfredodelaiti@netscape.net> wrote:
>> The problem was that tvtime was set to 768, by passing a resolution to 720
>> was solved. Sorry for not having tried before.
>> With a resolution of 720 pixels the image looks good.
>> My sincere apologies and thanks.
> I'll have to check if that's a driver bug or not.  The way the logic
> is supposed to work is the application is supposed to propose a size,
> and if the driver concludes the size is unacceptable it should return
> the size that it intends to actually operate at.  The application is
> expected to read the resulting size from the driver and adjust
> accordingly.
>
> Hence, either:
>
> 1.  the driver is saying "ok" to 768 and then tvtime receives green
> video from the driver.
> 2.  the driver properly returns 720 when asked for 768, but tvtime
> doesn't check for the adjusted size.
>
> Scenario #1 is a driver bug, and scenario #2 is a tvtime bug.
>
> Devin
>
What I can I do to know what is the problem?

I tried the following:

I have two cards, one FlyVideo 3000 that has no problems with TVTime to 
change the resolution (no green line on the right side) and over the 
X8507 has the problem.

With the X8507 card with the resolution set at 768 pixels, if I change 
the TV standards NTSC, PAL-M, PAL-N, NTSC-JP no green line(Of course the 
image is distorted). If change to Pal, Pal-Nc and Pal-60 shows the green 
line. Always using TVTime.

Output of TVTime at 768 first and 720 below

alfredo@dhcppc1:/usr/share/man/es> tvtime -v --device=/dev/video1
Ejecutando tvtime 1.0.2.
Leyendo la configuración de /etc/tvtime/tvtime.xml
Leyendo la configuración de /home/alfredo/.tvtime/tvtime.xml
cpuinfo: CPU AMD Phenom(tm) 8450 Triple-Core Processor, family 15, model 
2, stepping 3.
cpuinfo: CPU measured at 2104,519MHz.
tvtime: Cannot set priority to -10: Permiso denegado.
xcommon: Display :0, vendor The X.Org Foundation, vendor release 10903000
xfullscreen: Using XINERAMA for dual-head information.
xfullscreen: Pixels are square.
xfullscreen: Number of displays is 1.
xfullscreen: Head 0 at 0,0 with size 1920x1080.
xcommon: Have XTest, will use it to ping the screensaver.
xcommon: Pixel aspect ratio 1:1.
xcommon: Pixel aspect ratio 1:1.
xcommon: Window manager is KWin and is EWMH compliant.
xcommon: Using EWMH state fullscreen property.
xcommon: Using EWMH state above property.
xcommon: Using EWMH state below property.
xcommon: Pixel aspect ratio 1:1.
xcommon: Displaying in a 768x576 window inside 768x576 space.
xvoutput: Using XVIDEO adaptor 63: Radeon Textured Video.
speedycode: Using MMXEXT optimized functions.
station: Reading stationlist from /home/alfredo/.tvtime/stationlist.xml
videoinput: Using video4linux2 driver 'cx23885', card 'Mygica X8507' 
(bus PCIe:0000:02:00.0).
videoinput: Version is 197635, capabilities 5010011.
videoinput: Maximum input width: 768 pixels.
tvtime: Sampling input at 768 pixels per scanline.
xcommon: Pixel aspect ratio 1:1.
xcommon: Displaying in a 768x576 window inside 768x576 space.
xcommon: Received a map, marking window as visible (58).
tvtime: Cleaning up.
Gracias por usar tvtime.

alfredo@dhcppc1:/usr/share/man/es> tvtime -v --device=/dev/video1
Ejecutando tvtime 1.0.2.
Leyendo la configuración de /etc/tvtime/tvtime.xml
Leyendo la configuración de /home/alfredo/.tvtime/tvtime.xml
cpuinfo: CPU AMD Phenom(tm) 8450 Triple-Core Processor, family 15, model 
2, stepping 3.
cpuinfo: CPU measured at 2104,500MHz.
tvtime: Cannot set priority to -10: Permiso denegado.
xcommon: Display :0, vendor The X.Org Foundation, vendor release 10903000
xfullscreen: Using XINERAMA for dual-head information.
xfullscreen: Pixels are square.
xfullscreen: Number of displays is 1.
xfullscreen: Head 0 at 0,0 with size 1920x1080.
xcommon: Have XTest, will use it to ping the screensaver.
xcommon: Pixel aspect ratio 1:1.
xcommon: Pixel aspect ratio 1:1.
xcommon: Window manager is KWin and is EWMH compliant.
xcommon: Using EWMH state fullscreen property.
xcommon: Using EWMH state above property.
xcommon: Using EWMH state below property.
xcommon: Pixel aspect ratio 1:1.
xcommon: Displaying in a 768x576 window inside 768x576 space.
xvoutput: Using XVIDEO adaptor 63: Radeon Textured Video.
speedycode: Using MMXEXT optimized functions.
station: Reading stationlist from /home/alfredo/.tvtime/stationlist.xml
videoinput: Using video4linux2 driver 'cx23885', card 'Mygica X8507' 
(bus PCIe:0000:02:00.0).
videoinput: Version is 197635, capabilities 5010011.
videoinput: Maximum input width: 768 pixels.
tvtime: Sampling input at 720 pixels per scanline.
xcommon: Pixel aspect ratio 1:1.
xcommon: Displaying in a 768x576 window inside 768x576 space.
xcommon: Received a map, marking window as visible (60).
tvtime: Cleaning up.
Gracias por usar tvtime.


Thank you very much for your help and time.

Alfredo


-- 
Dona tu voz
http://www.voxforge.org/es

