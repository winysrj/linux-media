Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:47642 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572AbZBNS6m (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Feb 2009 13:58:42 -0500
Date: Sat, 14 Feb 2009 16:58:08 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Andy Walls <awalls@radix.net>, linux-media@vger.kernel.org,
	Hans de Goede <j.w.r.degoede@hhs.nl>
Subject: Re: libv4l2 library problem
Message-ID: <20090214165808.2a54e048@pedra.chehab.org>
In-Reply-To: <200902141511.13334.hverkuil@xs4all.nl>
References: <200902131357.46279.hverkuil@xs4all.nl>
	<200902141206.28036.hverkuil@xs4all.nl>
	<1234620314.3073.28.camel@palomino.walls.org>
	<200902141511.13334.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 14 Feb 2009 15:11:13 +0100
Hans Verkuil <hverkuil@xs4all.nl> wrote:

> On Saturday 14 February 2009 15:05:14 Andy Walls wrote:
> > On Sat, 2009-02-14 at 12:06 +0100, Hans Verkuil wrote:
> > > On Saturday 14 February 2009 11:32:06 Mauro Carvalho Chehab wrote:
> > > > On Sat, 14 Feb 2009 10:08:31 +0100
> > > >
> > > > Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > > > > On Saturday 14 February 2009 09:52:06 Mauro Carvalho Chehab wrote:
> > > > > > On Fri, 13 Feb 2009 13:57:45 +0100
> > > > > >
> > > > > > Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > > > > > > Hi Hans,
> > > > > > >
> > > > > > > I've developed a converter for the HM12 format (produced by
> > > > > > > Conexant MPEG encoders as used in the ivtv and cx18 drivers).
> > > > > > >
> > > > > > > But libv4l2 has a problem in its implementation of v4l2_read:
> > > > > > > it assumes that the driver can always do streaming. However,
> > > > > > > that is not the case for some drivers, including cx18 and ivtv.
> > > > > > > These drivers only implement read() functionality and no
> > > > > > > streaming.
> > > >
> > > > I suspect that the only two drivers that don't support mmap() are
> > > > ivtv and cx18. All other drivers support it, including other drivers
> > > > that also provides compressed data (like jpeg webcams). In a matter
> > > > of fact, most applications work only with mmap() interface (being
> > > > mythtv and mplayer capable of supporting both read() and mmap()). So,
> > > > by providing mmap(), other applications will benefit of it.
> > > >
> > > > Also, there is a sort of chicken and egg trouble: almost nobody uses
> > > > raw formats, since it uses a non-standard format that it is not
> > > > supported by userspace apps. The libv4l2 is the proper way for
> > > > handling it, but only works with mmap().
> > >
> > > I'd be happy if libv4l2 would just check whether mmap is supported, and
> > > if not then disable adding the extra pixelformats. That's easy to do
> > > there, and would make it possible to add hm12 for use with
> > > libv4lconvert. While it would be nice from my point of view if
> > > libv4l2's read() could convert without using mmap, I have to agree that
> > > that is probably overkill.
> > >
> > > And nobody really cares about raw video with ivtv and cx18. Really.
> > > I've had perhaps 3-4 queries about this in all the years that I've been
> > > maintaining ivtv. Anyway, it will only be useful if we also add a
> > > proper alsa driver for the audio.
> > >
> > > Bottom line is: no time on my side and no pressure whatsoever from the
> > > users of cx18 and ivtv. There are also additional complications with
> > > respect to splicing the sliced VBI data into the MPEG stream that will
> > > make a videobuf conversion much more complicated than you think. It
> > > will mean a substantial and risky overhaul of the driver that requires
> > > probably weeks of work.
> > >
> > > Yes, I do want to do this, but unless someone else steps in it won't be
> > > anytime soon.
> >
> > I can convert cx18 if someone really cares, but *no one* has ever
> > directly enquired about the YUV (HM12) data from cx18.  (I think there
> > was quite a long time when it actually may not have been wokring -
> > nobody cared.)  When someone has paid the extra money for the encoder
> > hardware, raw formats are really just a nice to have.  There is cheaper
> > hardware for raw formats.
> >
> > Anyway, such a conversion to mmap and/or videobuf is very far down on my
> > TODO list.  Whatever I do for cx18 may not translate directly to usable
> > code for ivtv, the buffer handling is slightly different and simpler
> > since there's no MPEG decoder to worry about.
> >
> > Again, it's not impossible, just a matter of time and demand.  I have
> > little time and I have no demand, aside from Hans Verkuil's desire to
> > get an HM12 converter into the library.
> >
> > I haven't done any research, but I'm surprised that no other supported
> > chip offers this format.  I guess maybe that has something to do with
> > the CX23415's origins from Internext Compression Inc.
> 
> It's a macroblock format where all Y and UV bytes are organized in 8x8 
> blocks. I believe it is a by-product of the MPEG encoding process that is 
> made available by the firmware as a bonus feature. It is clearly meant as 
> the source format for the actual MPEG encoder. Pretty much specific to the 
> cx2341x devices.

Hans and Andy,

I understand that this have low priority. The only practical usage is if
someone wants to do a better encoding for some video above the limits that
cx2341x provides (for example, encoding with the same rate, but with MPEG 4, to
have a higher quality).

What I'm trying to say is that I don't see much value to change libv4l2 to
support read() method and HM12, since using read() method for a stream without
a metadata doesn't work very well (sync issues, etc), but this is just my 2 cents.

With respect with ivtv-alsa and cx18-alsa, I think that, once having the driver
ported to videobuf, it shouldn't be hard to use cx88-alsa as a reference for
writing those drivers.

About the efforts to port it, only you can evaluate it. In the case of em28xx,
once having a videobuf driver for usb, it weren't hard to port it to videobuf
(almost all troubles we had were related to the usage of a new videobuf module
- videobuf-vmalloc). The resulting code worked a way better than the original
driver and it is now easier to understand what it is doing at the videobuffers
than what it used to be.

Cheers,
Mauro
