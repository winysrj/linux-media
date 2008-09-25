Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mx3.mail.ru ([194.67.23.149])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <goga777@bk.ru>) id 1KiuYY-0002H9-34
	for linux-dvb@linuxtv.org; Thu, 25 Sep 2008 19:23:13 +0200
Date: Thu, 25 Sep 2008 21:22:51 +0400
From: Goga777 <goga777@bk.ru>
To: "Hans Werner" <HWerner4@gmx.de>
Message-ID: <20080925212251.197da7b5@bk.ru>
In-Reply-To: <20080923174305.282400@gmx.net>
References: <200809211905.34424.hftom@free.fr> <20080921235429.18440@gmx.net>
	<200809221201.26115.hftom@free.fr> <20080923162757.282370@gmx.net>
	<alpine.DEB.1.10.0809231848260.26459@ybpnyubfg.ybpnyqbznva>
	<20080923174305.282400@gmx.net>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
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


> > > My CPU (3ghz core 2 quad) is fast enough to show live HD video
> > > [...]   ARTE HD throws some errors and stutters a bit. 
> > 
> > A suggestion:  Write your arte-HD streams to disk, instead of
> > trying to decode them real-time.
> > 
> > If for some reason your CPU isn't quite fast enough, you can
> > later decode the arte-HD streams and see if the artifacts you
> > are observing are still present.
> 
> Hi Barry, thanks for the suggestion. 
> 
> I have checked this : Arte HD recordings I have just made with Kaffeine
> play perfectly with mplayer (svn yesterday). So there's no basic
> problem with my CPU power or with support for the stream by ffmpeg. 
> When played back in kaffeine/xinelib the sound is missing or jittery.
> 
> Simul HD is a different story -- recordings play ok for a few tens of seconds
> in mplayer (with some errors "warning: first frame is no keyframe") until a
> hard crash with error "Internal error, picture buffer overflow" from mplayer.
> In kaffeine it the recordings play with jittery sound and then crash at exactly the
> same points with the same error.
> 
> Any ideas anyone?


after my bug report and sample from SimulHD Michael Niedermayer from ffmpeg-team has fixed this bug in ffh264
in 15413 revision. Could you test please
https://roundup.mplayerhq.hu/roundup/ffmpeg/issue652

Goga


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
