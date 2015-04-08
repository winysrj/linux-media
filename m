Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:31385 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbbDHKX2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Apr 2015 06:23:28 -0400
Message-id: <5525019B.8050104@samsung.com>
Date: Wed, 08 Apr 2015 12:23:23 +0200
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
 <5524ECDC.1070609@samsung.com>
 <20150408091129.GT20756@valkosipuli.retiisi.org.uk>
In-reply-to: <20150408091129.GT20756@valkosipuli.retiisi.org.uk>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 04/08/2015 11:11 AM, Sakari Ailus wrote:
> Hi Jacek,
>
> On Wed, Apr 08, 2015 at 10:54:52AM +0200, Jacek Anaszewski wrote:
>> Hi Sakari,
>>
>> On 04/03/2015 02:09 PM, Sakari Ailus wrote:
>>> Hi Jacek,
>>>
>>> On Tue, Mar 31, 2015 at 03:52:37PM +0200, Jacek Anaszewski wrote:
>>>> Description of flash LEDs related properties was not precise regarding
>>>> the state of corresponding settings in case a property is missing.
>>>> Add relevant statements.
>>>> Removed is also the requirement making the flash-max-microamp
>>>> property obligatory for flash LEDs. It was inconsistent as the property
>>>> is defined as optional. Devices which require the property will have
>>>> to assert this in their DT bindings.
>>>>
>>>> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
>>>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>>>> Cc: Bryan Wu <cooloney@gmail.com>
>>>> Cc: Richard Purdie <rpurdie@rpsys.net>
>>>> Cc: Pavel Machek <pavel@ucw.cz>
>>>> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
>>>> Cc: devicetree@vger.kernel.org
>>>> ---
>>>>   Documentation/devicetree/bindings/leds/common.txt |   16 +++++++++-------
>>>>   1 file changed, 9 insertions(+), 7 deletions(-)
>>>>
>>>> diff --git a/Documentation/devicetree/bindings/leds/common.txt b/Documentation/devicetree/bindings/leds/common.txt
>>>> index 747c538..21a25e4 100644
>>>> --- a/Documentation/devicetree/bindings/leds/common.txt
>>>> +++ b/Documentation/devicetree/bindings/leds/common.txt
>>>> @@ -29,13 +29,15 @@ Optional properties for child nodes:
>>>>        "ide-disk" - LED indicates disk activity
>>>>        "timer" - LED flashes at a fixed, configurable rate
>>>>
>>>> -- max-microamp : maximum intensity in microamperes of the LED
>>>> -		 (torch LED for flash devices)
>>>> -- flash-max-microamp : maximum intensity in microamperes of the
>>>> -                       flash LED; it is mandatory if the LED should
>>>> -		       support the flash mode
>>>> -- flash-timeout-us : timeout in microseconds after which the flash
>>>> -                     LED is turned off
>>>> +- max-microamp : Maximum intensity in microamperes of the LED
>>>> +		 (torch LED for flash devices). If omitted this will default
>>>> +		 to the maximum current allowed by the device.
>>>> +- flash-max-microamp : Maximum intensity in microamperes of the flash LED.
>>>> +		       If omitted this will default to the maximum
>>>> +		       current allowed by the device.
>>>> +- flash-timeout-us : Timeout in microseconds after which the flash
>>>> +                     LED is turned off. If omitted this will default to the
>>>> +		     maximum timeout allowed by the device.
>>>>
>>>>
>>>>   Examples:
>>>
>>> Pavel pointed out that the brightness between maximum current and the
>>> maximum *allowed* another current might not be noticeable, leading a
>>> potential spelling error to cause the LED being run at too high current.
>>
>> I think that a board designed so that it can be damaged because of
>> software bugs should be considered not eligible for commercial use.
>> Any self-esteeming manufacturer will not connect a LED to the output
>> that can produce the current greater than the LED's absolute maximum
>> current.
>
> The maximum current *is* used to prevent potential hardware damage.

What hardware are we talking about - LED controller or the discrete
LED component attached to the LED controller's current output?

The maximum current the LED controller can produce is fixed or depends
on external components like resistors.

This is at least the case for max77693 and aat1290 device I've been
working with. If a LED is rated to max 1A and it will be connected
to the output capable of producing 1.2A then it is likely that it
will be damaged. I was thinking about this kind of hardware damage.

How vendors can protect from it if they connect incompatible LED
to the current output?

There might be boards that provide sockets for connecting external
LEDs though. Such arrangements indeed justify the need for making the
properties required.

> This is
> how mobile phones typically are, probably also the one you're using. :-) I
> don't believe there's really a difference between vendors in this respect.
>
> We still lack a proper way to model the temperature of the flash LED, so
> what we have now is a bit incomplete, but at least it prevents causing
> damage unintentionally.

Are you thinking about flash faults?

>> The DT properties could be useful for devices like aat1290 device I was
>> writing a driver for, which has the maximum current and timeout values
>> depending on corresponding capacitor and resistor values respectively.
>> Such devices should make the properties required in their bindings.
>>
>>> The three drivers I've looked also require these properties, which I think
>>> is in the line with the above.
>>>
>>> How about either dropping the patch, or changing maximum to minimum and
>>> will to should? The drivers could also behave this way instead of requiring
>>> the properties, but I don't think there's anything wrong with requiring the
>>> properties either.
>>
>> As I mentioned in the previous message in this subject, the max-microamp
>> property refers also to non-flash LEDs. Since existing LED class devices
>> does not require them, then it should be left optional and default to
>> max. It would however be inconsistent with flash LEDs related
>> properties.
>
> I do agree with Pavel here, these should be mandatory (at least for new
> drivers) OR default to minimum.
>


-- 
Best Regards,
Jacek Anaszewski
