Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:56893 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355Ab1HHSJG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Aug 2011 14:09:06 -0400
Date: Mon, 8 Aug 2011 13:14:02 -0500 (CDT)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Alan Stern <stern@rowland.harvard.edu>
cc: Adam Baker <linux@baker-net.org.uk>,
	Jean-Francois Moine <moinejf@free.fr>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-usb@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
Subject: Re: [Workshop-2011] Media Subsystem Workshop 2011
In-Reply-To: <Pine.LNX.4.44L0.1108081038350.1944-100000@iolanthe.rowland.org>
Message-ID: <alpine.LNX.2.00.1108081241380.21409@banach.math.auburn.edu>
References: <Pine.LNX.4.44L0.1108081038350.1944-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Mon, 8 Aug 2011, Alan Stern wrote:

> On Sun, 7 Aug 2011, Theodore Kilgore wrote:
> 
> > This indirectly answers my question, above, about whatever device there 
> > may or may not be. What I get from this, and also from a bit of snooping 
> > around, is that there is not any dev that gets created in order to be 
> > accessed by libusb. Just an entry under /proc/bus/usb, which AFAICT is at 
> > most a pseudo-device. Thanks.
> 
> Nowadays, most distributions create device nodes under /dev/bus/usb.  A 
> few also support the old /proc/bus/usb files.

What does this mean, exactly, in practice? You are right that I have the 
/dev/bus/usb/ files but does everybody have them, these days?


> 
> > So, Alan, what do you think is the best way to go about the problem? The 
> > camera can act as a stillcam or as a webcam. The problem is to provide 
> > access to both, with equal facility (and of course to lock out access to 
> > whichever action is not currently in use, if the other one is). 
> > 
> > The current situation with libusb does not cut it, as among other things 
> > it currently does only half the job and seemingly cannot address the 
> > locking problem. 

Alan, I do not know if you have actually followed what has been going on. 
One of the things which has been happening is that we have a real, 
immediate mess on our hands, in that some folks have put together distros 
which insist upon automatically mounting all stilcams whenever they are 
plugged in, thereby destroying the ability of any dual-mode camera to 
function as a webcam. This "brilliant" move seems to have been conceived 
in sin, or at least in total ignorance or disregard of the underlying 
problems, but it has been done and sold to the public as a convenience. So 
it seems to me that the infrastructural problem needs attention.


> > Hans suggests to create two explicit devices, /dev/video 
> > (as already done and something like /dev/cam. Then access webcam function 
> > as now and stillcam function with libgphoto2, as now, but through /dev/cam 
> > instead of through libusb. This would seem to me to solve all the 
> > problems, but at the expense of some work. Can you think of something more 
> > clever?
> 
> I'm not familiar with the MTP protocol used in the stillcam mode, or
> how feasible it would be to implement that protocol in a kernel driver.  

What? You, too? :-/

As I said to Mauro, all of the currently affected cameras that I know of 
are proprietary. And proprietary means what it says. It means that the 
protocol depends upon the controller chip in the camera, not upon any 
standard. And not just the commands, but also the methodologies and 
approaches which underlie the command structure can differ wildly. 

> Maybe a good compromise would be to create a kind of stub driver that
> could negotiate the device access while still delegating most of the
> real work to userspace.

Hooray. This appears to me to be a very good solution.

> 
> This could become a bigger problem if this kind of design becomes an
> ongoing trend.  To do what Hans was suggesting, today we have to merge
> two separate drivers... 

Actually, the current count is even worse. It is four drivers, not two. 
See previous remarks about proprietary protocols. 


then tomorrow we would have to merge two others
> and then later on even more.  Before you know it, we would end up with
> a single gigantic kernel driver to manage every USB device!  

More exactly, a gillion kernel drivers, each one to control each 
proprietary device, and then, I suppose, "one ring to rule them all ..."
But that is just as bad as your nightmare, so it makes no difference in 
the end, does it?

Obviously
> not a sustainable approach in the long run.

I agree approximately 120% with this. Let's think of a more clever way. If 
we get the basic idea right, it really ought not to be too terribly 
difficult.

Theodore Kilgore
