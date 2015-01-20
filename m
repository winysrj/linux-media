Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:40366 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742AbbATMxK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Jan 2015 07:53:10 -0500
Message-id: <54BE4FB1.3030209@samsung.com>
Date: Tue, 20 Jan 2015 13:53:05 +0100
From: Jacek Anaszewski <j.anaszewski@samsung.com>
MIME-version: 1.0
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
	kyungmin.park@samsung.com, b.zolnierkie@samsung.com, pavel@ucw.cz,
	cooloney@gmail.com, rpurdie@rpsys.net, sakari.ailus@iki.fi,
	s.nawrocki@samsung.com, Chanwoo Choi <cw00.choi@samsung.com>
Subject: Re: [PATCH/RFC v10 04/19] dt-binding: mfd: max77693: Add DT binding
 related macros
References: <1420816989-1808-1-git-send-email-j.anaszewski@samsung.com>
 <1420816989-1808-5-git-send-email-j.anaszewski@samsung.com>
 <20150120111243.GC13701@x1>
In-reply-to: <20150120111243.GC13701@x1>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/20/2015 12:12 PM, Lee Jones wrote:
> On Fri, 09 Jan 2015, Jacek Anaszewski wrote:
>
>> Add macros for max77693 led part related binding.
>>
>> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>> Cc: Lee Jones <lee.jones@linaro.org>
>> Cc: Chanwoo Choi <cw00.choi@samsung.com>
>> ---
>>   include/dt-bindings/mfd/max77693.h |   21 +++++++++++++++++++++
>>   1 file changed, 21 insertions(+)
>>   create mode 100644 include/dt-bindings/mfd/max77693.h
>>
>> diff --git a/include/dt-bindings/mfd/max77693.h b/include/dt-bindings/mfd/max77693.h
>> new file mode 100644
>> index 0000000..f53e197
>> --- /dev/null
>> +++ b/include/dt-bindings/mfd/max77693.h
>> @@ -0,0 +1,21 @@
>> +/*
>> + * This header provides macros for MAX77693 device binding
>> + *
>> + * Copyright (C) 2014, Samsung Electronics Co., Ltd.
>> + *
>> + * Author: Jacek Anaszewski <j.anaszewski@samsung.com>
>> + */
>> +
>> +#ifndef __DT_BINDINGS_MAX77693_H__
>> +#define __DT_BINDINGS_MAX77693_H
>> +
>> +/* External trigger type */
>> +#define MAX77693_LED_TRIG_TYPE_EDGE	0
>> +#define MAX77693_LED_TRIG_TYPE_LEVEL	1
>> +
>> +/* Boost modes */
>> +#define MAX77693_LED_BOOST_OFF		0
>> +#define MAX77693_LED_BOOST_ADAPTIVE	1
>> +#define MAX77693_LED_BOOST_FIXED	2
>> +
>> +#endif /* __DT_BINDINGS_MAX77693_H */
>
> These look fairly generic.  Do generic LED defines already exist?  If
> not, can they?

I am not entirely sure that they are generic. Different devices
may define different trigger types for low current LEDs and flash
LEDs. Boost modes could also have different semantics.

Regardless of the above we can consider renaming the file to
include/dt-bindings/leds/max77693.h

Bryan - what is your opinion?

-- 
Best Regards,
Jacek Anaszewski
