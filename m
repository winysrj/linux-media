Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:40165 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751097AbdE2JUU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 May 2017 05:20:20 -0400
Subject: Re: [PATCH v4 0/2] cec: STM32 driver
To: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Cc: Yannick Fertre <yannick.fertre@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        devicetree@vger.kernel.org,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Rob Herring <robh@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
References: <1496046855-5809-1-git-send-email-benjamin.gaignard@linaro.org>
 <5ef1d96d-dc5f-49b9-0650-51d086efc226@xs4all.nl>
 <CA+M3ks5gdzAGx9suKnz-=4Aw5DiigLGFjOA5xqunzDEL8MmPBg@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <1a1685a9-c1c6-07db-6a3e-fe973d35086f@xs4all.nl>
Date: Mon, 29 May 2017 11:20:15 +0200
MIME-Version: 1.0
In-Reply-To: <CA+M3ks5gdzAGx9suKnz-=4Aw5DiigLGFjOA5xqunzDEL8MmPBg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/29/2017 11:07 AM, Benjamin Gaignard wrote:
> 2017-05-29 10:54 GMT+02:00 Hans Verkuil <hverkuil@xs4all.nl>:
>> Hi Benjamin,
>>
>> On 05/29/2017 10:34 AM, Benjamin Gaignard wrote:
>>>
>>> version 4:
>>> - rebased on Hans cec-config branch
>>> - rework bindings commit message
>>> - add notifier support
>>
>>
>> I really don't like this change. This forced me to think about this a bit
>> more,
>> and I think this requires another change as well.
>>
>> The problem you have is that the drm driver for this platform isn't ready
>> yet,
>> so this CEC driver needs userspace to provide a physical address since it
>> can't
>> use a notifier.
>>
>> Trying to support both is a bad idea since this runs the risk that we will
>> forget
>> to remove the CAP_PHYS_ADDR path later.
> 
> I would like stm32 cec driver to be able to work with or without
> notifier support.
> stm32 are small platforms and not everybody will use hdmi because of memory
> consomption but cec can be used anyway.

Ah, that's a good point.

So drop the notifier and add a comment where you describe that once the drm
driver becomes available notifier support will be added, but that CAP_PHYS_ADDR
remains allowed in cases where the drm driver isn't enabled due to the small
size of the platform.

With that comment it can stay in mainline.

When the drm driver arrives the notifier should probably be automatically
selected when the drm driver is enabled. I want to avoid the combination of
CAP_PHYS_ADDR and a drm driver, that shouldn't happen.

Regards,

	Hans
