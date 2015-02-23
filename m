Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:39838 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959AbbBWUcy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Feb 2015 15:32:54 -0500
Received: by wggx12 with SMTP id x12so1171649wgg.6
        for <linux-media@vger.kernel.org>; Mon, 23 Feb 2015 12:32:53 -0800 (PST)
Message-ID: <54EB8E73.2060808@gmail.com>
Date: Mon, 23 Feb 2015 21:32:51 +0100
From: =?UTF-8?B?VHljaG8gTMO8cnNlbg==?= <tycholursen@gmail.com>
MIME-Version: 1.0
To: =?UTF-8?B?SG9uemEgUGV0cm91xaE=?= <jpetrous@gmail.com>,
	Rudy Zijlstra <rudy@grumpydevil.homelinux.org>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: DVB Simulcrypt
References: <54E8F8F4.1010601@grumpydevil.homelinux.org>	<54E9F59A.4070407@grumpydevil.homelinux.org>	<CAJbz7-2efvftG4=UAphyLFjjuFpLZQKCFDzqXrwb-mfDg4A7SQ@mail.gmail.com>	<54EB016D.8040105@grumpydevil.homelinux.org>	<CAJbz7-0U-s543mQ+a+sNt1V2m8T23X=ST5VYJ7LF0tk-n_yd8g@mail.gmail.com>	<54EB2099.5040103@grumpydevil.homelinux.org>	<54EB3784.4090908@gmail.com>	<54EB4C85.1050003@grumpydevil.homelinux.org> <CAJbz7-2hQo-jtJCqx1OEuTOxtzVYNVR+e7SvssFJ5YY2ZU=YQw@mail.gmail.com>
In-Reply-To: <CAJbz7-2hQo-jtJCqx1OEuTOxtzVYNVR+e7SvssFJ5YY2ZU=YQw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Op 23-02-15 om 20:56 schreef Honza Petrouš:
> 2015-02-23 16:51 GMT+01:00 Rudy Zijlstra <rudy@grumpydevil.homelinux.org>:
>> On 23-02-15 15:21, Tycho Lürsen wrote:
>>>
>>> Op 23-02-15 om 13:44 schreef Rudy Zijlstra:
>>>> On 23-02-15 12:21, Honza Petrouš wrote:
>>>>> 2015-02-23 11:31 GMT+01:00 Rudy Zijlstra
>>>>> <rudy@grumpydevil.homelinux.org>:
>>>>>> On 23-02-15 08:44, Honza Petrouš wrote:
>>>>>>
>>>>>> Hi Rudy.
>>>>>>
>>>>>> 2015-02-22 16:28 GMT+01:00 Rudy Zijlstra
>>>>>> <rudy@grumpydevil.homelinux.org>:
>>>>>>> Some more info
>>>>>>>
>>>>>>> On 21-02-15 22:30, Rudy Zijlstra wrote:
>>>>>>>> Dears (Hans?)
>>>>>>>>
>>>>>>>> My setup, where the cable operator was using only irdeto, was working
>>>>>>>> good. Then the cable operator merged with another, and now the
>>>>>>>> networks are
>>>>>>>> being merged. As a result, the encryption has moved from irdeto only
>>>>>>>> to
>>>>>>>> simulcyrpt with Irdeto and Nagra.
>>>>>>>>
>>>>>>>> Current status:
>>>>>>>> - when i put the CA card in a STB, it works
>>>>>>>> - when trying to record an encrypted channel from PC, it no longer
>>>>>>>> works.
>>>>>>> Recording system has 3 tuners. All equal, all with same permissions on
>>>>>>> the
>>>>>>> smartcard. On cards 0 and 2 does not work, but card 1 does work, on
>>>>>>> all
>>>>>>> channels tested.
>>>>>>>
>>>>>> Does it mean that descrambling is not working for you? If so,
>>>>>> how do you manage descrambling? By CI-CAM module
>>>>>> or by some "softcam" like oscam?
>>>>>>
>>>>>> Or do you record ENCRYPTED stream and decrypt the recordings
>>>>>> later on?
>>>>>>
>>>>>>
>>>>>> Each tuner has its own legal CI-CAM module. And yes, except for the
>>>>>> second
>>>>>> tuner descrambling no longer works
>>>>>>
>>>>> I'm not much familiar with MythTV, so I'm guessing from the mux setup
>>>>> changes,
>>>>> but did you check to descramble the same channel on different tuners?
>>>>> To eliminate
>>>>> the particular change inside one service only.
>>>>>
>>>>> Of course there can be also software issue in CI-CAM module itself
>>>>> (fail in parsing
>>>>> PMT CA descriptors etc).
>>>>>
>>>>> TBH, I think it must be application layer issue, not kernel one.
>>>>>
>>>> See above:
>>>>
>>>> Recording system has 3 tuners. All equal, all with same permissions on
>>>> the
>>>> smartcard. On cards 0 and 2 does not work, but card 1 does work, on all
>>>> channels tested.
>>>>
>>>> additional finfo: i tested the same channel(s) on all 3 tuners. For now i
>>>> have re-configured mythtv to use only the second tuner for encrypted
>>>> channels.
>>>> This does reduce scheduling flexibility though.
>>>>
>>>> Would to understand what makes the difference, so i can ask the right
>>>> questions to MythTV developers.
>>>>
>>>>
>>>> As the decryption does work with 1 tuner, i see 2 options:
>>>> - depending on tuner id the default CA descriptor used is different, and
>>>> this selection is not expoerted on API level (kernel issue)
>>>> - application needs to select which CA to use (and currently does not do
>>>> this)
>>>>
>>> It should be the latter one. I'm also having  Ziggo for provider, but
>>> always used FFdecsawrapper/Oscam for decryption (also legal in The
>>> Netherlands, providing you have a paid subscription)
>>> ECM CA system id's 0x604 or 0x602 (depending on your region) gets you
>>> Irdeto, while ECM CA system id's 0x1850 or 0x1801 get you Nagra.
>>> Correctly configured FFdecsa/Oscam can deal with it, MythTV probably
>>> cannot.
>>> Check it out at:
>>> http://www.dtvmonitor.com/nl/?guid=0BE90D25-BA46-7B93-FDCD-20EFC79691E0
>>> That's a snapshot from today, monitored from Groningen.
>>>
>> Tycho,
>>
>> thanks. looking at http://www.dtvmonitor.com/nl/ziggo-limburg the CA id for
>> Iredeto are same in Limburg as in Groningen.
>>
>> And yes, my CAM's are for Irdeto and do not support Nagra. To my knowledge
>> no valid Nagra CAM do exist for DVB-C
>>
> I'm a bit fossil regarding current status of CA in DVB but anyway I can say
> I know that some years ago existed CI-CAM modules for Nagra, it was
> in time of so-called Nagra2 introduction on Hispasat ;)
>
> Dunno how is the current situation.
>
> An second - it has no difference if it is for sattelite or cable variant
> of DVB. The CI-CAM standard is the same. The only problem
> can be if support for particular provider is "baked" inside (meaning
> only particular auth data are inserted).
>
> /Honza
Thanks for the input Honza, but where we live, we are forced to use 
Irdeto. Moreover, such a Nagra CAM would not eliminate the supposed 
inability of MythTV to point (while tuning&locking) to the right CA 
descriptor in a reliable way.
Tycho


