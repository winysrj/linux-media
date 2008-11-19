Return-path: <video4linux-list-bounces@redhat.com>
From: Adam Baker <linux@baker-net.org.uk>
To: kilgota@banach.math.auburn.edu, sqcam-devel@lists.sourceforge.net,
	video4linux-list@redhat.com
Date: Wed, 19 Nov 2008 00:20:15 +0000
References: <mailman.208512.1227000563.24145.sqcam-devel@lists.sourceforge.net>
	<Pine.LNX.4.64.0811181216270.2778@banach.math.auburn.edu>
In-Reply-To: <Pine.LNX.4.64.0811181216270.2778@banach.math.auburn.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Disposition: inline
Message-Id: <200811190020.15663.linux@baker-net.org.uk>
Content-Transfer-Encoding: 8bit
Cc: Hans de Goede <hdegoede@redhat.com>
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

Responses to both Kilgore and Hans are included below.

On Tuesday 18 November 2008, kilgota@banach.math.auburn.edu wrote:

> Hi,
>
> I am not a specialist on kernel camera drivers, but I do know a few things
> about SQ cameras, having done the support in Gphoto for them. I am quite
> willing to offer some help on this, as the other thing that I am doing
> right now a very slow effort to figure out the decompression algorithm for
> another camera, from another company. Here follow some comments and
> questions, in no particular order:

Thanks for the offer of help - if nothing else it will be useful to have 
someone who has a selection of these cameras available for testing as I've 
only got one myself.

>
> 1. The SQ905C cameras (0x2770:0x905c) are not identical but in fact are
> very similar. The commands are similar, but no single one of them is an
> exact match. It would have been feasible to combine the two drivers in
> libgphoto2, but it would have been messy. I think that to keep them
> separate was the right decision for that reason. But there is a lot of
> similarity, so it seems to me that it is certainly a better idea to
> produce video drivers for both SQ905 and SQ905C at the same time. Or,
> perhaps since the list of commands used for video is much smaller, then
> perhaps they could be combined after all.

I think it might be best to produce one driver first and then see if it makes 
more sense to add sq905c or to use the sq905 driver as a template for an 
sq905c one. Not having access to an sq905c camera I'm not volunteering for 
that phase though.

>
> 3. Even so, you should both take seriously the question whether these
> cameras actually need a kernel driver, or whether it would actually be
> useful. Perhaps it would be a better idea to do something totally in
> userspace and figure out how to hook that into a frontend program like
> xawtv or some other program which is associated with V4L instead of
> getting input from a kernel-supported device? The reasons I say this are:
>
> a. There is IMHO a too big proliferation of kernel modules especially in
> this area of video. It seems every new device that comes along needs its
> own separate module. It would be nice if it is possible to slow down on
> this. In general, I think it is a *good idea* if more is done in userspace
> and as little as is needed is done in the kernel.

I've been thinking about that for quite a while now. The problem is that 
applications are written to use V4L2 and a V4L2 camera has a device node. I 
did consider for a while the idea of creating a kernel space driver that just 
exposed an interface that a user space libusb app could provide video data to 
but concluded it seemed like a lot of work for little benefit.

>
> b. As I understand, the reason for needing a kernel driver is because of
> speed issues. Partly correlated with this, the libusb support for
> isochronous data transmission (used by most webcams) has been missing.
> There are attempts, I understand, to add that. But I have not heard it is
> done. However, the question of isochronous transport is not relevant here,
> at all.

>From my PoV the main reason for wanting a kernel driver is so that a V4L2 
aware app can find the device. I don't expect performance to be a big issue, 
especially as this is only a USB 1.1 device

>
> 4. As to kernel support, there is the further problem that the camera does
> not appear visibly different to the computer if it is in still mode or in
> webcam mode. Some devices, when they change from one mode to another, also
> change the USB Product number or give some other signal that they are now
> in a different mode. But, no, these do not do any of that. It is just a
> question of what command is given _to_ the camera. If you give a certain
> sequence of bytes to the camera, it trips the shutter and the camera then
> expects you to download the frame it just shot. That's it. So the problem
> is now which will grab the camera when it is plugged in -- libgphoto2 or
> the kernel module? If the kernel module grabs the camera, then libgphoto2
> is userspace and will lose. So then the user who was intending to download
> all the snapshots on the camera, swears under his breath and has to unplug
> the camera, become root, remove the module, blacklist the module, become
> user, replug the camera, and then get the photos off. Or, if the module is
> blacklisted by default, then the user plugs in the camera, runs a video
> capture/display program, gets nothing but an error message saying there is
> no device, swears under his breath, remembers that he has to do "su
> modprobe xxxx" and only then can run the capture program. It is far the
> best to think of ways to avoid nonsense situations like this before they
> happen to users.

