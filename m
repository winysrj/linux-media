Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:53190 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756253AbaDHHtX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Apr 2014 03:49:23 -0400
Received: by mail-ob0-f172.google.com with SMTP id wm4so599303obc.31
        for <linux-media@vger.kernel.org>; Tue, 08 Apr 2014 00:49:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1396876573-15811-7-git-send-email-j.anaszewski@samsung.com>
References: <1396876573-15811-1-git-send-email-j.anaszewski@samsung.com>
	<1396876573-15811-7-git-send-email-j.anaszewski@samsung.com>
Date: Tue, 8 Apr 2014 13:19:23 +0530
Message-ID: <CAK9yfHxXRXagZVAZhGjqH+qVGTAdP-=PnFw4O7HEU09UNB5Tsg@mail.gmail.com>
Subject: Re: [PATCH 7/8] [media] s5p_jpeg: Prevent JPEG 4:2:0 > YUV 4:2:0 decompression
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacek,

On 7 April 2014 18:46, Jacek Anaszewski <j.anaszewski@samsung.com> wrote:
> Prevent decompression of a JPEG 4:2:0 with odd width to
> the YUV 4:2:0 compliant formats for Exynos4x12 SoCs and
> adjust capture format to RGB565 in such a case. This is
> required because the configuration would produce a raw
> image with broken luma component.
>
> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
<snip>

> +       if (ctx->subsampling == V4L2_JPEG_CHROMA_SUBSAMPLING_420 &&
> +           (ctx->out_q.w & 1) &&
> +           (pix->pixelformat == V4L2_PIX_FMT_NV12 ||
> +            pix->pixelformat == V4L2_PIX_FMT_NV21 ||
> +            pix->pixelformat == V4L2_PIX_FMT_YUV420)) {
> +               pix->pixelformat = V4L2_PIX_FMT_RGB565;
> +               fmt = s5p_jpeg_find_format(ctx, pix->pixelformat,
> +                                                       FMT_TYPE_CAPTURE);
> +               v4l2_info(&ctx->jpeg->v4l2_dev,
> +                         "Adjusted capture fourcc to RGB565. Decompression\n"
> +                         "of a JPEG file with 4:2:0 subsampling and odd\n"
> +                         "width to the YUV 4:2:0 compliant formats produces\n"
> +                         "a raw image with broken luma component.\n");

This could be made a comment in the code rather than a info message.

-- 
With warm regards,
Sachin
