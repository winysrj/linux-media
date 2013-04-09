Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f169.google.com ([209.85.223.169]:54551 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755065Ab3DIGia (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Apr 2013 02:38:30 -0400
Received: by mail-ie0-f169.google.com with SMTP id qd14so8074965ieb.14
        for <linux-media@vger.kernel.org>; Mon, 08 Apr 2013 23:38:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1365489319-29343-1-git-send-email-tjlee@ambarella.com>
References: <1365489319-29343-1-git-send-email-tjlee@ambarella.com>
Date: Tue, 9 Apr 2013 14:38:30 +0800
Message-ID: <CAEvN+1gihDhXVuE7swg-F6x5n80Gszs0cEYPUy_Em2wTYL1uvw@mail.gmail.com>
Subject: Re: [PATCH] v4l2-ctl: skip precalculate_bars() for compressed formats
From: Tzu-Jung Lee <roylee17@gmail.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Tzu-Jung Lee <tjlee@ambarella.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sorry.. wrong patch..
Please ignore this noise.

Thanks.

Roy

On Tue, Apr 9, 2013 at 2:35 PM, Tzu-Jung Lee <roylee17@gmail.com> wrote:
> Signed-off-by: Tzu-Jung Lee <tjlee@ambarella.com>
> ---
>  utils/v4l2-ctl/v4l2-ctl-streaming.cpp | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
> index a6ea8b3..ec18312 100644
> --- a/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
> +++ b/utils/v4l2-ctl/v4l2-ctl-streaming.cpp
> @@ -771,7 +771,10 @@ void streaming_set(int fd)
>                 fmt.type = type;
>                 doioctl(fd, VIDIOC_G_FMT, &fmt);
>
> -               if (!precalculate_bars(fmt.fmt.pix.pixelformat, stream_pat % NUM_PATTERNS)) {
> +               if (!(fmt.flags && V4L2_FMT_FLAG_COMPRESSED) &&
> +                               !precalculate_bars(fmt.fmt.pix.pixelformat,
> +                                       stream_pat % NUM_PATTERNS)) {
> +
>                         fprintf(stderr, "unsupported pixelformat\n");
>                         return;
>                 }
> --
> 1.8.1.5
>
