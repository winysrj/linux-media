Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:53578 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426AbZBPPBA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Feb 2009 10:01:00 -0500
Date: Mon, 16 Feb 2009 12:00:10 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Trent Piepho <xyzzy@speakeasy.org>,
	kilgota@banach.math.auburn.edu,
	Adam Baker <linux@baker-net.org.uk>,
	linux-media@vger.kernel.org, Jean-Francois Moine <moinejf@free.fr>,
	Olivier Lorin <o.lorin@laposte.net>
Subject: Re: Adding a control for Sensor Orientation
Message-ID: <20090216120010.6eac2cc5@pedra.chehab.org>
In-Reply-To: <499959E3.3030903@redhat.com>
References: <53216.62.70.2.252.1234775259.squirrel@webmail.xs4all.nl>
	<49993563.80607@redhat.com>
	<20090216081143.05dafb14@pedra.chehab.org>
	<499959E3.3030903@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 16 Feb 2009 13:19:47 +0100
Hans de Goede <hdegoede@redhat.com> wrote:

Hans,

> Mauro Carvalho Chehab wrote:
> > On Mon, 16 Feb 2009 10:44:03 +0100
> > Hans de Goede <hdegoede@redhat.com> wrote:
> > 
> >> I've discussed this with Laurent Pinchart (and other webcam driver authors) and 
> >> the conclusion was that having a table of USB-ID's + DMI strings in the driver, 
> >> and design an API to tell userspace to sensor is upside down and have code for 
> >> all this both in the driver and in userspace makes no sense. Esp since such a 
> >> table will probably be more easy to update in userspace too. So the conclusion 
> >> was to just put the entire table of cams with known upside down mounted sensors 
> >> in userspace. This is currently in libv4l and making many philips webcam users 
> >> happy (philips has a tendency to mount the sensor upside down).
> > 
> > Are you saying that you have a table at libv4l for what cameras have sensors
> > flipped? 
> 
> Yes.
> 
> > This is really ugly and proofs that the api is broken. No userspace
> > application or library should need to do any special hack based on usb id,
> > driver name or querycap names.
> 
> Well libv4l is already pretty full of cam specific knowledge in the form of 
> decompression algorithm's etc.

That's bad. Not all approaches use libv4l, unfortunately. It will take time to
port all userspace apps to use it and maybe some driver authors will never
accept libv4l. We are too late with the userspace library. This should have been
released together with the first V4L2 API, in order to have a broad acceptance.

Due to that, instead of having the info on just one place (at kernel), we will
split this info on other places. This will lead to inconsistent support,
depending on what app you're using.

Since those info are about the hardware characteristics, IMO, kernel driver
should provide such info.

> Quirk tables like this are best kept in userspace, esp. when userspace is the 
> only consumer of the information, why store information in the kernel if the 
> kernel never uses it at all? Take a look at HAL quirks for suspend resume, 
> wireless on/off buttons, etc. for example.

Take a look on how those subsystems work in practice. IMO, they need to work
more on those subsystems.

For example, the desktop machine I'm writing this email has troubles with both
wireless and suspend subsystems.

In the case of suspend, it only suspends with certain kernel/userspace
combinations. With 2.6.28.2 kernel I'm currently running, suspend is broken.
With the kernel that comes with distro, suspend generally works, but
hibernation hangs. On my laptop (that uses the same HAL version and has the same
distro) suspend generally works fine with both the original and the new
kernels (but hibernation fails).

Wireless is another source of mess that starts with their libraries complaining
that kernel has wireless extension FOO, but the library supports only BAR
extension version. It never works fine. 

Here, on all machines/distros/kernel versions I ever tried with wireless, I
always need to do some hacking to have my wireless card to work with WPA. This
generally require things like starting wpa_supplicant manually after machine
reboot, and even sometimes rebooting my access point or disabling dhcp.

So, I don't think that the current status of those subsystems are good
examples, at least currently. I know the maintainers of those subsystems are
working hard to fix the troubles they're facing with, although I'm not
following all the discussions about those subsystems.

