Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAOBLL1H018361
	for <video4linux-list@redhat.com>; Mon, 24 Nov 2008 06:21:21 -0500
Received: from smtp4.versatel.nl (smtp4.versatel.nl [62.58.50.91])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAOBL8hP017481
	for <video4linux-list@redhat.com>; Mon, 24 Nov 2008 06:21:09 -0500
Message-ID: <492A8F83.1020208@hhs.nl>
Date: Mon, 24 Nov 2008 12:26:59 +0100
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: kilgota@banach.math.auburn.edu
References: <mailman.208512.1227000563.24145.sqcam-devel@lists.sourceforge.net>
	<49269369.90805@hhs.nl>
	<Pine.LNX.4.64.0811211244120.4475@banach.math.auburn.edu>
	<200811212157.21254.linux@baker-net.org.uk>
	<Pine.LNX.4.64.0811211658290.4727@banach.math.auburn.edu>
In-Reply-To: <Pine.LNX.4.64.0811211658290.4727@banach.math.auburn.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, sqcam-devel@lists.sourceforge.net
Subject: Re: [sqcam-devel] Advice wanted on producing an in kernel sq905
	driver
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>



kilgota@banach.math.auburn.edu wrote:
> 

<snip>

> Unfortunately libusb doesn't include a
>> corresponding attach method for libgphoto2 to use when it has finished 
>> so it
>> can't re-instate the kernel driver.
> 
> True. But what I am wondering is, if it would be possible to write the 
> kernel driver in such a way that it does not need to get detached, then 
> it would be possible to solve the problem in both directions, not just 
> one. Somehow, arrange things so that if an app requires the kernel 
> driver, then the kernel driver obliges. But if the app wants to approach 
> the device through libusb, then libusb, upon discovering that the kernel 
> driver is loaded, asks the kernel driver for access and then the kernel 
> driver, under certain reasonable conditions, obliges. For example, in 
> the case of a dual-mode camera I would probably tend to consider that 
> the kernel module ought not to surrender while a webcam app is actually 
> in use, but in other circumstances ought to allow "pass through." I 
> mean, if I am a userspace app which peaceably and above-board wants 
> access to a still camera through libusb then do I care if there is a 
> device /dev/videoXX which is associated with my USB vendor:product 
> number? Actually, not. I only care that if I am an app which never wants 
> even to go near to any /dev/videoXX then nobody is going to try to force 
> me to do that. In particular, why does the kernel driver for the device 
> have to force me to access /dev/videoXX even if I never requested any 
> such thing? So it could work like this:
> 

I've been thinking along similar lines (keeping /dev/videoX present when using 
the still image function). But thinking about this some more I don't think this 
is worth the trouble. A camera which can do both still images and function as 
webcam really is a multifunction device, with one function active at a time, 
this is just like any usb device with multiple usb configurations, and when you 
change the configuration certain functionality becomes not available and other 
becomes available. If this cam would be correctly using usb configuaration 
profiles for this, the /dev/videoX would also disappear.

Also by just unloading the driver removing /dev/videoX things stay KISS.

Last it is not that strange for the webcam not to show up as a webcam to choose 
from for use in a webcam app, when you've got a photo app open for importing 
photo's (and when the import dialog is closed the device should be given back 
to the /dev/videoX driver).

So all in all I believe that having some mechanism:
-to unload the driver when libusb wants access *AND*
-reload it when libusb is done

Is enough, and is nice and KISS, which I like.

Regards,

Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
