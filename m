Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:65260 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751215Ab1LPIU1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Dec 2011 03:20:27 -0500
Received: by lagp5 with SMTP id p5so1360078lag.19
        for <linux-media@vger.kernel.org>; Fri, 16 Dec 2011 00:20:26 -0800 (PST)
Message-ID: <4EEAFF47.5040003@gmail.com>
Date: Fri, 16 Dec 2011 09:20:23 +0100
From: Fredrik Lingvall <fredrik.lingvall@gmail.com>
MIME-Version: 1.0
To: Mihai Dobrescu <msdobrescu@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: Hauppauge HVR-930C problems
References: <CALJK-QhGrjC9K8CasrUJ-aisZh8U_4-O3uh_-dq6cNBWUx_4WA@mail.gmail.com> <4EE9AA21.1060101@gmail.com> <CALJK-QjxDpC8Y_gPXeAJaT2si_pRREiuTW=T8CWSTxGprRhfkg@mail.gmail.com>
In-Reply-To: <CALJK-QjxDpC8Y_gPXeAJaT2si_pRREiuTW=T8CWSTxGprRhfkg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/15/11 10:08, Mihai Dobrescu wrote:
> Hello Fredrik,
>
> I have extracted the firmware, but I've noticed there are 2 versions,
> one for 32 bit and one for 64 bit. Which one should it be?
There is probably a 64-bit and a 32-bit Windows driver but the firmware 
should be the same I think.
> My OS is 64 bit, I use the kernel sys-kernel/linux-sabayon-3.1-r2:
>
> uname --all
> Linux USC 3.1.0-sabayon #1 SMP Wed Nov 30 10:37:12 UTC 2011 x86_64
> Intel(R) Core(TM) i7 CPU 920 @ 2.67GHz GenuineIntel GNU/Linux
>
> I have successfully compiled the sources from media_build taking the
> latest sources I've found, using:
>
> git clone git://linuxtv.org/media_build.git
>
> Also, what to do next?
>
> I've tried w_scan:
>
> w_scan -fc -c RO -k
> w_scan version 20101204 (compiled for DVB API 5.2)
> using settings for ROMANIA
> Country identifier RO not defined. Using defaults.
> frontend_type DVB-C, channellist 4
> output format kaffeine channels.dvb
> Info: using DVB adapter auto detection.
>          /dev/dvb/adapter0/frontend0 ->  DVB-C "DRXK DVB-C": good :-)
>          /dev/dvb/adapter0/frontend1 ->  DVB-T "DRXK DVB-T": specified
> was DVB-C ->  SEARCH NEXT ONE.
> Using DVB-C frontend (adapter /dev/dvb/adapter0/frontend0)
> -_-_-_-_ Getting frontend capabilities-_-_-_-_
> Using DVB API 5.5
> frontend DRXK DVB-C supports
> INVERSION_AUTO
> QAM_AUTO not supported, trying QAM_64.
> FEC_AUTO
> -_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_
> searching QAM64...
> 177500: sr6900 (time: 00:07) sr6875 (time: 00:10)
> 184500: sr6900 (time: 00:12) sr6875 (time: 00:15)
> 191500: sr6900 (time: 00:18) sr6875 (time: 00:20)
> 198500: sr6900 (time: 00:23) sr6875 (time: 00:25)
> 205500: sr6900 (time: 00:28) sr6875 (time: 00:30)
> 212500: sr6900 (time: 00:33) sr6875 (time: 00:35)
> 219500: sr6900 (time: 00:38) sr6875 (time: 00:40)
> 226500: sr6900 (time: 00:43) sr6875 (time: 00:46)
> 474000: sr6900 (time: 00:48) sr6875 (time: 00:51)
> 482000: sr6900 (time: 00:53) sr6875 (time: 00:56)
> 490000: sr6900 (time: 00:58) sr6875 (time: 01:01)
> 498000: sr6900 (time: 01:03) sr6875 (time: 01:06)
> 506000: sr6900 (time: 01:08) sr6875 (time: 01:11)
> 514000: sr6900 (time: 01:13) sr6875 (time: 01:16)
> 522000: sr6900 (time: 01:19) sr6875 (time: 01:21)
> 530000: sr6900 (time: 01:24) sr6875 (time: 01:26)
> 538000: sr6900 (time: 01:29) sr6875 (time: 01:31)
> 546000: sr6900 (time: 01:34) sr6875 (time: 01:36)
> 554000: sr6900 (time: 01:39) sr6875 (time: 01:41)
> 562000: sr6900 (time: 01:44) sr6875 (time: 01:46)
> 570000: sr6900 (time: 01:49) sr6875 (time: 01:52)
> 578000: sr6900 (time: 01:54) sr6875 (time: 01:57)
> 586000: sr6900 (time: 01:59) sr6875 (time: 02:02)
> 594000: sr6900 (time: 02:04) sr6875 (time: 02:07)
> 602000: sr6900 (time: 02:09) sr6875 (time: 02:12)
> 610000: sr6900 (time: 02:14) sr6875 (time: 02:17)
> 618000: sr6900 (time: 02:19) sr6875 (time: 02:22)
> 626000: sr6900 (time: 02:25) sr6875 (time: 02:27)
> 634000: sr6900 (time: 02:30) sr6875 (time: 02:32)
> 642000: sr6900 (time: 02:35) sr6875 (time: 02:37)
> 650000: sr6900 (time: 02:40) sr6875 (time: 02:42)
> 658000: sr6900 (time: 02:45) sr6875 (time: 02:47)
> 666000: sr6900 (time: 02:50) sr6875 (time: 02:53)
> 674000: sr6900 (time: 02:55) sr6875 (time: 02:58)
> 682000: sr6900 (time: 03:00) sr6875 (time: 03:03)
> 690000: sr6900 (time: 03:05) sr6875 (time: 03:08)
> 698000: sr6900 (time: 03:10) sr6875 (time: 03:13)
> 706000: sr6900 (time: 03:15) sr6875 (time: 03:18)
> 714000: sr6900 (time: 03:20) sr6875 (time: 03:23)
> 722000: sr6900 (time: 03:26) sr6875 (time: 03:28)
> 730000: sr6900 (time: 03:31) sr6875 (time: 03:33)
> 738000: sr6900 (time: 03:36) sr6875 (time: 03:38)
> 746000: sr6900 (time: 03:41) sr6875 (time: 03:43)
> 754000: sr6900 (time: 03:46) sr6875 (time: 03:48)
> 762000: sr6900 (time: 03:51) sr6875 (time: 03:53)
> 770000: sr6900 (time: 03:56) sr6875 (time: 03:59)
> 778000: sr6900 (time: 04:01) sr6875 (time: 04:04)
> 786000: sr6900 (time: 04:06) sr6875 (time: 04:09)
> 794000: sr6900 (time: 04:11) sr6875 (time: 04:14)
> 802000: sr6900 (time: 04:16) sr6875 (time: 04:19)
> 810000: sr6900 (time: 04:21) sr6875 (time: 04:24)
> 818000: sr6900 (time: 04:27) sr6875 (time: 04:29)
> 826000: sr6900 (time: 04:32) sr6875 (time: 04:34)
> 834000: sr6900 (time: 04:37) sr6875 (time: 04:39)
> 842000: sr6900 (time: 04:42) sr6875 (time: 04:44)
> 850000: sr6900 (time: 04:47) sr6875 (time: 04:49)
> 858000: sr6900 (time: 04:52) sr6875 (time: 04:54)
>
> ERROR: Sorry - i couldn't get any working frequency/transponder
>   Nothing to scan!!
>
> There are unencrypted channels, as I receive them under Windows.


I have had the same problem with scanning on the 930C. There has been several new patches commited to the git tree the last couple of weeks so try the latest driver from git. I had no time this week to test it but I will test this too next week.

And, I recommend that you CC the linux-media list with as detailed reports as possible of your tests so the poeple working on it get the test results.

Regards,

/Fredrik

