Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:58374 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932984Ab1LFIiy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Dec 2011 03:38:54 -0500
Received: by lagp5 with SMTP id p5so1449442lag.19
        for <linux-media@vger.kernel.org>; Tue, 06 Dec 2011 00:38:52 -0800 (PST)
Message-ID: <4EDDD499.5060502@gmail.com>
Date: Tue, 06 Dec 2011 09:38:49 +0100
From: Fredrik Lingvall <fredrik.lingvall@gmail.com>
MIME-Version: 1.0
To: Eddi De Pieri <eddi@depieri.net>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org, mchehab@redhat.com
Subject: Re: Hauppauge HVR-930C problems
References: <4ED929E7.2050808@gmail.com> <CAGoCfizgkfHJ-0YwcdTEQEhci=7eE7BTuSOj8KmMpLRhc4oqGg@mail.gmail.com> <CAKdnbx5vewR3bLvFD4DeGiOSa8AqP0hupVF2jf1w9xrizXYz1g@mail.gmail.com>
In-Reply-To: <CAKdnbx5vewR3bLvFD4DeGiOSa8AqP0hupVF2jf1w9xrizXYz1g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/06/11 00:37, Eddi De Pieri wrote:
> try using scan from dvb-apps and not w_scan.
>
> Actually It seems to me w_scan isn't compatible with this driver due
> some missing lock.

I've tired dvbscan (=scan on Gentoo?). Apperently I need some initial 
scan file and I found one here:

  http://www.mail-archive.com/linuxtv-commits@linuxtv.org/msg02599.html

for the provider I have (I'm not really sure if it's correct though).

The scan file:

  # no-Oslo-Get (cable)
C 241000000 6900000 NONE QAM256
C 272000000 6900000 NONE QAM256
C 280000000 6900000 NONE QAM256
C 290000000 6900000 NONE QAM256
C 298000000 6900000 NONE QAM256
C 306000000 6900000 NONE QAM256
C 314000000 6900000 NONE QAM256
C 322000000 6900000 NONE QAM256
C 330000000 6900000 NONE QAM256
C 338000000 6900000 NONE QAM256
C 346000000 6900000 NONE QAM256
C 354000000 6900000 NONE QAM256
C 362000000 6900000 NONE QAM256
C 370000000 6900000 NONE QAM256
C 378000000 6900000 NONE QAM256
C 386000000 6900000 NONE QAM256
C 394000000 6900000 NONE QAM256
C 410000000 6900000 NONE QAM256
C 442000000 6952000 NONE QAM256
C 482000000 6900000 NONE QAM256
C 498000000 6900000 NONE QAM256

Scan results:

# dvbscan -a0 /usr/share/dvb/dvb-c/no-Oslo-Get
scanning /usr/share/dvb/dvb-c/no-Oslo-Get
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
initial transponder 241000000 6900000 0 5
initial transponder 272000000 6900000 0 5
initial transponder 280000000 6900000 0 5
initial transponder 290000000 6900000 0 5
initial transponder 298000000 6900000 0 5
initial transponder 306000000 6900000 0 5
initial transponder 314000000 6900000 0 5
initial transponder 322000000 6900000 0 5
initial transponder 330000000 6900000 0 5
initial transponder 338000000 6900000 0 5
initial transponder 346000000 6900000 0 5
initial transponder 354000000 6900000 0 5
initial transponder 362000000 6900000 0 5
initial transponder 370000000 6900000 0 5
initial transponder 378000000 6900000 0 5
initial transponder 386000000 6900000 0 5
initial transponder 394000000 6900000 0 5
initial transponder 410000000 6900000 0 5
initial transponder 442000000 6952000 0 5
initial transponder 482000000 6900000 0 5
initial transponder 498000000 6900000 0 5
 >>> tune to: 241000000:INVERSION_AUTO:6900000:FEC_NONE:QAM_256
WARNING: >>> tuning failed!!!
 >>> tune to: 241000000:INVERSION_AUTO:6900000:FEC_NONE:QAM_256 (tuning 
failed)
WARNING: >>> tuning failed!!!
 >>> tune to: 272000000:INVERSION_AUTO:6900000:FEC_NONE:QAM_256
WARNING: filter timeout pid 0x0011
WARNING: filter timeout pid 0x0000
WARNING: filter timeout pid 0x0010
 >>> tune to: 280000000:INVERSION_AUTO:6900000:FEC_NONE:QAM_256
WARNING: filter timeout pid 0x0011
WARNING: filter timeout pid 0x0000
WARNING: filter timeout pid 0x0010
 >>> tune to: 290000000:INVERSION_AUTO:6900000:FEC_NONE:QAM_256
