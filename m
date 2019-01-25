Return-Path: <SRS0=PLMr=QB=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45861C282C0
	for <linux-media@archiver.kernel.org>; Fri, 25 Jan 2019 05:25:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2E19218CD
	for <linux-media@archiver.kernel.org>; Fri, 25 Jan 2019 05:25:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="mgB5ZQ2M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726097AbfAYFZ4 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 25 Jan 2019 00:25:56 -0500
Received: from mail-oi1-f180.google.com ([209.85.167.180]:34465 "EHLO
        mail-oi1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725936AbfAYFZz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Jan 2019 00:25:55 -0500
Received: by mail-oi1-f180.google.com with SMTP id r62so6896640oie.1
        for <linux-media@vger.kernel.org>; Thu, 24 Jan 2019 21:25:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GB6AzBNwjyM/ZuaKW2LBKmnR2xjM74f/HnQdJGgQEuM=;
        b=mgB5ZQ2M0I2ibdSEo3B5Fmtzj4wPzS+7Aw16mHvI93f/CpsYE1fGZWwz6jSG9+XelC
         NGuIcaa5cFW3vERp9Okj8aSMU1pmGRs4lelOCtj8ClSB777vZP6lEzEvGjKK0KEQZodh
         2S2oRwP3ljHEzUh0AZ09j5NuXqH7Yu/9i7kWo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GB6AzBNwjyM/ZuaKW2LBKmnR2xjM74f/HnQdJGgQEuM=;
        b=diqjb+jqRNzpyeMgCspZOEN0BD6tL4Ir3fYlpElDnwFds9JxyiYzKmndx5QMCTuRUC
         DrZV59EJ8ZYUsBOOxXq3TyCs/YNG8JK6Ab+qxna4CjqFBUuqsXz/HNm06o5sokOcC/Q2
         eIu21h87xCoy7ZUHXW4dBgNziJ0T4tIIDsOnwnpSP8EF+auaOsJWTl+cESHhCuYc/w6/
         SWBPnHqwBCl7r+JdJIsDMm0tgICnRHRkRhLNvRakv+L0VjMbt7e0xKyJxP6H3r/jpQwi
         qu+kI5RJymnO4SqhzPbQSw1ovBpjO0QVT+U1Ldt3UZUnX5YZoY/ut4GJSeRQYQpxVyOa
         wgxQ==
X-Gm-Message-State: AHQUAua4DnWDFq2xYsAGdmkP6SL8hQJYf7BDn9tHuPW5Zvrbl8gb9jFv
        wCLpx+UeG+xOHsZlt/iU/G8VyCIQy6yYOA==
X-Google-Smtp-Source: AHgI3Ia+ADi4FB2VZkUUeug5CbDCNjOSa6tMasxVxqVEudLJiXi4AQCywQggk2tFCZL+xL5Ea8Kxtw==
X-Received: by 2002:aca:3c06:: with SMTP id j6mr420455oia.126.1548393953806;
        Thu, 24 Jan 2019 21:25:53 -0800 (PST)
Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com. [209.85.167.177])
        by smtp.gmail.com with ESMTPSA id t197sm1090374oif.29.2019.01.24.21.25.52
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Jan 2019 21:25:53 -0800 (PST)
Received: by mail-oi1-f177.google.com with SMTP id i6so6848835oia.6
        for <linux-media@vger.kernel.org>; Thu, 24 Jan 2019 21:25:52 -0800 (PST)
X-Received: by 2002:aca:b882:: with SMTP id i124mr394946oif.127.1548392752023;
 Thu, 24 Jan 2019 21:05:52 -0800 (PST)
MIME-Version: 1.0
References: <20181119110903.24383-1-hverkuil@xs4all.nl> <20181119110903.24383-4-hverkuil@xs4all.nl>
In-Reply-To: <20181119110903.24383-4-hverkuil@xs4all.nl>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Fri, 25 Jan 2019 14:05:40 +0900
X-Gmail-Original-Message-ID: <CAAFQd5BULqTEcdmPOv=AtaN+SOeL6EVNFLoF4ksKW5adcNX5Dg@mail.gmail.com>
Message-ID: <CAAFQd5BULqTEcdmPOv=AtaN+SOeL6EVNFLoF4ksKW5adcNX5Dg@mail.gmail.com>
Subject: Re: [PATCHv2 3/4] vb2 core: add new queue_setup_lock/unlock ops
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Hans,

