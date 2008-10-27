Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9RNGNEV001145
	for <video4linux-list@redhat.com>; Mon, 27 Oct 2008 19:16:23 -0400
Received: from mailrelay012.isp.belgacom.be (mailrelay012.isp.belgacom.be
	[195.238.6.179])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9RNGDrs018554
	for <video4linux-list@redhat.com>; Mon, 27 Oct 2008 19:16:14 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: video4linux-list@redhat.com
Date: Tue, 28 Oct 2008 00:03:03 +0100
References: <200810191632.36406.hverkuil@xs4all.nl>
In-Reply-To: <200810191632.36406.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810280003.03265.laurent.pinchart@skynet.be>
Cc: Jean Delvare <khali@linux-fr.org>
Subject: Re: Feedback wanted: V4L2 framework additions
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi Hans,

first of all, sorry for the late reply.

On Sunday 19 October 2008, Hans Verkuil wrote:
> Hi all,
>
> During the Linux Plumbers Conference I proposed additions to the V4L2
> framework that should simplify driver development and ensure better
> consistency between drivers.
>
> The last few days I worked to get this framework in place and I would
> like to get feedback on what I have right now.
>
> The repository is here:
>
> http://linuxtv.org/hg/~hverkuil/v4l-dvb-media2/
>
> The documentation is in:
>
> linux/Documentation/video4linux/v4l2-framework.txt
>
> The documentation is pretty complete, so that's probably a good place to
> start.
>
> The purpose of the framework is to move common administrative tasks to
> the framework so that drivers do not have to do that themselves. In
> addition, having all drivers use the same basic structures will make it
> much easier to write new helper functions that only use those basic
> structures and so can be independent of the driver-specific structs.

Just to make things clear, I'm very much in favour of a proper kernel-side 
media framework. The various subsystems we currently have don't suffer from 
serious design flaws by themselves, but they are simply not integrated.

> In fact, even though at the moment the new structs and functions are
> prefixed with 'v4l2_', they are actually completely generic and could
> also be used with other subsystems if desired.
>
> For now I keep the 'v4l2_' prefix, but this might become something more
> generic like 'media_' in the future. I might do that anyway to clearly
> distinguish between the generic and v4l2-specific parts of the
> framework. I'm not sure yet.

I like media_ much better, as v4l2 is probably not the right prefix. Your 
proposal deals with composite devices that not only implement video 
input/output but also offer sound, input events and video frame buffer 
functions (among others). The framework should reflect that by using a new 
prefix.

> The new structs are:
>
> v4l2_driver: basic driver support, provides a standardized way of
> numbering device instances.

The driver id and name are redundant. Beside, maintaining a global driver ID 
registry will introduce compatibility issues with out-of-tree drivers. The 
I2C subsystem has gone that way and is now coming back. Jean should probably 
be able to comment on this with more details.

The name field is also redundant, as drivers currently instantiate a 
usb_driver/pci_driver/whatever structure and set the driver name there. 
Wouldn't it be possible to retrieve the driver name from the 'physical driver 
structure' (usb/pci/whatever as opposed to the class driver) ?

What's the rationale behind the instance counter ? If I understand things 
correctly, the counter is used to number instances and give them a unique 
name. As the counter is monotonic, instance numbers will always increase. 
With hotpluggable devices such as webcams the instance number will become 
quite meaningless for end-users.

Instead of maintaining a global list of devices that can be searched using 
v4l2_device_iterate, it might be better to use the device list available in 
struct device_driver. Except if you have a specific use-case in mind, 
restricting device iteration to the related driver is probably a good thing.

> v4l2_device: this is a device instance, usually embedded in a larger
> struct. Keeps track of sub-devices and provides a generic way of
> communicating with sub-devices. v4l2_device structs are registered with
> a global list which allows e.g. alsa or fb drivers to find the 'parent'
> device. It also removes artificial limits regarding the maximum number
> of supported devices since all device instances are now stored in a
> list.

So that's a meta-device (at the same level as the pci or usb device) that 
gathers related sub-devices (mostly i2c chips) and class devices (v4l2, 
alsa, ...) ? If so, why do we need a separate list of sub devices instead of 
using the struct device children list ?

> v4l2_subdev: provides communication with sub-devices (usually i2c
> devices). By using v4l2_subdev it is possible to easily command
> sub-devices, regardless of the bus they are on. For i2c devices
> additional helper functions are provided to easily load and create the
> i2c_clients.

I'll have to think some more about it. My general impression is that we're 
trying to reinvent the wheel already available in drivers/base, but there 
might be a good reason to do so.

> In the future the framework will be expanded with a v4l2_fh struct for
> filehandle-private data and a v4l2_mc for the mediacontroller (needed
> for Texas Instruments hardware). Also, video_device needs a pointer to
> v4l2_device.

I think the media controller is actually the most interesting part of the 
framework and will shape everything else.

As composite devices are becoming more common, Linux will need a way to report 
the device topology to userspace, and let userspace applications interact 
with that topology when applicable (to route video streams for instance). 
Even USB Video Class devices conform to that model: their USB descriptors 
report a graph of connected blocks (connexions are fixed), and individual 
blocks can be accessed by the host.

We will also need a way to corelate streams coming from multiple logical 
devices part of the same physical device. For instance, USB webcams usually 
provide video and audio interfaces that map to a v4l2 device and an alsa 
device. Both interfaces support timestamping the data they carry, but Linux 
provides no way to synchronise those timestamps. The two streams are thus 
hard to synchronise.

> To test the code I've converted ivtv and the i2c modules that it uses to
> the new framework. In particular it shows how to setup a v4l2_subdev
> implementation for the gpio pins, so ivtv supports both gpio and i2c
> devices all controlled by v4l2_subdev.

As a side note, I think pure video device drivers should be allowed to create 
a video_device instance only and should not be required to instantiate a 
media controller or composite media device (v4l2_device). Only drivers that 
create multiple devices (video, alsa, i2c bus master, ...) should use the 
composite device.

> Depending on the feedback I'll make a final version in 1-2 weeks. I hope
> to merge it in v4l-dvb soon after the 2.6.28 merge window closes.

As a summary, I really think a kernel media framework will be a big step 
forward for Linux. As such a framework can become quite complex, adhering to 
the KISS philosophy is probably the best solution. Designing the architecture 
around real drivers and making it evolve with time has always been a good 
decision.

Best regards,

Laurent Pinchart

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
