Return-path: <video4linux-list-bounces@redhat.com>
From: Adam Baker <linux@baker-net.org.uk>
To: sqcam-devel@lists.sourceforge.net
Date: Tue, 25 Nov 2008 20:57:37 +0000
References: <mailman.208512.1227000563.24145.sqcam-devel@lists.sourceforge.net>
	<200811250002.36951.linux@baker-net.org.uk>
	<Pine.LNX.4.64.0811241929420.7049@banach.math.auburn.edu>
In-Reply-To: <Pine.LNX.4.64.0811241929420.7049@banach.math.auburn.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811252057.38162.linux@baker-net.org.uk>
Cc: Hans de Goede <hdegoede@redhat.com>, video4linux-list@redhat.com,
	kilgota@banach.math.auburn.edu
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

On Tuesday 25 November 2008, kilgota@banach.math.auburn.edu wrote:
> On Tue, 25 Nov 2008, Adam Baker wrote:
<snip>
> > This approach can even cope with the complex case that no-one has yet
> > considered, wanting to use one sq905 based camera to record video while
> > you download stills from another.
>
> That is interesting if it works, yes. But how could a thing like that
> work?

Because it the libusb detach call doesn't unload the driver, just detach it 
from the usb device supplied as an argument. If there were another device 
using the same driver it would remain attached.

> If the kernel is without V4L support, then clearly no module will get
> loaded. But I would say that
>
> "embedded system or small system" != "don't want camera drivers"

Certainly there exist embedded systems that may want camera drivers but then 
they have to have the memory to support them so there is no benefit to not 
loading the driver.

>
> > To hopefully convince you this can easily provide all the functionality
> > you want I've attempted to do some testing and in order to avoid changing
> > libgphoto I've written a little standalone app (attached) to do the
> > cleanup. I'm taking advantage of the fact I know we want ifno 0 for this
> > cam but libgphoto2 has already found the correct value.
> >
<snip>
> >
> > If I now run up gphoto2 again all my images have gone as I actually used
> > the webcam functionality.
>
> Convincing, yes.
>
> > I've changed the ioctl's in the patch from using libusb private values to
> > values from a kernel provided header file.
>
> All right, I will have a look. Unfortunately, I understand that in order
> really to test it I need to have some piece of hardware which is supported
> through libgphoto2 in one mode and by a module in the other mode. An old
> SQ905 camera will do that, but what module are you using to support it
> right now? The old one? Is it compatible with recent kernels? Or is it
> rewritten somewhere? Sorry, but while I can easily understand the
> underlying problems here I am not up to speed at all about webcam apps or,
> for that matter, the latest status of V4L.

Yes, I am using the existing sqcam driver from 
http://sqcam.cvs.sourceforge.net/viewvc/sqcam/sqcam26/

I think the newest kernel I've tested it with is 2.6.26. I've certainly tried 
with one where V4L1 support is optional which I think started from 2.6.26 but 
I never committed the changes needed to allow the driver to build if V4L1 
support is disabled so you need to check CONFIG_VIDEO_V4L1 is set on recent 
kernels.

>
>
> So what I understand is this code will re-scan the USB bus, and, when it
> does, the module gets reloaded if the camera is plugged in. It seems to me
> that a very logical place to put code like this would be in a webcam app,
> not in libgphoto2. I suspect that this is not what you want me to say.
> But, as I said, I will have a look at the code.

It doesn't re-scan the whole bus, just rescan the driver list to see if one 
matches that device.

Regards

Adam

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
