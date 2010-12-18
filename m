Return-path: <mchehab@gaivota>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:44655 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756110Ab0LROMA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Dec 2010 09:12:00 -0500
Subject: Re: Volunteers needed: BKL removal: replace .ioctl by
 .unlocked_ioctl
From: Andy Walls <awalls@md.metrocast.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, pawel@osciak.com,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Steven Toth <stoth@kernellabs.com>,
	sakari.ailus@maxwell.research.nokia.com,
	David Cohen <dacohen@gmail.com>, Janne Grunau <j@jannau.net>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Muralidharan Karicheri <m-karicheri2@ti.com>,
	Mike Isely <isely@isely.net>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Anatolij Gustschin <agust@denx.de>,
	Hans de Goede <hdegoede@redhat.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Pete Eberlein <pete@sensoray.com>
In-Reply-To: <201012181231.27198.hverkuil@xs4all.nl>
References: <201012181231.27198.hverkuil@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 18 Dec 2010 09:11:35 -0500
Message-ID: <1292681495.2397.6.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Sat, 2010-12-18 at 12:31 +0100, Hans Verkuil wrote:
> Hi all,
> 
> Now that the BKL patch series has been merged in 2.6.37 it is time to work
> on replacing .ioctl by .unlocked_ioctl in all v4l drivers.
> 
> I've made an inventory of all drivers that still use .ioctl and I am looking
> for volunteers to tackle one or more drivers.

> If I have added your name to a driver, then please confirm if you are able to
> work on it or not. If you can't work on it, but you know someone else, then
> let me know as well.

> There is also a list of drivers where I do not know who can do the conversion.
> If you can tackle one or more of those, please respond. Unfortunately, those
> are among the hardest to convert :-(


> Driver list:
> 
> saa7146 (Hans Verkuil)
> mem2mem_testdev (Pawel Osciak or Marek Szyprowski)
> cx23885 (Steve Toth)
> cx18-alsa (Andy Walls)

Ack.  This thing has locking problems between ALSA and /dev/video24
anyway.

> omap24xxcam (Sakari Ailus or David Cohen)
> au0828 (Janne Grunau)
> cpia2 (Andy Walls or Hans Verkuil)

Ack.  But -ENOHARWARE; I only have a cpia1 based device on hand.

The driver is small enough:

        $ wc -l *.[ch]
          2534 cpia2_core.c
            50 cpia2dev.h
           494 cpia2.h
           476 cpia2_registers.h
           914 cpia2_usb.c
          1776 cpia2_v4l.c
          6244 total
        
and has a pretty clean coding style, so conversion shouldn't be hard.
It would be nice to have a tester.

> cx231xx (Mauro Carvalho Chehab)
> davinci (Muralidharan Karicheri)
> saa6588 (Hans Verkuil)
> pvrusb2 (Mike Isely)
> usbvision (Hans Verkuil)
> s5p-fimc (Sylwester Nawrocki)
> fsl-viu (Anatolij Gustschin)
> tlg2300 (Mauro Carvalho Chehab)
> zr364xx (Hans de Goede)
> soc_camera (Guennadi Liakhovetski)
> usbvideo/vicam (Hans de Goede)
> s2255drv (Pete Eberlein)
> bttv (Mauro Carvalho Chehab)
> stk-webcam (Hans de Goede)
> se401 (Hans de Goede)
> si4713-i2c (Hans Verkuil)
> dsbr100 (Hans Verkuil)
> 
> Staging driver list:
> 
> go7007 (Pete Eberlein)
> tm6000 (Mauro Carvalho Chehab)
> (stradis/cpia: will be removed in 2.6.38, so no need to do anything)
> 
> Unassigned drivers:
> 
> saa7134
> em28xx
> cx88
> solo6x10 (staging driver)
> 
> Regards,
> 
> 	Hans
> 