> > In the case of flipping, kernel should provide this info for userspace, at
> > least for the cameras it knows it is flipped (based on USB ID or any other
> > method). In the case of DMI, it seems ok to let userspace to use the kernel DMI
> > support to read this info and detect if the sensor were mounted flipped on a
> > notebook, but for those cams where such info is known based on USB ID, we need
> > to have an interface to read this information. I can see some ways for doing it:
> > 
> > 1) via VIDIOC_QUERYCAP capabilities flag;
> > 2) via VIDIOC_*CNTL read-only interfaces;
> > 3) another ioctl for querying the webcam capabilities;
> > 4) some info via sysfs interface;
> > 
> > IMO, the easier and more adequate way for this case is creating an enumbered
> > control. Something like:
> > 
> > #define V4L2_CID_MOUNTED_ANGLE    (V4L2_CID_CAMERA_CLASS_BASE+17)
> > 
> > enum v4l2_mounted_angle {
> > 	V4L2_CID_MOUNTED_ANGLE_0_DEGREES = 0,
> > 	V4L2_CID_MOUNTED_ANGLE_90_DEGREES = 1,
> > 	V4L2_CID_MOUNTED_ANGLE_180_DEGREES = 2,
> > 	V4L2_CID_MOUNTED_ANGLE_270_DEGREES = 3,
> > 	V4L2_CID_MOUNTED_ANGLE_VIA_DMI = 4,
> > };
> > 
> 
> Here you are making things nice and inconsistent, so the information is in the 
> kernel, except where it is not (the DMI case). If we move this in to the 
> kernel, we should move it *completely* in to the kernel.
> 
> I've discussed this with Laurent Pinchart, and it really makes the most sense 
> to do this in userspace.
> 
> Userspace approach:
> 1 table is in userspace, libv4l reads it directly, done.
> 
> Kernelspace approach:
> 1 add a (smaller) table to *each* driver (which the driver has 0 use for)
> 2 add code to *each* driver to export this info
> 3 add code to libv4l to read this
> 
> You've just created a kernel round trip for no good reason at all, and added a 
> significant amount of code to the kernel, which can live in userspace just as 
> well. The userspace approach is the KISS way. Also it is far easier for people 
> to upgrade libv4l, then it is to upgrade a kernel. Given that this table will 
> most likely change regulary the ease of updating is another argument for doing 
> this in userspace.

I don't agree. Having an userspace library so closely bound to the kernelspace
counterpart just increases overall support troubles. 

For example, consider adding support for camera FOO, that is mounted with 180
degrees at the kernel driver, on the trivial case where the new cam is just a
new USB ID to an existing driver/chipset.

With a combined userspace/kernelspace, you will need to upgrade both
kernelspace AND userspace, in order to properly support this cam.

This also means more work to distro, since libv4l should depend on the kernel
version, and it will need to check, at runtime, for each driver specific
version, complaining if libv4l finds a kernel driver newer than libv4l or a
unknown kernel driver, and providing backport support for older kernels.

With a kernel only approach, you only need to set the rotation flag at the
kernel driver. Userspace will work fine with the older and newer kernel
versions, since all info that userspace needs are the capability flags (or
controls) for that device.

> Also can we please STOP with coming up of new and novel ways of abusing the 
> control API, the control API's purpose is for userspace to control v4l device 
> settings. It is way overkill for things like communicating a few simple flags 
> to userspace (and is a pain to use for things like that both on the kernel and 
> the userspace side).

In the case of sensors mounted rotated or flipped, I agree that the control API
is not the better approach. This is better fitted by a capability flag. Hans
proposal to connect it to the input information seems interesting.

What would be the other capabilities flag that we need, in order to provide
enough info to libv4l for it to not need to check for USB ID codes?

-

In the case of the dynamic camera rotation, I'm not sure if we should provide
this info at the frame info. Why do we need such info 60 times per second?
Let's imagine a case of a cam inclined around 45 degrees. You may have bouncing
troubles, like:
frame odd - 0 degrees
frame even - 90 degrees
frame odd - 0 degrees
frame even - 90 degrees

So, I don't think it would be a good idea to have this at v4l2-buffer. This
seems like what we have with tuner strength and mono/stereo detection: we have
tuner ioctl to get such status, and the driver polls this info, from time to
time. The debounce should be done at userspace.

Cheers,
Mauro