WARNING: filter timeout pid 0x0011
WARNING: filter timeout pid 0x0000
WARNING: filter timeout pid 0x0010
 >>> tune to: 298000000:INVERSION_AUTO:6900000:FEC_NONE:QAM_256
WARNING: filter timeout pid 0x0011
WARNING: filter timeout pid 0x0000
WARNING: filter timeout pid 0x0010
 >>> tune to: 306000000:INVERSION_AUTO:6900000:FEC_NONE:QAM_256
WARNING: filter timeout pid 0x0011
WARNING: filter timeout pid 0x0000
WARNING: filter timeout pid 0x0010
 >>> tune to: 314000000:INVERSION_AUTO:6900000:FEC_NONE:QAM_256
WARNING: filter timeout pid 0x0011
WARNING: filter timeout pid 0x0000
WARNING: filter timeout pid 0x0010
 >>> tune to: 322000000:INVERSION_AUTO:6900000:FEC_NONE:QAM_256
WARNING: filter timeout pid 0x0011
WARNING: filter timeout pid 0x0000
WARNING: filter timeout pid 0x0010
 >>> tune to: 330000000:INVERSION_AUTO:6900000:FEC_NONE:QAM_256
WARNING: filter timeout pid 0x0011
WARNING: filter timeout pid 0x0000
WARNING: filter timeout pid 0x0010
 >>> tune to: 338000000:INVERSION_AUTO:6900000:FEC_NONE:QAM_256
WARNING: filter timeout pid 0x0011
WARNING: filter timeout pid 0x0000
WARNING: filter timeout pid 0x0010
 >>> tune to: 346000000:INVERSION_AUTO:6900000:FEC_NONE:QAM_256
WARNING: filter timeout pid 0x0011
WARNING: filter timeout pid 0x0000
WARNING: filter timeout pid 0x0010
 >>> tune to: 354000000:INVERSION_AUTO:6900000:FEC_NONE:QAM_256
WARNING: filter timeout pid 0x0011
WARNING: filter timeout pid 0x0000
WARNING: filter timeout pid 0x0010
 >>> tune to: 362000000:INVERSION_AUTO:6900000:FEC_NONE:QAM_256
WARNING: filter timeout pid 0x0011
WARNING: filter timeout pid 0x0000
WARNING: filter timeout pid 0x0010
 >>> tune to: 370000000:INVERSION_AUTO:6900000:FEC_NONE:QAM_256
WARNING: filter timeout pid 0x0011
WARNING: filter timeout pid 0x0000
WARNING: filter timeout pid 0x0010
 >>> tune to: 378000000:INVERSION_AUTO:6900000:FEC_NONE:QAM_256
WARNING: filter timeout pid 0x0011
WARNING: filter timeout pid 0x0000
WARNING: filter timeout pid 0x0010
 >>> tune to: 386000000:INVERSION_AUTO:6900000:FEC_NONE:QAM_256
WARNING: filter timeout pid 0x0011
WARNING: filter timeout pid 0x0000
WARNING: filter timeout pid 0x0010
 >>> tune to: 394000000:INVERSION_AUTO:6900000:FEC_NONE:QAM_256
WARNING: filter timeout pid 0x0011
WARNING: filter timeout pid 0x0000
WARNING: filter timeout pid 0x0010
 >>> tune to: 410000000:INVERSION_AUTO:6900000:FEC_NONE:QAM_256
WARNING: >>> tuning failed!!!
 >>> tune to: 410000000:INVERSION_AUTO:6900000:FEC_NONE:QAM_256 (tuning 
failed)
WARNING: >>> tuning failed!!!
 >>> tune to: 442000000:INVERSION_AUTO:6952000:FEC_NONE:QAM_256
WARNING: filter timeout pid 0x0011
WARNING: filter timeout pid 0x0000
WARNING: filter timeout pid 0x0010
 >>> tune to: 482000000:INVERSION_AUTO:6900000:FEC_NONE:QAM_256
WARNING: >>> tuning failed!!!
 >>> tune to: 482000000:INVERSION_AUTO:6900000:FEC_NONE:QAM_256 (tuning 
failed)
WARNING: >>> tuning failed!!!
 >>> tune to: 498000000:INVERSION_AUTO:6900000:FEC_NONE:QAM_256
WARNING: >>> tuning failed!!!
 >>> tune to: 498000000:INVERSION_AUTO:6900000:FEC_NONE:QAM_256 (tuning 
failed)
WARNING: >>> tuning failed!!!
dumping lists (0 services)
Done.

I did a scan with my Sony Bravia TV and it found some +100 digital channels.

/Fredrik


