Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:38278 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752823AbZCYKQ4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Mar 2009 06:16:56 -0400
Message-ID: <49CA04F7.4010603@redhat.com>
Date: Wed, 25 Mar 2009 11:18:31 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Ricardo Jorge da Fonseca Marques Ferreira <storm@sys49152.net>
Subject: v4l parent for usb device interface or device?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

<take 2 this time to the new list, hoping it gets some more attention>

Hi,

Today it came to my attention (through a libv4l bugreport) that
the uvc driver and the gspca driver handle the setting of
the v4l parent for usb webcams differently.

The probe function for an usb driver gets passed in a
"struct usb_interface *intf" parameter.

uvc sets parent to:

vdev->parent = &intf->dev;

gspca uses:
struct usb_device *dev = interface_to_usbdev(intf);
vdev.parent = &dev->dev;

Looking at what for example the usb mass-storage driver
does (with my multi function printer/scanner with cardreader),
which matches UVC, and thinking about how this is supposed to
work with multifunction devices in general, I believe the uvc
driver behaviour is correct, but before writing a patch for
gspca, I thought it would be good to first discuss this on the
list.

So what do you think ?

Thanks & Regards,

Hans


p.s.

This mainly influences what the /sys/class/video4linux/video#/device
symlink will point to, which libv4l uses.
