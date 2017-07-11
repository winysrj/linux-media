Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:35266 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755511AbdGKM4d (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Jul 2017 08:56:33 -0400
Received: by mail-qk0-f194.google.com with SMTP id 16so17338430qkg.2
        for <linux-media@vger.kernel.org>; Tue, 11 Jul 2017 05:56:32 -0700 (PDT)
Date: Tue, 11 Jul 2017 09:56:26 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: Re: [PATCH 03/12] [media] vb2: add in-fence support to QBUF
Message-ID: <20170711125626.GN10284@jade>
References: <20170616073915.5027-1-gustavo@padovan.org>
 <20170616073915.5027-4-gustavo@padovan.org>
 <ae203289-11cc-d5a5-0ce6-a8fbbc4742af@xs4all.nl>
 <20170707020028.GE10284@jade>
 <25827205-94f3-3a2f-c65a-4ae120288f00@xs4all.nl>
 <20170710190244.GF10284@jade>
 <20170710202656.GM10284@jade>
 <62670305-3d18-aba8-aa2d-2aa2e6755699@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62670305-3d18-aba8-aa2d-2aa2e6755699@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2017-07-11 Hans Verkuil <hverkuil@xs4all.nl>:

> On 10/07/17 22:26, Gustavo Padovan wrote:
> > 2017-07-10 Gustavo Padovan <gustavo@padovan.org>:
> > 
> >> 2017-07-07 Hans Verkuil <hverkuil@xs4all.nl>:
> >>
> >>> On 07/07/2017 04:00 AM, Gustavo Padovan wrote:
> >>>> 2017-07-06 Hans Verkuil <hverkuil@xs4all.nl>:
> >>>>
> >>>>> On 06/16/17 09:39, Gustavo Padovan wrote:
> >>>>>> From: Gustavo Padovan <gustavo.padovan@collabora.com>
> >>>>>>
> >>>>>> Receive in-fence from userspace and add support for waiting on them
> >>>>>> before queueing the buffer to the driver. Buffers are only queued
> >>>>>> to the driver once they are ready. A buffer is ready when its
> >>>>>> in-fence signals.
> >>>>>>
> >>>>>> v2:
> >>>>>> 	- fix vb2_queue_or_prepare_buf() ret check
> >>>>>> 	- remove check for VB2_MEMORY_DMABUF only (Javier)
> >>>>>> 	- check num of ready buffers to start streaming
> >>>>>> 	- when queueing, start from the first ready buffer
> >>>>>> 	- handle queue cancel
> >>>>>>
> >>>>>> Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
> >>>>>> ---
> >>>>>>   drivers/media/Kconfig                    |  1 +
> >>>>>>   drivers/media/v4l2-core/videobuf2-core.c | 97 +++++++++++++++++++++++++-------
> >>>>>>   drivers/media/v4l2-core/videobuf2-v4l2.c | 15 ++++-
> >>>>>>   include/media/videobuf2-core.h           |  7 ++-
> >>>>>>   4 files changed, 99 insertions(+), 21 deletions(-)
> >>>>>>
> >>>>>
> >>>>> <snip>
> >>>>>
> >>>>>> diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c b/drivers/media/v4l2-core/videobuf2-v4l2.c
> >>>>>> index 110fb45..e6ad77f 100644
> >>>>>> --- a/drivers/media/v4l2-core/videobuf2-v4l2.c
> >>>>>> +++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
> >>>>>> @@ -23,6 +23,7 @@
> >>>>>>   #include <linux/sched.h>
> >>>>>>   #include <linux/freezer.h>
> >>>>>>   #include <linux/kthread.h>
> >>>>>> +#include <linux/sync_file.h>
> >>>>>>   #include <media/v4l2-dev.h>
> >>>>>>   #include <media/v4l2-fh.h>
> >>>>>> @@ -560,6 +561,7 @@ EXPORT_SYMBOL_GPL(vb2_create_bufs);
> >>>>>>   int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
> >>>>>>   {
> >>>>>> +	struct dma_fence *fence = NULL;
> >>>>>>   	int ret;
> >>>>>>   	if (vb2_fileio_is_active(q)) {
> >>>>>> @@ -568,7 +570,18 @@ int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
> >>>>>>   	}
> >>>>>>   	ret = vb2_queue_or_prepare_buf(q, b, "qbuf");
> >>>>>> -	return ret ? ret : vb2_core_qbuf(q, b->index, b);
> >>>>>> +	if (ret)
> >>>>>> +		return ret;
> >>>>>> +
> >>>>>> +	if (b->flags & V4L2_BUF_FLAG_IN_FENCE) {
> >>>>>> +		fence = sync_file_get_fence(b->fence_fd);
> >>>>>> +		if (!fence) {
> >>>>>> +			dprintk(1, "failed to get in-fence from fd\n");
> >>>>>> +			return -EINVAL;
> >>>>>> +		}
> >>>>>> +	}
> >>>>>> +
> >>>>>> +	return ret ? ret : vb2_core_qbuf(q, b->index, b, fence);
> >>>>>>   }
> >>>>>>   EXPORT_SYMBOL_GPL(vb2_qbuf);
> >>>>>
> >>>>> You need to adapt __fill_v4l2_buffer so it sets the IN_FENCE buffer flag
> >>>>> if there is a fence pending. It should also fill in fence_fd.
> >>>>
> >>>> It was userspace who sent the fence_fd in the first place. Why do we
> >>>> need to send it back? The initial plan was - from a userspace point of view
> >>>> - to send the in-fence in the fence_fd field and receive the out-fence
> >>>>   in the same field.
> >>>>
> >>>> As per setting the IN_FENCE flag, that is racy, as the fence can signal
> >>>> just after we called __fill_v4l2_buffer. Why is it important to set it?
> >>>
> >>> Because when running VIDIOC_QUERYBUF it should return the current state of
> >>> the buffer, including whether it has a fence. You can do something like
> >>> v4l2-ctl --list-buffers to see how many buffers are queued up and the state
> >>> of each buffer. Can be useful to e.g. figure out why a video capture seems
> >>> to stall. Knowing that all queued buffers are all waiting for a fence is
> >>> very useful information. Whether the fence_fd should also be set here or
> >>> only in dqbuf is something I don't know (not enough knowledge about how
> >>> fences are supposed to work). The IN/OUT_FENCE flags should definitely be
> >>> reported though.
> >>
> >> I didn't know about this usecase. Thanks for explaining. It certainly
> >> makes sense to set the IN/OUT_FENCE flags here. Regarding the fence_fd
> >> I would expect the application to know the fence fd associated to than
> >> buffer. If we expect an application other than the one which issued
> >> QBUF than I'd say we also need to provide the fd on VIDIOC_QUERYBUF
> >> for inspection purposes. Is that the case?
> > 
> > I just realized that if we want to also set the in-fence fd here we
> > actually need to get a new unused fd, as either it is a different pid or
> > the app already closed the fd it was using previously. Given this extra
> > complication I'd say we shouldn't set fence fd unless someone has an
> > usecase in mind.
> 
> Fair enough. Just make sure the fence_fd is some fixed value (-1?) in
> that case.

Sure. -1 is the default value for these cases.

	Gustavo
