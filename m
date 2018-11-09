Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb1-f196.google.com ([209.85.219.196]:43613 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727962AbeKIRgA (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Nov 2018 12:36:00 -0500
Received: by mail-yb1-f196.google.com with SMTP id h187-v6so683907ybg.10
        for <linux-media@vger.kernel.org>; Thu, 08 Nov 2018 23:56:36 -0800 (PST)
Received: from mail-yb1-f176.google.com (mail-yb1-f176.google.com. [209.85.219.176])
        by smtp.gmail.com with ESMTPSA id l69-v6sm1700169ywl.51.2018.11.08.23.56.34
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Nov 2018 23:56:35 -0800 (PST)
Received: by mail-yb1-f176.google.com with SMTP id u103-v6so704995ybi.5
        for <linux-media@vger.kernel.org>; Thu, 08 Nov 2018 23:56:34 -0800 (PST)
MIME-Version: 1.0
References: <1541749141-6989-1-git-send-email-mgottam@codeaurora.org>
In-Reply-To: <1541749141-6989-1-git-send-email-mgottam@codeaurora.org>
From: Tomasz Figa <tfiga@chromium.org>
Date: Fri, 9 Nov 2018 16:56:21 +0900
Message-ID: <CAAFQd5CwhPTmh4kF6O23Os2tihaWEez1SM=Th6BGkf_wo_LYDA@mail.gmail.com>
Subject: Re: [PATCH v2] media: venus: add support for selection rectangles
To: mgottam@codeaurora.org
Cc: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        vgarodia@codeaurora.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Malathi,

On Fri, Nov 9, 2018 at 4:39 PM Malathi Gottam <mgottam@codeaurora.org> wrote:
>
> Handles target type crop by setting the new active rectangle
> to hardware. The new rectangle should be within YUV size.
>
> Signed-off-by: Malathi Gottam <mgottam@codeaurora.org>
> ---
>  drivers/media/platform/qcom/venus/venc.c | 26 ++++++++++++++++++++++----
>  1 file changed, 22 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/media/platform/qcom/venus/venc.c b/drivers/media/platform/qcom/venus/venc.c
> index ce85962..d26c129 100644
> --- a/drivers/media/platform/qcom/venus/venc.c
> +++ b/drivers/media/platform/qcom/venus/venc.c
> @@ -478,16 +478,34 @@ static int venc_g_fmt(struct file *file, void *fh, struct v4l2_format *f)
>  venc_s_selection(struct file *file, void *fh, struct v4l2_selection *s)
>  {
>         struct venus_inst *inst = to_inst(file);
> +       int ret;
> +       u32 buftype;
>
>         if (s->type != V4L2_BUF_TYPE_VIDEO_OUTPUT)
>                 return -EINVAL;
>
>         switch (s->target) {
>         case V4L2_SEL_TGT_CROP:
> -               if (s->r.width != inst->out_width ||
> -                   s->r.height != inst->out_height ||
> -                   s->r.top != 0 || s->r.left != 0)
> -                       return -EINVAL;
> +               if (s->r.left != 0) {
> +                       s->r.width += s->r.left;
> +                       s->r.left = 0;
> +               }
> +
> +               if (s->r.top != 0) {
> +                       s->r.height += s->r.top;
> +                       s->r.top = 0;
> +               }
> +
> +               if (s->r.width > inst->width)
> +                       s->r.width = inst->width;
> +               else
> +                       inst->width = s->r.width;
> +
> +               if (s->r.height > inst->height)
> +                       s->r.height = inst->height;
> +               else
> +                       inst->height = s->r.height;
> +

>From semantic point of view, it looks fine, but where is the rectangle
actually set to the hardware?

Best regards,
Tomasz
