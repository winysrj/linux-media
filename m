Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:1421 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbaAYNos (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Jan 2014 08:44:48 -0500
Message-ID: <52E3BFC4.3020503@xs4all.nl>
Date: Sat, 25 Jan 2014 14:44:36 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org
Subject: Re: [REVIEW PATCH 10/13] DocBook: Software Defined Radio Interface
References: <1390511333-25837-1-git-send-email-crope@iki.fi> <1390511333-25837-11-git-send-email-crope@iki.fi> <52E37533.6010607@xs4all.nl> <52E3B5BA.5010808@iki.fi>
In-Reply-To: <52E3B5BA.5010808@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 01/25/2014 02:01 PM, Antti Palosaari wrote:
> On 25.01.2014 10:26, Hans Verkuil wrote:
>> A few comments below...
>>
>> On 01/23/2014 10:08 PM, Antti Palosaari wrote:
>>> Document V4L2 SDR interface.
>>>
>>> Cc: Hans Verkuil <hverkuil@xs4all.nl>
>>> Signed-off-by: Antti Palosaari <crope@iki.fi>
> 
>>> +    <section>
>>> +      <title>V4L2 in Linux 3.14</title>
>>
>> This should be 3.15.
> 
> OK. The goal was that 3.14 but fixing that documentation has taken over month.
> 
> 
>>> +
>>> +    <para>
>>> +The SDR capture device uses the <link linkend="format">format</link> ioctls to
>>> +select the capture format. Both the sampling resolution and the data streaming
>>
>> I understand why the data streaming format is bound to the format, but why is
>> the sampling resolution bound by it as well?
> 
> How can I explain that... it is not always bind to format nor it could be known 100% from sure from format. But resolution has some deep relation to format. Data is usually packed to smallest reasonable size in order to minimize needed transmission bandwidth. If you change sampling resolution then format likely changes too, as greater resolution needs more bits per sample and format carries samples. Lets take a some simple example:
> 
> Lets take an examples:
> A is 8-bit sample, number from range 0-255.
> B is 16-bit sample, number from range 0-65536.
> 
> Then your formats are defined, lets say V4L_FMT_SDR_U8 and V4L_FMT_SDR_U16.
> 
> Streams are sequence of those samples, use 10 samples here as example:
> A0A1A2A3A4A5A6A7A8A9 = 80bits, 10 bytes
> B0B1B2B3B4B5B6B7B8B9 = 160bits, 20 bytes
> 
> But you still don't know surely what is sampling resolution, only how it is represented. It is always more or less than that nominal value, die to many reasons. ADC datasheets usually define ENOB (effective number of bits) value. It is fairly common having 12bit resolution but ENOB is only around 10bit.
> 
> Here is example from Mirics, which shows different formats and resolutions:
> 
> format,resolution,sample rate (~max)
> 252    14         8613281
> 336    12        11484375
> 384    10+2      13125000 (packed, 2 bits dropped using some formula)
> 504    8         17226562
> 
> All in all, the idea was to tell user that the sampling resolution is selected according to dataformat he uses.

I'm sorry for having you work so hard on explaining this when the problem was with
my brain that confused 'resolution' with 'rate' :-) Well, they both start with 'r'...

Your text is fine.

> 
> 
>>> --- a/Documentation/DocBook/media/v4l/vidioc-g-fmt.xml
>>> +++ b/Documentation/DocBook/media/v4l/vidioc-g-fmt.xml
>>> @@ -172,6 +172,13 @@ capture and output devices.</entry>
>>>         </row>
>>>         <row>
>>>           <entry></entry>
>>> +        <entry>&v4l2-format-sdr;</entry>
>>> +        <entry><structfield>sdr</structfield></entry>
>>> +        <entry>Definition of an data format, see
>>
>> s/an data/a data/
> 
> OK
> 
> 
> regards
> Antti
> 

Regards,

	Hans
