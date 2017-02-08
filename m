Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f173.google.com ([209.85.128.173]:35682 "EHLO
        mail-wr0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752968AbdBHPL5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 8 Feb 2017 10:11:57 -0500
Received: by mail-wr0-f173.google.com with SMTP id 89so62231431wrr.2
        for <linux-media@vger.kernel.org>; Wed, 08 Feb 2017 07:10:31 -0800 (PST)
Subject: Re: [PATCH v6 4/9] media: venus: adding core part and helper
 functions
To: Bjorn Andersson <bjorn.andersson@linaro.org>
References: <1486473024-21705-1-git-send-email-stanimir.varbanov@linaro.org>
 <1486473024-21705-5-git-send-email-stanimir.varbanov@linaro.org>
 <20170207233202.GI27837@minitux>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Andy Gross <andy.gross@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <feb3efb6-dbda-b16a-477c-f36292b94f27@linaro.org>
Date: Wed, 8 Feb 2017 17:01:54 +0200
MIME-Version: 1.0
In-Reply-To: <20170207233202.GI27837@minitux>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Bjorn, thanks for the comments!

On 02/08/2017 01:32 AM, Bjorn Andersson wrote:
> On Tue 07 Feb 05:10 PST 2017, Stanimir Varbanov wrote:
> 
>>  * firmware loader
>>
> 
> I like the way this turns out, just some style comments below.
> 
> [..]
>> diff --git a/drivers/media/platform/qcom/venus/firmware.c b/drivers/media/platform/qcom/venus/firmware.c
>> new file mode 100644
>> index 000000000000..4057696abaf5
>> --- /dev/null
>> +++ b/drivers/media/platform/qcom/venus/firmware.c
>> @@ -0,0 +1,151 @@
>> +/*
>> + * Copyright (C) 2017 Linaro Ltd.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 and
>> + * only version 2 as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + */
>> +
>> +#include <linux/dma-mapping.h>
>> +#include <linux/firmware.h>
>> +#include <linux/kernel.h>
>> +#include <linux/of.h>
>> +#include <linux/of_reserved_mem.h>
>> +#include <linux/slab.h>
>> +#include <linux/qcom_scm.h>
>> +#include <linux/soc/qcom/mdt_loader.h>
>> +
>> +#define VENUS_FIRMWARE_NAME		"venus.mdt"
>> +#define VENUS_PAS_ID			9
>> +#define VENUS_FW_MEM_SIZE		SZ_8M
>> +
>> +struct firmware_mem {
>> +	struct device dev;
>> +	void *mem_va;
>> +	phys_addr_t mem_phys;
>> +	size_t mem_size;
>> +};
>> +
>> +static struct firmware_mem fw;
> 
> Rather than operating on a global variable I think you should either
> return your firmware_mem pointer or the device pointer to the caller of
> venus_boot() and have the core pass that back into venus_shutdown().

I will take your comments and will pass struct device *fw_dev as an
argument of venus_boot. Also I will move memory allocation in venus_boot
and by that way I don't need to keep memory attributes from above structure.

-- 
regards,
Stan
