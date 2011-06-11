Return-path: <mchehab@pedra>
Received: from banach.math.auburn.edu ([131.204.45.3]:51478 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab1FKQS5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Jun 2011 12:18:57 -0400
Date: Sat, 11 Jun 2011 11:19:59 -0500 (CDT)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Hans de Goede <hdegoede@redhat.com>
cc: Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
	Sarah Sharp <sarah.a.sharp@linux.intel.com>,
	linux-media@vger.kernel.org, Alexander Graf <agraf@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>, hector@marcansoft.com,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>,
	pbonzini@redhat.com, Anthony Liguori <aliguori@us.ibm.com>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	Oliver Neukum <oliver@neukum.org>, Greg KH <greg@kroah.com>,
	Felipe Balbi <balbi@ti.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Clemens Ladisch <clemens@ladisch.de>,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: Improving kernel -> userspace (usbfs)  usb device hand off
In-Reply-To: <4DF3324E.3050506@redhat.com>
Message-ID: <alpine.LNX.2.00.1106111058170.12801@banach.math.auburn.edu>
References: <Pine.LNX.4.44L0.1106101023330.1921-100000@iolanthe.rowland.org> <4DF3324E.3050506@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>



On Sat, 11 Jun 2011, Hans de Goede wrote:

> Hi,
> 
> Given the many comments in this thread, I'm just
> going reply to this one, and try to also answer any
> other ones in this mail.
> 
> As far as the dual mode camera is involved, I agree
> that that should be fixed in the existing v4l2
> drivers + libgphoto. I think that Felipe's solution
> to also handle the stillcam part in kernel space for
> dual mode cameras (and add a libgphoto cam driver which
> knows how to talk the new kernel API for this), is
> the best solution. Unfortunately this will involve
> quite a bit of work, but so be it.

Hans,

It appears to me that the solution ought to be at hand, actually.

I was not aware of the recent changes in libusb, which I understand are 
supposed to allow a kernel driver to be hooked up again.

To review the situation:

1. As of approximately 2 years ago, libusb already was so configured as to 
suspend the kernel module for a dual-mode device if a userspace-based 
program tried to claim the device.

2. At this point with the more recent versions of libusb (see the last 
message from yesterday, from Xiaofan Chen), we are supposed to be able to 
re-activate the kernel module for the device when it is relinquished by 
userspace.

This ought to take care of the problems completely, provided that the new 
capabilities of libusb are actually used and called upon in libgphoto2.

I have checked on what is happening, just now, on my own machine. I have 
libusb version 1.08 which ought to be recent enough. The advertised 
abilities did not work, however. Presumably, what is missing is on the 
other end of the problem, most likely in the functions in libgphoto2 which 
hook up a camera. That code would presumably need to call upon the new 
functionality of libusb. My currently installed version of libgphoto2 
(from svn, but several months old) clearly does not contain the needed 
functionality. But it might have been put in recently and I did not 
notice. I guess that the first thing to do is to update my gphoto tree and 
then to see what happens. If things still don't work, then something needs 
to be updated and then things ought to work.

I will try to see that something gets done about this. Thank you for 
raising the old issue of dual-mode devices yet again, and thanks to 
Xiaofan Chen for pointing out that the needed missing half of the 
functionality is supposed to exist now in libusb. That had escaped my 
attention. 

Theodore Kilgore
