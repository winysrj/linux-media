Return-path: <mchehab@pedra>
Received: from banach.math.auburn.edu ([131.204.45.3]:43281 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758172Ab1FJWlx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jun 2011 18:41:53 -0400
Date: Fri, 10 Jun 2011 17:43:06 -0500 (CDT)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Felipe Balbi <balbi@ti.com>
cc: Hans de Goede <hdegoede@redhat.com>, linux-usb@vger.kernel.org,
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
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Clemens Ladisch <clemens@ladisch.de>,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: Improving kernel -> userspace (usbfs)  usb device hand off
In-Reply-To: <20110610183452.GV31396@legolas.emea.dhcp.ti.com>
Message-ID: <alpine.LNX.2.00.1106101652050.11718@banach.math.auburn.edu>
References: <20110610002103.GA7169@xanatos> <4DF1CDE1.4080303@redhat.com> <alpine.LNX.2.00.1106101206350.11487@banach.math.auburn.edu> <20110610183452.GV31396@legolas.emea.dhcp.ti.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>



On Fri, 10 Jun 2011, Felipe Balbi wrote:

> Hi,
> 
> On Fri, Jun 10, 2011 at 01:16:47PM -0500, Theodore Kilgore wrote:
> > As I have been involved in writing the drivers (both the kernel and the 
> > libgphoto2 drivers) for many of the affected cameras, perhaps I should 
> > expand on this problem. There are lots of responses to this original 
> > message of Hans. I will try to take some of their comments into account, 
> > below. First, some background.
> > 
> > 1. All of the cameras in question have only one USB Vendor:Product number. 
> > In this sense, they are not "good citizens" which have different Product 
> 
> there's nothing in the USB spec that says you need different product IDs
> for different modes of operation. No matter if it's still or webcam
> configuration, the underlying function is the same: capture images using
> a set of lenses and image sensor.

True, true. But I will add that most of these cameras are Class 255, 
Subclass 255, Protocol 255 (Proprietary, Proprietary, Proprietary).

> 
> > numbers for the two distinct modes of functioning. Thus, the problems are 
> > from that standpoint unavoidable.
> 
> I don't see any problems in this situation. If, for that particular
> product, webcam and still image functionality are mutually exclusive,
> then that's how the product (and their drivers) have to work.

Yes.

> 
> If the linux community decided to put webcam functionality in kernel and
> still image functionality on a completely separate driver, that's
> entirely our problem.

As I understand, the basic reason why webcam functionality needs to be in 
the kernel is speed. Quick reaction time, and faster data transmission. 
Most but not all webcams use isochronous data transport. The ones which do 
not, cannot get as high a rate of frames per second. Isochronous data 
transport has historically seemed to need kernel support in order to work 
properly. Related to this, libusb has not supported isochronous data 
transport. But still cameras use bulk transport. This is natural because 
one needs to move data which is stored on the camera to a place on the 
computer where it can be processed (if needed) and stored. There is no 
impediment to userspace talking to a USB device, so why not go ahead and 
do the job that way if the kernel is not needed?

The second thing to mention is that libgphoto2 at this point is supporting 
well over 1,000 cameras. True, there are not 1,000 driver libraries, but 
there are quite a few. My impression is that nobody wants to put stuff 
like that in the kernel unless it is absolutely necessary, just because 
some of those cameras are dual-mode cameras. Don't people complain on a 
fairly regular basis about kernel code bloat?


> 
> > 2. Until recently in the history of Linux, there was an irreconcilable 
> > conflict. If a kernel driver for the video streaming mode was present and 
> > installed, it was not possible to use the camera in stillcam mode at all. 
> > Thus the only solution to the problem was to blacklist the kernel module 
> > so that it would not get loaded automatically and only to install said 
> > module by hand if the camera were to be used in video streaming mode, then 
> > to rmmod it immediately afterwards. Very cumbersome, obviously. 
> 
> true... but why couldn't we combine both in kernel or in userspace
> altogether ? Why do we have this split ? (words from a newbie in V4L2,
> go easy :-p)

See above.
 
> > 3. The current state of affairs is an advance on (2) but it is still 
> > inelegant. What happens now is, libusb has been revised in such a way that 
> > the kernel module is disabled (though still present) if a userspace driver 
> > (libgphoto2) wants to access the device (the camera). If it is desired to 
> > do video streaming after that, the camera needs to be re-plugged, which 
> > then causes the module to be automatically re-loaded.
> 
> It's still wrong. This should be just another
> USB_REQ_SET_CONFIGURATION(). If this is was just one single driver, you
> could easily do that.

Well, I think it ought to be possible anyway. Up to that point, I agree. 
Though I confess I do not exactly know how.

 
> > 4. Hans is absolutely correct about the problem with certain Gnome apps 
> > (and certain distros which blindly use them), which load up the libgphoto2 
> > driver for the camera as soon as it is detected. The consequence (cf. item 
> > 3) is that the camera can never be used as a webcam. The only solution to 
> > that problem is to disable the automatic loading of the libgphoto2 driver.

I would only add to this, that it is not pleasant to have to deal with 
frustrated users. At this point, my usual advice is that this is a distro 
problem. Ask your distro for help.

> 
> Or, to move the libgphoto2 driver to kernel, combine it in the same
> driver that handles streaming. No ?

See above. 

> 
> > 5. It could be said that those who came up with the "user-friendly" 
> > "solution" described in (4) were not very clever, and perhaps they ought 
> > to fix their own mess. I would strongly agree that they ought to have 
> > thought before coding, as the result is not user-friendly in the least. 
> 
> I agree here

Excellent. I really did have to restrain myself when writing that, too. 

> 
> > 6. The question has been asked whether the cameras are always using the 
> > same interface. Typically, yes. The same altsetting? That depends on the 
> > camera. Some of them use isochronous transport for streaming, and some of 
> > them rely exclusively upon bulk transport. Those which use bulk transport 
> > only are confined to altsetting 0.
> 
> the transfer type or the way the configurations are setup shouldn't
> matter much for the end functionality.
> 
> > Some possible solutions?
> > 
> > Well, first of all it needs to be understood that the problem originates 
> > as a bad feature of something good, namely the rigid separation of 
> > kernelspace and userspace functionality which is an integral part of the 
> > Linux security model. Some other operating systems are not so careful, and 
> > thus they do not have a problem about supporting dual-mode hardware.
> 
> You'd need to describe this fully. 

Certain other operating systems are not fussy at all about their device 
drivers. Those operating systems are also notorious for bad security and 
for crashing, and one of the things which gets blamed for that is all 
those hardware drivers from the hardware manufacturers. Linux tries to do 
things right, which clearly can also cause problems.

What's the problem in having one
> driver handle all modes of operation of that particular camera ? Sounds
> like a decision from V4L2 folks not to take still image cameras in
> kernel. Am I wrong ?

Still image cameras can be handled perfectly well in userspace. There is 
no need for kernel support, at all. Moreover, many still cameras will not 
stream at all; they simply were not designed, built, or sold to do that.  
As far as V4L2 was concerned, it was developed in order to meet the need 
for supporting webcams. Clearly, that was a conscious decision. But you 
ask whether it is possible to support a dual-mode camera entirely in V4L2. 
I would say that of course it ought to be possible, but that would require 
a large portion of the functionality of Gphoto to be duplicated in V4L2, 
just to support those dual-mode cameras. Having some experience with both 
Gphoto and V4L2, I have to say that I am not very taken with the idea. 
There has to be a way which is not so arduous, one would hope.

> 
> > Second, it appears to me that the problem is most appropriately addressed 
> > from the userspace side and perhaps also from the kernelspace side. 
> > 
> > In userspace, it would be a really good idea if those who are attempting 
> > to write user-friendly apps and to create user-friendly distros would 
> > actually learn some of the basics of Linux, such as the rudiments of the 
> > security model. Since dual-mode cameras are known to exist, it would have 
> > been appropriate, when one is detected, to pop up a dialog window which 
> > asks the user to choose a webcam app or a stillcam app. Even this minor 
> > innovation would stop a lot of user grief. Frankly, I am mystified that 
> > this was not done.
> 
> I think this is still not good. It should be more "fluid". If the camera
> has separate alternate settings or different configurations, all it
> takes (from a USB standpoint) is to send the correct SetConfiguration or
> SetInterface command and the camera should happily change its mode of
> operation.

Often true, but not necessarily. 

> 
> Which means that a simple ioctl() to change the mode of operation would
> suffice should the driver be combined.
> 
> > This still leaves the problem (see item 3, above) that a dual-mode camera 
> > needs to be re-plugged in order to re-enable the access to /dev/video* if 
> > it has been used in stillcam mode. If it is possible to do a re-plug in 
> > software, this would help a lot. It does not matter if the re-plug is done 
> > in userspace or in kernelspace, so long as it can be done, somehow, after 
> > libusb relinquishes the camera. Or, fix things up somehow so that the 
> > kernel module automatically re-activates itself when the userspace app 
> > (using libgphoto2) is closed down.
> > 
> > Finally, another possible alternative would be to figure out how to do 
> > something in the kernel module which permits the camera to be accessed by 
> > libusb.
> 
> I don't see the possibility of combining both drivers and use
> /dev/videoX for streaming and something like /dev/camX for still image.
> Now, the only thing you have to be sure in kernel space is that you
> don't allow both to be accessed together, but there are ways to handle
> it.

Which leaves a problem for still cameras. Most of them, in fact, do not 
need any such /dev/camX as you are proposing, at all. The only cameras 
which need the kernel are those which need /dev/videoX. For pure still 
cameras, /dev/videoX is entirely superfluous, at best. Dual-mode cameras 
only need /dev/videoX when streaming and otherwise need for /dev/videoX to 
go away.

I do not believe that we have found the optimal solution, yet. The ideal 
thing would be some kind of hack which allows the kernel to be used when 
it is needed, and when it is not needed it does not interfere.

Theodore Kilgore
