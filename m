Return-path: <mchehab@gaivota>
Received: from cmsout02.mbox.net ([165.212.64.32]:35214 "EHLO
	cmsout02.mbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216Ab1ELMYR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 May 2011 08:24:17 -0400
Message-ID: <4DCBD154.5060904@usa.net>
Date: Thu, 12 May 2011 14:23:48 +0200
From: Issa Gorissen <flop.m@usa.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Manu Abraham <abraham.manu@gmail.com>
Subject: Re: TT-budget S2-3200 cannot tune on HB13E DVBS2 transponder
References: <4DA63A66.1070300@gmx.net> <4DC08CB8.3020105@redhat.com> <4DC13823.7000700@gmx.net>
In-Reply-To: <4DC13823.7000700@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On 04/05/2011 13:27, Lutz Sammer wrote:
> On 05/04/11 01:16, Mauro Carvalho Chehab wrote:
>> Em 13-04-2011 21:05, Lutz Sammer escreveu:
>>>> On 05/04/11 21:07, Steffen Barszus wrote:
>>>>> On Tue, 05 Apr 2011 13:00:14 +0200
>>>>> "Issa Gorissen" <flop.m@xxxxxxx> wrote:
>>>>>
>>>>>> Hi,
>>>>>>
>>>>>> Eutelsat made a recent migration from DVB-S to DVB-S2 (since
>>>>>> 31/3/2011) on two transponders on HB13E
>>>>>>
>>>>>> - HOT BIRD 6 13° Est TP 159 Freq 11,681 Ghz DVB-S2 FEC 3/4 27500
>>>>>> Msymb/s 0.2 Pilot off Polar H
>>>>>>
>>>>>> - HOT BIRD 9 13° Est TP 99 Freq 12,692 Ghz DVB-S2 FEC 3/4 27500
>>>>>> Msymb/s 0.2 Pilot off Polar H
>>>>>>
>>>>>>
>>>>>> Before those changes, with my TT S2 3200, I was able to watch TV on
>>>>>> those transponders. Now, I cannot even tune on those transponders. I
>>>>>> have tried with scan-s2 and w_scan and the latest drivers from git.
>>>>>> They both find the transponders but cannot tune onto it.
>>>>>>
>>>>>> Something noteworthy is that my other card, a DuoFlex S2 can tune
>>>>>> fine on those transponders.
>>>>>>
>>>>>> My question is; can someone try this as well with a TT S2 3200 and
>>>>>> post the results ?
>>>>> i read something about it lately here (german!): 
>>>>> http://www.vdr-portal.de/board16-video-disk-recorder/board85-hdtv-dvb-s2/p977938-stb0899-fec-3-4-tester-gesucht/#post977938
>>>>>
>>>>> It says in stb0899_drv.c function:
>>>>> static void stb0899_set_iterations(struct stb0899_state *state) 
>>>>>
>>>>> This:
>>>>> reg = STB0899_READ_S2REG(STB0899_S2DEMOD, MAX_ITER);
>>>>> STB0899_SETFIELD_VAL(MAX_ITERATIONS, reg, iter_scale);
>>>>> stb0899_write_s2reg(state, STB0899_S2DEMOD, STB0899_BASE_MAX_ITER, STB0899_OFF0_MAX_ITER, reg);
>>>>>
>>>>> should be replaced with this:
>>>>>
>>>>> reg = STB0899_READ_S2REG(STB0899_S2FEC, MAX_ITER);
>>>>> STB0899_SETFIELD_VAL(MAX_ITERATIONS, reg, iter_scale);
>>>>> stb0899_write_s2reg(state, STB0899_S2FEC, STB0899_BASE_MAX_ITER, STB0899_OFF0_MAX_ITER, reg);
>>>>>
>>>>> Basically replace STB0899_S2DEMOD with STB0899_S2FEC in this 2 lines
>>>>> affected.
>>>>>
>>>>> Kind Regards 
>>>>>
>>>>> Steffen
>>>> Hi Steffen,
>>>>
>>>> Unfortunately, it does not help in my case. Thx anyway.
>>> Try my locking fix. With above patch I can lock the
>>> channels without problem.
>> Can someone confirm that such patch would fix the issue? If so, please
>> forward it in a way that it could be applied (patch is currently line-wrapped),
>> and submit with some comments/description and your SOB.
>>
>> As the patch is currently broken, I'm just marking it as rejected at patchwork.
>>
>> Manu,
>>
>> Please take a look on this trouble report.

Hi,

Just to report that I can lock on those problematic transponders with
kernel 2.6.37 (and with an amp on the coax of 40m long), but not with
2.6.39-rc6.

I figured the patch which might cause my problem is the following

[media] stb6100: Improve tuner performance
[http://git.linuxtv.org/media_tree.git?a=commitdiff;h=f14bfe94e459cb070a489e1786f26d54e9e7b5de]


I recall that in this thread
[http://www.mail-archive.com/linux-media@vger.kernel.org/msg29712.html],
there were concerns about the above patch.

Is it possible to remove it from 2.6.39 release and do further research
or is it too late ?

Thx,
--
Issa
