Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:60222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750828AbdBWNQj (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 23 Feb 2017 08:16:39 -0500
MIME-Version: 1.0
In-Reply-To: <ced61ede-1d51-18c1-ea00-731dc5887c58@linaro.org>
References: <1486473024-21705-1-git-send-email-stanimir.varbanov@linaro.org>
 <1486473024-21705-3-git-send-email-stanimir.varbanov@linaro.org>
 <20170222000952.w6bg4bhvbklgkcnx@rob-hp-laptop> <88584dd3-165f-2393-433e-95c288a8f473@linaro.org>
 <CAL_JsqJ0+YEcw1-DgWpHgdDe4zfppNnpLt6XY=CGnMYwu8ALhw@mail.gmail.com> <ced61ede-1d51-18c1-ea00-731dc5887c58@linaro.org>
From: Rob Herring <robh@kernel.org>
Date: Thu, 23 Feb 2017 07:16:15 -0600
Message-ID: <CAL_JsqLwEz1tX9H2DgDZ3a20L=NcPOB=0zqaWyHKEFRffZJ9Zg@mail.gmail.com>
Subject: Re: [PATCH v6 2/9] doc: DT: venus: binding document for Qualcomm
 video driver
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Andy Gross <andy.gross@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Feb 23, 2017 at 7:08 AM, Stanimir Varbanov
<stanimir.varbanov@linaro.org> wrote:
>
>
> On 02/22/2017 04:17 PM, Rob Herring wrote:
>> On Wed, Feb 22, 2017 at 3:25 AM, Stanimir Varbanov
>> <stanimir.varbanov@linaro.org> wrote:
>>> Hi Rob,
>>>
>>> On 02/22/2017 02:09 AM, Rob Herring wrote:
>>>> On Tue, Feb 07, 2017 at 03:10:17PM +0200, Stanimir Varbanov wrote:
>>>>> Add binding document for Venus video encoder/decoder driver
>>>>>
>>>>> Cc: Rob Herring <robh+dt@kernel.org>
>>>>> Cc: devicetree@vger.kernel.org
>>>>> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
>>>>> ---
>>>>> Changes since previous v5:
>>>>>  * dropped rproc phandle (remoteproc is not used anymore)
>>>>>  * added subnodes paragraph with descrition of three subnodes:
>>>>>     - video-decoder and video-encoder - describes decoder (core0) and
>>>>>     encoder (core1) power-domains and clocks (applicable for msm8996
>>>>>     Venus core).
>>>>>     - video-firmware - needed to get reserved memory region where the
>>>>>     firmware is stored.
>>>>>
>>>>>  .../devicetree/bindings/media/qcom,venus.txt       | 112 +++++++++++++++++++++
>>>>>  1 file changed, 112 insertions(+)
>>>>>  create mode 100644 Documentation/devicetree/bindings/media/qcom,venus.txt
>>>>>
>>>>> diff --git a/Documentation/devicetree/bindings/media/qcom,venus.txt b/Documentation/devicetree/bindings/media/qcom,venus.txt
>>>>> new file mode 100644
>>>>> index 000000000000..4427af3ca5a5
>>>>> --- /dev/null
>>>>> +++ b/Documentation/devicetree/bindings/media/qcom,venus.txt
>>>>> @@ -0,0 +1,112 @@
>>>>
>>>> [...]
>>>>
>>>>> +* Subnodes
>>>>> +The Venus node must contain three subnodes representing video-decoder,
>>>>> +video-encoder and video-firmware.
>>>>
>>>> [...]
>>>>
>>>>> +The video-firmware subnode should contain:
>>>>> +
>>>>> +- memory-region:
>>>>> +    Usage: required
>>>>> +    Value type: <phandle>
>>>>> +    Definition: reference to the reserved-memory for the memory region
>>>>> +
>>>>> +* An Example
>>>>> +    video-codec@1d00000 {
>>>>> +            compatible = "qcom,msm8916-venus";
>>>>> +            reg = <0x01d00000 0xff000>;
>>>>> +            interrupts = <GIC_SPI 44 IRQ_TYPE_LEVEL_HIGH>;
>>>>> +            clocks = <&gcc GCC_VENUS0_VCODEC0_CLK>,
>>>>> +                     <&gcc GCC_VENUS0_AHB_CLK>,
>>>>> +                     <&gcc GCC_VENUS0_AXI_CLK>;
>>>>> +            clock-names = "core", "iface", "bus";
>>>>> +            power-domains = <&gcc VENUS_GDSC>;
>>>>> +            iommus = <&apps_iommu 5>;
>>>>> +
>>>>> +            video-decoder {
>>>>> +                    compatible = "venus-decoder";
>>>>> +                    clocks = <&mmcc VIDEO_SUBCORE0_CLK>;
>>>>> +                    clock-names = "core";
>>>>> +                    power-domains = <&mmcc VENUS_CORE0_GDSC>;
>>>>> +            };
>>>>> +
>>>>> +            video-encoder {
>>>>> +                    compatible = "venus-encoder";
>>>>> +                    clocks = <&mmcc VIDEO_SUBCORE1_CLK>;
>>>>> +                    clock-names = "core";
>>>>> +                    power-domains = <&mmcc VENUS_CORE1_GDSC>;
>>>>> +            };
>>>>> +
>>>>> +            video-firmware {
>>>>> +                    memory-region = <&venus_mem>;
>>>>
>>>> Why does this need to be a sub node?
>>>
>>> Because firmware reserved memory region must have separate struct
>>> device, otherwise allocating video buffers (and map them through iommu)
>>> for video-codec will fail because dma_alloc_coherent trying to allocate
>>> from per-device coherent area.
>>
>> Why can't the struct device be the video-codec device? Looking at the
>> code, I don't see why you need the 2nd struct device.
>
> The issue when using one device (video-codec device) is coming from
> dma_alloc_from_coherent() which is called by dma_alloc_attrs(). The
> firmware memory-region is parsed and initialize coherent memory such a
> region with flag DMA_MEMORY_EXCLUSIVE which means that following
> invocations of dma_alloc_coherent (for example to allocate video buffers
> and map them through IOMMU) will no fallback to generic memory allocator
> i.e. dma_ops. Because Venus is behind IOMMU the dma_ops are pointing to
> iommu_dma_ops for ARM64.
>
>>
>> In any case, this is letting the driver design the binding which is
>> wrong. From a binding perspective, there's no reason to have this
>> node.
>
> OK, thanks for the comments. I have few changes in the firmware memory
> allocation part of the driver which makes possible to remove
> video-firmware subnode and move memory-region to video-codec DT node.
>
> Is that fine for you?

Yes. With that change:

Acked-by: Rob Herring <robh@kernel.org>
