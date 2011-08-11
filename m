Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:37347 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753640Ab1HKUdL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Aug 2011 16:33:11 -0400
Message-ID: <4E443C6E.8040808@infradead.org>
Date: Thu, 11 Aug 2011 17:32:46 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Theodore Kilgore <kilgota@banach.math.auburn.edu>
CC: Alan Stern <stern@rowland.harvard.edu>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Hans de Goede <hdegoede@redhat.com>,
	Sarah Sharp <sarah.a.sharp@linux.intel.com>,
	Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	libusb-devel@lists.sourceforge.net, Alexander Graf <agraf@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>, hector@marcansoft.com,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>,
	pbonzini@redhat.com, Anthony Liguori <aliguori@us.ibm.com>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	Oliver Neukum <oliver@neukum.org>, Felipe Balbi <balbi@ti.com>,
	Clemens Ladisch <clemens@ladisch.de>,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Adam Baker <linux@baker-net.org.uk>
Subject: Re: USB mini-summit at LinuxCon Vancouver
References: <Pine.LNX.4.44L0.1108111145360.1958-100000@iolanthe.rowland.org> <alpine.LNX.2.00.1108111235400.27040@banach.math.auburn.edu>
In-Reply-To: <alpine.LNX.2.00.1108111235400.27040@banach.math.auburn.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 11-08-2011 17:01, Theodore Kilgore escreveu:

> As I said, I am agnostic, though leaning in the direction that Hans de 
> Goede is pointing. What he says about a single control mechanism seems to 
> make a lot of sense. If you can come up with an outline of the "easier to 
> code" solution, that would be interesting, though.
> 
> I assume you are also going to be in Vancouver? If you will be there on 
> Monday, then Hans and I are already planning to meet and discuss. 
> 
> BTW, as to using V4L with "tweaks" to handle still mode, it would probably 
> be more difficult than is imagined. For, though the operations required to 
> process still images and webcam frames are in principle similar, the 
> priorities and constraints are too different. Therefore, my understanding 
> is that the libgphoto2 image processing routines, not the libv4l image 
> processing routines, would still be used for still images.

I agree with Alan Cox: most of the code that the driver needs is already there: 
register read/write routines, bulk transfer support, etc. The amount of extra 
code for adding still cam functionality is probably not big.

>From the kernel driver's perspective, it doesn't matter if the access will come
via libv4l, libgphoto2 or whatever. The driver should be able to allow simultaneous
open, while protecting the data access when userspace requests data stream or
still image retrieve.

instead of using the V4L2 device node to access the stored images, it probably makes 
more sense to use a separate device for that, that will handle a separate set of 
ioctl's, and just use read() to retrieve the image data, after selecting the desired
image number, via ioctl().

It probably makes sense to add a new set of callbacks at the gspca core in order
to handle the new device node, and letting it to avoid start streaming while the
store access is happening, and vice-versa. Alternatively, we may create a separate
"still cam" core library to handle the new device node,.

If all agree around such solution, I suggest to take the most complex case and try
to map it into the driver and core, and see how it behaves, testing with some simple
command line applications, only changing the libgphoto2 code after those initial
tests. Writing a simple code for reading still images should be easy, and we have 
already some testing tools for V4L2.

After coding the core changes that are common to all drives, I suspect that adding 
the remaining 4 drivers will be quick.

With regards to libgphoto2, all it needs to do is to test if the new device nodes
exist. If they exist, then the new code will be used. Otherwise, it will fallback
to the libusb. This way, we can incrementally add the Dual mode drivers into the
kernel.

There is one advantage on using this strategy: if, in the future, new Dual Cams
arise, one can write first a still cam kernel driver, adding V4L support later.

Cheers,
Mauro
