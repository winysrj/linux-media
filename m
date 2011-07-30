Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:1692 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142Ab1G3NwR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 30 Jul 2011 09:52:17 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Pawel Osciak <pawel@osciak.com>
Subject: Re: [PATCH v3] V4L: add two new ioctl()s for multi-size videobuffer management
Date: Sat, 30 Jul 2011 15:50:53 +0200
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
References: <Pine.LNX.4.64.1107201025120.12084@axis700.grange> <201107280856.55731.hverkuil@xs4all.nl> <CAMm-=zCU1B1zXNK7hp_B8hAW0YfcrN9V8M_uSDva8TbXL2AKbQ@mail.gmail.com>
In-Reply-To: <CAMm-=zCU1B1zXNK7hp_B8hAW0YfcrN9V8M_uSDva8TbXL2AKbQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107301550.53638.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday, July 30, 2011 06:21:37 Pawel Osciak wrote:
> Hi Hans,
> 
> On Wed, Jul 27, 2011 at 23:56, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > On Thursday, July 28, 2011 06:11:38 Pawel Osciak wrote:
> >> Hi Guennadi,
> >>
> >> On Wed, Jul 20, 2011 at 01:43, Guennadi Liakhovetski
> >> <g.liakhovetski@gmx.de> wrote:
> >> > A possibility to preallocate and initialise buffers of different sizes
> >> > in V4L2 is required for an efficient implementation of asnapshot mode.
> >> > This patch adds two new ioctl()s: VIDIOC_CREATE_BUFS and
> >> > VIDIOC_PREPARE_BUF and defines respective data structures.
> >> >
> >> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> >> > ---
> >> >
> >> <snip>
> >>
> >> This looks nicer, I like how we got rid of destroy and gave up on
> >> making holes, it would've given us a lot of headaches. I'm thinking
> >> about some issues though and also have some comments/questions further
> >> below.
> >>
> >> Already mentioned by others mixing of REQBUFS and CREATE_BUFS.
> >> Personally I'd like to allow mixing, including REQBUFS for non-zero,
> >> because I think it would be easy to do. I think it could work in the
> >> same way as REQBUFS for !=0 works currently (at least in vb2), if we
> >> already have some buffers allocated and they are not in use, we free
> >> them and a new set is allocated. So I guess it could just stay this
> >> way. REQBUFS(0) would of course free everything.
> >>
> >> Passing format to CREATE_BUFS will make vb2 a bit format-aware, as it
> >> would have to pass it forward to the driver somehow. The obvious way
> >> would be just vb2 calling the driver's s_fmt handler, but that won't
> >> work, as you can't pass indexes to s_fmt. So we'd have to implement a
> >> new driver callback for setting formats per index. I guess there is no
> >> way around it, unless we actually take the format struct out of
> >> CREATE_BUFS and somehow do it via S_FMT. The single-planar structure
> >> is full already though, the only way would be to use
> >> v4l2_pix_format_mplane instead with plane count = 1 (or more if
> >> needed).
> >
> > I just got an idea for this: use TRY_FMT. That will do exactly what
> > you want. In fact, perhaps we should remove the format struct from
> > CREATE_BUFS and use __u32 sizes[VIDEO_MAX_PLANES] instead. Let the
> > application call TRY_FMT and initialize the sizes array instead of
> > putting that into vb2. We may need a num_planes field as well. If the
> > sizes are all 0 (or num_planes is 0), then the driver can use the current
> > format, just as it does with REQBUFS.
> >
> > Or am I missing something?
> >
> 
> I'm not sure I'm following. Could you give a usage example? Do you
> mean we want the application to:
> - SET_FMT and REQBUFS for normal buffers
> - TRY_FMT and CREATE_BUFS for additional buffers?

Right.

> 
> I'm still not clear how would driver know for which set of buffers the
> *_FMT is being called... I'm pretty sure I'm misunderstanding your
> idea though...

S_FMT programs the pipeline. It is up to the application to ensure that the
buffers queued to the DMA engine are big enough to handle it (and up to the
driver to reject buffers if they are too small).

REQBUFS just calculates the size of the mmap buffers based on the current format.
This is very limiting in certain situations. With CREATE_BUFS I would prefer
being more flexible and let the application determine the buffer sizes, possibly
based on what TRY_FMT returns.

