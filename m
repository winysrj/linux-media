Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:26390 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750960AbdIMCe3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Sep 2017 22:34:29 -0400
Subject: Re: [PATCH v3 4/6] [media] exynos-gsc: Add hardware rotation limits
To: Sylwester Nawrocki <s.nawrocki@samsung.com>, mchehab@kernel.org
Cc: inki.dae@samsung.com, airlied@linux.ie, kgene@kernel.org,
        krzk@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        catalin.marinas@arm.com, will.deacon@arm.com,
        m.szyprowski@samsung.com, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        Hoegeun Kwon <hoegeun.kwon@samsung.com>
From: Hoegeun Kwon <hoegeun.kwon@samsung.com>
Message-id: <bb025fcb-e316-dfe9-a8eb-8a9535f35b93@samsung.com>
Date: Wed, 13 Sep 2017 11:33:45 +0900
MIME-version: 1.0
In-reply-to: <27b46679-e6c7-2471-f10e-3f0634178ebf@samsung.com>
Content-type: text/plain; charset="utf-8"; format="flowed"
Content-transfer-encoding: 7bit
Content-language: en-US
References: <1504850560-27950-1-git-send-email-hoegeun.kwon@samsung.com>
        <CGME20170908060309epcas1p3d48dd0871d3fde02ba3c9921bbe5a7a6@epcas1p3.samsung.com>
        <1504850560-27950-5-git-send-email-hoegeun.kwon@samsung.com>
        <27b46679-e6c7-2471-f10e-3f0634178ebf@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On 09/11/2017 06:35 PM, Sylwester Nawrocki wrote:
