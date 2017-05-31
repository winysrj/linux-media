Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36388 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751130AbdEaNEK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 May 2017 09:04:10 -0400
Subject: Re: [PATCH v9 3/4] arm: dts: mt2701: Add node for Mediatek JPEG
 Decoder
From: Matthias Brugger <matthias.bgg@gmail.com>
To: Rick Chang <rick.chang@mediatek.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        srv_heupstream@mediatek.com, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Minghsiu Tsai <minghsiu.tsai@mediatek.com>,
        Bin Liu <bin.liu@mediatek.com>
References: <1481702690-10476-1-git-send-email-rick.chang@mediatek.com>
 <1481702690-10476-4-git-send-email-rick.chang@mediatek.com>
 <492cfa38-aff0-f7c9-72f9-94e53adc198c@gmail.com>
Message-ID: <35da3376-cc23-b588-c026-b3d300f6ecfa@gmail.com>
Date: Wed, 31 May 2017 15:04:06 +0200
MIME-Version: 1.0
In-Reply-To: <492cfa38-aff0-f7c9-72f9-94e53adc198c@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 10/05/17 13:02, Matthias Brugger wrote:
> 
> 
> On 14/12/16 09:04, Rick Chang wrote:
>> Signed-off-by: Rick Chang <rick.chang@mediatek.com>
>> Signed-off-by: Minghsiu Tsai <minghsiu.tsai@mediatek.com>
>> ---
>> This patch depends on:
>>    CCF "Add clock support for Mediatek MT2701"[1]
>>    iommu and smi "Add the dtsi node of iommu and smi for mt2701"[2]
>>
>> [1] 
>> http://lists.infradead.org/pipermail/linux-mediatek/2016-October/007271.html 
>>
>> [2] https://patchwork.kernel.org/patch/9164013/
> 
> Now queued for v4.12-next/dts32
> 
> Thanks and sorry for the delay.
> Matthias
> 

I realized that a long time ago I made a mistake when taking:
f3cba0f49c7c ("ARM: dts: mt2701: add iommu/smi dtsi node for mt2701")

as I forgot to include dt-bindings/memory/mt2701-larb-port.h

I fixed this now in v4.12-next/dts32

Sorry for that.

Regards,
Matthias

>> ---
>>   arch/arm/boot/dts/mt2701.dtsi | 14 ++++++++++++++
>>   1 file changed, 14 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/mt2701.dtsi 
>> b/arch/arm/boot/dts/mt2701.dtsi
>> index 8f13c70..4dd5048 100644
>> --- a/arch/arm/boot/dts/mt2701.dtsi
>> +++ b/arch/arm/boot/dts/mt2701.dtsi
>> @@ -298,6 +298,20 @@
>>           power-domains = <&scpsys MT2701_POWER_DOMAIN_ISP>;
>>       };
>> +    jpegdec: jpegdec@15004000 {
>> +        compatible = "mediatek,mt2701-jpgdec";
>> +        reg = <0 0x15004000 0 0x1000>;
>> +        interrupts = <GIC_SPI 143 IRQ_TYPE_LEVEL_LOW>;
>> +        clocks =  <&imgsys CLK_IMG_JPGDEC_SMI>,
>> +              <&imgsys CLK_IMG_JPGDEC>;
>> +        clock-names = "jpgdec-smi",
>> +                  "jpgdec";
>> +        power-domains = <&scpsys MT2701_POWER_DOMAIN_ISP>;
>> +        mediatek,larb = <&larb2>;
>> +        iommus = <&iommu MT2701_M4U_PORT_JPGDEC_WDMA>,
>> +             <&iommu MT2701_M4U_PORT_JPGDEC_BSDMA>;
>> +    };
>> +
>>       vdecsys: syscon@16000000 {
>>           compatible = "mediatek,mt2701-vdecsys", "syscon";
>>           reg = <0 0x16000000 0 0x1000>;
>>
