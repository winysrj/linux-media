Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw1-f68.google.com ([209.85.161.68]:39596 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390677AbeKVVIR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Nov 2018 16:08:17 -0500
Received: by mail-yw1-f68.google.com with SMTP id v8-v6so3443077ywh.6
        for <linux-media@vger.kernel.org>; Thu, 22 Nov 2018 02:29:28 -0800 (PST)
Received: from mail-yw1-f54.google.com (mail-yw1-f54.google.com. [209.85.161.54])
        by smtp.gmail.com with ESMTPSA id u4sm29513289ywu.92.2018.11.22.02.29.25
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 22 Nov 2018 02:29:25 -0800 (PST)
Received: by mail-yw1-f54.google.com with SMTP id i20so3440542ywc.5
        for <linux-media@vger.kernel.org>; Thu, 22 Nov 2018 02:29:25 -0800 (PST)
MIME-Version: 1.0
References: <20181121191652.22814-1-ezequiel@collabora.com> <20181121191652.22814-3-ezequiel@collabora.com>
In-Reply-To: <20181121191652.22814-3-ezequiel@collabora.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Thu, 22 Nov 2018 19:29:13 +0900
Message-ID: <CAAFQd5AsAsLbbJXN3+9urbZipcXn3WSpQp8G5r+Nj04wKpiy5w@mail.gmail.com>
Subject: Re: [PATCH v10 2/4] ARM: dts: rockchip: add VPU device node for RK3288
To: Ezequiel Garcia <ezequiel@collabora.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        devicetree@vger.kernel.org,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, myy@miouyouyou.fr
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ezequiel,

On Thu, Nov 22, 2018 at 4:17 AM Ezequiel Garcia <ezequiel@collabora.com> wrote:
>
> Add the Video Processing Unit node for RK3288 SoC.
>
> Fix the VPU IOMMU node, which was disabled and lacking
> its power domain property.
>
> Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
> ---
>  arch/arm/boot/dts/rk3288.dtsi | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
> index 0840ffb3205c..40d203cdca09 100644
> --- a/arch/arm/boot/dts/rk3288.dtsi
> +++ b/arch/arm/boot/dts/rk3288.dtsi
> @@ -1223,6 +1223,18 @@
>                 };
>         };
>
> +       vpu: video-codec@ff9a0000 {
> +               compatible = "rockchip,rk3288-vpu";
> +               reg = <0x0 0xff9a0000 0x0 0x800>;
> +               interrupts = <GIC_SPI 9 IRQ_TYPE_LEVEL_HIGH>,
> +                            <GIC_SPI 10 IRQ_TYPE_LEVEL_HIGH>;
> +               interrupt-names = "vepu", "vdpu";
> +               clocks = <&cru ACLK_VCODEC>, <&cru HCLK_VCODEC>;
> +               clock-names = "aclk", "hclk";
> +               power-domains = <&power RK3288_PD_VIDEO>;
> +               iommus = <&vpu_mmu>;
> +       };
> +
>         vpu_mmu: iommu@ff9a0800 {
>                 compatible = "rockchip,iommu";
>                 reg = <0x0 0xff9a0800 0x0 0x100>;
> @@ -1230,8 +1242,8 @@
>                 interrupt-names = "vpu_mmu";
>                 clocks = <&cru ACLK_VCODEC>, <&cru HCLK_VCODEC>;
>                 clock-names = "aclk", "iface";
> +               power-domains = <&power RK3288_PD_VIDEO>;
>                 #iommu-cells = <0>;
> -               status = "disabled";
>         };
>
>         hevc_mmu: iommu@ff9c0440 {

Reviewed-by: Tomasz Figa <tfiga@chromium.org>

Best regards,
Tomasz