On Mon, Nov 19, 2018 at 8:09 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> If queue->lock is different from the video_device lock, then
> you need to serialize queue_setup with VIDIOC_S_FMT, and this
> should be done by the driver.
>
> Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
> ---
>  .../media/common/videobuf2/videobuf2-core.c   | 51 +++++++++++++------
>  include/media/videobuf2-core.h                | 19 +++++++
>  2 files changed, 55 insertions(+), 15 deletions(-)
>
> diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
> index f7e7e633bcd7..269485920beb 100644
> --- a/drivers/media/common/videobuf2/videobuf2-core.c
> +++ b/drivers/media/common/videobuf2/videobuf2-core.c
> @@ -465,7 +465,8 @@ static int __vb2_queue_free(struct vb2_queue *q, unsigned int buffers)
>          */
>         if (q->num_buffers) {
>                 bool unbalanced = q->cnt_start_streaming != q->cnt_stop_streaming ||
> -                                 q->cnt_wait_prepare != q->cnt_wait_finish;
> +                                 q->cnt_wait_prepare != q->cnt_wait_finish ||
> +                                 q->cnt_queue_setup_lock != q->cnt_queue_setup_unlock;
>
>                 if (unbalanced || debug) {
>                         pr_info("counters for queue %p:%s\n", q,
> @@ -473,10 +474,14 @@ static int __vb2_queue_free(struct vb2_queue *q, unsigned int buffers)
>                         pr_info("     setup: %u start_streaming: %u stop_streaming: %u\n",
>                                 q->cnt_queue_setup, q->cnt_start_streaming,
>                                 q->cnt_stop_streaming);
> +                       pr_info("     queue_setup_lock: %u queue_setup_unlock: %u\n",
> +                               q->cnt_queue_setup_lock, q->cnt_queue_setup_unlock);
>                         pr_info("     wait_prepare: %u wait_finish: %u\n",
>                                 q->cnt_wait_prepare, q->cnt_wait_finish);
>                 }
>                 q->cnt_queue_setup = 0;
> +               q->cnt_queue_setup_lock = 0;
> +               q->cnt_queue_setup_unlock = 0;
>                 q->cnt_wait_prepare = 0;
>                 q->cnt_wait_finish = 0;
>                 q->cnt_start_streaming = 0;
> @@ -717,6 +722,7 @@ int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
>         num_buffers = min_t(unsigned int, num_buffers, VB2_MAX_FRAME);
>         memset(q->alloc_devs, 0, sizeof(q->alloc_devs));
>         q->memory = memory;
> +       call_void_qop(q, queue_setup_lock, q);
>
>         /*
>          * Ask the driver how many buffers and planes per buffer it requires.
> @@ -725,22 +731,27 @@ int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
>         ret = call_qop(q, queue_setup, q, &num_buffers, &num_planes,
>                        plane_sizes, q->alloc_devs);
>         if (ret)
> -               return ret;
> +               goto unlock;
>
>         /* Check that driver has set sane values */
> -       if (WARN_ON(!num_planes))
> -               return -EINVAL;
> +       if (WARN_ON(!num_planes)) {
> +               ret = -EINVAL;
> +               goto unlock;
> +       }
>
>         for (i = 0; i < num_planes; i++)
> -               if (WARN_ON(!plane_sizes[i]))
> -                       return -EINVAL;
> +               if (WARN_ON(!plane_sizes[i])) {
> +                       ret = -EINVAL;
> +                       goto unlock;
> +               }
>
>         /* Finally, allocate buffers and video memory */
>         allocated_buffers =
>                 __vb2_queue_alloc(q, memory, num_buffers, num_planes, plane_sizes);
>         if (allocated_buffers == 0) {
>                 dprintk(1, "memory allocation failed\n");
> -               return -ENOMEM;
> +               ret = -ENOMEM;
> +               goto unlock;
>         }
>
>         /*
> @@ -775,19 +786,19 @@ int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
>                  */
>         }
>
> -       mutex_lock(&q->mmap_lock);
>         q->num_buffers = allocated_buffers;

Why is it safe to stop acquiring mmap_lock here? Looking at other
code, I feel like it's assumed that q->num_buffers is actually
protected by it.

> +       call_void_qop(q, queue_setup_unlock, q);
>
>         if (ret < 0) {
>                 /*
>                  * Note: __vb2_queue_free() will subtract 'allocated_buffers'
>                  * from q->num_buffers.
>                  */
> +               mutex_lock(&q->mmap_lock);
>                 __vb2_queue_free(q, allocated_buffers);
>                 mutex_unlock(&q->mmap_lock);
>                 return ret;
>         }
> -       mutex_unlock(&q->mmap_lock);
>
>         /*
>          * Return the number of successfully allocated buffers
> @@ -795,8 +806,11 @@ int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
>          */
>         *count = allocated_buffers;
>         q->waiting_for_buffers = !q->is_output;
> -
>         return 0;
> +
> +unlock:
> +       call_void_qop(q, queue_setup_unlock, q);
> +       return ret;
>  }
>  EXPORT_SYMBOL_GPL(vb2_core_reqbufs);
>
> @@ -813,10 +827,12 @@ int vb2_core_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
>                 return -ENOBUFS;
>         }
>
> +       call_void_qop(q, queue_setup_lock, q);
>         if (!q->num_buffers) {
>                 if (q->waiting_in_dqbuf && *count) {
>                         dprintk(1, "another dup()ped fd is waiting for a buffer\n");
> -                       return -EBUSY;
> +                       ret = -EBUSY;
> +                       goto unlock;
>                 }
>                 memset(q->alloc_devs, 0, sizeof(q->alloc_devs));
>                 q->memory = memory;
> @@ -837,14 +853,15 @@ int vb2_core_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
>         ret = call_qop(q, queue_setup, q, &num_buffers,
>                        &num_planes, plane_sizes, q->alloc_devs);
>         if (ret)
> -               return ret;
> +               goto unlock;
>
>         /* Finally, allocate buffers and video memory */
>         allocated_buffers = __vb2_queue_alloc(q, memory, num_buffers,
>                                 num_planes, plane_sizes);
>         if (allocated_buffers == 0) {
>                 dprintk(1, "memory allocation failed\n");
> -               return -ENOMEM;
> +               ret = -ENOMEM;
> +               goto unlock;
>         }
>
>         /*
> @@ -869,19 +886,19 @@ int vb2_core_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
>                  */
>         }
>
> -       mutex_lock(&q->mmap_lock);
>         q->num_buffers += allocated_buffers;

