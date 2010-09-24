Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:6558 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754141Ab0IXNfL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Sep 2010 09:35:11 -0400
Message-ID: <4C9CA90A.50204@redhat.com>
Date: Fri, 24 Sep 2010 10:35:06 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Daniel Moraes <daniel.b.moraes@gmail.com>
CC: linux-media@vger.kernel.org,
	Fernando Henrique <fernandohbc@gmail.com>
Subject: Re: Webcam Driver Bug while using two Multilaser Cameras simultaneously
References: <AANLkTi=TjOKMRQk1spGFVnt1ycu48eZudiWh-hc0a8vp@mail.gmail.com> <AANLkTikWL10Tjb1BnmESGKvq1edZJXoe60pEdJUzMsLx@mail.gmail.com> <AANLkTimRw9=K5D51iejuVv2Duphu0tqCt8_nH2X2eOyL@mail.gmail.com> <4C990C08.9050504@redhat.com> <AANLkTinO4Wm0vHYv2nDP25bar-ASSvgGgO_7ONF-MNmh@mail.gmail.com>
In-Reply-To: <AANLkTinO4Wm0vHYv2nDP25bar-ASSvgGgO_7ONF-MNmh@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 23-09-2010 23:19, Daniel Moraes escreveu:
> Hi Mauro,
> 
> thanks a lot for your help. I would only take a few more questions.
> 
>    1. A computer can have more than one USB Bus? As far as I know the USB Bus is unique.

Yes, it can have as many bus as designed by the manufacturer. You can also add other buses
by buying USB adapter cards.

>    2. Whereas HP webcam uses the same USB Bus but has a more compressed stream, is there a way to compress or reduce the stream of a webcam that uses a generic driver like the HP Webcam does with your drive?

It will depend on the chipset used by the cameras, the screen resolution, and the number of frames per sec.

>    3. Is there a way to check the amount of bandwich in an USB Bus?

Yes. you can watch /proc/bus/usb/devices. It will provide not only the information about each connected
device on your usb bus, but also the speed used.

For example, a quick test here:

$ lsusb
Bus 008 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 007 Device 003: ID 2040:4200 Hauppauge 
Bus 007 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 006 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 001 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub

This machine has 2 USB 2.0 buses (bus 7 and bus 8), with an WinTV USB2 device
connected at bus 7, reading a stream at 640x480x30fps:

cat /proc/bus/usb/devices showed (I removed the info for the USB 1.1 buses):

