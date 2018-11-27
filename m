Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi1-f195.google.com ([209.85.167.195]:43017 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729092AbeK0S2d (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Nov 2018 13:28:33 -0500
Received: by mail-oi1-f195.google.com with SMTP id u18so18422708oie.10
        for <linux-media@vger.kernel.org>; Mon, 26 Nov 2018 23:31:35 -0800 (PST)
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com. [209.85.210.53])
        by smtp.gmail.com with ESMTPSA id h25sm1031696otj.27.2018.11.26.23.31.34
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Nov 2018 23:31:34 -0800 (PST)
Received: by mail-ot1-f53.google.com with SMTP id e12so14938525otl.5
        for <linux-media@vger.kernel.org>; Mon, 26 Nov 2018 23:31:34 -0800 (PST)
MIME-Version: 1.0
References: <1542708506-12680-1-git-send-email-mgottam@codeaurora.org>
In-Reply-To: <1542708506-12680-1-git-send-email-mgottam@codeaurora.org>
From: Alexandre Courbot <acourbot@chromium.org>
Date: Tue, 27 Nov 2018 16:31:22 +0900
Message-ID: <CAPBb6MVzmxfRstUrTOtkJdCDaZEZO=UeP_u3btGKrsKasBijRg@mail.gmail.com>
Subject: Re: [PATCH] arm64: dts: sdm845: add video nodes
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

On Tue, Nov 20, 2018 at 7:08 PM Malathi Gottam <mgottam@codeaurora.org> wrote:
>
> This adds video nodes to sdm845 based on the examples
> in the bindings.
>
> Signed-off-by: Malathi Gottam <mgottam@codeaurora.org>
> ---
>  arch/arm64/boot/dts/qcom/sdm845.dtsi | 34 ++++++++++++++++++++++++++++++++++
>  1 file changed, 34 insertions(+)
>
> diff --git a/arch/arm64/boot/dts/qcom/sdm845.dtsi b/arch/arm64/boot/dts/qcom/sdm845.dtsi
> index 0c9a2aa..d82487d 100644
> --- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
> +++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
> @@ -84,6 +84,10 @@
>                         reg = <0 0x86200000 0 0x2d00000>;
>                         no-map;
>                 };
> +               venus_region: venus@95800000 {
> +                       reg = <0x0 0x95800000 0x0 0x500000>;

Note that the driver expects a size of 0x600000 here and will fail to
probe if this is smaller.
