Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:45212 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751819Ab1LXV4Y (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Dec 2011 16:56:24 -0500
Message-ID: <4EF64A83.5080606@iki.fi>
Date: Sat, 24 Dec 2011 23:56:19 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Patrick Boettcher <pboettcher@kernellabs.com>
CC: Andreas Oberritter <obi@linuxtv.org>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [RFCv1] add DTMB support for DVB API
References: <4EF3A171.3030906@iki.fi> <4EF48473.3020207@linuxtv.org> <201112231827.13375.pboettcher@kernellabs.com>
In-Reply-To: <201112231827.13375.pboettcher@kernellabs.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/23/2011 07:27 PM, Patrick Boettcher wrote:
> On Friday, December 23, 2011 02:38:59 PM Andreas Oberritter wrote:
>> On 22.12.2011 22:30, Antti Palosaari wrote:
>>> @@ -201,6 +205,9 @@ typedef enum fe_guard_interval {
>>>
>>>       GUARD_INTERVAL_1_128,
>>>       GUARD_INTERVAL_19_128,
>>>       GUARD_INTERVAL_19_256,
>>>
>>> +    GUARD_INTERVAL_PN420,
>>> +    GUARD_INTERVAL_PN595,
>>> +    GUARD_INTERVAL_PN945,
>>>
>>>   } fe_guard_interval_t;
>>
>> What does PN mean in this context?
>
> While I (right now) cannot remember what the PN abbreviation stands for, the
> numbers are the guard time in micro-seconds. At least if I remember
> correctly.
>
> I can confirm that Tuesday next week if no one else corrects me before.

I see you have sent that reply more than one day ago, but likely due to 
problems of your mail server it was delivered late. So I have already 
answered that.

Antti

-- 
http://palosaari.fi/
