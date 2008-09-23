Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta3.srv.hcvlny.cv.net ([167.206.4.198])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KiAva-0004lI-A6
	for linux-dvb@linuxtv.org; Tue, 23 Sep 2008 18:39:55 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta3.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K7N00FRRQ96U121@mta3.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Tue, 23 Sep 2008 12:39:13 -0400 (EDT)
Date: Tue, 23 Sep 2008 12:39:05 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <20080923162757.282370@gmx.net>
To: Christophe Thommeret <hftom@free.fr>
Message-id: <48D91BA9.9020803@linuxtv.org>
MIME-version: 1.0
References: <200809211905.34424.hftom@free.fr> <20080921235429.18440@gmx.net>
	<200809221201.26115.hftom@free.fr> <20080923162757.282370@gmx.net>
Cc: Hans Werner <HWerner4@gmx.de>, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] hvr4000-s2api + QAM_AUTO
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hans Werner wrote:
>>>> Hi Steve,
>>>>
>>>> I've managed to add S2 support to kaffeine, so it can scan and zap.
>>>> However, i have a little problem with DVB-S:
>>>> Before tuning to S2, S channels tune well with QAM_AUTO.
>>>> But after having tuned to S2 channels, i can no more lock on S ones
>> until
>>>> i
>>>> set modulation to QPSK insteed of QAM_AUTO for these S channels.
>>>> Is this known?
>>>>
>>>> --
>>>> Christophe Thommeret
>>> Hi Christophe,
> ...
>>> I'd be very happy to try out your patch for Kaffeine and give feedback
>> if
>>> you are ready to share it.
>> Sure, here it is (patch against current svn 
>> http://websvn.kde.org/branches/extragear/kde3/multimedia/)
>>
>> Atm, s2api is only used for S/S2.
>>
>> P.S.
>> In order to play H264/HD with kaffeine/xine, you need a fairly recent
>> ffmpeg 
>> and xine compiled with --with-external-ffmpeg configure option. (and of 
>> course a quite strong cpu, unlike my old athlon-xp-2600 :)
>> However, you can still record and/or broadcast without this update.
> 
> Success! Many thanks Christophe.
> 
> With the following:
> HVR4000 card
> S2API + multifrontend patch (hg clone http://linuxtv.org/hg/~stoth/s2-mfe)
> ffmpeg from SVN
> xine-lib from mercurial (compiled with --with-external-ffmpeg)
> Kaffeine from SVN + Christophe's S2API patch
> 

Excellent news.

Christophe, thanks for helping with Kaffeine :)

Regards,

- Steve

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
