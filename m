Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:35277 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbbBWTdo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Feb 2015 14:33:44 -0500
Received: by wevl61 with SMTP id l61so16716633wev.2
        for <linux-media@vger.kernel.org>; Mon, 23 Feb 2015 11:33:43 -0800 (PST)
Message-ID: <54EB8095.4080000@gmail.com>
Date: Mon, 23 Feb 2015 20:33:41 +0100
From: =?UTF-8?B?VHljaG8gTMO8cnNlbg==?= <tycholursen@gmail.com>
MIME-Version: 1.0
To: Rudy Zijlstra <rudy@grumpydevil.homelinux.org>,
	=?UTF-8?B?SG9uemEgUGV0?= =?UTF-8?B?cm91xaE=?=
	<jpetrous@gmail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: DVB Simulcrypt
References: <54E8F8F4.1010601@grumpydevil.homelinux.org>	<54E9F59A.4070407@grumpydevil.homelinux.org>	<CAJbz7-2efvftG4=UAphyLFjjuFpLZQKCFDzqXrwb-mfDg4A7SQ@mail.gmail.com>	<54EB016D.8040105@grumpydevil.homelinux.org> <CAJbz7-0U-s543mQ+a+sNt1V2m8T23X=ST5VYJ7LF0tk-n_yd8g@mail.gmail.com> <54EB2099.5040103@grumpydevil.homelinux.org> <54EB3784.4090908@gmail.com> <54EB4C85.1050003@grumpydevil.homelinux.org>
In-Reply-To: <54EB4C85.1050003@grumpydevil.homelinux.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Op 23-02-15 om 16:51 schreef Rudy Zijlstra:
> On 23-02-15 15:21, Tycho Lürsen wrote:
>>
>> Op 23-02-15 om 13:44 schreef Rudy Zijlstra:
>>> On 23-02-15 12:21, Honza Petrouš wrote:
>>>> 2015-02-23 11:31 GMT+01:00 Rudy Zijlstra 
>>>> <rudy@grumpydevil.homelinux.org>:
>>>>> On 23-02-15 08:44, Honza Petrouš wrote:
>>>>>
>>>>> Hi Rudy.
>>>>>
>>>>> 2015-02-22 16:28 GMT+01:00 Rudy Zijlstra 
>>>>> <rudy@grumpydevil.homelinux.org>:
>>>>>> Some more info
>>>>>>
>>>>>> On 21-02-15 22:30, Rudy Zijlstra wrote:
>>>>>>> Dears (Hans?)
>>>>>>>
>>>>>>> My setup, where the cable operator was using only irdeto, was 
>>>>>>> working
>>>>>>> good. Then the cable operator merged with another, and now the 
>>>>>>> networks are
>>>>>>> being merged. As a result, the encryption has moved from irdeto 
>>>>>>> only to
>>>>>>> simulcyrpt with Irdeto and Nagra.
>>>>>>>
>>>>>>> Current status:
>>>>>>> - when i put the CA card in a STB, it works
>>>>>>> - when trying to record an encrypted channel from PC, it no 
>>>>>>> longer works.
>>>>>> Recording system has 3 tuners. All equal, all with same 
>>>>>> permissions on the
>>>>>> smartcard. On cards 0 and 2 does not work, but card 1 does work, 
>>>>>> on all
>>>>>> channels tested.
>>>>>>
>>>>> Does it mean that descrambling is not working for you? If so,
>>>>> how do you manage descrambling? By CI-CAM module
>>>>> or by some "softcam" like oscam?
>>>>>
>>>>> Or do you record ENCRYPTED stream and decrypt the recordings
>>>>> later on?
>>>>>
>>>>>
>>>>> Each tuner has its own legal CI-CAM module. And yes, except for 
>>>>> the second
>>>>> tuner descrambling no longer works
>>>>>
>>>> I'm not much familiar with MythTV, so I'm guessing from the mux 
>>>> setup changes,
>>>> but did you check to descramble the same channel on different tuners?
>>>> To eliminate
>>>> the particular change inside one service only.
>>>>
>>>> Of course there can be also software issue in CI-CAM module itself
>>>> (fail in parsing
>>>> PMT CA descriptors etc).
>>>>
>>>> TBH, I think it must be application layer issue, not kernel one.
>>>>
>>> See above:
>>>
>>> Recording system has 3 tuners. All equal, all with same permissions 
>>> on the
>>> smartcard. On cards 0 and 2 does not work, but card 1 does work, on all
>>> channels tested.
>>>
>>> additional finfo: i tested the same channel(s) on all 3 tuners. For 
>>> now i have re-configured mythtv to use only the second tuner for 
>>> encrypted channels.
>>> This does reduce scheduling flexibility though.
>>>
>>> Would to understand what makes the difference, so i can ask the 
>>> right questions to MythTV developers.
>>>
>>>
>>> As the decryption does work with 1 tuner, i see 2 options:
>>> - depending on tuner id the default CA descriptor used is different, 
>>> and this selection is not expoerted on API level (kernel issue)
>>> - application needs to select which CA to use (and currently does 
>>> not do this)
>>>
>> It should be the latter one. I'm also having  Ziggo for provider, but 
>> always used FFdecsawrapper/Oscam for decryption (also legal in The 
>> Netherlands, providing you have a paid subscription)
>> ECM CA system id's 0x604 or 0x602 (depending on your region) gets you 
>> Irdeto, while ECM CA system id's 0x1850 or 0x1801 get you Nagra.
>> Correctly configured FFdecsa/Oscam can deal with it, MythTV probably 
>> cannot.
>> Check it out at: 
>> http://www.dtvmonitor.com/nl/?guid=0BE90D25-BA46-7B93-FDCD-20EFC79691E0
>> That's a snapshot from today, monitored from Groningen.
>>
> Tycho,
>
> thanks. looking at http://www.dtvmonitor.com/nl/ziggo-limburg the CA 
> id for Iredeto are same in Limburg as in Groningen.
>
> And yes, my CAM's are for Irdeto and do not support Nagra. To my 
> knowledge no valid Nagra CAM do exist for DVB-C
>
> Can FFdecsawrapper/Oscam be used in combination with MythTV?
>
> Cheers
>
>
> Rudy
Sure it can, I've been using it for many years with MythTV, up until 
now. Ziggo does not encrypt any channel that I'm actually using anymore.
As for the setup, I do know what I'm talking about, I've been the 
maintainer of FFdecsawrapper for about 3 years now.
For basic instructions (a how-to) look at my wiki pages:
http://www.lursen.org/wiki/FFdecsawrapper_with_MythTV_and_Oscam_on_Debian/Ubuntu
http://www.lursen.org/wiki/Speciaal:AllePaginas

Aren't we lucky to live in The Netherlands? (I mean in the US we'd 
probably be imprisoned for even mentioning the subject)

Tycho

