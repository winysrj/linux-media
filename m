Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:58329 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788Ab1HXEGH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Aug 2011 00:06:07 -0400
Received: by ewy4 with SMTP id 4so328131ewy.19
        for <linux-media@vger.kernel.org>; Tue, 23 Aug 2011 21:06:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201108230831.41332.hverkuil@xs4all.nl>
References: <Pine.LNX.4.64.1108042329460.31239@axis700.grange>
 <201108221752.12950.hverkuil@xs4all.nl> <201108221921.18864.laurent.pinchart@ideasonboard.com>
 <201108230831.41332.hverkuil@xs4all.nl>
From: Pawel Osciak <pawel@osciak.com>
Date: Tue, 23 Aug 2011 21:05:44 -0700
Message-ID: <CAMm-=zCvnyx6vCuyVdastax6At=ffXw2a9agFk2ek4g6dFJ3NQ@mail.gmail.com>
Subject: Re: [PATCH 1/6 v4] V4L: add two new ioctl()s for multi-size
 videobuffer management
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hansverk@cisco.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Mon, Aug 22, 2011 at 23:31, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On Monday, August 22, 2011 19:21:18 Laurent Pinchart wrote:
>> Hi Hans,
>>
>> On Monday 22 August 2011 17:52:12 Hans Verkuil wrote:
>> > On Monday, August 22, 2011 17:42:36 Laurent Pinchart wrote:
>> > > On Monday 22 August 2011 15:54:03 Guennadi Liakhovetski wrote:
>> > > > We discussed a bit more with Hans on IRC, and below is my attempt of a
>> > > > summary. Hans, please, correct me, if I misunderstood anything. Pawel,
>> > > > Sakari, Laurent: please, reply, whether you're ok with this.
>> > >
>> > > Sakari is on holidays this week.
>> > >
>> > > > On Mon, 22 Aug 2011, Hans Verkuil wrote:
>> > > > > On Monday, August 22, 2011 12:40:25 Guennadi Liakhovetski wrote:
>> > > > [snip]
>> > > >
>> > > > > > It would be good if you also could have a look at my reply to this
>> > > > > > Pawel's mail:
>> > > > > >
>> > > > > > http://article.gmane.org/gmane.linux.drivers.video-input-
>> > > > >
>> > > > > infrastructure/36905
>> > > > >
>> > > > > > and, specifically, at the vb2_parse_planes() function in it. That's
>> > > > > > my understanding of what would be needed, if we preserve
>> > > > > > .queue_setup() and use your last suggestion to include struct
>> > > > > > v4l2_format in struct v4l2_create_buffers.
>> > > > >
>> > > > > vb2_parse_planes can be useful as a utility function that 'normal'
>> > > > > drivers can call from the queue_setup. But vb2 should not parse the
>> > > > > format directly, it should just pass it on to the driver through the
>> > > > > queue_setup function.
>> > > > >
>> > > > > You also mention: "All frame-format fields like fourcc code, width,
>> > > > > height, colorspace are only input from the user. If the user didn't
>> > > > > fill them in, they should not be used."
>> > > > >
>> > > > > I disagree with that. The user should fill in a full format
>> > > > > description, just as with S/TRY_FMT. That's the information that the
>> > > > > driver will use to set up the buffers. It could have weird rules
>> > > > > like: if the fourcc is this, and the size is less than that, then we
>> > > > > can allocate in this memory bank.
>> > > > >
>> > > > > It is also consistent with REQBUFS: there too the driver uses a full
>> > > > > format (i.e. the last set format).
>> > > > >
>> > > > > I would modify queue_setup to something like this:
>> > > > >
>> > > > > int (*queue_setup)(struct vb2_queue *q, struct v4l2_format *fmt,
>> > > > >
>> > > > >                      unsigned int *num_buffers,
>> > > > >                      unsigned int *num_planes, unsigned int sizes[],
>> > > > >                      void *alloc_ctxs[]);
>> > > > >
>> > > > > Whether fmt is left to NULL in the reqbufs case, or whether the
>> > > > > driver has to call g_fmt first before calling vb2 is something that
>> > > > > could be decided by what is easiest to implement.
>> > > >
>> > > > 1. VIDIOC_CREATE_BUFS passes struct v4l2_create_buffers from the user
>> > > > to
>> > > >
>> > > >    the kernel, in which struct v4l2_format is embedded. The user _must_
>> > > >    fill in .type member of struct v4l2_format. For .type ==
>> > > >    V4L2_BUF_TYPE_VIDEO_CAPTURE or V4L2_BUF_TYPE_VIDEO_OUTPUT .fmt.pix
>> > > >    is used, for .type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE or
>> > > >    V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE .fmt.pix_mp is used. In both these
>> > > >    cases the user _must_ fill in .width, .height, .pixelformat, .field,
>> > > >    .colorspace by possibly calling VIDIOC_G_FMT or VIDIOC_TRY_FMT. The
>> > > >    user also _may_ optionally fill in any further buffer-size related
>> > > >    fields, if it believes to have any special requirements to them. On
>> > > >    a successful return from the ioctl() .count and .index fields are
>> > > >    filled in by the kernel, .format stays unchanged. The user has to
>> > > >    call VIDIOC_QUERYBUF to retrieve specific buffer information.
>> > > >

