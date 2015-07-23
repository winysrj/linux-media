Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-3.cisco.com ([173.38.203.53]:48622 "EHLO
	aer-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902AbbGWRW5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Jul 2015 13:22:57 -0400
Message-ID: <55B122CC.1000605@cisco.com>
Date: Thu, 23 Jul 2015 19:22:20 +0200
From: Hans Verkuil <hansverk@cisco.com>
MIME-Version: 1.0
To: Kamil Debski <kamil@wypas.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	thomas@tommie-lie.de, sean@mess.org, dmitry.torokhov@gmail.com,
	linux-input@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	lars@opdenkamp.eu
Subject: Re: [PATCHv7 14/15] cec: s5p-cec: Add s5p-cec driver
References: <1435572900-56998-1-git-send-email-hans.verkuil@cisco.com>	<1435572900-56998-15-git-send-email-hans.verkuil@cisco.com>	<55A7AD20.3080703@xs4all.nl>	<55AE430A.8040300@samsung.com> <CAP3TMiF-swEQU7KJWaA5NXgbkf1u8o_7vmjXf9QFuHj83MmDyw@mail.gmail.com>
In-Reply-To: <CAP3TMiF-swEQU7KJWaA5NXgbkf1u8o_7vmjXf9QFuHj83MmDyw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/23/2015 06:39 PM, Kamil Debski wrote:
> Hi,
>
> On 21 July 2015 at 15:03, Marek Szyprowski <m.szyprowski@samsung.com> wrote:
>> Hello,
>>
>> On 2015-07-16 15:09, Hans Verkuil wrote:
>>>
>>> Marek, Kamil,
>>>
>>> On 06/29/15 12:14, Hans Verkuil wrote:
>>>>
>>>> From: Kamil Debski <kamil@wypas.org>
>>>>
>>>> Add CEC interface driver present in the Samsung Exynos range of
>>>> SoCs.
>>>>
>>>> The following files were based on work by SangPil Moon:
>>>> - exynos_hdmi_cec.h
>>>> - exynos_hdmi_cecctl.c
>>>>
>>>> Signed-off-by: Kamil Debski <kamil@wypas.org>
>>>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>>>> ---
>>>
>>> <snip>
>>>
>>>> diff --git a/drivers/media/platform/s5p-cec/s5p_cec.c
>>>> b/drivers/media/platform/s5p-cec/s5p_cec.c
>>>> new file mode 100644
>>>> index 0000000..0f16d00
>>>> --- /dev/null
>>>> +++ b/drivers/media/platform/s5p-cec/s5p_cec.c
>>>> @@ -0,0 +1,283 @@
>>>> +/* drivers/media/platform/s5p-cec/s5p_cec.c
>>>> + *
>>>> + * Samsung S5P CEC driver
>>>> + *
>>>> + * Copyright (c) 2014 Samsung Electronics Co., Ltd.
>>>> + *
>>>> + * This program is free software; you can redistribute it and/or modify
>>>> + * it under the terms of the GNU General Public License as published by
>>>> + * the Free Software Foundation; either version 2 of the License, or
>>>> + * (at your option) any later version.
>>>> + *
>>>> + * This driver is based on the "cec interface driver for exynos soc" by
>>>> + * SangPil Moon.
>>>> + */
>>>> +
>>>> +#include <linux/clk.h>
>>>> +#include <linux/interrupt.h>
>>>> +#include <linux/kernel.h>
>>>> +#include <linux/mfd/syscon.h>
>>>> +#include <linux/module.h>
>>>> +#include <linux/of.h>
>>>> +#include <linux/platform_device.h>
>>>> +#include <linux/pm_runtime.h>
>>>> +#include <linux/timer.h>
>>>> +#include <linux/version.h>
>>>> +#include <linux/workqueue.h>
>>>> +#include <media/cec.h>
>>>> +
>>>> +#include "exynos_hdmi_cec.h"
>>>> +#include "regs-cec.h"
>>>> +#include "s5p_cec.h"
>>>> +
>>>> +#define CEC_NAME       "s5p-cec"
>>>> +
>>>> +static int debug;
>>>> +module_param(debug, int, 0644);
>>>> +MODULE_PARM_DESC(debug, "debug level (0-2)");
>>>> +
>>>> +static int s5p_cec_enable(struct cec_adapter *adap, bool enable)
>>>> +{
>>>> +       struct s5p_cec_dev *cec = container_of(adap, struct s5p_cec_dev,
>>>> adap);
>>>> +       int ret;
>>>> +
>>>> +       if (enable) {
>>>> +               ret = pm_runtime_get_sync(cec->dev);
>>>> +
>>>> +               adap->phys_addr = 0x100b;
>>>
>>> This is a bogus physical address. The actual physical address has to be
>>> derived
>>> from the EDID that is read by the HDMI transmitter.
>>>
>>> I think in the case of this driver it will have to be userspace that
>>> assigns
>>> the physical address after reading the EDID from drm/kms?
>>>
>>> How did you test this, Kamil?
>>
>>
>> If I remember correctly, physical address has been derived from EDID in the
>> userspace (it is available in /sys/class/drm/*) and passed to s5p-cec driver
>> by
>> appropriate ioctl.
>>
>> I don't know what is the reason for the above 'adap->phys_addr = 0x100b'
>> assignment.
>
> At some point there was an idea to read the address from the EDID in
> kernel. This static address was a hack until the code that reads the
> EDID is written. As you say, it is much better to leave the address to
> be set by the userspace. So this assignment serves no purpose anymore.

Thank you, that's what I thought. It's fixed in my current tree. Still
working on the CEC framework: I'm chasing race conditions and I suspect
that there may be a bug in the adv7604 or adv7511 CEC implementation.

Once I've sorted that I post a new version which has been tested a lot
more thoroughly and should be complete except for the documentation.

Regards,

	Hans

