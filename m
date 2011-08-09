Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2104 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752438Ab1HIH22 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Aug 2011 03:28:28 -0400
Message-ID: <4E40E20C.2090001@redhat.com>
Date: Tue, 09 Aug 2011 09:30:20 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Theodore Kilgore <kilgota@banach.math.auburn.edu>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Adam Baker <linux@baker-net.org.uk>, workshop-2011@linuxtv.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [Workshop-2011] Media Subsystem Workshop 2011
References: <4E398381.4080505@redhat.com> <4E3A91D1.1040000@redhat.com> <4E3B9597.4040307@redhat.com> <201108072353.42237.linux@baker-net.org.uk> <alpine.LNX.2.00.1108072103200.20613@banach.math.auburn.edu> <4E3FE86A.5030908@redhat.com> <alpine.LNX.2.00.1108081208080.21409@banach.math.auburn.edu>
In-Reply-To: <alpine.LNX.2.00.1108081208080.21409@banach.math.auburn.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 08/08/2011 07:39 PM, Theodore Kilgore wrote:
>
>
> On Mon, 8 Aug 2011, Mauro Carvalho Chehab wrote:
>

<snip>

> Mauro,
>
> In fact none of the currently known and supported cameras are using PTP.
> All of them are proprietary. They have a rather intimidating set of
> differences in functionality, too. Namely, some of them have an
> isochronous endpoint, and some of them rely exclusively upon bulk
> transport. Some of them have a well developed set of internal capabilities
> as far as handling still photos are concerned. I mean, such things as the
> ability to download a single photo, selected at random from the set of
> photos on the camera, and some do not, requiring that the "ability" to do
> this is emulated in software -- by first downloading all previously listed
> photos and sending the data to /dev/null, then downloading the desired
> photo and saving it. Some of them permit deletion of individual photos, or
> all photos, and some do not. For some of them it is even true, as I have
> previously mentioned, that the USB command string which will delete all
> photos is the same command used for starting the camera in streaming mode.
>
> But the point here is that these cameras are all different from one
> another, depending upon chipset and even, sometimes, upon firmware
> or chipset version. The still camera abilities and limitations of all of
> them are pretty much worked out in libgphoto2. My suggestion would be that
> the libgphoto2 support libraries for these cameras ought to be left the
> hell alone, except for some changes in, for example, how the camera is
> accessed in the first place (through libusb or through a kernel device) in
> order to address adequately the need to support both modes. I know what is
> in those libgphoto2 drivers because I wrote them. I can definitely promise
> that to move all of that functionality over into kernel modules would be a
> nightmare and would moreover greatly contribute to kernel bloat. You
> really don't want to go there.

I strongly disagree with this. The libgphoto2 camlibs (drivers) for these
cameras handle a number of different tasks:

1) Talking to the camera getting binary blobs out of them (be it a PAT or
    some data)
2) Interpreting said blobs
3) Converting the data parts to pictures doing post processing, etc.

I'm not suggesting to move all of this to the kernel driver, we just need
to move part 1. to the kernel driver. This is not rocket science.

We currently have a really bad situation were drivers are fighting
for the same device. The problem here is that these devices are not
only one device on the physical level, but also one device on the
logical level (IOW they have only 1 usb interface).

It is time to quit thinking in band-aides and solve this properly,
1 logical device means it gets 1 driver.

This may be an approach which means some more work then others, but
I believe in the end that doing it right is worth the effort.

As for Mauro's resource locking patches, these won't work because
the assume both drivers are active at the same time, which is simply
not true. Only 1 driver can be bound to the interface at a time, and
when switching from the gspca driver to the usbfs driver, gspca will
see an unplug which is indistinguishable from a real device unplug.

More over a kernel only solution without libgphoto changes won't solve
the problem of a libgphoto app keeping the device open locking out
streaming.

Regards,

Hans
