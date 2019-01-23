Return-Path: <SRS0=FDnu=P7=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 665BDC282C2
	for <linux-media@archiver.kernel.org>; Wed, 23 Jan 2019 10:06:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 267C920870
	for <linux-media@archiver.kernel.org>; Wed, 23 Jan 2019 10:06:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="Jc7pOUow"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727403AbfAWKGB (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 23 Jan 2019 05:06:01 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34306 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727237AbfAWKGB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Jan 2019 05:06:01 -0500
Received: by mail-wr1-f65.google.com with SMTP id f7so1707132wrp.1
        for <linux-media@vger.kernel.org>; Wed, 23 Jan 2019 02:05:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ynBOsX/eqcl033dteY412McLrMDqBA/LXk1X+SVFGpY=;
        b=Jc7pOUowJW7eIQU0oz3Sik7FbKI2DmRHpoTq6RIzN0oUdAhfaBc4zNZA2+LFmHx8tw
         PqEfPboALMN73rUHodFup3gEi/qmwtyAdPJBAlZSAsKYA6oC633KcBGqjM2ec11Ltkvx
         svtcCeCh/GK12eNvL5w7eRjQ2TlOrmZGslVjU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ynBOsX/eqcl033dteY412McLrMDqBA/LXk1X+SVFGpY=;
        b=QJB0Nj13fl7z46uoTMobZ2XVnktV4rCzW57zxIeibP7SQkkHsrdZVfZ9TDAgeT8cco
         ax7eEIvNJNDargYOatJd6TgzdZ2CCtt3MMXs1U+vm8Ka+2vsyUIHq/HT91b9mjY5UxmT
         LQQPN9v9z2YruQMSMJ8k29PoWPX35EPn6uQeHnCqMIShdFpkzvnnYWQf5JuPp3IJFNd3
         TCiPh53jYEky+hSUV6HF/zP76+rIFRNZwAAPT2nOBnOiuDYF/Sw7t2+8OmwagYyqlAL8
         a9hcsSPo/kLNL09kRLgI3oRpsEqvpxJ6/zHK2xrlcjK9yjTwqNqYreF3wDfSA7FsTXZv
         pGvQ==
X-Gm-Message-State: AJcUukcNiCuLKFqNdgk64SDN8map9VvDn6hBtuY1cLVV0SdIUoKzi+pw
        NU5phQQwMPFJUX1vbbQ1uVFSww==
X-Google-Smtp-Source: ALg8bN4goearlpBcfWPe3c/N1l03u9+xqpktnxZ1tGU6knJ/VQ2FJtGrKrQ1YvijdlmxlydFBG0inQ==
X-Received: by 2002:adf:9d4c:: with SMTP id o12mr1849180wre.94.1548237958936;
        Wed, 23 Jan 2019 02:05:58 -0800 (PST)
Received: from [192.168.27.209] ([37.157.136.206])
        by smtp.googlemail.com with ESMTPSA id j14sm81889107wrv.96.2019.01.23.02.05.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Jan 2019 02:05:58 -0800 (PST)
Subject: Re: [PATCH 1/4] venus: firmware: check fw size against DT memory
 region size
To:     Alexandre Courbot <acourbot@chromium.org>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org,
        Vikash Garodia <vgarodia@codeaurora.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Malathi Gottam <mgottam@codeaurora.org>
References: <20190109084616.17162-1-stanimir.varbanov@linaro.org>
 <20190109084616.17162-2-stanimir.varbanov@linaro.org>
 <CAPBb6MXr-oLaLUjyPmUf5uFwSLv9WOs17YjnRp_bV8VhZpsosw@mail.gmail.com>
From:   Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <e6ec0925-2a60-6006-4d3b-218014e601fc@linaro.org>
Date:   Wed, 23 Jan 2019 12:05:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <CAPBb6MXr-oLaLUjyPmUf5uFwSLv9WOs17YjnRp_bV8VhZpsosw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Alex,

Thanks for the review!

On 1/23/19 8:10 AM, Alexandre Courbot wrote:
> Sorry for the delayed review! >_<
> 
> On Wed, Jan 9, 2019 at 5:46 PM Stanimir Varbanov
> <stanimir.varbanov@linaro.org> wrote:
>>
>> By historical reasons we defined firmware memory size to be 6MB even
>> that the firmware size for all supported Venus versions is 5MBs. Correct
>> that by compare the required firmware size returned from mdt loader and
>> the one provided by DT reserved memory region. We proceed further if the
>> required firmware size is smaller than provided by DT memory region.
>>
>> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
>> ---
>>  drivers/media/platform/qcom/venus/core.h     |  1 +
>>  drivers/media/platform/qcom/venus/firmware.c | 54 +++++++++++---------
>>  2 files changed, 31 insertions(+), 24 deletions(-)
>>
>> diff --git a/drivers/media/platform/qcom/venus/core.h b/drivers/media/platform/qcom/venus/core.h
>> index 6382cea29185..79c7e816c706 100644
>> --- a/drivers/media/platform/qcom/venus/core.h
>> +++ b/drivers/media/platform/qcom/venus/core.h
>> @@ -134,6 +134,7 @@ struct venus_core {
>>         struct video_firmware {
>>                 struct device *dev;
>>                 struct iommu_domain *iommu_domain;
>> +               size_t mapped_mem_size;
>>         } fw;
>>         struct mutex lock;
>>         struct list_head instances;
>> diff --git a/drivers/media/platform/qcom/venus/firmware.c b/drivers/media/platform/qcom/venus/firmware.c
>> index c29acfd70c1b..6b509ffd022a 100644
>> --- a/drivers/media/platform/qcom/venus/firmware.c
>> +++ b/drivers/media/platform/qcom/venus/firmware.c
>> @@ -35,14 +35,15 @@
>>
>>  static void venus_reset_cpu(struct venus_core *core)
>>  {
>> +       u32 fw_size = core->fw.mapped_mem_size;
>>         void __iomem *base = core->base;
>>
>>         writel(0, base + WRAPPER_FW_START_ADDR);
>> -       writel(VENUS_FW_MEM_SIZE, base + WRAPPER_FW_END_ADDR);
>> +       writel(fw_size, base + WRAPPER_FW_END_ADDR);
>>         writel(0, base + WRAPPER_CPA_START_ADDR);
>> -       writel(VENUS_FW_MEM_SIZE, base + WRAPPER_CPA_END_ADDR);
>> -       writel(VENUS_FW_MEM_SIZE, base + WRAPPER_NONPIX_START_ADDR);
>> -       writel(VENUS_FW_MEM_SIZE, base + WRAPPER_NONPIX_END_ADDR);
>> +       writel(fw_size, base + WRAPPER_CPA_END_ADDR);
>> +       writel(fw_size, base + WRAPPER_NONPIX_START_ADDR);
>> +       writel(fw_size, base + WRAPPER_NONPIX_END_ADDR);
>>         writel(0x0, base + WRAPPER_CPU_CGC_DIS);
>>         writel(0x0, base + WRAPPER_CPU_CLOCK_CONFIG);
>>
>> @@ -74,6 +75,9 @@ static int venus_load_fw(struct venus_core *core, const char *fwname,
>>         void *mem_va;
>>         int ret;
>>
>> +       *mem_phys = 0;
>> +       *mem_size = 0;
>> +
>>         dev = core->dev;
>>         node = of_parse_phandle(dev->of_node, "memory-region", 0);
>>         if (!node) {
>> @@ -85,28 +89,30 @@ static int venus_load_fw(struct venus_core *core, const char *fwname,
>>         if (ret)
>>                 return ret;
>>
>> +       ret = request_firmware(&mdt, fwname, dev);
>> +       if (ret < 0)
>> +               return ret;
>> +
>> +       fw_size = qcom_mdt_get_size(mdt);
>> +       if (fw_size < 0) {
>> +               ret = fw_size;
>> +               goto err_release_fw;
>> +       }
>> +
>>         *mem_phys = r.start;
>>         *mem_size = resource_size(&r);
>>
>> -       if (*mem_size < VENUS_FW_MEM_SIZE)
>> -               return -EINVAL;
>> +       if (*mem_size < fw_size || fw_size > VENUS_FW_MEM_SIZE) {
> 
> Do we still need to check for fw_size > VENUS_FW_MEM_SIZE ? If we
> don't then we can remove the definition of VENUS_FW_MEM_SIZE
> altogether.

I know, it is a bit paranoid but I'd want to avoid if someone set
unreasonable memory size. So I'd like to have some sanitized firmware
region size in the driver.

> 
>> +               ret = -EINVAL;
>> +               goto err_release_fw;
>> +       }
>>
>>         mem_va = memremap(r.start, *mem_size, MEMREMAP_WC);
>>         if (!mem_va) {
>>                 dev_err(dev, "unable to map memory region: %pa+%zx\n",
>>                         &r.start, *mem_size);
>> -               return -ENOMEM;
>> -       }
>> -
>> -       ret = request_firmware(&mdt, fwname, dev);
>> -       if (ret < 0)
>> -               goto err_unmap;
>> -
>> -       fw_size = qcom_mdt_get_size(mdt);
>> -       if (fw_size < 0) {
>> -               ret = fw_size;
>> -               release_firmware(mdt);
>> -               goto err_unmap;
>> +               ret = -ENOMEM;
>> +               goto err_release_fw;
>>         }
>>
>>         if (core->use_tz)
>> @@ -116,10 +122,9 @@ static int venus_load_fw(struct venus_core *core, const char *fwname,
>>                 ret = qcom_mdt_load_no_init(dev, mdt, fwname, VENUS_PAS_ID,
>>                                             mem_va, *mem_phys, *mem_size, NULL);
>>
>> -       release_firmware(mdt);
>> -
>> -err_unmap:
>>         memunmap(mem_va);
>> +err_release_fw:
>> +       release_firmware(mdt);
>>         return ret;
>>  }
>>
>> @@ -135,6 +140,7 @@ static int venus_boot_no_tz(struct venus_core *core, phys_addr_t mem_phys,
>>                 return -EPROBE_DEFER;
>>
>>         iommu = core->fw.iommu_domain;
>> +       core->fw.mapped_mem_size = mem_size;
>>
>>         ret = iommu_map(iommu, VENUS_FW_START_ADDR, mem_phys, mem_size,
>>                         IOMMU_READ | IOMMU_WRITE | IOMMU_PRIV);
>> @@ -151,7 +157,7 @@ static int venus_boot_no_tz(struct venus_core *core, phys_addr_t mem_phys,
>>  static int venus_shutdown_no_tz(struct venus_core *core)
>>  {
>>         struct iommu_domain *iommu;
>> -       size_t unmapped;
>> +       size_t unmapped, mapped = core->fw.mapped_mem_size;
> 
> mapped should probably be const here.

Ok.

> 
> With these minor comments:
> 
> Reviewed-by: Alexandre Courbot <acourbot@chromium.org>
> Tested-by: Alexandre Courbot <acourbot@chromium.org>
> 
> For the 4 patches in this series. I could see the improvement in
> decoder performance introduced by patches 2 and 3, thanks!
> 

-- 
regards,
Stan
