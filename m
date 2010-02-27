Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay01.digicable.hu ([92.249.128.189]:58907 "EHLO
	relay01.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968435Ab0B0Pfe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Feb 2010 10:35:34 -0500
Message-ID: <4B893BBD.9030600@freemail.hu>
Date: Sat, 27 Feb 2010 16:35:25 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>,
	Hans de Goede <hdegoede@redhat.com>
CC: Richard Purdie <rpurdie@rpsys.net>,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/2] gspca pac7302: allow controlling LED separately
References: <4B84CC9E.4030600@freemail.hu>	<20100224082238.53c8f6f8@tele>	<4B886566.8000600@freemail.hu>	<4B88CF6C.2070703@redhat.com> <20100227100400.05fede81@tele>
In-Reply-To: <20100227100400.05fede81@tele>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
Jean-Francois Moine wrote:
> On Sat, 27 Feb 2010 08:53:16 +0100
> Hans de Goede <hdegoede@redhat.com> wrote:
> 
>> This is true for a lot of cameras, so if we are going to add a way to
>> support control of the LED separate of the streaming state, we
>> should do that at the gspca_main level, and let sub drivers which
>> support this export a set_led callback function.
>>
>> I must say I personally don't see much of a use case for this feature,
>> but I believe JF Moine does, so I'll leave further comments and
>> review of this to JF. I do believe it is important that if we go this
>> way we do so add the gspca_main level.
> 
> Hi,
> 
> I don't like this mechanism to switch on or off the webcam LEDs. Here
> are some arguments (some of them were sent last year to the list):

I could accept both the V4L2 control solution or the LED subclass solution
for handling the camera LED. I miss a little the positive side of using
the LED subclass from the list, so I try take the role of that side and
add them.

> 1) End users.
> 
> Many Linux users don't know the kernel internals, nor which of the too
> many applications they should use to make their devices work. 
> 
> Actually, there are a few X11 programs in common Linux distros which can
> handle the webcam parameters: I just know about vlc and v4l2ucp, and
> they don't even handle the VIDIOC_G_JPEGCOMP and VIDIOC_S_JPEGCOMP
> ioctls which are part of the v4l2 API.
>
> The LED interface uses the /sys file system. Will the webcam programs
> offer access to this interface? I don't believe it. So, the users will
> have to search how they can switch on or off the LEDs of their webcams,
> and then, when found, they should start a X terminal and run a command
> to do the job!

The programs like v4l2ucp can be extended to handle the /sys/class/leds
interface. This is work but the user will not recognise the difference
as long as the GUI supports it.

> On the other hand, a webcam LED control, whether general or private, is
> available in the graphical interface as soon as the driver offers it.
> 
> 2) Memory overhead.
> 
> Using the led class adds more kernel code and asks the webcam drivers
> to create a new device. Also, the function called for changing the LED
> brighness cannot sleep, so the use a workqueue is required.

Let me show the numbers on a 32bit machine:
  sizeof(struct gspca_dev) = 2032 bytes
  sizeof(struct led_classdev) = 112 bytes
  sizeof(struct work_struct) = 28 bytes
  sizeof(struct led_trigger) = 52 bytes

Additionally two strings are also needed one for the LED device name and
one for the LED trigger. Let's take 32 bytes for each (this value can be
made smaller). This means that the necessary memory is 112+28+52+2*32 =
256 bytes.

The pac7302 driver subdriver structure with LED device, workqueue and LED
trigger is:
  sizeof(struct sd) = 2308 bytes

So the memory usage increase is 1-2308/2032 = 13.6%. I would compare the
structure size with the memory page size of the x86 system which is 4096 bytes
(see the return value of getpagesize(2)).

> On contrary, with a webcam control, only one byte (for 8 LEDs) is added
> to the webcam structure and the change is immediatly done in the ioctl.
>
> 3) Development.
> 
> If nobody wants a LED control in the v4l2 interface, I think the code
> added to access the led class could be splitted between the different
> subsystem. For example, the workqueue handling could be done in the led
> class itself...

Advantages of LED subsystem are:
4) Flexible usage of the camera LED for purposes unrelated to camera or
   unusual way, e.g. just blinking the LED with ledtrig-timer.

5) The status of the LED can be read back by reading
   /sys/class/leds/video0::camera/brightness. This is not possible when
   the "auto" menu item is selected from a V4L2 based menu control.

Regards,

	Márton Németh

