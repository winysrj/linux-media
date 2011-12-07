Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:61924 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756152Ab1LGPvI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Dec 2011 10:51:08 -0500
Received: by eaak14 with SMTP id k14so608160eaa.19
        for <linux-media@vger.kernel.org>; Wed, 07 Dec 2011 07:51:06 -0800 (PST)
Message-ID: <4EDF8B68.1040009@gmail.com>
Date: Wed, 07 Dec 2011 16:51:04 +0100
From: Gianluca Gennari <gennarone@gmail.com>
Reply-To: gennarone@gmail.com
MIME-Version: 1.0
To: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 0/1] xc3028: force reload of DTV7 firmware in VHF band
 with Zarlink demodulator
References: <4EDE27A0.8060406@gmail.com> <4EDF6640.801@redhat.com> <4EDF6E7E.30200@gmail.com> <4EDF762A.9030604@redhat.com> <4EDF7DF3.1080007@gmail.com> <4EDF80AF.5060709@redhat.com> <4EDF8A22.6020201@gmail.com>
In-Reply-To: <4EDF8A22.6020201@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Il 07/12/2011 16:45, Gianluca Gennari ha scritto:
> Il 07/12/2011 16:05, Mauro Carvalho Chehab ha scritto:
>> On 07-12-2011 12:53, Gianluca Gennari wrote:
>>> Il 07/12/2011 15:20, Mauro Carvalho Chehab ha scritto:
>>>> On 07-12-2011 11:47, Gianluca Gennari wrote:
>>>>> Il 07/12/2011 14:12, Mauro Carvalho Chehab ha scritto:
>>>>>> On 06-12-2011 12:33, Gianluca Gennari wrote:
>>>>>>> Hi All,
>>>>>>>
>>>>>>> I have a Terratec Cinergy Hybrid T USB XS stick (USB 0ccd:0042).
>>>>>>> This device is made of the following components:
>>>>>>> - Empiatech em2880 USB bridge;
>>>>>>> - Zarlink zl10353 demodulator;
>>>>>>> - Xceive XC3028 tuner;
>>>>>>>
>>>>>>> For this device, the ZARLINK456 define is set to true so it is using
>>>>>>> the
>>>>>>> firmwares with type D2633 for the XC3028 tuner.
>>>>>>>
>>>>>>> I found out that:
>>>>>>> 1) the DTV7 firmware works fine in VHF band (bw=7MHz);
>>>>>>> 2) the DTV8 firmware works fine in UHF band (bw=8MHz);
>>>>>>> 3) the DTV78 firmware works fine in UHF band (bw=8MHz) but it
>>>>>>> doesn not
>>>>>>> work at all in VHF band (bw=7MHz);
>>>>>>>
>>>>>>> In fact, when the DTV78 firmware is loaded and I try to tune a VHF
>>>>>>> channel, the frequency lock is ciclically acquired for a second and
>>>>>>> immediately lost.
>>>>>>> So the proposed patch forces a reload of the DTV7 firmware every
>>>>>>> time a
>>>>>>> 7MHz channel is requested.
>>>>>>> The only drawback is that channel change from VHF to UHF or
>>>>>>> viceversa is
>>>>>>> slightly slower.
>>>>>>> Devices using the D2620 firmwares are unaffected.
>>>>>>
>>>>>> Hi Gianluca,
>>>>>>
>>>>>> The issues with firmware DTV78 x DTV7/DTV8 are old. No matter what we
>>>>>> do,
>>>>>> we end by having troubles, as the issue is Country-dependent. For
>>>>>> example,
>>>>>> Australia requires a different firmware than Germany, due to the
>>>>>> differences
>>>>>> on the VHF/UHF bands.
>>>>>>
>>>>>> I prefer if you could work into a patch that would add some modprobe
>>>>>> parameter
>>>>>> to disable the current "autodetection" way, allowing to override the
>>>>>> firmware
>>>>>> used for VHF and UHF.
>>>>>>
>>>>>> Thanks,
>>>>>> Mauro
>>>>>>
>>>>>
>>>>> Hi Mauro,
>>>>> thanks for the feedback. Unfortunately I do not have any info on which
>>>>> kind of firmware is needed on other parts of the world. All I know is
>>>>> what is happening here in Italy, and what I can understand reading the
>>>>> code. I suppose my findings can be extended to the rest of Europe, and
>>>>> maybe Africa and Middle-East.
>>>>
>>>> Even in Europe, there are some differences.
>>>>
>>>
>>> OK, so the validity of my findings are restricted to Italy.
>>>
>>>>> Can you provide a reference about problems in other continents like
>>>>> Australia?
>>>>
>>>> All I know is from the constant reports at the ML from users. We used to
>>>> have a developer in Australia, but he moved away, and it seems that
>>>> he lost
>>>> interest on DVB development, as we were unable to contact him ever
>>>> since.
>>>>>
>>>>> Do you think a simple module parameters that allows to enable/disable
>>>>> the usage of the DTV78 firmware would do the trick?
>>>>
>>>> Perhaps one or two module parameters to allow forcing a certain firmware
>>>> for
>>>> VHF and UHF.
>>>
>>> Seems reasonable.
>>>
>>>>> Eventually, do you agree that the default solution should be to DISABLE
>>>>> DTV78 firmware, since this seems to be the more robust solution, and
>>>>> let
>>>>> the user enable it through the kernel parameter if it is working in his
>>>>> country? Or do you prefer the other way around, so by default  DTV78
>>>>> firmware is enabled, and users with problems can disable it through the
>>>>> kernel module parameter?
>>>>
>>>> AFAIK, DTV78 should be used in Spain and in Germany. Changing the
>>>> current
>>>> default doesn't look a good idea, as it will cause regressions, if
>>>> the new
>>>> way is not backward-compatible.
>>>
>>> With the proposed patch DTV78 will be used in UHF band, while DTV7 in
>>> VHF band. Will this make any difference in Spain or Germany?
>>
>> Not sure. I don't live there ;)
>>
>>> What about a kernel parameter to specify the country?
>>> Something like:
>>>
>>> country={0-4}
>>>
>>> DEFAULT=0,ITALY=1,GERMANY=2,SPAIN=3,AUSTRALIA=4
>>>
>>> Then we could specify a well-defined behavior for each country, hiding
>>> the firmware-related problems to the user (which will have problems
>>> understanding parameters like force-DTV7-firmware-in-VHF-band).
>>>
>>> All I need to know is what is the best behavior for each country.
>>
>> That's the hardest part ;) We would need someone on each possible Country,
>> in order to test. Also, a per-country setup like that sucks. Ideally, the
>> driver should use the bandwidh and the other information at the standard
>> DVB
>> parameters, in order to select the right firmware. This works with all
>> other
>> frontends. Not sure what's broken on xc3028 design that it requires a
>> per-country
>> hack. I suspect that it is not a pure per-country hack, but it is also per
>> demod.
>>
>> As we don't have much complains about it nowadays, I assume that the
>> current
>> behavior is ok for most users. So, a parameter would be used only for those
>> where the default behavior doesn't work.
>>
>> Btw, we already have a similar parameter to force the audio demodulation
>> standard,
>> due to the same reasons.
>>
>> Regards,
>> Mauro
>>
> 
> Probably there are no complains about the firmware because in most
> countries VHF is not used at all, or is only used for marginal TV
> stations. In Italy instead the main DTT mux (RAI mux 1) is broadcasted
> in VHF band for historical reasons, so many Italian users are concerned
> about it. I've already faced problems related to DTT VHF reception, that
> were never noticed before by users from other countries.
> 
> Moreover, another problem is that there are 2 firmwares types: D2633 and
> D2620; also there are 2 completely different files: xc3028-v27.fw and
> xc3028L-v36.fw.
> 
> In my case, my stick uses firmwares of type D2633 from file
> xc3028-v27.fw; I cannot test anything else. It is also possible that the
> VHF part of the DTV78 firmware of type D2633 in file xc3028-v27.fw is
> simply broken. As far as I know, this firmware is older than than the
> first DTT mux in VHF band here in Italy, so maybe it was optimized for
> analog reception and has never been tested with digital modulations.
> 
> What about a module parameter "alternative-VHF-firmware" which can be
> either on/off (default=off)?
> 
> By default, we keep current behavior; when enabled, DTV7 firmware is
> always loaded for VHF channels, for all firmware types and files.
> 
> Best regards,
> Gianluca
> 
> 

Thinking about it, maybe a shorter name like "vhf-fw" =
default(0)/alternative(1) would be better.

Best,
Gianluca
