Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from hond.eatserver.nl ([195.20.9.5])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <joep@groovytunes.nl>) id 1K8K6E-0000l4-PM
	for linux-dvb@linuxtv.org; Mon, 16 Jun 2008 21:10:43 +0200
Received: from test (82-171-18-31.ip.telfort.nl [82.171.18.31])
	(authenticated bits=0)
	by hond.eatserver.nl (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id
	m5GJAcvY009592
	for <linux-dvb@linuxtv.org>; Mon, 16 Jun 2008 21:10:38 +0200
From: joep <joep@groovytunes.nl>
To: linux-dvb@linuxtv.org
Date: Mon, 16 Jun 2008 21:14:27 +0200
References: <200805122042.43456.ajurik@quick.cz>
	<1213582905l.12580l.1l@manu-laptop>
	<200806161020.05437.ajurik@quick.cz>
In-Reply-To: <200806161020.05437.ajurik@quick.cz>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806162114.27912.joep@groovytunes.nl>
Subject: Re: [linux-dvb] Re : Re : Re : No lock possible at some DVB-S2
	channels with TT S2-3200/linux
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Op Monday 16 June 2008 10:20:04 schreef Ales Jurik:
> On Monday 16 of June 2008, manu wrote:
> > Le 15.06.2008 13:20:30, Ales Jurik a =E9crit=A0:
> > > On Sunday 15 of June 2008, Dominik Kuhlen wrote:
> > > > Hi,
> > > >
> > > > On Thursday 22 May 2008, Ales Jurik wrote:
> > > > > Hi,
> > > > >
> > > > > my friend told me that he is sometimes able to get lock by
> > >
> > > decreasing
> > >
> > > > > (not increasing) the frequency. Yesterday I've tested it and it
> > >
> > > seems to
> > >
> > > > > me he was right. So I'm able to get (not very stable, for few
> > >
> > > minutes)
> > >
> > > > > lock as well as by increasing and by decreasing frequency of the
> > >
> > > same
> > >
> > > > > channel (EurosportHD).
> > > >
> > > > The derotator code in the stb0899 seems to be setting the initial
> > >
> > > frequency
> > >
> > > > to the lowest search range and never changes this (as it should
> > >
> > > increase
> > >
> > > > steadily to find a lock)
> > > >
> > > > > It was also detected (not by me, I don't have riser card) that
> > >
> > > when the
> > >
> > > > > card is connected not directly into PCI slot but with some riser
> > >
> > > card,
> > >
> > > > > the needed difference for getting lock is higher (up to 10MHz).
> > >
> > > So
> > > also
> > >
> > > > > some noise from PC is going into calculations.
> > > > >
> > > > > I don't think the problem is in computation of frequency but in
> > >
> > > for
> > >
> > > > > example not stable signal amplitude at input of demodulator or in
> > >
> > > not
> > >
> > > > > fluently changing the gain and bandwith of tuner within the band.
> > >
> > > As I
> > >
> > > > > see in the code some parameters are changing in steps and maybe 3
> > >
> > > steps
> > >
> > > > > for whole band is not enough? Especially in real conditions (not
> > >
> > > in lab)?
> > >
> > > > Could you please try the attached patch if this fixes the problem
> > >
> > > with
> > >
> > > > nominal frequency/symbolrate settings?
> > >
> > > Many thanks, but I don't see any improvement. Minimum time after I've
> > > lock is
> > > 150s.
> > >
> > > The only improvement was done 2weeks ago when Manu Abraham fixed some
> > > headers
> > > with register addresses. From that time it is possible to get lock
> > > also at
> > > problematic channels but very unstable.
> > >
> > > But I've found that all channels with lock problems are DVB-S2, 8PSK,
> > > FEC 3/4.
> > > So all channels broadcasted in QPSK is possible to tune without
> > > problems and
> > > also channels broadcasted in DVB-S2, 8PSK, FEC 2/3 are possible to
> > > tune to
> > > without problems. Channels in DVB-S2, 8PSK with different FEC (to 2/3
> > > and
> > > 3/4) I was not able to test.
> >
> > For me adding 4MHz solved the lock problems for DVB-S QPSK FEC 3/4, but
> > did not solve my problems for a DVB-S QPSK FEC 5/6.
> > I will try Dominik's patch to see if it improves things.
> > Stay tuned (oh well)
> > Bye
> > Manu
>
> So it seems to me that there are more problem in driver that (maybe) could
> be solved separately:
>
> 1. Some channels/transponders could be tuned by increasing/decreasing fre=
q.
> by 4-10MHz. This solution is not for me usable. I didn't find any
> transponder on such solution is working. But for my friend this is working
> on transponders which I'm able to tune to directly. Maybe some problem in
> tolerance of TT S2-3200 components or in PC case (grounding or so).
>
> 2. Some channels/transponders is not possible to tune if this transponders
> is choosing as first after changing satellite (by diseqc switch). This is
> generally solved by users by tuning to another transponder at problematic
> satellite (for me for example this two transponders use the same
> modulation) - it seems not to be modulation problem (timing problem?).
>
> 3. At some transponders above 2 point doesn't help to get lock. For me
> these transponders are all DVB-S2, 8PSK and FEC3/4.
>
> Maybe I'm not right but hope another small step forward.
>

I don't have the TT S2-3200 yet (it will arive tomorow).
I do have the skystar hd2 which also has the STB0899 and the STB6100.
So maybee some of this info can be usefull.

With this card I have the following situations on astra 19,2:
After a reboot I can't tune to any dvb-s channel.
Tuning to astra hd promo at dvbs-2 11914500H does work.
After that I can successfull tune to these transponders
dvb-s 12574250 22000 5/6 h (bvn)
dvb-s 11836500 27500 3/4 h (erste)
dvb-s 12544750 22000 5/6 h (sat 1)

after adding 4500 to the frequency of bvn, I can change directly to this =

channel after a reboot.

The most important thing I can't get working is diseqc switching.
Does anyone use Astra23,5 or hotbird13 with the multiproto driver?
If so, please tell me which channels you can tune to successfuly so I can d=
o =

my next tests on those channels.

Greetings,
JoepAdmiraal

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
