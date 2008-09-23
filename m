Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mx30.mail.ru ([194.67.23.238])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <goga777@bk.ru>) id 1KiC0p-0001YY-61
	for linux-dvb@linuxtv.org; Tue, 23 Sep 2008 19:49:24 +0200
Received: from [92.101.138.183] (port=62481 helo=localhost.localdomain)
	by mx30.mail.ru with asmtp id 1KiC0G-000GpB-00
	for linux-dvb@linuxtv.org; Tue, 23 Sep 2008 21:48:48 +0400
Date: Tue, 23 Sep 2008 21:49:07 +0400
From: Goga777 <goga777@bk.ru>
To: linux-dvb@linuxtv.org
Message-ID: <20080923214907.3bcec6f7@bk.ru>
In-Reply-To: <20080923174305.282400@gmx.net>
References: <200809211905.34424.hftom@free.fr> <20080921235429.18440@gmx.net>
	<200809221201.26115.hftom@free.fr> <20080923162757.282370@gmx.net>
	<alpine.DEB.1.10.0809231848260.26459@ybpnyubfg.ybpnyqbznva>
	<20080923174305.282400@gmx.net>
Mime-Version: 1.0
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

> > On Tue, 23 Sep 2008, Hans Werner wrote:
> > 
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

could you play with ffplay from svn and download somewhere the sample with 10 MB size (I will try to play)

Goga

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
