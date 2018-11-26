Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi1-f196.google.com ([209.85.167.196]:33928 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726164AbeKZTPU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Nov 2018 14:15:20 -0500
Received: by mail-oi1-f196.google.com with SMTP id h25so15053599oig.1
        for <linux-media@vger.kernel.org>; Mon, 26 Nov 2018 00:21:59 -0800 (PST)
Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com. [209.85.167.174])
        by smtp.gmail.com with ESMTPSA id m89sm19916330otc.35.2018.11.26.00.21.57
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Nov 2018 00:21:58 -0800 (PST)
Received: by mail-oi1-f174.google.com with SMTP id x23so15021195oix.3
        for <linux-media@vger.kernel.org>; Mon, 26 Nov 2018 00:21:57 -0800 (PST)
MIME-Version: 1.0
References: <1542696783-23016-1-git-send-email-mgottam@codeaurora.org>
In-Reply-To: <1542696783-23016-1-git-send-email-mgottam@codeaurora.org>
From: Alexandre Courbot <acourbot@chromium.org>
Date: Mon, 26 Nov 2018 17:21:45 +0900
Message-ID: <CAPBb6MWZ146=Ri12HyBRed4QUOGqDT4m90w2W5VwRhKW4ELCHA@mail.gmail.com>
Subject: Re: [PATCH v2] media: venus: amend buffer size for bitstream plane
To: mgottam@codeaurora.org
Cc: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, vgarodia@codeaurora.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Malathi,

On Tue, Nov 20, 2018 at 3:53 PM Malathi Gottam <mgottam@codeaurora.org> wrote:
>
> Accept the buffer size requested by client and compare it
> against driver calculated size and set the maximum to
> bitstream plane.
>
> Signed-off-by: Malathi Gottam <mgottam@codeaurora.org>
> ---
>  drivers/media/platform/qcom/venus/venc.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/media/platform/qcom/venus/venc.c b/drivers/media/platform/qcom/venus/venc.c
> index ce85962..ecfdbd6 100644
> --- a/drivers/media/platform/qcom/venus/venc.c
> +++ b/drivers/media/platform/qcom/venus/venc.c
> @@ -303,6 +303,7 @@ static int venc_enum_fmt(struct file *file, void *fh, struct v4l2_fmtdesc *f)
>         struct v4l2_pix_format_mplane *pixmp = &f->fmt.pix_mp;
>         struct v4l2_plane_pix_format *pfmt = pixmp->plane_fmt;
>         const struct venus_format *fmt;
> +       __u32 sizeimage;
>
>         memset(pfmt[0].reserved, 0, sizeof(pfmt[0].reserved));
>         memset(pixmp->reserved, 0, sizeof(pixmp->reserved));
> @@ -334,9 +335,10 @@ static int venc_enum_fmt(struct file *file, void *fh, struct v4l2_fmtdesc *f)
>         pixmp->num_planes = fmt->num_planes;
>         pixmp->flags = 0;
>
> -       pfmt[0].sizeimage = venus_helper_get_framesz(pixmp->pixelformat,
> -                                                    pixmp->width,
> -                                                    pixmp->height);
> +       sizeimage = venus_helper_get_framesz(pixmp->pixelformat,
> +                                            pixmp->width,
> +                                            pixmp->height);
> +       pfmt[0].sizeimage = max(ALIGN(pfmt[0].sizeimage, SZ_4K), sizeimage);
>
>         if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
>                 pfmt[0].bytesperline = ALIGN(pixmp->width, 128);
> @@ -408,8 +410,10 @@ static int venc_s_fmt(struct file *file, void *fh, struct v4l2_format *f)
>
>         if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
>                 inst->fmt_out = fmt;
> -       else if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
> +       else if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
>                 inst->fmt_cap = fmt;
> +               inst->output_buf_size = pixmp->plane_fmt[0].sizeimage;
> +       }
>
>         return 0;
>  }
> @@ -908,6 +912,7 @@ static int venc_queue_setup(struct vb2_queue *q,
>                 sizes[0] = venus_helper_get_framesz(inst->fmt_cap->pixfmt,
>                                                     inst->width,
>                                                     inst->height);
> +               sizes[0] = max(sizes[0], inst->output_buf_size);
>                 inst->output_buf_size = sizes[0];
>                 break;
>         default:

I think this should work, but don't we also need to do the same thing
for the decoder's OUTPUT queue?