> >> Another thing is the case of passing size to CREATE_BUFS. vb2, when
> >> allocating buffers, gets their sizes from the driver (via
> >> queue_setup), it never "suggest" any particular size. So that flow
> >> would have to be changed as well. I guess vb2 could pass the size to
> >> queue_setup in a similar way as it does with buffer count. This would
> >> mean though that the ioctl would fail if the driver didn't agree to
> >> the given size. Right now I don't see an option to "negotiate" the
> >> size with the driver via this option.
> >
> > I think the driver can always increase the size if needed and return the
> > new size.
> >
> 
> Right, this can easily be done in vb2. But if we do that, it will
> introduce asymmetry with REQBUFS. For SET_FMT/TRY_FMT+REQBUFS the
> driver would only be able to adjust buffer sizes on *_FMT, while with
> *_FMT+CREATE_BUFS it could do that for both calls. Why do we need an
> additional chance to adjust? Or am I misunderstanding your suggestion?

I don't really understand your question. With REQBUFS the size used to allocate
the mmap buffers is derived from the current format by the driver. You have no
chance to change that for the V4L2_MEMORY_MMAP buffers. It would be much more
flexible if you let the application set up the buffer size(s). The application
can always call TRY_FMT (or G_FMT) to learn the buffer size and fill it in for
CREATE_BUFS.
 
> >>
> >> The more I think of it though, why do we need the size argument? It's
> >> not needed in the existing flows (that use S_FMT) and, more
> >> importantly, I don't think the application can know more than the
> >> driver can, so why giving that option? The driver should know the size
> >> for a format at least as well as the application... Also, is there a
> >> real use case of providing just size, will the driver know which
> >> format to use given a size?
> >
> > There are cases where you want a larger buffer size than the format
> > really required. The most common case being 1920x1080 formats where you
> > want to capture in a 1920x1088 buffer (since 1088 is a multiple of 16
> > and is more suitable for MPEG et al encoding).
> >
> > So, yes, you do want the option to set the size explicitly.
> 
> Yes, that's true, but my point is in the current API it works too,
> because the driver can adjust the size on TRY/S_FMT. Even though the
> application knows that 1088 is needed instead of 1080, shouldn't the
> driver know it as well (or actually, know even better than the app)
> and be able to adjust?

The driver will of course adjust it if hardware limitations require it.
But it shouldn't make assumptions on how the buffer is going to be used.
To take this example: an application that will just capture 1920x1080 and
output it on another HDMI output without any encoding doesn't need 1088.
But if it is fed to an encoder, then selecting 1088 as size is very useful.
Perhaps the application would also like to record meta data after the
picture, thus requiring an even larger size.

> So when we CREATE_BUFS, the driver can adjust
> the format struct (or if we somehow use *_FMT for CREATE_BUFS buffers,
> it could adjust the size there). Sorry, I still can't see why we need
> an explicit size argument...

The size is what vb2 needs. It shouldn't care about the format. The format
is only used one time to calculate the sizes. By moving that to the application
you allow the application to modify sizes as needed.

Suppose we pass in the format to CREATE_BUFS as originally proposed. What
would happen is that vb2 would probably call TRY_FMT and use the returned
imagesize(s) to fill in the vb2 internals. And the application would have
no way of changing those.

> 
> <snip>
> 
> >>
> >> I'm probably forgetting something, but why would we want to do both
> >> PREPARE_BUF and QBUF? Why not queue in advance?
> >
> > QBUF both prepares the buffer and makes it available for use with DMA. You don't want
> > that. You just want to prepare it (that's the part that is expensive) and postpone
> > the actual queuing until the buffer is needed to e.g. take a snapshot.
> 
> Just to confirm I understood correctly: we don't want to QBUF, because
> then it'd would immediately be used and we want to time when it is to
> be used? 

Right.

> So when the driver sees a larger buffer being queued, it is
> to change the current streaming format for the duration of filling
> that buffer and switch back afterwards?

No. We do not have a mechanism (yet) to tie a pipeline configuration to
a queued buffer (to be discussed in next week in Cambourne).

It is my understanding that you change the current streaming format, and
then queue the large (prepared) buffer and switch back afterwards.

Somebody please correct me if I am wrong.

Regards,

	Hans
