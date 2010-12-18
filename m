Return-path: <mchehab@gaivota>
Received: from cnc.isely.net ([64.81.146.143]:59862 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932100Ab0LRSjG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Dec 2010 13:39:06 -0500
Date: Sat, 18 Dec 2010 12:34:00 -0600 (CST)
From: Mike Isely <isely@isely.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: linux-media@vger.kernel.org, pawel@osciak.com,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Steven Toth <stoth@kernellabs.com>,
	Andy Walls <awalls@md.metrocast.net>,
	sakari.ailus@maxwell.research.nokia.com,
	David Cohen <dacohen@gmail.com>, Janne Grunau <j@jannau.net>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Muralidharan Karicheri <m-karicheri2@ti.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Anatolij Gustschin <agust@denx.de>,
	Hans de Goede <hdegoede@redhat.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Pete Eberlein <pete@sensoray.com>
Subject: Re: Volunteers needed: BKL removal: replace .ioctl by
 .unlocked_ioctl
In-Reply-To: <201012181246.09823.hverkuil@xs4all.nl>
Message-ID: <alpine.DEB.1.10.1012181233240.8489@ivanova.isely.net>
References: <201012181231.27198.hverkuil@xs4all.nl> <201012181246.09823.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>


I'll take care of the pvrusb2 driver.  How soon does this need to be 
completed?

  -Mike


On Sat, 18 Dec 2010, Hans Verkuil wrote:

> On Saturday, December 18, 2010 12:31:26 Hans Verkuil wrote:
> > Driver list:
> > 
> > saa7146 (Hans Verkuil)
> > mem2mem_testdev (Pawel Osciak or Marek Szyprowski)
> > cx23885 (Steve Toth)
> > cx18-alsa (Andy Walls)
> > omap24xxcam (Sakari Ailus or David Cohen)
> > au0828 (Janne Grunau)
> > cpia2 (Andy Walls or Hans Verkuil)
> > cx231xx (Mauro Carvalho Chehab)
> > davinci (Muralidharan Karicheri)
> > saa6588 (Hans Verkuil)
> > pvrusb2 (Mike Isely)
> > usbvision (Hans Verkuil)
> > s5p-fimc (Sylwester Nawrocki)
> > fsl-viu (Anatolij Gustschin)
> > tlg2300 (Mauro Carvalho Chehab)
> > zr364xx (Hans de Goede)
> > soc_camera (Guennadi Liakhovetski)
> > usbvideo/vicam (Hans de Goede)
> > s2255drv (Pete Eberlein)
> > bttv (Mauro Carvalho Chehab)
> > stk-webcam (Hans de Goede)
> > se401 (Hans de Goede)
> > si4713-i2c (Hans Verkuil)
> > dsbr100 (Hans Verkuil)
> 
> Oops, si4713-i2c and saa6588 are subdevs, so those two can be removed from
> this list.
> 
> Regards,
> 
> 	Hans
> 
> 

-- 

Mike Isely
isely @ isely (dot) net
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
