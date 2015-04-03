Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:23581 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702AbbDCM4O (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Apr 2015 08:56:14 -0400
Message-id: <551E8DEA.5070205@samsung.com>
Date: Fri, 03 Apr 2015 14:56:10 +0200
From: Jacek Anaszewski <j.anaszewski@samsung.com>
MIME-version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	kyungmin.park@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
	rpurdie@rpsys.net, s.nawrocki@samsung.com,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	devicetree@vger.kernel.org
Subject: Re: [PATCH v4 01/12] DT: leds: Improve description of flash LEDs
 related properties
References: <1427809965-25540-1-git-send-email-j.anaszewski@samsung.com>
 <1427809965-25540-2-git-send-email-j.anaszewski@samsung.com>
 <20150403120910.GL20756@valkosipuli.retiisi.org.uk>
In-reply-to: <20150403120910.GL20756@valkosipuli.retiisi.org.uk>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 04/03/2015 02:09 PM, Sakari Ailus wrote:
> Hi Jacek,
>
> On Tue, Mar 31, 2015 at 03:52:37PM +0200, Jacek Anaszewski wrote:
>> Description of flash LEDs related properties was not precise regarding
>> the state of corresponding settings in case a property is missing.
>> Add relevant statements.
>> Removed is also the requirement making the flash-max-microamp
>> property obligatory for flash LEDs. It was inconsistent as the property
>> is defined as optional. Devices which require the property will have
>> to assert this in their DT bindings.
>>
>> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>> Cc: Bryan Wu <cooloney@gmail.com>
>> Cc: Richard Purdie <rpurdie@rpsys.net>
>> Cc: Pavel Machek <pavel@ucw.cz>
>> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
>> Cc: devicetree@vger.kernel.org
>> ---
>>   Documentation/devicetree/bindings/leds/common.txt |   16 +++++++++-------
>>   1 file changed, 9 insertions(+), 7 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/leds/common.txt b/Documentation/devicetree/bindings/leds/common.txt
>> index 747c538..21a25e4 100644
>> --- a/Documentation/devicetree/bindings/leds/common.txt
>> +++ b/Documentation/devicetree/bindings/leds/common.txt
>> @@ -29,13 +29,15 @@ Optional properties for child nodes:
>>        "ide-disk" - LED indicates disk activity
>>        "timer" - LED flashes at a fixed, configurable rate
>>
>> -- max-microamp : maximum intensity in microamperes of the LED
>> -		 (torch LED for flash devices)
>> -- flash-max-microamp : maximum intensity in microamperes of the
>> -                       flash LED; it is mandatory if the LED should
>> -		       support the flash mode
>> -- flash-timeout-us : timeout in microseconds after which the flash
>> -                     LED is turned off
>> +- max-microamp : Maximum intensity in microamperes of the LED
>> +		 (torch LED for flash devices). If omitted this will default
>> +		 to the maximum current allowed by the device.
>> +- flash-max-microamp : Maximum intensity in microamperes of the flash LED.
>> +		       If omitted this will default to the maximum
>> +		       current allowed by the device.
>> +- flash-timeout-us : Timeout in microseconds after which the flash
>> +                     LED is turned off. If omitted this will default to the
>> +		     maximum timeout allowed by the device.
>>
>>
>>   Examples:
>
> Pavel pointed out that the brightness between maximum current and the
> maximum *allowed* another current might not be noticeable,leading a
> potential spelling error to cause the LED being run at too high current.

Where did he point this out? Do you think about the current version
of the leds/common.txt documentation or there was some other message,
that I don't see?

Besides, I can't understand your point. Could you express it in other
words, please?

> The three drivers I've looked also require these properties, which I think
> is in the line with the above.

These properties were introduced two months ago and there is no merged
driver which require them. It means that the drivers that are currently
in the mainline assume that they can set the maximum current (please
note that max-microamp property refers to non-flash LEDs too).
The modifications I proposed just validate the current status.

> How about either dropping the patch, or changing maximum to minimum and
> will to should? The drivers could also behave this way instead of requiring
> the properties, but I don't think there's anything wrong with requiring the
> properties either.
>
> I think this is worth considering now as we can't change this later without
> breaking something.
>

-- 
Best Regards,
Jacek Anaszewski