Sounds good, just one question: we deliberately don't want to allow
CREATE_BUFS to adjust the format in any way, as S_FMT could?

>> > > > 2. Videobuf2 drivers, that implement .vidioc_create_bufs() operation,
>> > > > call
>> > > >
>> > > >    vb2_create_bufs() with a pointer to struct v4l2_create_buffers as a
>> > > >    second argument. vb2_create_bufs() in turn calls the .queue_setup()
>> > > >
>> > > >    driver callback, whose prototype is modified as follows:
>> > > > int (*queue_setup)(struct vb2_queue *q, const struct v4l2_format *fmt,
>> > > >
>> > > >                         unsigned int *num_buffers,
>> > > >                         unsigned int *num_planes, unsigned int sizes[],
>> > > >                         void *alloc_ctxs[]);
>> > > >
>> > > >    with &create->format as a second argument. As pointed out above,
>> > > >    this struct is not modified by V4L, instead, the usual arguments
>> > > >    3-6 are filled in by the driver, which are then used by
>> > > >    vb2_create_bufs() to call __vb2_queue_alloc().
>> > > >
>> > > > 3. vb2_reqbufs() shall call .queue_setup() with fmt == NULL, which will
>> > > > be
>> > > >
>> > > >    a signal to the driver to use the current format.
>> > > >
>> > > > 4. We keep .queue_setup(), because its removal would inevitably push a
>> > > >
>> > > >    part of the common code from vb2_reqbufs() and vb2_create_bufs()
>> > > >    down into drivers, thus creating code redundancy and increasing its
>> > > >    complexity.
>> > >

What part would be passed down to drivers? Please see my example
below. I actually feel the drivers would become slightly simpler with
this change.

>> > > How much common code would be pushed down to drivers ? I don't think this
>> > > is a real issue. I like Pawel's proposal of removing .queue_setup()
>> > > better.
>> >
>> > I still don't see what removing queue_setup will solve or improve.
>>
>> It will remove handling of the format in vb2 (even if it's a pass-through
>> operation). I think it would be cleaner that way. It will also avoid going
>> back and forth between drivers and vb2, which would improve code readability.
>
> I very much doubt it will be more readable or cleaner. For one thing it is
> inconsistent with the other ioctl ops where you just call a vb2 function to
> handle it. Suddenly here you have to do lots of things to make it work.
>

This flow:

REQBUFS->driver_reqbufs()->vb2_reqbufs()->queue_setup(fmt=NULL, nums,
sizes)->vb2_reqbufs->driver_reqbufs
CREATE_BUFS->driver_create_bufs()->vb2_create_bufs(fmt)->queue_setup(fmt,
nums, sizes)->vb2_create_bufs->driver_create_bufs

is more complicated than this flow:

REQBUFS->driver_reqbufs()->vb2_reqbufs(nums, sizes)->driver_reqbufs
CREATE_BUFS->driver_create_bufs()->vb2_create_bufs(nums,
sizes)->driver_create_bufs

without giving any clear advantage (at least from what I can see),
apart from making Guennadi's change simpler.


Below is what I'm proposing. This, in my opinion, makes vb2's
interface cleaner, as the format is never passed to it. I don't see
what code it'd be passing down to drivers. The goal is to pass
(return) nums/sizes to vb2 anyway. Existing queue_setup() could with
some modifications become figure_out_params():

driver_create_bufs(create) /* optional */
{
   /* use create->fmt to figure out num_* and *_sizes */
   figure_out_params(create->fmt, &num_buffers, &num_planes,
&buf_sizes, &plane_sizes);
   return vb2_create_bufs(num_buffers, num_planes, buf_sizes,
plane_sizes, alloc_ctxs);
}

driver_reqbufs()
{
   /* use current format to figure out num_* and *_sizes */
   figure_out_params(current_fmt, &num_buffers, &num_planes,
&buf_sizes, &plane_sizes);
   return vb2_reqbufs(num_buffers, num_planes, buf_sizes, plane_sizes,
alloc_ctxs);
}

/* ---------- */

vb2_reqbufs(num_buffers, num_planes, buf_sizes, plane_sizes, alloc_ctxs)
{
   if (buffers_allocated)
       free_buffers(...);

   return vb2_create_bufs(num_buffers, num_planes, buf_sizes,
plane_sizes, alloc_ctxs);
}

>> > I'd say leave it as it is to keep the diff as small as possible and someone
>> > can always attempt to remove it later. Removing queue_setup is independent
>> > from multi-size videobuffer management and we should not mix the two.
>>
>> Guennadi's patch will (at least in my opinion) be cleaner if built on top of
>> queue_setup() removal.
>
> Really? Just adding a single v4l2_format pointer is less clean than removing
> queue_setup? That would really surprise me.
> Anyway, let Guennadi choose what is easiest. It's an implementation detail in
> the end and I just want to get this functionality in.

I'm not completely opposed to your last suggestion. I agree the patch
would be much shorter. Your proposal is reasonable and simple enough.
I just feel that it'd pay off to put a little bit more effort to make
the changes I'm proposing, to make the interface cleaner and simplify
ping-ponging calls and parameters between drivers and vb2.

But I don't mind if we make it simple for now. As you suggested, I'll
be more than happy to look into removing queue_setup later.

-- 
Best regards,
Pawel Osciak
