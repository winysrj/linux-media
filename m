Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:20043 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754814Ab0IJAuQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Sep 2010 20:50:16 -0400
Subject: Re: [PATCH] Illuminators and status LED controls
From: Andy Walls <awalls@md.metrocast.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Hans de Goede <hdegoede@redhat.com>,
	Peter Korsgaard <jacmet@sunsite.dk>,
	Jean-Francois Moine <moinejf@free.fr>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	eduardo.valentin@nokia.com,
	ext Eino-Ville Talvala <talvala@stanford.edu>
In-Reply-To: <275b6fc10404e9bda012060f49cdf2f3.squirrel@webmail.xs4all.nl>
References: <y1el0c4vecj8x6uk04ypatvd.1284039765001@email.android.com>
	 <275b6fc10404e9bda012060f49cdf2f3.squirrel@webmail.xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Sep 2010 20:49:44 -0400
Message-ID: <1284079784.4438.192.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Thu, 2010-09-09 at 16:17 +0200, Hans Verkuil wrote:
> > Hans,
> > I'll have more later, but I can say, if LED API is what we agree to, we
> > should have infrastructure in v4l2 at a level higher than gspca for
> > helping drivers use the LED interface and triggers.
> >
> >
> > Specifically this is needed to make discovery and association of v4l2
> > devices, exposed v4l2 LEDs, and v4l2 LED triggers easier for userspace,
> > and to provide a logical, consistent naming scheme.  It may also help with
> > logical association to a v4l2 media controller later on.
> 
> The association between a v4l device and sysfs LEDs is something that
> should be exposed in the upcoming media API (although I guess we should
> take a look first as to how that should be done exactly).

Given choices I made when I patched up gspca/cpia1.c for my prototype
LED API usage, I got these associations

By exposed LED name:

	/sys/class/leds/video0:white:illuminator0


By the exposed LED having the same parent struct device:

	/sys/class/leds/video0:white:illuminator0/device/video4linux/video0

	/sys/class/video4linux/video0/device/leds/video0:white:illuminator0

	/sys/bus/pci/devices/0000:00:12.0/usb3/3-2/3-2:1.0/leds/video0:white:illuminator0

	/sys/bus/pci/devices/0000:00:12.0/usb3/3-2/3-2:1.0/video4linux/video0

and similar results for video0:white:illuminator1.

These have all the usual sysfs gore, but video0's "led" illuminators are
clearly associated with video0 no matter how one runs through sysfs to
discover leds provided by a v4l2 device driver.

The Documentation/leds-class.txt file recommends, rather loosely, that
led device names formed as "devicename:color:function".    Across the
existing drives that expose LEDs, devicename is somewhat inconsistently
chosen, and I don't recall seeing one that chose to expose that it may
be one of multiple instances of a device.  For v4l2 devices, I would
recommend devicename be "videoN" or "mcN", so that the user can shortcut
some sysfs traversal to discover the association.


> But I feel I am missing something: who is supposed to use these LEDs?

The most compelling use-cases I heard so far were::

1. A user who wants to force the LED on the camera to be:

	always off (get rid of annoyance or surreptitious recording?)
	steady on (illusion of continuous recording?)
	auto (driver controlled)
	blinking (obvious warning that recording is happening?)

I do not think this use-case forces the use of either API, but V4L2
controls take less lines of code and have working user permissions out
of the box.

Any driver can be written to support both APIs (my prototype patches to
gspca/cpia1.c do that).  I'm debating if that would be good to do for
illuminators.  I'm sure it's not a good idea for LED indicators.



2. A kernel video device driver controlling a camera that doesn't have
it's own LED, but provides an LED trigger and LED event notifications.
That way a user can hook the video device driver up to a "spare" LED in
his system to get actual LED indications for the camera's operation
without a separate userspace utility.

(This could also apply to some sort of photography setup, where a kernel
driver needs to control external illuminators or flashbulbs without any
help from userspace utilities.)

