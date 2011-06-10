Return-path: <mchehab@pedra>
Received: from banach.math.auburn.edu ([131.204.45.3]:36326 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753098Ab1FJSwz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jun 2011 14:52:55 -0400
Date: Fri, 10 Jun 2011 13:16:47 -0500 (CDT)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Hans de Goede <hdegoede@redhat.com>
cc: linux-usb@vger.kernel.org,
	Sarah Sharp <sarah.a.sharp@linux.intel.com>,
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
Subject: Re: Improving kernel -> userspace (usbfs)  usb device hand off
In-Reply-To: <4DF1CDE1.4080303@redhat.com>
Message-ID: <alpine.LNX.2.00.1106101206350.11487@banach.math.auburn.edu>
References: <20110610002103.GA7169@xanatos> <4DF1CDE1.4080303@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>



On Fri, 10 Jun 2011, Hans de Goede wrote:

> Hi all,
> 
> The current API for managing kernel -> userspace is a bit
> rough around the edges, so I would like to discuss extending
> the API.

[...]

> 2) So called dual mode cameras are (cheap) stillcams often even
> without an lcdscreen viewfinder, and battery backed sram instead
> of flash, which double as a webcam. We have drivers for both the
> stillcam function of these (in libgphoto2, so using usbfs) as
> well as for the webcam function (v4l2 kernel drivers).
> 
> These drivers work well, and are mature. Yet the user experience
> is rather poor. Under gnome the still-cam contents will be
> automatically be made available as a "drive" using a gvfs-gphoto2 fuse
> mount. This however involves sending a disconnect to the v4l2 kernel
> driver, and thus the /dev/video# node disappearing. So if a user
> wants to use the device as a webcam he/she needs to first go to
> nautilus and unmount the gvfs mount. Until that is done the user will
> simply get a message from an app like cheese that he has no webcam,
> not even an ebusy error, just that he has no such device.
> 
> Again not good.

[...]

As I have been involved in writing the drivers (both the kernel and the 
libgphoto2 drivers) for many of the affected cameras, perhaps I should 
expand on this problem. There are lots of responses to this original 
message of Hans. I will try to take some of their comments into account, 
below. First, some background.

1. All of the cameras in question have only one USB Vendor:Product number. 
In this sense, they are not "good citizens" which have different Product 
numbers for the two distinct modes of functioning. Thus, the problems are 
from that standpoint unavoidable.

2. Until recently in the history of Linux, there was an irreconcilable 
conflict. If a kernel driver for the video streaming mode was present and 
installed, it was not possible to use the camera in stillcam mode at all. 
Thus the only solution to the problem was to blacklist the kernel module 
so that it would not get loaded automatically and only to install said 
module by hand if the camera were to be used in video streaming mode, then 
to rmmod it immediately afterwards. Very cumbersome, obviously. 

3. The current state of affairs is an advance on (2) but it is still 
inelegant. What happens now is, libusb has been revised in such a way that 
the kernel module is disabled (though still present) if a userspace driver 
(libgphoto2) wants to access the device (the camera). If it is desired to 
do video streaming after that, the camera needs to be re-plugged, which 
then causes the module to be automatically re-loaded.

4. Hans is absolutely correct about the problem with certain Gnome apps 
(and certain distros which blindly use them), which load up the libgphoto2 
driver for the camera as soon as it is detected. The consequence (cf. item 
3) is that the camera can never be used as a webcam. The only solution to 
that problem is to disable the automatic loading of the libgphoto2 driver.

5. It could be said that those who came up with the "user-friendly" 
"solution" described in (4) were not very clever, and perhaps they ought 
to fix their own mess. I would strongly agree that they ought to have 
thought before coding, as the result is not user-friendly in the least. 

6. The question has been asked whether the cameras are always using the 
same interface. Typically, yes. The same altsetting? That depends on the 
camera. Some of them use isochronous transport for streaming, and some of 
them rely exclusively upon bulk transport. Those which use bulk transport 
only are confined to altsetting 0.

Some possible solutions?

Well, first of all it needs to be understood that the problem originates 
as a bad feature of something good, namely the rigid separation of 
kernelspace and userspace functionality which is an integral part of the 
Linux security model. Some other operating systems are not so careful, and 
thus they do not have a problem about supporting dual-mode hardware.

Second, it appears to me that the problem is most appropriately addressed 
from the userspace side and perhaps also from the kernelspace side. 

In userspace, it would be a really good idea if those who are attempting 
to write user-friendly apps and to create user-friendly distros would 
actually learn some of the basics of Linux, such as the rudiments of the 
security model. Since dual-mode cameras are known to exist, it would have 
been appropriate, when one is detected, to pop up a dialog window which 
asks the user to choose a webcam app or a stillcam app. Even this minor 
innovation would stop a lot of user grief. Frankly, I am mystified that 
this was not done.

This still leaves the problem (see item 3, above) that a dual-mode camera 
needs to be re-plugged in order to re-enable the access to /dev/video* if 
it has been used in stillcam mode. If it is possible to do a re-plug in 
software, this would help a lot. It does not matter if the re-plug is done 
in userspace or in kernelspace, so long as it can be done, somehow, after 
libusb relinquishes the camera. Or, fix things up somehow so that the 
kernel module automatically re-activates itself when the userspace app 
(using libgphoto2) is closed down.

Finally, another possible alternative would be to figure out how to do 
something in the kernel module which permits the camera to be accessed by 
libusb.

If there is going to be discussion about this problem in Vancouver, I am 
really sorry that I will probably be able to attend. Classes for the Fall 
semester begin at Auburn University on August 17. Nevertheless, this is a 
problem in which I have been interested for a long time.

Theodore Kilgore

