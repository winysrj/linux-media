Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw1-f67.google.com ([209.85.161.67]:43566 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727992AbeKNU7d (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Nov 2018 15:59:33 -0500
Received: by mail-yw1-f67.google.com with SMTP id l200so1496710ywe.10
        for <linux-media@vger.kernel.org>; Wed, 14 Nov 2018 02:56:47 -0800 (PST)
Received: from mail-yw1-f50.google.com (mail-yw1-f50.google.com. [209.85.161.50])
        by smtp.gmail.com with ESMTPSA id h63-v6sm5594560ywb.110.2018.11.14.02.56.45
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Nov 2018 02:56:46 -0800 (PST)
Received: by mail-yw1-f50.google.com with SMTP id z72-v6so7133636ywa.0
        for <linux-media@vger.kernel.org>; Wed, 14 Nov 2018 02:56:45 -0800 (PST)
MIME-Version: 1.0
References: <1538222432-25894-1-git-send-email-sgorle@codeaurora.org> <1538222432-25894-3-git-send-email-sgorle@codeaurora.org>
In-Reply-To: <1538222432-25894-3-git-send-email-sgorle@codeaurora.org>
From: Tomasz Figa <tfiga@chromium.org>
Date: Wed, 14 Nov 2018 19:56:33 +0900
Message-ID: <CAAFQd5D4p_1PGCYzeKTYJovS6PVA7rho0wj_knvr4Vm3gDOtTw@mail.gmail.com>
Subject: Re: [PATCH v1 2/5] media: venus: dynamically configure codec type
To: sgorle@codeaurora.org
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

On Sat, Sep 29, 2018 at 9:01 PM Srinu Gorle <sgorle@codeaurora.org> wrote:
>
> - currently video decoder instance is hardcoded to H.264 video format.
> - this change enables video decoder dynamically configure to
>   any supported video format.
>
> Signed-off-by: Srinu Gorle <sgorle@codeaurora.org>
> ---
>  drivers/media/platform/qcom/venus/helpers.c | 51 ++++++++++++++---------------
>  drivers/media/platform/qcom/venus/helpers.h |  1 +
>  drivers/media/platform/qcom/venus/vdec.c    |  2 ++
>  3 files changed, 27 insertions(+), 27 deletions(-)
>
> diff --git a/drivers/media/platform/qcom/venus/helpers.c b/drivers/media/platform/qcom/venus/helpers.c
> index 822a853..c82dbac 100644
> --- a/drivers/media/platform/qcom/venus/helpers.c
> +++ b/drivers/media/platform/qcom/venus/helpers.c
> @@ -36,47 +36,44 @@ struct intbuf {
>         unsigned long attrs;
>  };
>
> -bool venus_helper_check_codec(struct venus_inst *inst, u32 v4l2_pixfmt)
> +u32 v4l2_venus_fmt(u32 pixfmt)
>  {
> -       struct venus_core *core = inst->core;
> -       u32 session_type = inst->session_type;
> -       u32 codec;
> -
> -       switch (v4l2_pixfmt) {
> +       switch (pixfmt) {
>         case V4L2_PIX_FMT_H264:
> -               codec = HFI_VIDEO_CODEC_H264;
> -               break;
> +       case V4L2_PIX_FMT_H264_NO_SC:
> +               return HFI_VIDEO_CODEC_H264;
>         case V4L2_PIX_FMT_H263:
> -               codec = HFI_VIDEO_CODEC_H263;
> -               break;
> +               return HFI_VIDEO_CODEC_H263;
>         case V4L2_PIX_FMT_MPEG1:
> -               codec = HFI_VIDEO_CODEC_MPEG1;
> -               break;
> +               return HFI_VIDEO_CODEC_MPEG1;
>         case V4L2_PIX_FMT_MPEG2:
> -               codec = HFI_VIDEO_CODEC_MPEG2;
> -               break;
> +               return HFI_VIDEO_CODEC_MPEG2;
>         case V4L2_PIX_FMT_MPEG4:
> -               codec = HFI_VIDEO_CODEC_MPEG4;
> -               break;
> +               return HFI_VIDEO_CODEC_MPEG4;
>         case V4L2_PIX_FMT_VC1_ANNEX_G:
>         case V4L2_PIX_FMT_VC1_ANNEX_L:
> -               codec = HFI_VIDEO_CODEC_VC1;
> -               break;
> +               return HFI_VIDEO_CODEC_VC1;
>         case V4L2_PIX_FMT_VP8:
> -               codec = HFI_VIDEO_CODEC_VP8;
> -               break;
> +               return HFI_VIDEO_CODEC_VP8;
>         case V4L2_PIX_FMT_VP9:
> -               codec = HFI_VIDEO_CODEC_VP9;
> -               break;
> +               return HFI_VIDEO_CODEC_VP9;
>         case V4L2_PIX_FMT_XVID:
> -               codec = HFI_VIDEO_CODEC_DIVX;
> -               break;
> +               return HFI_VIDEO_CODEC_DIVX;
>         case V4L2_PIX_FMT_HEVC:
> -               codec = HFI_VIDEO_CODEC_HEVC;
> -               break;
> +               return HFI_VIDEO_CODEC_HEVC;
>         default:
> -               return false;
> +               return 0;
>         }
> +}
> +EXPORT_SYMBOL_GPL(v4l2_venus_fmt);
> +
> +bool venus_helper_check_codec(struct venus_inst *inst, u32 v4l2_pixfmt)
> +{
> +       struct venus_core *core = inst->core;
> +       u32 session_type = inst->session_type;
> +       u32 codec;
> +
> +       codec = v4l2_venus_fmt(v4l2_pixfmt);
>
>         if (session_type == VIDC_SESSION_TYPE_ENC && core->enc_codecs & codec)
>                 return true;
> diff --git a/drivers/media/platform/qcom/venus/helpers.h b/drivers/media/platform/qcom/venus/helpers.h
> index 3de0c44..725831d 100644
> --- a/drivers/media/platform/qcom/venus/helpers.h
> +++ b/drivers/media/platform/qcom/venus/helpers.h
> @@ -19,6 +19,7 @@
>
>  struct venus_inst;
>
> +u32 v4l2_venus_fmt(u32 pixfmt);
>  bool venus_helper_check_codec(struct venus_inst *inst, u32 v4l2_pixfmt);
>  struct vb2_v4l2_buffer *venus_helper_find_buf(struct venus_inst *inst,
>                                               unsigned int type, u32 idx);
> diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
> index 98675db..afe3b36 100644
> --- a/drivers/media/platform/qcom/venus/vdec.c
> +++ b/drivers/media/platform/qcom/venus/vdec.c
> @@ -413,6 +413,8 @@ static int vdec_enum_framesizes(struct file *file, void *fh,
>                                   V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE);
>                 if (!fmt)
>                         return -EINVAL;
> +               inst->fmt_out = fmt;
> +               inst->hfi_codec = v4l2_venus_fmt(fmt->pixfmt);

That's wrong. ENUM_FRAMESIZES (and any other ENUM_* or G_* ioctl) must
not affect driver state or result in any other side effects.

Best regards,
Tomasz
