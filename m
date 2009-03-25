Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:10575 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754381AbZCYOua (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Mar 2009 10:50:30 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: v4l parent for usb device interface or device?
Date: Wed, 25 Mar 2009 15:51:28 +0100
Cc: linux-media@vger.kernel.org,
	Ricardo Jorge da Fonseca Marques Ferreira
	<storm@sys49152.net>
References: <49CA04F7.4010603@redhat.com>
In-Reply-To: <49CA04F7.4010603@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903251551.28320.laurent.pinchart@skynet.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Wednesday 25 March 2009 11:18:31 Hans de Goede wrote:
> <take 2 this time to the new list, hoping it gets some more attention>
>
> Hi,
>
> Today it came to my attention (through a libv4l bugreport) that
> the uvc driver and the gspca driver handle the setting of
> the v4l parent for usb webcams differently.
>
> The probe function for an usb driver gets passed in a
> "struct usb_interface *intf" parameter.
>
> uvc sets parent to:
>
> vdev->parent = &intf->dev;
>
> gspca uses:
> struct usb_device *dev = interface_to_usbdev(intf);
> vdev.parent = &dev->dev;
>
> Looking at what for example the usb mass-storage driver
> does (with my multi function printer/scanner with cardreader),
> which matches UVC, and thinking about how this is supposed to
> work with multifunction devices in general, I believe the uvc
> driver behaviour is correct, but before writing a patch for
> gspca, I thought it would be good to first discuss this on the
> list.
>
> So what do you think ?

I obviously agree with you :-)

USB class drivers bind to interfaces instead of devices to support composite 
(multifunction) devices. While drivers for vendor-specific USB devices can 
bind to the device, in which case the parent could be a USB device, we need to 
have some consistency in the sysfs symlinks. Using a USB interface as the 
video device parent regardless of the device type makes sense.

Best regards,

Laurent Pinchart

