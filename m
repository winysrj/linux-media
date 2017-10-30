Return-path: <linux-media-owner@vger.kernel.org>
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:43387 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751429AbdJ3AZo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 29 Oct 2017 20:25:44 -0400
Subject: Re: [PATCH v5 0/5] media: atmel-isc: Rework the format list and clock
 provider
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
CC: <linux-kernel@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Jonathan Corbet <corbet@lwn.net>,
        <linux-arm-kernel@lists.infradead.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
References: <20171027032132.16418-1-wenyou.yang@microchip.com>
 <c7344ea2-dd71-8f42-1a11-188eb843c787@xs4all.nl>
From: "Yang, Wenyou" <Wenyou.Yang@Microchip.com>
Message-ID: <ea3ac954-0ed7-b045-5135-fd1eeadaf2d9@Microchip.com>
Date: Mon, 30 Oct 2017 08:25:35 +0800
MIME-Version: 1.0
In-Reply-To: <c7344ea2-dd71-8f42-1a11-188eb843c787@xs4all.nl>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,


On 2017/10/27 20:41, Hans Verkuil wrote:
> Hi Wenyou,
>
> Unfortunately the v4 patch series was just merged instead of v5. Can you make a new
> patch applying just the v4 -> v5 changes?
Thank you for your merging.

Of course, I will send a patch to fix it.

>
> Thanks!
>
> 	Hans
>
> On 10/27/2017 05:21 AM, Wenyou Yang wrote:
>> To improve the readability of code, rework the format list table,
>> split the format array into two. Meanwhile, fix the issue of the
>> clock provider operation and the pm runtime support.
>>
>> Changes in v5:
>>   - Fix the clock ID which enters the runtime suspend should be
>>     ISC_ISPCK, instead of ISC_MCK for clk_prepare/clk_unprepare().
>>   - Fix the clock ID to ISC_ISPCK, instead of ISC_MCK for
>>     isc_clk_is_enabled().
>>
>> Changes in v4:
>>   - Call pm_runtime_get_sync() and pm_runtime_put_sync() in ->prepare
>>     and ->unprepare callback.
>>   - Move pm_runtime_enable() call from the complete callback to the
>>     end of probe.
>>   - Call pm_runtime_get_sync() and pm_runtime_put_sync() in
>>     ->is_enabled() callbacks.
>>   - Call clk_disable_unprepare() in ->remove callback.
>>
>> Changes in v3:
>>   - Fix the wrong used spinlock.
>>   - s/_/- on the subject.
>>   - Add a new flag for Raw Bayer format to remove MAX_RAW_FMT_INDEX define.
>>   - Add the comments for define of the format flag.
>>   - Rebase media_tree/master.
>>
>> Changes in v2:
>>   - Add the new patch to remove the unnecessary member from
>>     isc_subdev_entity struct.
>>   - Rebase on the patch set,
>>          [PATCH 0/6] [media] Atmel: Adjustments for seven function implementations
>>          https://www.mail-archive.com/linux-media@vger.kernel.org/msg118342.html
>>
>> Wenyou Yang (5):
>>    media: atmel-isc: Add spin lock for clock enable ops
>>    media: atmel-isc: Add prepare and unprepare ops
>>    media: atmel-isc: Enable the clocks during probe
>>    media: atmel-isc: Remove unnecessary member
>>    media: atmel-isc: Rework the format list
>>
>>   drivers/media/platform/atmel/atmel-isc-regs.h |   1 +
>>   drivers/media/platform/atmel/atmel-isc.c      | 629 ++++++++++++++++++++------
>>   2 files changed, 498 insertions(+), 132 deletions(-)
>>
Best Regards,
Wenyou Yang
