Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:45139 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756458Ab0DROwB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Apr 2010 10:52:01 -0400
Received: by fg-out-1718.google.com with SMTP id d23so1426000fga.1
        for <linux-media@vger.kernel.org>; Sun, 18 Apr 2010 07:51:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4BCB06E7.8050806@tvdr.de>
References: <4BC19294.4010200@tvdr.de>
	 <s2n1a297b361004151321rb51b5225q79842aac2964371b@mail.gmail.com>
	 <4BCB06E7.8050806@tvdr.de>
Date: Sun, 18 Apr 2010 18:51:53 +0400
Message-ID: <x2l1a297b361004180751y1e8c89f2pafbd257d8107e50c@mail.gmail.com>
Subject: Re: [linux-media] Re: [PATCH] Add FE_CAN_PSK_8 to allow apps to
	identify PSK_8 capable DVB devices
From: Manu Abraham <abraham.manu@gmail.com>
To: Klaus Schmidinger <Klaus.Schmidinger@tvdr.de>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Apr 18, 2010 at 5:19 PM, Klaus Schmidinger
<Klaus.Schmidinger@tvdr.de> wrote:
> On 15.04.2010 22:21, Manu Abraham wrote:
>> Hi Klaus,
>>
>> On Sun, Apr 11, 2010 at 1:12 PM, Klaus Schmidinger
>> <Klaus.Schmidinger@tvdr.de> wrote:
>>> The enum fe_caps provides flags that allow an application to detect
>>> whether a device is capable of handling various modulation types etc.
>>> A flag for detecting PSK_8, however, is missing.
>>> This patch adds the flag FE_CAN_PSK_8 to frontend.h and implements
>>> it for the gp8psk-fe.c and cx24116.c driver (apparently the only ones
>>> with PSK_8). Only the gp8psk-fe.c has been explicitly tested, though.
>>
>>
>> The FE_CAN_PSK_8 is a misnomer. In fact what you are looking for is
>> FE_CAN_TURBO_FEC
>
> Well, when processing the NIT data in VDR, for instance, the possible
> modulation types that can be used according to the driver's frontend.h
> are
>        QPSK,
>        QAM_16,
>        QAM_32,
>        QAM_64,
>        QAM_128,
>        QAM_256,
>        QAM_AUTO,
>        VSB_8,
>        VSB_16,
>        PSK_8,
>        APSK_16,
>        APSK_32,
>        DQPSK,
>
> There is nothing in frontend.h that would be in any way related to
> "turbo fec" (whatever that may be).
>
> Of course we can rename FE_CAN_PSK_8 to FE_CAN_TURBO_FEC, but wouldn't
> something like
>
>  if (Modulation == PSK_8 && !(frontendInfo.caps & FE_CAN_TURBO_FEC))
>    return false;
>
> be even more irritating than a straight forward
>
>  if (Modulation == PSK_8 && !(frontendInfo.caps & FE_CAN_PSK_8))
>    return false;
>
> After all it's
>
>  if (Modulation == QAM_256 && !(frontendInfo.caps & FE_CAN_QAM_256))
>    return false;
>
> Please advise. Whatever you prefer is fine with me.
> All I need in VDR is a flag that allows me to detect whether a device
> can handle a given transponder's modulation. I don't really care how
> that flag is named ;-).


Maybe I wasn't clear enough, why I stated that ...

consider any DVB-S2 frontend: stb0899, cx24116, stv090x, ds3000 or any
other any frontend ..
All these devices are capable of demodulating 8PSK. Now, if people
start adding capabilities that which the devices are capable, then it
will cause a lot of problems for the applications themselves, since
you don't get the differentiation between the frontends that you were
originally looking for.

Now looking at another angle ..

consider the Genpix frontend, can it tune to 8PSK ? Yes, it can..

Eventually, it implies that, all DVB-S2 devices are 8PSK capable, but
not all 8PSK capable devices are DVB-S2 capable.

Now, assume the FE_CAN_PSK8 or FE_CAN8PSK flag; Does it really make
any sense, when it is applied to the whole group of 8PSK frontends ? I
guess not. You would require a flag that is capable of distinguishing
between the S2 8PSK category and the other category.

Looking back at history, originally France Telecom introduced the
superior Error Correction scheme called Turbo Mode or so called
Concatenated FEC mode on a 8PSK modulated carrier. This was a great
approach, but they wanted to people to pay them a royalty and hence
the general acceptance for it went down. In the initial phase, it was
implemented in the Americas and for small clients alone. Eventually,
the rest of the world wanted a royalty free approach and thus came
LDPC which is just as good.

So eventually while the difference between these 2 carriers is that
while both are 8PSK modulated stream, the Error correction used with
France Telecom's proprietary stream is Concatenated Codes, while for
S2 and DVB.org it became LDPC.

As you can see, the discriminating factor is the FEC, in this
condition and nothing else. You will need a flag to discriminate
between the FEC types, rather than the modulation, if things were to
look more logical.

Regards,
Manu
