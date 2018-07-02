Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:41901 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752349AbeGBNGX (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 2 Jul 2018 09:06:23 -0400
Received: by mail-yw0-f193.google.com with SMTP id j5-v6so6631787ywe.8
        for <linux-media@vger.kernel.org>; Mon, 02 Jul 2018 06:06:22 -0700 (PDT)
Received: from mail-yb0-f172.google.com (mail-yb0-f172.google.com. [209.85.213.172])
        by smtp.gmail.com with ESMTPSA id g190-v6sm6719951ywh.83.2018.07.02.06.06.21
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 02 Jul 2018 06:06:21 -0700 (PDT)
Received: by mail-yb0-f172.google.com with SMTP id x15-v6so5064968ybm.2
        for <linux-media@vger.kernel.org>; Mon, 02 Jul 2018 06:06:21 -0700 (PDT)
MIME-Version: 1.0
References: <20180604114648.26159-1-hverkuil@xs4all.nl> <20180604114648.26159-8-hverkuil@xs4all.nl>
In-Reply-To: <20180604114648.26159-8-hverkuil@xs4all.nl>
From: Tomasz Figa <tfiga@chromium.org>
Date: Mon, 2 Jul 2018 22:06:09 +0900
Message-ID: <CAAFQd5B3QZKucU-dLBe-XKWSB3oObuRO6frycxr2e=AkkvrWLA@mail.gmail.com>
Subject: Re: [PATCHv15 07/35] v4l2-dev: lock req_queue_mutex
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Mon, Jun 4, 2018 at 8:48 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
[snip]
> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
> index 965fd301f617..27a893aa0664 100644
> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> @@ -2714,6 +2714,7 @@ static long __video_do_ioctl(struct file *file,
>                 unsigned int cmd, void *arg)
>  {
>         struct video_device *vfd = video_devdata(file);
> +       struct mutex *req_queue_lock = NULL;
>         struct mutex *lock; /* ioctl serialization mutex */
>         const struct v4l2_ioctl_ops *ops = vfd->ioctl_ops;
>         bool write_only = false;
> @@ -2733,10 +2734,27 @@ static long __video_do_ioctl(struct file *file,
>         if (test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags))
>                 vfh = file->private_data;
>
> +       /*
> +        * We need to serialize streamon/off with queueing new requests.
> +        * These ioctls may trigger the cancellation of a streaming
> +        * operation, and that should not be mixed with queueing a new
> +        * request at the same time.
> +        */
> +       if (v4l2_device_supports_requests(vfd->v4l2_dev) &&
> +           (cmd == VIDIOC_STREAMON || cmd == VIDIOC_STREAMOFF)) {

Are STREAMON and STREAMOFF the only ioctls we need to acquire
req_queue_lock for? How about a race with, for example, S_CTRL(control
X, request_fd = -1) and req_validate() on a request that depends on
the value of control X? Maybe we should just lock here for any ioctl?

> +               req_queue_lock = &vfd->v4l2_dev->mdev->req_queue_mutex;
> +
> +               if (req_queue_lock && mutex_lock_interruptible(req_queue_lock))

I believe it isn't possible for req_queue_lock to be NULL here.

> +                       return -ERESTARTSYS;

I guess it isn't really possible for mutex_lock_interruptible() to
return anything non-zero other than this, but I'd still return what it
returns here just in case.

Best regards,
Tomasz
