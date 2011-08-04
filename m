Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:40247 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754245Ab1HDWZv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Aug 2011 18:25:51 -0400
Date: Thu, 4 Aug 2011 17:30:38 -0500 (CDT)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Adam Baker <linux@baker-net.org.uk>
cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Jean-Francois Moine <moinejf@free.fr>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans de Goede <hdegoede@redhat.com>,
	workshop-2011@linuxtv.org
Subject: Re: [Workshop-2011] Media Subsystem Workshop 2011
In-Reply-To: <201108042238.22487.linux@baker-net.org.uk>
Message-ID: <alpine.LNX.2.00.1108041659430.17734@banach.math.auburn.edu>
References: <4E398381.4080505@redhat.com> <Pine.LNX.4.64.1108042052070.31239@axis700.grange> <4E3B0237.7010209@redhat.com> <201108042238.22487.linux@baker-net.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Thu, 4 Aug 2011, Adam Baker wrote:

> On Thursday 04 August 2011, Mauro Carvalho Chehab wrote:
> > > That'd also be my understanding. There are already several standard ways 
> > > to access data on still cameras: mass-storage, PTP, MTP, why invent Yet 
> > > Another One? "Just" learn to share a device between several existing 
> > > drivers.
> > 
> > For those that can export data into some fs-like way, this may be the
> > better way. It seems that gvfs does something like that. I've no idea how
> > easy or difficult would be to write Kernel driver for it.
> 
> As I understand it gvfs uses libgphoto2 and fuse and it is the interface 
> libghoto2 that is the problem. 

This is correct. Except that the problem is not in libgphoto2 per se, but 
is at an even lower level. It could be said that the problem is in libusb, 
because libghoto2 uses libusb. So maybe the solution is to fix up libusb. 
Or, as I have come recently to think, maybe not. In any event, neither use 
nor avoidance of gvfs has much of anything to do with the problem at hand. 
But the problem exists with it or without it.


libgphoto2 contains lots of the same sort of 
> code to handle strange data formats from the camera as libv4l so I don't think 
> we want to be moving that code back into the kernel.(The old out of kernel 
> driver for sq905 before Theodore and I rewrote it contained code to do Bayer 
> decoding and gamma correction that was copied from libgphoto2).

This is all very much true. Moreover, I do not think that anyone has the 
idea to put any of that kind of code back into the kernel.

But, just in case that anyone is thinking of possible "overlap" between 
what is done in libv4l and libgphoto2, someone should point out that 
things like Bayer demosaicing and gamma correction are not necessarily 
done the same way in the two libraries. Why is that? Well, it is true 
because one of the libraries supports streaming and the other one supports 
still cameras. Thus, the Bayer demosaicing functions in libv4l are 
optimized for speed, which will directly affect the frames per second 
rate. The Bayer demosaicing functions in libusb are intended to process 
image data from still cameras. For a still camera, frame rate is 
irrelevant and meaningless. Therefore the priority is, or ought to be, to 
get the best possible image out of the downloaded image data. 

Theodore Kilgore
