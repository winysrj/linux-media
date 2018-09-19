Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:37720 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726972AbeISNJS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Sep 2018 09:09:18 -0400
Received: by mail-it0-f66.google.com with SMTP id h20-v6so6510060itf.2
        for <linux-media@vger.kernel.org>; Wed, 19 Sep 2018 00:32:40 -0700 (PDT)
Received: from mail-it0-f51.google.com (mail-it0-f51.google.com. [209.85.214.51])
        by smtp.gmail.com with ESMTPSA id r18-v6sm8010487iob.16.2018.09.19.00.32.39
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 19 Sep 2018 00:32:39 -0700 (PDT)
Received: by mail-it0-f51.google.com with SMTP id p79-v6so6973222itp.3
        for <linux-media@vger.kernel.org>; Wed, 19 Sep 2018 00:32:39 -0700 (PDT)
MIME-Version: 1.0
References: <1537314192-26892-1-git-send-email-vgarodia@codeaurora.org> <1537314192-26892-6-git-send-email-vgarodia@codeaurora.org>
In-Reply-To: <1537314192-26892-6-git-send-email-vgarodia@codeaurora.org>
From: Alexandre Courbot <acourbot@chromium.org>
Date: Wed, 19 Sep 2018 16:32:27 +0900
Message-ID: <CAPBb6MV0egcso8fDcfkvc_+Un2PKX+H=fz-1aKFRJ38ciOBd7g@mail.gmail.com>
Subject: Re: [PATCH v9 5/5] dt-bindings: media: Document bindings for venus
 firmware device
To: vgarodia@codeaurora.org
Cc: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>, robh@kernel.org,
        mark.rutland@arm.com, Andy Gross <andy.gross@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, bjorn.andersson@linaro.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, linux-soc@vger.kernel.org,
        devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Sep 19, 2018 at 8:44 AM Vikash Garodia <vgarodia@codeaurora.org> wrote:
>
> Add devicetree binding documentation for firmware loader for video
> hardware running on qualcomm chip.
>
> Signed-off-by: Vikash Garodia <vgarodia@codeaurora.org>
> ---
>  Documentation/devicetree/bindings/media/qcom,venus.txt | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
>
> diff --git a/Documentation/devicetree/bindings/media/qcom,venus.txt b/Documentation/devicetree/bindings/media/qcom,venus.txt
> index 00d0d1b..7e04586 100644
> --- a/Documentation/devicetree/bindings/media/qcom,venus.txt
> +++ b/Documentation/devicetree/bindings/media/qcom,venus.txt
> @@ -53,7 +53,7 @@
>
>  * Subnodes
>  The Venus video-codec node must contain two subnodes representing
> -video-decoder and video-encoder.
> +video-decoder and video-encoder, and one optional firmware subnode.

I think I mentioned this in my previous review, but it would be nice
to explain in which circumstances the firmware node is optional. I.e.
it should not be specified if TrustZone is used.

>
>  Every of video-encoder or video-decoder subnode should have:
>
> @@ -79,6 +79,13 @@ Every of video-encoder or video-decoder subnode should have:
>                     power domain which is responsible for collapsing
>                     and restoring power to the subcore.
>
> +The firmware subnode must have:
> +
> +- iommus:
> +       Usage: required
> +       Value type: <prop-encoded-array>
> +       Definition: A list of phandle and IOMMU specifier pairs.
> +
>  * An Example
>         video-codec@1d00000 {
>                 compatible = "qcom,msm8916-venus";
> @@ -105,4 +112,8 @@ Every of video-encoder or video-decoder subnode should have:
>                         clock-names = "core";
>                         power-domains = <&mmcc VENUS_CORE1_GDSC>;
>                 };
> +
> +               video-firmware {
> +                       iommus = <&apps_iommu 0x10b2 0x0>;
> +               };
>         };
> --
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> a Linux Foundation Collaborative Project
>
