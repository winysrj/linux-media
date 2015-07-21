Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:33518 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933056AbbGUQLd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Jul 2015 12:11:33 -0400
Received: by wicmv11 with SMTP id mv11so46040851wic.0
        for <linux-media@vger.kernel.org>; Tue, 21 Jul 2015 09:11:32 -0700 (PDT)
Message-ID: <55AE6F31.3050308@gmail.com>
Date: Tue, 21 Jul 2015 18:11:29 +0200
From: =?UTF-8?B?VHljaG8gTMO8cnNlbg==?= <tycholursen@gmail.com>
MIME-Version: 1.0
To: Steven Toth <stoth@kernellabs.com>
CC: tonyc@wincomm.com.tw, Antti Palosaari <crope@iki.fi>,
	Linux-Media <linux-media@vger.kernel.org>
Subject: Re: Adding support for three new Hauppauge HVR-1275 variants - testers
 reqd.
References: <CALzAhNXQe7AtkwymcUeakVouMBmw7pG79-TeEjBMiK5ysXze_g@mail.gmail.com>	<55AB5320.8030100@gmail.com>	<CALzAhNX1Hs7vx9mF_nW08LcbW3Aa2UY0sNEDOi117NfhpCLK-A@mail.gmail.com>	<55AD1C77.6030208@gmail.com> <CALzAhNVmmAy=4r0Vd=T82HPUrOzxK9Rg2-M=DQ8gUa-DXKsS6w@mail.gmail.com>
In-Reply-To: <CALzAhNVmmAy=4r0Vd=T82HPUrOzxK9Rg2-M=DQ8gUa-DXKsS6w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steven,
I was too curious to wait for you and Antti to settle your differences, 
so I tested again against a 4.2-RC2
I did not disable DVB-T/T2, instead I reordered the lot. MythTV just 
sees the first system in the .delsys line in si2168.c,
so when it looks like this:
SYS_DVBC_ANNEX_A, SYS_DVBT, SYS_DVBT2
I'm good.

Result:
With your patch both MythTV and Tvheadend still can't tune. Without it, 
everything is ok.

I'm not very interested in czap results, only in real use cases. For me 
that's MythTV, but just to be sure I also tested with TVheadend.

Regards,
Tycho.

Op 20-07-15 om 18:32 schreef Steven Toth:
> On Mon, Jul 20, 2015 at 12:06 PM, Tycho Lürsen <tycholursen@gmail.com> wrote:
>> Hi Steven,
>> I was not aware of the fact that your patch depends on dvb-core as in
>> 4.2-RC2 (and up, I guess)
>> I tested against 3.18.18 and 4.1.2. That might explain the failures.
>> Anyhow, as soon as Antti and you are on the same page regarding this patch,
>> I'll test again against a 4.2-RC>1
>> Regards,
>> Tycho.
> Thank you Tycho.
>
> I specifically only tested on 4.2, with the entire tree. No attempt
> was made to backport or otherwise test in environments outside on
> prior kernels.
>
> - Steve
>

