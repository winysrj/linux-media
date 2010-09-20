Return-path: <mchehab@pedra>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:63966 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754336Ab0ITCat (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Sep 2010 22:30:49 -0400
Received: by ywh1 with SMTP id 1so1184896ywh.19
        for <linux-media@vger.kernel.org>; Sun, 19 Sep 2010 19:30:48 -0700 (PDT)
Message-ID: <4C96C7EC.4040603@gmail.com>
Date: Sun, 19 Sep 2010 22:33:16 -0400
From: Emmanuel <eallaud@gmail.com>
MIME-Version: 1.0
To: SE <tuxoholic@hotmail.de>
CC: linux-media@vger.kernel.org, manu@linuxtv.org
Subject: Re: [PATCH] faster DVB-S lock with cards using stb0899 demod
References: <BLU0-SMTP1574ECDF1FB4B418ACB34CED87D0@phx.gbl>
In-Reply-To: <BLU0-SMTP1574ECDF1FB4B418ACB34CED87D0@phx.gbl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

SE a écrit :
> hi list
>
> v4l-dvb still lacks fast and reliable dvb-s lock for stb08899 chipsets. This 
> problem was adressed by Alex Betis two years ago [1]+[2]resulting in a patch 
> [3] that made its way into s2-liplianin, not v4l-dvb.
>
> With minor adjustments by me this patch now offers reliable dvb-s/dvb-s2 lock 
> for v4l-dvb, most of them will lock in less than a second. Without the patch 
> many QPSK channels won't lock at all or within a 5-20 second delay.
>
> The algo can be tested with a modified version of szap-s2 [4], introducing:
>
> * process a channel list sequentially (-e [number] -n [number])
> * DiSEqC repetition (-s [number] - the default is 1 sequence + 1 repetition)
> * faster status polling (poll instantly after tuning, then poll every 10ms
>   instead of 1 poll per second)
> * some statistics about the tuning success while processing the list
>
> Here are the new features of szap2-s2 explained:
>
> ## channel lock with instant status poll [last raw still is 0]
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> status 1f|signal 27948|noise 56032|ber 0|unc -2|tim 0|FE_HAS_LOCK| 0
>
> ## channel lock with the first status poll [last raw is 1]
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> status 0b|signal 23200|noise 40413|ber 0|unc -2|tim 0|
> status 1b|signal 23200|noise 37136|ber 0|unc -2|tim 1|FE_HAS_LOCK| 1
>
> ## channel lock with the second status poll [last raw is 2]
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> status 00|signal   245|noise    21|ber 0|unc -2|tim 0|
> status 1f|signal 17347|noise 45219|ber 0|unc -2|tim 2|FE_HAS_LOCK| 2
>
> ## no channel lock - try to lock for 10 seconds, then give up and increase 
> lok_errs +1
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> status 00 | signal 0 | noise 4 | ber 0 | unc -2 | tim    0 |
> status 00 | signal 0 | noise 4 | ber 0 | unc -2 | tim  100 |
> status 00 | signal 0 | noise 4 | ber 0 | unc -2 | tim  200 |
> status 00 | signal 0 | noise 4 | ber 0 | unc -2 | tim  300 |
> status 00 | signal 0 | noise 4 | ber 0 | unc -2 | tim  400 |
> status 00 | signal 0 | noise 4 | ber 0 | unc -2 | tim  500 |
> status 00 | signal 0 | noise 4 | ber 0 | unc -2 | tim  600 |
> status 00 | signal 0 | noise 4 | ber 0 | unc -2 | tim  700 |
> status 00 | signal 0 | noise 4 | ber 0 | unc -2 | tim  800 |
> status 00 | signal 0 | noise 4 | ber 0 | unc -2 | tim  900 |
>
> ## the tuning statistics look like this:
> lok_errs =0, runs=3035 of sequ=1207, multi=139, multi_max=2
>
> * lok_errs = amount of lock errors
> * runs = current channel number while processing the list
> * sequ = the amount of channels to process you specified with "-e [number]"
> * multi = amount of multiple polls
> * multi_max =  the highest status poll of a channel is stored in here
>
>
> Here are the results from ezap2 with an Astra 19.2E list and improved algo:
>
> TOT: lok_errs =0, runs=1207 of sequ=1207, multi=48, multi_max=47
>
> real    22m52.883s
> user    0m0.004s
> sys     0m20.297s
>
>
> Here are the results from ezap2 with the same list and v4l-dvb mercurial algo:
>
> TOT: lok_errs =233, runs=1207 of sequ=1207, multi=113361, multi_max=987
>
> real    135m34.236s
> user    0m0.344s
> sys     7m52.322s
>
>
> Similar results where reported by testers in vdr-portal.de [5]
>
> Feel free to test the improved algo yourself like this:
>
> time ./ezap2 -a0 -xHc Astra_only.txt -e 1207 -n 1 >> zap.log
>
> Change adapter to 1 or higher in case stb0899 is a different adapter in your 
> multi card setup.
>
> Attachments are stb0899_algo.c.patch, szap-s2-to-ezap2.patch, Astra_only.txt 
> (Astra 19.2E channels list in zap format)
>
> Inline posted patches get word wrapped again and again in kmail, even after I 
> followed the suggestions in email-clients.txt
>
>
> [1] http://www.linuxtv.org/pipermail/linux-dvb/2008-September/029361.html
> [2] http://www.linuxtv.org/pipermail/linux-dvb/2008-October/029455.html
> [3] http://mercurial.intuxication.org/hg/s2-liplianin/rev/d423b7887ec8
> [4] http://mercurial.intuxication.org/hg/szap-s2
> [5] http://www.vdr-portal.de/board/thread.php?threadid=99603
>
> Signed-off-by: SE <tuxoholic@hotmail.de>
>   
I will try this with a TT-S2 3200 when I find some time ;-) Do I need a 
very recent tree?
I have a v4l-dvb tree from a year ago I think.
Bye
Manu
