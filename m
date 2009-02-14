Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:3485 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbZBNLGa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Feb 2009 06:06:30 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: libv4l2 library problem
Date: Sat, 14 Feb 2009 12:06:27 +0100
Cc: linux-media@vger.kernel.org, Hans de Goede <j.w.r.degoede@hhs.nl>
References: <200902131357.46279.hverkuil@xs4all.nl> <200902141008.31748.hverkuil@xs4all.nl> <20090214083206.665561f6@pedra.chehab.org>
In-Reply-To: <20090214083206.665561f6@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902141206.28036.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 14 February 2009 11:32:06 Mauro Carvalho Chehab wrote:
> On Sat, 14 Feb 2009 10:08:31 +0100
>
> Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > On Saturday 14 February 2009 09:52:06 Mauro Carvalho Chehab wrote:
> > > On Fri, 13 Feb 2009 13:57:45 +0100
> > >
> > > Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > > > Hi Hans,
> > > >
> > > > I've developed a converter for the HM12 format (produced by
> > > > Conexant MPEG encoders as used in the ivtv and cx18 drivers).
> > > >
> > > > But libv4l2 has a problem in its implementation of v4l2_read: it
> > > > assumes that the driver can always do streaming. However, that is
> > > > not the case for some drivers, including cx18 and ivtv. These
> > > > drivers only implement read() functionality and no streaming.
> > > >
> > > > Can you as a minimum modify libv4l2 so that it will check for this
> > > > case? The best solution would be that libv4l2 can read HM12 from
> > > > the driver and convert it on the fly. But currently it tries to
> > > > convert HM12 by starting to stream, and that produces an error.
> > > >
> > > > This bug needs to be fixed first before I can contribute my HM12
> > > > converter.
> > >
> > > Hans Verkuil,
> > >
> > > I think it would be valuable if you could convert the drivers to use
> > > videobuf. There's currently a videobuf variation for devices that
> > > don't support scatter/gather dma transfers. By using videobuf, the
> > > mmap() methods (and also overlay, if you want) will be supported.
> >
> > It's been on my todo list for ages, but I don't see it happening
> > anytime soon. It will be difficult to do and the simple fact of the
> > matter is that the read() interface is much more suitable for MPEG
> > streams than mmap, and almost nobody is using the raw video streams
> > where mmap would make sense.
> >
> > The only reason for doing this would be to make the driver consistent
> > with the other drivers in V4L2. Which is a valid argument, but as long
> > as we still have V4L1 drivers to convert I'd argue that this is
> > definitely a low prio task.
>
> I suspect that the only two drivers that don't support mmap() are ivtv
> and cx18. All other drivers support it, including other drivers that also
> provides compressed data (like jpeg webcams). In a matter of fact, most
> applications work only with mmap() interface (being mythtv and mplayer
> capable of supporting both read() and mmap()). So, by providing mmap(),
> other applications will benefit of it.
>
> Also, there is a sort of chicken and egg trouble: almost nobody uses raw
> formats, since it uses a non-standard format that it is not supported by
> userspace apps. The libv4l2 is the proper way for handling it, but only
> works with mmap().

I'd be happy if libv4l2 would just check whether mmap is supported, and if 
not then disable adding the extra pixelformats. That's easy to do there, 
and would make it possible to add hm12 for use with libv4lconvert. While it 
would be nice from my point of view if libv4l2's read() could convert 
without using mmap, I have to agree that that is probably overkill.

And nobody really cares about raw video with ivtv and cx18. Really. I've had 
perhaps 3-4 queries about this in all the years that I've been maintaining 
ivtv. Anyway, it will only be useful if we also add a proper alsa driver 
for the audio.

Bottom line is: no time on my side and no pressure whatsoever from the users 
of cx18 and ivtv. There are also additional complications with respect to 
splicing the sliced VBI data into the MPEG stream that will make a videobuf 
conversion much more complicated than you think. It will mean a substantial 
and risky overhaul of the driver that requires probably weeks of work.

Yes, I do want to do this, but unless someone else steps in it won't be 
anytime soon.

Regards,

	Hans

> The usage of read() for raw formats is possible, but, read() method
> doesn't provide any meta-data info. For example, there's no timestamp
> that would be useful for syncing audio and video and detect frame losses.
> Also, if, for some reason, you loose a half frame, the result would be a
> disaster if you're using the read() method.
>
> So, IMO, adding read() support to libv4l2 would be just a hack and will
> likely cause more troubles than benefits. This is just my 2 cents.
>
> > BTW, it would help if someone would actually document videobuf.
> > Documentation should be much more important than it currently is.
>
> Videobuf usage is not that complicate. You just need to provide ops for
> four handlers:
>
> q->ops->buf_setup   - calculates the size of the video buffers and avoid
> they to waste more than some maximum limit of RAM;
> q->ops->buf_prepare - fills the video buffer structs and calls
> 		      videobuf_iolock() to alloc and prepare mmaped memory;
> q->ops->buf_queue   - advices the driver that another buffer were
> 		      requested (by read() or by QBUF);
> q->ops->buf_release - frees any buffer that were allocated.
>
> In order to use it, the driver need to have a code (generally called at
> interrupt context) that will properly handle the buffer request lists,
> announcing that a new buffer were filled.
>
> There are a number of videobuf methods that practically matches the video
> buffer ioctls. for example videobuf_streamon() should be called for
> streaming the video on (VIDIOC_STREAMON).
>
> The better way to understand it is to take a look at vivi driver.
>
> Anyway, I just documented it, from the driver authors POV:
> 	http://linuxtv.org/hg/v4l-dvb/rev/6f4cff0e7f16


-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
