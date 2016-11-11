Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f51.google.com ([209.85.214.51]:37065 "EHLO
        mail-it0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756077AbcKKMLn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Nov 2016 07:11:43 -0500
Received: by mail-it0-f51.google.com with SMTP id u205so118034378itc.0
        for <linux-media@vger.kernel.org>; Fri, 11 Nov 2016 04:11:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <f5120730-0e1d-f93c-eed9-7b71ff79f5db@xs4all.nl>
References: <1478540043-24558-1-git-send-email-stanimir.varbanov@linaro.org> <f5120730-0e1d-f93c-eed9-7b71ff79f5db@xs4all.nl>
From: Javier Martinez Canillas <javier@dowhile0.org>
Date: Fri, 11 Nov 2016 09:11:42 -0300
Message-ID: <CABxcv=nop8h5U0Kt5yjmSVX3ZZbUb7O6yVzOf5AxzsiWUucjwA@mail.gmail.com>
Subject: Re: [PATCH v3 0/9] Qualcomm video decoder/encoder driver
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Andy Gross <andy.gross@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans,

On Fri, Nov 11, 2016 at 8:49 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Hi Stanimir,
>
> Overall it looks good. As you saw, I do have some comments but nothing major.
>
> One question: you use qcom as the directory name. How about using qualcomm?
>
> It's really not that much longer and a bit more obvious.
>
> Up to you, though.
>

It seems qcom is more consistent to the name used in most subsystems
for Qualcomm:

$ find -name *qcom
./arch/arm/mach-qcom
./arch/arm64/boot/dts/qcom
./Documentation/devicetree/bindings/soc/qcom
./sound/soc/qcom
./drivers/pinctrl/qcom
./drivers/soc/qcom
./drivers/clk/qcom

$ find -name *qualcomm
./drivers/net/ethernet/qualcomm

> Regards,
>
>         Hans
>

Best regards,
Javier
