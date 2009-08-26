Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta5.srv.hcvlny.cv.net ([167.206.4.200]:61869 "EHLO
	mta5.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753777AbZHZATU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Aug 2009 20:19:20 -0400
Received: from mbpwifi.kernelscience.com
 (ool-18bfe0d5.dyn.optonline.net [24.191.224.213]) by mta5.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0KOY00JH3JK99SF0@mta5.srv.hcvlny.cv.net> for
 linux-media@vger.kernel.org; Tue, 25 Aug 2009 20:19:21 -0400 (EDT)
Date: Tue, 25 Aug 2009 20:19:21 -0400
From: Steven Toth <stoth@kernellabs.com>
Subject: Re: Hauppauge 2250 - second tuner is only half working
In-reply-to: <4A947260.1040907@kernellabs.com>
To: seth@cyberseth.com
Cc: Steve Harrington <steve@Emel-Harrington.net>,
	linux-media@vger.kernel.org
Message-id: <4A947F89.3010705@kernellabs.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <283002305-1251239519-cardhu_decombobulator_blackberry.rim.net-845544064-@bxe1079.bisx.prod.on.blackberry>
 <4A946CB5.2010800@kernellabs.com> <4A947260.1040907@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 8/25/09 7:23 PM, Steven Toth wrote:
> On 8/25/09 6:59 PM, Steven Toth wrote:
>>> After reading Steven Toth's reply I tried adding 1 and then 2 2-way
>>> splitters before the 2250 input. No joy. I also tried feeding the cable
>>> directly into the 2250 with no splitters. Again - no joy.
>>> Any other ideas?
>>
>> Most likely this is dependent on what frequency the other tuner is tuned
>> to, especially since Seth indicated it worked for a short time. And,
>> again, I don't see the issue but two other people do.
>>
>> RMA is probably not the answer.
>>
>> When you next get a chance to test please use azap and keep track of
>> what frequency the first tuner is currently tuned to even if tuner#1 is
>> technically no longer streaming. I suspect varying the frequency on
>> tuner#1 will vary your test results.
>>
>
> OK, I can repro the issue.
>
> Tuning tuner 1 to 669 works, then tune tuner2 to 669 no lock. Set tuner
> #1 to 579 is locks, then tuner2 automatically also goes into lock.
>
> So, it depends on where tuner#1 was previously tuned to.
>
> I'll look into this.
>
> Save yourself the trouble of the RMA if it hasn't already shipped.
>

I was able to repro the issue once however during patching the issue went away, 
never to return - regardless of whether the patch was active or not. I even ran 
a series of cold boots to try and repro the behavior but I cannot.

I have seen the issue and I believe it exists, I just cannot get a reliable repro.

If you can test tuner 1 on selected frequencies then test tuner 2 always against 
channel 103 (669MHz) and find a reliable repro case then I'll take another look.

Annoying.

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
