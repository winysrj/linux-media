Return-path: <linux-media-owner@vger.kernel.org>
Received: from tichy.grunau.be ([85.131.189.73]:40076 "EHLO tichy.grunau.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933733AbZC0Avp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Mar 2009 20:51:45 -0400
Date: Fri, 27 Mar 2009 01:51:24 +0100
From: Janne Grunau <j@jannau.net>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@skynet.be>,
	linux-media@vger.kernel.org,
	Ricardo Jorge da Fonseca Marques Ferreira
	<storm@sys49152.net>, linux-usb@vger.kernel.org
Subject: Re: v4l parent for usb device interface or device?
Message-ID: <20090327005124.GD2349@aniel>
References: <20232.62.70.2.252.1237993114.squirrel@webmail.xs4all.nl> <49CB7545.2050301@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49CB7545.2050301@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

[cc-ing linux-usb]

On Thu, Mar 26, 2009 at 01:29:57PM +0100, Hans de Goede wrote:
> 
> On 03/25/2009 03:58 PM, Hans Verkuil wrote:
> >> Hi Hans,
> >>
> >> On Wednesday 25 March 2009 11:18:31 Hans de Goede wrote:
> >>> <take 2 this time to the new list, hoping it gets some more attention>
> >>>
> >>> Hi,
> >>>
> >>> Today it came to my attention (through a libv4l bugreport) that
> >>> the uvc driver and the gspca driver handle the setting of
> >>> the v4l parent for usb webcams differently.
> >>>
> >>> The probe function for an usb driver gets passed in a
> >>> "struct usb_interface *intf" parameter.
> >>>
> >>> uvc sets parent to:
> >>>
> >>> vdev->parent =&intf->dev;
> >>>
> >>> gspca uses:
> >>> struct usb_device *dev = interface_to_usbdev(intf);
> >>> vdev.parent =&dev->dev;
> >>>
> >>> Looking at what for example the usb mass-storage driver
> >>> does (with my multi function printer/scanner with cardreader),
> >>> which matches UVC, and thinking about how this is supposed to
> >>> work with multifunction devices in general, I believe the uvc
> >>> driver behaviour is correct, but before writing a patch for
> >>> gspca, I thought it would be good to first discuss this on the
> >>> list.
> >>>
> >>> So what do you think ?
> >> I obviously agree with you :-)
> >>
> >> USB class drivers bind to interfaces instead of devices to support
> >> composite
> >> (multifunction) devices. While drivers for vendor-specific USB devices can
> >> bind to the device, in which case the parent could be a USB device, we
> >> need to
> >> have some consistency in the sysfs symlinks. Using a USB interface as the
> >> video device parent regardless of the device type makes sense.
> >
> > If the parent should indeed become the usb_interface, then we should make
> > all v4l usb drivers consistent. And update v4l2-framework.txt. I've
> > noticed before that it seems to be random what is used as the parent. I'm
> > no USB expert, so I'm relying on your input.
> >
> 
> I believe that what uvc is doing, is the right thing. USB explicitly allows for
> multi-function devices, where each function has a seperate interface. So far
> example a still camera, with a webcam mode, could have 2 interfaces, a mass
> storage interface for the sdcard which stores the pictures and a foo interface,
> for the webcam mode. Clearly the right parent for the webcam v4l device then is
> the foo interface, and not the entire device (just like the mass storage driver
> will use the other interface as its parent).
> 
> I think writing some docs about this and making all drivers consistent wrt this,
> is a good plan. I will write a driver to make gspca the right thing.
> 
While I generally agree that setting parent to the usb interface is
probably correct for multifunction devices I noticed a problem after
changing the hdpvr driver accordingly.

With parent set to the usb interface there is no longer easy access to
the usb device properties like the serial number through sysfs. I know
that a couple of user with more than one device use the serial number
to set static device nodes through udev.

Regards,

Janne
