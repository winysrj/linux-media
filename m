Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:23466 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753489Ab1FJHzY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jun 2011 03:55:24 -0400
Message-ID: <4DF1CDE1.4080303@redhat.com>
Date: Fri, 10 Jun 2011 09:55:13 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: linux-usb@vger.kernel.org
CC: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
	linux-media@vger.kernel.org, libusb-devel@lists.sourceforge.net,
	Alexander Graf <agraf@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>, hector@marcansoft.com,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>,
	pbonzini@redhat.com, Anthony Liguori <aliguori@us.ibm.com>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Oliver Neukum <oliver@neukum.org>, Greg KH <greg@kroah.com>,
	Felipe Balbi <balbi@ti.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Clemens Ladisch <clemens@ladisch.de>,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Improving kernel -> userspace (usbfs)  usb device hand off
References: <20110610002103.GA7169@xanatos>
In-Reply-To: <20110610002103.GA7169@xanatos>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi all,

The current API for managing kernel -> userspace is a bit
rough around the edges, so I would like to discuss extending
the API.

First of all an example use case scenarios where the current API
falls short.

1) Redirection of USB devices to a virtual machine, qemu, vbox, etc.
all have the ability to redirect a USB device to the virtual machine,
and they all use usbfs for this. The first thing which will happen
here when the user selects a device to redirect is a
IOCTL_USBFS_DISCONNECT. This causes the kernel driver to see a
device unplug, with no chances for the kernel driver to do anything
against this.

Now lets say the user does the following:
-write a file to a usb flash disk
-redirect the flash disk to a vm

Currently this will cause the usb mass storage driver to see a
disconnect, and any possible still pending writes are lost ...

This is IMHO unacceptable, but currently there is nothing we can
do to avoid this.

2) So called dual mode cameras are (cheap) stillcams often even
without an lcdscreen viewfinder, and battery backed sram instead
of flash, which double as a webcam. We have drivers for both the
stillcam function of these (in libgphoto2, so using usbfs) as
well as for the webcam function (v4l2 kernel drivers).

These drivers work well, and are mature. Yet the user experience
is rather poor. Under gnome the still-cam contents will be
automatically be made available as a "drive" using a gvfs-gphoto2 fuse
mount. This however involves sending a disconnect to the v4l2 kernel
driver, and thus the /dev/video# node disappearing. So if a user
wants to use the device as a webcam he/she needs to first go to
nautilus and unmount the gvfs mount. Until that is done the user will
simply get a message from an app like cheese that he has no webcam,
not even an ebusy error, just that he has no such device.

Again not good.

###

So what do we need to make this situation better:
1) A usb_driver callback alternative to the disconnect callback,
    I propose to call this soft_disconnect. This serves 2 purposes
    a) It will allow the driver to tell the caller that that is not
       a good idea by returning an error code (think usb mass storage
       driver and mounted filesystem
    b) It will allow for example a v4l2 driver to keep its /dev/video
       node around
    Note that b) means that the normal disconnect handler should still
    be called after a soft reconnect on a real disconnect.
2) A usb_driver soft_reconnect callback to match the soft_disconnect
3) A mechanism for a usb_driver to signal a usbfs fd owner of the device
    it would like the device back. So for example the gvfs mount can be
    automatically unmounted (if not busy).

4) A IOCTL_USBFS_SOFT_DISCONNECT ioctl which will call the drivers
    soft_disconnect if it has one, and otherwise fall back to the
    regular disconnect.
5) A method for a usbfs fd owning app to know the device driver would
    like the device back. I suggest using poll with POLLIN to signal this.

Regards,

Hans
