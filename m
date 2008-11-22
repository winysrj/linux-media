Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAMLtWwx022445
	for <video4linux-list@redhat.com>; Sat, 22 Nov 2008 16:55:32 -0500
Received: from mk-outboundfilter-5.mail.uk.tiscali.com
	(mk-outboundfilter-5.mail.uk.tiscali.com [212.74.114.1])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAMLtRQQ025172
	for <video4linux-list@redhat.com>; Sat, 22 Nov 2008 16:55:31 -0500
From: Adam Baker <linux@baker-net.org.uk>
To: sqcam-devel@lists.sourceforge.net
Date: Sat, 22 Nov 2008 21:55:24 +0000
References: <mailman.208512.1227000563.24145.sqcam-devel@lists.sourceforge.net>
	<200811220005.34321.linux@baker-net.org.uk>
	<Pine.LNX.4.64.0811211955490.4832@banach.math.auburn.edu>
In-Reply-To: <Pine.LNX.4.64.0811211955490.4832@banach.math.auburn.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811222155.24822.linux@baker-net.org.uk>
Cc: video4linux-list@redhat.com, kilgota@banach.math.auburn.edu
Subject: Re: The userspace-kernelspace thing. Continuation of sq905 driver
	discussion.
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

On Saturday 22 November 2008, kilgota@banach.math.auburn.edu wrote:
> On Sat, 22 Nov 2008, Adam Baker wrote:
> > On Friday 21 November 2008, kilgota@banach.math.auburn.edu wrote:
> >>> Unfortunately libusb doesn't include a
> >>> corresponding attach method for libgphoto2 to use when it has finished
> >>> so it can't re-instate the kernel driver.
> >>
> >> True. But what I am wondering is, if it would be possible to write the
> >> kernel driver in such a way that it does not need to get detached, then
> >> it would be possible to solve the problem in both directions,
> >
> > I don't believe that that is possible because if I understand correctly
> > libusb detects that a driver has been loaded that has claimed that device
> > and so it needs to be involved in the communication to get the kernel
> > driver to allow access.
>
> I understand this to be an accurate description of the current state of
> affairs. Under a different scenario, though, libgphoto2 asks the kernel
> for access to the device. The kernel either gives it directly, or, if the
> device is controlled by a module, then passes the request to the module.
> If the module is a "nice" module and understands that the hardware device
> is not in use by some other program, it cheerfully honors the request. If
> such a thing were to be implemented, then of course there would have to be
> a change in the way that libusb tries to get access to a device, too.
>

That is basically what usb_detach_kernel_driver_np does. The only problem is 
that the current version of libusb does not provide a corresponding attach 
method to reinstate the kernel driver afterwards. Having got a response on 
the libusb mailing list I can now also confirm that the current libusb API 
never will.

The attach method is however a completely standalone piece of code so 
libgphoto2 could if desired just define it's own attach method if the 
platform provides a detach method but no attach method.

> > To acheive what you are suggesting the kernel driver would have to return
> > false from its xxx_probe routine and not create it's endpoints but still
> > call video_register_device to create the /dev/videox dev file.
>
> Hmmm. Well, not necessarily. If automatically loaded at boot it could just
> sit there and do nothing unless it gets a request, couldn't it? Or, if
> loaded later on because the camera is plugged in, it could then do the
> same thing. Then, if a v4l type of program wants something from it, it
> creates the video device. Otherwise, it does not. And if the v4l type
> program is exited, then the video device goes away and the kernel driver
> waits for the next request, from whatever source.
>
>

It needs to create the /dev/video device so that video aware apps can see a 
device to offer to the user to use. Otherwise they have no way of talking to 
the driver to say they want it to wake up.

> The problem is I
>
> > don't believe there exists a mechanism whereby it
>
> by "it" I assume you mean the kernel driver?

Correct

>
> could then obtain access to
>
> > the USB device within it's xxx_open routine and it certainlywouldn't
> > receive USB disconnect events so couldn't clean up properly.
> >
> > The libusb attach/detach mechanism definitely looks like the cleanest
> > solution if we can get a shipping version of libusb that implements
> > attach.
>
> Well, It would be fun to test that. Is there an SVN version? I hereby
> volunteer. If it works, then, problem solved.

There is an svn version but it is in a dead branch. As stated above I think 
putting the attach code into libgphoto2 is the best we can do.

>
> I am not very much scared of such things, but if I am supposed to be
> scared, then, well, I have 2 other machines sitting within a two meter
> radius. They are old boxes. So if one of them catches fire I will just
> have to run and get the fire extinguisher. Adtually, I run a risk every
> time I boot one of them up already. They are both dual boot (as this
> machine is not because it is for serious business). One of them has a
> Win98 partition on it and the other one has a Win2K partition. Neither of
> them is hooked to any network because of that. They are used, of course,
> for installing Win drivers and running stuff like usbsnoop. But I already
> take my life in my hands every time I fire one of those up. So, scared of
> experimental code? Who, me? Nah.

I don't think the patch at
http://osdir.com/ml/lib.libusb.devel.general/2007-04/msg00239.html
is anything to be scared of, at least not on a machine that already has a non 
vendor packaged libgphoto2

Regards

Adam

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
