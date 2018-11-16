Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw1-f66.google.com ([209.85.161.66]:40271 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727413AbeKPSqG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Nov 2018 13:46:06 -0500
Received: by mail-yw1-f66.google.com with SMTP id l66-v6so9803521ywl.7
        for <linux-media@vger.kernel.org>; Fri, 16 Nov 2018 00:34:46 -0800 (PST)
Received: from mail-yw1-f48.google.com (mail-yw1-f48.google.com. [209.85.161.48])
        by smtp.gmail.com with ESMTPSA id m126sm1430820ywd.39.2018.11.16.00.34.44
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Nov 2018 00:34:44 -0800 (PST)
Received: by mail-yw1-f48.google.com with SMTP id p18-v6so9759641ywg.12
        for <linux-media@vger.kernel.org>; Fri, 16 Nov 2018 00:34:44 -0800 (PST)
MIME-Version: 1.0
References: <20181113150834.22125-1-hverkuil@xs4all.nl> <20181113150834.22125-3-hverkuil@xs4all.nl>
In-Reply-To: <20181113150834.22125-3-hverkuil@xs4all.nl>
From: Tomasz Figa <tfiga@chromium.org>
Date: Fri, 16 Nov 2018 17:34:32 +0900
Message-ID: <CAAFQd5DWXJX29U8wpL=fysNo6TSc4scxa4uhEkdFVMDEQ85F3Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] vb2: don't allow queueing buffers when canceling queue
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>, mhjungk@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Wed, Nov 14, 2018 at 12:08 AM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> Calling the stop_streaming op can release the core serialization lock
> pointed to by vb2_queue->lock if it has to wait for buffers to finish.
> An example of that behavior is the vivid driver.

Why would vb2_queue->lock have to be released to wait for buffer to
finish? The drivers I worked with never had to do anything like that.

>
> However, if userspace dup()ped the video device filehandle, then it is
> possible to stop streaming on one filehandle and call read/write or
> VIDIOC_QBUF from the other.

How about other ioctls? I can imagine at least STREAMON could be
called at the same time too, but not sure if it would have any side
effects.

Best regards,
Tomasz

>
> This is fixed by setting a flag whenever stop_streaming is called and
> checking the flag where needed so we can return -EBUSY.
>
> Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
> Reported-by: syzbot+736c3aae4af7b50d9683@syzkaller.appspotmail.com
> ---
>  drivers/media/common/videobuf2/videobuf2-core.c | 14 +++++++++++++-
>  include/media/videobuf2-core.h                  |  1 +
>  2 files changed, 14 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
> index 138223af701f..560577321fe7 100644
> --- a/drivers/media/common/videobuf2/videobuf2-core.c
> +++ b/drivers/media/common/videobuf2/videobuf2-core.c
> @@ -1503,6 +1503,10 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb,
>                 dprintk(1, "fatal error occurred on queue\n");
>                 return -EIO;
>         }
> +       if (q->in_stop_streaming) {
> +               dprintk(1, "stop_streaming is called\n");
> +               return -EBUSY;
> +       }
>
>         vb = q->bufs[index];
>
> @@ -1834,8 +1838,11 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
>          * Tell driver to stop all transactions and release all queued
>          * buffers.
>          */
> -       if (q->start_streaming_called)
> +       if (q->start_streaming_called) {
> +               q->in_stop_streaming = 1;
>                 call_void_qop(q, stop_streaming, q);
> +               q->in_stop_streaming = 0;
> +       }
>
>         /*
>          * If you see this warning, then the driver isn't cleaning up properly
> @@ -2565,6 +2572,11 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
>                 return -EBUSY;
>         }
>
> +       if (q->in_stop_streaming) {
> +               dprintk(3, "stop_streaming is called\n");
> +               return -EBUSY;
> +       }
> +
>         /*
>          * Initialize emulator on first call.
>          */
> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
> index 613f22910174..5a3d3ada5940 100644
> --- a/include/media/videobuf2-core.h
> +++ b/include/media/videobuf2-core.h
> @@ -585,6 +585,7 @@ struct vb2_queue {
>         unsigned int                    error:1;
>         unsigned int                    waiting_for_buffers:1;
>         unsigned int                    waiting_in_dqbuf:1;
> +       unsigned int                    in_stop_streaming:1;
>         unsigned int                    is_multiplanar:1;
>         unsigned int                    is_output:1;
>         unsigned int                    copy_timestamp:1;
> --
> 2.19.1
>