Solving that problem was one of my blocking points for pushing a module into 
mainline. Thankfully the libgphoto2 team have near enough solved it. Current 
operation is that when the camera is plugged the kernel driver takes control 
of it. If you then start a libgphoto based app it will attempt to claim the 
device and as long as the driver isn't in use it should succeed. The only bit 
that doesn't work perfectly is that it won't revert to webcam mode after you 
stop the libgphoto app, you need to unplug the camera and plug it back in to 
use it as a webcam again. As far as I can tell that is a shortcoming of 
libusb for which a fix is being considered.

>
> 5. As to the command which is required to get video out of one of these
> cameras, the command is already in use in both of the camera support
> libraries in libgphoto2. It is used there for taking a single snapshot,
> with the command option gphoto2 --capture-preview. So all that is needed
> is to be able to run this command repeatedly, process the data each time
> into a frame, and have some method for displaying the sequence of frames,
> instead of doing these things just once and saving the captured frame, as
> it is done in Gphoto.

The necessary commands are also working in the current out of kernel V4L 
driver (based I believe on some of your earlier work) so I'm not too worried 
on that front.

>
> Needless to say, even though I have some reservations about kernel
> support, as presented in items 3 and 4, I offer my cooperation. I do
> believe, however that the points under item 3 should be thought about
> seriously.

I hope my comments above have at least reduced your reservations

> A few further comments are interspersed below, which address some specific
> points.
>
> Theodore Kilgore
>
> > Message: 7
> > Date: Mon, 17 Nov 2008 22:53:33 +0000
> > From: Adam Baker <linux@baker-net.org.uk>
> > Subject: [sqcam-devel] Advice wanted on producing an in kernel sq905
> > 	driver
> > To: video4linux-list@redhat.com
> > Cc: sqcam-devel@lists.sourceforge.net
> > Message-ID: <200811172253.33396.linux@baker-net.org.uk>
> > Content-Type: text/plain;  charset="us-ascii"
> >
> > Hi V4L readers,
> >
> > There currently exists an out of kernel driver for the SQ technologies
> > sq905 USB webcam chipset used by a number of low cost webcams. This
> > driver has a number of issues which would count against it being included
> > in kernel as is but I'm considering trying to create something that could
> > be suitable. I have a number of questions on how best to proceed.
>
> Please do refer to item 5 above. That is a problem which needs to be
> solved.

Did you mean 4, not 5?

> >
> > First off some thoughts on how I'd like to proceed.
> >
> > The chip exposes the Bayer sensor output directly to the driver so the
> > current driver uses code borrowed from libgphoto2 to do the Bayer decode
> > in kernel. Obviously this is wrong and now we have libv4l it should use
> > that instead.
>
> Ah, Bayer demosaicing. I wonder if my new demosaicing algorithm for
> libgphoto2 could run fast enough to work for a webcam, or at least for a
> slow webcam. It does give much better output for still shots.
>

The out of kernel code has just copy and pasted from libgphoto2 for the Bayer 
demosaicing but if I rely on libv4l this becomes Hans de Goede's problem to 
select the best algorithm, not mine.

> >
> > 3) The current driver needs to do some up/down and left/right flips of
> > the data to get it in the right order to do the Bayer decode that depend
> > on the version info the camera returns to its init sequence.
>
> That is correct. If you don't know which camera it is, then you cannot
> correctly process the images because of these orientation issues. The
> Bayer tiling scheme also is dependent on the model version number, so if
> this is not accounted for then the colors will be wrong as well as the
> orientation.
>
> Should that code remain
>
> > in the driver and if not how should the driver communicate what is
> > needed.
>
> My two cents is that you have to read the version number and make the
> appropriate use of that information. There is no other way to communicate
> what is needed.
>

I clearly have to read the version and either flip the data myself or inform 
libv4l that it needs to be flipped. The do as much work in userspace as 
possible argument says I should just provide an indicator that it needs 
flipping but I don't know how to do that.


