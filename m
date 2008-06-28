Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n45.bullet.mail.ukl.yahoo.com ([87.248.110.178])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <eallaud@yahoo.fr>) id 1KCcwB-00017s-3W
	for linux-dvb@linuxtv.org; Sat, 28 Jun 2008 18:06:10 +0200
Date: Sat, 28 Jun 2008 11:19:50 -0400
From: manu <eallaud@yahoo.fr>
To: linux-dvb@linuxtv.org
References: <1214015056l.6292l.1l@manu-laptop>
	<200806211114.46921.ajurik@quick.cz> <1214657052l.7275l.0l@manu-laptop>
In-Reply-To: <1214657052l.7275l.0l@manu-laptop> (from eallaud@yahoo.fr on
	Sat Jun 28 08:44:12 2008)
Message-Id: <1214666390l.13865l.0l@manu-laptop>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Re : Re : How to solve the TT-S2-3200 tuning problems?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Le 28.06.2008 08:44:12, manu a =E9crit=A0:
> Le 21.06.2008 05:14:46, Ales Jurik a =E9crit=A0:
> > Hi,
> > =

> > I've tried to see where the problem is for some time. My opinions
> and
> > results =

> > of some debugging work is included.
> > =

> > I'm ready to cooperate in debugging of this driver.
> > =

> > BR,
> > =

> > Ales
> > =

> > On Saturday 21 of June 2008, manu wrote:
> > > 	Hi all,
> > > there are several threads about TT-3200 not being able to lock on
> > > different channels depending on FEC/symbol rate/modulation.
> > > Now what kind of experimentation could provide enough data to
> solve
> > > them? For example would it be possible that some knowledgeable =

> guy
> > here
> > > posts:
> > > -datasheets/programming guide for the tuner/demod if no NDA...
> > =

> > Yes, such documents are under NDA, I don't have access to it.
> > =

> > > -post the source of a prog that could gather data when tuning to =

> a
> > > given transponder.
> > > -or anything else that this/these persons think would improve the
> > > understanding of the problems.
> > > HTH
> > > Bye
> > > Manu, who would like to watch the final of the euro cup in HD ;-)
> > =

> > The point from which I've checked the driver is file stb0899_priv.h
> > (enum =

> > stb0899_modcod). There are defined values for all possible =

> > FEC/modulation combinations. We could see that 8PSK modulations =

> have
> > values =

> > from 12 to 17 (for debugging). =

> > =

> > But no initial values are used for 8PSK modulation for registers
> csm1
> > to csm4 =

> > as the stb0899_dvbs2_init_csm is called only for QPSK ( condition =

> is
> > and-ed =

> > with INRANGE(STB0899_QPSK_23, modcod, STB0899_QPSK_910) ).
> > =

> > I'm not sure if this is the reason of problems, but I could get =

> lock
> > (very =

> > unstable - lock is active for few minutes, than for minute or so
> > disappeared =

> > and so long) after few minutes staying tuned on some 8PSK channels. =

> > =

> > Maybe if set some registers (don't know if csm1-csm4 is enough) to
> > initial =

> > values depending on FEC/modulation it would be possible to get lock
> > within =

> > seconds like it is with QPSK.
> > =

> > In the driver there are also some pieces of code depended to
> > FEC/modulation, =

> > but only STB0899_QPSK_XXX is used for such pieces of code. Not
> > possible to =

> > find STB0899_8PSK_XXX depending code. Isn't it necessary? Or such =

> > code
> > is =

> > missing and the casual lock is done by hw automation? =

> =

> One more datapoint: I have one transponder which has only HD Channels =

> on it; the only difference with the other transponders (which are =

> working great using TT 3200) is the FEC (and the fact that it is
> MPEG4, =

> but that changes nothing for getting the lock); symbol rate and =

> modulation are the same. But it does not lock. Here is the dmesg of a =

> simpledvbtune session: one with a success on another transponder, and =

> then a failure on this transponder.
> I'd like to know where to put some printks or tweak the code to be
> able =

> to debug this, if someone with the know-how could explain a bit. I =

> can
> =

> definitely do some coding, but without data it is kind of hard.
> HTH
> Bye

just to precise a bit more: all transponders are DVB-S with QPSK =

modulation (at least this is what is advertised in the dvb tables).
BYe
Manu


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
