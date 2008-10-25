Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9PIRUHN010056
	for <video4linux-list@redhat.com>; Sat, 25 Oct 2008 14:27:30 -0400
Received: from mail1.radix.net (mail1.radix.net [207.192.128.31])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9PIRHqo004529
	for <video4linux-list@redhat.com>; Sat, 25 Oct 2008 14:27:17 -0400
From: Andy Walls <awalls@radix.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
In-Reply-To: <200810191632.36406.hverkuil@xs4all.nl>
References: <200810191632.36406.hverkuil@xs4all.nl>
Content-Type: text/plain
Date: Sat, 25 Oct 2008 14:29:03 -0400
Message-Id: <1224959343.3453.61.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: Jean Delvare <khali@linux-fr.org>, v4l <video4linux-list@redhat.com>
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

On Sun, 2008-10-19 at 16:32 +0200, Hans Verkuil wrote: 
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
> 
> In fact, even though at the moment the new structs and functions are 
> prefixed with 'v4l2_', they are actually completely generic and could 
> also be used with other subsystems if desired.
> 
> For now I keep the 'v4l2_' prefix, but this might become something more 
> generic like 'media_' in the future. I might do that anyway to clearly 
> distinguish between the generic and v4l2-specific parts of the 
> framework. I'm not sure yet.
> 
> The new structs are:
> 
> v4l2_driver: basic driver support, provides a standardized way of 
> numbering device instances.
> 
> v4l2_device: this is a device instance, usually embedded in a larger 
> struct. Keeps track of sub-devices and provides a generic way of 
> communicating with sub-devices. v4l2_device structs are registered with 
> a global list which allows e.g. alsa or fb drivers to find the 'parent' 
> device. It also removes artificial limits regarding the maximum number 
> of supported devices since all device instances are now stored in a 
> list.
> 
> v4l2_subdev: provides communication with sub-devices (usually i2c 
> devices). By using v4l2_subdev it is possible to easily command 
> sub-devices, regardless of the bus they are on. For i2c devices 
> additional helper functions are provided to easily load and create the 
> i2c_clients.


Comments mostly WRT to iteration over v4l2_devices:

1. From the documentation, it appears that v4l2_driver doesn't provide
storage for a (bridge) v4l2_device instance pointer list, so bridge
drivers still have to all maintain their own separate storage right?  If
the bridge driver doesn't, I suppose it could iterate over the global
device list looking for only it's v4l2_devices every time it needs one -
but it's probably easier and slightly faster to just maintain driver
specific copies of their "sublist" of the global list.  No?

2.  When iterating over the whole global device list, why should a
(bridge) driver be allowed to access anything other than it's own
v4l2_devices?

3.  What protections does one driver have from another driver module
iterating over all the devices and running a callback that trashes the
contents of another driver's v4l2_devices?  These things used to be
private (static) and very hard for other modules to intentionally
access.


Regards,
Andy



> In the future the framework will be expanded with a v4l2_fh struct for 
> filehandle-private data and a v4l2_mc for the mediacontroller (needed 
> for Texas Instruments hardware). Also, video_device needs a pointer to 
> v4l2_device.
> 
> To test the code I've converted ivtv and the i2c modules that it uses to 
> the new framework. In particular it shows how to setup a v4l2_subdev 
> implementation for the gpio pins, so ivtv supports both gpio and i2c 
> devices all controlled by v4l2_subdev.
> 
> Depending on the feedback I'll make a final version in 1-2 weeks. I hope 
> to merge it in v4l-dvb soon after the 2.6.28 merge window closes.
> 
> Regards,
> 
>         Hans


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
