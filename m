Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA9D4I3j030673
	for <video4linux-list@redhat.com>; Sun, 9 Nov 2008 08:04:18 -0500
Received: from smtp-vbr14.xs4all.nl (smtp-vbr14.xs4all.nl [194.109.24.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mA9D1isv025715
	for <video4linux-list@redhat.com>; Sun, 9 Nov 2008 08:01:45 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: video4linux-list@redhat.com
Date: Sun, 9 Nov 2008 14:01:41 +0100
References: <200810191632.36406.hverkuil@xs4all.nl>
In-Reply-To: <200810191632.36406.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811091401.41181.hverkuil@xs4all.nl>
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

Hi all,

First of all, thanks to everyone who replied to my initial request for 
feedback. It's been very useful.

I have updated the framework with this feedback in mind. The repository 
is here:

http://linuxtv.org/hg/~hverkuil/v4l-dvb-media2/

Based on the feedback I have dropped the global device list, the driver 
struct and the driver ID/num. All the driver/device information is 
already present in the kernel's device system so should be obtained 
from there. I was basically duplicating that. ID/num was dropped in 
favor of 'name'. Nothing changed with the v4l2_subdev handling.

Again, feedback is welcome. I think I addressed all the points that were 
raised.

My plans are to convert one or two other drivers and if all goes well 
then I'll make a proper tree and ask it to be merged.

Regards,

	Hans

On Sunday 19 October 2008 16:32:36 Hans Verkuil wrote:
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
> The documentation is pretty complete, so that's probably a good place
> to start.
>
> The purpose of the framework is to move common administrative tasks
> to the framework so that drivers do not have to do that themselves.
> In addition, having all drivers use the same basic structures will
> make it much easier to write new helper functions that only use those
> basic structures and so can be independent of the driver-specific
> structs.
>
> In fact, even though at the moment the new structs and functions are
> prefixed with 'v4l2_', they are actually completely generic and could
> also be used with other subsystems if desired.
>
> For now I keep the 'v4l2_' prefix, but this might become something
> more generic like 'media_' in the future. I might do that anyway to
> clearly distinguish between the generic and v4l2-specific parts of
> the framework. I'm not sure yet.
>
> The new structs are:
>
> v4l2_driver: basic driver support, provides a standardized way of
> numbering device instances.
>
> v4l2_device: this is a device instance, usually embedded in a larger
> struct. Keeps track of sub-devices and provides a generic way of
> communicating with sub-devices. v4l2_device structs are registered
> with a global list which allows e.g. alsa or fb drivers to find the
> 'parent' device. It also removes artificial limits regarding the
> maximum number of supported devices since all device instances are
> now stored in a list.
>
> v4l2_subdev: provides communication with sub-devices (usually i2c
> devices). By using v4l2_subdev it is possible to easily command
> sub-devices, regardless of the bus they are on. For i2c devices
> additional helper functions are provided to easily load and create
> the i2c_clients.
>
> In the future the framework will be expanded with a v4l2_fh struct
> for filehandle-private data and a v4l2_mc for the mediacontroller
> (needed for Texas Instruments hardware). Also, video_device needs a
> pointer to v4l2_device.
>
> To test the code I've converted ivtv and the i2c modules that it uses
> to the new framework. In particular it shows how to setup a
> v4l2_subdev implementation for the gpio pins, so ivtv supports both
> gpio and i2c devices all controlled by v4l2_subdev.
>
> Depending on the feedback I'll make a final version in 1-2 weeks. I
> hope to merge it in v4l-dvb soon after the 2.6.28 merge window
> closes.
>
> Regards,
>
>         Hans
>
> --
> video4linux-list mailing list
> Unsubscribe
> mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
