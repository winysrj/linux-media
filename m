Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:4093 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbZBPLBR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Feb 2009 06:01:17 -0500
Message-ID: <44220.62.70.2.252.1234782074.squirrel@webmail.xs4all.nl>
Date: Mon, 16 Feb 2009 12:01:14 +0100 (CET)
Subject: Re: Adding a control for Sensor Orientation
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Hans de Goede" <hdegoede@redhat.com>
Cc: "Trent Piepho" <xyzzy@speakeasy.org>,
	"Mauro Carvalho Chehab" <mchehab@infradead.org>,
	kilgota@banach.math.auburn.edu,
	"Adam Baker" <linux@baker-net.org.uk>, linux-media@vger.kernel.org,
	"Jean-Francois Moine" <moinejf@free.fr>,
	"Olivier Lorin" <o.lorin@laposte.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

> Agreed, and that is not what we are doing, we are only talking mount
> information here.
>
> Lets please keep pivot out of the discussion entirely. Esp the whole
> handheld
> case, notice that the handheld case will have to be handled at the
> application
> level anyways, as the portrait versus landscape detection sensor will not
> be
> part of the cam, but will be handled by the kernel input subsystem.
>
> The problems we are *currently* trying to deal with are 3 things:
>
>
> 1) Some (web)cams have their sensors mounted upside down and some laptops
> have
>     their webcam module entirely mounted upside down
>
> This is a known and solved problem. These webcams have well known usb-ID's
> and
> in the laptop case this get complemented by DMI info as one module type
> (so one
> USB-id) may be mounted correctly in one laptop model and upside down in
> another.
>
> I've discussed this with Laurent Pinchart (and other webcam driver
> authors) and
> the conclusion was that having a table of USB-ID's + DMI strings in the
> driver,
> and design an API to tell userspace to sensor is upside down and have code
> for
> all this both in the driver and in userspace makes no sense. Esp since
> such a
> table will probably be more easy to update in userspace too. So the
> conclusion
> was to just put the entire table of cams with known upside down mounted
> sensors
> in userspace. This is currently in libv4l and making many philips webcam
> users
> happy (philips has a tendency to mount the sensor upside down).
>
> A special case here is if the driver can do flipping in hardware, in this
> case
> (which is rarer then we would like), the driver keeps the table itself and
> simply inverts the meaning of the v and h flip controls so userspace will
> never
> notice anything, this is what the m5602 driver does.

Very nice. I agree completely.

> 2) The new sq905X driver being worked on has the problem that all devices
> have
> the same USB-ID, and some model string or id is read in a sq905 specific
> way
> over usb and the sensor orientation differs from model.
>
> So we need an API to relay this information to userspace, and specifically
> to
> libv4l, so it can correct the orientation in software.
>
> If you look at the amount of code needed here to relay this information
> using a
> control at both the kernel and userspace side this is ridiculous we are
> talking
> about a shitload of code to transport 2 bits from kernel space to
> userspace.
> Adding a new ioctl just for this would be less code.
>
> Also read-only versions of existing controls are definitively not the
> answer
> here. read-only already has a well defined meaning, lets not overload that
> and
> add all kind of vagueness to our API. API's need to be clear, well and
> precisely defined!

OK.

> The discussion on solving the sq905X case was wide open until 3 came
> along:
>
>
> 3) There is a cam which can be clicked on for example the top of a
> notebook
> screen, and then can be flipped over the screen to film someone who is not
> behind the keyboard, but on the other (back) side of the notebook screen.
> This
> flipping happens over the X axis, causing the image to be upside down,
> this cam
> has a built-in sensor to detect this (and only this, its a 1 bit sensor).
>
> Since we want to be able to correct this in software (in libv4l) on the
> fly,
> the idea was born to add vflip and hflip flags to the v4l buffer flags, as
> polling some control for this is too ugly for words. This also gave us a
> nice
> simple KISS solution for problem 2.

OK, I'm fine with using two hflip/vflip bits to tell the mount position.

> So all this has nothing to do with pivotting, case 3 could be seen as a
> very
> special case of pivotting, but it is really just a case of the becoming
> mounted
> upside down on the fly. and there certainly is no 90 degrees rotation (or
> any
> rotation other then 180 degrees) involved in this anywhere. That is a
> different
>   (much harder) problem, which needs to be solved at the application level
> as
> width and height will change.

Case 3 *is* pivoting. That's a separate piece of information from the
mount position. All I want is that that is administrated in separate bits.
And if we do this, do it right and support the reporting of 0, 90, 180 and
270 degrees. No one expects libv4l to handle the portrait modes, and apps
that can handle this will probably not use libv4l at all.

> Now can we please stop this color of the bikeshed discussion, add the 2
> damn
> flags and move forward?

Anyone can add an API in 5 seconds. It's modifying or removing a bad API
that worries me as that can take years. If you want to add two bits with
mount information, feel free. But don't abuse them for pivot information.
If you want that, then add another two bits for the rotation:

#define V4L2_BUF_FLAG_VFLIP     0x0400
#define V4L2_BUF_FLAG_HFLIP     0x0800

#define V4L2_BUF_FLAG_PIVOT_0   0x0000
#define V4L2_BUF_FLAG_PIVOT_90  0x1000
#define V4L2_BUF_FLAG_PIVOT_180 0x2000
#define V4L2_BUF_FLAG_PIVOT_270 0x3000
#define V4L2_BUF_FLAG_PIVOT_MSK 0x3000

Regards,

        Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

