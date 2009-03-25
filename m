Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:2140 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754512AbZCYO6x (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Mar 2009 10:58:53 -0400
Message-ID: <20232.62.70.2.252.1237993114.squirrel@webmail.xs4all.nl>
Date: Wed, 25 Mar 2009 15:58:34 +0100 (CET)
Subject: Re: v4l parent for usb device interface or device?
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Laurent Pinchart" <laurent.pinchart@skynet.be>
Cc: "Hans de Goede" <hdegoede@redhat.com>, linux-media@vger.kernel.org,
	"Ricardo Jorge da Fonseca Marques Ferreira" <storm@sys49152.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> Hi Hans,
>
> On Wednesday 25 March 2009 11:18:31 Hans de Goede wrote:
>> <take 2 this time to the new list, hoping it gets some more attention>
>>
>> Hi,
>>
>> Today it came to my attention (through a libv4l bugreport) that
>> the uvc driver and the gspca driver handle the setting of
>> the v4l parent for usb webcams differently.
>>
>> The probe function for an usb driver gets passed in a
>> "struct usb_interface *intf" parameter.
>>
>> uvc sets parent to:
>>
>> vdev->parent = &intf->dev;
>>
>> gspca uses:
>> struct usb_device *dev = interface_to_usbdev(intf);
>> vdev.parent = &dev->dev;
>>
>> Looking at what for example the usb mass-storage driver
>> does (with my multi function printer/scanner with cardreader),
>> which matches UVC, and thinking about how this is supposed to
>> work with multifunction devices in general, I believe the uvc
>> driver behaviour is correct, but before writing a patch for
>> gspca, I thought it would be good to first discuss this on the
>> list.
>>
>> So what do you think ?
>
> I obviously agree with you :-)
>
> USB class drivers bind to interfaces instead of devices to support
> composite
> (multifunction) devices. While drivers for vendor-specific USB devices can
> bind to the device, in which case the parent could be a USB device, we
> need to
> have some consistency in the sysfs symlinks. Using a USB interface as the
> video device parent regardless of the device type makes sense.

If the parent should indeed become the usb_interface, then we should make
all v4l usb drivers consistent. And update v4l2-framework.txt. I've
noticed before that it seems to be random what is used as the parent. I'm
no USB expert, so I'm relying on your input.

Regards,

       Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

