Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:42809 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751283AbbCVLaH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Mar 2015 07:30:07 -0400
Message-ID: <550EA7BC.60206@iki.fi>
Date: Sun, 22 Mar 2015 13:30:04 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Benjamin Larsson <benjamin@southpole.se>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/1] mn88473: implement lock for all delivery systems
References: <1426714629-15640-1-git-send-email-benjamin@southpole.se> <550AE0CC.5050407@iki.fi> <550CA9B4.4050903@southpole.se> <550CAC52.50700@iki.fi> <550D455F.4050500@southpole.se>
In-Reply-To: <550D455F.4050500@southpole.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/21/2015 12:18 PM, Benjamin Larsson wrote:
> On 03/21/2015 12:25 AM, Antti Palosaari wrote:
>> On 03/21/2015 01:13 AM, Benjamin Larsson wrote:
>>> On 03/19/2015 03:44 PM, Antti Palosaari wrote:
>>>> Bad news. It does lock for DVB-C now, but DVB-T nor DVB-T2 does not
>>>> lock.
>>>>
>>>> regards
>>>> Antti
>>>
>>> I'm getting tired :/. Had the time to test now and the checks is
>>> supposed to be negated.
>>>
>>> if (utmp & 0xA0) { -> if (!(utmp & 0xA0))
>>>
>>> But as stock dvbv5-scan crashes on ubuntu 14.04 and I can't unload the
>>> mn88473 module I will confirm this when I have an actual working version
>>> of dvbv5-scan and Ubuntu.
>>
>> You could also use w_scan. Or install latest dvbv5-scan from git - it
>> works even without install by running from compile directory.
>
> Ok, will try that later.
>
> Anyway, I tried the attached patch and I was able to get a lock after a
> reboot from windows with the windows driver initializing the stick. If I
> replugged the stick I get no signal and if I try the rtl2832 demod it
> reports the same. So I think that my signal is just to weak for the
> kernel r820t driver. So it would be nice if you could test this patch
> and see if it works.

Now it works. Next time I really expect you will test your patches 
somehow before sending. Now I tested 3 different patch versions, find 2 
first to be broken and last one working. It took around 2 hours of my time.

Patch applied.

Antti


>
>
>>
>> regards
>> Antti
>>
>
> MvH
> Benjamin Larsson

-- 
http://palosaari.fi/
