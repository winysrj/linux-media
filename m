Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from hond.eatserver.nl ([195.20.9.5])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <joep@groovytunes.nl>) id 1K9ikG-0003gj-4D
	for linux-dvb@linuxtv.org; Fri, 20 Jun 2008 17:41:49 +0200
Received: from test (82-171-18-31.ip.telfort.nl [82.171.18.31])
	(authenticated bits=0)
	by hond.eatserver.nl (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id
	m5KFfiLe020636
	for <linux-dvb@linuxtv.org>; Fri, 20 Jun 2008 17:41:44 +0200
From: joep <joep@groovytunes.nl>
To: linux-dvb@linuxtv.org
Date: Fri, 20 Jun 2008 17:45:47 +0200
References: <200805122042.43456.ajurik@quick.cz>
	<loom.20080620T131302-220@post.gmane.org>
	<200806201547.28906.ajurik@quick.cz>
In-Reply-To: <200806201547.28906.ajurik@quick.cz>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806201745.47628.joep@groovytunes.nl>
Subject: Re: [linux-dvb]
	=?iso-8859-1?q?Re_=3A_Re_=3A_Re_=3A_No_lock_possible_?=
	=?iso-8859-1?q?at_some_DVB-S2=09channels_with_TT_S2-3200/linux?=
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

Op Friday 20 June 2008 15:47:28 schreef Ales Jurik:
> On Friday 20 of June 2008, Daniel wrote:
> > Ales Jurik <ajurik <at> quick.cz> writes:
> > > On Monday 16 of June 2008, joep wrote:
> > > > The most important thing I can't get working is diseqc switching.
> > > > Does anyone use Astra23,5 or hotbird13 with the multiproto driver?
> > >
> > > I'm using multiproto with TT S2-3200 and 4-way diseqc switch (13.0E,
> > > 19.2E, 23.5 and motor with secondary dish). No problem, but for motor
> > > I'm using patch in vdr (vdr-1.6.0-gotox.diff).
> > >
> > > BR,
> > > Ales
> >
> > I have the exact same problem. When Telenor moved the DVB-S2 channels and
> > changed FEC from 2/3 to 3/4 and turned pilot off all DVB-S2 channels just
> > stopped working for me. Before the changed I had no problems at all with
> > them. It have to be somekind of driverproblem since I have done no
> > changes to my linuxsetup and when I try the card in windoze it works just
> > fine. I noticed in the pressrelease Telenor published that the netbitrate
> > increased from 48.391Mbps to 55.703Mbps along with the FEC change. Could
> > that cause any problems? Or could it be problems with the pilothandling
> > in the driver?
> >
> > Daniel
>
> I'm still trying to find the reason of that problem, but (as I think) this
> is done not by FEC as well not by bitrate. All channels in 8PSK modulation
> are not possible to receive, or the lock is after few minutes. So I'm
> thinking that 8PSK is badly handled within the driver.
>
> BR,
>
> Ales
>

I found out I did make a mistake.
I can watch a channel with FEC 9/10 on Astra 19.2 (11914.50 H)
However the channels on astra 23.5 won't lock.
The one that is most important for me uses dvb-s2 qpsk according to kingofsat.
So this might be an other problem than the 8psk problem you decribe.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
