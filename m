Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:48761 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbaKWLCF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Nov 2014 06:02:05 -0500
Received: by mail-lb0-f178.google.com with SMTP id f15so5088893lbj.37
        for <linux-media@vger.kernel.org>; Sun, 23 Nov 2014 03:02:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1416315068-22936-2-git-send-email-hverkuil@xs4all.nl>
References: <1416315068-22936-1-git-send-email-hverkuil@xs4all.nl> <1416315068-22936-2-git-send-email-hverkuil@xs4all.nl>
From: Pawel Osciak <pawel@osciak.com>
Date: Sun, 23 Nov 2014 20:01:22 +0900
Message-ID: <CAMm-=zADQpwW8+A24vWo0hAS+h=5eqGVsKQfn4ApEiL5czxSgA@mail.gmail.com>
Subject: Re: [REVIEWv7 PATCH 01/12] videobuf2-core.h: improve documentation
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: LMML <linux-media@vger.kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Nov 18, 2014 at 9:50 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> Document that drivers can access/modify the buffer contents in buf_prepare
> and buf_finish. That was not clearly stated before.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Pawel Osciak <pawel@osciak.com>

> ---
>  include/media/videobuf2-core.h | 32 +++++++++++++++++---------------
>  1 file changed, 17 insertions(+), 15 deletions(-)
>
> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
> index 6ef2d01..70ace7c 100644
> --- a/include/media/videobuf2-core.h
> +++ b/include/media/videobuf2-core.h
> @@ -270,22 +270,24 @@ struct vb2_buffer {
>   *                     queue setup from completing successfully; optional.
>   * @buf_prepare:       called every time the buffer is queued from userspace
>   *                     and from the VIDIOC_PREPARE_BUF ioctl; drivers may
> - *                     perform any initialization required before each hardware
> - *                     operation in this callback; drivers that support
> - *                     VIDIOC_CREATE_BUFS must also validate the buffer size;
> - *                     if an error is returned, the buffer will not be queued
> - *                     in driver; optional.
> + *                     perform any initialization required before each
> + *                     hardware operation in this callback; drivers can
> + *                     access/modify the buffer here as it is still synced for
> + *                     the CPU; drivers that support VIDIOC_CREATE_BUFS must
> + *                     also validate the buffer size; if an error is returned,
> + *                     the buffer will not be queued in driver; optional.
>   * @buf_finish:                called before every dequeue of the buffer back to
> - *                     userspace; drivers may perform any operations required
> - *                     before userspace accesses the buffer; optional. The
> - *                     buffer state can be one of the following: DONE and
> - *                     ERROR occur while streaming is in progress, and the
> - *                     PREPARED state occurs when the queue has been canceled
> - *                     and all pending buffers are being returned to their
> - *                     default DEQUEUED state. Typically you only have to do
> - *                     something if the state is VB2_BUF_STATE_DONE, since in
> - *                     all other cases the buffer contents will be ignored
> - *                     anyway.
> + *                     userspace; the buffer is synced for the CPU, so drivers
> + *                     can access/modify the buffer contents; drivers may
> + *                     perform any operations required before userspace
> + *                     accesses the buffer; optional. The buffer state can be
> + *                     one of the following: DONE and ERROR occur while
> + *                     streaming is in progress, and the PREPARED state occurs
> + *                     when the queue has been canceled and all pending
> + *                     buffers are being returned to their default DEQUEUED
> + *                     state. Typically you only have to do something if the
> + *                     state is VB2_BUF_STATE_DONE, since in all other cases
> + *                     the buffer contents will be ignored anyway.
>   * @buf_cleanup:       called once before the buffer is freed; drivers may
>   *                     perform any additional cleanup; optional.
>   * @start_streaming:   called once to enter 'streaming' state; the driver may
> --
> 2.1.1
>



-- 
Best regards,
Pawel Osciak
