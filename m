Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw1-f66.google.com ([209.85.161.66]:39477 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725855AbeJIPOq (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 9 Oct 2018 11:14:46 -0400
Received: by mail-yw1-f66.google.com with SMTP id v1-v6so266913ywv.6
        for <linux-media@vger.kernel.org>; Tue, 09 Oct 2018 00:59:06 -0700 (PDT)
Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com. [209.85.219.172])
        by smtp.gmail.com with ESMTPSA id f63-v6sm8821573ywc.21.2018.10.09.00.59.05
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Oct 2018 00:59:05 -0700 (PDT)
Received: by mail-yb1-f172.google.com with SMTP id 5-v6so266280ybf.3
        for <linux-media@vger.kernel.org>; Tue, 09 Oct 2018 00:59:05 -0700 (PDT)
MIME-Version: 1.0
References: <20181004133739.19086-1-mjourdan@baylibre.com>
In-Reply-To: <20181004133739.19086-1-mjourdan@baylibre.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Tue, 9 Oct 2018 16:58:53 +0900
Message-ID: <CAAFQd5BTD6mwB1O4SVeKfKOho7cMMufuenu5xE0BjCAq1GuTag@mail.gmail.com>
Subject: Re: [PATCH] media: videodev2: add V4L2_FMT_FLAG_NO_SOURCE_CHANGE
To: mjourdan@baylibre.com
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Maxime,

On Thu, Oct 4, 2018 at 10:38 PM Maxime Jourdan <mjourdan@baylibre.com> wrote:
>
> When a v4l2 driver exposes V4L2_EVENT_SOURCE_CHANGE, some (usually
> OUTPUT) formats may not be able to trigger this event.
>
> Add a enum_fmt format flag to tag those specific formats.
>
> Signed-off-by: Maxime Jourdan <mjourdan@baylibre.com>
> ---
>  Documentation/media/uapi/v4l/vidioc-enum-fmt.rst | 5 +++++
>  include/uapi/linux/videodev2.h                   | 5 +++--
>  2 files changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst b/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst
> index 019c513df217..e0040b36ac43 100644
> --- a/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst
> +++ b/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst
> @@ -116,6 +116,11 @@ one until ``EINVAL`` is returned.
>        - This format is not native to the device but emulated through
>         software (usually libv4l2), where possible try to use a native
>         format instead for better performance.
> +    * - ``V4L2_FMT_FLAG_NO_SOURCE_CHANGE``
> +      - 0x0004
> +      - The event ``V4L2_EVENT_SOURCE_CHANGE`` is not supported
> +       for this format.
> +
>
>
>  Return Value
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index 3a65951ca51e..a28acee1cb52 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -723,8 +723,9 @@ struct v4l2_fmtdesc {
>         __u32               reserved[4];
>  };
>
> -#define V4L2_FMT_FLAG_COMPRESSED 0x0001
> -#define V4L2_FMT_FLAG_EMULATED   0x0002
> +#define V4L2_FMT_FLAG_COMPRESSED       0x0001
> +#define V4L2_FMT_FLAG_EMULATED         0x0002
> +#define V4L2_FMT_FLAG_NO_SOURCE_CHANGE 0x0004

I think it indeed makes sense. I'd suggest submitting this patch
together with the series that adds the affected driver, though, since
we'd be otherwise just adding a dead API.

Also, it would be good to refer to it from the Decoder Interface
documentation. Depending on which one gets in earlier, you might
either want to base on it or I'd add a note myself.

Best regards,
Tomasz