> On 09/08/2017 08:02 AM, Hoegeun Kwon wrote:
>> The hardware rotation limits of gsc depends on SOC (Exynos
>> 5250/5420/5433). Distinguish them and add them to the driver data.
>>
>> Signed-off-by: Hoegeun Kwon <hoegeun.kwon@samsung.com>
>> ---
>>   drivers/media/platform/exynos-gsc/gsc-core.c | 96 
>> ++++++++++++++++++++++++----
>>   1 file changed, 83 insertions(+), 13 deletions(-)
>>
>> diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c 
>> b/drivers/media/platform/exynos-gsc/gsc-core.c
>> index 4380150..8f8636e 100644
>> --- a/drivers/media/platform/exynos-gsc/gsc-core.c
>> +++ b/drivers/media/platform/exynos-gsc/gsc-core.c
>> @@ -943,7 +943,37 @@ static irqreturn_t gsc_irq_handler(int irq, void 
>> *priv)
>>       return IRQ_HANDLED;
>>   }
>>   -static struct gsc_pix_max gsc_v_100_max = {
>> +static struct gsc_pix_max gsc_v_5250_max = {
>> +    .org_scaler_bypass_w    = 8192,
>> +    .org_scaler_bypass_h    = 8192,
>> +    .org_scaler_input_w    = 4800,
>> +    .org_scaler_input_h    = 3344,
>> +    .real_rot_dis_w        = 4800,
>> +    .real_rot_dis_h        = 3344,
>> +    .real_rot_en_w        = 2016,
>> +    .real_rot_en_h        = 2016,
>> +    .target_rot_dis_w    = 4800,
>> +    .target_rot_dis_h    = 3344,
>> +    .target_rot_en_w    = 2016,
>> +    .target_rot_en_h    = 2016,
>> +};
>> +
>> +static struct gsc_pix_max gsc_v_5420_max = {
>> +    .org_scaler_bypass_w    = 8192,
>> +    .org_scaler_bypass_h    = 8192,
>> +    .org_scaler_input_w    = 4800,
>> +    .org_scaler_input_h    = 3344,
>> +    .real_rot_dis_w        = 4800,
>> +    .real_rot_dis_h        = 3344,
>> +    .real_rot_en_w        = 2048,
>> +    .real_rot_en_h        = 2048,
>> +    .target_rot_dis_w    = 4800,
>> +    .target_rot_dis_h    = 3344,
>> +    .target_rot_en_w    = 2016,
>> +    .target_rot_en_h    = 2016,
>> +};
>> +
>> +static struct gsc_pix_max gsc_v_5433_max = {
>>       .org_scaler_bypass_w    = 8192,
>>       .org_scaler_bypass_h    = 8192,
>>       .org_scaler_input_w    = 4800,
>> @@ -979,8 +1009,8 @@ static irqreturn_t gsc_irq_handler(int irq, void 
>> *priv)
>>       .target_h        = 2,  /* yuv420 : 2, others : 1 */
>>   };
>>   -static struct gsc_variant gsc_v_100_variant = {
>> -    .pix_max        = &gsc_v_100_max,
>> +static struct gsc_variant gsc_v_5250_variant = {
>> +    .pix_max        = &gsc_v_5250_max,
>>       .pix_min        = &gsc_v_100_min,
>>       .pix_align        = &gsc_v_100_align,
>>       .in_buf_cnt        = 32,
>> @@ -992,12 +1022,48 @@ static irqreturn_t gsc_irq_handler(int irq, 
>> void *priv)
>>       .local_sc_down        = 2,
>>   };
>>   -static struct gsc_driverdata gsc_v_100_drvdata = {
>> +static struct gsc_variant gsc_v_5420_variant = {
>> +    .pix_max        = &gsc_v_5420_max,
>> +    .pix_min        = &gsc_v_100_min,
>> +    .pix_align        = &gsc_v_100_align,
>> +    .in_buf_cnt        = 32,
>> +    .out_buf_cnt        = 32,
>> +    .sc_up_max        = 8,
>> +    .sc_down_max        = 16,
>> +    .poly_sc_down_max    = 4,
>> +    .pre_sc_down_max    = 4,
>> +    .local_sc_down        = 2,
>> +};
>> +
>> +static struct gsc_variant gsc_v_5433_variant = {
>> +    .pix_max        = &gsc_v_5433_max,
>> +    .pix_min        = &gsc_v_100_min,
>> +    .pix_align        = &gsc_v_100_align,
>> +    .in_buf_cnt        = 32,
>> +    .out_buf_cnt        = 32,
>> +    .sc_up_max        = 8,
>> +    .sc_down_max        = 16,
>> +    .poly_sc_down_max    = 4,
>> +    .pre_sc_down_max    = 4,
>> +    .local_sc_down        = 2,
>> +};
>> +
>> +static struct gsc_driverdata gsc_v_5250_drvdata = {
>>       .variant = {
>> -        [0] = &gsc_v_100_variant,
>> -        [1] = &gsc_v_100_variant,
>> -        [2] = &gsc_v_100_variant,
>> -        [3] = &gsc_v_100_variant,
>> +        [0] = &gsc_v_5250_variant,
>> +        [1] = &gsc_v_5250_variant,
>> +        [2] = &gsc_v_5250_variant,
>> +        [3] = &gsc_v_5250_variant,
>> +    },
>> +    .num_entities = 4,
>> +    .clk_names = { "gscl" },
>> +    .num_clocks = 1,
>> +};
>> +
>> +static struct gsc_driverdata gsc_v_5420_drvdata = {
>> +    .variant = {
>> +        [0] = &gsc_v_5420_variant,
>> +        [1] = &gsc_v_5420_variant,
>>       },
>>       .num_entities = 4,
>>       .clk_names = { "gscl" },
>> @@ -1006,9 +1072,9 @@ static irqreturn_t gsc_irq_handler(int irq, 
>> void *priv)
>>     static struct gsc_driverdata gsc_5433_drvdata = {
>>       .variant = {
>> -        [0] = &gsc_v_100_variant,
>> -        [1] = &gsc_v_100_variant,
>> -        [2] = &gsc_v_100_variant,
>> +        [0] = &gsc_v_5433_variant,
>> +        [1] = &gsc_v_5433_variant,
>> +        [2] = &gsc_v_5433_variant,
>>       },
>>       .num_entities = 3,
>>       .clk_names = { "pclk", "aclk", "aclk_xiu", "aclk_gsclbend" },
>> @@ -1017,8 +1083,12 @@ static irqreturn_t gsc_irq_handler(int irq, 
>> void *priv)
>>     static const struct of_device_id exynos_gsc_match[] = {
>>       {
>> -        .compatible = "samsung,exynos5-gsc",
>> -        .data = &gsc_v_100_drvdata,
>
> Can you keep the "samsung,exynos5-gsc" entry with the gsc_v_5250_variant
> data, so that it can work with "samsung,exynos5-gsc" compatible in DT
> on both exynos5250 and exynos5420 SoCs?
>

Thank you for your question.

Exynos 5250 and 5420 have different hardware rotation limits.
Exynos 5250 is '.real_rot_en_w/h = 2016' and 5420 is '.real_rot_en_w/h = 
2048'.

So my opinion they must have different compatible.

Best regards,
Hoegeun

>> +        .compatible = "samsung,exynos5250-gsc",
>> +        .data = &gsc_v_5250_drvdata,
>> +    },
>> +    {
>> +        .compatible = "samsung,exynos5420-gsc",
>> +        .data = &gsc_v_5420_drvdata,
>>       },
>