This is the compelling case for camera device drivers to at least
provide LED API triggers and events, as V4L2 cannot make this happen
without the v4l2_event API and a userspace helper program.  Then at the
point a driver provides LED triggers and events, it makes a lot of sense
to use those same triggers and events to drive any LEDs it might have on
any supported hardware.

The LED API has some shortcomings/annoyances:

- The method a driver provides to set the LED brightness cannot sleep,
so a workqueue is needed to simply turn a hardware light on and off for
USB devices.

- The Documentation is not very good for end-users or kernel developers
on using the LED API. 

- Triggers are available globally, so trigger name clashes are possible,
especially with drivers that support multiple instances of hardware.  I
can't name an LED trigger provided by the cpia1 driver as "cpia_button",
for if I have 2 QX3 microscopes hooked to my system, only the first
QX3's button events are going to effect the LED.  I would suggest LED
trigger names of the form "videoN_eventclass" such as "video0_dock" (the
QX3 microscope body docks in a cradle which has the bottom lamp),
"video0_button1", "video0_streaming", etc.

- For an LED trigger not to override a user's desire to inhibit an LED,
the user needs to know to cancel all the triggers on an LED before
setting the LEDs brightness to 0.

- By default only root has permissions on the sysfs nodes, even though
the user may have permissions for the video nodes.

- Stock triggers are loadable modules (e.g. ledtrig-timer.ko) which only
root can load, so they are unavailable, if root hasn't preloaded them.

- LED triggers can be compiled out of the kernel.  video drivers that
want to use LED triggers for their own LED handling, will need alternate
code paths (#ifdef CONFIG_LED_TRIGGER, IIRC) or the Kconfig for the
driver will have to select/depend on LED_TRIGGER or loose it's lights.


> Turning LEDs in e.g. webcams on or off is a job for the driver, never for
> a userspace application. For that matter, if the driver handles the LEDs,
> can we still expose the API to userspace?

Yes.  You can use the LED triggers and LED events for the driver to
handle it's own LEDs for it's own purposes.  in that case, if the driver
handles a piece of hardware without and LED, the user can hook up the
trigger to a "spare" LED somewhere else in the system, so the driver's
LED events are given to that user specified LED.

Again, that happens to be the only real compelling use case I see for
using the LED API.  However, I doubt many users will try to take
advantage of it, and I suspect even less will succeed in getting it
configured right.  Good documentation could go a long way in correcting
that.

Of note, is that userspace, and some random LED trigger the user has
hooked to your driver's LED, has no sensitivity to commands that may
glitch or corrupt the capture stream.  Video drivers have to have
brightness_set() functions that are smart enough to make sure that
doesn't happen.  It is not sufficient to have the driver's own LED
triggers and timing of LED events handle not glitching the video stream.


>  Wouldn't those two interfere
> with one another? I know nothing about the LED interface in sysfs, but I
> can imagine that will be a problem.

If a user configures multiple LED triggers on an LED, those triggers
will compete with each other.  The net result is the most recent event
from the driver, any LED triggers wins, or user manipulation of sysfs
brightness.

With indicators that's annoying, but not a failure.  With illuminators,
that is a failure.



> > Sysfs entry ownership, unix permissions, and ACL permissions consistency
> > with /dev/videoN will be the immediate usability problem for end users in
> > any case.
> 
> Again, why would end users or application need or want to manipulate such
> LEDs in any case?

To quash the LED shining in one's eye, as one tries to look at the
webcam lens (situated right next to said annoying LED) in the lid of
one's laptop.



> > BTW, what did you mean by uvc discovering an LED control?
> 
> In order for the uvc driver to be able to turn LEDs on or off it needs to
> detect that the uvc camera actually has a LED. It is my impression that
> that is something that the driver has to discover from the uvc camera
> itself. Either that, or it is passed in from the userspace utility that
> uses the usb ID to determine the uvc extension controls and tells the
> driver about it.
> 
> I'm probably not using the right terminology, but I hope I didn't make too
> much of a mess of it :-)
> 
> In any case, the uvc driver has to discover somehow if there are leds and
> how to turn them on/off.


Ah, I understand.  Thanks.

Regards,
Andy



