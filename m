Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:44072 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149AbaBSHJ0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Feb 2014 02:09:26 -0500
Message-ID: <530458A1.8060609@gmail.com>
Date: Wed, 19 Feb 2014 16:09:21 +0900
From: Daniel Jeong <gshark.jeong@gmail.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Rob Landley <rob@landley.net>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [RFC v3,2/3] controls.xml : add addtional Flash fault bits
References: <1392371151-32644-1-git-send-email-gshark.jeong@gmail.com> <20140217094143.GU15635@valkosipuli.retiisi.org.uk>
In-Reply-To: <20140217094143.GU15635@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari.

Thank you for you comments.

> Hi Daniel,
>
> Thanks for the update.
>
> Daniel Jeong wrote:
>> Add addtional falult bits for FLASH
>> V4L2_FLASH_FAULT_UNDER_VOLTAGE	: UVLO
>> V4L2_FLASH_FAULT_INPUT_VOLTAGE	: input voltage is adjusted by IVFM
>> V4L2_FLASH_FAULT_LED_OVER_TEMPERATURE : NTC Trip point is crossed.
>>
>> Signed-off-by: Daniel Jeong <gshark.jeong@gmail.com>
>> ---
>>   Documentation/DocBook/media/v4l/controls.xml |   16 ++++++++++++++++
>>   1 file changed, 16 insertions(+)
>>
>> diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
>> index a5a3188..8121f7e 100644
>> --- a/Documentation/DocBook/media/v4l/controls.xml
>> +++ b/Documentation/DocBook/media/v4l/controls.xml
>> @@ -4370,6 +4370,22 @@ interface and may change in the future.</para>
>>       		  <entry>The flash controller has detected a short or open
>>       		  circuit condition on the indicator LED.</entry>
>>       		</row>
>> +    		<row>
>> +    		  <entry><constant>V4L2_FLASH_FAULT_UNDER_VOLTAGE</constant></entry>
>> +    		  <entry>Flash controller voltage to the flash LED
>> +    		  has been below the minimum limit specific to the flash
>> +    		  controller.</entry>
>> +    		</row>
>> +    		<row>
>> +    		  <entry><constant>V4L2_FLASH_FAULT_INPUT_VOLTAGE</constant></entry>
>> +    		  <entry>The flash controller has detected adjustment of input
>> +    		  voltage by Input Volage Flash Monitor(IVFM).</entry>
> Volage -> Voltage; space before "(".
>
> I still feel uncomfortable with the reference to the IVFM. That appears
> clearely an implementation specific term.
>
> You previously mentioned the flash current may be adjusted by the flash
> controller. It should be mentioned here.
>
> Is it possible to read the adjusted value from the chip?
>
Unfornatley it is NOT possible.
Usually thresholds can be selected,for example 2.9V, 3.0V, 3.1V, and 3.2V.
Chip adjusts the current value if the input voltage cross the thresholds.
We just read this flault flag from chip. So we need this.

I will describe more next patch.

>> +    		</row>
>> +    		<row>
>> +    		  <entry><constant>V4L2_FLASH_FAULT_LED_OVER_TEMPERATURE</constant></entry>
>> +    		  <entry>The flash controller has detected that TEMP input has
>> +    		  crossed NTC Trip Voltage.</entry>
> Even if the NTC resistor might be the actual implementation, I wouldn't
> refer to it here. There could be a real temperature sensor, for instance.

I will fix it.

>> +    		</row>
>>       	      </tbody>
>>       	    </entrytbl>
>>       	  </row>
>>

