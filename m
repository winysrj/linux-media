Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:35852 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582Ab1IURwo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Sep 2011 13:52:44 -0400
Received: by eya28 with SMTP id 28so1163192eya.19
        for <linux-media@vger.kernel.org>; Wed, 21 Sep 2011 10:52:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E7A1481.1090205@redhat.com>
References: <4DA63A66.1070300@gmx.net>
	<4DC08CB8.3020105@redhat.com>
	<4DC13823.7000700@gmx.net>
	<4E7A1481.1090205@redhat.com>
Date: Wed, 21 Sep 2011 23:22:43 +0530
Message-ID: <CAHFNz9K3kAVeH=um-9yts4UkehUf9x=-C_3pfdhR5c4qZ4euvw@mail.gmail.com>
Subject: Re: TT-budget S2-3200 cannot tune on HB13E DVBS2 transponder
From: Manu Abraham <abraham.manu@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Lutz Sammer <johns98@gmx.net>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

On Wed, Sep 21, 2011 at 10:14 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Em 04-05-2011 08:27, Lutz Sammer escreveu:
>> On 05/04/11 01:16, Mauro Carvalho Chehab wrote:
>>> Em 13-04-2011 21:05, Lutz Sammer escreveu:
>>>>> On 05/04/11 21:07, Steffen Barszus wrote:
>>>>>> On Tue, 05 Apr 2011 13:00:14 +0200
>>>>>> "Issa Gorissen" <flop.m@xxxxxxx> wrote:
>>>>>>
>>>>>>> Hi,
>>>>>>>
>>>>>>> Eutelsat made a recent migration from DVB-S to DVB-S2 (since
>>>>>>> 31/3/2011) on two transponders on HB13E
>>>>>>>
>>>>>>> - HOT BIRD 6 13° Est TP 159 Freq 11,681 Ghz DVB-S2 FEC 3/4 27500
>>>>>>> Msymb/s 0.2 Pilot off Polar H
>>>>>>>
>>>>>>> - HOT BIRD 9 13° Est TP 99 Freq 12,692 Ghz DVB-S2 FEC 3/4 27500
>>>>>>> Msymb/s 0.2 Pilot off Polar H
>>>>>>>
>>>>>>>
>>>>>>> Before those changes, with my TT S2 3200, I was able to watch TV on
>>>>>>> those transponders. Now, I cannot even tune on those transponders. I
>>>>>>> have tried with scan-s2 and w_scan and the latest drivers from git.
>>>>>>> They both find the transponders but cannot tune onto it.
>>>>>>>
>>>>>>> Something noteworthy is that my other card, a DuoFlex S2 can tune
>>>>>>> fine on those transponders.
>>>>>>>
>>>>>>> My question is; can someone try this as well with a TT S2 3200 and
>>>>>>> post the results ?
>>>>>> i read something about it lately here (german!):
>>>>>> http://www.vdr-portal.de/board16-video-disk-recorder/board85-hdtv-dvb-s2/p977938-stb0899-fec-3-4-tester-gesucht/#post977938
>>>>>>
>>>>>> It says in stb0899_drv.c function:
>>>>>> static void stb0899_set_iterations(struct stb0899_state *state)
>>>>>>
>>>>>> This:
>>>>>> reg = STB0899_READ_S2REG(STB0899_S2DEMOD, MAX_ITER);
>>>>>> STB0899_SETFIELD_VAL(MAX_ITERATIONS, reg, iter_scale);
>>>>>> stb0899_write_s2reg(state, STB0899_S2DEMOD, STB0899_BASE_MAX_ITER, STB0899_OFF0_MAX_ITER, reg);
>>>>>>
>>>>>> should be replaced with this:
>>>>>>
>>>>>> reg = STB0899_READ_S2REG(STB0899_S2FEC, MAX_ITER);
>>>>>> STB0899_SETFIELD_VAL(MAX_ITERATIONS, reg, iter_scale);
>>>>>> stb0899_write_s2reg(state, STB0899_S2FEC, STB0899_BASE_MAX_ITER, STB0899_OFF0_MAX_ITER, reg);
>>>>>>
>>>>>> Basically replace STB0899_S2DEMOD with STB0899_S2FEC in this 2 lines
>>>>>> affected.
>>>>>>
>>>>>> Kind Regards
>>>>>>
>>>>>> Steffen
>>>>> Hi Steffen,
>>>>>
>>>>> Unfortunately, it does not help in my case. Thx anyway.
>>>>
>>>> Try my locking fix. With above patch I can lock the
>>>> channels without problem.
>>>
>>> Can someone confirm that such patch would fix the issue? If so, please
>>> forward it in a way that it could be applied (patch is currently line-wrapped),
>>> and submit with some comments/description and your SOB.
>>>
>>> As the patch is currently broken, I'm just marking it as rejected at patchwork.
>>>
>>> Manu,
>>>
>>> Please take a look on this trouble report.
>>>
>>
>> Sorry, the things are mixed here. My patch (resend and hopefully this
>> time not broken) handles only DVB-S transponders.
>>
>> The FEC fix patch fixed locking on 11,681 Ghz, but not on 12,692 Ghz for
>> me.  But I have very weak receiption,
>>
>> Johns
>
> Manu,
>
> We're still missing your review on this patch[1], or it were eventually
> missed. Please review it.
>
> Thanks,
> Mauro
>
> [1] http://patchwork.linuxtv.org/patch/6511/
>

Patch is good and correct. Thanks.
Reviewed-by: Manu Abraham <manu@linuxtv.org>