T:  Bus=08 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=480 MxCh= 6
B:  Alloc=  0/800 us ( 0%), #Int=  0, #Iso=  0
D:  Ver= 2.00 Cls=09(hub  ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=1d6b ProdID=0002 Rev= 2.06
S:  Manufacturer=Linux 2.6.35+ ehci_hcd
S:  Product=EHCI Host Controller
S:  SerialNumber=0000:00:1d.7
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   4 Ivl=256ms

T:  Bus=07 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=480 MxCh= 6
B:  Alloc=408/800 us (51%), #Int=  0, #Iso=  5
D:  Ver= 2.00 Cls=09(hub  ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=1d6b ProdID=0002 Rev= 2.06
S:  Manufacturer=Linux 2.6.35+ ehci_hcd
S:  Product=EHCI Host Controller
S:  SerialNumber=0000:00:1a.7
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   4 Ivl=256ms

T:  Bus=07 Lev=01 Prnt=01 Port=05 Cnt=01 Dev#=  3 Spd=480 MxCh= 0
D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=2040 ProdID=4200 Rev= 1.00
S:  Product=WinTV USB2
S:  SerialNumber=0002819348
C:* #Ifs= 3 Cfg#= 1 Atr=80 MxPwr=500mA
I:  If#= 0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=ff Driver=em28xx
E:  Ad=81(I) Atr=03(Int.) MxPS=   1 Ivl=128ms
E:  Ad=82(I) Atr=01(Isoc) MxPS=   0 Ivl=125us
E:  Ad=84(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:  If#= 0 Alt= 1 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=ff Driver=em28xx
E:  Ad=81(I) Atr=03(Int.) MxPS=   1 Ivl=128ms
E:  Ad=82(I) Atr=01(Isoc) MxPS=1024 Ivl=125us
E:  Ad=84(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:  If#= 0 Alt= 2 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=ff Driver=em28xx
E:  Ad=81(I) Atr=03(Int.) MxPS=   1 Ivl=128ms
E:  Ad=82(I) Atr=01(Isoc) MxPS=1448 Ivl=125us
E:  Ad=84(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:  If#= 0 Alt= 3 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=ff Driver=em28xx
E:  Ad=81(I) Atr=03(Int.) MxPS=   1 Ivl=128ms
E:  Ad=82(I) Atr=01(Isoc) MxPS=2048 Ivl=125us
E:  Ad=84(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:  If#= 0 Alt= 4 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=ff Driver=em28xx
E:  Ad=81(I) Atr=03(Int.) MxPS=   1 Ivl=128ms
E:  Ad=82(I) Atr=01(Isoc) MxPS=2304 Ivl=125us
E:  Ad=84(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 0 Alt= 5 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=ff Driver=em28xx
E:  Ad=81(I) Atr=03(Int.) MxPS=   1 Ivl=128ms
E:  Ad=82(I) Atr=01(Isoc) MxPS=2580 Ivl=125us
E:  Ad=84(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:  If#= 0 Alt= 6 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=ff Driver=em28xx
E:  Ad=81(I) Atr=03(Int.) MxPS=   1 Ivl=128ms
E:  Ad=82(I) Atr=01(Isoc) MxPS=2892 Ivl=125us
E:  Ad=84(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:  If#= 0 Alt= 7 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=ff Driver=em28xx
E:  Ad=81(I) Atr=03(Int.) MxPS=   1 Ivl=128ms
E:  Ad=82(I) Atr=01(Isoc) MxPS=3072 Ivl=125us
E:  Ad=84(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
I:* If#= 1 Alt= 0 #EPs= 0 Cls=01(audio) Sub=01 Prot=00 Driver=snd-usb-audio
I:* If#= 2 Alt= 0 #EPs= 0 Cls=01(audio) Sub=02 Prot=00 Driver=snd-usb-audio
I:  If#= 2 Alt= 1 #EPs= 1 Cls=01(audio) Sub=02 Prot=00 Driver=snd-usb-audio
E:  Ad=83(I) Atr=01(Isoc) MxPS=  20 Ivl=125us


The bandwidth is per bus. In this case, bus 7 shows:
	B:  Alloc=408/800 us (51%), #Int=  0, #Iso=  5

Eg: the stream is using 51% of the USB for just one single stream. If I want to plug another
device, I'll need to use bus 8, as it is free:
	B:  Alloc=  0/800 us ( 0%), #Int=  0, #Iso=  0

If I try to use bus 7 for another HVR-950 using the same resolution, it will return 
the error you got (-ENOSPC), as otherwise, it would be using more than 800 slots, of an
USB bus that can provide only 800 ISOC slots, according with USB 2.0 specs.


Cheers,
Mauro
> 
> Att,
>  Daniel Bastos Moraes
> 
> 
> 
> On Tue, Sep 21, 2010 at 4:48 PM, Mauro Carvalho Chehab <mchehab@redhat.com <mailto:mchehab@redhat.com>> wrote:
> 
>     Hi Daniel,
> 
>     Em 21-09-2010 16:05, Daniel Moraes escreveu:
>     > I'm using Ubuntu 10.04 and I need to get images from two Multilaser
>     > Cameras simultaneously. First I tried to do that using OpenCV, but I
>     > got an error. So, I entered the OpenCV Mailing List to report that and
>     > I discovered that's a driver problem. To ensure that, I used mplayer
>     > to get imagens from the both cameras and I got the following error
>     > (again):
>     >
>     >> v4l2: ioctl streamon failed: No space left on device
> 
>     This is not a driver issue, but a limit imposed by USB specs. This
>     error code is returned by USB core when you try to use more than 100% of
>     the available bandwidth for an USB isoc stream.
> 
>     The amount of bandwidth basically depends on what type of compression
>     is provided by your webcams.
> 
>     You'll need to plug the other webcam on a separate USB bus.
>     >
>     > The cameras model is Multilaser WC0440.
>     >
>     > This problem only happens when I try to capture images from two
>     > IDENTICAL cameras simultaneously. I have three cameras here, two
>     > Multilaser Cameras and one HP Camera, from my laptop. I have no
>     > problem to capture images from my HP Camera and one of the Multilaser
>     > Cameras simultaneously, but when I try to capture from the both
>     > Multilaser Cameras simultaneously, i got that error.
>     >
>     > I think that the problem may be something related to the generic
>     > driver. When I use the Multilaser Cameras, they use the same driver.
>     > That's not happen with the HP Camera, which uses another driver.
> 
>     Probably, the HP Camera is connected internally into a different USB bus,
>     or provide a more compressed stream.
> 
>     > Someone knows a solution for that?
>     >
>     > Att,
>     >  Daniel Bastos Moraes
>     >  Graduando em Ciência da Computação - Universidade Tiradentes
>     >  +55 79 88455531
>     > --
>     > To unsubscribe from this list: send the line "unsubscribe linux-media" in
>     > the body of a message to majordomo@vger.kernel.org <mailto:majordomo@vger.kernel.org>
>     > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

