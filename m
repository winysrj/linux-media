Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:42873 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196Ab1HHUiJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Aug 2011 16:38:09 -0400
Date: Mon, 8 Aug 2011 15:43:09 -0500 (CDT)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Adam Baker <linux@baker-net.org.uk>
cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans de Goede <hdegoede@redhat.com>,
	workshop-2011@linuxtv.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [Workshop-2011] Media Subsystem Workshop 2011
In-Reply-To: <201108082124.47789.linux@baker-net.org.uk>
Message-ID: <alpine.LNX.2.00.1108081534300.21785@banach.math.auburn.edu>
References: <4E398381.4080505@redhat.com> <alpine.LNX.2.00.1108081423020.21636@banach.math.auburn.edu> <4E4041EF.8020702@redhat.com> <201108082124.47789.linux@baker-net.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Mon, 8 Aug 2011, Adam Baker wrote:

> On Monday 08 August 2011, Mauro Carvalho Chehab wrote:
> > > 
> > >
> > > Well, in practice the "fork" would presumably be carried out by yours 
> > > truly. Presumably with the advice and help of concerned parties. too. 
> > > Since I am involved on both the kernel side and the libgphoto2 side of
> > > the  support for the same cameras, it would certainly shorten the lines
> > > of communication at the very least. Therefore this is not infeasible.
> > 
> > Forking the code just because we have something "special" is the wrong
> > thing to do (TM). I would not like to fork V4L core code due to some
> > special need, but instead to add some glue there to cover the extra case.
> > Maintaining a fork is bad in long term, as the same fixes/changes will
> > likely be needed on both copies.
> 
> Unfortunately there is some difficulty with libusb in that respect. libgphoto 
> relies upon libusb-0.1 becuase it  is cross platform and Win32 support in 
> libusb-1.0 is only just being integrated. The libusb developers consider the 
> libusb-0.1 API frozen and are not willing to extend it to address our problem. 
> libusb doesn't expose the file descriptor it uses to talk to the underlying 
> device so it is hard to extend the interface without forking libusb (The best 
> hope I can think of at the moment is to get the distros to accept a patch for 
> it to add the extra required API call(s) and for libgphoto to use the extra 
> features in that patch if it detects it is supported at compile time).

Adam,

Yes, you are quite correct about this. I was just on the way out of the 
house and remembered that this problem exists, decided to re-connect and 
add this point to the witches' brew that we are working on. 

What struck me was not the Windows support, though, it was the Mac 
support. And a number of people run Gphoto stuff on Mac, too. That just 
reinforces your point, of course. Gphoto is explicitly cross-platform. It 
is developed on Linux but it is supposed to compile on anyone's C compiler 
and run on any hardware platform or operating system which has available 
the minimal support require to make it work.

You are right. We, basically, can not screw with the internals of 
libgphoto2. At the outside, one can not go to the point where any changes 
would break the support for other platforms.

Theodore Kilgore
