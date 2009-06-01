Return-path: <linux-media-owner@vger.kernel.org>
Received: from [195.7.61.12] ([195.7.61.12]:46877 "EHLO killala.koala.ie"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756470AbZFAKER (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Jun 2009 06:04:17 -0400
Message-ID: <4A23A7A1.2010402@koala.ie>
Date: Mon, 01 Jun 2009 11:04:17 +0100
From: Simon Kenyon <simon@koala.ie>
MIME-Version: 1.0
To: "Igor M. Liplianin" <liplianin@me.by>
CC: linux-media@vger.kernel.org
Subject: Re: [linux-dvb] SDMC DM1105N not being detected
References: <e6ac15e50904022156u40221c3fib15d1b4cdf36461@mail.gmail.com> <4A1C4AF1.6020200@koala.ie> <200905302000.32353.liplianin@me.by> <200906010101.01925.liplianin@me.by>
In-Reply-To: <200906010101.01925.liplianin@me.by>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Igor M. Liplianin wrote:
> On 30 May 2009 20:00:32 Igor M. Liplianin wrote:
>   
>> On 26 May 2009 23:02:57 Simon Kenyon wrote:
>>     
>>> Igor M. Liplianin wrote:
>>>       
>>>> The card is working with external LNB power supply, for example,
>>>> through the loop out from another sat box. So, we need to know, which
>>>> way to control LNB power on the board. Usually it is through GPIO pins.
>>>> For example:
>>>> Pins 112 and 111 for GPIO0, GPIO1. Also GPIO15 is at 65 pin.
>>>> You can edit this lines in code:
>>>> -*-*-*-*-*-*-*-*-*-*-*-*-
>>>> /* GPIO's for LNB power control for Axess DM05 */
>>>> #define DM05_LNB_MASK                           0xfffffffc  // GPIO
>>>> control #define DM05_LNB_13V                            0x3fffd // GPIO
>>>> value #define DM05_LNB_18V                            0x3fffc // GPIO
>>>> value -*-*-*-*-*-*-*-*-*-*-*-*-
>>>>
>>>> BTW:
>>>> Bit value 0 for GPIOCTL means output, 1 - input.
>>>> Bit value for GPIOVAL - read/write.
>>>> GPIO pins count is 18. Bits over 18 affect nothing.
>>>>         
>>> i will try to work out the correct values
>>> when i have done so (or given up trying) i will let you know
>>>
>>> thank you very much for your help
>>> --
>>> simon
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>       
>> Patch against latest v4l-dvb.
>> Please, test it.
>>     
> Patch version 2
>
>   
the picture seems to be breaking up badly
will revert to my version and see if that fixes it
--
simon
