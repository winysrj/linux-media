Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:35585 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187Ab1HSUac (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Aug 2011 16:30:32 -0400
Received: by eyx24 with SMTP id 24so1980227eyx.19
        for <linux-media@vger.kernel.org>; Fri, 19 Aug 2011 13:30:31 -0700 (PDT)
Message-ID: <4E4EC7E3.8030500@gmail.com>
Date: Fri, 19 Aug 2011 22:30:27 +0200
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCHv2] adp1653: make ->power() method optional
References: <20110818092158.GA8872@valkosipuli.localdomain>	 <98c77ce2a17d7a098dedfc858f4055edc5556c54.1313666504.git.andriy.shevchenko@linux.intel.com>	 <1313667122.25065.8.camel@smile>	 <20110818115131.GD8872@valkosipuli.localdomain> <1313674341.25065.17.camel@smile> <4E4D4840.7050207@gmail.com> <4E4D61CD.40405@iki.fi> <4E4D7D3A.4040708@gmail.com> <4E4E8C7B.7090806@iki.fi>
In-Reply-To: <4E4E8C7B.7090806@iki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/19/2011 06:16 PM, Sakari Ailus wrote:
> Sylwester Nawrocki wrote:
>> On 08/18/2011 09:02 PM, Sakari Ailus wrote:
>>>>>>>
>>>>>>> He-h, I guess you are not going to apply this one.
>>>>>>> The patch breaks init logic of the device. If we have no ->power(), we
>>>>>>> still need to bring the device to the known state. I have no good idea
>>>>>>> how to do this.
>>>>>>
>>>>>> I don't think it breaks anything actually. Albeit in practice one is still
>>>>>> likely to put the adp1653 reset line to the board since that lowers its power
>>>>>> consumption significantly.
>>>>> Yeah, even in practice we might see various ways of a chip connection.
>>>>>
>>>>>> Instead of being in power-up state after opening the flash subdev, it will
>>>>>> reach this state already when the system is powered up. At subdev open all
>>>>>> the relevant registers are written to anyway, so I don't see an issue here.
>>>>> You mean at first writing to the V4L2 value, do you? Because ->open()
>>>>> uses set_power() which will be skipped in case of no ->power method
>>>>> defined.
>>>>>
>>>>>> I think either this one, or one should check in probe() that the power()
>>>>>> callback is non-NULL.
>>>>>> The board code is going away in the near future so this callback will
>>>>>> disappear eventually anyway.
>>>>> So, it's up to you to include or not my last patch.
>>>>>
>>>>>> The gpio code in the board file should likely
>>>>>> be moved to the driver itself.
>>>>> The line could be different, the hw could be used in environment w/o
>>>>> gpio, but with (for example) external gate, and so on. I think current
>>>>> generic driver is pretty okay.
>>>>
>>>> Would it make sense to use the regulator API in place of the platform_data
>>>> callback? If there is only one GPIO then it's easy to create a 'fixed voltage
>>>> regulator' for this.
>>>
>>> I don't know the regulator framework very well, but do you mean creating a new
>>> regulator which just controls a gpio? It would be preferable that this wouldn't
>>> create a new driver nor add any board core.
>>
>> I'm afraid your requirements are too demanding :)
>> Yes, I meant creating a new regulator. In case the ADP1635 voltage regulator
>> is inhibited through a GPIO at a host processor such regulator would in fact
>> be only flipping a GPIO (and its driver would request the GPIO and set it into
>> a default inactive state during its initialization). But the LDO for ADP1635
> 
> Thinking about this again, I think we'd need a regulator and reset gpio.
> The reset line probably can't be really modelled as a power supply, as
> the voltage provided to the chip is different from the reset line. Both
> may exist on some boards.
> 
> The regulator might be a dummy one, too, as well as the reset line. 

Yes, this would make the driver most complete I guess.
And the gpio API seems a natural choice for the reset signal. If there is
some 'non-standard' circuit to drive the ADP1635 pin possibly it can be
handled by some existing or dedicated gpio driver.


--
Regards,
Sylwester
