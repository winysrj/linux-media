Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:29265 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754062AbbGUNDL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Jul 2015 09:03:11 -0400
Subject: Re: [PATCHv7 14/15] cec: s5p-cec: Add s5p-cec driver
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org
References: <1435572900-56998-1-git-send-email-hans.verkuil@cisco.com>
 <1435572900-56998-15-git-send-email-hans.verkuil@cisco.com>
 <55A7AD20.3080703@xs4all.nl>
Cc: dri-devel@lists.freedesktop.org, kyungmin.park@samsung.com,
	thomas@tommie-lie.de, sean@mess.org, dmitry.torokhov@gmail.com,
	linux-input@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	lars@opdenkamp.eu, kamil@wypas.org
From: Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <55AE430A.8040300@samsung.com>
Date: Tue, 21 Jul 2015 15:03:06 +0200
MIME-version: 1.0
In-reply-to: <55A7AD20.3080703@xs4all.nl>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 2015-07-16 15:09, Hans Verkuil wrote:
> Marek, Kamil,
>
> On 06/29/15 12:14, Hans Verkuil wrote:
>> From: Kamil Debski <kamil@wypas.org>
>>
>> Add CEC interface driver present in the Samsung Exynos range of
>> SoCs.
>>
>> The following files were based on work by SangPil Moon:
>> - exynos_hdmi_cec.h
>> - exynos_hdmi_cecctl.c
>>
>> Signed-off-by: Kamil Debski <kamil@wypas.org>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
> <snip>
>
>> diff --git a/drivers/media/platform/s5p-cec/s5p_cec.c b/drivers/media/platform/s5p-cec/s5p_cec.c
>> new file mode 100644
>> index 0000000..0f16d00
>> --- /dev/null
>> +++ b/drivers/media/platform/s5p-cec/s5p_cec.c
>> @@ -0,0 +1,283 @@
>> +/* drivers/media/platform/s5p-cec/s5p_cec.c
>> + *
>> + * Samsung S5P CEC driver
>> + *
>> + * Copyright (c) 2014 Samsung Electronics Co., Ltd.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; either version 2 of the License, or
>> + * (at your option) any later version.
>> + *
>> + * This driver is based on the "cec interface driver for exynos soc" by
>> + * SangPil Moon.
>> + */
>> +
>> +#include <linux/clk.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/kernel.h>
>> +#include <linux/mfd/syscon.h>
>> +#include <linux/module.h>
>> +#include <linux/of.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/pm_runtime.h>
>> +#include <linux/timer.h>
>> +#include <linux/version.h>
>> +#include <linux/workqueue.h>
>> +#include <media/cec.h>
>> +
>> +#include "exynos_hdmi_cec.h"
>> +#include "regs-cec.h"
>> +#include "s5p_cec.h"
>> +
>> +#define CEC_NAME	"s5p-cec"
>> +
>> +static int debug;
>> +module_param(debug, int, 0644);
>> +MODULE_PARM_DESC(debug, "debug level (0-2)");
>> +
>> +static int s5p_cec_enable(struct cec_adapter *adap, bool enable)
>> +{
>> +	struct s5p_cec_dev *cec = container_of(adap, struct s5p_cec_dev, adap);
>> +	int ret;
>> +
>> +	if (enable) {
>> +		ret = pm_runtime_get_sync(cec->dev);
>> +
>> +		adap->phys_addr = 0x100b;
> This is a bogus physical address. The actual physical address has to be derived
> from the EDID that is read by the HDMI transmitter.
>
> I think in the case of this driver it will have to be userspace that assigns
> the physical address after reading the EDID from drm/kms?
>
> How did you test this, Kamil?

If I remember correctly, physical address has been derived from EDID in the
userspace (it is available in /sys/class/drm/*) and passed to s5p-cec 
driver by
appropriate ioctl.

I don't know what is the reason for the above 'adap->phys_addr = 0x100b' 
assignment.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

