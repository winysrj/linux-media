Return-path: <mchehab@gaivota>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:4406 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932210Ab0LRVMQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Dec 2010 16:12:16 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mike Isely <isely@isely.net>
Subject: Re: Volunteers needed: BKL removal: replace .ioctl by .unlocked_ioctl
Date: Sat, 18 Dec 2010 22:11:58 +0100
Cc: linux-media@vger.kernel.org, pawel@osciak.com,
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
References: <201012181231.27198.hverkuil@xs4all.nl> <201012181246.09823.hverkuil@xs4all.nl> <alpine.DEB.1.10.1012181233240.8489@ivanova.isely.net>
In-Reply-To: <alpine.DEB.1.10.1012181233240.8489@ivanova.isely.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012182211.58379.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Saturday, December 18, 2010 19:34:00 Mike Isely wrote:
> 
> I'll take care of the pvrusb2 driver.  How soon does this need to be 
> completed?

It would be great if we can finish this in time for 2.6.38. So that's in the
next three weeks.

I have to say that switching drivers to use the core-assisted lock tends to be
pretty easy. So I am hopeful that it is less work than it looks at first sight.

Regards,

	hans

> 
>   -Mike
> 
> 
> On Sat, 18 Dec 2010, Hans Verkuil wrote:
> 
> > On Saturday, December 18, 2010 12:31:26 Hans Verkuil wrote:
> > > Driver list:
> > > 
> > > saa7146 (Hans Verkuil)
> > > mem2mem_testdev (Pawel Osciak or Marek Szyprowski)
> > > cx23885 (Steve Toth)
> > > cx18-alsa (Andy Walls)
> > > omap24xxcam (Sakari Ailus or David Cohen)
> > > au0828 (Janne Grunau)
> > > cpia2 (Andy Walls or Hans Verkuil)
> > > cx231xx (Mauro Carvalho Chehab)
> > > davinci (Muralidharan Karicheri)
> > > saa6588 (Hans Verkuil)
> > > pvrusb2 (Mike Isely)
> > > usbvision (Hans Verkuil)
> > > s5p-fimc (Sylwester Nawrocki)
> > > fsl-viu (Anatolij Gustschin)
> > > tlg2300 (Mauro Carvalho Chehab)
> > > zr364xx (Hans de Goede)
> > > soc_camera (Guennadi Liakhovetski)
> > > usbvideo/vicam (Hans de Goede)
> > > s2255drv (Pete Eberlein)
> > > bttv (Mauro Carvalho Chehab)
> > > stk-webcam (Hans de Goede)
> > > se401 (Hans de Goede)
> > > si4713-i2c (Hans Verkuil)
> > > dsbr100 (Hans Verkuil)
> > 
> > Oops, si4713-i2c and saa6588 are subdevs, so those two can be removed from
> > this list.
> > 
> > Regards,
> > 
> > 	Hans
> > 
> > 
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
