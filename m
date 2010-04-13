Return-path: <linux-media-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:59911 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754486Ab0DMB7m (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Apr 2010 21:59:42 -0400
Date: Mon, 12 Apr 2010 21:59:41 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
To: Sarah Sharp <sarah.a.sharp@intel.com>
cc: linux-usb@vger.kernel.org, <linux-media@vger.kernel.org>,
	Libin <libin.yang@amd.com>, <andiry.xu@amd.com>,
	Jean-Francois Moine <moinejf@free.fr>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans de Goede <hdegoede@redhat.com>
Subject: Re: xHCI bandwidth error with USB webcam
In-Reply-To: <20100412222932.GA18647@xanatos>
Message-ID: <Pine.LNX.4.44L0.1004122141140.15844-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 12 Apr 2010, Sarah Sharp wrote:

> I've been trying out the patches to enable isochronous transfers under
> xHCI, and they work fine on my USB speaker.  However, I've been having
> trouble getting my high speed USB webcam to work.  The NEC Express Card
> I have rejects the first alternate setting that the uvcvideo driver
> tries to install (altsetting 11), saying that it takes too much
> bandwidth.  This happens even when I plug the device directly into the
> roothub with no other devices plugged in.
> 
> I would like to know if this is correct behavior for the host, as I
> can't believe a device would advertise an alternate setting that took up
> too much bandwidth by itself.  Device descriptors and a log snippet are
> attached.

The webcam is a high-speed device, right?  The descriptors call for an
isochronous-IN endpoint with 3x1020 bytes (period 1 uframe) and an
isochronous-IN endpoint with 36 bytes (period 8 uframes).  That
combination does not exceed the high-speed bandwidth limit, so the
controller should accept it.

Broadly speaking, at 480 Mb/s you get 60 KB/ms = 7500 B/uframe.  The
periodic bandwidth limit is 80% of the total, or 6000 B/uframe.  
Taking bitstuffing into account (6/7) leaves 5142 B/uframe available
for data, and overhead eats up some of that.  It's still much more than
the 3*1020 + 36 = 3096 bytes needed by the webcam.

> The other problem is that uvcvideo then gives up on the device when
> installing the alt setting fails, rather than trying the next less
> resource-intensive alternate setting.  The past, submit_urb() might fail
> if there wasn't enough bandwidth for the isochronous transfers, but
> under an xHCI host controller, it will fail sooner, when
> usb_set_interface() is called.  That needs to be fixed in all the USB
> video drivers.
> 
> I figured out how to patch the gspca driver, but not uvcvideo.  The
> patch looks a bit hackish; can with experience with that driver look it
> over?  Can anyone tell me where to look for the usb_set_interface() in
> uvcvideo?

Not at the moment, sorry.

Alan Stern

