Return-path: <mchehab@gaivota>
Received: from mail-fx0-f43.google.com ([209.85.161.43]:62925 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756806Ab0LRP4g (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Dec 2010 10:56:36 -0500
Received: by fxm18 with SMTP id 18so1691936fxm.2
        for <linux-media@vger.kernel.org>; Sat, 18 Dec 2010 07:56:34 -0800 (PST)
Message-ID: <4D0CD9AD.5050209@gmail.com>
Date: Sat, 18 Dec 2010 16:56:29 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, pawel@osciak.com,
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
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Pete Eberlein <pete@sensoray.com>
Subject: Re: Volunteers needed: BKL removal: replace .ioctl by .unlocked_ioctl
References: <201012181231.27198.hverkuil@xs4all.nl>
In-Reply-To: <201012181231.27198.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Hans,

On 12/18/2010 12:31 PM, Hans Verkuil wrote:
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

I've done a conversion of s5p-fimc already. The relevant patch
is included in my last pull request of the driver bugfix changeset
for 2.6.37.

I am not sure what are Mauro's plans about this changeset, I hope it is 
not too late to have it in 2.6.37. If it is, then it would be good to 
pick up at least the commit
7db545a [media] s5p-fimc: BKL lock removal - compilation fix
because without it the driver is not even compiling. The above commit
fixes some integration problem, i.e. I submitted the camera capture
support patches and in parallel there were changes in the v4l core.

Then I have also prepared further patch converting from driver's own
to the core assisted locking, but it's on my queue for 2.6.38.
That was submitted together with the videobuf 2 patches

http://git.infradead.org/users/kmpark/linux-2.6-samsung/shortlog/refs/heads/vb2-mfc-fimc

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

I could try converting saa7134 in my spare time, but it is rather
a huge driver and I have no experience with it.
If there is really nobody more familiar to take care of it I would
try it.

I have avermedia E506 TV card on hand, would it be enough for basic testing?

snawrocki@thinkpad:~/linux/v4l-dvb$ sudo lspci -vv
16:00.0 Multimedia controller: Philips Semiconductors 
SAA7131/SAA7133/SAA7135 Video Broadcast Decoder (rev d1)
	Subsystem: Avermedia Technologies Inc Device f436
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at 44000000 (32-bit, non-prefetchable) [size=2K]
	Capabilities: [40] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: saa7134
	Kernel modules: saa7134

> em28xx
> cx88
> solo6x10 (staging driver)
>
> Regards,
>
> 	Hans
>
