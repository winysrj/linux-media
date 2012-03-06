Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:54328 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932670Ab2CFX4o (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Mar 2012 18:56:44 -0500
Date: Tue, 6 Mar 2012 17:44:09 -0600 (CST)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Xavion <xavion.0@gmail.com>
cc: Hans de Goede <hdegoede@redhat.com>,
	Jean-Francois Moine <moinejf@free.fr>,
	"Linux Kernel (Media) ML" <linux-media@vger.kernel.org>
Subject: Re: My Microdia (SN9C201) webcam doesn't work properly in Linux
 anymore
In-Reply-To: <CAKnx8Y4z6Ai14RRdG6zd=CEDfHqfNr6Mx=x=XtfU9=KZEwmaNA@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1203061727300.2208@banach.math.auburn.edu>
References: <CAKnx8Y7BAyR8A5r-eL13MVgZO2DcKndP3v-MTfkQdmXPvjjGJg@mail.gmail.com> <CAKnx8Y6dM8qbQvJgt_z2A2XD8aPGhGoqCSWabyNYjRbsH6CDJw@mail.gmail.com> <4F51CCC1.8020308@redhat.com> <CAKnx8Y6ER6CV6WQKrmN4fFkLjQx0GXEzvNmuApnA=G6fJDgsPQ@mail.gmail.com>
 <20120304082531.1307a9ed@tele> <CAKnx8Y7A2Dd0JW0n9bJBBc+ScnagpdFEkAvbg_Jab3vt66Ky0Q@mail.gmail.com> <20120305182736.563df8b4@tele> <CAKnx8Y54ngVXmrLg2bjnn_MvibWE6SKR5jXQFQ9+ZmHWoM9HmQ@mail.gmail.com> <4F55DB8B.8050907@redhat.com>
 <CAKnx8Y4z6Ai14RRdG6zd=CEDfHqfNr6Mx=x=XtfU9=KZEwmaNA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-863829203-256965950-1331077449=:2208"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---863829203-256965950-1331077449=:2208
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT



On Wed, 7 Mar 2012, Xavion wrote:

> Hi Hans
> 
> >> The good news is that the nasty errors I was getting yesterday have
> >> magically disappeared overnight!
> >
> > That is likely because the scene you're pointing at (or the lighting
> > conditions) have changed, not all pictures compress equally well
> > with JPEG. If you point the camera at the same scene as when you were
> > getting these errors (with similar, good, lighting conditions) you'll
> > likely see those errors re-surface.
> 
> At the time, I thought it was probably just because I hadn't rebooted
> my computer after installing GSPCA v2.15.1 the previous day.  If those
> nastier errors resurface, I'll test whether they can be suppressed by
> making those changes to "sn9c20x.c" again.
> 
> >>     root@Desktop /etc/motion # tail /var/log/kernel.log
> >>     Mar  6 08:34:17 Desktop kernel: [ 7240.125167] gspca_main: ISOC
> >> data error: [0] len=0, status=-18
> >>    ...
> >
> > Hmm, error -18 is EXDEV, which according to
> > Documentation/usb/error-codes.txt is:
> >
> > -EXDEV                  ISO transfer only partially completed
> >                        (only set in iso_frame_desc[n].status, not
> > urb->status)
> >
> > I've seen those before, and I think we should simply ignore them rather then
> > log an error for them. Jean-Francois, what do you think?
> 
> I'll let you guys decide what to do about this, but remember that I'm
> here to help if you need more testing done.  If you want my opinion,
> I'd be leaning towards trying to prevent any errors that appear
> regularly.
> 
> >> In fairness to Motion, the default JPEG quality listed in its
> >> configuration file is only 75%.  I had upped this to 90% for clarity,
> >> but subsequently reverting to the default configuration file didn't
> >> stop these errors.
> >
> > That is a different JPG setting, that is the compression quality for the
> > JPEG's motion saves to disk if it detects motion. We're are talking about
> > the compression quality of the JPEG's going over the USB wire, which is
> > controller by the driver, not by motion.
> 
> I thought that was probably the case, but I left open the possibility
> that Motion could've been telling GSPCA what JPEG setting to use for
> USB transfers.
> 
> >> They also remained after I increased the three "vga_mode" ratios to "6
> >> / 8" or changed Line 2093 of "sn9c20x.c" to "sd->quality = 75;".
> >
> > You mean the -18 error remain, right, that is expected, the
> > ratios / sd->quality only fix the errors you were seeing previously.
> 
> Yes, I was only seeing the "-18" error message yesterday.  I knew that
> the "vga_mode" and "sd->quality" suggestions were intended for the
> other (nastier) errors.  As I couldn't be sure that the "-18" error
> wasn't somehow related, I decided to test those suggestions on it as
> well.
> 
> >> Entering either of the following commands before starting Motion
> >> didn't make any difference either.
> >>     export LD_PRELOAD=/usr/lib/libv4l/v4l1compat.so
> >>     export LD_PRELOAD=/usr/lib/libv4l/v4l2convert.so
> >>
> >> The other thing I'm wondering about is how to force SXGA (1280x1024)
> >> mode to be used.  I've set the 'width' and 'height' variables in the
> >> Motion configuration file correctly, but I still see the following
> >> kernel output:
> >>     Mar  6 08:37:46 Desktop kernel: [ 7448.680301] gspca_sn9c20x: Set
> >> 640x480
> >>
> >> I should note that Motion defaults to "V4L2_PIX_FMT_YUV420" in its
> >> configuration file, which is what I'd been using until now.  From the
> >> look of the code in the "sn9c20x.c" file, I must use
> >> "V4L2_PIX_FMT_SBGGR8" to get the 1280x1024 resolution.
> >
> > For sxga mode you will need to use libv4l, but I doubt if your camera
> > supports
> > it at all, most don't. What does dmesg say immediately after unplugging and
> > replugging the camera?
> 
> The software I use to control my webcam in Windows can increase the
> snapshot zoom to what it calls 'SXGA'.  Closer inspection reveals that
> it's actually just doubling the 640x480 image - via nearest-neighbour
> interpolation - to get a rather pixelated 1280x960.

This kind of fudging is, unfortunately, very typical. Lots of cameras on 
the market have things like that written on the package. If there is any 
residual truth in what is written there at all, it says something like 
"Interpolated XxY resolution" which is a mealy-mouthed admission of that 
kind of resolution-inflation when you see it. But sometimes they just 
plain lie. 

 
> This isn't even the proper SXGA resolution, which is supposed to be
> 1280x1024.  The Sonix website claims that their SN9C201 webcam can
> provide up to a 1.3 MP (SXGA) video size!  

Too typical. 

Do you happen to know of
> any inexpensive webcams that are capable of true SXGA in Linux?

Unfortunately, not. But I could not resist pointing out that the kind of 
hype that you have described is all too typical of the marketing for such 
merchandise. 

As to getting that kind of resolution out of a webcam, though, it would be 
a rather tough go due to the amount of data which has to pass over the 
wire even if it is compressed data. The frame rate would be pretty 
atrocious. Therefore, you are probably not going to see that kind 
of resolution in an inexpensive webcam, at least until USB 3 comes 
into common use. 

Perhaps for now if you want that kind of resolution and do not care about 
the frame rate very much, you would be better off to buy a slightly 
fancier camera and do something like using gphoto2 to take timed shots.

Just a suggestion. And thanks for the patience to work through the 
problem. This thread has been an interesting read.

Theodore Kilgore
---863829203-256965950-1331077449=:2208--
