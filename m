Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f170.google.com ([209.85.217.170]:45057 "EHLO
        mail-ua0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751049AbeDLINY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Apr 2018 04:13:24 -0400
Received: by mail-ua0-f170.google.com with SMTP id j18so2910665uae.12
        for <linux-media@vger.kernel.org>; Thu, 12 Apr 2018 01:13:24 -0700 (PDT)
Received: from mail-ua0-f175.google.com (mail-ua0-f175.google.com. [209.85.217.175])
        by smtp.gmail.com with ESMTPSA id r35sm699410uai.0.2018.04.12.01.13.22
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Apr 2018 01:13:22 -0700 (PDT)
Received: by mail-ua0-f175.google.com with SMTP id l21so2923526uak.1
        for <linux-media@vger.kernel.org>; Thu, 12 Apr 2018 01:13:22 -0700 (PDT)
MIME-Version: 1.0
References: <20180409142026.19369-1-hverkuil@xs4all.nl> <20180409142026.19369-20-hverkuil@xs4all.nl>
In-Reply-To: <20180409142026.19369-20-hverkuil@xs4all.nl>
From: Tomasz Figa <tfiga@chromium.org>
Date: Thu, 12 Apr 2018 08:13:11 +0000
Message-ID: <CAAFQd5B2Xs1Jc=DJsTYVTPC6GwMoyEdRHayVuWZQYTDStv1+Qg@mail.gmail.com>
Subject: Re: [RFCv11 PATCH 19/29] videobuf2-core: integrate with media requests
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Mon, Apr 9, 2018 at 11:20 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:

> From: Hans Verkuil <hans.verkuil@cisco.com>

> Buffers can now be prepared or queued for a request.

> A buffer is unbound from the request at vb2_buffer_done time or
> when the queue is cancelled.

Please see my comments inline.

[snip]
> -int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void
*pb)
> +static int vb2_req_prepare(struct media_request_object *obj)
>   {
> -       struct vb2_buffer *vb;
> +       struct vb2_buffer *vb = container_of(obj, struct vb2_buffer,
req_obj);
>          int ret;

> +       if (WARN_ON(vb->state != VB2_BUF_STATE_IN_REQUEST))
> +               return -EINVAL;
> +
> +       ret = __buf_prepare(vb, NULL);
> +       if (ret)
> +               vb->state = VB2_BUF_STATE_IN_REQUEST;

Hmm, I suppose this is here because __buf_prepare() changes the state to
VB2_BUF_STATE_DEQUEUED on error (other than q->error)? I guess it's
harmless, but perhaps we could have a comment explaining this?

Best regards,
Tomasz
