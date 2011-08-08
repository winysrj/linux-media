Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30214 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751626Ab1HHUHY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Aug 2011 16:07:24 -0400
Message-ID: <4E4041EF.8020702@redhat.com>
Date: Mon, 08 Aug 2011 17:07:11 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Theodore Kilgore <kilgota@banach.math.auburn.edu>
CC: Adam Baker <linux@baker-net.org.uk>,
	Hans de Goede <hdegoede@redhat.com>,
	workshop-2011@linuxtv.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [Workshop-2011] Media Subsystem Workshop 2011
References: <4E398381.4080505@redhat.com> <4E3A91D1.1040000@redhat.com> <4E3B9597.4040307@redhat.com> <201108072353.42237.linux@baker-net.org.uk> <alpine.LNX.2.00.1108072103200.20613@banach.math.auburn.edu> <4E3FE86A.5030908@redhat.com> <alpine.LNX.2.00.1108081208080.21409@banach.math.auburn.edu> <4E402D61.103@redhat.com> <alpine.LNX.2.00.1108081423020.21636@banach.math.auburn.edu>
In-Reply-To: <alpine.LNX.2.00.1108081423020.21636@banach.math.auburn.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 08-08-2011 16:32, Theodore Kilgore escreveu:

>> Doing an specific libusb-like approach just for those cams seems to be the
>> wrong direction, as such driver would be just a fork of an already existing
>> code. I'm all against duplicating it.
> 
> Well, in practice the "fork" would presumably be carried out by yours 
> truly. Presumably with the advice and help of concerned parties. too. 
> Since I am involved on both the kernel side and the libgphoto2 side of the 
> support for the same cameras, it would certainly shorten the lines of 
> communication at the very least. Therefore this is not infeasible.

Forking the code just because we have something "special" is the wrong thing
to do (TM). I would not like to fork V4L core code due to some special need,
but instead to add some glue there to cover the extra case. Maintaining a fork
is bad in long term, as the same fixes/changes will likely be needed on both
copies.

Adding some sort of resource locking like the example I've pointed seems easy
and will work just fine.

>> So, either we need to move the code from libgphoto2 to kernel 
> 
> As I said, I think you don't want to do that.

I don't have a strong opinion about that ATM. Both approaches have advantages
and disadvantages.

> or work into
>> an approach that will make libusb 
> 
> (or an appropriate substitute)

Something like what Hans proposed makes sense on my eyes, as an appropriate
substitute, but it seems that this is exactly what you don't want. I can
really see two alternatives there:

	1) keep the libusb API, e. g. the driver for data access is on
userspace, and a char device allows to communicate with USB in a transparent
way;
	2) create an API for camera, like Hans/Adam proposal. 

If we take (1), we should just use the already existing Kernel infrastructure,
plus a resource locking, to put the USB device into "exclusive access" mode.

> to return -EBUSY when a driver like V4L
>> is in usage, and vice-versa.
>>
>> I never took a look on how libusb works. It seems that the logic for it is
>> at drivers/usb/core/devio.c. Assuming that this is correct driver for libusb,
>> the locking patch would be similar to the enclosed one.
>>
>> Of course, more work will be needed. For example, in the specific case of
>> devices where starting stream will clean the memory data, the V4L driver
>> will need some additional logic to detect if the memory is filled and not
>> allowing stream (or requiring CAP_SYS_ADMIN, returning -EPERM otherwise).
> 
> Yes, this is probably a good idea in any event. 

Agreed.

> As far as I know, this 
> would affect just one kernel driver. A complication is that it 
> is only some of the cameras supported by that driver, and they need to be 
> detected.

Yes.

>> NOTE: As the problem also happens with some PCI devices, instead of adding
>> such locking schema at usb_device, it seems better to bind whatever
>> solution into struct device.
> 
> Interesting comment.

The problem with PCI devices is not exactly the same, but I tried to think on
a way that could also work for those issues. Eventually, when actually implementing
the code, we may come to a conclusion that this is the right thing to do, or
to decide to address those cases with a different solution.

The issue we have (and that it is bus-agnostic), is that some resources
depend on or are mutually exclusive of another resource.

For example, considering a single-tuner device that supports both analog
and digital TV. Due to the analog TV, such device needs to have an ALSA
module. 

However, accessing the ALSA input depends on having the hardware in analog mode,
as, on almost all supported hardware, there's no MPEG decoder inside it.
So, accessing the alsa device should return -EBUSY, if the device is on
digital mode.

On the other hand, as the device has just one tuner, the digital mode
driver can't be used simultaneously with the analog mode one.

So, what I'm seeing is that we need some kernel way to describe hardware
resource dependencies.

Regards,
Mauro
