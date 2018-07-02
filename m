Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:45522 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752208AbeGBNXa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 2 Jul 2018 09:23:30 -0400
Subject: Re: [PATCHv15 07/35] v4l2-dev: lock req_queue_mutex
To: Tomasz Figa <tfiga@chromium.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
References: <20180604114648.26159-1-hverkuil@xs4all.nl>
 <20180604114648.26159-8-hverkuil@xs4all.nl>
 <CAAFQd5B3QZKucU-dLBe-XKWSB3oObuRO6frycxr2e=AkkvrWLA@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <7fd62f10-0aaa-808b-9048-5dd51fe35f6c@xs4all.nl>
Date: Mon, 2 Jul 2018 15:23:27 +0200
MIME-Version: 1.0
In-Reply-To: <CAAFQd5B3QZKucU-dLBe-XKWSB3oObuRO6frycxr2e=AkkvrWLA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/07/18 15:06, Tomasz Figa wrote:
> Hi Hans,
> 
> On Mon, Jun 4, 2018 at 8:48 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
> [snip]
>> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
>> index 965fd301f617..27a893aa0664 100644
>> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
>> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
>> @@ -2714,6 +2714,7 @@ static long __video_do_ioctl(struct file *file,
>>                 unsigned int cmd, void *arg)
>>  {
>>         struct video_device *vfd = video_devdata(file);
>> +       struct mutex *req_queue_lock = NULL;
>>         struct mutex *lock; /* ioctl serialization mutex */
>>         const struct v4l2_ioctl_ops *ops = vfd->ioctl_ops;
>>         bool write_only = false;
>> @@ -2733,10 +2734,27 @@ static long __video_do_ioctl(struct file *file,
>>         if (test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags))
>>                 vfh = file->private_data;
>>
>> +       /*
>> +        * We need to serialize streamon/off with queueing new requests.
>> +        * These ioctls may trigger the cancellation of a streaming
>> +        * operation, and that should not be mixed with queueing a new
>> +        * request at the same time.
>> +        */
>> +       if (v4l2_device_supports_requests(vfd->v4l2_dev) &&
>> +           (cmd == VIDIOC_STREAMON || cmd == VIDIOC_STREAMOFF)) {
> 
> Are STREAMON and STREAMOFF the only ioctls we need to acquire
> req_queue_lock for? How about a race with, for example, S_CTRL(control
> X, request_fd = -1) and req_validate() on a request that depends on
> the value of control X? Maybe we should just lock here for any ioctl?

Definitely not, that would seriously impact performance since this is such
a high-level lock.

It is indeed possible to set controls directly even if the same control is
also used in a request. It is intentional that you can still set controls
directly: for some controls (e.g. POWERLINE frequency) it makes no sense to
use them in a request and you just want to be able to set them directly. It
is also very useful for debugging. So even though it can potentially mess
things up, it is practical to allow this.

Drivers need to be able to handle such situations anyway since setting
controls from a request can fail regardless due to HW errors of some kind,
so a control might not have the value that you expected.

And worse case there will only be a wrong control value until a request is
applied containing a new value of this control.

It might be that in the future we need to restrict this for selected controls
in some manner, but for now I think this is fine.

Note that this is different for buffers: once you've switched to using requests
to queue buffers, you can no longer queue a buffer directly. Mixing that is
theoretically possible, but it is very confusing.

> 
>> +               req_queue_lock = &vfd->v4l2_dev->mdev->req_queue_mutex;
>> +
>> +               if (req_queue_lock && mutex_lock_interruptible(req_queue_lock))
> 
> I believe it isn't possible for req_queue_lock to be NULL here.

True, I can remove that test.

Regards,

	Hans

> 
>> +                       return -ERESTARTSYS;
> 
> I guess it isn't really possible for mutex_lock_interruptible() to
> return anything non-zero other than this, but I'd still return what it
> returns here just in case.
