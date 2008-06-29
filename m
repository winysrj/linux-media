Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n29.bullet.mail.ukl.yahoo.com ([87.248.110.146])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <eallaud@yahoo.fr>) id 1KClkY-0007Fb-N9
	for linux-dvb@linuxtv.org; Sun, 29 Jun 2008 03:30:45 +0200
Date: Sat, 28 Jun 2008 21:24:26 -0400
From: manu <eallaud@yahoo.fr>
To: linux-dvb@linuxtv.org
In-Reply-To: <200806282223.39447.ajurik@quick.cz> (from ajurik@quick.cz on
	Sat Jun 28 16:23:39 2008)
Message-Id: <1214702666l.6081l.1l@manu-laptop>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Re : Re : Re : How to solve the TT-S2-3200 tuning
 problems?
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

Le 28.06.2008 16:23:39, Ales Jurik a =E9crit=A0:
> On Saturday 28 of June 2008, manu wrote:
> > Le 28.06.2008 08:44:12, manu a =E9crit=A0:
> >
> > just to precise a bit more: all transponders are DVB-S with QPSK
> > modulation (at least this is what is advertised in the dvb tables).
> > BYe
> > Manu
> >
> Hi,
> =

> this is interesting - I don't have problem with DVB-S/QPSK channels
> except for =

> some channels I'm not able to tune directly when changing sat (on
> diseqc =

> switch) - it is necessary to tune first to another transponder and
> then to =

> this problematic one.
> =

> Could you be so kind and specify more channels you have problems =

> with?

Thats the thing: every other transponder works great, that is: 11093, =

11555, 11635, 11675 MHz, 30MBauds, DVB-S, QPSK, FEC 3/4.
The only problematic one: 11495MHz, FEC 5/6 and every other =

characteristics are the same as the working ones. I checked in the dvb =

tables from the transport stream.
Have you got any idea?
Thanks
Manu



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
