Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n40.bullet.mail.ukl.yahoo.com ([87.248.110.173])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <eallaud@yahoo.fr>) id 1K84Q7-0004SR-JB
	for linux-dvb@linuxtv.org; Mon, 16 Jun 2008 04:26:14 +0200
Date: Sun, 15 Jun 2008 22:21:45 -0400
From: manu <eallaud@yahoo.fr>
To: linux-dvb@linuxtv.org
References: <200805122042.43456.ajurik@quick.cz>
	<200805221013.10246.ajurik@quick.cz>
	<200806151147.19451.dkuhlen@gmx.net>
	<200806151920.30719.ajurik@quick.cz>
In-Reply-To: <200806151920.30719.ajurik@quick.cz> (from ajurik@quick.cz on
	Sun Jun 15 13:20:30 2008)
Message-Id: <1213582905l.12580l.1l@manu-laptop>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Re : Re : Re : No lock possible at some DVB-S2 channels
 with TT S2-3200/linux
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

Le 15.06.2008 13:20:30, Ales Jurik a =E9crit=A0:
> On Sunday 15 of June 2008, Dominik Kuhlen wrote:
> > Hi,
> >
> > On Thursday 22 May 2008, Ales Jurik wrote:
> > > Hi,
> > >
> > > my friend told me that he is sometimes able to get lock by
> decreasing
> > > (not increasing) the frequency. Yesterday I've tested it and it
> seems to
> > > me he was right. So I'm able to get (not very stable, for few
> minutes)
> > > lock as well as by increasing and by decreasing frequency of the
> same
> > > channel (EurosportHD).
> >
> > The derotator code in the stb0899 seems to be setting the initial
> frequency
> > to the lowest search range and never changes this (as it should
> increase
> > steadily to find a lock)
> >
> > > It was also detected (not by me, I don't have riser card) that
> when the
> > > card is connected not directly into PCI slot but with some riser
> card,
> > > the needed difference for getting lock is higher (up to 10MHz). =

> So
> also
> > > some noise from PC is going into calculations.
> > >
> > > I don't think the problem is in computation of frequency but in
> for
> > > example not stable signal amplitude at input of demodulator or in
> not
> > > fluently changing the gain and bandwith of tuner within the band.
> As I
> > > see in the code some parameters are changing in steps and maybe 3
> steps
> > > for whole band is not enough? Especially in real conditions (not
> in lab)?
> >
> > Could you please try the attached patch if this fixes the problem
> with
> > nominal frequency/symbolrate settings?
> >
> =

> Many thanks, but I don't see any improvement. Minimum time after I've
> lock is =

> 150s. =

> =

> The only improvement was done 2weeks ago when Manu Abraham fixed some
> headers =

> with register addresses. From that time it is possible to get lock
> also at =

> problematic channels but very unstable.
> =

> But I've found that all channels with lock problems are DVB-S2, 8PSK,
> FEC 3/4. =

> So all channels broadcasted in QPSK is possible to tune without
> problems and =

> also channels broadcasted in DVB-S2, 8PSK, FEC 2/3 are possible to
> tune to =

> without problems. Channels in DVB-S2, 8PSK with different FEC (to 2/3
> and =

> 3/4) I was not able to test.

For me adding 4MHz solved the lock problems for DVB-S QPSK FEC 3/4, but =

did not solve my problems for a DVB-S QPSK FEC 5/6.
I will try Dominik's patch to see if it improves things.
Stay tuned (oh well)
Bye
Manu





_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
