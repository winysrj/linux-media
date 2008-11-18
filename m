Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAI9uY0m030008
	for <video4linux-list@redhat.com>; Tue, 18 Nov 2008 04:56:34 -0500
Received: from smtp3.versatel.nl (smtp3.versatel.nl [62.58.50.90])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAI9tNsN011345
	for <video4linux-list@redhat.com>; Tue, 18 Nov 2008 04:55:24 -0500
Message-ID: <4922924B.8050302@hhs.nl>
Date: Tue, 18 Nov 2008 11:00:43 +0100
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Adam Baker <linux@baker-net.org.uk>
References: <200811172253.33396.linux@baker-net.org.uk>
In-Reply-To: <200811172253.33396.linux@baker-net.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, sqcam-devel@lists.sourceforge.net
Subject: Re: Advice wanted on producing an in kernel sq905 driver
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

<note resend with different From address for the video4linux-list>

Adam Baker wrote:
> Hi V4L readers,
> 

Hi Adam,

Nice to meet you.

> There currently exists an out of kernel driver for the SQ technologies sq905 
> USB webcam chipset used by a number of low cost webcams. This driver has a 
> number of issues which would count against it being included in kernel as is 
> but I'm considering trying to create something that could be suitable.

Great, thats very good news!

> I have 
> a number of questions on how best to proceed.
>

Good, keep asking asking questions!

> Note that this refers only to the sq905, USB ID 0x2770:0x9120 the sq905c is a 
> substantially different chip.
> 
> (If anyone wants to check out the current driver it is at 
> http://sqcam.cvs.sourceforge.net/viewvc/sqcam/sqcam26/ )
> 
> First off some thoughts on how I'd like to proceed.
> 
> The chip exposes the Bayer sensor output directly to the driver so the current 
> driver uses code borrowed from libgphoto2 to do the Bayer decode in kernel. 
> Obviously this is wrong and now we have libv4l it should use that instead.
> 

Correct, there is nothing special you need to do for that, just pass frames
with the raw bayer data to userspace and set the pixelformat to one of:
V4L2_PIX_FMT_SBGGR8 /* v4l2_fourcc('B', 'A', '8', '1'), 8 bit BGBG.. GRGR.. */
V4L2_PIX_FMT_SGBRG8 /* v4l2_fourcc('G', 'B', 'R', 'G'), 8 bit GBGB.. RGRG.. */
V4L2_PIX_FMT_SGRBG8 /* v4l2_fourcc('G','R','B','G'), 8 bit GRGR.. BGBG.. */
V4L2_PIX_FMT_SRGGB8 /* v4l2_fourcc('R','G','G','B'), 8 bit RGRG.. GBGB.. */

Note the last 2 currently are only defined internally in libv4l and not in
linux/videodev2.h as no drivers use them yet, but if you need one of them
adding it to linux/videodev2.h is fine.

And then make sure your applications are either patched to use libv4l, or use
the LD_PRELOAD libc wrapper (see libv4l docs).

> I don't have masses of time to work on this so I need an approach that isn't 
> going to require writing loads of code.

Actually, the plan is to remove lots of code :)

> Considering the mess the current
> driver is in it is probably going to be better to make it a sub driver of 
> gspca rather than try to re-use the existing code (which should also make 
> life easier from a long term maintenance PoV).
> 

Yes please make it a subdriver of gspca, then all you need to lift from the
current driver are the chip specific initalization sequences, and the isoc
frame parsing for detecting the beginning and ending of frames.

> Now my questions
> 
> 1) What kernel should I base any patches I produce on? The obvious choice 
> would seem to be 
> git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git but it 
> seems as if Linus's 2.6 tree is more up to date for gspca.

Please use:
http://linuxtv.org/hg/~jfrancois/gspca/

Note that like al v4l-dvb trees this is a standalone tree, not a complete
kernel, assuming you've got the headers installed for your current kernel you
can just do make menuconfig, make, make install from this tree (from the main
dir, not from the linux subdir) to update your current kernels video4linux
modules to the latest, then add your own driver and rince repeat :)

> 2) The existing driver needed to perform a gamma adjustment after performing 
> the Bayer decode. I couldn't find anything in libv4l that obviously did that 
> so I'm guessing it isn't needed for existing devices - should that be added 
> to libv4l if needed and if so how should the driver indicate it is needed - 
> could it be indicated with a new value for v4l2_colorspace?

Hmm interesting for now lets ignore this and first get it up and running
without this, and the revisit this. I'm asking for this because gamma
correction might be interesting for other cams too, so I would like to see a
generic solution for this, which will take some design work, etc.

> 3) The current driver needs to do some up/down and left/right flips of the 
> data to get it in the right order to do the Bayer decode that depend on the 
> version info the camera returns to its init sequence. Should that code remain 
> in the driver and if not how should the driver communicate what is needed.
> 

It should communicate what is needed all possible bayer orders are covered by
the 4 formats I gave above, and libv4l knows how to handle all 4 of them, for
the defines of the last 2 see libv4lconvert/libv4lconvert-priv.h

> 4) The current driver doesn't support streaming mode for V4L2 (only V4L1) and 
> libv4l doesn't support cameras that don't support streaming so is there an 
> easy way to test out if the camera output will work well with libv4l before 
> starting work?

This should not be a problem. gspca now can work with both bulk and
isochronyous usb transfers using cams, although your cam most likely is an isoc
one (bulk mode cams are rare).

> 5) Is there anything else I should know before starting.

Not that I know, go for it!

Regards,

Hans


p.s.

In case it isn't clear  I'm the author of libv4l and a contributer to gspca, as
said before: go for it and keep asking questions!

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
