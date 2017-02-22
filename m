Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:35253 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754510AbdBVJZX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 22 Feb 2017 04:25:23 -0500
Received: by mail-wm0-f54.google.com with SMTP id v186so134963128wmd.0
        for <linux-media@vger.kernel.org>; Wed, 22 Feb 2017 01:25:22 -0800 (PST)
Subject: Re: [PATCH v6 2/9] doc: DT: venus: binding document for Qualcomm
 video driver
To: Rob Herring <robh@kernel.org>
References: <1486473024-21705-1-git-send-email-stanimir.varbanov@linaro.org>
 <1486473024-21705-3-git-send-email-stanimir.varbanov@linaro.org>
 <20170222000952.w6bg4bhvbklgkcnx@rob-hp-laptop>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Andy Gross <andy.gross@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <88584dd3-165f-2393-433e-95c288a8f473@linaro.org>
Date: Wed, 22 Feb 2017 11:25:19 +0200
MIME-Version: 1.0
In-Reply-To: <20170222000952.w6bg4bhvbklgkcnx@rob-hp-laptop>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rob,

On 02/22/2017 02:09 AM, Rob Herring wrote:
> On Tue, Feb 07, 2017 at 03:10:17PM +0200, Stanimir Varbanov wrote:
>> Add binding document for Venus video encoder/decoder driver
>>
>> Cc: Rob Herring <robh+dt@kernel.org>
>> Cc: devicetree@vger.kernel.org
>> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
>> ---
>> Changes since previous v5:
>>  * dropped rproc phandle (remoteproc is not used anymore)
>>  * added subnodes paragraph with descrition of three subnodes:
>>     - video-decoder and video-encoder - describes decoder (core0) and
>>     encoder (core1) power-domains and clocks (applicable for msm8996
>>     Venus core).
>>     - video-firmware - needed to get reserved memory region where the
>>     firmware is stored.
>>
>>  .../devicetree/bindings/media/qcom,venus.txt       | 112 +++++++++++++++++++++
>>  1 file changed, 112 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/media/qcom,venus.txt
>>
>> diff --git a/Documentation/devicetree/bindings/media/qcom,venus.txt b/Documentation/devicetree/bindings/media/qcom,venus.txt
>> new file mode 100644
>> index 000000000000..4427af3ca5a5
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/media/qcom,venus.txt
>> @@ -0,0 +1,112 @@
> 
> [...]
> 
>> +* Subnodes
>> +The Venus node must contain three subnodes representing video-decoder,
>> +video-encoder and video-firmware.
> 
> [...]
> 
>> +The video-firmware subnode should contain:
>> +
>> +- memory-region:
>> +	Usage: required
>> +	Value type: <phandle>
>> +	Definition: reference to the reserved-memory for the memory region
>> +
>> +* An Example
>> +	video-codec@1d00000 {
>> +		compatible = "qcom,msm8916-venus";
>> +		reg = <0x01d00000 0xff000>;
>> +		interrupts = <GIC_SPI 44 IRQ_TYPE_LEVEL_HIGH>;
>> +		clocks = <&gcc GCC_VENUS0_VCODEC0_CLK>,
>> +			 <&gcc GCC_VENUS0_AHB_CLK>,
>> +			 <&gcc GCC_VENUS0_AXI_CLK>;
>> +		clock-names = "core", "iface", "bus";
>> +		power-domains = <&gcc VENUS_GDSC>;
>> +		iommus = <&apps_iommu 5>;
>> +
>> +		video-decoder {
>> +			compatible = "venus-decoder";
>> +			clocks = <&mmcc VIDEO_SUBCORE0_CLK>;
>> +			clock-names = "core";
>> +			power-domains = <&mmcc VENUS_CORE0_GDSC>;
>> +		};
>> +
>> +		video-encoder {
>> +			compatible = "venus-encoder";
>> +			clocks = <&mmcc VIDEO_SUBCORE1_CLK>;
>> +			clock-names = "core";
>> +			power-domains = <&mmcc VENUS_CORE1_GDSC>;
>> +		};
>> +
>> +		video-firmware {
>> +			memory-region = <&venus_mem>;
> 
> Why does this need to be a sub node?

Because firmware reserved memory region must have separate struct
device, otherwise allocating video buffers (and map them through iommu)
for video-codec will fail because dma_alloc_coherent trying to allocate
from per-device coherent area.

-- 
regards,
Stan
