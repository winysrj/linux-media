Return-Path: <SRS0=W9AE=PO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8D1EC43387
	for <linux-media@archiver.kernel.org>; Sun,  6 Jan 2019 16:15:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 780E42070D
	for <linux-media@archiver.kernel.org>; Sun,  6 Jan 2019 16:15:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbfAFQP5 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-media@archiver.kernel.org>);
        Sun, 6 Jan 2019 11:15:57 -0500
Received: from kozue.soulik.info ([108.61.200.231]:41006 "EHLO
        kozue.soulik.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726341AbfAFQP5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 6 Jan 2019 11:15:57 -0500
Received: from [192.168.0.49] (unknown [192.168.0.49])
        by kozue.soulik.info (Postfix) with ESMTPSA id F2D25100F5C;
        Mon,  7 Jan 2019 01:16:33 +0900 (JST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH 4/4] arm64: dts: rockchip: add video codec for rk3399
From:   Ayaka <ayaka@soulik.info>
X-Mailer: iPad Mail (16A404)
In-Reply-To: <f3dcd25bb1c3f0544cb7eedd0b27633d923c0d27.camel@collabora.com>
Date:   Mon, 7 Jan 2019 00:15:48 +0800
Cc:     linux-rockchip@lists.infradead.org,
        Tomasz Figa <tfiga@chromium.org>,
        nicolas.dufresne@collabora.com, myy@miouyouyou.fr,
        paul.kocialkowski@bootlin.com, mchehab@kernel.org,
        linux-media@vger.kernel.org, hverkuil@xs4all.nl, heiko@sntech.de,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <C53B5CFA-2F9C-41E1-BBA8-D63819D0AC3D@soulik.info>
References: <20190105183150.20266-1-ayaka@soulik.info> <20190105183150.20266-5-ayaka@soulik.info> <50db3bc3faea97182b7fe18b4d9677f7e1563eaa.camel@collabora.com> <CAC7DE03-A74C-4154-9443-BC91E6CED02E@soulik.info> <f3dcd25bb1c3f0544cb7eedd0b27633d923c0d27.camel@collabora.com>
To:     Ezequiel Garcia <ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org



Sent from my iPad

> On Jan 7, 2019, at 12:04 AM, Ezequiel Garcia <ezequiel@collabora.com> wrote:
> 
> On Sun, 2019-01-06 at 23:05 +0800, Ayaka wrote:
>>> On Jan 6, 2019, at 10:22 PM, Ezequiel Garcia <ezequiel@collabora.com> wrote:
>>> 
>>> Hi Randy,
>>> 
>>> Thanks a lot for this patches. They are really useful
>>> to provide more insight into the VPU hardware.
>>> 
>>> This change will make the vpu encoder and vpu decoder
>>> completely independent, can they really work in parallel?
>> As I said it depends on the platform, but with this patch, the user space would think they can work at the same time.
> 
> 
> I think there is some confusion.
> 
> The devicetree is one thing: it is a hardware representation,
> a way to describe the hardware, for the kernel/bootloader to
> parse.
> 
> The userspace view will depend on the driver implementation.
> 
> The current devicetree and driver (without your patches),
> model the VPU as a single piece of hardware, exposing a decoder
> and an encoder.
> 
> The V4L driver will then create two video devices, i.e. /dev/videoX
> and /dev/videoY. So userspace sees an independent view of the
> devices.
> 
I knew that, the problem is that the driver should not always create a decoder and encoder pair, they may not exist at some platforms, even some platforms doesn’t have a encoder. You may have a look on the rk3328 I post on the first email as example.
> However, they are internally connected, and thus we can
> easily avoid two jobs running in parallel.
> 
That is what the mpp service did in my patches, handing the relationship between each devices. And it is not a easy work, maybe a 4k decoder would be blocked by another high frame rate encoding work or another decoder session. The vendor kernel have more worry about this,  but not in this version.
> So, in other words, if the VPU can issue a decoder and encoder
> job in parallel, then it's useful to model it as two independent
> devices. Otherwise, it's better not to.
> 
> I hope this can clarify things a bit for you!
> 
I would review the request API for those codecs structures and some basic designs, people from LibreELEC told me a few noticed inform.
> PS: Too bad I won't be at FOSDEM to discuss this personally.
I am sure Paulk from bootlin would be there and some others guy related, I have not cared about this for a little long time, there are more huge problem I should point out now.
> 
> Thanks,
> Ezequiel
> 
>> BTW, not only the decoder, there is a post processor with the decoder, it can be used as part of the decoder pipeline with only a macro block delay
>> or process the data from an external buffer.
>> I forget to write a note on what this driver doesn’t present. The real one would have much complex scheduler system, but this one is just a queue.
>> More task management feature are not there.
>> Also the clock boosting is removing and the loading analysis, which are useful for encoder, especially on the rv1108.
>>> Could you provide more details about what is
>>> shared between these devices?
>> No, if Rockchip doesn’t tell, my mouth is sealed.
>>> Thanks a lot!
>>> 
>>>> On Sun, 2019-01-06 at 02:31 +0800, Randy Li wrote:
>>>> It offers an example how a full features video codec
>>>> should be configured.
>>>> 
>>>> The original clocks assignment don't look good, if the clocks
>>>> lower than 300MHZ, most of decoing tasks would suffer from
>>>> timeout problem, 500MHZ is also a little high for RK3399
>>>> running in a stable state.
>>>> 
>>>> Signed-off-by: Randy Li <ayaka@soulik.info>
>>>> ---
>>>> .../boot/dts/rockchip/rk3399-sapphire.dtsi    | 29 ++++++++
>>>> arch/arm64/boot/dts/rockchip/rk3399.dtsi      | 68 +++++++++++++++++--
>>>> 2 files changed, 90 insertions(+), 7 deletions(-)
>>>> 
>>>> diff --git a/arch/arm64/boot/dts/rockchip/rk3399-sapphire.dtsi b/arch/arm64/boot/dts/rockchip/rk3399-sapphire.dtsi
>>>> index 946d3589575a..c3db878bae45 100644
>>>> --- a/arch/arm64/boot/dts/rockchip/rk3399-sapphire.dtsi
>>>> +++ b/arch/arm64/boot/dts/rockchip/rk3399-sapphire.dtsi
>>>> @@ -632,6 +632,35 @@
>>>>  dr_mode = "host";
>>>> };
>>>> 
>>>> +&rkvdec {
>>>> +    status = "okay";
>>>> +};
>>>> +
>>>> +&rkvdec_srv {
>>>> +    status = "okay";
>>>> +};
>>>> +
>>>> +&vdec_mmu {
>>>> +    status = "okay";
>>>> +};
>>>> +
>>>> +&vdpu {
>>>> +    status = "okay";
>>>> +};
>>>> +
>>>> +&vepu {
>>>> +    status = "okay";
>>>> +};
>>>> +
>>>> +&vpu_service {
>>>> +    status = "okay";
>>>> +};
>>>> +
>>>> +&vpu_mmu {
>>>> +    status = "okay";
>>>> +
>>>> +};
>>>> +
>>>> &vopb {
>>>>  status = "okay";
>>>> };
>>>> diff --git a/arch/arm64/boot/dts/rockchip/rk3399.dtsi b/arch/arm64/boot/dts/rockchip/rk3399.dtsi
>>>> index b22b2e40422b..5fa3247e7bf0 100644
>>>> --- a/arch/arm64/boot/dts/rockchip/rk3399.dtsi
>>>> +++ b/arch/arm64/boot/dts/rockchip/rk3399.dtsi
>>>> @@ -1242,16 +1242,39 @@
>>>>      status = "disabled";
>>>>  };
>>>> 
>>>> -    vpu: video-codec@ff650000 {
>>>> -        compatible = "rockchip,rk3399-vpu";
>>>> -        reg = <0x0 0xff650000 0x0 0x800>;
>>>> -        interrupts = <GIC_SPI 114 IRQ_TYPE_LEVEL_HIGH 0>,
>>>> -                 <GIC_SPI 113 IRQ_TYPE_LEVEL_HIGH 0>;
>>>> -        interrupt-names = "vepu", "vdpu";
>>>> +    vpu_service: vpu-srv {
>>>> +        compatible = "rockchip,mpp-service";
>>>> +        status = "disabled";
>>>> +    };
>>>> +
>>>> +    vepu: vpu-encoder@ff650000 {
>>>> +        compatible = "rockchip,vpu-encoder-v2";
>>>> +        reg = <0x0 0xff650000 0x0 0x400>;
>>>> +        interrupts = <GIC_SPI 114 IRQ_TYPE_LEVEL_HIGH 0>;
>>>> +        interrupt-names = "irq_enc";
>>>>      clocks = <&cru ACLK_VCODEC>, <&cru HCLK_VCODEC>;
>>>> -        clock-names = "aclk", "hclk";
>>>> +        clock-names = "aclk_vcodec", "hclk_vcodec";
>>>> +        resets = <&cru SRST_H_VCODEC>, <&cru SRST_A_VCODEC>;
>>>> +        reset-names = "video_h", "video_a";
>>>>      iommus = <&vpu_mmu>;
>>>>      power-domains = <&power RK3399_PD_VCODEC>;
>>>> +        rockchip,srv = <&vpu_service>;
>>>> +        status = "disabled";
>>>> +    };
>>>> +
>>>> +    vdpu: vpu-decoder@ff650400 {
>>>> +        compatible = "rockchip,vpu-decoder-v2";
>>>> +        reg = <0x0 0xff650400 0x0 0x400>;
>>>> +        interrupts = <GIC_SPI 113 IRQ_TYPE_LEVEL_HIGH 0>;
>>>> +        interrupt-names = "irq_dec";
>>>> +        iommus = <&vpu_mmu>;
>>>> +        clocks = <&cru ACLK_VCODEC>, <&cru HCLK_VCODEC>;
>>>> +        clock-names = "aclk_vcodec", "hclk_vcodec";
>>>> +        resets = <&cru SRST_H_VCODEC>, <&cru SRST_A_VCODEC>;
>>>> +        reset-names = "video_h", "video_a";
>>>> +        power-domains = <&power RK3399_PD_VCODEC>;
>>>> +        rockchip,srv = <&vpu_service>;
>>>> +        status = "disabled";
>>>>  };
>>>> 
>>>>  vpu_mmu: iommu@ff650800 {
>>>> @@ -1261,11 +1284,42 @@
>>>>      interrupt-names = "vpu_mmu";
>>>>      clocks = <&cru ACLK_VCODEC>, <&cru HCLK_VCODEC>;
>>>>      clock-names = "aclk", "iface";
>>>> +        assigned-clocks = <&cru ACLK_VCODEC_PRE>;
>>>> +        assigned-clock-parents = <&cru PLL_GPLL>;
>>>>      #iommu-cells = <0>;
>>>>      power-domains = <&power RK3399_PD_VCODEC>;
>>>>      status = "disabled";
>>>>  };
>>>> 
>>>> +    rkvdec_srv: rkvdec-srv {
>>>> +        compatible = "rockchip,mpp-service";
>>>> +        status = "disabled";
>>>> +    };
>>>> +
>>>> +    rkvdec: video-decoder@ff660000 {
>>>> +        compatible = "rockchip,video-decoder-v1";
>>>> +        reg = <0x0 0xff660000 0x0 0x400>;
>>>> +        interrupts = <GIC_SPI 116 IRQ_TYPE_LEVEL_HIGH 0>;
>>>> +        interrupt-names = "irq_dec";
>>>> +        clocks = <&cru ACLK_VDU>, <&cru HCLK_VDU>,
>>>> +             <&cru SCLK_VDU_CA>, <&cru SCLK_VDU_CORE>;
>>>> +        clock-names = "aclk_vcodec", "hclk_vcodec",
>>>> +                  "clk_cabac", "clk_core";
>>>> +        assigned-clocks = <&cru ACLK_VDU_PRE>, <&cru SCLK_VDU_CA>,
>>>> +                  <&cru SCLK_VDU_CORE>;
>>>> +        assigned-clock-parents = <&cru PLL_NPLL>, <&cru PLL_NPLL>,
>>>> +                     <&cru PLL_NPLL>;
>>>> +        resets = <&cru SRST_H_VDU>, <&cru SRST_A_VDU>,
>>>> +             <&cru SRST_VDU_CORE>, <&cru SRST_VDU_CA>,
>>>> +             <&cru SRST_A_VDU_NOC>, <&cru SRST_H_VDU_NOC>;
>>>> +        reset-names = "video_h", "video_a", "video_core", "video_cabac",
>>>> +                  "niu_a", "niu_h";
>>>> +        power-domains = <&power RK3399_PD_VDU>;
>>>> +        rockchip,srv = <&rkvdec_srv>;
>>>> +        iommus = <&vdec_mmu>;
>>>> +        status = "disabled";
>>>> +    };
>>>> +
>>>>  vdec_mmu: iommu@ff660480 {
>>>>      compatible = "rockchip,iommu";
>>>>      reg = <0x0 0xff660480 0x0 0x40>, <0x0 0xff6604c0 0x0 0x40>;
> 
> 

