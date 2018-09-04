Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw1-f66.google.com ([209.85.161.66]:41659 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725990AbeIDMqC (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 4 Sep 2018 08:46:02 -0400
Received: by mail-yw1-f66.google.com with SMTP id q129-v6so944477ywg.8
        for <linux-media@vger.kernel.org>; Tue, 04 Sep 2018 01:21:58 -0700 (PDT)
Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com. [209.85.219.175])
        by smtp.gmail.com with ESMTPSA id f5-v6sm7485538ywa.39.2018.09.04.01.21.56
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Sep 2018 01:21:57 -0700 (PDT)
Received: by mail-yb1-f175.google.com with SMTP id y20-v6so965024ybi.13
        for <linux-media@vger.kernel.org>; Tue, 04 Sep 2018 01:21:56 -0700 (PDT)
MIME-Version: 1.0
References: <20180904075850.2406-1-hverkuil@xs4all.nl> <20180904075850.2406-10-hverkuil@xs4all.nl>
In-Reply-To: <20180904075850.2406-10-hverkuil@xs4all.nl>
From: Tomasz Figa <tfiga@chromium.org>
Date: Tue, 4 Sep 2018 17:21:44 +0900
Message-ID: <CAAFQd5BZ_OVXGyNS7+0h07f7uun45NSitnWegKj20QcdcoqyNg@mail.gmail.com>
Subject: Re: [PATCHv4 09/10] media-request: EPERM -> EACCES/EBUSY
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Sep 4, 2018 at 4:59 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> If requests are not supported by the driver, then return EACCES, not
> EPERM.
>
> If you attempt to mix queueing buffers directly and using requests,
> then EBUSY is returned instead of EPERM: once a specific queueing mode
> has been chosen the queue is 'busy' if you attempt the other mode
> (i.e. direct queueing vs via a request).
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  .../uapi/mediactl/media-request-ioc-queue.rst  |  9 ++++-----
>  .../media/uapi/mediactl/request-api.rst        |  4 ++--
>  Documentation/media/uapi/v4l/buffer.rst        |  2 +-
>  .../media/uapi/v4l/vidioc-g-ext-ctrls.rst      |  9 ++++-----
>  Documentation/media/uapi/v4l/vidioc-qbuf.rst   | 18 ++++++++++--------
>  .../media/common/videobuf2/videobuf2-core.c    |  2 +-
>  .../media/common/videobuf2/videobuf2-v4l2.c    |  9 ++++++---
>  drivers/media/media-request.c                  |  4 ++--
>  include/media/media-request.h                  |  6 +++---
>  9 files changed, 33 insertions(+), 30 deletions(-)
[snip]
> diff --git a/include/media/media-request.h b/include/media/media-request.h
> index d8c8db89dbde..0ce75c35131f 100644
> --- a/include/media/media-request.h
> +++ b/include/media/media-request.h
> @@ -198,8 +198,8 @@ void media_request_put(struct media_request *req);
>   * Get the request represented by @request_fd that is owned
>   * by the media device.
>   *
> - * Return a -EPERM error pointer if requests are not supported
> - * by this driver. Return -ENOENT if the request was not found.
> + * Return a -EACCES error pointer if requests are not supported
> + * by this driver. Return -EINVAL if the request was not found.

I think the bottom-most line belongs to patch 1/10. With that fixed
(possibly when applying):

Reviewed-by: Tomasz Figa <tfiga@chromium.org>

Best regards,
Tomasz
