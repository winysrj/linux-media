Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36804 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726330AbeHXQBQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Aug 2018 12:01:16 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Fri, 24 Aug 2018 17:56:47 +0530
From: Vikash Garodia <vgarodia@codeaurora.org>
To: Alexandre Courbot <acourbot@chromium.org>
Cc: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>, robh@kernel.org,
        mark.rutland@arm.com, Andy Gross <andy.gross@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, bjorn.andersson@linaro.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, linux-soc@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v6 3/4] venus: firmware: add no TZ boot and shutdown
 routine
In-Reply-To: <CAPBb6MV1jjksgbSaCuUcY_ZbjfGeK-GaQ_+OZ7LWUv4ehA3dGQ@mail.gmail.com>
References: <1535034528-11590-1-git-send-email-vgarodia@codeaurora.org>
 <1535034528-11590-4-git-send-email-vgarodia@codeaurora.org>
 <CAPBb6MV1jjksgbSaCuUcY_ZbjfGeK-GaQ_+OZ7LWUv4ehA3dGQ@mail.gmail.com>
Message-ID: <9e9417cf2fccfed4015f6893045e4f7f@codeaurora.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alex,

On 2018-08-24 13:09, Alexandre Courbot wrote:
> On Thu, Aug 23, 2018 at 11:29 PM Vikash Garodia 
> <vgarodia@codeaurora.org> wrote:

[snip]

>> +struct video_firmware {
>> +       struct device *dev;
>> +       struct iommu_domain *iommu_domain;
>> +};
>> +
>>  /**
>>   * struct venus_core - holds core parameters valid for all instances
>>   *
>> @@ -98,6 +103,7 @@ struct venus_caps {
>>   * @dev:               convenience struct device pointer
>>   * @dev_dec:   convenience struct device pointer for decoder device
>>   * @dev_enc:   convenience struct device pointer for encoder device
>> + * @fw:                a struct for venus firmware info
>>   * @no_tz:     a flag that suggests presence of trustzone
>>   * @lock:      a lock for this strucure
>>   * @instances: a list_head of all instances
>> @@ -130,6 +136,7 @@ struct venus_core {
>>         struct device *dev;
>>         struct device *dev_dec;
>>         struct device *dev_enc;
>> +       struct video_firmware fw;
> 
> Since struct video_firmware is only used here I think you can declare
> it inline, i.e.
> 
>     struct {
>         struct device *dev;
>         struct iommu_domain *iommu_domain;
>     } fw;
> 
> This structure is actually a good candidate to hold the firmware
> memory area start address and size.

I can make it inline.
Memory area and size are common parameters populated
locally while loading the firmware with or without tz. Firmware struct 
has
info more specific to firmware device.

[snip]

> 
>> +{
>> +       struct iommu_domain *iommu_dom;
>> +       struct device *dev;
>> +       int ret;
>> +
>> +       dev = core->fw.dev;
>> +       if (!dev)
>> +               return -EPROBE_DEFER;
>> +
>> +       iommu_dom = iommu_domain_alloc(&platform_bus_type);
>> +       if (!iommu_dom) {
>> +               dev_err(dev, "Failed to allocate iommu domain\n");
>> +               return -ENOMEM;
>> +       }
>> +
>> +       ret = iommu_attach_device(iommu_dom, dev);
>> +       if (ret) {
>> +               dev_err(dev, "could not attach device\n");
>> +               goto err_attach;
>> +       }
> 
> I think like the above belongs more in venus_firmware_init()
> (introduced in patch 4/4) than here. There is no reason to
> detach/reattach the iommu if we stop the firmware.

Consider the case when we want to reload the firmware during error 
recovery.
Boot and shutdown will be needed in such case without the need to 
populate
the firmware device again.

[snip]

>> +static int venus_shutdown_no_tz(struct venus_core *core)
>> +{
>> +       struct iommu_domain *iommu;
>> +       size_t unmapped;
>> +       u32 reg;
>> +       struct device *dev = core->fw.dev;
>> +       void __iomem *base = core->base;
>> +
>> +       /* Assert the reset to ARM9 */
>> +       reg = readl_relaxed(base + WRAPPER_A9SS_SW_RESET);
>> +       reg |= WRAPPER_A9SS_SW_RESET_BIT;
>> +       writel_relaxed(reg, base + WRAPPER_A9SS_SW_RESET);
>> +
>> +       /* Make sure reset is asserted before the mapping is removed 
>> */
>> +       mb();
>> +
>> +       iommu = core->fw.iommu_domain;
>> +
>> +       unmapped = iommu_unmap(iommu, VENUS_FW_START_ADDR, 
>> VENUS_FW_MEM_SIZE);
>> +       if (unmapped != VENUS_FW_MEM_SIZE)
>> +               dev_err(dev, "failed to unmap firmware\n");
>> +
>> +       iommu_detach_device(iommu, dev);
>> +       iommu_domain_free(iommu);
> 
> Accordingly, this would also be moved into venus_firmware_deinit().

Same explanation here as well.

Thanks,
Vikash