> >> First off some thoughts on how I'd like to proceed.
> >>
> >> The chip exposes the Bayer sensor output directly to the driver so the
> >> current driver uses code borrowed from libgphoto2 to do the Bayer decode
> >> in kernel. Obviously this is wrong and now we have libv4l it should use
> >> that instead.
> >
> > Correct, there is nothing special you need to do for that, just pass
> > frames with the raw bayer data to userspace and set the pixelformat to
> > one of: V4L2_PIX_FMT_SBGGR8 /* v4l2_fourcc('B', 'A', '8', '1'), 8 bit
> > BGBG.. GRGR.. */ V4L2_PIX_FMT_SGBRG8 /* v4l2_fourcc('G', 'B', 'R', 'G'),
> > 8 bit GBGB.. RGRG.. */ V4L2_PIX_FMT_SGRBG8 /*
> > v4l2_fourcc('G','R','B','G'), 8 bit GRGR.. BGBG.. */ V4L2_PIX_FMT_SRGGB8
> > /* v4l2_fourcc('R','G','G','B'), 8 bit RGRG.. GBGB.. */
> >
> > Note the last 2 currently are only defined internally in libv4l and not
> > in linux/videodev2.h as no drivers use them yet, but if you need one of
> > them adding it to linux/videodev2.h is fine.

The different known variants of this camera use either BGGR or GBRG so I seem 
to be off the hook there.

> >
> > And then make sure your applications are either patched to use libv4l, or
> > use the LD_PRELOAD libc wrapper (see libv4l docs).
> >

I've been testing with LD_PRELOAD but discovered it was rejecting the camera 
because the current driver doesn't support mmap for V4L2 so doesn't set the 
streaming flag.

> >> Now my questions
> >>
> >> 1) What kernel should I base any patches I produce on? The obvious
> >> choice would seem to be
> >> git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git but
> >> it seems as if Linus's 2.6 tree is more up to date for gspca.
> >
> > Please use:
> > http://linuxtv.org/hg/~jfrancois/gspca/

OK

> >
> > Note that like al v4l-dvb trees this is a standalone tree, not a complete
> > kernel, assuming you've got the headers installed for your current kernel
> > you can just do make menuconfig, make, make install from this tree (from
> > the main dir, not from the linux subdir) to update your current kernels
> > video4linux modules to the latest, then add your own driver and rince
> > repeat :)
> >
> >> 2) The existing driver needed to perform a gamma adjustment after
> >> performing the Bayer decode. I couldn't find anything in libv4l that
> >> obviously did that so I'm guessing it isn't needed for existing devices
> >> - should that be added to libv4l if needed and if so how should the
> >> driver indicate it is needed - could it be indicated with a new value
> >> for v4l2_colorspace?
> >
> > Hmm interesting for now lets ignore this and first get it up and running
> > without this, and the revisit this. I'm asking for this because gamma
> > correction might be interesting for other cams too, so I would like to
> > see a generic solution for this, which will take some design work, etc.

OK, I wondered if anyone else might be able to make use of it. The 
implementation in the current driver is just a single fixed correction. There 
is a version at http://philippe.corbes.free.fr/sqcam/ in which someone has 
implemented 8 gamma tables selected by VIDIOCSPICT (that driver is pure V4L1) 
but libv4l is allowed to use floating point so could calculate the table on 
the fly upon receiving an ioctl. This doesn't sound too hard to add to libv4l 
if needed - the only problem is in selecting an appropriate initial value as 
that may be camera dependent.

> >
> >> 3) The current driver needs to do some up/down and left/right flips of
> >> the data to get it in the right order to do the Bayer decode that depend
> >> on the version info the camera returns to its init sequence. Should that
> >> code remain in the driver and if not how should the driver communicate
> >> what is needed.
> >
> > It should communicate what is needed all possible bayer orders are
> > covered by the 4 formats I gave above, and libv4l knows how to handle all
> > 4 of them, for the defines of the last 2 see
> > libv4lconvert/libv4lconvert-priv.h

This isn't just a question of Bayer selection, the image will be upside down 
and possibly mirror imaged too. The question is mainly one of how can the 
driver communicate such info to libv4l.

> >
> >> 4) The current driver doesn't support streaming mode for V4L2 (only
> >> V4L1) and libv4l doesn't support cameras that don't support streaming so
> >> is there an easy way to test out if the camera output will work well
> >> with libv4l before starting work?
> >
> > This should not be a problem. gspca now can work with both bulk and
> > isochronyous usb transfers using cams, although your cam most likely is
> > an isoc one (bulk mode cams are rare).
>
> It may be rare, but this is one of those rare specimens. These cameras do
> not even have isochronous endpoints so there is no option to use what does
> not even exist.

Correct.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
