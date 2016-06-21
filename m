Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:16501 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbcFUNLI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Jun 2016 09:11:08 -0400
Message-id: <57693CE5.7050904@samsung.com>
Date: Tue, 21 Jun 2016 15:11:01 +0200
From: Jacek Anaszewski <j.anaszewski@samsung.com>
MIME-version: 1.0
To: "Andrew F. Davis" <afd@ti.com>
Cc: Russell King <linux@armlinux.org.uk>,
	Miguel Ojeda Sandonis <miguel.ojeda.sandonis@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sebastian Reichel <sre@kernel.org>,
	Wolfram Sang <wsa@the-dreams.de>,
	Richard Purdie <rpurdie@rpsys.net>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Ingo Molnar <mingo@kernel.org>, linux-pwm@vger.kernel.org,
	lguest@lists.ozlabs.org, linux-wireless@vger.kernel.org,
	linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-gpio@vger.kernel.org, linux-i2c@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, linux-leds@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] leds: Add no-op gpio_led_register_device when LED
 subsystem is disabled
References: <20160613200211.14790-1-afd@ti.com>
 <20160613200211.14790-13-afd@ti.com> <5760FA52.7010806@samsung.com>
 <57647DBD.2010406@ti.com> <57679E38.3080901@samsung.com>
 <57686A94.2010704@ti.com> <5768E815.5080706@samsung.com>
 <5769297A.4050608@ti.com>
In-reply-to: <5769297A.4050608@ti.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/21/2016 01:48 PM, Andrew F. Davis wrote:
> On 06/21/2016 02:09 AM, Jacek Anaszewski wrote:
>> Hi Andrew,
>>
>> This patch doesn't apply, please rebase onto recent LED tree.
>>
>> On 06/21/2016 12:13 AM, Andrew F. Davis wrote:
>>> Some systems use 'gpio_led_register_device' to make an in-memory copy of
>>> their LED device table so the original can be removed as .init.rodata.
>>> When the LED subsystem is not enabled source in the led directory is not
>>> built and so this function may be undefined. Fix this here.
>>>
>>> Signed-off-by: Andrew F. Davis <afd@ti.com>
>>> ---
>>>    include/linux/leds.h | 8 ++++++++
>>>    1 file changed, 8 insertions(+)
>>>
>>> diff --git a/include/linux/leds.h b/include/linux/leds.h
>>> index d2b1306..a4a3da6 100644
>>> --- a/include/linux/leds.h
>>> +++ b/include/linux/leds.h
>>> @@ -386,8 +386,16 @@ struct gpio_led_platform_data {
>>>                                           unsigned long *delay_off);
>>
>> Currently there is some stuff here, and in fact it has been for
>> a long time.
>>
>> Patch "[PATCH 12/12] leds: Only descend into leds directory when
>> CONFIG_NEW_LEDS is set" also doesn't apply.
>> What repository are you using?
>>
>
> v4.7-rc4, it may not apply due to the surrounding lines being changed in
> the other patches which may not be applied to your tree. It is a single
> line change per patch so hopefully the merge conflict resolutions will
> be trivial.
>
> A better solution could have been getting an ack from each maintainer
> and having someone pull the whole series into one tree, but parts have
> already been picked so it may be a little late for that.

OK, I resolved the issues and applied, thanks.

>>>    };
>>>
>>> +#ifdef CONFIG_NEW_LEDS
>>>    struct platform_device *gpio_led_register_device(
>>>                   int id, const struct gpio_led_platform_data *pdata);
>>> +#else
>>> +static inline struct platform_device *gpio_led_register_device(
>>> +               int id, const struct gpio_led_platform_data *pdata)
>>> +{
>>> +       return 0;
>>> +}
>>> +#endif
>>>
>>>    enum cpu_led_event {
>>>           CPU_LED_IDLE_START,     /* CPU enters idle */
>>>
>>
>>
>
>


-- 
Best regards,
Jacek Anaszewski
