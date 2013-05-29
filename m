Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:37739 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934764Ab3E2R7f (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 29 May 2013 13:59:35 -0400
Message-ID: <51A641DE.9020403@iki.fi>
Date: Wed, 29 May 2013 20:58:54 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: LMML <linux-media@vger.kernel.org>
Subject: Re: Keene
References: <5167513D.60804@iki.fi> <201304190912.06319.hverkuil@xs4all.nl> <51710A3F.10909@iki.fi> <201305291626.20170.hverkuil@xs4all.nl>
In-Reply-To: <201305291626.20170.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/29/2013 05:26 PM, Hans Verkuil wrote:
> On Fri April 19 2013 11:11:27 Antti Palosaari wrote:
>> On 04/19/2013 10:12 AM, Hans Verkuil wrote:
>>> On Wed April 17 2013 21:45:24 Antti Palosaari wrote:
>>>> On 04/15/2013 09:55 AM, Hans Verkuil wrote:
>>>>> On Fri April 12 2013 02:11:41 Antti Palosaari wrote:
>>>>>> Hello Hans,
>>>>>> That device is working very, thank you for it. Anyhow, I noticed two things.
>>>>>>
>>>>>> 1) it does not start transmitting just after I plug it - I have to
>>>>>> retune it!
>>>>>> Output says it is tuned to 95.160000 MHz by default, but it is not.
>>>>>> After I issue retune, just to same channel it starts working.
>>>>>> $ v4l2-ctl -d /dev/radio0 --set-freq=95.16
>>>>>
>>>>> Can you try this patch:
>>>>>
>>>>
>>>> It does not resolve the problem. It is quite strange behavior. After I
>>>> install modules, and modules are unload, plug stick in first time, it
>>>> usually (not every-time) starts TX. But when I replug it without
>>>> unloading modules, it will never start TX. Tx is started always when I
>>>> set freq using v4l2-ctl.
>>>
>>> If you replace 'false' by 'true' in the cmd_main, does that make it work?
>>> I'm fairly certain that's the problem.
>>
>> Nope, I replaces all 'false' with 'true' and problem remains. When
>> modules were unload and device is plugged it starts TX. When I replug it
>> doesn't start anymore.
>>
>> I just added msleep(1000); just before keene_cmd_main() in .probe() and
>> now it seems to work every-time. So it is definitely timing issue. I
>> will try to find out some smallest suitable value for sleep and and sent
>> patch.
>
> Have you had time to find a smaller msleep value?

Nope, but I will do it today (if I don't meet any problems when 
upgrading to latest master).

regards
Antti

-- 
http://palosaari.fi/
