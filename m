Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:51333 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754241Ab1L0Ruf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Dec 2011 12:50:35 -0500
Message-ID: <4EFA0563.2060906@infradead.org>
Date: Tue, 27 Dec 2011 15:50:27 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Patrick Boettcher <pboettcher@kernellabs.com>
CC: Andreas Oberritter <obi@linuxtv.org>,
	Antti Palosaari <crope@iki.fi>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [RFCv1] add DTMB support for DVB API
References: <4EF3A171.3030906@iki.fi> <4EF48473.3020207@linuxtv.org> <201112231827.13375.pboettcher@kernellabs.com> <201112271726.33733.pboettcher@kernellabs.com>
In-Reply-To: <201112271726.33733.pboettcher@kernellabs.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 27-12-2011 14:26, Patrick Boettcher wrote:
> On Friday 23 December 2011 18:27:12 Patrick Boettcher wrote:
>> On Friday, December 23, 2011 02:38:59 PM Andreas Oberritter wrote:
>>> On 22.12.2011 22:30, Antti Palosaari wrote:
>>>> @@ -201,6 +205,9 @@ typedef enum fe_guard_interval {
>>>>
>>>>      GUARD_INTERVAL_1_128,
>>>>      GUARD_INTERVAL_19_128,
>>>>      GUARD_INTERVAL_19_256,
>>>>
>>>> +    GUARD_INTERVAL_PN420,
>>>> +    GUARD_INTERVAL_PN595,
>>>> +    GUARD_INTERVAL_PN945,
>>>>
>>>>  } fe_guard_interval_t;
>>>
>>> What does PN mean in this context?
>>
>> While I (right now) cannot remember what the PN abbreviation stands
>> for, the numbers are the guard time in micro-seconds. At least if I
>> remember correctly.
> 
> Totally wrong.
> 
> The number indicated by the PN-value is in samples. Not in micro-
> seconds.
> 
> To compare the PN value with the guard-time known from DVB-T we could do 
> like that: in DVB-T's 8K mode we have 8192 samples which make one 
> symbol. If the guard time is 1/32 we have 8192/32 samples which 
> represent the protect the symbols from inter-symbol-interference: 256 in 
> this case. 
> 
> In DTMB one symbol consists of 3780 samples + the PN-value. Using the 
> classical representation we could say: PN420 is 1/9, PN595 is about 1/6 
> and PN945 is 1/4.

PN595 is then 595/3780 = 119/756 = 17/108

While we might code it then as:

      GUARD_INTERVAL_1_9,		/* PN 420 */
      GUARD_INTERVAL_17_108,		/* PN 595 */
      GUARD_INTERVAL_1_4,		/* PN 945 */

in order to preserve the traditional way, maybe it should be coded, instead, as:

    GUARD_INTERVAL_420_SAMPLES,		/* PN 420 */
    GUARD_INTERVAL_595_SAMPLES,		/* PN 595 */
    GUARD_INTERVAL_945_SAMPLES,		/* PN 945 */

I would avoid "PN", as this meaning is not as clear as "samples" or as
a fraction. Also, the traditional guard interval won't be obvious for the
ones that know the DTMB spec.
> 
> HTH,
> 
> --
> Patrick Boettcher
> 
> Kernel Labs Inc.
> http://www.kernellabs.com/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

