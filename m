Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw1-f67.google.com ([209.85.161.67]:35378 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390766AbeKVVIz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Nov 2018 16:08:55 -0500
Received: by mail-yw1-f67.google.com with SMTP id h32so3453456ywk.2
        for <linux-media@vger.kernel.org>; Thu, 22 Nov 2018 02:30:06 -0800 (PST)
Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com. [209.85.219.172])
        by smtp.gmail.com with ESMTPSA id 80-v6sm10518451ywh.55.2018.11.22.02.30.04
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 22 Nov 2018 02:30:04 -0800 (PST)
Received: by mail-yb1-f172.google.com with SMTP id g9-v6so3389125ybh.7
        for <linux-media@vger.kernel.org>; Thu, 22 Nov 2018 02:30:04 -0800 (PST)
MIME-Version: 1.0
References: <20181121195846.23676-1-ezequiel@collabora.com>
In-Reply-To: <20181121195846.23676-1-ezequiel@collabora.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Thu, 22 Nov 2018 19:29:52 +0900
Message-ID: <CAAFQd5AtFb0icwOr5h06XL3KyU1YJnh9nHnQ8gHLJhXi=StNgg@mail.gmail.com>
Subject: Re: [PATCH v10 3/4] arm64: dts: rockchip: add VPU device node for RK3399
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

On Thu, Nov 22, 2018 at 4:58 AM Ezequiel Garcia <ezequiel@collabora.com> wrote:
>
> Add the Video Processing Unit node for the RK3399 SoC.
>
> Also, fix the VPU IOMMU node, which was disabled and lacking
> its power domain property.
>
> Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
> ---
>  arch/arm64/boot/dts/rockchip/rk3399.dtsi | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/boot/dts/rockchip/rk3399.dtsi b/arch/arm64/boot/dts/rockchip/rk3399.dtsi
> index 99e7f65c1779..040d3080565f 100644
> --- a/arch/arm64/boot/dts/rockchip/rk3399.dtsi
> +++ b/arch/arm64/boot/dts/rockchip/rk3399.dtsi
> @@ -1226,6 +1226,18 @@
>                 status = "disabled";
>         };
>
> +       vpu: video-codec@ff650000 {
> +               compatible = "rockchip,rk3399-vpu";
> +               reg = <0x0 0xff650000 0x0 0x800>;
> +               interrupts = <GIC_SPI 114 IRQ_TYPE_LEVEL_HIGH 0>,
> +                            <GIC_SPI 113 IRQ_TYPE_LEVEL_HIGH 0>;
> +               interrupt-names = "vepu", "vdpu";
> +               clocks = <&cru ACLK_VCODEC>, <&cru HCLK_VCODEC>;
> +               clock-names = "aclk", "hclk";
> +               power-domains = <&power RK3399_PD_VCODEC>;
> +               iommus = <&vpu_mmu>;
> +       };
> +
>         vpu_mmu: iommu@ff650800 {
>                 compatible = "rockchip,iommu";
>                 reg = <0x0 0xff650800 0x0 0x40>;
> @@ -1233,8 +1245,8 @@
>                 interrupt-names = "vpu_mmu";
>                 clocks = <&cru ACLK_VCODEC>, <&cru HCLK_VCODEC>;
>                 clock-names = "aclk", "iface";
> +               power-domains = <&power RK3399_PD_VCODEC>;
>                 #iommu-cells = <0>;
> -               status = "disabled";
>         };
>
>         vdec_mmu: iommu@ff660480 {


Reviewed-by: Tomasz Figa <tfiga@chromium.org>

Best regards,
Tomasz
