Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:37547 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbbCJAda (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Mar 2015 20:33:30 -0400
MIME-Version: 1.0
In-Reply-To: <54F80C2B.20705@samsung.com>
References: <1425485680-8417-1-git-send-email-j.anaszewski@samsung.com>
 <1425485680-8417-5-git-send-email-j.anaszewski@samsung.com> <54F80C2B.20705@samsung.com>
From: Bryan Wu <cooloney@gmail.com>
Date: Mon, 9 Mar 2015 17:33:08 -0700
Message-ID: <CAK5ve-K15jV0Mvkqkg4dAdBs91iu_iPeuDU3RjYNBOfzNLRmow@mail.gmail.com>
Subject: Re: [PATCH/RFC v12 04/19] dt-binding: leds: Add common LED DT
 bindings macros
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: Linux LED Subsystem <linux-leds@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	lkml <linux-kernel@vger.kernel.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Pavel Machek <pavel@ucw.cz>,
	"rpurdie@rpsys.net" <rpurdie@rpsys.net>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Mar 4, 2015 at 11:56 PM, Jacek Anaszewski
<j.anaszewski@samsung.com> wrote:
> On 03/04/2015 05:14 PM, Jacek Anaszewski wrote:
>>
>> Add macros for defining boost mode and trigger type properties
>> of flash LED devices.
>>
>> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>> Cc: Bryan Wu <cooloney@gmail.com>
>> Cc: Richard Purdie <rpurdie@rpsys.net>
>> ---
>>   include/dt-bindings/leds/max77693.h |   21 +++++++++++++++++++++
>>   1 file changed, 21 insertions(+)
>>   create mode 100644 include/dt-bindings/leds/max77693.h
>
>
> This should be obviously include/dt-bindings/leds/common.h.
> It will affect also max77693-led bindings documentation patch.
> I'll send the update after receiving review remarks related to the
> remaining part of the mentioned patches.
>

OK, please update them then I will merge this patch.

Thanks,
-Bryan

>
>>
>> diff --git a/include/dt-bindings/leds/max77693.h
>> b/include/dt-bindings/leds/max77693.h
>> new file mode 100644
>> index 0000000..79fcef7
>> --- /dev/null
>> +++ b/include/dt-bindings/leds/max77693.h
>> @@ -0,0 +1,21 @@
>> +/*
>> + * This header provides macros for the common LEDs device tree bindings.
>> + *
>> + * Copyright (C) 2015, Samsung Electronics Co., Ltd.
>> + *
>> + * Author: Jacek Anaszewski <j.anaszewski@samsung.com>
>> + */
>> +
>> +#ifndef __DT_BINDINGS_LEDS_H__
>> +#define __DT_BINDINGS_LEDS_H
>> +
>> +/* External trigger type */
>> +#define LEDS_TRIG_TYPE_EDGE    0
>> +#define LEDS_TRIG_TYPE_LEVEL   1
>> +
>> +/* Boost modes */
>> +#define LEDS_BOOST_OFF         0
>> +#define LEDS_BOOST_ADAPTIVE    1
>> +#define LEDS_BOOST_FIXED       2
>> +
>> +#endif /* __DT_BINDINGS_LEDS_H */
>>
>
>
> --
> Best Regards,
> Jacek Anaszewski
