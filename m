Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f20.google.com ([209.85.219.20]:48385 "EHLO
	mail-ew0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750AbZAVWNE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Jan 2009 17:13:04 -0500
Received: by ewy13 with SMTP id 13so3117532ewy.13
        for <linux-media@vger.kernel.org>; Thu, 22 Jan 2009 14:13:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0901221706250.8336@tupari.net>
References: <48F78D8A020000560001A654@GWISE1.matc.edu>
	 <alpine.LFD.2.00.0901221434040.7609@tupari.net>
	 <412bdbff0901221149x100cf8abwd07d2c5821e286b2@mail.gmail.com>
	 <alpine.LFD.2.00.0901221542190.7960@tupari.net>
	 <412bdbff0901221328u6338ecd9q9ecc2ecab19051e5@mail.gmail.com>
	 <alpine.LFD.2.00.0901221635550.8219@tupari.net>
	 <412bdbff0901221343s7fc16ecdl3bed34c8e50ee3da@mail.gmail.com>
	 <alpine.LFD.2.00.0901221706250.8336@tupari.net>
Date: Thu, 22 Jan 2009 14:13:02 -0800
Message-ID: <cae4ceb0901221413y55072ee7r570f9f7000dc7ddd@mail.gmail.com>
Subject: Re: [linux-dvb] Fusion HDTV 7 Dual Express
From: Tu-Tu Yu <tutuyu@usc.edu>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <devin.heitmueller@gmail.com>,
	linux-dvb@linuxtv.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Then that means you're getting good signal== 012c (Hex) equal to
300(Dec) then that means your snr value is 300/10 = 30 dB

On Thu, Jan 22, 2009 at 2:07 PM, Joseph Shraibman
<linuxtv.org@jks.tupari.net> wrote:
> Ignore my previous email.  The card wasn't tuned to anything.  I tuned to
> a known good station and get this:
>
> FE: Samsung S5H1411 QAM/8VSB Frontend (ATSC)
> status SCVYL | signal 012c | snr 012c | ber 00000000 | unc 00000000 |
> FE_HAS_LOCK
> status SCVYL | signal 0127 | snr 0127 | ber 00000000 | unc 00000000 |
> FE_HAS_LOCK
> status SCVYL | signal 012c | snr 012c | ber 00000000 | unc 00000000 |
> FE_HAS_LOCK
> status SCVYL | signal 012c | snr 012c | ber 00000000 | unc 00000000 |
> FE_HAS_LOCK
> status SCVYL | signal 012c | snr 012c | ber 00000000 | unc 00000000 |
> FE_HAS_LOCK
> status SCVYL | signal 012c | snr 012c | ber 00000000 | unc 00000000 |
> FE_HAS_LOCK
> status SCVYL | signal 012c | snr 012c | ber 00000000 | unc 00000000 |
> FE_HAS_LOCK
> status SCVYL | signal 0127 | snr 0127 | ber 00000000 | unc 00000000 |
> FE_HAS_LOCK
> status SCVYL | signal 0127 | snr 0127 | ber 00000000 | unc 00000000 |
> FE_HAS_LOCK
> status SCVYL | signal 0127 | snr 0127 | ber 00000000 | unc 00000000 |
> FE_HAS_LOCK
> status SCVYL | signal 012c | snr 012c | ber 00000000 | unc 00000000 |
> FE_HAS_LOCK
> status SCVYL | signal 012c | snr 012c | ber 00000000 | unc 00000000 |
> FE_HAS_LOCK
> status SCVYL | signal 012c | snr 012c | ber 00000000 | unc 00000000 |
> FE_HAS_LOCK
> status SCVYL | signal 012c | snr 012c | ber 00000000 | unc 00000000 |
> FE_HAS_LOCK
> status SCVYL | signal 0127 | snr 0127 | ber 00000000 | unc 00000000 |
> FE_HAS_LOCK
> status SCVYL | signal 0127 | snr 0127 | ber 00000000 | unc 00000000 |
> FE_HAS_LOCK
> status SCVYL | signal 012c | snr 012c | ber 00000000 | unc 00000000 |
> FE_HAS_LOCK
> status SCVYL | signal 012c | snr 012c | ber 00000000 | unc 00000000 |
> FE_HAS_LOCK
> status SCVYL | signal 012c | snr 012c | ber 00000000 | unc 00000000 |
> FE_HAS_LOCK
> status SCVYL | signal 012c | snr 012c | ber 00000000 | unc 00000000 |
> FE_HAS_LOCK
>
>
> On Thu, 22 Jan 2009, Devin Heitmueller wrote:
>
>> On Thu, Jan 22, 2009 at 4:37 PM, Joseph Shraibman
>> <linuxtv.org@jks.tupari.net> wrote:
>>>> On some demods, the strength and SNR indicators are only valid if you
>>>> have a lock.
>>>
>>> But why don't I get a lock?  I was getting signals with my pcHDTV3000 so I
>>> know it isn't an antenna problem.
>>
>> I just looked back at your dmesg output, and I am somewhat confused.
>> Do you have multiple cards installed in the host at the same time?
>> Isn't the Oren OR51132 the other card?  I would assume that you would
>> need to be looking at the output of the s5h1411 frontend with femon if
>> you're trying to capture on the Fusion HDTV 7 Dual Express.  Or
>> perhaps I am just missing something here.
>>
>> Devin
>>
>> --
>> Devin J. Heitmueller
>> http://www.devinheitmueller.com
>> AIM: devinheitmueller
>>
>
> _______________________________________________
> linux-dvb users mailing list
> For V4L/DVB development, please use instead linux-media@vger.kernel.org
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>
