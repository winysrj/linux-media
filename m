Return-path: <linux-media-owner@vger.kernel.org>
Received: from racoon.tvdr.de ([188.40.50.18]:40053 "EHLO racoon.tvdr.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752694Ab0DRSeb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Apr 2010 14:34:31 -0400
Received: from whale.cadsoft.de (whale.tvdr.de [192.168.100.6])
	by racoon.tvdr.de (8.14.3/8.14.3) with ESMTP id o3IIYTMo024186
	for <linux-media@vger.kernel.org>; Sun, 18 Apr 2010 20:34:29 +0200
Received: from [192.168.100.10] (hawk.cadsoft.de [192.168.100.10])
	by whale.cadsoft.de (8.14.3/8.14.3) with ESMTP id o3IIYNxK024068
	for <linux-media@vger.kernel.org>; Sun, 18 Apr 2010 20:34:23 +0200
Message-ID: <4BCB50AF.9030008@tvdr.de>
Date: Sun, 18 Apr 2010 20:34:23 +0200
From: Klaus Schmidinger <Klaus.Schmidinger@tvdr.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [linux-media] Re: [linux-media] Re: [PATCH] Add FE_CAN_PSK_8
 to allow apps to 	identify PSK_8 capable DVB devices
References: <4BC19294.4010200@tvdr.de>	 <s2n1a297b361004151321rb51b5225q79842aac2964371b@mail.gmail.com>	 <4BCB06E7.8050806@tvdr.de> <x2l1a297b361004180751y1e8c89f2pafbd257d8107e50c@mail.gmail.com>
In-Reply-To: <x2l1a297b361004180751y1e8c89f2pafbd257d8107e50c@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 18.04.2010 16:51, Manu Abraham wrote:
> On Sun, Apr 18, 2010 at 5:19 PM, Klaus Schmidinger
> <Klaus.Schmidinger@tvdr.de> wrote:
>> On 15.04.2010 22:21, Manu Abraham wrote:
>>> Hi Klaus,
>>>
>>> On Sun, Apr 11, 2010 at 1:12 PM, Klaus Schmidinger
>>> <Klaus.Schmidinger@tvdr.de> wrote:
>>>> The enum fe_caps provides flags that allow an application to detect
>>>> whether a device is capable of handling various modulation types etc.
>>>> A flag for detecting PSK_8, however, is missing.
>>>> This patch adds the flag FE_CAN_PSK_8 to frontend.h and implements
>>>> it for the gp8psk-fe.c and cx24116.c driver (apparently the only ones
>>>> with PSK_8). Only the gp8psk-fe.c has been explicitly tested, though.
>>>
>>> The FE_CAN_PSK_8 is a misnomer. In fact what you are looking for is
>>> FE_CAN_TURBO_FEC
>> Well, when processing the NIT data in VDR, for instance, the possible
>> modulation types that can be used according to the driver's frontend.h
>> are
>>        QPSK,
>>        QAM_16,
>>        QAM_32,
>>        QAM_64,
>>        QAM_128,
>>        QAM_256,
>>        QAM_AUTO,
>>        VSB_8,
>>        VSB_16,
>>        PSK_8,
>>        APSK_16,
>>        APSK_32,
>>        DQPSK,
>>
>> There is nothing in frontend.h that would be in any way related to
>> "turbo fec" (whatever that may be).
>>
>> Of course we can rename FE_CAN_PSK_8 to FE_CAN_TURBO_FEC, but wouldn't
>> something like
>>
>>  if (Modulation == PSK_8 && !(frontendInfo.caps & FE_CAN_TURBO_FEC))
>>    return false;
>>
>> be even more irritating than a straight forward
>>
>>  if (Modulation == PSK_8 && !(frontendInfo.caps & FE_CAN_PSK_8))
>>    return false;
>>
>> After all it's
>>
>>  if (Modulation == QAM_256 && !(frontendInfo.caps & FE_CAN_QAM_256))
>>    return false;
>>
>> Please advise. Whatever you prefer is fine with me.
>> All I need in VDR is a flag that allows me to detect whether a device
>> can handle a given transponder's modulation. I don't really care how
>> that flag is named ;-).
> 
> 
> Maybe I wasn't clear enough, why I stated that ...
> 
> consider any DVB-S2 frontend: stb0899, cx24116, stv090x, ds3000 or any
> other any frontend ..
> All these devices are capable of demodulating 8PSK. Now, if people
> start adding capabilities that which the devices are capable, then it
> will cause a lot of problems for the applications themselves, since
> you don't get the differentiation between the frontends that you were
> originally looking for.
> 
> Now looking at another angle ..
> 
> consider the Genpix frontend, can it tune to 8PSK ? Yes, it can..
> 
> Eventually, it implies that, all DVB-S2 devices are 8PSK capable, but
> not all 8PSK capable devices are DVB-S2 capable.

Since there are already FE_CAN_* flags for all but PSK_8, I guess
it would make sense that all devices that support PSK_8 set the
related FE_CAN_PSK_8 flag (or FE_CAN_8PSK, if you insist in continuing the
suboptimal naming scheme), independent of the "Turbo FEC" thing.

> Now, assume the FE_CAN_PSK8 or FE_CAN8PSK flag; Does it really make
> any sense, when it is applied to the whole group of 8PSK frontends ? I
> guess not. You would require a flag that is capable of distinguishing
> between the S2 8PSK category and the other category.

There already is such a flag: FE_CAN_2G_MODULATION.

> Looking back at history, originally France Telecom introduced the
> superior Error Correction scheme called Turbo Mode or so called
> Concatenated FEC mode on a 8PSK modulated carrier. This was a great
> approach, but they wanted to people to pay them a royalty and hence
> the general acceptance for it went down. In the initial phase, it was
> implemented in the Americas and for small clients alone. Eventually,
> the rest of the world wanted a royalty free approach and thus came
> LDPC which is just as good.
> 
> So eventually while the difference between these 2 carriers is that
> while both are 8PSK modulated stream, the Error correction used with
> France Telecom's proprietary stream is Concatenated Codes, while for
> S2 and DVB.org it became LDPC.
> 
> As you can see, the discriminating factor is the FEC, in this
> condition and nothing else. You will need a flag to discriminate
> between the FEC types, rather than the modulation, if things were to
> look more logical.

I guess the problem, as I can see now, is that there is now way
of telling from the SI data that a transponder uses "8psk turbo fec",
or is there?

Would it make sense to differentiate this in the following way:

- an 8psk transponder on DVB-S is "turbo fec"
- an 8psk transponder on DVB-S2 is  *not* "turbo fec"

? So an "8psk/DVB-S" transpoder will require a device that has
FE_CAN_TURBO_FEC set, while an "8psk/DVB-S2" transpoder simply
requires a DVB-S2 device (since there is no FE_CAN_PSK_8).

Klaus
