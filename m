Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf1-f193.google.com ([209.85.210.193]:38676 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729114AbeJ1McR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 28 Oct 2018 08:32:17 -0400
Received: by mail-pf1-f193.google.com with SMTP id b11-v6so2375222pfi.5
        for <linux-media@vger.kernel.org>; Sat, 27 Oct 2018 20:49:00 -0700 (PDT)
MIME-Version: 1.0
References: <1540045588-9091-1-git-send-email-akinobu.mita@gmail.com> <1540045588-9091-4-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1540045588-9091-4-git-send-email-akinobu.mita@gmail.com>
From: Matt Ranostay <matt.ranostay@konsulko.com>
Date: Sat, 27 Oct 2018 20:48:49 -0700
Message-ID: <CAJCx=gm0+ZdPKed_w4yZv8+ohgHWh3bi+=7nqxTjazHFtfFQsQ@mail.gmail.com>
Subject: Re: [PATCH v4 3/6] media: v4l2-common: add V4L2_FRACT_COMPARE
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
        Hans Verkuil <hansverk@cisco.com>, mchehab@kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Oct 20, 2018 at 7:26 AM Akinobu Mita <akinobu.mita@gmail.com> wrote:
>
> Add macro to compare two v4l2_fract values in v4l2 common internal API.
> The same macro FRACT_CMP() is used by vivid and bcm2835-camera.  This just
> renames it to V4L2_FRACT_COMPARE in order to avoid namespace collision.
>
> Cc: Matt Ranostay <matt.ranostay@konsulko.com>
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: Hans Verkuil <hansverk@cisco.com>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> ---
> * v4
> - No changes from v3
>
>  include/media/v4l2-common.h | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
> index cdc87ec..eafb8a3 100644
> --- a/include/media/v4l2-common.h
> +++ b/include/media/v4l2-common.h
> @@ -384,4 +384,9 @@ int v4l2_g_parm_cap(struct video_device *vdev,
>  int v4l2_s_parm_cap(struct video_device *vdev,
>                     struct v4l2_subdev *sd, struct v4l2_streamparm *a);
>
> +/* Compare two v4l2_fract structs */
> +#define V4L2_FRACT_COMPARE(a, OP, b)                   \
> +       ((u64)(a).numerator * (b).denominator OP        \
> +       (u64)(b).numerator * (a).denominator)
> +

Noticed a few issues today when testing another thermal camera that
can do 0.5 fps to 64 fps with this macro..

1) This can have collision easily when numerator and denominators
multiplied have the same product, example is 0.5hz and 2hz have the
same output as 2

2) Also this doesn't reduce fractions so I am seeing 4000000 compared
with 4 for instance with a 4hz frame interval.

- Matt



>  #endif /* V4L2_COMMON_H_ */
> --
> 2.7.4
>
