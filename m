Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:36837 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753784AbbGWQjw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Jul 2015 12:39:52 -0400
Received: by lbbqi7 with SMTP id qi7so81198129lbb.3
        for <linux-media@vger.kernel.org>; Thu, 23 Jul 2015 09:39:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55AE430A.8040300@samsung.com>
References: <1435572900-56998-1-git-send-email-hans.verkuil@cisco.com>
	<1435572900-56998-15-git-send-email-hans.verkuil@cisco.com>
	<55A7AD20.3080703@xs4all.nl>
	<55AE430A.8040300@samsung.com>
Date: Thu, 23 Jul 2015 18:39:50 +0200
Message-ID: <CAP3TMiF-swEQU7KJWaA5NXgbkf1u8o_7vmjXf9QFuHj83MmDyw@mail.gmail.com>
Subject: Re: [PATCHv7 14/15] cec: s5p-cec: Add s5p-cec driver
From: Kamil Debski <kamil@wypas.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	thomas@tommie-lie.de, sean@mess.org, dmitry.torokhov@gmail.com,
	linux-input@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	lars@opdenkamp.eu
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 21 July 2015 at 15:03, Marek Szyprowski <m.szyprowski@samsung.com> wrote:
> Hello,
>
> On 2015-07-16 15:09, Hans Verkuil wrote:
>>
>> Marek, Kamil,
>>
>> On 06/29/15 12:14, Hans Verkuil wrote:
>>>
>>> From: Kamil Debski <kamil@wypas.org>
>>>
>>> Add CEC interface driver present in the Samsung Exynos range of
>>> SoCs.
>>>
>>> The following files were based on work by SangPil Moon:
>>> - exynos_hdmi_cec.h
>>> - exynos_hdmi_cecctl.c
>>>
>>> Signed-off-by: Kamil Debski <kamil@wypas.org>
>>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>>> ---
>>
>> <snip>
>>
>>> diff --git a/drivers/media/platform/s5p-cec/s5p_cec.c
>>> b/drivers/media/platform/s5p-cec/s5p_cec.c
>>> new file mode 100644
>>> index 0000000..0f16d00
>>> --- /dev/null
>>> +++ b/drivers/media/platform/s5p-cec/s5p_cec.c
>>> @@ -0,0 +1,283 @@
>>> +/* drivers/media/platform/s5p-cec/s5p_cec.c
>>> + *
>>> + * Samsung S5P CEC driver
>>> + *
>>> + * Copyright (c) 2014 Samsung Electronics Co., Ltd.
>>> + *
>>> + * This program is free software; you can redistribute it and/or modify
>>> + * it under the terms of the GNU General Public License as published by
>>> + * the Free Software Foundation; either version 2 of the License, or
>>> + * (at your option) any later version.
>>> + *
>>> + * This driver is based on the "cec interface driver for exynos soc" by
>>> + * SangPil Moon.
>>> + */
>>> +
>>> +#include <linux/clk.h>
>>> +#include <linux/interrupt.h>
>>> +#include <linux/kernel.h>
>>> +#include <linux/mfd/syscon.h>
>>> +#include <linux/module.h>
>>> +#include <linux/of.h>
>>> +#include <linux/platform_device.h>
>>> +#include <linux/pm_runtime.h>
>>> +#include <linux/timer.h>
>>> +#include <linux/version.h>
>>> +#include <linux/workqueue.h>
>>> +#include <media/cec.h>
>>> +
>>> +#include "exynos_hdmi_cec.h"
>>> +#include "regs-cec.h"
>>> +#include "s5p_cec.h"
>>> +
>>> +#define CEC_NAME       "s5p-cec"
>>> +
>>> +static int debug;
>>> +module_param(debug, int, 0644);
>>> +MODULE_PARM_DESC(debug, "debug level (0-2)");
>>> +
>>> +static int s5p_cec_enable(struct cec_adapter *adap, bool enable)
>>> +{
>>> +       struct s5p_cec_dev *cec = container_of(adap, struct s5p_cec_dev,
>>> adap);
>>> +       int ret;
>>> +
>>> +       if (enable) {
>>> +               ret = pm_runtime_get_sync(cec->dev);
>>> +
>>> +               adap->phys_addr = 0x100b;
>>
>> This is a bogus physical address. The actual physical address has to be
>> derived
>> from the EDID that is read by the HDMI transmitter.
>>
>> I think in the case of this driver it will have to be userspace that
>> assigns
>> the physical address after reading the EDID from drm/kms?
>>
>> How did you test this, Kamil?
>
>
> If I remember correctly, physical address has been derived from EDID in the
> userspace (it is available in /sys/class/drm/*) and passed to s5p-cec driver
> by
> appropriate ioctl.
>
> I don't know what is the reason for the above 'adap->phys_addr = 0x100b'
> assignment.

At some point there was an idea to read the address from the EDID in
kernel. This static address was a hack until the code that reads the
EDID is written. As you say, it is much better to leave the address to
be set by the userspace. So this assignment serves no purpose anymore.

>
> Best regards
> --
> Marek Szyprowski, PhD
> Samsung R&D Institute Poland
>

Best wishes,
Kamil
