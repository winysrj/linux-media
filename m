Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <HWerner4@gmx.de>) id 1KiBvJ-0000mZ-IB
	for linux-dvb@linuxtv.org; Tue, 23 Sep 2008 19:43:42 +0200
Date: Tue, 23 Sep 2008 19:43:05 +0200
From: "Hans Werner" <HWerner4@gmx.de>
In-Reply-To: <alpine.DEB.1.10.0809231848260.26459@ybpnyubfg.ybpnyqbznva>
Message-ID: <20080923174305.282400@gmx.net>
MIME-Version: 1.0
References: <200809211905.34424.hftom@free.fr> <20080921235429.18440@gmx.net>
	<200809221201.26115.hftom@free.fr> <20080923162757.282370@gmx.net>
	<alpine.DEB.1.10.0809231848260.26459@ybpnyubfg.ybpnyqbznva>
To: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
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



> On Tue, 23 Sep 2008, Hans Werner wrote:
> 
> > My CPU (3ghz core 2 quad) is fast enough to show live HD video
> > [...]   ARTE HD throws some errors and stutters a bit. 
> 
> A suggestion:  Write your arte-HD streams to disk, instead of
> trying to decode them real-time.
> 
> If for some reason your CPU isn't quite fast enough, you can
> later decode the arte-HD streams and see if the artifacts you
> are observing are still present.

Hi Barry, thanks for the suggestion. 

I have checked this : Arte HD recordings I have just made with Kaffeine
play perfectly with mplayer (svn yesterday). So there's no basic
problem with my CPU power or with support for the stream by ffmpeg. 
When played back in kaffeine/xinelib the sound is missing or jittery.

Simul HD is a different story -- recordings play ok for a few tens of seconds
in mplayer (with some errors "warning: first frame is no keyframe") until a
hard crash with error "Internal error, picture buffer overflow" from mplayer.
In kaffeine it the recordings play with jittery sound and then crash at exactly the
same points with the same error.

Any ideas anyone?

Regards,
Hans
-- 
Release early, release often.

Ist Ihr Browser Vista-kompatibel? Jetzt die neuesten 
Browser-Versionen downloaden: http://www.gmx.net/de/go/browser

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
