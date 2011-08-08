Return-path: <linux-media-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:38173 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751392Ab1HHOze (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Aug 2011 10:55:34 -0400
Date: Mon, 8 Aug 2011 10:55:34 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
To: Theodore Kilgore <kilgota@banach.math.auburn.edu>
cc: Adam Baker <linux@baker-net.org.uk>,
	Jean-Francois Moine <moinejf@free.fr>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	<linux-usb@vger.kernel.org>, Hans de Goede <hdegoede@redhat.com>
Subject: Re: [Workshop-2011] Media Subsystem Workshop 2011
In-Reply-To: <alpine.LNX.2.00.1108072158210.20613@banach.math.auburn.edu>
Message-ID: <Pine.LNX.4.44L0.1108081038350.1944-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 7 Aug 2011, Theodore Kilgore wrote:

> This indirectly answers my question, above, about whatever device there 
> may or may not be. What I get from this, and also from a bit of snooping 
> around, is that there is not any dev that gets created in order to be 
> accessed by libusb. Just an entry under /proc/bus/usb, which AFAICT is at 
> most a pseudo-device. Thanks.

Nowadays, most distributions create device nodes under /dev/bus/usb.  A 
few also support the old /proc/bus/usb files.

> So, Alan, what do you think is the best way to go about the problem? The 
> camera can act as a stillcam or as a webcam. The problem is to provide 
> access to both, with equal facility (and of course to lock out access to 
> whichever action is not currently in use, if the other one is). 
> 
> The current situation with libusb does not cut it, as among other things 
> it currently does only half the job and seemingly cannot address the 
> locking problem. Hans suggests to create two explicit devices, /dev/video 
> (as already done and something like /dev/cam. Then access webcam function 
> as now and stillcam function with libgphoto2, as now, but through /dev/cam 
> instead of through libusb. This would seem to me to solve all the 
> problems, but at the expense of some work. Can you think of something more 
> clever?

I'm not familiar with the MTP protocol used in the stillcam mode, or
how feasible it would be to implement that protocol in a kernel driver.  
Maybe a good compromise would be to create a kind of stub driver that
could negotiate the device access while still delegating most of the
real work to userspace.

This could become a bigger problem if this kind of design becomes an
ongoing trend.  To do what Hans was suggesting, today we have to merge
two separate drivers... then tomorrow we would have to merge two others
and then later on even more.  Before you know it, we would end up with
a single gigantic kernel driver to manage every USB device!  Obviously
not a sustainable approach in the long run.

Alan Stern

