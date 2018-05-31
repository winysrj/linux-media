Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f66.google.com ([209.85.213.66]:43221 "EHLO
        mail-vk0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754154AbeEaJ1V (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 May 2018 05:27:21 -0400
Received: by mail-vk0-f66.google.com with SMTP id x191-v6so12918547vke.10
        for <linux-media@vger.kernel.org>; Thu, 31 May 2018 02:27:21 -0700 (PDT)
Received: from mail-ua0-f176.google.com (mail-ua0-f176.google.com. [209.85.217.176])
        by smtp.gmail.com with ESMTPSA id l6-v6sm3864918vki.30.2018.05.31.02.27.19
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 31 May 2018 02:27:19 -0700 (PDT)
Received: by mail-ua0-f176.google.com with SMTP id f30-v6so12783504uab.11
        for <linux-media@vger.kernel.org>; Thu, 31 May 2018 02:27:19 -0700 (PDT)
MIME-Version: 1.0
References: <20180515075859.17217-1-stanimir.varbanov@linaro.org> <20180515075859.17217-26-stanimir.varbanov@linaro.org>
In-Reply-To: <20180515075859.17217-26-stanimir.varbanov@linaro.org>
From: Tomasz Figa <tfiga@chromium.org>
Date: Thu, 31 May 2018 18:27:07 +0900
Message-ID: <CAAFQd5BjfdyZw4cHogCK1QkxTHTfdbvH-mvkQ79sRixThr5COg@mail.gmail.com>
Subject: Re: [PATCH v2 25/29] venus: vdec: new function for output configuration
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        vgarodia@codeaurora.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 15, 2018 at 5:01 PM Stanimir Varbanov
<stanimir.varbanov@linaro.org> wrote:
>
> Make a new function vdec_output_conf() for decoder output
> configuration. vdec_output_conf() will set properties via
> HFI interface related to the output configuration, and
> keep vdec_set_properties() which will set properties
> related to decoding parameters.
>
> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
> ---
>  drivers/media/platform/qcom/venus/vdec.c | 35 ++++++++++++++++++--------------
>  1 file changed, 20 insertions(+), 15 deletions(-)
>
> diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
> index 5a5e3e2fece4..3a699af0ab58 100644
> --- a/drivers/media/platform/qcom/venus/vdec.c
> +++ b/drivers/media/platform/qcom/venus/vdec.c
> @@ -545,6 +545,23 @@ static const struct v4l2_ioctl_ops vdec_ioctl_ops = {
>  static int vdec_set_properties(struct venus_inst *inst)
>  {
>         struct vdec_controls *ctr = &inst->controls.dec;
> +       struct hfi_enable en = { .enable = 1 };
> +       u32 ptype;
> +       int ret;
> +
> +       if (ctr->post_loop_deb_mode) {
> +               ptype = HFI_PROPERTY_CONFIG_VDEC_POST_LOOP_DEBLOCKER;
> +               en.enable = 1;

en.enable was already set to 1 in the definition.

Best regards,
Tomasz
