Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-in-13.arcor-online.net ([151.189.21.53])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hermann-pitton@arcor.de>) id 1Jnjvr-00073R-7S
	for linux-dvb@linuxtv.org; Mon, 21 Apr 2008 02:30:58 +0200
From: hermann pitton <hermann-pitton@arcor.de>
To: linux-dvb@linuxtv.org
In-Reply-To: <200804210132.17281@orion.escape-edv.de>
References: <4803E9A2.30804@t-online.de>
	<200804210132.17281@orion.escape-edv.de>
Date: Mon, 21 Apr 2008 02:30:21 +0200
Message-Id: <1208737821.5682.58.camel@pc10.localdom.local>
Mime-Version: 1.0
Cc: Hartmut Hackmann <hartmut.hackmann@t-online.de>
Subject: Re: [linux-dvb] tda10086: Testers wanted
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


Am Montag, den 21.04.2008, 01:32 +0200 schrieb Oliver Endriss:
> Hartmut Hackmann wrote:
> > Hi, folks
> > 
> > In my personal repository at
> > http://linuxtv.org/hg/~hhackmann/v4l-dvb/
> > there are 2 changes that affect all DVB-S cards with tda10086
> > - The reference frequency (crystal) of the tda10086 now is an option
> >    of the tda10086_config struct. This is necessary i.e. for cards with the
> >    SD1878 tuner.
> >    I adapted the driver for these boards:
> >     - TT Budget-S-1401
> >     - Pinnacle 400e / Technotrend USB
> >     - Lifeview Flydvb Trio
> >     - Medion MD8800
> >     - Lifeview Flydvbs LR300
> >     - Philips Snake
> >     - MD7134 (Bridge 2 - works now)
> > 
> > - The bandwidth of the tda826x baseband filter is now set according to the
> >    expected symbol rate. The boards with this tuner now should work with
> >    transponders providing a higher symbol rate than usual.
> >    This patch was provided by Oliver Endriss.
> > 
> > I tried to make the changes backward compatibe but since i can't test these
> > cards, i need your feedback.
> 
> Sorry, I have no hardware to test your patches.
> 
> > Oliver: there was no signature in your patch. But of corse i mentioned you
> > in the log. I hope that's ok for you.
> 
> I don't care, but beware that the lawyers @LKML might send you to jail.
> :D
> 
> CU
> Oliver
> 

Hi,

they won't, since we will take all away from them they seem to have :)

Seriously, Oliver, I have tested your patch previously and the highest
symbol rate is even only 28000 at the Hotbird crowd, so for me no
difference.

Hartmut, didn't care for the clock, _very_ unlikely a problem,
but if you prefer to have it tested explicitly, I come back with some
report.

Cheers,
Hermann





_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
