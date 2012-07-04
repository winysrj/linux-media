Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:63340 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755738Ab2GDTGZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Jul 2012 15:06:25 -0400
Message-ID: <4FF4911B.9090600@web.de>
Date: Wed, 04 Jul 2012 20:53:15 +0200
From: =?UTF-8?B?QW5kcsOpIFdlaWRlbWFubg==?= <Andre.Weidemann@web.de>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: Steve Hill <steve@nexusuk.org>, linux-media@vger.kernel.org
Subject: Re: pctv452e
References: <4FF4697C.8080602@nexusuk.org> <4FF46DC4.4070204@iki.fi>
In-Reply-To: <4FF46DC4.4070204@iki.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04.07.2012 18:22, Antti Palosaari wrote:
> On 07/04/2012 07:04 PM, Steve Hill wrote:
>>  >> Ps. Steve, could you please give me full version of kernel which
>>  >> works with pctv452e?
>>
>> I think it was 2.6.37-1-kirkwood from Debian which I was using (this is
>> an ARM system).
>>
>>  > As the new DVB-USB fixes many bugs I ask you to test it. I converted
>>  > pctv452e driver for you:
>>  >
>>  >
>> http://git.linuxtv.org/anttip/media_tree.git/shortlog/refs/heads/pctv452e
>>  >
>>  > Only PCTV device supported currently, not TechnoTrend at that time.
>>
>> Can I ask why it only works on the PCTV devices?  I was under the
>> impression that the TechnoTrend hardware was identical?
>>
>>
>> If you are able to provide any pointers as to where the TechnoTrend
>> support is broken (or what debugging I should be turning on to figure
>> out where it is broken) then that would be helpful.
>
> I don't have hardware, no PCTV neither TechnoTrend. I just converted
> PCTV as Marx seems to have such device and he was blaming. Code wasn't
> 100% similar, for example TechnoTrend has CI PCTV doesn't.
>
> It should not fix problems but it could since I fixed some nasty bugs.
> Lets wait test report first and make decision what to do after that.

The pctv452e and TT-connect S2-3600 are identical in hardware. Only USB 
IDs and remote control codes differ between the two. The Pinnacle box 
has its own remote. The TT-connect uses the same RC as the TT-budget series.
The TT-connect S2-3650-CI has an additional CI slot.

André

