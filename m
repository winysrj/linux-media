Return-path: <linux-media-owner@vger.kernel.org>
Received: from racoon.tvdr.de ([188.40.50.18]:43266 "EHLO racoon.tvdr.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752144Ab0DRNTo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Apr 2010 09:19:44 -0400
Received: from whale.cadsoft.de (whale.tvdr.de [192.168.100.6])
	by racoon.tvdr.de (8.14.3/8.14.3) with ESMTP id o3IDJfF2020059
	for <linux-media@vger.kernel.org>; Sun, 18 Apr 2010 15:19:41 +0200
Message-ID: <4BCB06E7.8050806@tvdr.de>
Date: Sun, 18 Apr 2010 15:19:35 +0200
From: Klaus Schmidinger <Klaus.Schmidinger@tvdr.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [linux-media] Re: [PATCH] Add FE_CAN_PSK_8 to allow apps to identify
 PSK_8 capable 	DVB devices
References: <4BC19294.4010200@tvdr.de> <s2n1a297b361004151321rb51b5225q79842aac2964371b@mail.gmail.com>
In-Reply-To: <s2n1a297b361004151321rb51b5225q79842aac2964371b@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 15.04.2010 22:21, Manu Abraham wrote:
> Hi Klaus,
> 
> On Sun, Apr 11, 2010 at 1:12 PM, Klaus Schmidinger
> <Klaus.Schmidinger@tvdr.de> wrote:
>> The enum fe_caps provides flags that allow an application to detect
>> whether a device is capable of handling various modulation types etc.
>> A flag for detecting PSK_8, however, is missing.
>> This patch adds the flag FE_CAN_PSK_8 to frontend.h and implements
>> it for the gp8psk-fe.c and cx24116.c driver (apparently the only ones
>> with PSK_8). Only the gp8psk-fe.c has been explicitly tested, though.
> 
> 
> The FE_CAN_PSK_8 is a misnomer. In fact what you are looking for is
> FE_CAN_TURBO_FEC

Well, when processing the NIT data in VDR, for instance, the possible
modulation types that can be used according to the driver's frontend.h
are
        QPSK,
        QAM_16,
        QAM_32,
        QAM_64,
        QAM_128,
        QAM_256,
        QAM_AUTO,
        VSB_8,
        VSB_16,
        PSK_8,
        APSK_16,
        APSK_32,
        DQPSK,

There is nothing in frontend.h that would be in any way related to
"turbo fec" (whatever that may be).

Of course we can rename FE_CAN_PSK_8 to FE_CAN_TURBO_FEC, but wouldn't
something like

 if (Modulation == PSK_8 && !(frontendInfo.caps & FE_CAN_TURBO_FEC))
    return false;

be even more irritating than a straight forward

 if (Modulation == PSK_8 && !(frontendInfo.caps & FE_CAN_PSK_8))
    return false;

After all it's

 if (Modulation == QAM_256 && !(frontendInfo.caps & FE_CAN_QAM_256))
    return false;

Please advise. Whatever you prefer is fine with me.
All I need in VDR is a flag that allows me to detect whether a device
can handle a given transponder's modulation. I don't really care how
that flag is named ;-).

> FE_CAN_8PSK will be matched by any DVB-S2 capable frontend, so that
> name is very likely to cause a very large confusion.

I chose FE_CAN_PSK_8 over FE_CAN_8PSK, because the modulation itself
is named PSK_8. This allows for easily finding all PSK_8 related places
with 'grep'. Personally I find the FE_CAN_8VSB and FE_CAN_16VSB misnomers,
because the modulations are named VSB_8 and VSB_16, respectively. They
should have been named FE_CAN_VSB_8 and FE_CAN_VSB_16 in the first place.
But that's, of course, a different story...

Klaus Schmidinger

> Another thing I am not entirely sure though ... The cx24116 requires a
> separate firmware and maybe some necessary code changes (?) for Turbo
> FEC to be supported, so I wonder whether applying the flag to the
> cx24116 driver would be any relevant....
> 
> With regards to the Genpix driver, i guess the flag would be necessary.
> 
>> Signed-off-by: Klaus Schmidinger <Klaus.Schmidinger@tvdr.de>
>> Tested-by: Derek Kelly <user.vdr@gmail.com>
> 
> Other than for the naming of the Flag (which i suggest strongly to
> update the patch) and the application to the cx24116 driver, it looks
> appropriate;
> 
> Acked-by: Manu Abraham <manu@linuxtv.org>
> 
> 
> 
> 
>>
>> --- linux/include/linux/dvb/frontend.h.001      2010-04-05 16:13:08.000000000 +0200
>> +++ linux/include/linux/dvb/frontend.h  2010-04-10 12:08:47.000000000 +0200
>> @@ -62,6 +62,7 @@
>>        FE_CAN_8VSB                     = 0x200000,
>>        FE_CAN_16VSB                    = 0x400000,
>>        FE_HAS_EXTENDED_CAPS            = 0x800000,   /* We need more bitspace for newer APIs, indicate this. */
>> +       FE_CAN_PSK_8                    = 0x8000000,  /* frontend supports "8psk modulation" */
>>        FE_CAN_2G_MODULATION            = 0x10000000, /* frontend supports "2nd generation modulation" (DVB-S2) */
>>        FE_NEEDS_BENDING                = 0x20000000, /* not supported anymore, don't use (frontend requires frequency bending) */
>>        FE_CAN_RECOVER                  = 0x40000000, /* frontend can recover from a cable unplug automatically */
>> --- linux/drivers/media/dvb/dvb-usb/gp8psk-fe.c.001     2010-04-05 16:13:08.000000000 +0200
>> +++ linux/drivers/media/dvb/dvb-usb/gp8psk-fe.c 2010-04-10 12:18:37.000000000 +0200
>> @@ -349,7 +349,7 @@
>>                         * FE_CAN_QAM_16 is for compatibility
>>                         * (Myth incorrectly detects Turbo-QPSK as plain QAM-16)
>>                         */
>> -                       FE_CAN_QPSK | FE_CAN_QAM_16
>> +                       FE_CAN_QPSK | FE_CAN_QAM_16 | FE_CAN_PSK_8
>>        },
>>
>>        .release = gp8psk_fe_release,
>> --- linux/drivers/media/dvb/frontends/cx24116.c.001     2010-04-05 16:13:08.000000000 +0200
>> +++ linux/drivers/media/dvb/frontends/cx24116.c 2010-04-10 13:40:32.000000000 +0200
>> @@ -1496,7 +1496,7 @@
>>                        FE_CAN_FEC_4_5 | FE_CAN_FEC_5_6 | FE_CAN_FEC_6_7 |
>>                        FE_CAN_FEC_7_8 | FE_CAN_FEC_AUTO |
>>                        FE_CAN_2G_MODULATION |
>> -                       FE_CAN_QPSK | FE_CAN_RECOVER
>> +                       FE_CAN_QPSK | FE_CAN_RECOVER | FE_CAN_PSK_8
>>        },
>>
>>        .release = cx24116_release,
