Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:42438 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932653AbaJ2Mkk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Oct 2014 08:40:40 -0400
Date: Wed, 29 Oct 2014 10:40:33 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Divneil Wadhawan <divneil.wadhawan@st.com>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH] vb2: replace VIDEO_MAX_FRAME with VB2_MAX_FRAME
Message-ID: <20141029104033.35f0d212@recife.lan>
In-Reply-To: <5450BAF4.6050008@xs4all.nl>
References: <5437932A.7000706@xs4all.nl>
	<20141028162647.43c1946a@recife.lan>
	<54509744.7090005@xs4all.nl>
	<20141029062952.05e47989@recife.lan>
	<5450AC8C.4090603@xs4all.nl>
	<20141029071312.08aef860@recife.lan>
	<5450BAF4.6050008@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 29 Oct 2014 11:01:24 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 10/29/14 10:13, Mauro Carvalho Chehab wrote:
> > Em Wed, 29 Oct 2014 09:59:56 +0100
> > Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> > 
> >> On 10/29/14 09:29, Mauro Carvalho Chehab wrote:
> >>> Em Wed, 29 Oct 2014 08:29:08 +0100
> >>> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> >>>
> >>>> On 10/28/2014 07:26 PM, Mauro Carvalho Chehab wrote:
> >>>>> Em Fri, 10 Oct 2014 10:04:58 +0200
> >>>>> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> >>>>>
> >>>>>> (This patch is from Divneil except for the vivid changes which I added. He had
> >>>>>> difficulties posting the patch without the mailer mangling it, so I'm reposting
> >>>>>> it for him)
> >>>>>>
> >>>>>> - vb2 drivers to rely on VB2_MAX_FRAME.
> >>>>>>
> >>>>>> - VB2_MAX_FRAME bumps the value to 64 from current 32
> >>>>>
> >>>>> Hmm... what's the point of announcing a maximum of 32 buffers to userspace,
> >>>>> but using internally 64?
> >>>>
> >>>> Where do we announce 32 buffers?
> >>>
> >>> VIDEO_MAX_FRAME is defined at videodev2.h:
> >>>
> >>> include/uapi/linux/videodev2.h:#define VIDEO_MAX_FRAME               32
> >>>
> >>> So, it is part of userspace API. Yeah, I know, it sucks, but apps
> >>> may be using it to limit the max number of buffers.
> >>
> >> So? Userspace is free to ask for 32 buffers, and it will get 32 buffers if
> >> memory allows. vb2 won't be returning more than 32, so I don't see how things
> >> can break.
> > 
> > Well, VIDEO_MAX_FRAME has nothing to do with the max VB1 support. It is
> > the maximum number of buffers supported by V4L2. Properly-written apps
> > will never request more than 32 buffers, because we're telling them that
> > this is not supported.
> > 
> > So, it makes no sense to change internally to 64, but keeping announcing
> > that the maximum is 32. We're just wasting memory inside the Kernel with
> > no reason.
> 
> Hmm, so you think VIDEO_MAX_FRAME should just be updated to 64?

Yes.

> I am a bit afraid that that might break applications (especially if there
> are any that use bits in a 32-bit unsigned variable).

What 32-bits have to do with that? This is just the maximum number of
buffers, and not the number of bits.

> Should userspace
> know about this at all? I think that the maximum number of frames is
> driver dependent, and in fact one of the future vb2 improvements would be
> to stop hardcoding this and leave the maximum up to the driver.

It is not driver dependent. It basically depends on the streaming logic.
Both VB and VB2 are free to set whatever size it is needed. They can
even change the logic to use a linked list, to avoid pre-allocating
anything.

Ok, there's actually a hardware limit, with is the maximum amount of
memory that could be used for DMA on a given hardware/architecture.

The 32 limit was just a random number that was chosen. Actually,
with V4L1 API, one struct were relying on it:

