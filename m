Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62249 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859Ab1LIKqu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 9 Dec 2011 05:46:50 -0500
Message-ID: <4EE1E714.5060908@redhat.com>
Date: Fri, 09 Dec 2011 08:46:44 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Eddi De Pieri <eddi@depieri.net>
CC: Fredrik Lingvall <fredrik.lingvall@gmail.com>,
	linux-media@vger.kernel.org,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Steven Toth <stoth@kernellabs.com>,
	Michael Krufky <mkrufky@kernellabs.com>
Subject: Re: HVR-930C DVB-T mode report
References: <CAKdnbx5JaCp71kqxH6sO4r35rb28UjOHmL7eD4e7bHtbYFgn5g@mail.gmail.com> <4EE08D88.2070806@redhat.com> <4EE0C312.90401@gmail.com> <4EE0D264.4090306@redhat.com> <4EE114E6.9040307@redhat.com> <CAKdnbx7mQL+D7Qas38gYR-E3nCoRVGgW-kk_cAE-kV=DYkhEYg@mail.gmail.com> <CAKdnbx6-448+3=8ONrcd0pGhbJ1P4vKZPse-RYHGnhkpHfzW8w@mail.gmail.com>
In-Reply-To: <CAKdnbx6-448+3=8ONrcd0pGhbJ1P4vKZPse-RYHGnhkpHfzW8w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09-12-2011 07:35, Eddi De Pieri wrote:
> Hi Mauro,
>
> drxk driver seems to have 2 issue with w_scan:
>
> - dvb-t tune error while scanning ("solved" by forcing w_scan to open
> dvb-t fe without autoscan)
> - dvb-t scan fail
>
> so... we should have an issue that when the driver release dvb-c
> adapter drxk (or xc5000?) stay in dvb-c mode
>
> Can you check if you can replicate my error and if Terratec H5 have same issue?
> follow the test:....
>
> I build w_scan 20111011 like you
>
> -unplug tuner
> -replug tuner
>
> dmesg says:
> [ 1030.370462] DVB: registering new adapter (em28xx #0)
> [ 1030.370470] DVB: registering adapter 0 frontend 0 (DRXK DVB-C)...
> [ 1030.370689] DVB: registering adapter 0 frontend 1 (DRXK DVB-T)...
> [ 1030.371393] em28xx #0: Successfully loaded em28xx-dvb
>
> - w_scan -a /dev/dvb/adapter0/frontend1  (the autodetect of adapter is disabled)
>
> dmesg says:
> [ 1117.000725] xc5000: waiting for firmware upload (dvb-fe-xc5000-1.6.114.fw)...
> [ 1117.005404] xc5000: firmware read 12401 bytes.
> [ 1117.005410] xc5000: firmware uploading...
> [ 1117.416085] xc5000: firmware upload complete...
>
> However, like Fedrik, I don't get errors on dmesg but w_scan ends with
>
>   ERROR: Sorry - i couldn't get any working frequency/transponder
>   Nothing to scan!!
>
> - w_scan -a /dev/dvb/adapter0/frontend1  -I it-All
> no error on dmesg...
>
>
> - w_scan -f t -c IT
> Leaving autodetect turned on I get
> [  794.964818] drxk: Error -22 on QAMSetSymbolrate
> [  794.964827] drxk: Error -22 on SetQAM
> [  794.964832] drxk: Error -22 on Start
> [  795.164518] drxk: Error -22 on QAMSetSymbolrate
> [  795.164528] drxk: Error -22 on SetQAM
> [  795.164534] drxk: Error -22 on Start

That's weird... SetQAM and QAMSetSymbolrate are only called for DVB-C.

 From DRX-K driver, the only way to get EINVAL on QAMSetSymbolrate is when
there would be a division by zero, e. g. symbol rate = 0 or frequency equal to 0.

Did a quick test here with HVR-930C, using strace:

open("/dev/dvb/adapter0/frontend0", O_RDWR|O_NONBLOCK) = 3
ioctl(3, FE_GET_INFO, 0x635120)         = 0
write(2, "\t/dev/dvb/adapter0/frontend0 -> "..., 92	/dev/dvb/adapter0/frontend0 -> DVB-C "DRXK DVB-C": specified was DVB-T -> SEARCH NEXT ONE.
) = 92
close(3)                                = 0
open("/dev/dvb/adapter0/frontend1", O_RDWR|O_NONBLOCK) = 3
ioctl(3, FE_GET_INFO, 0x635120)         = 0
write(2, "\t/dev/dvb/adapter0/frontend1 -> "..., 52	/dev/dvb/adapter0/frontend1 -> DVB-T "DRXK DVB-T": ) = 52
write(2, "good :-)\n", 9good :-)
)               = 9
close(3)                                = 0
...
open("/dev/dvb/adapter0/frontend1", O_RDWR) = 3
write(2, "-_-_-_-_ Getting frontend capabi"..., 48-_-_-_-_ Getting frontend capabilities-_-_-_-_
) = 48
ioctl(3, FE_GET_INFO, 0x635120)         = 0
ioctl(3, FE_GET_PROPERTY, 0x7fff81f5de70) = 0
...
ioctl(3, FE_SET_PROPERTY, 0x7fff81f5de60) = 0

So far so good, but then drxk tries to use DVB-C, instead of DVB-T:
[  717.260140] drxk: Error -22 on SetQAM
[  717.263858] drxk: Error -22 on Start

It seems that there's a bug at the dvb-t on the current version.

I'll try to fix it.

>
> trying scan now...
>   scan -f1 it-All
> dmesg days
> [ 2044.103987] drxk: Error -22 on Start
> [ 2045.293728] drxk: Error -22 on SetQAM
> [ 2045.293738] drxk: Error -22 on Start
> [ 2045.431231] drxk: Error -22 on QAMSetSymbolrate
> [ 2045.431241] drxk: Error -22 on SetQAM
> [ 2045.431246] drxk: Error -22 on Start
>
>
> regards,
>
> Eddi

