Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw1-f65.google.com ([209.85.161.65]:42341 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726264AbeHXSLn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Aug 2018 14:11:43 -0400
Received: by mail-yw1-f65.google.com with SMTP id n207-v6so3149886ywn.9
        for <linux-media@vger.kernel.org>; Fri, 24 Aug 2018 07:36:47 -0700 (PDT)
Received: from mail-yb0-f174.google.com (mail-yb0-f174.google.com. [209.85.213.174])
        by smtp.gmail.com with ESMTPSA id a129-v6sm8241223ywh.79.2018.08.24.07.36.45
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 Aug 2018 07:36:45 -0700 (PDT)
Received: by mail-yb0-f174.google.com with SMTP id d34-v6so3554065yba.3
        for <linux-media@vger.kernel.org>; Fri, 24 Aug 2018 07:36:45 -0700 (PDT)
MIME-Version: 1.0
References: <20180824082156.6986-1-hverkuil@xs4all.nl> <20180824082156.6986-5-hverkuil@xs4all.nl>
In-Reply-To: <20180824082156.6986-5-hverkuil@xs4all.nl>
From: Tomasz Figa <tfiga@chromium.org>
Date: Fri, 24 Aug 2018 23:36:32 +0900
Message-ID: <CAAFQd5A+UCSxBM11-maLbe-0WAKVFnk-mDCn+o06Xd9JO7=0_g@mail.gmail.com>
Subject: Re: [PATCH 4/5] videodev2.h: add new capabilities for buffer types
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        hansverk@cisco.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Fri, Aug 24, 2018 at 5:22 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> From: Hans Verkuil <hansverk@cisco.com>
>
> VIDIOC_REQBUFS and VIDIOC_CREATE_BUFFERS will return capabilities
> telling userspace what the given buffer type is capable of.
>

Please see my comments below.

> Signed-off-by: Hans Verkuil <hansverk@cisco.com>
> ---
>  .../media/uapi/v4l/vidioc-create-bufs.rst     | 10 +++++-
>  .../media/uapi/v4l/vidioc-reqbufs.rst         | 36 ++++++++++++++++++-
>  include/uapi/linux/videodev2.h                | 13 +++++--
>  3 files changed, 55 insertions(+), 4 deletions(-)
>
> diff --git a/Documentation/media/uapi/v4l/vidioc-create-bufs.rst b/Documentation/media/uapi/v4l/vidioc-create-bufs.rst
> index a39e18d69511..fd34d3f236c9 100644
> --- a/Documentation/media/uapi/v4l/vidioc-create-bufs.rst
> +++ b/Documentation/media/uapi/v4l/vidioc-create-bufs.rst
> @@ -102,7 +102,15 @@ than the number requested.
>        - ``format``
>        - Filled in by the application, preserved by the driver.
>      * - __u32
> -      - ``reserved``\ [8]
> +      - ``capabilities``
> +      - Set by the driver. If 0, then the driver doesn't support
> +        capabilities. In that case all you know is that the driver is
> +       guaranteed to support ``V4L2_MEMORY_MMAP`` and *might* support
> +       other :c:type:`v4l2_memory` types. It will not support any others
> +       capabilities. See :ref:`here <v4l2-buf-capabilities>` for a list of the
> +       capabilities.

Perhaps it would make sense to document how the application is
expected to query for these capabilities? Right now, the application
is expected to fill in the "memory" field in this struct (and reqbufs
counterpart), but it sounds a bit strange that one needs to know what
"memory" value to write there to query what set of "memory" values is
supported. In theory, MMAP is expected to be always supported, but it
sounds strange anyway. Also, is there a way to call REQBUFS without
altering the buffer allocation?

Best regards,
Tomasz
