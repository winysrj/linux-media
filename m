Return-path: <mchehab@gaivota>
Received: from moutng.kundenserver.de ([212.227.126.186]:53597 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932158Ab0LRVPP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Dec 2010 16:15:15 -0500
Date: Sat, 18 Dec 2010 22:14:32 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: linux-media@vger.kernel.org, pawel@osciak.com,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Steven Toth <stoth@kernellabs.com>,
	Andy Walls <awalls@md.metrocast.net>,
	sakari.ailus@maxwell.research.nokia.com,
	David Cohen <dacohen@gmail.com>, Janne Grunau <j@jannau.net>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Muralidharan Karicheri <m-karicheri2@ti.com>,
	Mike Isely <isely@isely.net>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Anatolij Gustschin <agust@denx.de>,
	Hans de Goede <hdegoede@redhat.com>,
	Pete Eberlein <pete@sensoray.com>
Subject: Re: Volunteers needed: BKL removal: replace .ioctl by .unlocked_ioctl
In-Reply-To: <201012181231.27198.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.1012182214140.18515@axis700.grange>
References: <201012181231.27198.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Sat, 18 Dec 2010, Hans Verkuil wrote:

> Hi all,
> 
> Now that the BKL patch series has been merged in 2.6.37 it is time to work
> on replacing .ioctl by .unlocked_ioctl in all v4l drivers.
> 
> I've made an inventory of all drivers that still use .ioctl and I am looking
> for volunteers to tackle one or more drivers.
> 
> I have CCed this email to the maintainers of the various drivers (if I know
> who it is) in the hope that we can get this conversion done as quickly as
> possible.
> 
> If I have added your name to a driver, then please confirm if you are able to
> work on it or not. If you can't work on it, but you know someone else, then
> let me know as well.
> 
> There is also a list of drivers where I do not know who can do the conversion.
> If you can tackle one or more of those, please respond. Unfortunately, those
> are among the hardest to convert :-(
> 
> It would be great if we can tackle most of these drivers for 2.6.38. I think
> we should finish all drivers for 2.6.39 at the latest.
> 
> There are two ways of doing the conversion: one is to do all the locking within
> the driver, the other is to use core-assisted locking. How to do the core-assisted
> locking is described in Documentation/video4linux/v4l2-framework.txt, but I'll
> repeat the relevant part here:
> 
> v4l2_file_operations and locking
> --------------------------------
> 
> You can set a pointer to a mutex_lock in struct video_device. Usually this
> will be either a top-level mutex or a mutex per device node. If you want
> finer-grained locking then you have to set it to NULL and do you own locking.
> 
> If a lock is specified then all file operations will be serialized on that
> lock. If you use videobuf then you must pass the same lock to the videobuf
> queue initialize function: if videobuf has to wait for a frame to arrive, then
> it will temporarily unlock the lock and relock it afterwards. If your driver
> also waits in the code, then you should do the same to allow other processes
> to access the device node while the first process is waiting for something.
> 
> The implementation of a hotplug disconnect should also take the lock before
> calling v4l2_device_disconnect.
> 
> 
> Driver list:
> 
> saa7146 (Hans Verkuil)
> mem2mem_testdev (Pawel Osciak or Marek Szyprowski)
> cx23885 (Steve Toth)
> cx18-alsa (Andy Walls)
> omap24xxcam (Sakari Ailus or David Cohen)
> au0828 (Janne Grunau)
> cpia2 (Andy Walls or Hans Verkuil)
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

Will have a look.

Thanks
Guennadi

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
> -- 
> Hans Verkuil - video4linux developer - sponsored by Cisco
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
