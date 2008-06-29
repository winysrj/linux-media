Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n44.bullet.mail.ukl.yahoo.com ([87.248.110.177])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <eallaud@yahoo.fr>) id 1KClMe-0005fs-EC
	for linux-dvb@linuxtv.org; Sun, 29 Jun 2008 03:06:01 +0200
Date: Sat, 28 Jun 2008 21:05:20 -0400
From: manu <eallaud@yahoo.fr>
To: linux-dvb@linuxtv.org
In-Reply-To: <loom.20080628T180915-166@post.gmane.org> (from
	dvenion@hotmail.com on Sat Jun 28 14:15:37 2008)
Message-Id: <1214701520l.6081l.0l@manu-laptop>
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
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Le 28.06.2008 14:15:37, Daniel a =E9crit=A0:
> manu <eallaud <at> yahoo.fr> writes:
> =

> > =

> > One more datapoint: I have one transponder which has only HD
> Channels =

> > on it; the only difference with the other transponders (which are =

> > working great using TT 3200) is the FEC (and the fact that it is
> MPEG4, =

> > but that changes nothing for getting the lock); symbol rate and =

> > modulation are the same. But it does not lock. Here is the dmesg of
> a =

> > simpledvbtune session: one with a success on another transponder,
> and =

> > then a failure on this transponder.
> > I'd like to know where to put some printks or tweak the code to be
> able =

> > to debug this, if someone with the know-how could explain a bit. I
> can =

> > definitely do some coding, but without data it is kind of hard.
> > HTH
> > Bye
> > Manu
> > =

> =

> =

> What FEC is it on the transponder you can't lock? =

> I have one transponder witch is DVB-S with QPSK mod, FEC 7/8 and SR
> 28000 that
> has one mpeg4 channel (Eurosport HD) and I get lock on that one all
> the time,
> could it be becuse there are regular channels on that transponder =

> too?

AFAIK there are only HD channels on this transponder. FEC is 5/6 =

instead of the more common 3/4 for all other transponders. And that's =

the only difference. I do not understand why this could be a problem =

for tuning to the transponder.
And I tried to tune to frequencies between 11485 and 11505 MHz, whereas =

the freq is advertised as 11495MHz. With no luck: not a single lock.
For the other transponders lock is fast and reliabke.
One more thing, the symbol rate is the same across all transponders, =

30MBauds.
Do you have an idea about solving this, or at least how to get useful =

info.
Bye
Manu


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