^1da177e4c3f4 (Linus Torvalds        2005-04-16 15:20:36 -0700 264) #define VIDEO_MAX_FRAME             32
^1da177e4c3f4 (Linus Torvalds        2005-04-16 15:20:36 -0700 265) 
^1da177e4c3f4 (Linus Torvalds        2005-04-16 15:20:36 -0700 266) struct video_mbuf
^1da177e4c3f4 (Linus Torvalds        2005-04-16 15:20:36 -0700 267) {
^1da177e4c3f4 (Linus Torvalds        2005-04-16 15:20:36 -0700 268)     int     size;           /* Total memory to map */
^1da177e4c3f4 (Linus Torvalds        2005-04-16 15:20:36 -0700 269)     int     frames;         /* Frames */
^1da177e4c3f4 (Linus Torvalds        2005-04-16 15:20:36 -0700 270)     int     offsets[VIDEO_MAX_FRAME];
^1da177e4c3f4 (Linus Torvalds        2005-04-16 15:20:36 -0700 271) };

But, for V4L2, this is just a number that can be used by apps when
then want to get the biggest number of buffers that the Kernel
supports.

> Basically I would like to deprecate VIDEO_MAX_FRAME.

As usual, this requires to first fix all applications that use it,
give a few years for them to stop using it. Then, it can be removed.

If you want to do so, you should start with v4l-utils:

$ git grep VIDEO_MAX_FRAME
contrib/freebsd/include/linux/videodev2.h:#define VIDEO_MAX_FRAME               32
include/linux/videodev2.h:#define VIDEO_MAX_FRAME               32
utils/v4l2-compliance/v4l-helpers.h:    __u32 mem_offsets[VIDEO_MAX_FRAME][VIDEO_MAX_PLANES];
utils/v4l2-compliance/v4l-helpers.h:    void *mmappings[VIDEO_MAX_FRAME][VIDEO_MAX_PLANES];
utils/v4l2-compliance/v4l-helpers.h:    unsigned long userptrs[VIDEO_MAX_FRAME][VIDEO_MAX_PLANES];
utils/v4l2-compliance/v4l-helpers.h:    int fds[VIDEO_MAX_FRAME][VIDEO_MAX_PLANES];
utils/v4l2-compliance/v4l-helpers.h:    for (i = 0; i < VIDEO_MAX_FRAME; i++)
utils/v4l2-compliance/v4l2-test-buffers.cpp:    fail_on_test(g_index() >= VIDEO_MAX_FRAME);
utils/v4l2-compliance/v4l2-test-buffers.cpp:                    buf.s_index(buf.g_index() + VIDEO_MAX_FRAME);
utils/v4l2-compliance/v4l2-test-buffers.cpp:                    buf.s_index(buf.g_index() - VIDEO_MAX_FRAME);
utils/v4l2-compliance/v4l2-test-formats.cpp:            fail_on_test(cap->readbuffers > VIDEO_MAX_FRAME);
utils/v4l2-compliance/v4l2-test-formats.cpp:            fail_on_test(out->writebuffers > VIDEO_MAX_FRAME);
utils/v4l2-ctl/v4l2-ctl-streaming.cpp:  for (i = 0; i < VIDEO_MAX_FRAME; i++) {
utils/v4l2-ctl/v4l2-ctl-streaming.cpp:          for (int i = 0; i < VIDEO_MAX_FRAME; i++)
utils/v4l2-ctl/v4l2-ctl-streaming.cpp:          for (int i = 0; i < VIDEO_MAX_FRAME; i++)
utils/v4l2-ctl/v4l2-ctl-streaming.cpp:  struct v4l2_plane planes[VIDEO_MAX_FRAME][VIDEO_MAX_PLANES];
utils/v4l2-ctl/v4l2-ctl-streaming.cpp:  void *bufs[VIDEO_MAX_FRAME][VIDEO_MAX_PLANES];
utils/v4l2-ctl/v4l2-ctl-streaming.cpp:  int fds[VIDEO_MAX_FRAME][VIDEO_MAX_PLANES];

Regards,
Mauro
