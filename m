Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:41378 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754951AbZCZSBr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Mar 2009 14:01:47 -0400
Date: Thu, 26 Mar 2009 13:14:25 -0500 (CDT)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Hans de Goede <hdegoede@redhat.com>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@skynet.be>,
	linux-media@vger.kernel.org,
	Ricardo Jorge da Fonseca Marques Ferreira
	<storm@sys49152.net>
Subject: Re: v4l parent for usb device interface or device?
In-Reply-To: <49CB7545.2050301@redhat.com>
Message-ID: <alpine.LNX.2.00.0903261308160.25425@banach.math.auburn.edu>
References: <20232.62.70.2.252.1237993114.squirrel@webmail.xs4all.nl> <49CB7545.2050301@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Thu, 26 Mar 2009, Hans de Goede wrote:

>
>
> On 03/25/2009 03:58 PM, Hans Verkuil wrote:
>>> Hi Hans,
>>> 
>>> On Wednesday 25 March 2009 11:18:31 Hans de Goede wrote:
>>>> <take 2 this time to the new list, hoping it gets some more attention>
>>>> 
>>>> Hi,
>>>> 
>>>> Today it came to my attention (through a libv4l bugreport) that
>>>> the uvc driver and the gspca driver handle the setting of
>>>> the v4l parent for usb webcams differently.
>>>> 
>>>> The probe function for an usb driver gets passed in a
>>>> "struct usb_interface *intf" parameter.
>>>> 
>>>> uvc sets parent to:
>>>> 
>>>> vdev->parent =&intf->dev;
>>>> 
>>>> gspca uses:
>>>> struct usb_device *dev = interface_to_usbdev(intf);
>>>> vdev.parent =&dev->dev;
>>>> 
>>>> Looking at what for example the usb mass-storage driver
>>>> does (with my multi function printer/scanner with cardreader),
>>>> which matches UVC, and thinking about how this is supposed to
>>>> work with multifunction devices in general, I believe the uvc
>>>> driver behaviour is correct, but before writing a patch for
>>>> gspca, I thought it would be good to first discuss this on the
>>>> list.
>>>> 
>>>> So what do you think ?
>>> I obviously agree with you :-)
>>> 
>>> USB class drivers bind to interfaces instead of devices to support
>>> composite
>>> (multifunction) devices. While drivers for vendor-specific USB devices can
>>> bind to the device, in which case the parent could be a USB device, we
>>> need to
>>> have some consistency in the sysfs symlinks. Using a USB interface as the
>>> video device parent regardless of the device type makes sense.
>> 
>> If the parent should indeed become the usb_interface, then we should make
>> all v4l usb drivers consistent. And update v4l2-framework.txt. I've
>> noticed before that it seems to be random what is used as the parent. I'm
>> no USB expert, so I'm relying on your input.
>> 
>
> I believe that what uvc is doing, is the right thing. USB explicitly allows 
> for
> multi-function devices, where each function has a seperate interface. So far
> example a still camera, with a webcam mode, could have 2 interfaces, a mass
> storage interface for the sdcard which stores the pictures and a foo 
> interface,
> for the webcam mode. Clearly the right parent for the webcam v4l device then 
> is
> the foo interface, and not the entire device (just like the mass storage 
> driver
> will use the other interface as its parent).
>
> I think writing some docs about this and making all drivers consistent wrt 
> this,
> is a good plan. I will write a driver to make gspca the right thing.
>
> Regards,
>
> Hans

If it is possible to make the kernel claim the _interface_ and not the 
entire device, this would solve a lot of ancient problems. For example, 
the problem of dual-mode cameras, which are supported as still cameras in 
userspace and in streaming mode, by a kernel module. For another example, 
the problem of those USB DSL modems and similar devices, which come up one 
way as mass storage devices (so one can put config files on them and such) 
and the other way as modems.

If these problems can be solved, then it is really great, and any effort 
spent is well spent.

Good luck, and if I could do anything at all to help, I would be very glad 
to participate.

Theodore Kilgore
