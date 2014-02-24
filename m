Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:53319 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450AbaBXEMo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Feb 2014 23:12:44 -0500
Message-ID: <530AC6B6.4060000@gmail.com>
Date: Mon, 24 Feb 2014 13:12:38 +0900
From: Daniel Jeong <gshark.jeong@gmail.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Rob Landley <rob@landley.net>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [RFC v5,2/3] controls.xml : add addtional Flash fault bits
References: <1392958166-4614-1-git-send-email-gshark.jeong@gmail.com> <53072326.7050809@iki.fi>
In-Reply-To: <53072326.7050809@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari
Thank you for your comments.
> Hi Daniel,
>
> Daniel Jeong wrote:
>> Added more comment about Input voltage flash monitor and external 
>> temp function.
>>
>> Signed-off-by: Daniel Jeong <gshark.jeong@gmail.com>
>> ---
>>   Documentation/DocBook/media/v4l/controls.xml |   18 ++++++++++++++++++
>>   1 file changed, 18 insertions(+)
>>
>> diff --git a/Documentation/DocBook/media/v4l/controls.xml 
>> b/Documentation/DocBook/media/v4l/controls.xml
>> index a5a3188..145a127 100644
>> --- a/Documentation/DocBook/media/v4l/controls.xml
>> +++ b/Documentation/DocBook/media/v4l/controls.xml
>> @@ -4370,6 +4370,24 @@ interface and may change in the future.</para>
>>                 <entry>The flash controller has detected a short or open
>>                 circuit condition on the indicator LED.</entry>
>>               </row>
>> +            <row>
>> + <entry><constant>V4L2_FLASH_FAULT_UNDER_VOLTAGE</constant></entry>
>> +              <entry>Flash controller voltage to the flash LED
>> +              has been below the minimum limit specific to the flash
>> +              controller.</entry>
>> +            </row>
>> +            <row>
>> + <entry><constant>V4L2_FLASH_FAULT_INPUT_VOLTAGE</constant></entry>
>> +              <entry>The flash controller has detected adjustment by 
>> IVFM
>> +              (Input Voltage Flash Monitor) block.
>> +          If during the flash current turn-on, the input voltage falls
>> +          below the threshold input voltage, IVFM adjust level</entry>
>
> Could you add an explanation what does this fault actually mean to the 
> user?
>
> "IVFM" at least doesn't say anything to me...
>
How about this ?
"The flash current can't reach to the target current due to the input 
voltage falling below lower limit
and flash controller adjusted the flash current not to occur low voltage 
envent"
>> +            </row>
>> +            <row>
>> + 
>> <entry><constant>V4L2_FLASH_FAULT_LED_OVER_TEMPERATURE</constant></entry>
>> +              <entry>The flash controller has detected that TEMP 
>> input has
>> +              crossed threshold by external temperature sensor.</entry>
>
> How about this instead?
>
> "The temperature of the LED has exceeded its allowed upper limit."
>
Ok.