Ditto.

> +       call_void_qop(q, queue_setup_unlock, q);
>
>         if (ret < 0) {
>                 /*
>                  * Note: __vb2_queue_free() will subtract 'allocated_buffers'
>                  * from q->num_buffers.
>                  */
> +               mutex_lock(&q->mmap_lock);
>                 __vb2_queue_free(q, allocated_buffers);
>                 mutex_unlock(&q->mmap_lock);
>                 return -ENOMEM;
>         }
> -       mutex_unlock(&q->mmap_lock);
>
>         /*
>          * Return the number of successfully allocated buffers
> @@ -890,6 +907,10 @@ int vb2_core_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
>         *count = allocated_buffers;
>
>         return 0;
> +
> +unlock:
> +       call_void_qop(q, queue_setup_unlock, q);
> +       return ret;
>  }
>  EXPORT_SYMBOL_GPL(vb2_core_create_bufs);
>
> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
> index 613f22910174..92861b6fe7f8 100644
> --- a/include/media/videobuf2-core.h
> +++ b/include/media/videobuf2-core.h
> @@ -333,6 +333,20 @@ struct vb2_buffer {
>   *                     \*num_buffers are being allocated additionally to
>   *                     q->num_buffers. If either \*num_planes or the requested
>   *                     sizes are invalid callback must return %-EINVAL.
> + * @queue_setup_lock:  called from VIDIOC_REQBUFS() and VIDIOC_CREATE_BUFS()
> + *                     to serialize @queue_setup with ioctls like
> + *                     VIDIOC_S_FMT() that change the buffer size. Only
> + *                     required if queue->lock differs from the mutex that is
> + *                     used to serialize the ioctls that change the buffer
> + *                     size. This callback should lock the ioctl serialization
> + *                     mutex.
> + * @queue_setup_unlock:        called from VIDIOC_REQBUFS() and VIDIOC_CREATE_BUFS()
> + *                     to serialize @queue_setup with ioctls like
> + *                     VIDIOC_S_FMT() that change the buffer size. Only
> + *                     required if queue->lock differs from the mutex that is
> + *                     used to serialize the ioctls that change the buffer
> + *                     size. This callback should unlock the ioctl
> + *                     serialization mutex.
>   * @wait_prepare:      release any locks taken while calling vb2 functions;
>   *                     it is called before an ioctl needs to wait for a new
>   *                     buffer to arrive; required to avoid a deadlock in
> @@ -403,10 +417,13 @@ struct vb2_ops {
>         int (*queue_setup)(struct vb2_queue *q,
>                            unsigned int *num_buffers, unsigned int *num_planes,
>                            unsigned int sizes[], struct device *alloc_devs[]);
> +       void (*queue_setup_lock)(struct vb2_queue *q);
> +       void (*queue_setup_unlock)(struct vb2_queue *q);
>
>         void (*wait_prepare)(struct vb2_queue *q);
>         void (*wait_finish)(struct vb2_queue *q);
>
> +

Stray blank line?

Best regards,
Tomasz
