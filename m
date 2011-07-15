Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36791 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750718Ab1GOEBk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jul 2011 00:01:40 -0400
Message-ID: <4E1FBB9E.7070103@redhat.com>
Date: Fri, 15 Jul 2011 01:01:34 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Oliver Endriss <o.endriss@gmx.de>
CC: linux-media@vger.kernel.org, Ralph Metzler <rjkm@metzlerbros.de>
Subject: Re: [PATCH 0/5] Driver support for cards based on Digital Devices
 bridge (ddbridge)
References: <201107032321.46092@orion.escape-edv.de> <201107150145.29547@orion.escape-edv.de> <4E1F8E1F.3000008@redhat.com> <201107150411.45222@orion.escape-edv.de>
In-Reply-To: <201107150411.45222@orion.escape-edv.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 14-07-2011 23:11, Oliver Endriss escreveu:
> On Friday 15 July 2011 02:47:27 Mauro Carvalho Chehab wrote:
>> Em 14-07-2011 20:45, Oliver Endriss escreveu:
>>> On Monday 04 July 2011 02:17:52 Mauro Carvalho Chehab wrote:
>>>> Em 03-07-2011 20:24, Oliver Endriss escreveu:
>>> ...
>>>>> Anyway, I spent the whole weekend to re-format the code carefully
>>>>> and create both patch series, trying not to break anything.
>>>>> I simply cannot go through the driver code and verify everything.
>>>>
>>>> As the changes on CHK_ERROR were done via script, it is unlikely that it
>>>> introduced any problems (well, except if some function is returning
>>>> a positive value as an error code, but I think that this is not the
>>>> case).
>>>>
>>>> I did the same replacement when I've cleanup the drx-d driver (well, the 
>>>> script were not the same, but it used a similar approach), and the changes 
>>>> didn't break anything, but it is safer to have a test, to be sure that no
>>>> functional changes were introduced.
>>>>
>>>> A simple test with the code and some working board is probably enough
>>>> to verify that nothing broke.
>>>
>>> Finally I found some time to do this 'simple' test.
>>
>> Thanks for testing it. Big changes on complex driver require testing.
>>
>>> Congratulations! You completely broke the DRXK for ngene and ddbridge:
>>> - DVB-T tuning does not work anymore.
>>
>> I don't have any DVB-T signal here. I'll double check what changed there
>> and see if I can identify a possible cause for it, but eventually I may
>> not discover what's wrong. 
>>
>> Before I start bisecting, I need to know if the starting point is working.
>> So, had you test that DVB-T was working after your cleanup patches?
> 
> Yes, it worked.
> 
> And now I double checked with media_build of July 3th + my patch series:
> It works as expected.

Ok, thanks for checking it. I'll see if I can discover what has changed.
 
> Well, I did not test DVB-C, but people reported that DVB-C was working
> before I applied my cleanups. So I assume it worked.

>>> (DVB-C not tested: I currently do not have access to a DVB-C signal.)
>>
>> Hmm... are you sure that DVB-C used to work? I found an error on DVB-C setup for
>> the device I used for test, fixed on this patch:
>>
>> http://git.linuxtv.org/media_tree.git?a=commitdiff;h=21ff98772327ff182f54d2fcca69448e440e23d3
>>
>> Basically, on the device I tested, scu command:
>> 	SCU_RAM_COMMAND_STANDARD_QAM | SCU_RAM_COMMAND_CMD_DEMOD_SET_PARAM
>> requires 2 parameters, instead of 4.
>>
>> I've preserved the old behavior there, assuming that your code was working, but I suspect that
>> at least you need to do this:
>>
>> +               setParamParameters[0] = QAM_TOP_ANNEX_A;
>> +               if (state->m_OperationMode == OM_QAM_ITU_C)
>> +                       setEnvParameters[0] = QAM_TOP_ANNEX_C;  /* Annex */
>> +               else
>> +                       setEnvParameters[0] = 0;
>> +
>> +               status = scu_command(state, SCU_RAM_COMMAND_STANDARD_QAM | SCU_RAM_COMMAND_CMD_DEMOD_SET_ENV, 1, setEnvParameters, 1, &cmdResult);
>>
>> Due to this logic there, at SetQAM:
>>
>>        	/* Env parameters */
>>         setEnvParameters[2] = QAM_TOP_ANNEX_A;  /* Annex */
>>         if (state->m_OperationMode == OM_QAM_ITU_C)
>>                 setEnvParameters[2] = QAM_TOP_ANNEX_C;  /* Annex */
>>
>> This var is filled, but there's no call to SCU_RAM_COMMAND_CMD_DEMOD_SET_ENV. Also,
>> iti initializes it as parameters[2], instead of parameters[0].
> 
> Sorry, I can't test it. Maybe Ralph can comment on this.

Ralph,

could you please double check the DEMOD_SET_ENV logic at the driver, before my fallback
code to use a 2 parameters call for scu_command, instead of 4 (required by the firmware
I have here for Terratec)?

Thanks!
Mauro
