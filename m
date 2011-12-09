Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28710 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758Ab1LIKAt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 9 Dec 2011 05:00:49 -0500
Message-ID: <4EE1DC4A.8000200@redhat.com>
Date: Fri, 09 Dec 2011 08:00:42 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Eddi De Pieri <eddi@depieri.net>
CC: Fredrik Lingvall <fredrik.lingvall@gmail.com>,
	linux-media@vger.kernel.org,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Steven Toth <stoth@kernellabs.com>,
	Michael Krufky <mkrufky@kernellabs.com>
Subject: Re: HVR-930C DVB-T mode report
References: <CAKdnbx5JaCp71kqxH6sO4r35rb28UjOHmL7eD4e7bHtbYFgn5g@mail.gmail.com> <4EE08D88.2070806@redhat.com> <4EE0C312.90401@gmail.com> <4EE0D264.4090306@redhat.com> <4EE114E6.9040307@redhat.com> <CAKdnbx7mQL+D7Qas38gYR-E3nCoRVGgW-kk_cAE-kV=DYkhEYg@mail.gmail.com>
In-Reply-To: <CAKdnbx7mQL+D7Qas38gYR-E3nCoRVGgW-kk_cAE-kV=DYkhEYg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08-12-2011 22:45, Eddi De Pieri wrote:
> Hi Mauro...
>
> I applied your patch... the patch seems good using scan, but still
> some issue with w_scan:
>
>>>> tune to: 177500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
> 0x0000 0x0d49: pmt_pid 0x0102 RAI -- Rai 1 (running)
> 0x0000 0x0d4a: pmt_pid 0x0101 RAI -- Rai 2 (running)
> 0x0000 0x0d4b: pmt_pid 0x0100 RAI -- Rai 3 TGR Veneto (running)
> 0x0000 0x0d53: pmt_pid 0x0118 RAI -- Rai News (running)
> 0x0000 0x0d54: pmt_pid 0x0119 Rai -- Rai 3 TGR Emilia Romagna (running)
> 0x0000 0x0d4c: pmt_pid 0x0103 Rai -- Rai Radio1 (running)
> 0x0000 0x0d4d: pmt_pid 0x0104 Rai -- Rai Radio2 (running)
> 0x0000 0x0d4e: pmt_pid 0x0105 Rai -- Rai Radio3 (running)
> Network Name 'Rai'
>>>> tune to: 212500000:INVERSION_AUTO:BANDWIDTH_7_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
> 0x0000 0x0001: pmt_pid 0x0023 TV7 -- TV7 MOVIE (running)
> 0x0000 0x0002: pmt_pid 0x002f TV7 -- TV7 DOC (running)
> 0x0000 0x0003: pmt_pid 0x002d TV7 -- TV7 SANITA (running)
> 0x0000 0x0004: pmt_pid 0x0026 TV7 -- TV7 ITALIA (running)
> 0x0000 0x0005: pmt_pid 0x0032 TV7 -- TV7 ATENEO (running)
> 0x0000 0x0006: pmt_pid 0x0022 TV7 -- TV7 SPORT (running)
> 0x0000 0x000b: pmt_pid 0x002b TV7 -- TV7 AZZURRA (running)
> Network Name 'Triveneta TV'

Good! I'll merge it upstream then.

>
> using w_scan still persist issues.

Will comment about it on your  next email.
>
> Here is the results:
>
> root@depieri1lnx:~# w_scan -f t  -c IT
> w_scan version 20110616 (compiled for DVB API 5.3)
> using settings for ITALY
> DVB aerial
> DVB-T Europe
> frontend_type DVB-T, channellist 4
> output format vdr-1.6
> output charset 'UTF-8', use -C<charset>  to override
> Info: using DVB adapter auto detection.
> 	/dev/dvb/adapter0/frontend0 ->  DVB-C "DRXK DVB-C": specified was
> DVB-T ->  SEARCH NEXT ONE.
> 	/dev/dvb/adapter0/frontend1 ->  DVB-T "DRXK DVB-T": good :-)
> Using DVB-T frontend (adapter /dev/dvb/adapter0/frontend1)
> -_-_-_-_ Getting frontend capabilities-_-_-_-_
> Using DVB API 5.4
> frontend 'DRXK DVB-T' supports
> INVERSION_AUTO
> QAM_AUTO
> TRANSMISSION_MODE_AUTO
> GUARD_INTERVAL_AUTO
> HIERARCHY_AUTO
> FEC_AUTO
> FREQ (47.12MHz ... 865.00MHz)
> -_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
> Scanning 7MHz frequencies...
> 177500: (time: 00:00)
> 184500: (time: 00:03)
> 191500: (time: 00:06)
> 198500: (time: 00:09)
> 205500: (time: 00:12)
> 212500: (time: 00:15)
> 219500: (time: 00:17)
> 226500: (time: 00:20)
> Scanning 8MHz frequencies...
> 474000: (time: 00:23)
> [...]
> 850000: (time: 02:38)
> 858000: (time: 02:40)
>
>
> ERROR: Sorry - i couldn't get any working frequency/transponder
>   Nothing to scan!!
>
>
> dmesg says:
> [  794.964818] drxk: Error -22 on QAMSetSymbolrate
> [  794.964827] drxk: Error -22 on SetQAM
> [  794.964832] drxk: Error -22 on Start
> [  795.164518] drxk: Error -22 on QAMSetSymbolrate
> [  795.164528] drxk: Error -22 on SetQAM
> [  795.164534] drxk: Error -22 on Start

