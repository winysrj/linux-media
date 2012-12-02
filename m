Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38200 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342Ab2LBRjF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Dec 2012 12:39:05 -0500
Received: by mail-bk0-f46.google.com with SMTP id q16so745162bkw.19
        for <linux-media@vger.kernel.org>; Sun, 02 Dec 2012 09:39:03 -0800 (PST)
Message-ID: <50BB923F.7090705@googlemail.com>
Date: Sun, 02 Dec 2012 18:39:11 +0100
From: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: mkrufky@linuxtv.org, linux-media@vger.kernel.org
Subject: Re: LGDT3305 configuration questions
References: <50BB413C.9010606@googlemail.com> <CAGoCfixam4zMuFStJfaEMi6EZAE455CpKcZyXtZFtL0O6JxU_A@mail.gmail.com>
In-Reply-To: <CAGoCfixam4zMuFStJfaEMi6EZAE455CpKcZyXtZFtL0O6JxU_A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Devin,

Am 02.12.2012 17:10, schrieb Devin Heitmueller:
> Hi Frank,
>
> I might be able to help out here a bit.
>
> On Sun, Dec 2, 2012 at 6:53 AM, Frank Schäfer
> <fschaefer.oss@googlemail.com> wrote:
>> 1) When should deny_i2c_rptr in struct lgdt3305_config be set ?
>> I can see what the code does, but I'm unsure which value to use.
>> What's the i2c repeater / i2c gate ctrl and how does it work ?
> Basically an i2c gate is a construct where i2c traffic from the bridge
> to the tuner goes *through* the demodulator, and the demodulator has
> the ability to open/close the gate to block traffic.

 Yeah, thats what the name suggests. But I didn't understand the
purpose/benefit...

> This is very
> typical in tuners since in many cases servicing i2c traffic can
> reducing tuning quality (hence you want it to only receive traffic if
> it's actually intended for the tuner).

... and that explains it. Thanks !

>   It's sometimes referred to as
> an I2C repeater, but it's the same thing.
>
> I discuss some more of the details here:
>
> How Tuners Work
> http://www.kernellabs.com/blog/?p=1045

Thank you for the link, I will definitely read it !

>
>> 2) User defined IF frequencies (fields vsb_if_khz and qam_if_khz in
>> struct lgdt3305_config):
>> What happens if no user defined values are selected ? The corresponding
>> registers seem to be 0x00000000 in this case (for the LGDT3305).
> You won't get a signal lock.  This value must be set, and it must
> match the value configured in the tuner.

Yes, that's what Antti explained, too.
The tda18271 driver also lets me understand things better...

>> Which IF is used in this case ?
>> The USB log of the stick shows that the registers are set to 4a 3d 70 a3
>> (for QAM; don't have a log for VSB).
>> According to the code in lgdt3305_set_if() this corresponds to a value
>> of .qam_if_khz = 4000.
>> In the em28xx driver we have another device with the LGDT3304 which sets
>> this value to 4000, too.
>> OTOH, these fields claim to hold the value in kHz, so this would be 4MHz
>> only. But AFAIK intermediate frequencies are usually about 10 times
>> higher !? ATSC seems to use 44MHz.
> 4000 MHz is a very common intermediate frequency for Both QAM and
> ATSC.  The value is user definable but in reality the value chosen
> will directly impact the quality of tuning reception (the manufacturer
> typically determines the ideal IF by putting a spectrum analyzer on
> the output and evaluating performance at different IF levels).  Hence
> if you got 4000 from the em28xx trace, that is probably the correct
> value (make sure the same value is specified in both the demodulator
> and tuner configuration blocks - in this case the tda18271_cfg block
> passed at dvb_attach).
>
> It's also not impossible (although uncommon) to have different IF
> settings for ATSC versus ClearQAM, so you should indeed get a second
> trace to see if it's 4MHz in both cases.

Ok, so it seems the 44000 KHz for ATSC I've read were wrong and 4000KHz
is right.

The LGDT3305 driver handles only 1 IF setting for QAM, but looking into
the tda18271 driver it seems that different intermediate frequencies for
QAM are possible.
Looks like this is configured with the tda18271_std_map entry in
tda18271_config...
I have to stop for today now, will continue tomorrow evening.

Thanks for your explanations !

Regards,
Frank



>
> Cheers,
>
> Devin
>

