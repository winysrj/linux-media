Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f196.google.com ([209.85.217.196]:37824 "EHLO
        mail-ua0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753165AbeFDM6X (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Jun 2018 08:58:23 -0400
Received: by mail-ua0-f196.google.com with SMTP id i3-v6so22036699uad.4
        for <linux-media@vger.kernel.org>; Mon, 04 Jun 2018 05:58:23 -0700 (PDT)
Received: from mail-vk0-f54.google.com (mail-vk0-f54.google.com. [209.85.213.54])
        by smtp.gmail.com with ESMTPSA id p1-v6sm8274368vke.32.2018.06.04.05.58.20
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 04 Jun 2018 05:58:20 -0700 (PDT)
Received: by mail-vk0-f54.google.com with SMTP id 128-v6so14561846vkf.8
        for <linux-media@vger.kernel.org>; Mon, 04 Jun 2018 05:58:20 -0700 (PDT)
MIME-Version: 1.0
References: <1527884768-22392-1-git-send-email-vgarodia@codeaurora.org> <1527884768-22392-4-git-send-email-vgarodia@codeaurora.org>
In-Reply-To: <1527884768-22392-4-git-send-email-vgarodia@codeaurora.org>
From: Tomasz Figa <tfiga@chromium.org>
Date: Mon, 4 Jun 2018 21:58:08 +0900
Message-ID: <CAAFQd5BSgB0OoqUFckJLXto9FNMYCTQ8ubDftaC-LvFm+A-gxA@mail.gmail.com>
Subject: Re: [PATCH v2 3/5] venus: add check to make scm calls
To: vgarodia@codeaurora.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, andy.gross@linaro.org,
        bjorn.andersson@linaro.org,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        linux-soc@vger.kernel.org, devicetree@vger.kernel.org,
        Alexandre Courbot <acourbot@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Vikash,

On Sat, Jun 2, 2018 at 5:27 AM Vikash Garodia <vgarodia@codeaurora.org> wrote:
[snip]
> +int venus_boot(struct venus_core *core)
> +{
> +       phys_addr_t mem_phys;
> +       size_t mem_size;
> +       int ret;
> +       struct device *dev;
> +
> +       if (!IS_ENABLED(CONFIG_QCOM_MDT_LOADER))
> +               return -EPROBE_DEFER;

Why are we deferring probe here? The option will not magically become
enabled after probe is retried.

Best regards,
Tomasz
