Return-path: <mchehab@pedra>
Received: from banach.math.auburn.edu ([131.204.45.3]:43299 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758029Ab1FJWoe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jun 2011 18:44:34 -0400
Date: Fri, 10 Jun 2011 17:46:16 -0500 (CDT)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Alan Stern <stern@rowland.harvard.edu>
cc: Felipe Balbi <balbi@ti.com>, Hans de Goede <hdegoede@redhat.com>,
	linux-usb@vger.kernel.org,
	Sarah Sharp <sarah.a.sharp@linux.intel.com>,
	linux-media@vger.kernel.org, libusb-devel@lists.sourceforge.net,
	Alexander Graf <agraf@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>, hector@marcansoft.com,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>,
	pbonzini@redhat.com, Anthony Liguori <aliguori@us.ibm.com>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	Oliver Neukum <oliver@neukum.org>, Greg KH <greg@kroah.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Clemens Ladisch <clemens@ladisch.de>,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: Improving kernel -> userspace (usbfs)  usb device hand off
In-Reply-To: <Pine.LNX.4.44L0.1106101714130.1812-100000@iolanthe.rowland.org>
Message-ID: <alpine.LNX.2.00.1106101744500.11718@banach.math.auburn.edu>
References: <Pine.LNX.4.44L0.1106101714130.1812-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>



On Fri, 10 Jun 2011, Alan Stern wrote:

> On Fri, 10 Jun 2011, Felipe Balbi wrote:
> 
> > I don't see any problems in this situation. If, for that particular
> > product, webcam and still image functionality are mutually exclusive,
> > then that's how the product (and their drivers) have to work.
> > 
> > If the linux community decided to put webcam functionality in kernel and
> > still image functionality on a completely separate driver, that's
> > entirely our problem.
> 
> And the problem is how to coordinate the two of them.
> 
> > > 2. Until recently in the history of Linux, there was an irreconcilable 
> > > conflict. If a kernel driver for the video streaming mode was present and 
> > > installed, it was not possible to use the camera in stillcam mode at all. 
> > > Thus the only solution to the problem was to blacklist the kernel module 
> > > so that it would not get loaded automatically and only to install said 
> > > module by hand if the camera were to be used in video streaming mode, then 
> > > to rmmod it immediately afterwards. Very cumbersome, obviously. 
> > 
> > true... but why couldn't we combine both in kernel or in userspace
> > altogether ? Why do we have this split ? (words from a newbie in V4L2,
> > go easy :-p)
> 
> I think the problem may be that the PTP protocol used in the still-cam
> mode isn't suitable for a kernel driver.  Or if it is suitable, it
> would have to be something like a shared-filesystem driver -- nothing
> like a video driver.  You certainly wouldn't want to put it in V4L2.
> 
> > Or, to move the libgphoto2 driver to kernel, combine it in the same
> > driver that handles streaming. No ?
> 
> No.  Something else is needed.
> 
> Alan Stern
> 

Agreed. Something else is needed. But what? Also, very good point about 
PTP.

Theodore Kilgore
