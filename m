Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:38043 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230AbbGSHfA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Jul 2015 03:35:00 -0400
Received: by wibxm9 with SMTP id xm9so1383212wib.1
        for <linux-media@vger.kernel.org>; Sun, 19 Jul 2015 00:34:58 -0700 (PDT)
Message-ID: <55AB5320.8030100@gmail.com>
Date: Sun, 19 Jul 2015 09:34:56 +0200
From: =?UTF-8?B?VHljaG8gTMO8cnNlbg==?= <tycholursen@gmail.com>
MIME-Version: 1.0
To: Steven Toth <stoth@kernellabs.com>, tonyc@wincomm.com.tw,
	Antti Palosaari <crope@iki.fi>
CC: Linux-Media <linux-media@vger.kernel.org>
Subject: Re: Adding support for three new Hauppauge HVR-1275 variants - testers
 reqd.
References: <CALzAhNXQe7AtkwymcUeakVouMBmw7pG79-TeEjBMiK5ysXze_g@mail.gmail.com>
In-Reply-To: <CALzAhNXQe7AtkwymcUeakVouMBmw7pG79-TeEjBMiK5ysXze_g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steven,

Tested your si2186 patch with my DVBSky T982 and TBS 6285 cards using 
European DVB-C
Since MythTV can't handle multistandard frontends (yet), I've disabled 
DVB-T/T2 like this (I always do that):

sed -i 's/SYS_DVBT, SYS_DVBT2, SYS_DVBC_ANNEX_A/SYS_DVBC_ANNEX_A/' 
drivers/media/dvb-frontends/si2168.c

Result: both DVBSky T982 and TBS 6285 drivers are broken, meaning no 
lock, no tune.

Regards,
Tycho.

Op 19-07-15 om 00:21 schreef Steven Toth:
> http://git.linuxtv.org/cgit.cgi/stoth/hvr1275.git/log/?h=hvr-1275
>
> Patches above are available for test.
>
> Antti, note the change to SI2168 to add support for enabling and
> disabling the SI2168 transport bus dynamically.
>
> I've tested with a combo card, switching back and forward between QAM
> and DVB-T, this works fine, just remember to select a different
> frontend as we have two frontends on the same adapter,
> adapter0/frontend0 is QAM/8SVB, adapter0/frontend1 is DVB-T/T2.
>
> If any testers have the ATSC or DVB-T, I'd expect these to work
> equally well, replease report feedback here.
>
> Thanks,
>
> - Steve
>

